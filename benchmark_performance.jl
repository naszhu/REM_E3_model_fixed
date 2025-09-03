# Performance benchmarking and profiling script

using BenchmarkTools, Profile, Statistics
using InteractiveUtils

function memory_usage_mb()
    return Base.gc_bytes() / 1024^2
end

function benchmark_simulation()
    println("=== Performance Benchmark ===")
    
    # System info
    println("System Information:")
    println("Julia threads: ", Threads.nthreads())
    println("CPU cores: ", Sys.CPU_THREADS)
    println("Julia version: ", VERSION)
    println()
    
    # Memory before
    GC.gc()  # Force garbage collection
    initial_memory = memory_usage_mb()
    println("Initial memory usage: $(round(initial_memory, digits=2)) MB")
    
    # Run benchmark
    println("Running simulation benchmark...")
    
    # Include files
    include("E3/data_structures.jl")
    include("E3/utils.jl") 
    include("E3/constants.jl")
    include("E3/feature_updates.jl")
    include("E3/feature_generation.jl")
    include("E3/likelihood_calculations.jl")
    include("E3/memory_storage.jl")
    include("E3/memory_restorage.jl")
    include("E3/probe_generation.jl")
    include("E3/probe_evaluation.jl")
    include("E3/simulation.jl")
    
    # Benchmark with reduced simulations
    original_n_simulations = n_simulations
    
    # Override for benchmark (small number for timing)
    global n_simulations = 5
    
    println("Benchmarking with $n_simulations simulations...")
    
    # Time the simulation
    result = @timed simulate_rem()
    
    println("\n=== Results ===")
    println("Time: $(round(result.time, digits=2)) seconds")
    println("Memory allocated: $(round(result.bytes / 1024^3, digits=2)) GB")
    println("Allocations: $(result.gc_stats.malloc) mallocs, $(result.gc_stats.realloc) reallocs")
    println("GC time: $(round(result.gc_stats.total_time, digits=2)) seconds ($(round(result.gc_stats.total_time/result.time * 100, digits=1))%)")
    
    # Memory after
    final_memory = memory_usage_mb()
    println("Final memory usage: $(round(final_memory, digits=2)) MB")
    println("Memory increase: $(round(final_memory - initial_memory, digits=2)) MB")
    
    # Performance per simulation
    time_per_sim = result.time / n_simulations
    memory_per_sim = result.bytes / n_simulations / 1024^3
    
    println("\n=== Per Simulation ===")
    println("Time per simulation: $(round(time_per_sim, digits=2)) seconds")
    println("Memory per simulation: $(round(memory_per_sim, digits=2)) GB")
    
    # Estimate for full run
    println("\n=== Full Run Estimates ($(original_n_simulations) simulations) ===")
    full_time_estimate = time_per_sim * original_n_simulations
    full_memory_estimate = memory_per_sim * original_n_simulations
    
    println("Estimated time: $(round(full_time_estimate/60, digits=1)) minutes")
    println("Estimated memory: $(round(full_memory_estimate, digits=1)) GB")
    
    return result
end

function profile_simulation()
    println("\n=== Profiling Simulation ===")
    
    # Include necessary files
    include("E3/data_structures.jl")
    include("E3/utils.jl")
    include("E3/constants.jl")
    include("E3/feature_updates.jl")
    include("E3/feature_generation.jl")
    include("E3/likelihood_calculations.jl")
    include("E3/memory_storage.jl")
    include("E3/memory_restorage.jl")
    include("E3/probe_generation.jl")
    include("E3/probe_evaluation.jl")
    include("E3/simulation.jl")
    
    # Override for profiling
    global n_simulations = 3
    
    Profile.clear()
    
    println("Running profiled simulation...")
    @profile simulate_rem()
    
    println("Top functions by execution time:")
    Profile.print(mincount=20, maxdepth=8)
    
    # Save profile to file
    open("profile_results.txt", "w") do io
        Profile.print(io, mincount=10)
    end
    
    println("\nProfile saved to profile_results.txt")
end

# Run if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    benchmark_simulation()
    println("\n" * "="^50 * "\n")
    profile_simulation()
end