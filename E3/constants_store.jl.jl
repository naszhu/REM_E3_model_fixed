

w_context = 56; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_word = 23;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 
nU = 28#w_context/2 
nC = 28#w_context/2

ku_base = 0.25 # study，higher this value, lower the starting point of T
ks_base = 0.4 #SOn (study only), lower the value, higher the starting point CF
kb_base = 0.2 #Tn (study and test)
kt_base = 0.2 #Fn (test only)

hj_base = 0.35; #higher this value higher CF starting point
hj_formula_r_rate = 0.9  # R parameter controlling asymptotic approach to 1 (0 < R < 1)

# h_j = asym_increase_formula_hj(hj_base, hj_formula_r_rate, n_lists - 1)

const g_word = 0.3; #geometric base rate
const g_context = 0.3; #0.3 originallly geometric base rate of context, or 0.2

u_star_v = 0.4 #1-(1-0.04)^13  # ≈ 0.415 - equivalent single-step probability

u_star_context= 0.4#
# u_adv_firstpos=1 #adv of first position in eeach list
c=0.7 #lower this value, the differences between T and F bigger at beggining, smaller later (is this true?, i think so)

p_reinstate_rate = 0.15#0.4 #prob of reinstatement

const p_driftStudyTest = 0.15; # Equivalent to (1-(1-0.03)^12) for study-test drift
const p_driftBetweenList = 0.456; # Equivalent to (1-(1-0.03)^20) for between-list change


base_distortion_prob_UC =base_distortion_prob_CC = 0.1  # Distortion probability for UC context features

ratio_unchanging_to_itself_init = 0.46#LinRange(0.46, 0.46, n_lists) # if use no unchanging
ratio_changing_to_itself_init = 1#LinRange(1, 1, n_lists) # if use no unchanging

ratio_unchanging_to_itself_final = 1#LinRange(1, 1, n_lists) # if use no unchanging
ratio_changing_to_itself_final = 0.15#LinRange(0.15,0.15, n_lists) # if use no unchanging


# iprobe_chunk_boundaries = [i for i in 42:42:600] # just make this a huge chunk the exceeded number doesn't matter

context_tau = 100# used for both initial and final test, LinRange(100, 100, n_lists) ##CHANGED 1000#foil odds should lower than this  
# context_tau_final = 100 #0.20.2 above if this is 10

criterion_initial = 0.16#generate_asymptotic_values(1.0,ci, ci, 1.0, 1.0, 3.0) 
# criterion_initial = LinRange(0.25, 0.1, n_probes);#the bigger the later number, more close hits and CR merges. control merging  

recall_odds_threshold = 0.3

criterion_final_start=0.11#(0.09+x-0.010)^power_taken; #0.11
criterion_final_step_size  = -0.0055

final_gap_change = 0.16; #0.21
p_ListChange_finaltest =  0.013 #make this a const value rather than a vector

ratio_unchanging_to_itself_final = LinRange(1, 1, n_lists) # if use no unchanging
ratio_changing_to_itself_final = LinRange(0.3,0.3, n_lists) # if use no unchanging


