

 


#### start of everything:: and Design
##########
is_finaltest = true
n_simulations = is_finaltest ? 300 : 200;
####Type general:
# T; Tn; SO; SOn; F; Fn

#### Type specific:
# :T (B) --         appearnum=1=T; 1=T; 2=none
# :Tn+1 (Dn+1) --   appearnum=1=T; 1=T; 2=Fb
# :Tn (Dn) --       appearnum=2=Fb; 1=T; 2=Fb
# :SO (A) --        appearnum=1=SO; 1=SO; 2=none
# :SOn+1 (Cn+1) --  appearnum=1=SO; 1=SO; 2=Fb
# :SOn (Cn) --      appearnum=2=Fb; 1=SO; 2=Fb
# :F (Fn)  --       appearnum=1=F; 1=F; 2=none
# :Fn+1 (Fnn+1) --  appearnum=1=F; 1=F; 2=Fb
# :Fn (Fnn) --      appearnum=2=Fb; 1=F; 2=Fb

#study: T; SO; Tn+1; SOn+1
#test: T; SO; Tn; SOn

probeTypeDesign_study = Dict(
    Symbol("Tn+1") => 1, 
    :T => 4, 
    :SO => 4, 
    Symbol("SOn+1") => 1)

probeTypeDesign_testProbe_L1 = Dict(
    :T => 4,       # B
    Symbol("Tn+1") => 1, # Dn+1
    
    :F => 4,       # Fn
    Symbol("Fn+1") => 1, # Fnn+1
    
    )
        
#first 2 current new Target, middle 2 current new foil, last 3 Fb bad foil, 
probeTypeDesign_testProbe_Ln = Dict(
    :T => 4,       # B
    Symbol("Tn+1") => 1, # Dn+1

    :F => 1,       # Fn
    Symbol("Fn+1") => 1, # Fnn+1
    
    :Tn => 1,      # Dn
    :Fn => 1,       # Fnn
    :SOn => 1     # Cn
    # :SO => 0,      # A
    # Symbol("SOn+1") => 0, # Cn+1
)

probeTypeDesign_finalTest_L1 = Dict(
    :T => 4,       # B
    :Tn => 1, # Dn+1

    :F => 4,       # Fn
    :Fn => 1, # Fnn+1
    
    :SOn => 1,     # Cn
    :SO => 4,
    
    :FF => 15# A
    # Symbol("SOn+1") => 0, # Cn+1
)

probeTypeDesign_finalTest_Ln  = Dict(
    :T => 4,
    :Tn => 1,
    :SO => 4,
    :SOn => 1,
    :F => 1, #this is diff from Ln
    :Fn => 1,

    :FF => 12,

) 

#[60, 48, 48, 48, 48, 48, 48, 48, 48, 48]
#following stores total number of NEW probes neede in each list
total_probe_L1 = 15;
total_probe_Ln = 12; #remember to *3 for item per unit
# =============================================================================
# -----------------------------------------
"""
Numbers of featuresl; etc
"""


const n_finalprobs = 492; #246*2; (120+120+30*4+9)/3*2*2
const n_inEachChunk = [60, 48];
#final test list 1 60 tests, and the rest list 48 tests

const n_units_time = 13#number of steps 


n_units_time_restore = n_units_time #only applies for adding traces now. 
n_units_time_restore_t = n_units_time_restore  # -3
n_units_time_restore_f = n_units_time_restore_t # -3
# n_units_time_restore = n_units_time + 10


const n_probes = 30; # Number of probes to test
const n_lists = 10;
# const n_words = 40;
const n_words = n_probes;

const n_studyitem = n_words

#modify the below to make it fully dependent on n_probes
nItemPerUnit=round(Int, n_probes/10) #how many units in E3 per type probe   
nItemPerUnit_final=round(Int, n_probes/10 * (2/3)) #how many units in E3 per type probe   
# -----------------------------------------
# =============================================================================


# =============================================================================
# -----------------------------------------
"""
Geometric parameters
"""

#####first half unchange context, second half change context, third half word-change context (third half is not added yet)

w_context = 56; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_positioncode = 0
w_allcontext = w_context + w_positioncode
w_word = 25;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 

const g_word = 0.4; #geometric base rate
const g_context = 0.3; #0.3 originallly geometric base rate of context, or 0.2

#!! adv for content? NO
u_star = vcat(0.039, ones(n_lists-1) * 0.039)

u_star_storeintest = u_star #for word # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence

#: nospecialty for first list right now
#the following show adv for ONLY CHANGE context (second part of context)
# u_star_context=vcat(0.05, ones(n_lists-1)*0.05)#CHANGED
u_adv_firstpos=0.05 #adv of first position in eeach list
u_star_context=vcat(0.05, ones(n_lists-1)*0.05)#CHANGED
# u_adv_firstpos=1 #adv of first position in eeach list

