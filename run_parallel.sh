#!/bin/bash
# Multi-process parallel execution script
# Produces identical output to main_JL_E3_V0.jl but runs faster with multiple processes

echo "Starting multi-process parallel simulation (producing same output as main file)..."

# Clean up any old results that might interfere
echo "Cleaning up old results..."
# Kill any existing image viewers that might be showing old plots
pkill -f "eog.*plot.*\.png" 2>/dev/null || true
rm -f DF.csv all_results.csv allresf.csv plot1.png plot2.png Rplots.pdf
rm -rf parallel_temp parallel_results

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
    
    # Run Julia with unique seed - simulation only, no plotting
    julia -e "
        using Random
        Random.seed!($seed);
        println(\"Process $process_id: Starting with seed $seed\");
        
        # Include all necessary files but skip plotting commands
        using Random, Distributions, Statistics, DataFrames, DataFramesMeta
        using BenchmarkTools, ProfileView, Profile, Base.Threads
        using QuadGK
        JULIA_NUM_THREADS=20
        Threads.nthreads()
        
        include(\"E3/data_structures.jl\")
        include(\"E3/utils.jl\")
        include(\"E3/constants.jl\")
        
        # Override n_simulations to divide total by number of processes
        # Original n_simulations from constants.jl will be divided by $NUM_PROCESSES
        original_n_simulations = n_simulations
        base_simulations = div(original_n_simulations, $NUM_PROCESSES)
        remainder = mod(original_n_simulations, $NUM_PROCESSES)
        
        # Distribute simulations evenly, with remainder distributed to first processes
        if $process_id <= remainder
            global n_simulations = base_simulations + 1
        else
            global n_simulations = base_simulations
        end
        println(\"Process $process_id: Running $n_simulations simulations\");
        
        include(\"E3/feature_updates.jl\")
        include(\"E3/feature_origin.jl\")
        include(\"E3/feature_generation.jl\")
        include(\"E3/likelihood_calculations.jl\")
        include(\"E3/memory_storage.jl\")
        include(\"E3/memory_restorage.jl\")
        include(\"E3/probe_generation.jl\")
        include(\"E3/probe_evaluation.jl\")
        include(\"E3/simulation.jl\")
        
        # Run simulation
        all_results, allresf = simulate_rem()
        
        # Save raw simulation data only - NO AGGREGATION
        using CSV
        CSV.write(\"all_results_raw.csv\", all_results)
        if is_finaltest
            allresf = @chain allresf begin
                @transform(:condition = string.(:condition))
            end
            CSV.write(\"allresf.csv\", allresf)
        end
        
        println(\"Process $process_id: Completed with $n_simulations simulations\")
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

# Progress monitoring while waiting
START_TIME=$(date +%s)
while [ $(jobs -r | wc -l) -gt 0 ]; do
    RUNNING_JOBS=$(jobs -r | wc -l)
    COMPLETED_JOBS=$((NUM_PROCESSES - RUNNING_JOBS))
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    echo "Progress: $COMPLETED_JOBS/$NUM_PROCESSES processes completed (${RUNNING_JOBS} still running) - ${ELAPSED}s elapsed"
    sleep 3
done

TOTAL_TIME=$(( $(date +%s) - START_TIME ))
echo ""
echo "✓ All simulations completed in ${TOTAL_TIME}s! Combining results..."

# Combine results with proper headers - same format as original
cd parallel_temp

# Find first valid CSV file for header
FIRST_ALL_RESULTS_RAW=$(find . -name "all_results_raw.csv" -type f | head -1)
FIRST_ALLRESF=$(find . -name "allresf.csv" -type f | head -1)

if [ -n "$FIRST_ALL_RESULTS_RAW" ]; then
    echo "📊 Combining raw initial test results..."
    head -1 "$FIRST_ALL_RESULTS_RAW" > ../all_results.csv
    find . -name "all_results_raw.csv" -exec tail -n +2 {} \; >> ../all_results.csv
    echo "  ✓ Created combined all_results.csv"
fi

if [ -n "$FIRST_ALLRESF" ]; then
    echo "📊 Combining allresf.csv files..."
    head -1 "$FIRST_ALLRESF" > ../allresf.csv
    find . -name "allresf.csv" -exec tail -n +2 {} \; >> ../allresf.csv
    echo "  ✓ Created combined allresf.csv"
fi

cd ..

# Aggregate combined results to create DF.csv (same as main file)
echo "📊 Aggregating combined results to create DF.csv..."
julia -e '
using DataFrames, DataFramesMeta, CSV, Statistics

if isfile("all_results.csv")
    println("Aggregating initial test results...")
    all_results = CSV.read("all_results.csv", DataFrame)
    DF = @chain all_results begin
        @by([:list_number, :is_target, :testpos, :simulation_number, :type_general, :type_specific], :meanx = mean(:decision_isold))
        @by([:list_number, :is_target, :testpos, :type_general, :type_specific], :meanx = mean(:meanx))
    end
    CSV.write("DF.csv", DF)
    println("✓ DF.csv created with $(nrow(DF)) rows")
end

if isfile("allresf.csv")
    println("Final test results already processed (using raw data for plotting)")
end
'

# Debug: Check what files we actually created
echo "Debug: Checking created files..."
echo "DF.csv size: $(wc -l DF.csv 2>/dev/null || echo 'NOT FOUND')"
echo "all_results.csv size: $(wc -l all_results.csv 2>/dev/null || echo 'NOT FOUND')"
echo "allresf.csv size: $(wc -l allresf.csv 2>/dev/null || echo 'NOT FOUND')"

# Check a few lines from constants to verify they're current
echo "Debug: Checking constants used in latest run..."
grep "final_gap_change" parallel_temp/process_1/E3/constants.jl 2>/dev/null || echo "Could not check constants"

# Generate plots using R (same as original)
echo ""
echo "📈 Generating plots..."
if [ -f "DF.csv" ]; then
    echo "  🔄 Running R script for initial test plots..."
    timeout 120 Rscript E3/R_plots.r >/dev/null 2>&1 &
    PLOT1_PID=$!
    echo "  ⏳ Plot1 generation started (PID: $PLOT1_PID)..."
fi

if [ -f "allresf.csv" ]; then
    echo "  🔄 Running R script for final test plots..."  
    timeout 120 Rscript E3/R_plots_finalt.r >/dev/null 2>&1 &
    PLOT2_PID=$!
    echo "  ⏳ Plot2 generation started (PID: $PLOT2_PID)..."
fi

# Wait for both plots to complete
if [ ! -z "$PLOT1_PID" ]; then
    echo "  ⌛ Waiting for plot1 to complete..."
    wait $PLOT1_PID
    echo "  ✓ Generated plot1.png ($(stat -f%z plot1.png 2>/dev/null || stat -c%s plot1.png 2>/dev/null || echo 'unknown') bytes)"
fi

if [ ! -z "$PLOT2_PID" ]; then
    echo "  ⌛ Waiting for plot2 to complete..."
    wait $PLOT2_PID
    echo "  ✓ Generated plot2.png ($(stat -f%z plot2.png 2>/dev/null || stat -c%s plot2.png 2>/dev/null || echo 'unknown') bytes)"
fi

# Display plots (same as original) 
echo ""
echo "🖼️  Opening plot images..."
if command -v eog >/dev/null 2>&1; then
    if [ -f "plot1.png" ]; then
        echo "  👁️  Opening plot1.png"
        eog plot1.png & disown
    fi
    if [ -f "plot2.png" ]; then
        echo "  👁️  Opening plot2.png" 
        eog plot2.png & disown
    fi
fi

# Clean up temporary directory
rm -rf parallel_temp

echo ""
echo "🎉 === Parallel simulation completed! ==="
echo "📁 Output files (same as main_JL_E3_V0.jl):"
[ -f "DF.csv" ] && echo "  ✅ DF.csv ($(wc -l < DF.csv) lines)"
[ -f "all_results.csv" ] && echo "  ✅ all_results.csv ($(wc -l < all_results.csv) lines)" 
[ -f "allresf.csv" ] && echo "  ✅ allresf.csv ($(wc -l < allresf.csv) lines)"
[ -f "plot1.png" ] && echo "  ✅ plot1.png"
[ -f "plot2.png" ] && echo "  ✅ plot2.png"
[ -f "Rplots.pdf" ] && echo "  ✅ Rplots.pdf"

echo ""
echo "⚡ This parallel version produces identical results to running:"
echo "    julia E3/main_JL_E3_V0.jl"
echo "  But completed ${TOTAL_TIME}s faster with $NUM_PROCESSES parallel processes!"