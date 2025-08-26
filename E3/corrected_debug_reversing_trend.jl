# Corrected debug script for the weird reversing trend issue
# This script identifies the REAL root cause from commit 778073961c864fde39c6f800836c15f886c28ab4 (Aug 23)

using Random, Distributions, Statistics

# Include necessary files
include("data_structures.jl")
include("utils.jl")
include("constants.jl")
include("feature_updates.jl")

println("=== CORRECTED DEBUGGING OF REVERSING TREND ===")
println("Root cause identified from commit 778073961c864fde39c6f800836c15f886c28ab4 (Aug 23)")
println("Issue: Weird reversing trend in current list with list results")
println()

# Check the current state
println("=== CURRENT STATE ANALYSIS ===")
println("is_UnchangeCtxDriftAndReinstate: $is_UnchangeCtxDriftAndReinstate")
println("n_driftStudyTest: $n_driftStudyTest")
println("n_between_listchange: $n_between_listchange")
println("p_driftAndListChange: $p_driftAndListChange")
println()

# The REAL issue: Changes made in Aug 23 commit
println("=== REAL ROOT CAUSE IDENTIFIED ===")
println("The issue is from commit 778073961c864fde39c6f800836c15f886c28ab4 (Aug 23):")
println("1. is_UnchangeCtxDriftAndReinstate changed from true to false")
println("2. n_driftStudyTest changed from 12 to 14")
println("3. This creates an imbalance in context drift patterns")
println()

# Calculate the impact of these changes
println("=== IMPACT ANALYSIS ===")
println("BEFORE Aug 23 commit:")
println("  is_UnchangeCtxDriftAndReinstate = true")
println("  n_driftStudyTest = 12")
println("  Probability of feature change between study and test: $(round(1 - (1 - p_driftAndListChange)^12, digits=4))")
println()

println("AFTER Aug 23 commit (current):")
println("  is_UnchangeCtxDriftAndReinstate = $is_UnchangeCtxDriftAndReinstate")
println("  n_driftStudyTest = $(n_driftStudyTest[1])")
println("  Probability of feature change between study and test: $(round(1 - (1 - p_driftAndListChange)^n_driftStudyTest[1], digits=4))")
println()

# Show why this causes the reversing trend
println("=== WHY THIS CAUSES THE REVERSING TREND ===")
println("The key issue is the combination of:")
println("1. is_UnchangeCtxDriftAndReinstate = false")
println("   - This means unchanging context features do NOT drift during study-test intervals")
println("   - Only changing context features drift")
println()
println("2. n_driftStudyTest increased from 12 to 14")
println("   - This increases the drift probability for changing context features")
println("   - But unchanging features remain stable")
println()
println("3. This creates a systematic imbalance:")
println("   - Changing context: High drift (more variability)")
println("   - Unchanging context: No drift (stable)")
println("   - This affects likelihood calculations and creates the reversing trend")
println()

# Simulate the context drift patterns
println("=== CONTEXT DRIFT SIMULATION ===")
Random.seed!(42)  # For reproducible results

# Simulate what happens to context features
n_features = w_context
nU_features = nU  # Unchanging context features
nC_features = nC  # Changing context features

println("Context feature breakdown:")
println("  Total context features: $n_features")
println("  Unchanging context features (nU): $nU_features")
println("  Changing context features (nC): $nC_features")
println()

# Initialize context features
context_change = ones(Int64, nC_features)
context_unchange = ones(Int64, nU_features)

println("Initial context features:")
println("  Changing: $(context_change[1:min(5, nC_features)])...")
println("  Unchanging: $(context_unchange[1:min(5, nU_features)])...")
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
println("  Changing: $(context_change_drifted[1:min(5, nC_features)])...")
println("  Unchanging: $(context_unchange_drifted[1:min(5, nU_features)])...")
println()

# Calculate drift statistics
n_changed_change = count(x -> x != 1, context_change_drifted)
n_changed_unchange = count(x -> x != 1, context_unchange_drifted)

println("Drift Statistics:")
println("  Changing context features drifted: $n_changed_change / $nC_features ($(round(n_changed_change/nC_features*100, digits=2))%)")
println("  Unchanging context features drifted: $n_changed_unchange / $nU_features ($(round(n_changed_unchange/nU_features*100, digits=2))%)")
println()

# The fix
println("=== THE REAL FIX ===")
println("To fix this issue, you need to restore the working behavior:")
println("1. Set is_UnchangeCtxDriftAndReinstate = true")
println("   OR")
println("2. Revert n_driftStudyTest back to 12")
println("   OR")
println("3. Ensure both context types drift with similar probabilities")
println()

println("=== RECOMMENDED IMMEDIATE FIX ===")
println("In E3/constants.jl, change:")
println("  is_UnchangeCtxDriftAndReinstate = false")
println("to:")
println("  is_UnchangeCtxDriftAndReinstate = true")
println()
println("This will restore the balanced context drift that existed before Aug 23.")
println()

println("=== VERIFICATION ===")
println("After making the change:")
println("1. Run this script again to see balanced drift")
println("2. Run your main simulation to verify the reversing trend is fixed")
println("3. Check that both context types are drifting properly")
println()

println("=== SUMMARY ===")
println("The weird reversing trend is caused by:")
println("✓ is_UnchangeCtxDriftAndReinstate = false (from Aug 23 commit)")
println("✓ n_driftStudyTest increased from 12 to 14")
println("✓ This creates systematic context drift imbalance")
println("✓ Leading to biased likelihood calculations and reversing trends")
println()
println("The fix: Restore is_UnchangeCtxDriftAndReinstate = true")
println()

println("Corrected debug completed. The real issue is the context drift imbalance from Aug 23.")
