# Constants Comparison Report: E1 vs E3

**Comparison between:**
- E1: `/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/modeling/module_jl/constants.jl`
- E3: `/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/E3/constants.jl`

---

## 1. TRUE/FALSE Values That Don't Match

| Constant | E1 (design1) | E3 (design3) | E1 Location | E3 Location |
|----------|--------------|--------------|-------------|-------------|
| `is_finaltest` | `false` | `false` | :3 | :8 |
| `is_test_allcontext` | `false` | `true` | :91 | :433 |
| `is_distort_probes` | `true` | `false` | :98 | :452 |
| `is_UnchangeCtxDriftAndReinstate` | `false` | `false` | :97 | :451 |
| `is_content_drift_between_study_and_test` | `true` | N/A | :103 | N/A |
| `is_content_distort_between_study_and_test` | N/A | `false` | N/A | :265 |
| `is_UC_distort_between_study_and_test` | N/A | `true` | N/A | :266 |
| `is_CC_distort_between_study_and_test` | N/A | `true` | N/A | :267 |
| `is_reconstruct_finaltest_backward` | `false` | N/A | :214 | N/A |

**Notes:**
- `is_finaltest` now matches in both (both are `false`)
- E1 has `is_content_drift_between_study_and_test` while E3 has `is_content_distort_between_study_and_test` (similar but different variable names)
- E3 has separate flags for UC and CC distortion that don't exist in E1

---

## 2. Values Where One is Zero But the Other is Not

| Constant | E1 (design1) | E3 (design3) | E1 Location | E3 Location |
|----------|--------------|--------------|-------------|-------------|
| `p_reinstate_rate` | `0.3` | `0.15` | :176 | :244 |
| `base_distortion_prob` | `0.12` | `0.0` | :177 | :270 |
| `base_distortion_prob_UC` | N/A | `0.2` | N/A | :271 |
| `base_distortion_prob_CC` | N/A | `0.2` | N/A | :272 |
| `fj_asymptote_decrease_val` | N/A (from old version: `0.01`) | `0.00` | N/A | :162 |

**Notes:**
- `p_reinstate_rate` is non-zero in both, but different values (E1: 0.3, E3: 0.15)
- E1 has content distortion enabled with `base_distortion_prob=0.12`, E3 has it at `0.0`
- E3 has separate UC and CC distortion probabilities (both 0.2) that don't exist as separate parameters in E1

---

## 3. All Other Different Numeric Values

| Constant | E1 (design1) | E3 (design3) | E1 Location | E3 Location |
|----------|--------------|--------------|-------------|-------------|
| `n_simulations` | `200:1000` (conditional) | `300:800` (conditional) | :4 | :9 |
| `n_probes` | `20` | `30` | :14 | :108 |
| `nnnow` | `0.77` | `0.7` | :70 | :219 |
| `ku_base` | `0.1` (old) | `0.25` | :292 | :157 |
| `ks_base` | `0.47` (old) | `0.2` | :293 | :158 |
| `kb_base` | `0.55` (old) | `0.01` | :294 | :159 |
| `kt_base` | `0.65` (old) | `0.01` | :295 | :160 |
| `hj_asymptote_increase_val` | `0.6` (old) | `0.23` | :302 | :167 |
| `hj_rate` | `0.8` (old) | `0.85` | :303 | :168 |
| `hj_base` | `0.3` (old) | `0.35` | :304 | :169 |
| `p_driftStudyTest` | `base_distortion_prob` (0.12) | `0.15` | :191 | :249 |
| `max_distortion_probes` | `10` | `30` | :180 | :261 |
| `n_finalprobs` | `420` | `492` | :209 | :95 |
| `p_recallFeatureStore` | `0.85` | `1.0` | :125 | :297 |
| `recall_odds_threshold` | `0.08^power_taken` | `0.3^power_taken` | :123 | :333 |
| `final_gap_change` | `0.1` | `0.18` | :230 | :348 |
| `p_ListChange_finaltest` | `ones(10)*0.013` (vector) | `0.013` (scalar) | :232 | :349 |
| `context_tau` | `100` (scalar, old) | `LinRange(100,100,n_lists)` (vector) | :164 | :319 |
| `criterion_initial` | `generate_asymptotic_values(1.0, 1.0, 1.0, 0.35, 0.75, 5.0)` | `generate_asymptotic_values(1.0, ci, ci, 1.0, 1.0, 3.0)` where `ci=0.16^power_taken` | :121 | :327 |
| `criterion_final` | `LinRange((0.09+0.18)^power_taken, 0.27+0.07^power_taken, 10)` | `LinRange(cfinal_start, cfinal_end, n_lists)` where `cfinal_start=(0.08+x-0.00)^power_taken`, `cfinal_end=(0.08+x+0.05)^power_taken`, `x=0.13-0.1` | :226 | :344 |
| `ratio_unchanging_to_itself_init` | `LinRange(1, 0.46, n_lists)` | `LinRange(0.46, 0.46, n_lists)` | :200 | :284 |
| `ratio_changing_to_itself_final` | `LinRange(0.15, 0.15, n_lists)` | `LinRange(0.3, 0.3, n_lists)` | :234 | :352 |

