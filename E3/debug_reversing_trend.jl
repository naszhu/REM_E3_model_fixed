# Debug script for investigating the weird reversing trend issue
# Created to analyze the impact of commit 778073961c864fde39c6f800836c15f886c28ab4

using Random, Distributions, Statistics

# Include necessary files
include("data_structures.jl")
include("utils.jl")
include("constants.jl")
include("feature_updates.jl")

println("=== DEBUGGING REVERSING TREND ISSUE ===")
println("Commit: 778073961c864fde39c6f800836c15f886c28ab4")
println("Issue: Weird reversing trend in current list with list results")
println()

# Check critical parameters
println("=== CRITICAL PARAMETERS ===")
println("is_UnchangeCtxDriftAndReinstate: $is_UnchangeCtxDriftAndReinstate")
println("is_content_drift_between_study_and_test: $is_content_drift_between_study_and_test")
println("p_driftAndListChange: $p_driftAndListChange")
println("n_driftStudyTest: $n_driftStudyTest")
println("n_between_listchange: $n_between_listchange")
println()

# Calculate drift probabilities
println("=== DRIFT PROBABILITIES ===")
p_driftStudyTest_calc = 1 - (1 - p_driftAndListChange)^n_driftStudyTest[1]
p_betweenList_calc = 1 - (1 - p_driftAndListChange)^n_between_listchange[1]
println("Probability of feature change between study and test: $p_driftStudyTest_calc")
println("Probability of feature change between lists: $p_betweenList_calc")
println()

# Simulate context drift patterns
println("=== CONTEXT DRIFT SIMULATION ===")
Random.seed!(42)  # For reproducible results

# Simulate what happens to context features
n_features = w_context
n_simulations_drift = 1000

# Initialize context features
context_change = ones(Int64, n_features)
context_unchange = ones(Int64, n_features)

println("Initial context features:")
println("  Changing: $(context_change[1:min(10, n_features)])...")
println("  Unchanging: $(context_unchange[1:min(10, n_features)])...")
println()

# Simulate drift between study and test
println("Simulating drift between study and test...")
context_change_drifted = copy(context_change)
context_unchange_drifted = copy(context_unchange)

for _ in 1:n_driftStudyTest[1]
    # Apply drift to changing context (this always happens)
    drift_ctx_betweenStudyAndTest!(context_change_drifted, p_driftAndListChange, Geometric(g_context))
    
    # Apply drift to unchanging context ONLY if flag is true
    if is_UnchangeCtxDriftAndReinstate
        drift_ctx_betweenStudyAndTest!(context_unchange_drifted, p_driftAndListChange, Geometric(g_context))
    end
end

println("After study-test drift:")
println("  Changing: $(context_change_drifted[1:min(10, n_features)])...")
println("  Unchanging: $(context_unchange_drifted[1:min(10, n_features)])...")
println()

# Calculate drift statistics
n_changed_change = count(x -> x != 1, context_change_drifted)
n_changed_unchange = count(x -> x != 1, context_unchange_drifted)

println("Drift Statistics:")
println("  Changing context features drifted: $n_changed_change / $n_features ($(round(n_changed_change/n_features*100, digits=2))%)")
println("  Unchanging context features drifted: $n_changed_unchange / $n_features ($(round(n_changed_unchange/n_features*100, digits=2))%)")
println()

# Analyze the impact on likelihood calculations
println("=== LIKELIHOOD IMPACT ANALYSIS ===")
println("The issue likely stems from:")
println("1. Context imbalance: Only changing features drift, creating systematic differences")
println("2. Test position effects: Drift accumulates differently across test positions")
println("3. Memory retrieval bias: The imbalance affects similarity calculations")
println()

# Check if this matches the reported issue
println("=== ISSUE VERIFICATION ===")
if !is_UnchangeCtxDriftAndReinstate
    println("✓ CONFIRMED: is_UnchangeCtxDriftAndReinstate = false")
    println("  This means unchanging context features are NOT drifting during study-test intervals")
    println("  Only changing context features are drifting")
    println("  This creates the imbalance causing the weird reversing trend")
else
    println("✗ UNEXPECTED: is_UnchangeCtxDriftAndReinstate = true")
    println("  This should not cause the reported issue")
end

println()
println("=== RECOMMENDED FIXES ===")
println("1. Set is_UnchangeCtxDriftAndReinstate = true to restore balance")
println("2. OR ensure both context types drift with similar probabilities")
println("3. Check if the drift parameters need adjustment")
println("4. Verify that the OT feature implementation is working correctly")
println()

# Additional diagnostic: Check κ parameters
println("=== OT FEATURE PARAMETERS ===")
println("use_ot_feature: $use_ot_feature")
if use_ot_feature
    println("κs (incorrect test info): $κs")
    println("κb (add trace + strengthen): $κb")
    println("κt (add trace only): $κt")
    println("tested_before_feature_pos: $tested_before_feature_pos")
end
println()

println("=== NEXT STEPS ===")
println("1. Run this script to see the current drift patterns")
println("2. Compare with the working version from before commit 778073961c864fde39c6f800836c15f886c28ab4")
println("3. Check if setting is_UnchangeCtxDriftAndReinstate = true fixes the issue")
println("4. Analyze the specific test positions where the reversing trend occurs")
println()

println("Debug script completed. Check the output above for insights into the reversing trend issue.")
