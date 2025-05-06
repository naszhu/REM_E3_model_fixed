

 


#### start of everything::
##########
is_finaltest = false


# =============================================================================
# ----------------------------------------------------------------------
"""
Numbers of featuresl; etc
"""
n_simulations = is_finaltest ? 100 : 500;

const n_finalprobs = 420;

const n_units_time = 13#number of steps 
                                                                                                                                                                                                                      
n_units_time_restore = n_units_time #only applies for adding traces now. 
n_units_time_restore_t = n_units_time_restore  # -3
n_units_time_restore_f = n_units_time_restore_t # -3
# n_units_time_restore = n_units_time + 10


const n_probes = 20; # Number of probes to test
const n_lists = 10;
# const n_words = 40;
const n_words = n_probes;
# ----------------------------------------------------------------------
# =============================================================================


# =============================================================================
# ----------------------------------------------------------------------
"""
Geometric parameters
"""

const w_context = 50; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_positioncode = 0
w_allcontext = w_context + w_positioncode
w_word = 25;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 

const g_word = 0.4; #geometric base rate
const g_context = 0.3; #0.3 originallly geometric base rate of context, or 0.2

#!! adv for content? NO
u_star = vcat(0.06, ones(n_lists-1) * 0.06)

u_star_storeintest = u_star #for word # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence

u_star_context=vcat(0.08, ones(n_lists-1)*0.05)
u_adv_firstpos=0.05 #adv of first position in eeach list

const c = 0.75 #coying parameter - 0.8 for context copying 
const c_storeintest = c
const c_context = c
# ----------------------------------------------------------------------
# =============================================================================


# =============================================================================
# ----------------------------------------------------------------------
"""
Ratios of stuff of featuresl; etc
"""


p_poscode_change = 0.1
p_reinstate_context = 0.8 #stop reinstate after how much features

n_driftStudyTest = round.(Int, ones(10) * 9) #7
n_between_listchange = 12; #5;15; 
const p_driftAndListChange = 0.03; # used for both of two n above

p_reinstate_rate = 0.5#0.4 #prob of reinstatement
p_recallFeatureStore = 0.85;

final_gap_change = 0.2; #0.21
p_ListChange_finaltest = ones(10) * 0.55 #0.1 prob list change for final test

ratio_U = 0.5 #ratio of general(unchanging) context
nU = round(Int, w_context * ratio_U)
nC = w_context - nU

ratio_C_final = 0.1 #ratio of changing context used in final
nU_f = nU;#allunchange is used
nC_f = round(Int, nU_f / (1 - ratio_C_final) * ratio_C_final)

#the advatage of foil in inital test (to make final T prediciton overlap)
u_advFoilInitialT = 0;

# ----------------------------------------------------------------------
# =============================================================================


# =============================================================================
# ----------------------------------------------------------------------
"""
Thresholds
"""
context_tau = 100#foil odds should lower than this  
criterion_initial = LinRange(1, 0.25, n_probes);#the bigger the later number, more close hits and CR merges. control merging  

criterion_final = LinRange(0.18, 0.23, 10)
context_tau_final = 100 #0.20.2 above if this is 10
recall_odds_threshold = 100;
# ----------------------------------------------------------------------
# =============================================================================



# =============================================================================
# ----------------------------------------------------------------------
"""
TRUE FALSE
"""

firststg_allctx = false; #cancle this
firststg_allctx2 = false;
is_test_allcontext = false #include general context? not testing all context in intial test
is_test_allcontext2 = true #is testing all context in final testZ
is_test_changecontext2 = false #is testing only change context in final test

is_restore_context = true # HEY! we do need to restore context

is_firststage = true;

is_onlyaddtrace = false; #*add but not strengtening trace
is_onlytest_currentlist = false; #this is discarded currently
 
const is_store_mismatch = true; #if mismatched value is restored during test


is_restore_initial = true
is_UnchangeCtxDriftAndReinstate = true
is_restore_final = true#followed by the next
is_onlyaddtrace_final = false

# ----------------------------------------------------------------------
# =============================================================================



range_breaks_finalt = range(1, stop=420, length=11)  # Create 10 intervals (11 breaks)
Brt = 250#base time of RT
Pi = 30#RT scaling
# const w_context =60; #first half normal context, second half change context, third half word-change context