**Notes:**
- E1 now uses `base_distortion_prob` as the value for `p_driftStudyTest`
- Criterion calculations differ significantly between E1 and E3
- E1's `ratio_unchanging_to_itself_init` changes from 1 to 0.46 over lists, while E3 keeps it constant at 0.46

---

## 4. Values That Exist in One But Not the Other

### 4.1 Only in E1 (design1)

| Constant | Value | Location | Notes |
|----------|-------|----------|-------|
| `n_grade` | `2` | :42 | Only first to be special |
| `adv_u_star_strengthen` | `0.00` | :50 | No adv during strengthening |
| `adv_c_strenghten` | `0.0` | :51 | |
| `init_pos1_ustar_ctx_adv` | `0.00` | :61 | Initial position context advantage |
| `chunk_size_final_change` | `42` | :210 | |
| `is_reconstruct_finaltest_forward` | `true` | :213 | Enable CC reconstruction for forward |
| `is_reconstruct_finaltest_backward` | `false` | :214 | Disable CC reconstruction for backward |
| `p_reinstate_rate_finaltest` | `0.3` | :216 | Probability of reinstating CC features in final test |
| `range_breaks_finalt` | `range(1, stop=420, length=11)` | :218 | Create 10 intervals |
| `total_probe_L1` | `15` | :221 | Total probes in list 1 |
| `total_probe_Ln` | `12` | :222 | Total probes in other lists |
| `nItemPerUnit_final` | `2` | :223 | Items per unit in final test |
| `c_context_c` | `fill(c, n_lists)` | :76 (old) | Copying parameter for changing context |
| `c_context_un` | `fill(c, n_lists)` | :77 (old) | Copying parameter for unchanging context |
| `nU_in` | `round.(Int, nU .* ratio_unchanging_to_itself_init)[1]` | :203 | |
| `nC_in` | `round.(Int, nC .* ratio_changing_to_itself_init)[1]` | :204 | |
| `nU_f` | `round.(Int, nU .* ratio_unchanging_to_itself_final)` | :248 (old) | |
| `nC_f` | `round.(Int, nC .* ratio_changing_to_itself_final)` | :249 (old) | |
| `n_z_features` | `1` | :281 (old) | Number of Z features to add |
| `u_star_adv` | `0.0` | :54 (old) | |
| `c_adv` | `0.0` | :55 (old) | |
| `is_content_drift_between_study_and_test` | `true` | :103 | Enable content distortion from E3 |

### 4.2 Only in E3 (design3)

