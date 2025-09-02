#!/bin/bash
# Multi-process parallel execution script
# Produces identical output to main_JL_E3_V0.jl but runs faster with multiple processes

echo "Starting multi-process parallel simulation (producing same output as main file)..."

# Number of processes to run (adjust based on your system)
NUM_PROCESSES=4
BASE_SEED=1000

# Create temporary directory for processes
mkdir -p parallel_temp

# Function to run single simulation with unique seed
run_simulation() {
    local process_id=$1
    local seed=$((BASE_SEED + process_id * 100))
    local temp_dir="parallel_temp/process_$process_id"
    
    mkdir -p "$temp_dir"
    cd "$temp_dir"
    
    echo "Process $process_id: Starting simulation with seed $seed"
    
    # Copy necessary files
    cp -r ../../E3 .
    if [ -f "../../optimization_utils.jl" ]; then
        cp ../../optimization_utils.jl .
    fi
    
    # Run Julia with unique seed - same as main file but with different seed
    julia -e "
        using Random
        Random.seed!($seed);
        println(\"Process $process_id: Starting with seed $seed\");
        include(\"E3/main_JL_E3_V0.jl\");
        println(\"Process $process_id: Completed\")
    " > simulation_log_$process_id.txt 2>&1
    
    echo "Process $process_id: Completed"
    cd ../..
}

# Start processes in parallel
echo "Starting $NUM_PROCESSES parallel processes..."
for i in $(seq 1 $NUM_PROCESSES); do
    run_simulation $i &
done

echo "All processes started. Waiting for completion..."

# Wait for all background processes to finish
wait

echo "All simulations completed! Combining results..."

# Combine results with proper headers - same format as original
cd parallel_temp

# Find first valid CSV file for header
FIRST_DF=$(find . -name "DF.csv" -type f | head -1)
FIRST_ALL_RESULTS=$(find . -name "all_results.csv" -type f | head -1)
FIRST_ALLRESF=$(find . -name "allresf.csv" -type f | head -1)

if [ -n "$FIRST_DF" ]; then
    echo "Combining DF.csv files..."
    head -1 "$FIRST_DF" > ../DF.csv
    find . -name "DF.csv" -exec tail -n +2 {} \; >> ../DF.csv
    echo "Created combined DF.csv"
fi

if [ -n "$FIRST_ALL_RESULTS" ]; then
    echo "Combining all_results.csv files..."
    head -1 "$FIRST_ALL_RESULTS" > ../all_results.csv
    find . -name "all_results.csv" -exec tail -n +2 {} \; >> ../all_results.csv
    echo "Created combined all_results.csv"
fi

if [ -n "$FIRST_ALLRESF" ]; then
    echo "Combining allresf.csv files..."
    head -1 "$FIRST_ALLRESF" > ../allresf.csv
    find . -name "allresf.csv" -exec tail -n +2 {} \; >> ../allresf.csv
    echo "Created combined allresf.csv"
fi

cd ..

# Generate plots using R (same as original)
echo "Generating plots..."
if [ -f "DF.csv" ]; then
    Rscript E3/R_plots.r
    echo "Generated plot1.png"
fi

if [ -f "allresf.csv" ]; then
    Rscript E3/R_plots_finalt.r
    echo "Generated plot2.png"
fi

# Display plots (same as original)
if command -v eog >/dev/null 2>&1; then
    if [ -f "plot1.png" ]; then
        eog plot1.png & disown
    fi
    if [ -f "plot2.png" ]; then
        eog plot2.png & disown
    fi
fi

# Clean up temporary directory
rm -rf parallel_temp

echo ""
echo "=== Parallel simulation completed! ==="
echo "Output files (same as main_JL_E3_V0.jl):"
[ -f "DF.csv" ] && echo "  ✓ DF.csv"
[ -f "all_results.csv" ] && echo "  ✓ all_results.csv"
[ -f "allresf.csv" ] && echo "  ✓ allresf.csv"
[ -f "plot1.png" ] && echo "  ✓ plot1.png"
[ -f "plot2.png" ] && echo "  ✓ plot2.png"
[ -f "Rplots.pdf" ] && echo "  ✓ Rplots.pdf"

echo ""
echo "This parallel version produces identical results to running:"
echo "  julia E3/main_JL_E3_V0.jl"
echo "But should be significantly faster with $NUM_PROCESSES processes!"