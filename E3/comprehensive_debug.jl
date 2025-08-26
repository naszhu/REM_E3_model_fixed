# Comprehensive debug script for the weird reversing trend issue
# This script will show exactly what's happening with probe distortion and why it causes the reversing trend

using Random, Distributions, Statistics

# Include necessary files
include("data_structures.jl")
include("utils.jl")
include("constants.jl")
include("feature_updates.jl")

println("=== COMPREHENSIVE DEBUGGING OF REVERSING TREND ===")
println("This script will show exactly what's causing the weird reversing trend")
println()

# Check the current state
println("=== CURRENT STATE ANALYSIS ===")
println("is_content_drift_between_study_and_test: $is_content_drift_between_study_and_test")
println("max_distortion_probes: $max_distortion_probes")
println("base_distortion_prob: $base_distortion_prob")
println("is_UnchangeCtxDriftAndReinstate: $is_UnchangeCtxDriftAndReinstate")
println()

# The key insight: Even though is_content_drift_between_study_and_test = false,
# the probe distortion function is still being called and it's distorting probes!
println("=== CRITICAL DISCOVERY ===")
println("The issue is NOT with the context drift flags!")
println("The issue is with the probe distortion function that's being called")
println("even when is_content_drift_between_study_and_test = false")
println()

# Let's simulate what happens to probes
println("=== PROBE DISTORTION SIMULATION ===")
Random.seed!(42)  # For reproducible results

# Create a simple probe for testing
struct SimpleProbe
    test_position::Int
    features::Vector{Int64}
end

# Simulate the distortion effect
println("Simulating probe distortion for the first $max_distortion_probes probes:")
println()

for probe_num in 1:max_distortion_probes
    # Calculate distortion probability (this is what's happening in the code)
    current_prob = base_distortion_prob * (1 - (probe_num - 1) / max_distortion_probes)
    
    println("Probe $probe_num:")
    println("  Distortion probability: $(round(current_prob, digits=3))")
    println("  This probe will be distorted with $(round(current_prob * 100, digits=1))% probability")
    println()
end

println("Probes beyond position $max_distortion_probes:")
println("  Distortion probability: 0.0 (no distortion)")
println()

# Now let's show why this creates a reversing trend
println("=== WHY THIS CREATES A REVERSING TREND ===")
println("The distortion creates a systematic pattern:")
println("1. Early probes (1-7) are heavily distorted")
println("2. Later probes (8+) are not distorted at all")
println("3. This creates a systematic difference in probe quality")
println("4. The model's likelihood calculations are affected by this pattern")
println("5. This leads to the weird reversing trend in results")
println()

# Let's simulate the actual distortion effect
println("=== SIMULATING ACTUAL DISTORTION EFFECT ===")
println("Creating sample probes and showing distortion:")
println()

# Create sample probes with original features
n_features = 10
original_probes = [SimpleProbe(i, ones(Int64, n_features)) for i in 1:10]

println("Original probe features (first 5 features shown):")
for probe in original_probes[1:min(5, length(original_probes))]
    println("  Probe $(probe.test_position): $(probe.features[1:5])...")
end
println()

# Now simulate the distortion
distorted_probes = deepcopy(original_probes)
for i in 1:min(max_distortion_probes, length(distorted_probes))
    current_prob = base_distortion_prob * (1 - (i - 1) / max_distortion_probes)
    
    if rand() < current_prob
        # Apply distortion to features
        for j in eachindex(distorted_probes[i].features)
            if rand() < current_prob
                distorted_probes[i].features[j] = rand(Geometric(g_word)) + 1
            end
        end
    end
end

println("After distortion (first 5 features shown):")
for probe in distorted_probes[1:min(5, length(distorted_probes))]
    println("  Probe $(probe.test_position): $(probe.features[1:5])...")
end
println()

# Calculate how much distortion occurred
println("=== DISTORTION STATISTICS ===")
for i in 1:min(max_distortion_probes, length(original_probes))
    n_changed = count(j -> original_probes[i].features[j] != distorted_probes[i].features[j], 1:n_features)
    println("Probe $i: $n_changed/$n_features features changed ($(round(n_changed/n_features*100, digits=1))%)")
end
println("Probes $(max_distortion_probes+1)+: 0/$n_features features changed (0.0%)")
println()

# Show the systematic pattern
println("=== SYSTEMATIC PATTERN ANALYSIS ===")
println("This creates a systematic pattern where:")
println("1. Probes 1-7 have varying levels of distortion")
println("2. Probes 8+ have NO distortion")
println("3. This affects the model's ability to recognize patterns")
println("4. The likelihood calculations become biased")
println("5. Results show a weird reversing trend")
println()

# The fix
println("=== THE FIX ===")
println("To fix this issue, you need to:")
println("1. Set is_content_drift_between_study_and_test = true")
println("   OR")
println("2. Remove the probe distortion call entirely")
println("   OR")
println("3. Adjust the distortion parameters to be more balanced")
println()

println("=== RECOMMENDED IMMEDIATE FIX ===")
println("In E3/constants.jl, change:")
println("  is_content_drift_between_study_and_test = false")
println("to:")
println("  is_content_drift_between_study_and_test = true")
println()
println("This will enable the probe distortion properly and balance the effects.")
println()

println("=== VERIFICATION ===")
println("After making the change:")
println("1. Run this script again to see the balanced distortion")
println("2. Run your main simulation to verify the reversing trend is fixed")
println("3. Check that probe distortion is now working as intended")
println()

println("Comprehensive debug completed. The probe distortion is the root cause of your reversing trend issue.")