| Constant | Value | Location | Notes |
|----------|-------|----------|-------|
| `n_studyitem` | `n_words` | :113 | |
| `n_ot_features` | `1` | :136 | Number of OT features |
| `tested_before_feature_pos` | `w_word + n_ot_features` | :137 | Position of OT feature (25) |
| `u_adv_firstpos` | `0.00` | :210 | Advantage of first position in each list |
| `use_Z_decision_approximation` | `true` | :422 | |
| `use_sampled_item_for_decision` | `false` | :427 | |
| `nItemPerUnit` | `round(Int, n_probes/10)` | :116 | How many units in E3 per type probe |
| `nItemPerUnit_final` | `round(Int, n_probes/10 * (2/3))` | :117 | |
| `iprobe_chunk_boundaries` | `[i for i in 42:42:600]` | :307 | |
| `p_word_feature_use` | `LinRange(1, 1, n_lists)` | :305 | Ratio of word features used in first stage |
| `probeTypeDesign_study` | Dict with Tn+1, T, SO, SOn+1 | :27-31 | Study probe design |
| `probeTypeDesign_testProbe_L1` | Dict with T, Tn+1, F, Fn+1 | :33-40 | Test probe design for List 1 |
| `probeTypeDesign_testProbe_Ln` | Dict with T, Tn+1, F, Fn+1, Tn, Fn, SOn | :43-56 | Test probe design for List n |
| `probeTypeDesign_finalTest_L1` | Dict with various probe types | :58-70 | Final test design for List 1 |
| `probeTypeDesign_finalTest_Ln` | Dict with various probe types | :72-82 | Final test design for List n |
| `total_probe_L1` | `15` | :86 | Total probes in list 1 |
| `total_probe_Ln` | `12` | :87 | Total probes in other lists |
| `n_inEachChunk` | `[60, 48]` | :96 | Final test chunks |
| `hj_initial_increment` | `0.1` | :171 | Initial increment for linear diminishing |
| `hj_decrement_per_step` | `0.029` | :172 | Amount increment decreases each step |
| `Brt` | `250` | :469 | Base time of RT |
| `Pi` | `30` | :470 | RT scaling |
| `u_star_adv` | `0` | :203 | |
| `c_adv` | `0` | :220 | |
| `base_distortion_prob_UC` | `0.2` | :271 | Distortion probability for UC |
| `base_distortion_prob_CC` | `0.2` | :272 | Distortion probability for CC |
| `is_content_distort_between_study_and_test` | `false` | :265 | |
| `is_UC_distort_between_study_and_test` | `true` | :266 | |
| `is_CC_distort_between_study_and_test` | `true` | :267 | |
| `cfinal_rate` | `0.27` | :341 | Rate for criterion final |

---

## 5. Additional Notes and Type Differences

### Variable Name Differences
- E1 has `is_content_drift_between_study_and_test` while E3 has `is_content_distort_between_study_and_test` (drift vs distort)
- E1 uses `n_z_features` while E3 uses `n_ot_features` for similar purposes

### Type Differences
- `p_ListChange_finaltest`: E1 uses a vector (`ones(10) * 0.013`), E3 uses a scalar (`0.013`)
- `context_tau`: E1 uses a scalar (`100`), E3 uses a vector (`LinRange(100, 100, n_lists)`)

### Calculation Differences
- `tested_before_feature_pos`: E1 calculates as `w_word + n_z_features`, E3 as `w_word + n_ot_features`
- `h_j`: E1 uses `asym_increase_shift_hj()` (old version), E3 uses `asym_increase_diminishing_hj()`
- Criterion calculations differ significantly in their parameters

### Shared Variables with Same Values
Both files share these common values:
- `w_context = 56`
- `w_word = 23`
- `w_positioncode = 0`
- `n_lists = 10`
- `n_units_time = 1`
- `ratio_U = 0.5`
- `g_word = 0.3`
- `g_context = 0.3`
- `u_star_v = 0.4`
- `p_driftBetweenList = 0.456`
- `n_driftStudyTest = 1`
- `n_between_listchange = 1`
- `κ_update_between_list = 0.0`
- `LLpower = 1`
- `p_reinstate_context = 1.0`
- `is_store_mismatch = true`
- `is_restore_initial = true`
- `is_restore_final = true`
- `is_firststage = true`
- `is_onlyaddtrace = false`
- `recall_to_addtrace_threshold = Inf`
- `context_tau_final = 100`

---

## Summary of Major Differences

1. **Distortion Strategy**: E1 enables content distortion (`base_distortion_prob=0.12`), while E3 disables content distortion but enables UC and CC context distortion (`base_distortion_prob_UC=0.2`, `base_distortion_prob_CC=0.2`)

2. **Reinstatement**: E1 has higher reinstatement rate (0.3) compared to E3 (0.15)

3. **Probe Count**: E3 uses 30 probes vs E1's 20 probes

4. **Probe Design**: E3 has detailed probe type design dictionaries that E1 lacks

5. **Criterion Calculations**: Different asymptotic value generation with different parameters

6. **Context Ratios**: E1's `ratio_unchanging_to_itself_init` decreases over lists (1→0.46), while E3 keeps it constant at 0.46

7. **Kappa Values**: Significantly different base values for κu, κs, κb, κt between the two designs

8. **Final Test**: Different approaches to criterion_final calculation and context ratio handling