# c = LinRange(0.75, 0.75,n_lists)  #copying parameter - 0.8 for context copying 
# c_storeintest = c
# # c_context_c = LinRange(0.5,0.75, n_lists) #0.75->0.6
# c_context_c = LinRange(0.75,0.75, n_lists) #0.75->0.6
# c_context_un = LinRange(0.75,0.75, n_lists)
nnnow=0.70
c = LinRange(nnnow, nnnow,n_lists)  #copying parameter - 0.8 for context copying 
# println(c," aassssss")
c_storeintest = c
# c_context_c = LinRange(0.5,nnnow, n_lists) #nnnow->0.6
c_context_c = LinRange(nnnow,nnnow, n_lists) #nnnow->0.6
c_context_un = LinRange(nnnow,nnnow, n_lists)
# -----------------------------------------
# =============================================================================


# =============================================================================
# -----------------------------------------
"""
Ratios of stuff of featuresl; etc 
"""
########## Prob DRIFT and so on
LLpower = 1 #power of likelihood for changing context, 

# p_poscode_change = 0.1 #this is no need; deleted feature
p_reinstate_context = 0.8 #stop reinstate after how much features

p_reinstate_rate = 0.4#0.4 #prob of reinstatement
(1-(1-p_reinstate_rate)^1) #each feature reinstate after 1

const p_driftAndListChange = 0.03; # used for both of two n below

n_driftStudyTest = round.(Int, ones(10) * 7) #7
(1-(1-p_driftAndListChange)^n_driftStudyTest[1])

n_between_listchange = round.(Int, LinRange(15, 15, n_lists)); #5;15; #CHANGED, this is used in sim()
(1- (1-p_driftAndListChange)^n_between_listchange[1])


#first half unchange context, second half change context
ratio_U = 0.5 #ratio of general(unchanging) context
nU = round(Int, w_context * ratio_U)
nC = w_context - nU


# p_ratio_unchanging_out_of_total = LinRange(0.17,0.17, n_lists) #0.1 #ratio of unchanging context between lists
#CHANGED
ratio_unchanging_to_itself_init = LinRange(0.4, 0.4, n_lists) # if use no unchanging
ratio_changing_to_itself_init = LinRange(1, 1, n_lists) # if use no unchanging

# Only influence LL calculation below, otherwise, nU and nC used
nU_in = round.(Int, nU .* ratio_unchanging_to_itself_init)
nC_in = round.(Int, nC .* ratio_changing_to_itself_init)

ratio_unchanging_to_itself_final = LinRange(1, 1, n_lists) # if use no unchanging
ratio_changing_to_itself_final = LinRange(0.3,0.3, n_lists) # if use no unchanging

nU_f = round.(Int, nU .* ratio_unchanging_to_itself_final)
nC_f = round.(Int, nC .* ratio_changing_to_itself_final)

p_recallFeatureStore = 1.0;

final_gap_change = 0.1; #0.21
p_ListChange_finaltest = ones(10) * 0.55 #0.1 prob list change for final test


#the advatage of foil in inital test (to make final T prediciton overlap)
u_advFoilInitialT = 0;


p_word_feature_use = LinRange(1, 1, n_lists) #0.5 #ratio of word features used in the first stage
# -----------------------------------------
# =============================================================================


# =============================================================================
# -----------------------------------------
"""
Thresholds
"""
#TODO, apply first stage crition change to final test as well
context_tau = LinRange(1000, 1000, n_lists) ##CHANGED 1000#foil odds should lower than this  

# originally 0.23 works, but now needs to adjust
# criterion_initial = generate_asymptotic_values(1.0, 0.34, 0.20, 1.0, 1.0, 5.0) 
criterion_initial = generate_asymptotic_values(1.0, 0.31, 0.31, 1.0, 1.0, 0.0) 
# criterion_initial = LinRange(0.25, 0.1, n_probes);#the bigger the later number, more close hits and CR merges. control merging  

criterion_final =  LinRange(0.51,0.51, 10)#LinRange(0.18, 0.23, 10)
context_tau_final = 100 #0.20.2 above if this is 10
recall_odds_threshold = 0.3; #this value should be bigger a bit than criterion_initial

# stop increasing at around list t
ilist_switch_stop_at = 5; 
# start_and_rate = [0.28, 0.25]
start_and_end = [0.2, 0.5]


# asymptotic_vals =  generate_asymptotic_increase_fixed_start(start_and_rate[1], start_and_rate[2], ilist_switch_stop_at-1) 
asymptotic_vals =  LinRange(start_and_end[1], start_and_end[2], ilist_switch_stop_at-1)

