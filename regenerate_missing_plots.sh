#!/bin/bash
# Script to regenerate missing plots for previous commits

# Save current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CURRENT_COMMIT=$(git rev-parse HEAD)

echo "🔍 Checking for missing plots in plot_archive..."

# Get recent commits (last 20 commits to avoid going too far back)
COMMITS=$(git log --oneline -n 20 --format="%h")

# Function to generate plots for a specific commit
generate_plots_for_commit() {
    local commit=$1
    local commit_timestamp=$(git log -1 --format=%cd --date=format:'%Y%m%d_%H%M%S' $commit)
    local plot1_file="plot_archive/${commit}_${commit_timestamp}_plot1.png"
    local plot2_file="plot_archive/${commit}_${commit_timestamp}_plot2.png"
    
    # Check if plots already exist
    if [[ -f "$plot1_file" && -f "$plot2_file" ]]; then
        echo "✅ $commit: Plots already exist, skipping"
        return 0
    fi
    
    echo "🔄 $commit: Generating missing plots..."
    
    # Checkout the commit
    git checkout $commit --quiet
    
    # Check if we can run simulation at this commit
    if [[ ! -f "E3/main_JL_E3_V0.jl" ]]; then
        echo "❌ $commit: No main simulation file found, skipping"
        return 1
    fi
    
    # Try to run the simulation (with timeout to avoid hanging)
    timeout 300 julia E3/main_JL_E3_V0.jl > /tmp/sim_output_$commit.log 2>&1
    
    if [[ $? -eq 0 ]]; then
        # Check if plots were generated
        if [[ -f "plot1.png" && -f "plot2.png" ]]; then
            # Copy to archive with proper naming
            cp plot1.png "$plot1_file"
            cp plot2.png "$plot2_file"
            echo "✅ $commit: Successfully generated and archived plots"
            
            # Clean up temporary plots
            rm -f plot1.png plot2.png Rplots.pdf
        else
            echo "❌ $commit: Simulation ran but no plots generated"
        fi
    else
        echo "❌ $commit: Simulation failed or timed out"
    fi
    
    # Clean up log
    rm -f /tmp/sim_output_$commit.log
}

# Process each commit
for commit in $COMMITS; do
    generate_plots_for_commit $commit
done

# Return to original branch/commit
echo "🔄 Returning to original state..."
git checkout $CURRENT_BRANCH --quiet

echo "✅ Finished regenerating missing plots!"
echo "📁 Check plot_archive/ directory for new plots"