# p_switch_toListOrgin = vcat(0,asymptotic_vals, asymptotic_vals[end]*ones(n_lists-ilist_switch_stop_at)...)#probabiltiy of switch (or can say, recall LOR) from familarity to recall, from familarity to knowing "List of Origin"
z4_T = 0.25 #prob of switch from familiarity to recall of list origin for target in initial test
z1_SOn = 0.3
z2_Fn = 0.9
z3_Tn = 0.7

# p_new_with_ListOrigin_Tn_Fn = 0.5 #PO+ 
p_new_with_ListOrigin_Fn = 0.32 #good
p_new_with_ListOrigin_SOn = 0.53
p_new_with_ListOrigin_Tn = 0.22 ##good
p_new_with_ListOrigin_T = 0.45 
# Test only F: CR ~=0.55
# Study only SOn: CR ~= 0.47
# Study and test :  CR~= 0.43
# Calculate z * p for each corresponding name
z_times_p = Dict(
    :T => z4_T * p_new_with_ListOrigin_T,
    :Fn => z2_Fn * p_new_with_ListOrigin_Fn,
    :SOn => z1_SOn * p_new_with_ListOrigin_SOn,
    :Tn => z3_Tn * p_new_with_ListOrigin_Tn
)


how_much_z = 0.25
how_much_z_target = 0.11
how_fast_z = 0.4
how_fast_z_target = how_fast_z
how_much_z_f = 0.25
# z_time_p_val should take the same length as n_lists-1, thus ilist-1 when using
z_time_p_val = Dict(
    :T   => asym_increase_shift(0.05, how_much_z_target, how_fast_z_target, n_lists-1),
    Symbol("Tn+1")  => asym_increase_shift(0.01, how_much_z_target, how_fast_z_target, n_lists-1),
    :Fn  => asym_increase_shift(0.30, how_much_z, how_fast_z, n_lists-1),
    :Tn  => asym_increase_shift(0.28, how_much_z, how_fast_z, n_lists-1),
    :SOn => asym_increase_shift(0.18, how_much_z, how_fast_z, n_lists-1),
    Symbol("Fn+1") => asym_increase_shift(0.001, how_much_z_f, how_fast_z, n_lists-1),
    :F  => asym_increase_shift(0.001, how_much_z_f, how_fast_z, n_lists-1)
)
println("z_time_p_val: ", z_time_p_val)
# context_threshold_filter = 0
# p1_old_after_filter = LinRange(1, 1 , 10); #this is when that equals no threshold change 
# p2_old_after_filter = LinRange(0.5, 0.9, 10);
# -----------------------------------------
# =============================================================================



# =============================================================================
# -----------------------------------------
"""
TRUE FALSE
"""

sampling_method = true

#cancle this; this is to combine content and context in frist stage for a test, but figured that it doesn't work at all
firststg_allctx = false; 
firststg_allctx2 = false;

is_test_allcontext = true #!! this should be true if want to apply add unchange into probe (acutaly, likelihood calc)
is_test_allcontext2 = true #is testing all context in final testZ
is_test_changecontext2 = false #is testing only change context in final test

is_restore_context = true # HEY! we do need to restore context
is_strengthen_contextandcontent = true

is_firststage = true;

is_onlyaddtrace = false; #*add but not strengtening trace
is_onlytest_currentlist = false; #this is discarded currently
 
const is_store_mismatch = true; #if mismatched value is restored during test


is_restore_initial = true # flag check 
is_restore_final = true#followed by the next

is_UnchangeCtxDriftAndReinstate = true
is_onlyaddtrace_final = false


# -----------------------------------------
# =============================================================================



range_breaks_finalt = range(1, stop=420, length=11)  # Create 10 intervals (11 breaks)
Brt = 250#base time of RT
Pi = 30#RT scaling
# const w_context =60; #first half normal context, second half change context, third half word-change context

println("prob of each feature change between list $(1-(1-p_driftAndListChange)^n_between_listchange[1])")
println("prob of each feature drift between study and test $(1-(1-p_driftAndListChange)^n_driftStudyTest[1])")
aa = (1 - (1 - p_driftAndListChange)^n_between_listchange[1]);
println("prob of feature change after 4 lists $(1-(1-aa)^8)")
println("prob of each all features had reinstate after 3 $(1-(1-p_reinstate_rate)^3)")

#for easiness of understanding 
p_reinstate_context = (1-(1-p_reinstate_rate)^3);

p_driftStudyTest = (1-(1-p_driftAndListChange)^ Float64(n_driftStudyTest[1]))
# p_driftStudyTest = a
p_ChangeBetweenList = (1-(1-p_driftAndListChange)^n_between_listchange[1])
p_ChangeBetweenList = (1-(1-p_driftAndListChange)^n_between_listchange[end])




