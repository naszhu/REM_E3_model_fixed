# Model Progress

## Commit [c99e21c](https://github.com/naszhu/REM_E3_model_fixed/commit/c99e21c) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 21:22:16  
**Message:**
```
explore(model-e3): what if no change f(j)

- Set `fj_asymptote_decrease_val` from 0.85 to 0.0 to refine model dynamics and ensure better alignment with performance expectations.
- This adjustment aims to enhance the model's responsiveness and overall calibration.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/c99e21c_20250901_212216_plot1.png)  
![](../plot_archive/c99e21c_20250901_212216_plot2.png)  

## Commit [b71ea43](https://github.com/naszhu/REM_E3_model_fixed/commit/b71ea43) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 21:18:28  
**Message:**
```
finetune(model-e3): update base parameters for improved model calibration

- Increased `ku_base` from 0.85 to 0.95 and adjusted `ci` from 0.77 to 0.79 to enhance model dynamics and criterion initialization.
- These changes aim to refine the model's performance and ensure better alignment with expected outcomes.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b71ea43_20250901_211828_plot1.png)  
![](../plot_archive/b71ea43_20250901_211828_plot2.png)  

## Commit [46ed82f](https://github.com/naszhu/REM_E3_model_fixed/commit/46ed82f) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 21:15:46  
**Message:**
```
finetune(model-e3): adjust hj parameters for improved model dynamics

- Increased `hj_asymptote_increase_val` from 0.3 to 0.5, decreased `hj_rate` from 5.0 to 2.0, and reduced `hj_base` from 0.1 to 0.05 to refine model behavior.
- These adjustments aim to enhance the model's responsiveness and alignment with expected dynamics.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/46ed82f_20250901_211546_plot1.png)  
![](../plot_archive/46ed82f_20250901_211546_plot2.png)  

## Commit [24697ba](https://github.com/naszhu/REM_E3_model_fixed/commit/24697ba) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 21:12:19  
**Message:**
```
finetune(model-e3): adjust base parameters and asymptote values for model refinement

- Decreased `ku_base` from 0.90 to 0.85, `ks_base` from 0.92 to 0.32, `kb_base` from 0.90 to 0.30, and `kt_base` from 0.90 to 0.30 to refine model performance.
- Updated `fj_asymptote_decrease_val` from 0.9 to 0.85 and `hj_asymptote_increase_val` from 0.4 to 0.3 for better alignment with model dynamics.
- Adjusted calculations for `κs_values`, `κb_values`, and `κt_values` to reflect the new base parameters.

These changes aim to further optimize the model's performance through precise parameter adjustments.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/24697ba_20250901_211219_plot1.png)  
![](../plot_archive/24697ba_20250901_211219_plot2.png)  

## Commit [b87b108](https://github.com/naszhu/REM_E3_model_fixed/commit/b87b108) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 20:53:28  
**Message:**
```
finetune(model-e3): update base parameters and asymptote values for improved model performance

- Increased `ks_base` from 0.82 to 0.92, `kb_base` from 0.80 to 0.90, and `kt_base` from 0.50 to 0.90 to enhance study and test conditions.
- Adjusted `fj_asymptote_decrease_val` from 0.8 to 0.9 for better alignment with model dynamics.
- Updated assertion to ensure `ks_base` is greater than or equal to `fj_asymptote_decrease_val`.

These changes aim to further optimize the model's performance through refined parameter settings.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b87b108_20250901_205328_plot1.png)  
![](../plot_archive/b87b108_20250901_205328_plot2.png)  

## Commit [832b9c5](https://github.com/naszhu/REM_E3_model_fixed/commit/832b9c5) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 20:49:48  
**Message:**
```
explore(probe_evaluation): add debug prints for item code mismatches

- Introduced debug print statements in `probe_evaluation.jl` to log details when sampled item codes do not match probe item codes, aiding in troubleshooting.
- Updated filtering in `R_plots.r` to include only target items in the sampling data, improving the accuracy of visualized results.

These changes aim to facilitate debugging and enhance the clarity of sampling analysis in the model.
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/832b9c5_20250901_204948_plot1.png)  
![](../plot_archive/832b9c5_20250901_204948_plot2.png)  

## Commit [a33f756](https://github.com/naszhu/REM_E3_model_fixed/commit/a33f756) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 20:43:03  
**Message:**
```
fintune(model-e3): working? reorganize file inclusions and enhance R plotting functionality

- Removed and re-added the inclusion of `data_structures.jl` in `main_JL_E3_V0.jl` for better structure.
- Added a new plot in `R_plots.r` to visualize the probability of correct sampling when an item is sampled, enhancing data analysis capabilities.
- Updated the layout of the plots to include the new sampling accuracy plot, improving the overall presentation of results.

These changes aim to improve code organization and enhance the visualization of sampling accuracy in the model's analysis.
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/main_JL_E3_V0.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/a33f756_20250901_204303_plot1.png)  
![](../plot_archive/a33f756_20250901_204303_plot2.png)  

## Commit [a0f907b](https://github.com/naszhu/REM_E3_model_fixed/commit/a0f907b) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 12:56:54  
**Message:**
```
explore(model-e3): revise base parameters and asymptote values for model optimization

- Increased `ku_base` from 0.40 to 0.90, `ks_base` from 0.50 to 0.82, and `kb_base` from 0.50 to 0.80 to enhance study and test conditions.
- Adjusted `fj_asymptote_decrease_val` from 0.2 to 0.8 to better align with model dynamics.

These changes aim to further optimize the model's performance through refined parameter settings.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/a0f907b_20250901_125654_plot1.png)  
![](../plot_archive/a0f907b_20250901_125654_plot2.png)  

## Commit [fd057c3](https://github.com/naszhu/REM_E3_model_fixed/commit/fd057c3) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 12:52:47  
**Message:**
```
explore(model-e3): adjust base parameters and drift values for model optimization

- Updated `ku_base` from 0.50 to 0.40 to refine study conditions.
- Increased `n_driftStudyTest` from 10 to 15 to enhance drift modeling between study and test phases.
- Adjusted `n_between_listchange` from 18 to 25 to improve simulation accuracy.
- Incremented `ci` from 0.76 to 0.77 to optimize criterion initialization.

These changes aim to further enhance the model's performance and accuracy through fine-tuning of key parameters.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/fd057c3_20250901_125247_plot1.png)  
![](../plot_archive/fd057c3_20250901_125247_plot2.png)  

## Commit [2528ac0](https://github.com/naszhu/REM_E3_model_fixed/commit/2528ac0) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 12:33:45  
**Message:**
```
explore(model-e3): adjust base parameters and criterion values for improved model performance

- Updated base parameters `ks_base`, `ku_base`, `kb_base`, and `kt_base` to 0.50 to reflect new study conditions.
- Reduced `fj_asymptote_decrease_val` from 0.5 to 0.2 and `hj_asymptote_increase_val` from 0.7 to 0.4 for better alignment with model dynamics.
- Adjusted `u_star_v` from 0.07 to 0.04 and `ci` from 0.98 to 0.76 to optimize initial criterion values.

These changes aim to enhance the model's accuracy and performance by fine-tuning critical parameters.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/2528ac0_20250901_123345_plot1.png)  
![](../plot_archive/2528ac0_20250901_123345_plot2.png)  

## Commit [bd4a99e](https://github.com/naszhu/REM_E3_model_fixed/commit/bd4a99e) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 12:25:54  
**Message:**
```
fix(model-e3): update feature handling to replace OT with Z feature

- Commented out the OT feature parameters and related logic in `constants.jl`, `feature_updates.jl`, and `probe_evaluation.jl` to streamline the codebase.
- Adjusted conditions in feature update functions to utilize the new Z feature instead of the deprecated OT feature.
- Enhanced clarity by ensuring that the code reflects the current feature framework.

These changes aim to improve code maintainability and align with the recent transition from the OT feature to the Z feature.
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/bd4a99e_20250901_122554_plot1.png)  
![](../plot_archive/bd4a99e_20250901_122554_plot2.png)  

## Commit [01249a0](https://github.com/naszhu/REM_E3_model_fixed/commit/01249a0) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 01:50:13  
**Message:**
```
feat(model-e3): replace OT feature with Z feature and update related functions

- Removed the OT feature and its associated parameters, replacing them with a new Z feature framework.
- Updated functions to handle Z feature logic, including study and test conditions for confusing foils.
- Adjusted feature update mechanisms to ensure compatibility with the new Z feature implementation.
- Enhanced clarity in the code by renaming functions and parameters related to the Z feature.

These changes aim to streamline the model's feature handling and improve overall functionality.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/simulation.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/01249a0_20250901_015013_plot1.png)  
![](../plot_archive/01249a0_20250901_015013_plot2.png)  

## Commit [60ed225](https://github.com/naszhu/REM_E3_model_fixed/commit/60ed225) (branch: `aug-31-new-model-v6`)
**Time:** 2025-09-01 00:11:11  
**Message:**
```
merge(model-e3): Merge branch 'aug-30-test'

Refs #58
```
![](../plot_archive/60ed225_20250901_001111_plot1.png)  
![](../plot_archive/60ed225_20250901_001111_plot2.png)  

## Commit [7741691](https://github.com/naszhu/REM_E3_model_fixed/commit/7741691) (branch: `aug-30-test`)
**Time:** 2025-08-30 23:52:32  
**Message:**
```
refactor(model-e3): add is_same_item and is_sampled flags to probe evaluation and simulation

- Introduced `is_same_item` and `is_sampled` flags in `probe_evaluation` and `probe_evaluation2` functions to track whether the sampled item matches the probe and if an item was sampled.
- Updated the DataFrame structure in `simulate_rem` to include these new flags, ensuring comprehensive data tracking during simulations.
- Adjusted relevant logic to maintain consistency and clarity in the evaluation process.

These changes aim to improve the model's ability to analyze probe sampling outcomes and enhance data integrity during simulations.

For realizing  #58
```
**Changed Files:**
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `E3/simulation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7741691_20250830_235232_plot1.png)  
![](../plot_archive/7741691_20250830_235232_plot2.png)  

## Commit [82a4029](https://github.com/naszhu/REM_E3_model_fixed/commit/82a4029) (branch: `aug-30-test`)
**Time:** 2025-08-30 23:27:00  
**Message:**
```
merge(model-e3): Merge branch 'aug-29-test'
```
![](../plot_archive/82a4029_20250830_232700_plot1.png)  
![](../plot_archive/82a4029_20250830_232700_plot2.png)  

## Commit [17e334a](https://github.com/naszhu/REM_E3_model_fixed/commit/17e334a) (branch: `aug-29-test`)
**Time:** 2025-08-30 19:07:12  
**Message:**
```
finetune(model-e3): update κb and κt parameters for clarity and consistency

- Set `κb_base` and `κb_asymptote` to 0.0 to clarify the probability of adding traces during strengthening.
- Adjusted `κt_base` and `κt_asymptote` to 0.0 to reflect the probability of adding traces without strengthening.

These changes aim to enhance the clarity of the model's parameters related to trace addition during feature strengthening.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/17e334a_20250830_190712_plot1.png)  
![](../plot_archive/17e334a_20250830_190712_plot2.png)  

## Commit [17e334a](https://github.com/naszhu/REM_E3_model_fixed/commit/17e334a) (branch: `aug-29-test`)
**Time:** 2025-08-30 19:07:12  
**Message:**
```
finetune(model-e3): update κb and κt parameters for clarity and consistency

- Set `κb_base` and `κb_asymptote` to 0.0 to clarify the probability of adding traces during strengthening.
- Adjusted `κt_base` and `κt_asymptote` to 0.0 to reflect the probability of adding traces without strengthening.

These changes aim to enhance the clarity of the model's parameters related to trace addition during feature strengthening.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/17e334a_20250830_190712_plot1.png)  
![](../plot_archive/17e334a_20250830_190712_plot2.png)  

## Commit [8874844](https://github.com/naszhu/REM_E3_model_fixed/commit/8874844) (branch: `aug-29-test`)
**Time:** 2025-08-29 20:34:30  
**Message:**
```
fix(model-e3): update OT feature strengthening functions for clarity and consistency

- Revised function documentation to clarify the purpose of `update_ot_feature_strengthen!`, `update_ot_feature_add_trace_strengthen!`, and `update_ot_feature_add_trace_only!`.
- Adjusted the logic for κ value assignments to ensure correct parameter usage during feature updates, enhancing the model's operational consistency.

These changes aim to improve code readability and maintainability while ensuring accurate feature strengthening behavior.
```
**Changed Files:**
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/8874844_20250829_203430_plot1.png)  
![](../plot_archive/8874844_20250829_203430_plot2.png)  

## Commit [e16f69c](https://github.com/naszhu/REM_E3_model_fixed/commit/e16f69c) (branch: `aug-29-test`)
**Time:** 2025-08-29 20:14:46  
**Message:**
```
finetune(model-e3): adjust criterion initial values for improved model accuracy

- Updated `ci` from 0.58 to 0.98 to optimize the initial criterion values, reflecting a necessary adjustment for better model performance.
- Maintained `context_tau` at a constant value to ensure consistency with the updated foil odds.

These changes aim to enhance the model's accuracy by fine-tuning critical parameters related to the criterion initialization.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/e16f69c_20250829_201446_plot1.png)  
![](../plot_archive/e16f69c_20250829_201446_plot2.png)  

## Commit [4c8c5d6](https://github.com/naszhu/REM_E3_model_fixed/commit/4c8c5d6) (branch: `aug-29-test`)
**Time:** 2025-08-29 20:13:33  
**Message:**
```
finetune(model-e3): adjust criterion initial values for improved model accuracy

- Updated `ci` from 0.78 to 0.58 to optimize the initial criterion values, reflecting a necessary adjustment for better model performance.
- Modified `context_tau` to ensure alignment with the updated foil odds.

These changes aim to enhance the model's accuracy by fine-tuning critical parameters related to the criterion initialization.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/4c8c5d6_20250829_201333_plot1.png)  
![](../plot_archive/4c8c5d6_20250829_201333_plot2.png)  

## Commit [9f88ac1](https://github.com/naszhu/REM_E3_model_fixed/commit/9f88ac1) (branch: `aug-29-test`)
**Time:** 2025-08-29 20:12:19  
**Message:**
```
finetune(model-e3): adjust kappa parameters for improved model dynamics

- Increased `κs_base` and `κs_asymptote` to 0.80 to enhance the model's response dynamics related to incorrect test information.
- Decreased `κb_base` and `κt_base` to 0.20 to refine the initial probabilities of adding traces during and without strengthening.

These changes aim to further optimize the model's performance by fine-tuning critical kappa parameters.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/9f88ac1_20250829_201219_plot1.png)  
![](../plot_archive/9f88ac1_20250829_201219_plot2.png)  

## Commit [793ec6b](https://github.com/naszhu/REM_E3_model_fixed/commit/793ec6b) (branch: `aug-29-test`)
**Time:** 2025-08-29 20:09:07  
**Message:**
```
finetune(model-e3): update kappa parameters and criterion initial values for improved model performance

- Increased `κs_base`, `κs_asymptote`, `κb_base`, and `κt_base` to 0.50 to enhance the model's response dynamics.
- Adjusted `ci` from 0.67 to 0.78 to optimize the initial criterion values for better model accuracy.
- Commented out the `ylim` function in R plots to allow for dynamic y-axis scaling.

These changes aim to refine the model's performance by fine-tuning critical parameters related to kappa and feature evaluation.
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/793ec6b_20250829_200907_plot1.png)  
![](../plot_archive/793ec6b_20250829_200907_plot2.png)  

## Commit [4ab69bb](https://github.com/naszhu/REM_E3_model_fixed/commit/4ab69bb) (branch: `aug-29-test`)
**Time:** 2025-08-29 20:02:05  
**Message:**
```
finetune(model-e3): update kappa parameters and feature constants for improved model dynamics

- Adjusted `κ_update_between_list` from 0.85 to 0.25 to refine the update mechanism for features between lists.
- Set `κs_asymptote` to 0.00 to reflect a more accurate asymptotic behavior for incorrect test information.
- Increased `κb_base` from 0.1 to 0.2 to enhance the initial probability of adding traces during strengthening.
- Updated `u_star_v` from 0.04 to 0.07 and `nnnow` from 0.70 to 0.8 to improve context copying parameters.
- Modified `n_driftStudyTest` from 14 to 10 to adjust the drift study test values.
- Revised `ci` from 0.9 to 0.67 and updated `criterion_final` to use a range of 7 for better model performance.

These changes aim to enhance the model's accuracy and responsiveness by fine-tuning critical parameters related to kappa and feature dynamics.
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/4ab69bb_20250829_200205_plot1.png)  
![](../plot_archive/4ab69bb_20250829_200205_plot2.png)  

## Commit [aa9b958](https://github.com/naszhu/REM_E3_model_fixed/commit/aa9b958) (branch: `aug-29-test`)
**Time:** 2025-08-29 19:54:40  
**Message:**
```
refactor(model-e3): moving feature distortion function to feature_updates module

Fixed a bug as well, do not distort the OT features.

- Added a new function `distort_probes_with_linear_decay` to apply a linear decrease in distortion probability from the first to the last probe, enhancing the modeling of content drift.
- Updated the function to include parameters for maximum distortion probes, base distortion probability, and geometric distribution for feature value generation.
- Renamed `update_context_features_during_study!` to `store_context_features_during_study` for clarity in functionality.

These changes aim to improve the accuracy and flexibility of probe distortion mechanisms within the model.
```
**Changed Files:**
- `E3/feature_updates.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/aa9b958_20250829_195440_plot1.png)  
![](../plot_archive/aa9b958_20250829_195440_plot2.png)  

## Commit [63beedd](https://github.com/naszhu/REM_E3_model_fixed/commit/63beedd) (branch: `aug-29-test`)
**Time:** 2025-08-29 19:16:48  
**Message:**
```
fix(model-e3): change sequance of modules includion in main script

changed the inclusion of the "data_structures.jl" file to put on top  in the main script to ensure necessary data structures are available for subsequent operations. Removed redundant inclusion to streamline the code.
```
**Changed Files:**
- `E3/main_JL_E3_V0.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/63beedd_20250829_191648_plot1.png)  
![](../plot_archive/63beedd_20250829_191648_plot2.png)  

## Commit [c035450](https://github.com/naszhu/REM_E3_model_fixed/commit/c035450) (branch: `aug-29-test`)
**Time:** 2025-08-26 23:14:57  
**Message:**
```
merge(model-e3):Merge branch 'aug-26-within-list-fix'

Within list fix.
```
![](../plot_archive/c035450_20250826_231457_plot1.png)  
![](../plot_archive/c035450_20250826_231457_plot2.png)  

## Commit [07a86d3](https://github.com/naszhu/REM_E3_model_fixed/commit/07a86d3) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 22:24:49  
**Message:**
```
fix(model-e3): refine feature strengthening logic and enhance probe evaluation assertions

Found bug of where is the last v's difference between where we had problem, but what's the problem?. why?

why after chaning the decision logic, it instantly causes the within-list result be different? could it be the problem of the marking of the within-list test item to be 1 making the later ones mistaken?

- Updated the `strengthen_features!` function to include additional conditions for updating target features when current values are zero or mismatched, improving feature accuracy.
- Added an assertion in `probe_evaluation` to ensure that a sampled item is not `nothing`, addressing potential bugs in decision-making logic related to the OT feature.

These changes aim to enhance the robustness and reliability of the model's feature handling and evaluation processes.
```
**Changed Files:**
- `E3/feature_updates.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/07a86d3_20250826_222449_plot1.png)  
![](../plot_archive/07a86d3_20250826_222449_plot2.png)  

## Commit [007c234](https://github.com/naszhu/REM_E3_model_fixed/commit/007c234) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 21:11:58  
**Message:**
```
finetune(model-e3): update kappa parameters and distortion probabilities for improved model dynamics

- Adjusted `κs_asymptote` from 0.0 to 0.3 to better reflect the asymptotic behavior of incorrect test information.
- Reduced `κb_base` and `κt_base` from 0.5 to 0.1 to enhance the model's response to adding traces during strengthening and without strengthening.
- Updated `base_distortion_prob` from 0.8 to 0.6 to refine the initial probability of distortion for probes.
- Increased `ci` from 0.84 to 0.9 to optimize the initial criterion values for model dynamics.

These changes aim to enhance the model's performance by fine-tuning critical parameters related to kappa and distortion mechanisms.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/007c234_20250826_211158_plot1.png)  
![](../plot_archive/007c234_20250826_211158_plot2.png)  

## Commit [e048c24](https://github.com/naszhu/REM_E3_model_fixed/commit/e048c24) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 21:05:11  
**Message:**
```
feat(model-e3): integrate OT feature updates and enhance memory management

this is done by comparing change to 2be1bd01705c8e9c730147862981aa275a206d32

- Introduced a new OT feature to track prior testing status, with associated kappa parameters for dynamic updates during study and restoration processes.
- Updated functions to handle the OT feature, including `update_ot_feature!`, `strengthen_features!`, and `store_word_features!`, ensuring accurate memory storage and retrieval.
- Enhanced decision-making logic in `probe_evaluation` to utilize the OT feature when enabled, improving the model's adaptability in evaluating probe responses.
- Adjusted memory restoration functions to incorporate the new OT feature, ensuring consistent handling across different contexts.

These changes aim to refine the model's performance by improving the integration and management of the OT feature within the memory framework.

In solving #57
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/feature_generation.jl`  
- `E3/feature_updates.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/e048c24_20250826_210511_plot1.png)  
![](../plot_archive/e048c24_20250826_210511_plot2.png)  

## Commit [1f65eaa](https://github.com/naszhu/REM_E3_model_fixed/commit/1f65eaa) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 20:24:44  
**Message:**
```
feat(model-e3): content drift: probe distortion mechanism and update constants

redo commit 9dd4a2cbb1fa4aa4b6b0148fad3a144318bbb6cb

- Introduced a new function `distort_probes_with_linear_decay` to apply a linear decrease in distortion probability for probes, improving the modeling of content drift between study and test.
- Added constants for distortion parameters, including `max_distortion_probes` and `base_distortion_prob`, to refine the distortion process.
- Updated `criterion_initial` calculation to use a new variable `ci` for better clarity and consistency.
- Commented out unused code in `simulate_rem` to improve readability and maintainability.

These changes aim to enhance the model's accuracy in simulating probe behavior and content dynamics.

Refs this is to solve #57
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_generation.jl`  
- `E3/simulation.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/1f65eaa_20250826_202444_plot1.png)  
![](../plot_archive/1f65eaa_20250826_202444_plot2.png)  

## Commit [864c339](https://github.com/naszhu/REM_E3_model_fixed/commit/864c339) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 20:14:18  
**Message:**
```
restore(model-e3): restore back to commit before last whole branch merge

back to 778073961c864fde39c6f800836c15f886c28ab4

This is to solve #57
```
**Changed Files:**
- `E3/comprehensive_debug.jl`  
- `E3/constants.jl`  
- `E3/corrected_debug_reversing_trend.jl`  
- `E3/debug_reversing_trend.jl`  
- `E3/feature_generation.jl`  
- `E3/feature_updates.jl`  
- `E3/fix_content_drift_imbalance.jl`  
- `E3/fix_reversing_trend.jl`  
- `E3/main_JL_E3_V0.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `E3/quick_fix_reversing_trend.jl`  
- `E3/real_root_cause_analysis.jl`  
- `E3/simulation.jl`  
- `E3/utils.jl`  
- `criterion`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/864c339_20250826_201418_plot1.png)  
![](../plot_archive/864c339_20250826_201418_plot2.png)  

## Commit [b3a1c46](https://github.com/naszhu/REM_E3_model_fixed/commit/b3a1c46) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 20:13:53  
**Message:**
```
restore(model-e3): restore back to commit before last whole branch merge

back to 778073961c864fde39c6f800836c15f886c28ab4

This is to solve #57
```
**Changed Files:**
- `E3/comprehensive_debug.jl`  
- `E3/constants.jl`  
- `E3/corrected_debug_reversing_trend.jl`  
- `E3/debug_reversing_trend.jl`  
- `E3/feature_generation.jl`  
- `E3/feature_updates.jl`  
- `E3/fix_content_drift_imbalance.jl`  
- `E3/fix_reversing_trend.jl`  
- `E3/main_JL_E3_V0.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `E3/quick_fix_reversing_trend.jl`  
- `E3/real_root_cause_analysis.jl`  
- `E3/simulation.jl`  
- `E3/utils.jl`  
- `criterion`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b3a1c46_20250826_201353_plot1.png)  
![](../plot_archive/b3a1c46_20250826_201353_plot2.png)  

## Commit [b3a1c46](https://github.com/naszhu/REM_E3_model_fixed/commit/b3a1c46) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 20:13:53  
**Message:**
```
restore(model-e3): restore back to commit before last whole branch merge

back to 778073961c864fde39c6f800836c15f886c28ab4

This is to solve #57
```
**Changed Files:**
- `E3/comprehensive_debug.jl`  
- `E3/constants.jl`  
- `E3/corrected_debug_reversing_trend.jl`  
- `E3/debug_reversing_trend.jl`  
- `E3/feature_generation.jl`  
- `E3/feature_updates.jl`  
- `E3/fix_content_drift_imbalance.jl`  
- `E3/fix_reversing_trend.jl`  
- `E3/main_JL_E3_V0.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `E3/quick_fix_reversing_trend.jl`  
- `E3/real_root_cause_analysis.jl`  
- `E3/simulation.jl`  
- `E3/utils.jl`  
- `criterion`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b3a1c46_20250826_201353_plot1.png)  
![](../plot_archive/b3a1c46_20250826_201353_plot2.png)  

## Commit [b6333e5](https://github.com/naszhu/REM_E3_model_fixed/commit/b6333e5) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 20:10:57  
**Message:**
```
restore(model-e3): restore back to commit before last whole branch merge

back to 778073961c864fde39c6f800836c15f886c28ab4

This is to solve #57
```
**Changed Files:**
- `E3/comprehensive_debug.jl`  
- `E3/constants.jl`  
- `E3/corrected_debug_reversing_trend.jl`  
- `E3/debug_reversing_trend.jl`  
- `E3/feature_generation.jl`  
- `E3/feature_updates.jl`  
- `E3/fix_content_drift_imbalance.jl`  
- `E3/fix_reversing_trend.jl`  
- `E3/main_JL_E3_V0.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `E3/quick_fix_reversing_trend.jl`  
- `E3/real_root_cause_analysis.jl`  
- `E3/simulation.jl`  
- `E3/utils.jl`  
- `criterion`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b6333e5_20250826_201057_plot1.png)  
![](../plot_archive/b6333e5_20250826_201057_plot2.png)  

## Commit [d1322de](https://github.com/naszhu/REM_E3_model_fixed/commit/d1322de) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 16:49:55  
**Message:**
```
debug(model-e3): not exactly sure what is going on

- Introduced a new script `comprehensive_debug.jl` to analyze the reversing trend issue, providing detailed insights into probe distortion and its impact on model behavior.
- The script includes simulations of probe distortion, current state analysis, and critical discoveries regarding the root cause of the reversing trend.
- Recommendations for immediate fixes and verification steps are provided to restore balanced probe distortion and address the identified issues.
```
**Changed Files:**
- `E3/comprehensive_debug.jl`  
- `E3/corrected_debug_reversing_trend.jl`  
- `E3/debug_reversing_trend.jl`  
- `E3/fix_content_drift_imbalance.jl`  
- `E3/fix_reversing_trend.jl`  
- `E3/quick_fix_reversing_trend.jl`  
- `E3/real_root_cause_analysis.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/d1322de_20250826_164955_plot1.png)  
![](../plot_archive/d1322de_20250826_164955_plot2.png)  

## Commit [9dd4a2c](https://github.com/naszhu/REM_E3_model_fixed/commit/9dd4a2c) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 16:33:27  
**Message:**
```
feat(model-e3): probe distortion at beginning between study and test

This is modified but for some reason the within-list is still wrong

- Introduced a new function `distort_probes_with_linear_decay` to apply a linear decrease in distortion probability for probes, improving the modeling of content drift between study and test.
- Updated constants related to reinstatement and context drift, including `p_reinstate_rate` and `n_driftStudyTest`, to refine model dynamics.
- Adjusted flags for context drift behavior, enabling more flexible control over content drift during simulations.

These changes aim to improve the model's adaptability and accuracy in simulating probe behavior and context dynamics.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_generation.jl`  
- `E3/simulation.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/9dd4a2c_20250826_163327_plot1.png)  
![](../plot_archive/9dd4a2c_20250826_163327_plot2.png)  

## Commit [2be1bd0](https://github.com/naszhu/REM_E3_model_fixed/commit/2be1bd0) (branch: `aug-26-within-list-fix`)
**Time:** 2025-08-26 01:33:10  
**Message:**
```
merge(model-e3): Merge branch 'aug-23-new-test'
```
![](../plot_archive/2be1bd0_20250826_013310_plot1.png)  
![](../plot_archive/2be1bd0_20250826_013310_plot2.png)  

## Commit [713a4dc](https://github.com/naszhu/REM_E3_model_fixed/commit/713a4dc) (branch: `main`)
**Time:** 2025-08-26 01:32:33  
**Message:**
```
merge(model-e3): Merge branch 'aug-23-new-test'
```
![](../plot_archive/713a4dc_20250826_013233_plot1.png)  
![](../plot_archive/713a4dc_20250826_013233_plot2.png)  

## Commit [7780739](https://github.com/naszhu/REM_E3_model_fixed/commit/7780739) (branch: `main`)
**Time:** 2025-08-23 19:28:53  
**Message:**
```
merge(model-e3): replace UC drift in to content drift. Merge branch 'aug-20-newfeat'
```
![](../plot_archive/7780739_20250823_192853_plot1.png)  
![](../plot_archive/7780739_20250823_192853_plot2.png)  

## Commit [d0412c2](https://github.com/naszhu/REM_E3_model_fixed/commit/d0412c2) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 22:51:57  
**Message:**
```
finetune(model-e3): adjust kappa parameters for improved model dynamics

- Set `κs_base` to 0.00 to better reflect the starting probability of incorrect test information.
- Increased `nnnow` from 0.8 to 0.9 to enhance context copying parameters.
- Decreased `ci` from 0.7 to 0.6 to optimize the initial criterion values.

These changes aim to refine the model's performance by fine-tuning critical parameters related to kappa and context copying.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/d0412c2_20250824_225157_plot1.png)  
![](../plot_archive/d0412c2_20250824_225157_plot2.png)  

## Commit [0ec8103](https://github.com/naszhu/REM_E3_model_fixed/commit/0ec8103) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 22:37:10  
**Message:**
```
finetune(model-e3):  ks_base=0.15, doensn't help much

- Reduced `κs_base` from 0.3 to 0.15 to better reflect the starting probability of incorrect test information.
- Decreased `κs_asymptote` from 0.1 to 0.0 to align with the new model dynamics.

These changes aim to enhance the model's performance by refining the kappa parameters used in OT feature updates.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/0ec8103_20250824_223710_plot1.png)  
![](../plot_archive/0ec8103_20250824_223710_plot2.png)  

## Commit [c5603af](https://github.com/naszhu/REM_E3_model_fixed/commit/c5603af) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 22:28:40  
**Message:**
```
fix(model-e3): wrong on ks use again, bug caused by cursor

- Updated functions to replace `add_features_from_empty!` with `add_feature_during_restore!` and `restore_features!` with `strengthen_features!` for clarity and consistency in handling the OT feature.
- Incorporated list number handling for dynamic kappa value selection in the updated functions.
- Adjusted the initialization of word features to account for the number of OT features, ensuring accurate memory storage and retrieval.

These changes aim to enhance the model's adaptability and improve the clarity of the memory management process.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/c5603af_20250824_222840_plot1.png)  
![](../plot_archive/c5603af_20250824_222840_plot2.png)  

## Commit [2a2c900](https://github.com/naszhu/REM_E3_model_fixed/commit/2a2c900) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 21:05:08  
**Message:**
```
fix(model-e3): previous use of ks is wrong

ks should be used for studying item but not for test, and kb is used for strengthening for both,

- Introduced a flag `use_ot_feature` to enable or disable the OT feature functionality across various functions.
- Updated `add_features_from_empty!`, `restore_features!`, and `update_ot_feature` functions to incorporate list number handling for dynamic kappa value selection.
- Modified decision logic in `probe_evaluation` to utilize the OT feature only when enabled, ensuring fallback logic is in place when the feature is disabled.
- Adjusted related functions to maintain consistency in handling the OT feature during memory restoration and strengthening processes.

These changes aim to improve the model's adaptability and decision-making accuracy by refining the integration of the OT feature.

This updates issue #54 as well
This create issue #56, be caution
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/2a2c900_20250824_210508_plot1.png)  
![](../plot_archive/2a2c900_20250824_210508_plot2.png)  

## Commit [5c90a04](https://github.com/naszhu/REM_E3_model_fixed/commit/5c90a04) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 21:03:39  
**Message:**
```
fix(model-e3): previous use of ks is wrong

ks should be used for studying item but not for test, and kb is used for strengthening for both,

- Introduced a flag `use_ot_feature` to enable or disable the OT feature functionality across various functions.
- Updated `add_features_from_empty!`, `restore_features!`, and `update_ot_feature` functions to incorporate list number handling for dynamic kappa value selection.
- Modified decision logic in `probe_evaluation` to utilize the OT feature only when enabled, ensuring fallback logic is in place when the feature is disabled.
- Adjusted related functions to maintain consistency in handling the OT feature during memory restoration and strengthening processes.

These changes aim to improve the model's adaptability and decision-making accuracy by refining the integration of the OT feature.

This updates issue #54 as well
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/5c90a04_20250824_210339_plot1.png)  
![](../plot_archive/5c90a04_20250824_210339_plot2.png)  

## Commit [21fe52e](https://github.com/naszhu/REM_E3_model_fixed/commit/21fe52e) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 21:03:21  
**Message:**
```
enhance(model-e3): integrate OT feature handling in memory updates and evaluations

- Introduced a flag `use_ot_feature` to enable or disable the OT feature functionality across various functions.
- Updated `add_features_from_empty!`, `restore_features!`, and `update_ot_feature` functions to incorporate list number handling for dynamic kappa value selection.
- Modified decision logic in `probe_evaluation` to utilize the OT feature only when enabled, ensuring fallback logic is in place when the feature is disabled.
- Adjusted related functions to maintain consistency in handling the OT feature during memory restoration and strengthening processes.

These changes aim to improve the model's adaptability and decision-making accuracy by refining the integration of the OT feature.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/21fe52e_20250824_210321_plot1.png)  
![](../plot_archive/21fe52e_20250824_210321_plot2.png)  

## Commit [caf263c](https://github.com/naszhu/REM_E3_model_fixed/commit/caf263c) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 20:04:36  
**Message:**
```
explore(model-e3): c to 0.8, ks, kb change lower

- Decreased `κs_asymptote` from 0.5 to 0.4 to refine the probability of incorrect test information.
- Increased `κb_base` and `κt_base` from 0.1 to 0.5 to enhance the probability of adding traces during strengthening and without strengthening.
- Adjusted `u_star_v` from 0.1 to 0.046 to optimize model dynamics.
- Increased `nnnow` from 0.7 to 0.8 to improve context copying parameters.

These changes aim to enhance the model's adaptability and performance by fine-tuning critical parameters.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/caf263c_20250824_200436_plot1.png)  
![](../plot_archive/caf263c_20250824_200436_plot2.png)  

## Commit [b34c8a6](https://github.com/naszhu/REM_E3_model_fixed/commit/b34c8a6) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 19:42:16  
**Message:**
```
explore(model-e3): adjust u_star_v parameter for improved model dynamics

- Increased the value of `u_star_v` from 0.06 to 0.1 to enhance the model's adaptability.
- Updated the calculation of `u_star` to reflect the new `u_star_v` value, ensuring consistency in model behavior.

These changes aim to refine the model's performance by optimizing the parameter settings.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b34c8a6_20250824_194216_plot1.png)  
![](../plot_archive/b34c8a6_20250824_194216_plot2.png)  

## Commit [4661491](https://github.com/naszhu/REM_E3_model_fixed/commit/4661491) (branch: `aug-23-new-test`)
**Time:** 2025-08-24 19:33:24  
**Message:**
```
fix(model-e3): kb and ks used mistakenly ealier

- Updated kappa parameters for OT feature updates to use asymptotic functions, improving the model's adaptability across lists.
- Modified update functions to accept list numbers, allowing for dynamic kappa value selection based on the list context.
- Added debug output to display generated asymptotic kappa values for better traceability during simulations.
- Adjusted related memory restoration functions to incorporate the new update logic.

These changes aim to refine the feature update process and enhance the model's performance in memory management.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/main_JL_E3_V0.jl`  
- `E3/memory_restorage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/4661491_20250824_193324_plot1.png)  
![](../plot_archive/4661491_20250824_193324_plot2.png)  

## Commit [eab207e](https://github.com/naszhu/REM_E3_model_fixed/commit/eab207e) (branch: `aug-23-new-test`)
**Time:** 2025-08-23 22:05:23  
**Message:**
```
refactor(model-e3): update simulation parameters and enhance feature restoration logic

- Increased the number of simulations from 1000 to 300 for improved testing efficiency.
- Adjusted the logic in the feature restoration function to incorporate new parameters for better decision-making.
- Commented out the previous `z_time_p_val` dictionary and related print statement for clarity and future reference.

These changes aim to refine the simulation process and enhance the model's feature restoration capabilities.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/eab207e_20250823_220523_plot1.png)  
![](../plot_archive/eab207e_20250823_220523_plot2.png)  

## Commit [f2e29b7](https://github.com/naszhu/REM_E3_model_fixed/commit/f2e29b7) (branch: `aug-23-new-test`)
**Time:** 2025-08-23 21:23:00  
**Message:**
```
feat(model-e3): introduce OT feature for enhanced decision-making and memory updates

- Added an OT feature to track whether items have been tested before, influencing decision logic during evaluations.
- Updated feature generation to include the OT feature in both study lists and probes.
- Implemented functions to manage OT feature updates during memory restoration and strengthening processes.
- Adjusted decision logic to utilize the OT feature for improved accuracy in determining item status.

These changes aim to refine the model's memory management and enhance the decision-making process by incorporating additional contextual information.

Refs OT add #54
Closes #55
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_generation.jl`  
- `E3/feature_updates.jl`  
- `E3/main_JL_E3_V0.jl`  
- `E3/memory_restorage.jl`  
- `E3/memory_storage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `criterion`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/f2e29b7_20250823_212300_plot1.png)  
![](../plot_archive/f2e29b7_20250823_212300_plot2.png)  

## Commit [7780739](https://github.com/naszhu/REM_E3_model_fixed/commit/7780739) (branch: `aug-23-new-test`)
**Time:** 2025-08-23 19:28:53  
**Message:**
```
merge(model-e3): replace UC drift in to content drift. Merge branch 'aug-20-newfeat'
```
![](../plot_archive/7780739_20250823_192853_plot1.png)  
![](../plot_archive/7780739_20250823_192853_plot2.png)  

## Commit [654fc84](https://github.com/naszhu/REM_E3_model_fixed/commit/654fc84) (branch: `aug-20-newfeat`)
**Time:** 2025-08-21 19:41:44  
**Message:**
```
explore(model-e3): 1000 simuation
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/654fc84_20250821_194144_plot1.png)  
![](../plot_archive/654fc84_20250821_194144_plot2.png)  

## Commit [08d428d](https://github.com/naszhu/REM_E3_model_fixed/commit/08d428d) (branch: `aug-20-newfeat`)
**Time:** 2025-08-21 19:36:34  
**Message:**
```
feat(model-e3): content drift replace UC drift

- Set `is_finaltest` to false and adjusted `n_simulations` to 500 for improved testing efficiency.
- Renamed `context_features` to `context_or_content_features` in `drift_ctx_betweenStudyAndTest!` function for clarity.
- Introduced `is_content_drift_between_study_and_test` flag to manage content drift during simulations.
- Updated logic in `simulate_rem` to incorporate new content drift functionality, ensuring better context management during tests.

These changes aim to refine the simulation process and enhance the model's handling of context drift.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/issue_body.txt`  
- `E3/simulation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/08d428d_20250821_193634_plot1.png)  
![](../plot_archive/08d428d_20250821_193634_plot2.png)  

## Commit [f0af48f](https://github.com/naszhu/REM_E3_model_fixed/commit/f0af48f) (branch: `aug-20-newfeat`)
**Time:** 2025-08-19 09:31:48  
**Message:**
```
merge(model-e3): refine decision logic and enhance context management

- Restructured [decision logic] to sample items before making decisions, ensuring that the model uses the correct context.
- Introduced a new parameter `use_sampled_item_for_decision` for backward compatibility.
- Fixed bounds errors related to list number access and cleaned up restore function logic.
- Added a new function `drift_context_during_final_test!` to manage context changes during final tests.
- Updated simulation parameters for final tests, reducing the number of simulations for efficiency.

This commit addresses critical bugs and improves the overall decision-making process in the model.
```
![](../plot_archive/f0af48f_20250819_093148_plot1.png)  
![](../plot_archive/f0af48f_20250819_093148_plot2.png)  

## Commit [c810676](https://github.com/naszhu/REM_E3_model_fixed/commit/c810676) (branch: `main`)
**Time:** 2025-08-14 00:39:21  
**Message:**
```
merge(model-e3): integrate parameter adjustments and threshold optimizations

Merge branch 'aug-11' into main

- Merged experimental changes from aug-11 branch
- Updated context copying parameters (nnnow=0.70)
- Refined criterion thresholds with power transformation
- Improved z-value calculations for list origin probabilities
- Enhanced asymptotic value generation for decision thresholds

Ref: https://github.com/naszhu/REM_E3_model_fixed/
```
![](../plot_archive/c810676_20250814_003921_plot1.png)  
![](../plot_archive/c810676_20250814_003921_plot2.png)  

## Commit [8d4dcbb](https://github.com/naszhu/REM_E3_model_fixed/commit/8d4dcbb) (branch: `aug-14-test`)
**Time:** 2025-08-19 09:29:02  
**Message:**
```
fix(model-e3):  z  value mistaken on type Tn+1
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/8d4dcbb_20250819_092902_plot1.png)  
![](../plot_archive/8d4dcbb_20250819_092902_plot2.png)  

## Commit [7ab7cb0](https://github.com/naszhu/REM_E3_model_fixed/commit/7ab7cb0) (branch: `aug-14-test`)
**Time:** 2025-08-17 21:35:17  
**Message:**
```
chore(model-e3): Have tested on use_sample_for_decison = false, seems to be good
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7ab7cb0_20250817_213517_plot1.png)  
![](../plot_archive/7ab7cb0_20250817_213517_plot2.png)  

## Commit [80e50df](https://github.com/naszhu/REM_E3_model_fixed/commit/80e50df) (branch: `aug-14-test`)
**Time:** 2025-08-17 16:56:05  
**Message:**
```
fix(model-e3): restructure decision logic and fix bounds errors

- Restructure decision logic to sample items BEFORE making decisions
- Fix critical bug where decisions were based on probe instead of sampled item
- Add configurable parameter use_sampled_item_for_decision for backward compatibility
- Eliminate redundant sampling by passing sampled_item directly to restore functions
- Fix bounds error caused by list_number 0 accessing negative array indices
- Clean up restore function logic to handle cases where no item is sampled
- Maintain identical decision structure while changing only the source of type information
- Update both probe_evaluation and probe_evaluation2 functions consistently

This fixes the fundamental logical flaw where the model was making decisions
based on what was being tested rather than what was actually retrieved
from memory. The new structure ensures decisions are based on sampled
items while maintaining full backward compatibility.

Closes #53
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/80e50df_20250817_165605_plot1.png)  
![](../plot_archive/80e50df_20250817_165605_plot2.png)  

## Commit [4464576](https://github.com/naszhu/REM_E3_model_fixed/commit/4464576) (branch: `aug-14-test`)
**Time:** 2025-08-17 16:55:44  
**Message:**
```
fix(model-e3): restructure decision logic and fix bounds errors

- Restructure decision logic to sample items BEFORE making decisions
- Fix critical bug where decisions were based on probe instead of sampled item
- Add configurable parameter use_sampled_item_for_decision for backward compatibility
- Eliminate redundant sampling by passing sampled_item directly to restore functions
- Fix bounds error caused by list_number 0 accessing negative array indices
- Clean up restore function logic to handle cases where no item is sampled
- Maintain identical decision structure while changing only the source of type information
- Update both probe_evaluation and probe_evaluation2 functions consistently

This fixes the fundamental logical flaw where the model was making decisions
based on what was being tested rather than what was actually retrieved
from memory. The new structure ensures decisions are based on sampled
items while maintaining full backward compatibility.

Closes #53
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/4464576_20250817_165544_plot1.png)  
![](../plot_archive/4464576_20250817_165544_plot2.png)  

## Commit [893d5ae](https://github.com/naszhu/REM_E3_model_fixed/commit/893d5ae) (branch: `aug-14-test`)
**Time:** 2025-08-15 00:20:14  
**Message:**
```
finetune(model-e3): Change UC change in final - give a good OI after bug fixed

- Reduced the number of simulations for final tests from 200 to 100 for efficiency.
- Updated the context drift parameter in `generate_finalt_probes` from 0.001 to 0.02 to enhance feature management during final tests.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_generation.jl`  
![](../plot_archive/893d5ae_20250815_002014_plot1.png)  
![](../plot_archive/893d5ae_20250815_002014_plot2.png)  

## Commit [9de83ab](https://github.com/naszhu/REM_E3_model_fixed/commit/9de83ab) (branch: `HEAD`)
**Time:** 2025-08-14 23:42:14  
**Message:**
```
ix(model-e3): fix broken chunk boundary detection causing excessive context drift

- Replace complex findlast() logic with simple previous_chunk tracking
- Fix causes context drift to trigger only at chunk boundaries (9 times) instead of 432 times
- Resolves massive interference in final test results
- Addresses TODO comment about iprobe_chunk correct usage, this to do has been there hanging for so  long.

-  Added a chunk_test.jl file for chunk testing.

Fixes #51: Critical bug that was present for months
```
**Changed Files:**
- `E3/degbug_scr/chunk_test.jl`  
- `E3/probe_generation.jl`  
![](../plot_archive/9de83ab_20250814_234214_plot1.png)  
![](../plot_archive/9de83ab_20250814_234214_plot2.png)  

## Commit [50efaea](https://github.com/naszhu/REM_E3_model_fixed/commit/50efaea) (branch: `HEAD`)
**Time:** 2025-08-14 01:15:08  
**Message:**
```
fix(model-e3): refine simulation parameters and add context drift function

BIG BUG on no cotext change , sth happened

- Increased the number of simulations for final tests from 300 to 500.
- Introduced a new function `drift_context_during_final_test!` to update context features with a specified probability during final tests.
- Updated the logic in `generate_finalt_probes` to utilize the new context drift function for improved context management.
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/probe_generation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/50efaea_20250814_011508_plot1.png)  
![](../plot_archive/50efaea_20250814_011508_plot2.png)  

## Commit [c810676](https://github.com/naszhu/REM_E3_model_fixed/commit/c810676) (branch: `aug-14-test`)
**Time:** 2025-08-14 00:39:21  
**Message:**
```
merge(model-e3): integrate parameter adjustments and threshold optimizations

Merge branch 'aug-11' into main

- Merged experimental changes from aug-11 branch
- Updated context copying parameters (nnnow=0.70)
- Refined criterion thresholds with power transformation
- Improved z-value calculations for list origin probabilities
- Enhanced asymptotic value generation for decision thresholds

Ref: https://github.com/naszhu/REM_E3_model_fixed/
```
![](../plot_archive/c810676_20250814_003921_plot1.png)  
![](../plot_archive/c810676_20250814_003921_plot2.png)  

## Commit [e169187](https://github.com/naszhu/REM_E3_model_fixed/commit/e169187) (branch: `aug-11`)
**Time:** 2025-08-12 23:48:22  
**Message:**
```
add(vscode): create settings file for Visual Studio Code with custom theme

- Introduced a new settings.json file to configure the workbench color theme and customize UI colors for better visibility and aesthetics.
```
**Changed Files:**
- `.vscode/settings.json`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/e169187_20250812_234822_plot1.png)  
![](../plot_archive/e169187_20250812_234822_plot2.png)  

## Commit [b467152](https://github.com/naszhu/REM_E3_model_fixed/commit/b467152) (branch: `aug-11`)
**Time:** 2025-08-12 23:46:38  
**Message:**
```
fix(model-e3): strengthen context restoration logic on  parameters

fixed the mismatch between E1 and E3, but it doesn't really change the prediction much at all

- Increased the number of simulations for final tests from 100 to 1000.
- Modified the reinstatement context probability from 0.8 to 1.
- Updated logic in memory restoration functions to ensure context and content strengthening is correctly applied.

Making is_strengthen_contextandcontent to align with E1

Refs naszhu/REM_E3_model_fixed#21
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b467152_20250812_234638_plot1.png)  
![](../plot_archive/b467152_20250812_234638_plot2.png)  

## Commit [505d5f5](https://github.com/naszhu/REM_E3_model_fixed/commit/505d5f5) (branch: `aug-11`)
**Time:** 2025-08-12 23:46:18  
**Message:**
```
update(model-e3): strengthen context restoration logic on parameter is_strengthen_contextandcontent

- Increased the number of simulations for final tests from 100 to 1000.
- Modified the reinstatement context probability from 0.8 to 1.
- Updated logic in memory restoration functions to ensure context and content strengthening is correctly applied.

Making is_strengthen_contextandcontent to align with E1

Refs naszhu/REM_E3_model_fixed#21
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/505d5f5_20250812_234618_plot1.png)  
![](../plot_archive/505d5f5_20250812_234618_plot2.png)  

## Commit [9b8cf1b](https://github.com/naszhu/REM_E3_model_fixed/commit/9b8cf1b) (branch: `aug-11`)
**Time:** 2025-08-12 18:44:02  
**Message:**
```
add(docs): create new documents for research parameters and dataplot

- Added 'Dataplot-e2-aug12.docx' for data visualization.
- Introduced 'research_parameters_chart (5) (2).html' detailing updated research parameters with structured tables and calculated probabilities.
```
**Changed Files:**
- `docs/Dataplot-e2-aug12.docx`  
- `docs/research_parameters_aug12.html`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/9b8cf1b_20250812_184402_plot1.png)  
![](../plot_archive/9b8cf1b_20250812_184402_plot2.png)  

## Commit [7c13755](https://github.com/naszhu/REM_E3_model_fixed/commit/7c13755) (branch: `aug-11`)
**Time:** 2025-08-12 18:40:30  
**Message:**
```
add(docs): create new documents for research parameters and dataplot

- Added 'Dataplot-e2-aug12.docx' for data visualization.
- Introduced 'research_parameters_chart (5) (2).html' detailing updated research parameters with structured tables and calculated probabilities.
```
**Changed Files:**
- `docs/Dataplot-e2-aug12.docx`  
- `docs/research_parameters_chart (5) (2).html`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7c13755_20250812_184030_plot1.png)  
![](../plot_archive/7c13755_20250812_184030_plot2.png)  

## Commit [7c13755](https://github.com/naszhu/REM_E3_model_fixed/commit/7c13755) (branch: `aug-11`)
**Time:** 2025-08-12 18:40:30  
**Message:**
```
add(docs): create new documents for research parameters and dataplot

- Added 'Dataplot-e2-aug12.docx' for data visualization.
- Introduced 'research_parameters_chart (5) (2).html' detailing updated research parameters with structured tables and calculated probabilities.
```
**Changed Files:**
- `docs/Dataplot-e2-aug12.docx`  
- `docs/research_parameters_chart (5) (2).html`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7c13755_20250812_184030_plot1.png)  
![](../plot_archive/7c13755_20250812_184030_plot2.png)  

## Commit [7c13755](https://github.com/naszhu/REM_E3_model_fixed/commit/7c13755) (branch: `aug-11`)
**Time:** 2025-08-12 18:40:30  
**Message:**
```
add(docs): create new documents for research parameters and dataplot

- Added 'Dataplot-e2-aug12.docx' for data visualization.
- Introduced 'research_parameters_chart (5) (2).html' detailing updated research parameters with structured tables and calculated probabilities.
```
**Changed Files:**
- `docs/Dataplot-e2-aug12.docx`  
- `docs/research_parameters_chart (5) (2).html`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7c13755_20250812_184030_plot1.png)  
![](../plot_archive/7c13755_20250812_184030_plot2.png)  

## Commit [b21648e](https://github.com/naszhu/REM_E3_model_fixed/commit/b21648e) (branch: `aug-11`)
**Time:** 2025-08-11 20:06:11  
**Message:**
```
explore(model-e3): final test, a relative good v, but problems remain

- OI not bit enough

- BRANCH purpose: do more simulation for initial test and fine-tune final test
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b21648e_20250811_200611_plot1.png)  
![](../plot_archive/b21648e_20250811_200611_plot2.png)  

## Commit [9b09fa0](https://github.com/naszhu/REM_E3_model_fixed/commit/9b09fa0) (branch: `aug-11`)
**Time:** 2025-08-11 19:03:57  
**Message:**
```
finetune(model-e3): A 2000 simulation, good for initial test
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/9b09fa0_20250811_190357_plot1.png)  
![](../plot_archive/9b09fa0_20250811_190357_plot2.png)  

## Commit [4da5858](https://github.com/naszhu/REM_E3_model_fixed/commit/4da5858) (branch: `aug-11`)
**Time:** 2025-08-07 18:31:33  
**Message:**
```
merge(model-e3): Merge branch 'Aug-5-test'
```
![](../plot_archive/4da5858_20250807_183133_plot1.png)  
![](../plot_archive/4da5858_20250807_183133_plot2.png)  

## Commit [798fca7](https://github.com/naszhu/REM_E3_model_fixed/commit/798fca7) (branch: `main`)
**Time:** 2025-08-05 17:41:29  
**Message:**
```
merge(model-e3) Merge branch 'Aug-3-sideway-temp-try'

Because the eliminating doesn't work, I went back to this version

the .json files have been specially edited.  (added to include files changes from all prior commits). Added file changes from aug-3-sideway... branch becuase I can't just accept new neither just use old, so have to manually add them
```
![](../plot_archive/798fca7_20250805_174129_plot1.png)  
![](../plot_archive/798fca7_20250805_174129_plot2.png)  

## Commit [ea16e48](https://github.com/naszhu/REM_E3_model_fixed/commit/ea16e48) (branch: `Aug-5-test`)
**Time:** 2025-08-07 18:29:58  
**Message:**
```
explore(model-d3): puting threshold_recall = 0,

this makes within-list prediction worse
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/ea16e48_20250807_182958_plot1.png)  
![](../plot_archive/ea16e48_20250807_182958_plot2.png)  

## Commit [e215ede](https://github.com/naszhu/REM_E3_model_fixed/commit/e215ede) (branch: `Aug-5-test`)
**Time:** 2025-08-06 16:39:41  
**Message:**
```
fix(model-e3): Final test odds forgot to take 1/11
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/e215ede_20250806_163941_plot1.png)  
![](../plot_archive/e215ede_20250806_163941_plot2.png)  

## Commit [e7e0a7d](https://github.com/naszhu/REM_E3_model_fixed/commit/e7e0a7d) (branch: `Aug-5-test`)
**Time:** 2025-08-06 16:26:51  
**Message:**
```
finetune(model-e3): A good version?

- I thought the products that I sent is good.
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/e7e0a7d_20250806_162651_plot1.png)  
![](../plot_archive/e7e0a7d_20250806_162651_plot2.png)  

## Commit [0520676](https://github.com/naszhu/REM_E3_model_fixed/commit/0520676) (branch: `Aug-5-test`)
**Time:** 2025-08-05 17:55:05  
**Message:**
```
explore(model-e3): making rising rate for target to go fast than others.

- Branch details:  This branch is to test the 2-parameter ideas for switch basing on meeting log Aug-4
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/0520676_20250805_175505_plot1.png)  
![](../plot_archive/0520676_20250805_175505_plot2.png)  

## Commit [798fca7](https://github.com/naszhu/REM_E3_model_fixed/commit/798fca7) (branch: `Aug-5-test`)
**Time:** 2025-08-05 17:41:29  
**Message:**
```
merge(model-e3) Merge branch 'Aug-3-sideway-temp-try'

Because the eliminating doesn't work, I went back to this version

the .json files have been specially edited.  (added to include files changes from all prior commits). Added file changes from aug-3-sideway... branch becuase I can't just accept new neither just use old, so have to manually add them
```
![](../plot_archive/798fca7_20250805_174129_plot1.png)  
![](../plot_archive/798fca7_20250805_174129_plot2.png)  

## Commit [7ed5eb5](https://github.com/naszhu/REM_E3_model_fixed/commit/7ed5eb5) (branch: `main`)
**Time:** 2025-08-05 17:30:47  
**Message:**
```
restore(model-e3): restoring back to jul-17 branch becuase the elimination doesn't work

- The md files are not staged here (i.e., kept the history of explorations)
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/simulation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7ed5eb5_20250805_173047_plot1.png)  
![](../plot_archive/7ed5eb5_20250805_173047_plot2.png)  

## Commit [7f43080](https://github.com/naszhu/REM_E3_model_fixed/commit/7f43080) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 23:28:11  
**Message:**
```
fintune(model-e3): another test, raise recall_odds
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7f43080_20250803_232811_plot1.png)  
![](../plot_archive/7f43080_20250803_232811_plot2.png)  

## Commit [aa5cf49](https://github.com/naszhu/REM_E3_model_fixed/commit/aa5cf49) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 22:42:21  
**Message:**
```
finetune(model-e3): this may work even better
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/aa5cf49_20250803_224221_plot1.png)  
![](../plot_archive/aa5cf49_20250803_224221_plot2.png)  

## Commit [b687aab](https://github.com/naszhu/REM_E3_model_fixed/commit/b687aab) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 20:25:00  
**Message:**
```
finetune(model-e3): This seems to work well for now
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b687aab_20250803_202500_plot1.png)  
![](../plot_archive/b687aab_20250803_202500_plot2.png)  

## Commit [52972ed](https://github.com/naszhu/REM_E3_model_fixed/commit/52972ed) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 20:19:44  
**Message:**
```
explore(model-e3): increased proportion of unchanging contex t, seems to work well?
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/52972ed_20250803_201944_plot1.png)  
![](../plot_archive/52972ed_20250803_201944_plot2.png)  

## Commit [7a4bb1a](https://github.com/naszhu/REM_E3_model_fixed/commit/7a4bb1a) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 19:49:41  
**Message:**
```
explore(model-e3): trying making all 1/11 power, This shouldn't influence for now

Shouldn't influence for now becuase currently sampling already with 1/11 power,
and making odds to have 1/11 power is nothing that influences for now
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7a4bb1a_20250803_194941_plot1.png)  
![](../plot_archive/7a4bb1a_20250803_194941_plot2.png)  

## Commit [148c7f9](https://github.com/naszhu/REM_E3_model_fixed/commit/148c7f9) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 19:48:45  
**Message:**
```
explore(model-e3): trying making all 1/11 power, seems to work, maybe, needs fine=tuneing though to see better
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/148c7f9_20250803_194845_plot1.png)  
![](../plot_archive/148c7f9_20250803_194845_plot2.png)  

## Commit [a2c4b41](https://github.com/naszhu/REM_E3_model_fixed/commit/a2c4b41) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 19:44:35  
**Message:**
```
explore(model-e3): problem appears when making criterion_initial all the same
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/a2c4b41_20250803_194435_plot1.png)  
![](../plot_archive/a2c4b41_20250803_194435_plot2.png)  

## Commit [6440748](https://github.com/naszhu/REM_E3_model_fixed/commit/6440748) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 19:37:27  
**Message:**
```
explore(model-e3): ok, so the problem is recall_to_addtrace_treshold parameter?
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/6440748_20250803_193727_plot1.png)  
![](../plot_archive/6440748_20250803_193727_plot2.png)  

## Commit [77925a7](https://github.com/naszhu/REM_E3_model_fixed/commit/77925a7) (branch: `Aug-2-test`)
**Time:** 2025-08-03 19:30:42  
**Message:**
```
explore(model-e3): OK, turn down w_word doens't really work here, don't know why

See commits bf52d22
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/77925a7_20250803_193042_plot1.png)  
![](../plot_archive/77925a7_20250803_193042_plot2.png)  

## Commit [bf52d22](https://github.com/naszhu/REM_E3_model_fixed/commit/bf52d22) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-08-03 19:23:58  
**Message:**
```
explore(model-e3): OK found it would work when turn down the w_word value, go back to previous v and try
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/bf52d22_20250803_192358_plot1.png)  
![](../plot_archive/bf52d22_20250803_192358_plot2.png)  

## Commit [a951863](https://github.com/naszhu/REM_E3_model_fixed/commit/a951863) (branch: `Aug-2-test`)
**Time:** 2025-08-03 01:53:50  
**Message:**
```
feat(model-e3): Adding back 1/11 power

both for sampling and for odds taking
- this version is withiout a fine-tuining, this will be done next commit

Refs #37
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/probe_evaluation.jl`  
- `E3/simulation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/a951863_20250803_015350_plot1.png)  
![](../plot_archive/a951863_20250803_015350_plot2.png)  

## Commit [53c0b61](https://github.com/naszhu/REM_E3_model_fixed/commit/53c0b61) (branch: `Aug-2-test`)
**Time:** 2025-08-03 00:47:13  
**Message:**
```
merge(finetune): Eliminating prameters, Merge branch 'Aug-1-meeting-log-change'
```
![](../plot_archive/53c0b61_20250803_004713_plot1.png)  
![](../plot_archive/53c0b61_20250803_004713_plot2.png)  

## Commit [63b6f1e](https://github.com/naszhu/REM_E3_model_fixed/commit/63b6f1e) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-02 00:22:24  
**Message:**
```
finetune(model-e3): 1000 simulation that without product_f commented
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/63b6f1e_20250802_002224_plot1.png)  
![](../plot_archive/63b6f1e_20250802_002224_plot2.png)  

## Commit [00904ab](https://github.com/naszhu/REM_E3_model_fixed/commit/00904ab) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-02 00:18:15  
**Message:**
```
finetune(model-e3): 1000 simulation for above (version with product _F commented)
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/00904ab_20250802_001815_plot1.png)  
![](../plot_archive/00904ab_20250802_001815_plot2.png)  

## Commit [666cbc4](https://github.com/naszhu/REM_E3_model_fixed/commit/666cbc4) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-02 00:04:27  
**Message:**
```
finetune(model-e3): tried eliminating product prameter for F, while Go back HEAD~1 commit,

- eliminating that makes foil go down too much

Refs Log Meeting #46 point 5
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/666cbc4_20250802_000427_plot1.png)  
![](../plot_archive/666cbc4_20250802_000427_plot2.png)  

## Commit [5d404a5](https://github.com/naszhu/REM_E3_model_fixed/commit/5d404a5) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-02 00:04:07  
**Message:**
```
finetune(model-e3): tried eliminating product prameter for F, while Go back HEAD~1 commit,

- eliminating that makes foil go down too much

Refs Log Meeting #46 point 5
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/5d404a5_20250802_000407_plot1.png)  
![](../plot_archive/5d404a5_20250802_000407_plot2.png)  

## Commit [35ae1e8](https://github.com/naszhu/REM_E3_model_fixed/commit/35ae1e8) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-01 23:53:18  
**Message:**
```
finetune(model-e3): trade-off among criterions,  get 1s  test position good for Fb?

I don't relly know, can't get a good one

Refs trade-off naszhu/project-context/#14
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/35ae1e8_20250801_235318_plot1.png)  
![](../plot_archive/35ae1e8_20250801_235318_plot2.png)  

## Commit [d406a7f](https://github.com/naszhu/REM_E3_model_fixed/commit/d406a7f) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-01 23:19:54  
**Message:**
```
feat(model-e3): Eliminating one of the g parameter, and eliminate recall threshold

- Eliminated both because always need to asjust u* and the sets of parameters

- took away the const assignment for g_context and g_word

Refs Meeting Log #46 point 1, 2
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/d406a7f_20250801_231954_plot1.png)  
![](../plot_archive/d406a7f_20250801_231954_plot2.png)  

## Commit [7db7757](https://github.com/naszhu/REM_E3_model_fixed/commit/7db7757) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-01 22:47:56  
**Message:**
```
feat(model-e3): The recall threshold parameter

- I made a parameter recall_to_addtrace_treshold and so now when put this parameter as inf, it's like eliminating this. all that < odds +Inf will be

- changing this parameter doesn't influence the results too much, tuned the u* and criterion pramter only a little bit

Closes #48
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/7db7757_20250801_224756_plot1.png)  
![](../plot_archive/7db7757_20250801_224756_plot2.png)  

## Commit [fe1e5f3](https://github.com/naszhu/REM_E3_model_fixed/commit/fe1e5f3) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-01 22:36:58  
**Message:**
```
feat(model-e3): don't 1/11 power for sampling

- i am not sure if it works well, but I took out the criterion change parameter.

Refs #37 and Meeting-log #46 point 3
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/fe1e5f3_20250801_223658_plot1.png)  
![](../plot_archive/fe1e5f3_20250801_223658_plot2.png)  

## Commit [d3a2d15](https://github.com/naszhu/REM_E3_model_fixed/commit/d3a2d15) (branch: `Aug-1-meeting-log-change`)
**Time:** 2025-08-01 22:36:08  
**Message:**
```
feat(model-e3): don't 1/11 power for sampling

- i am not sure if it works well, but I took out the criterion change parameter.

Refs #37 and Meeting-log #46
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/d3a2d15_20250801_223608_plot1.png)  
![](../plot_archive/d3a2d15_20250801_223608_plot2.png)  

## Commit [c1abc04](https://github.com/naszhu/REM_E3_model_fixed/commit/c1abc04) (branch: `Aug-3-sideway-temp-try`)
**Time:** 2025-07-30 22:28:14  
**Message:**
```
merge(model-e3): Final Finetuning Merge branch 'jul-27-test'
```
![](../plot_archive/c1abc04_20250730_222814_plot1.png)  
![](../plot_archive/c1abc04_20250730_222814_plot2.png)  

## Commit [11f50cd](https://github.com/naszhu/REM_E3_model_fixed/commit/11f50cd) (branch: `jul-27-test`)
**Time:** 2025-07-29 23:41:35  
**Message:**
```
finetune(model-e3): 1000 simulations
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/11f50cd_20250729_234135_plot1.png)  
![](../plot_archive/11f50cd_20250729_234135_plot2.png)  

## Commit [dec9122](https://github.com/naszhu/REM_E3_model_fixed/commit/dec9122) (branch: `jul-27-test`)
**Time:** 2025-07-29 23:38:01  
**Message:**
```
finetune(model-e3): gosh have fine tuned to get the best one yet

Refs pattern-expoain #40
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/dec9122_20250729_233801_plot1.png)  
![](../plot_archive/dec9122_20250729_233801_plot2.png)  

## Commit [58c9594](https://github.com/naszhu/REM_E3_model_fixed/commit/58c9594) (branch: `jul-27-test`)
**Time:** 2025-07-29 23:13:15  
**Message:**
```
fix(model-e3): fixed a bug on context was reinstated even for first item (shouldn't be the case)
```
**Changed Files:**
- `E3/probe_generation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/58c9594_20250729_231315_plot1.png)  
![](../plot_archive/58c9594_20250729_231315_plot2.png)  

## Commit [36071b6](https://github.com/naszhu/REM_E3_model_fixed/commit/36071b6) (branch: `jul-27-test`)
**Time:** 2025-07-29 23:12:26  
**Message:**
```
finetnue(model-e3): tunning up, doesn't work exactly well, (with only context drift)

p_reinstate_rate = 0.15#0.4 #prob of reinstatement
n_driftStudyTest = round.(Int, ones(n_lists) * 15) #7
n_between_listchange = round.(Int, LinRange(18, 18, n_lists)); #5;15;

Refs pattern-expoain #40
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/36071b6_20250729_231226_plot1.png)  
![](../plot_archive/36071b6_20250729_231226_plot2.png)  

## Commit [5c74721](https://github.com/naszhu/REM_E3_model_fixed/commit/5c74721) (branch: `jul-27-test`)
**Time:** 2025-07-29 22:48:44  
**Message:**
```
feat(model-e3): within-list prediction, only use context drift between study and test, no criterion change

- Note: commented feature_update value p_reinstate_context for now, this is a techdebt and should be solved later.

n_driftStudyTest = 12
n_between_listchange= 18

Refs patter-explain  #40
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/5c74721_20250729_224844_plot1.png)  
![](../plot_archive/5c74721_20250729_224844_plot2.png)  

## Commit [9b16540](https://github.com/naszhu/REM_E3_model_fixed/commit/9b16540) (branch: `jul-27-test`)
**Time:** 2025-07-27 20:59:46  
**Message:**
```
finetune(model-e3): tuning for initial test
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/9b16540_20250727_205946_plot1.png)  
![](../plot_archive/9b16540_20250727_205946_plot2.png)  

## Commit [304c223](https://github.com/naszhu/REM_E3_model_fixed/commit/304c223) (branch: `jul-27-test`)
**Time:** 2025-07-27 00:38:15  
**Message:**
```
merge(model-e3): Merge branch 'jul-23-checkout-increase-strengthening' fine tunning strenghten
```
![](../plot_archive/304c223_20250727_003815_plot1.png)  
![](../plot_archive/304c223_20250727_003815_plot2.png)  

## Commit [16cfa3f](https://github.com/naszhu/REM_E3_model_fixed/commit/16cfa3f) (branch: `main`)
**Time:** 2025-07-23 17:02:24  
**Message:**
```
merge(model-e3): Merge branch 'jul-21-checkout'
```
![](../plot_archive/16cfa3f_20250723_170224_plot1.png)  
![](../plot_archive/16cfa3f_20250723_170224_plot2.png)  

## Commit [3dccf67](https://github.com/naszhu/REM_E3_model_fixed/commit/3dccf67) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-26 21:25:49  
**Message:**
```
finetune(model-e3): taking away the strenghten, finetuneing

- maybe needs a bit stronger for the strnehgtneing
```
**Changed Files:**
- `E3/R_plots_finalt.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/3dccf67_20250726_212549_plot1.png)  
![](../plot_archive/3dccf67_20250726_212549_plot2.png)  

## Commit [720d452](https://github.com/naszhu/REM_E3_model_fixed/commit/720d452) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-26 19:56:22  
**Message:**
```
fix(logscr-e3): .sh correct again on the json contents and so on
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/log_plot.sh`  
![](../plot_archive/720d452_20250726_195622_plot1.png)  
![](../plot_archive/720d452_20250726_195622_plot2.png)  

## Commit [57cedfe](https://github.com/naszhu/REM_E3_model_fixed/commit/57cedfe) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-26 19:55:37  
**Message:**
```
fix(logscr-e3): .sh correct again on the json contents and so on
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/log_plot.sh`  
![](../plot_archive/57cedfe_20250726_195537_plot1.png)  
![](../plot_archive/57cedfe_20250726_195537_plot2.png)  

## Commit [068a042](https://github.com/naszhu/REM_E3_model_fixed/commit/068a042) (branch: `jul-23-checkout-increase-strengthening`)
**Time:**   
**Message:**
```
fix(logscr-e3): .sh reflect LAST commit LAST plot rather than Last commit current plot

- ran a py file in plot_archive to change all file names
- copy store all plots to plot_archive after the commits for next use rather than before
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/log_plot.sh`  
![](../plot_archive/068a042_20250726_192901_plot1.png)  
![](../plot_archive/068a042_20250726_192901_plot2.png)  

## Commit [97ebbe3](https://github.com/naszhu/REM_E3_model_fixed/commit/97ebbe3) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-26 18:26:19  
**Message:**
```
explore(model-e3): Decrease Strenghten after fixed bug version

- decrease strenghten means go back to original strenghten but not more.
- this makes prediction in final green>blue (SO>F) , which is more aligned with data now
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/97ebbe3_20250726_182619_plot1.png)  
![](../plot_archive/97ebbe3_20250726_182619_plot2.png)  

## Commit [4b1eed4](https://github.com/naszhu/REM_E3_model_fixed/commit/4b1eed4) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-26 16:50:04  
**Message:**
```
explore(model-e3): A high number simulation 500 test
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/4b1eed4_20250726_165004_plot1.png)  
![](../plot_archive/4b1eed4_20250726_165004_plot2.png)  

## Commit [1de03ab](https://github.com/naszhu/REM_E3_model_fixed/commit/1de03ab) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-26 16:48:21  
**Message:**
```
fix(predplot-e3): Final Plot of SOn, Fn, Tn mistakenly put making linnig mistaken

Refs #25
```
**Changed Files:**
- `E3/R_plots_finalt.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/1de03ab_20250726_164821_plot1.png)  
![](../plot_archive/1de03ab_20250726_164821_plot2.png)  

## Commit [158dc43](https://github.com/naszhu/REM_E3_model_fixed/commit/158dc43) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-26 16:01:16  
**Message:**
```
fix(model-e3): A bug in feature restorage (strenghtening) function
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/158dc43_20250726_160116_plot1.png)  
![](../plot_archive/158dc43_20250726_160116_plot2.png)  

## Commit [890124b](https://github.com/naszhu/REM_E3_model_fixed/commit/890124b) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-24 21:36:02  
**Message:**
```
explore(model-e3): better strenghtening for 3 factors?

better u better c replace mismatches, doesn't work well though in raising final test predictions
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/890124b_20250724_213602_plot1.png)  
![](../plot_archive/890124b_20250724_213602_plot2.png)  

## Commit [3fcfc4c](https://github.com/naszhu/REM_E3_model_fixed/commit/3fcfc4c) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-24 20:49:59  
**Message:**
```
explore(model-e3): strenghten MORE? (higher c (1) for strenghtening
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/3fcfc4c_20250724_204959_plot1.png)  
![](../plot_archive/3fcfc4c_20250724_204959_plot2.png)  

## Commit [16cfa3f](https://github.com/naszhu/REM_E3_model_fixed/commit/16cfa3f) (branch: `jul-23-checkout-increase-strengthening`)
**Time:** 2025-07-23 17:02:24  
**Message:**
```
merge(model-e3): Merge branch 'jul-21-checkout'
```
![](../plot_archive/16cfa3f_20250723_170224_plot1.png)  
![](../plot_archive/16cfa3f_20250723_170224_plot2.png)  

## Commit [9e42d3b](https://github.com/naszhu/REM_E3_model_fixed/commit/9e42d3b) (branch: `main`)
**Time:** 2025-07-23 17:00:48  
**Message:**
```
merge(model-e3): Merge branch 'jul-17-add-finalT'
```
![](../plot_archive/9e42d3b_20250723_170048_plot1.png)  
![](../plot_archive/9e42d3b_20250723_170048_plot2.png)  

## Commit [1520aa8](https://github.com/naszhu/REM_E3_model_fixed/commit/1520aa8) (branch: `main`)
**Time:** 2025-07-21 00:01:15  
**Message:**
```
merge(model-e3): feature strenghtening trace. Merge branch 'jul-17-add-finalT'
```
![](../plot_archive/1520aa8_20250721_000115_plot1.png)  
![](../plot_archive/1520aa8_20250721_000115_plot2.png)  

## Commit [72825e6](https://github.com/naszhu/REM_E3_model_fixed/commit/72825e6) (branch: `main`)
**Time:** 2025-07-20 00:36:57  
**Message:**
```
merge(model-e3): A working V:  Merge branch 'jul-14-explore' into main
```
**Changed Files:**
- `.gitignore`  
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/probe_evaluation.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
![](../plot_archive/72825e6_20250720_003657_plot1.png)  
![](../plot_archive/72825e6_20250720_003657_plot2.png)  

## Commit [da048c7](https://github.com/naszhu/REM_E3_model_fixed/commit/da048c7) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 22:54:18  
**Message:**
```
feat(model-e3):  fine tune initial test within-list test position
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/da048c7_20250719_225418_plot1.png)  
![](../plot_archive/da048c7_20250719_225418_plot2.png)  

## Commit [afeed74](https://github.com/naszhu/REM_E3_model_fixed/commit/afeed74) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 21:53:37  
**Message:**
```
feat(model-e3):  Final test add trace when strengthen
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/afeed74_20250719_215337_plot1.png)  
![](../plot_archive/afeed74_20250719_215337_plot2.png)  

## Commit [aa64353](https://github.com/naszhu/REM_E3_model_fixed/commit/aa64353) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 21:36:11  
**Message:**
```
finettune(model-e3): fine tunning initial test alone with final test
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/aa64353_20250719_213611_plot1.png)  
![](../plot_archive/aa64353_20250719_213611_plot2.png)  

## Commit [c5ecefd](https://github.com/naszhu/REM_E3_model_fixed/commit/c5ecefd) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 20:35:59  
**Message:**
```
feat(model-e3): It  actually work? add new trace when strenghten
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/c5ecefd_20250719_203559_plot1.png)  
![](../plot_archive/c5ecefd_20250719_203559_plot2.png)  

## Commit [fee2e67](https://github.com/naszhu/REM_E3_model_fixed/commit/fee2e67) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 20:03:40  
**Message:**
```
explore(model-e3): take out context drift between study-test? doens't change final test prediction

- thought this made initial test within-list by test position narrows from that at the beggining
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/simulation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/fee2e67_20250719_200340_plot1.png)  
![](../plot_archive/fee2e67_20250719_200340_plot2.png)  

## Commit [4bff7f9](https://github.com/naszhu/REM_E3_model_fixed/commit/4bff7f9) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 20:02:35  
**Message:**
```
refactor(predplot-e3): refined the ylim a bit even better
```
**Changed Files:**
- `E3/R_plots.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/4bff7f9_20250719_200235_plot1.png)  
![](../plot_archive/4bff7f9_20250719_200235_plot2.png)  

## Commit [22eabe2](https://github.com/naszhu/REM_E3_model_fixed/commit/22eabe2) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 18:57:42  
**Message:**
```
finetune(model-e3): asypmotoptic on criterion_initial

(give back between list and study-test change)
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/22eabe2_20250719_185742_plot1.png)  
![](../plot_archive/22eabe2_20250719_185742_plot2.png)  

## Commit [6eb32d6](https://github.com/naszhu/REM_E3_model_fixed/commit/6eb32d6) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 18:49:19  
**Message:**
```
refactor(predplot-e3): make predplot within-list y limit the same with the data plot
```
**Changed Files:**
- `E3/R_plots.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/6eb32d6_20250719_184919_plot1.png)  
![](../plot_archive/6eb32d6_20250719_184919_plot2.png)  

## Commit [05dc0ef](https://github.com/naszhu/REM_E3_model_fixed/commit/05dc0ef) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 18:30:22  
**Message:**
```
finetune(model-e3): initial test within-list tuning - a relative good v but some problems to solve
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/main_JL_E3_V0.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/05dc0ef_20250719_183022_plot1.png)  
![](../plot_archive/05dc0ef_20250719_183022_plot2.png)  

## Commit [5b91d47](https://github.com/naszhu/REM_E3_model_fixed/commit/5b91d47) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 18:14:17  
**Message:**
```
refactor(predplot-e3): make the plot within-list, and color, point shape consistent
```
**Changed Files:**
- `E3/R_plots.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/5b91d47_20250719_181417_plot1.png)  
![](../plot_archive/5b91d47_20250719_181417_plot2.png)  

## Commit [0b7ce2b](https://github.com/naszhu/REM_E3_model_fixed/commit/0b7ce2b) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-19 15:24:51  
**Message:**
```
explore(model-e3): final test work well
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/0b7ce2b_20250719_152451_plot1.png)  
![](../plot_archive/0b7ce2b_20250719_152451_plot2.png)  

## Commit [5c3398d](https://github.com/naszhu/REM_E3_model_fixed/commit/5c3398d) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-18 00:36:57  
**Message:**
```
feat(model-e3): add back finat_test first v, not sure if works

Found problem of 1/11 at issue #39
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `plot2.png`  
![](../plot_archive/5c3398d_20250718_003657_plot1.png)  
![](../plot_archive/5c3398d_20250718_003657_plot2.png)  

## Commit [26697e2](https://github.com/naszhu/REM_E3_model_fixed/commit/26697e2) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-18 00:36:09  
**Message:**
```
feat(model-e3): add back finat_test first v, not sure if works

Found problem of 1/11 at issue #39
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `plot2.png`  
![](../plot_archive/26697e2_20250718_003609_plot1.png)  
![](../plot_archive/26697e2_20250718_003609_plot2.png)  

## Commit [26697e2](https://github.com/naszhu/REM_E3_model_fixed/commit/26697e2) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-18 00:35:53  
**Message:**
```
feat(model-e3): add back finat_test first v, not sure if works

Found problem of 1/11 at issue #39
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `E3/probe_generation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `plot2.png`  
![](../plot_archive/26697e2_20250718_003553_plot1.png)  
![](../plot_archive/26697e2_20250718_003553_plot2.png)  

## Commit [1a54d3e](https://github.com/naszhu/REM_E3_model_fixed/commit/1a54d3e) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-18 00:24:10  
**Message:**
```
feat(model-e3): add sampling_method choice

- changing the sampling method will make a little difference to Fb results (make it a bit lower, but shouldbe adjustable)

- if taking 1/11 power of the LL for the samppling, it changes a bit of the results but not much, seems acceptable (making the Fb to drop as well)

Refs #34
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/likelihood_calculations.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/1a54d3e_20250718_002410_plot1.png)  
![](../plot_archive/1a54d3e_20250718_002410_plot2.png)  

## Commit [56135a1](https://github.com/naszhu/REM_E3_model_fixed/commit/56135a1) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-18 00:04:19  
**Message:**
```
feat(model-e3): add sampling_method choice

- changing the sampling method will make a little difference to Fb results (make it a bit lower, but shouldbe adjustable)

Refs #34
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/likelihood_calculations.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/56135a1_20250718_000419_plot1.png)  
![](../plot_archive/56135a1_20250718_000419_plot2.png)  

## Commit [d0c4657](https://github.com/naszhu/REM_E3_model_fixed/commit/d0c4657) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-18 00:02:42  
**Message:**
```
feat(model-e3): add sampling_method choice

Refs #34
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/likelihood_calculations.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/d0c4657_20250718_000242_plot1.png)  
![](../plot_archive/d0c4657_20250718_000242_plot2.png)  

## Commit [1c5d950](https://github.com/naszhu/REM_E3_model_fixed/commit/1c5d950) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-18 00:01:53  
**Message:**
```
feat(model-e3): add sampling_method choice

Refs #34
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/likelihood_calculations.jl`  
- `E3/memory_restorage.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/1c5d950_20250718_000153_plot1.png)  
![](../plot_archive/1c5d950_20250718_000153_plot2.png)  

## Commit [b18039d](https://github.com/naszhu/REM_E3_model_fixed/commit/b18039d) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-17 23:14:46  
**Message:**
```
refactor(model-e3): likelihood calcualtion for initial test save more time (move some variable assign before for loop)
```
**Changed Files:**
- `E3/likelihood_calculations.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b18039d_20250717_231446_plot1.png)  
![](../plot_archive/b18039d_20250717_231446_plot2.png)  

## Commit [bb9023f](https://github.com/naszhu/REM_E3_model_fixed/commit/bb9023f) (branch: `jul-17-add-finalT`)
**Time:** 2025-07-17 22:53:02  
**Message:**
```
merge(model-e3): A working V:  Merge branch 'jul-14-explore' into save-uncleaned-messy-main
```
**Changed Files:**
- `.gitignore`  
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `E3/feature_updates.jl`  
- `E3/probe_evaluation.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
![](../plot_archive/bb9023f_20250717_225302_plot1.png)  
![](../plot_archive/bb9023f_20250717_225302_plot2.png)  

## Commit [e713c5f](https://github.com/naszhu/REM_E3_model_fixed/commit/e713c5f) (branch: `main`)
**Time:** 2025-07-17 19:46:04  
**Message:**
```
feat(logscr-e3): modiefied py and md to add log
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
![](../plot_archive/e713c5f_20250717_194604_plot1.png)  
![](../plot_archive/e713c5f_20250717_194604_plot2.png)  

## Commit [b2d6103](https://github.com/naszhu/REM_E3_model_fixed/commit/b2d6103) (branch: `jul-14-explore`)
**Time:** 2025-07-16 21:58:40  
**Message:**
```
finetune(model-e3): even better for others but bad for new foil
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b2d6103_20250716_215840_plot1.png)  
![](../plot_archive/b2d6103_20250716_215840_plot2.png)  

## Commit [5898072](https://github.com/naszhu/REM_E3_model_fixed/commit/5898072) (branch: `jul-14-explore`)
**Time:** 2025-07-16 19:44:56  
**Message:**
```
finetune(model-e3): so far the best parm values
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/5898072_20250716_194456_plot1.png)  
![](../plot_archive/5898072_20250716_194456_plot2.png)  

## Commit [b60bde6](https://github.com/naszhu/REM_E3_model_fixed/commit/b60bde6) (branch: `jul-14-explore`)
**Time:** 2025-07-16 19:43:21  
**Message:**
```
finetune(model-e3): so far the best parm values
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b60bde6_20250716_194321_plot1.png)  
![](../plot_archive/b60bde6_20250716_194321_plot2.png)  

## Commit [2b61c39](https://github.com/naszhu/REM_E3_model_fixed/commit/2b61c39) (branch: `jul-14-explore`)
**Time:** 2025-07-16 19:43:01  
**Message:**
```
finetune(model-e3): so far the best parm values
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/2b61c39_20250716_194301_plot1.png)  
![](../plot_archive/2b61c39_20250716_194301_plot2.png)  

## Commit [f0ade9f](https://github.com/naszhu/REM_E3_model_fixed/commit/f0ade9f) (branch: `jul-14-explore`)
**Time:** 2025-07-16 02:25:43  
**Message:**
```
fix(model-e3): ok, there is a mistake: forgot to assign Tn+1, which is current target as well
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/f0ade9f_20250716_022543_plot1.png)  
![](../plot_archive/f0ade9f_20250716_022543_plot2.png)  

## Commit [82ed94d](https://github.com/naszhu/REM_E3_model_fixed/commit/82ed94d) (branch: `jul-14-explore`)
**Time:** 2025-07-16 02:10:30  
**Message:**
```
explore(model-e3): A working v relatively
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/82ed94d_20250716_021030_plot1.png)  
![](../plot_archive/82ed94d_20250716_021030_plot2.png)  

## Commit [5fa0487](https://github.com/naszhu/REM_E3_model_fixed/commit/5fa0487) (branch: `jul-14-explore`)
**Time:** 2025-07-16 02:05:03  
**Message:**
```
explore(model-e3): ok, there actually are the rate difference and speed difference

sort of work? no but actually forgot to take out fact for list 1, will be chnaged next

Asympotote  issue refs #38
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/5fa0487_20250716_020503_plot1.png)  
![](../plot_archive/5fa0487_20250716_020503_plot2.png)  

## Commit [3bb22b4](https://github.com/naszhu/REM_E3_model_fixed/commit/3bb22b4) (branch: `HEAD`)
**Time:** 2025-07-16 01:48:07  
**Message:**
```
explore(model-e3): ok, there actually are the rate difference and speed difference

sort of work? no but actually forgot to take out fact for list 1, will be chnaged next

Asympotote  issue refs #38
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/3bb22b4_20250716_014807_plot1.png)  
![](../plot_archive/3bb22b4_20250716_014807_plot2.png)  

## Commit [dd92537](https://github.com/naszhu/REM_E3_model_fixed/commit/dd92537) (branch: `HEAD`)
**Time:** 2025-07-16 01:00:47  
**Message:**
```
explore(model-e3): get asumpotic increase, this works but i want to addd beta
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/dd92537_20250716_010047_plot1.png)  
![](../plot_archive/dd92537_20250716_010047_plot2.png)  

## Commit [bc6c7ab](https://github.com/naszhu/REM_E3_model_fixed/commit/bc6c7ab) (branch: `jul-14-explore`)
**Time:** 2025-07-16 00:59:30  
**Message:**
```
explore(model-e3):werid the generate functions why?
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `E3/utils.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/bc6c7ab_20250716_005930_plot1.png)  
![](../plot_archive/bc6c7ab_20250716_005930_plot2.png)  

## Commit [f8b3b23](https://github.com/naszhu/REM_E3_model_fixed/commit/f8b3b23) (branch: `jul-14-explore`)
**Time:** 2025-07-16 00:10:44  
**Message:**
```
explore(model-e3): make z and w into product
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/f8b3b23_20250716_001044_plot1.png)  
![](../plot_archive/f8b3b23_20250716_001044_plot2.png)  

## Commit [fa6d486](https://github.com/naszhu/REM_E3_model_fixed/commit/fa6d486) (branch: `jul-14-explore`)
**Time:** 2025-07-15 22:12:13  
**Message:**
```
explore(model-e3): make to see only list 1 and 2, add n_simulation

z4_T = 0.25 #prob of switch from familiarity to recall of list origin for target in initial test
z1_SOn = 0.3
z2_Fn = 0.9
z3_Tn = 0.7

p_new_with_ListOrigin_SOn = 0.65
p_new_with_ListOrigin_Fn = 0.45
p_new_with_ListOrigin_Tn = 0.5 #PO++ (prior target have lowest-make sense)
p_new_with_ListOrigin_T = 0.3 Good valu e now 0.71, 0.5, 0.5 + the z last one was mistaken now good
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/fa6d486_20250715_221213_plot1.png)  
![](../plot_archive/fa6d486_20250715_221213_plot2.png)  

## Commit [560590c](https://github.com/naszhu/REM_E3_model_fixed/commit/560590c) (branch: `jul-14-explore`)
**Time:** 2025-07-15 01:24:24  
**Message:**
```
explore(model-e3): make to see only list 1 and 2, add n_simulation

z4_T = 0.25 #prob of switch from familiarity to recall of list origin for target in initial test
z1_SOn = 0.3
z2_Fn = 0.9
z3_Tn = 0.7

p_new_with_ListOrigin_SOn = 0.65
# p_new_with_ListOrigin_Tn_Fn = 0.5 #PO+
p_new_with_ListOrigin_Fn = 0.45
p_new_with_ListOrigin_Tn = 0.5 #PO++ (prior target have lowest-make sense)
p_new_with_ListOrigin_T = 0.3 Good valu e now 0.71, 0.5, 0.5 + the z last one was mistaken now good
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/560590c_20250715_012424_plot1.png)  
![](../plot_archive/560590c_20250715_012424_plot2.png)  

## Commit [a267390](https://github.com/naszhu/REM_E3_model_fixed/commit/a267390) (branch: `jul-14-explore`)
**Time:** 2025-07-15 01:24:08  
**Message:**
```
explore(model-e3): make to see only list 1 and 2, add n_simulation

z4_T = 0.25 #prob of switch from familiarity to recall of list origin for target in initial test
z1_SOn = 0.3
z2_Fn = 0.9
z3_Tn = 0.7

p_new_with_ListOrigin_SOn = 0.65
# p_new_with_ListOrigin_Tn_Fn = 0.5 #PO+
p_new_with_ListOrigin_Fn = 0.45
p_new_with_ListOrigin_Tn = 0.5 #PO++ (prior target have lowest-make sense)
p_new_with_ListOrigin_T = 0.3 Good valu e now 0.71, 0.5, 0.5 + the z last one was mistaken now good
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/a267390_20250715_012408_plot1.png)  
![](../plot_archive/a267390_20250715_012408_plot2.png)  

## Commit [1900109](https://github.com/naszhu/REM_E3_model_fixed/commit/1900109) (branch: `jul-14-explore`)
**Time:** 2025-07-15 01:02:44  
**Message:**
```
explore(model-e3): make to see only list 1 and 2, add n_simulation

z4_T = 0.25 #prob of switch from familiarity to recall of list origin for target in initial test
z1_SOn = 0.3
z2_Fn = 0.9
z3_Tn = 0.7

p_new_with_ListOrigin_SOn = 0.65
# p_new_with_ListOrigin_Tn_Fn = 0.5 #PO+
p_new_with_ListOrigin_Fn = 0.45
p_new_with_ListOrigin_Tn = 0.5 #PO++ (prior target have lowest-make sense)
p_new_with_ListOrigin_T = 0.3 Good valu e now 0.71, 0.5, 0.5 + the z
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/1900109_20250715_010244_plot1.png)  
![](../plot_archive/1900109_20250715_010244_plot2.png)  

## Commit [2ad28e0](https://github.com/naszhu/REM_E3_model_fixed/commit/2ad28e0) (branch: `jul-14-explore`)
**Time:** 2025-07-15 00:50:23  
**Message:**
```
explore(model-e3): make to see only list 1 and 2, add n_simulation

z4_T = 0.25 #prob of switch from familiarity to recall of list origin for target in initial test
z1_SOn = 0.3
z2_Fn = 0.9
z3_Tn = 0.7

p_new_with_ListOrigin_SOn = 0.65
# p_new_with_ListOrigin_Tn_Fn = 0.5 #PO+
p_new_with_ListOrigin_Fn = 0.45
p_new_with_ListOrigin_Tn = 0.5 #PO++ (prior target have lowest-make sense)
p_new_with_ListOrigin_T = 0.3
```
**Changed Files:**
- `E3/R_plots.r`  
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/2ad28e0_20250715_005023_plot1.png)  
![](../plot_archive/2ad28e0_20250715_005023_plot2.png)  

## Commit [b85c5ad](https://github.com/naszhu/REM_E3_model_fixed/commit/b85c5ad) (branch: `jul-14-explore`)
**Time:** 2025-07-15 00:33:46  
**Message:**
```
explore(model-e3): p-switch remake, and p_switch not vary by list for now to see reults

- If the trace is a present list target, the prob of a switch from familiarity is z4; with prob 1-z4 familiarity is used and an OLD response is made. If a switch is made (p = z4) then the response made will be NEW with prob w4 and OLD otherwise.
- If the trace is a study-only confusing foil, then a switch is made with prob z1 and if switched the prob of NEW is w1, otherwise the response is OLD. (I assume these probabilities are low).
- If the trace is a test-only confusing foil, then a switch is made with prob z2 and if switched the prob of NEW is w2, otherwise the response is OLD. (I assume these probabilities are substantial).
- If the trace is a study-test confusing foil, then a switch is made with prob z3 and if switched the prob of NEW is w3, otherwise the response is OLD. (I assume these probabilities are substantial. possibly higher than z2 and w2)
```
**Changed Files:**
- `E3/constants.jl`  
- `E3/probe_evaluation.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/b85c5ad_20250715_003346_plot1.png)  
![](../plot_archive/b85c5ad_20250715_003346_plot2.png)  

## Commit [5d12d4d](https://github.com/naszhu/REM_E3_model_fixed/commit/5d12d4d) (branch: `jul-14-explore`)
**Time:** 2025-07-15 00:09:00  
**Message:**
```
explore(model-e3): replacing missing only during strenghtren last version not exactly correct, now the true amend
```
**Changed Files:**
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/5d12d4d_20250715_000900_plot1.png)  
![](../plot_archive/5d12d4d_20250715_000900_plot2.png)  

## Commit [d5a0f20](https://github.com/naszhu/REM_E3_model_fixed/commit/d5a0f20) (branch: `jul-14-explore`)
**Time:** 2025-07-15 00:06:27  
**Message:**
```
explore(model-e3): replacing missing only during strenghtren
```
**Changed Files:**
- `E3/feature_updates.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/d5a0f20_20250715_000627_plot1.png)  
![](../plot_archive/d5a0f20_20250715_000627_plot2.png)  

## Commit [b6de0fc](https://github.com/naszhu/REM_E3_model_fixed/commit/b6de0fc) (branch: `jul-14-explore`)
**Time:** 2025-07-15 00:04:44  
**Message:**
```
fix(logscr-e3): somehow last v doesn't work well, restore to head~1 and will do that later -recall-odds = 0.3 -recall-odds = 0.3
```
**Changed Files:**
- `E3/constants.jl`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/update_plot_log.py`  
![](../plot_archive/b6de0fc_20250715_000444_plot1.png)  
![](../plot_archive/b6de0fc_20250715_000444_plot2.png)  

## Commit [73bfb75](https://github.com/naszhu/REM_E3_model_fixed/commit/73bfb75) (branch: `jul-14-explore`)
**Time:** 2025-07-14 23:39:51  
**Message:**
```
fix(logscr-e3): somehow last v doesn't work well, restore to head~1 and will do that later -recall-odds = 0.3
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/update_plot_log.py`  
![](../plot_archive/73bfb75_20250714_233951_plot1.png)  
![](../plot_archive/73bfb75_20250714_233951_plot2.png)  

## Commit [a12187b](https://github.com/naszhu/REM_E3_model_fixed/commit/a12187b) (branch: `jul-14-explore`)
**Time:** 2025-07-14 23:29:10  
**Message:**
```
fix(logscr-e3): somehow last v doesn't work well, restore to head~1 and will do that later
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/update_plot_log.py`  
![](../plot_archive/a12187b_20250714_232910_plot1.png)  
![](../plot_archive/a12187b_20250714_232910_plot2.png)  

## Commit [4c30c12](https://github.com/naszhu/REM_E3_model_fixed/commit/4c30c12) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 19:48:19  
**Message:**
```
feat(logscr-e3): make the script to include body message and the html file to look pretty
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/update_plot_log.py`  
![](../plot_archive/4c30c12_20250714_194819_plot1.png)  
![](../plot_archive/4c30c12_20250714_194819_plot2.png)  

## Commit [ef14fac](https://github.com/naszhu/REM_E3_model_fixed/commit/ef14fac) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 19:47:46  
**Message:**
```
fix(logscr-e3): add commit message body on top of the head
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
![](../plot_archive/ef14fac_20250714_194746_plot1.png)  
![](../plot_archive/ef14fac_20250714_194746_plot2.png)  

## Commit [a77fcd7](https://github.com/naszhu/REM_E3_model_fixed/commit/a77fcd7) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 02:20:09  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
-when pSOn = 0.45 its not that weird but ....
-when pSO=0.45, p_listorigin 0.5 to 0.5, it looks - it drops very low at list 2 for target Hits -m p-switch 0.1 to 0.5, pold=0.64, look better but still lots discripancy among the 3 CFs -m make pSOn to 0.35 will change all Fbs, (Why? only becuase its caused by restorage makes this possible), raise 2 Fb
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
![](../plot_archive/a77fcd7_20250714_022009_plot1.png)  
![](../plot_archive/a77fcd7_20250714_022009_plot2.png)  

## Commit [a77fcd7](https://github.com/naszhu/REM_E3_model_fixed/commit/a77fcd7) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 02:11:41  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
-when pSOn = 0.45 its not that weird but ....
-when pSO=0.45, p_listorigin 0.5 to 0.5, it looks - it drops very low at list 2 for target Hits -m p-switch 0.1 to 0.5, pold=0.64, look better but still lots discripancy among the 3 CFs -m make pSOn to 0.35 will change all Fbs, (Why? only becuase its caused by restorage makes this possible), raise 2 Fb
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
![](../plot_archive/a77fcd7_20250714_021141_plot1.png)  
![](../plot_archive/a77fcd7_20250714_021141_plot2.png)  

## Commit [ebba4b0](https://github.com/naszhu/REM_E3_model_fixed/commit/ebba4b0) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 02:08:39  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
-when pSOn = 0.45 its not that weird but ....
-when pSO=0.45, p_listorigin 0.5 to 0.5, it looks - it drops very low at list 2 for target Hits -m p-switch 0.1 to 0.5, pold=0.64, look better but still lots discripancy among the 3 CFs
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
![](../plot_archive/ebba4b0_20250714_020839_plot1.png)  
![](../plot_archive/ebba4b0_20250714_020839_plot2.png)  

## Commit [4e0e83e](https://github.com/naszhu/REM_E3_model_fixed/commit/4e0e83e) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:53:45  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
-when pSOn = 0.45 its not that weird but ....
-when pSO=0.45, p_listorigin 0.5 to 0.5, it looks - it drops very low at list 2 for target Hits
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
![](../plot_archive/4e0e83e_20250714_015345_plot1.png)  
![](../plot_archive/4e0e83e_20250714_015345_plot2.png)  

## Commit [4e0e83e](https://github.com/naszhu/REM_E3_model_fixed/commit/4e0e83e) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:51:04  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
-when pSOn = 0.45 its not that weird but ....
-when pSO=0.45, p_listorigin 0.5 to 0.5, it looks - it drops very low at list 2 for target Hits
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
![](../plot_archive/4e0e83e_20250714_015104_plot1.png)  
![](../plot_archive/4e0e83e_20250714_015104_plot2.png)  

## Commit [bf2fab8](https://github.com/naszhu/REM_E3_model_fixed/commit/bf2fab8) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:46:11  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
-when pSOn = 0.45 its not that weird but ....
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
![](../plot_archive/bf2fab8_20250714_014611_plot1.png)  
![](../plot_archive/bf2fab8_20250714_014611_plot2.png)  

## Commit [a5a9228](https://github.com/naszhu/REM_E3_model_fixed/commit/a5a9228) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:42:33  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
![](../plot_archive/a5a9228_20250714_014233_plot1.png)  
![](../plot_archive/a5a9228_20250714_014233_plot2.png)  

## Commit [af2c4f0](https://github.com/naszhu/REM_E3_model_fixed/commit/af2c4f0) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:42:12  
**Message:**
```
fix(logscr-e3): re-fix the file address of the pictures missded "../"

forgot to commit one file
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_md_from_json.py`  
![](../plot_archive/af2c4f0_20250714_014212_plot1.png)  
![](../plot_archive/af2c4f0_20250714_014212_plot2.png)  

## Commit [570bd9b](https://github.com/naszhu/REM_E3_model_fixed/commit/570bd9b) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:40:43  
**Message:**
```
fix(predplot-e3): make the predplot within-list back to that for all lists

- commetned filter listnumber==1
- x-axis grouping not for 200 items but for 30 items (3 items per break)
{-n when p_}
-when p(list origin SOn) 0.75, the curve for SOn will go reverse direction
```
**Changed Files:**
- `E3/R_plots.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/570bd9b_20250714_014043_plot1.png)  
![](../plot_archive/570bd9b_20250714_014043_plot2.png)  

## Commit [d17d5f2](https://github.com/naszhu/REM_E3_model_fixed/commit/d17d5f2) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:40:01  
**Message:**
```
fix(predplot-e3): make the predplot within-list back to that for all lists

- commetned filter listnumber==1
- x-axis grouping not for 200 items but for 30 items (3 items per break)
{-n when p_}
```
**Changed Files:**
- `E3/R_plots.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/d17d5f2_20250714_014001_plot1.png)  
![](../plot_archive/d17d5f2_20250714_014001_plot2.png)  

## Commit [096f799](https://github.com/naszhu/REM_E3_model_fixed/commit/096f799) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:36:21  
**Message:**
```
fix(predplot-e3): make the predplot within-list back to that for all lists

- commetned filter listnumber==1
- x-axis grouping not for 200 items but for 30 items (3 items per break)
```
**Changed Files:**
- `E3/R_plots.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/096f799_20250714_013621_plot1.png)  
![](../plot_archive/096f799_20250714_013621_plot2.png)  

## Commit [638959c](https://github.com/naszhu/REM_E3_model_fixed/commit/638959c) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:35:49  
**Message:**
```
fix(predplot-e3): make the predplot within-list back to that for all lists

- commetned filter listnumber==1
- x-axis grouping not for 200 items but for 30 items (3 items per break)
```
**Changed Files:**
- `E3/R_plots.r`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
![](../plot_archive/638959c_20250714_013549_plot1.png)  
![](../plot_archive/638959c_20250714_013549_plot2.png)  

## Commit [ac499fb](https://github.com/naszhu/REM_E3_model_fixed/commit/ac499fb) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:26:45  
**Message:**
```
fix(logscr-e3): the file address of the pictures missded "../"
```
**Changed Files:**
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/log_plot.sh`  
![](../plot_archive/ac499fb_20250714_012645_plot1.png)  
![](../plot_archive/ac499fb_20250714_012645_plot2.png)  

## Commit [480fea3](https://github.com/naszhu/REM_E3_model_fixed/commit/480fea3) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:25:28  
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/480fea3_20250714_012528_plot1.png)  
![](../plot_archive/480fea3_20250714_012528_plot2.png)  

## Commit [480fea3](https://github.com/naszhu/REM_E3_model_fixed/commit/480fea3) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:24:08  
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/480fea3_20250714_012408_plot1.png)  
![](../plot_archive/480fea3_20250714_012408_plot2.png)  

## Commit [480fea3](https://github.com/naszhu/REM_E3_model_fixed/commit/480fea3) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:23:29  
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/480fea3_20250714_012329_plot1.png)  
![](../plot_archive/480fea3_20250714_012329_plot2.png)  

## Commit [480fea3](https://github.com/naszhu/REM_E3_model_fixed/commit/480fea3) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-14 01:22:20  
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/480fea3_20250714_012220_plot1.png)  
![](../plot_archive/480fea3_20250714_012220_plot2.png)  

## Commit [480fea3](https://github.com/naszhu/REM_E3_model_fixed/commit/480fea3) (branch: `save-uncleaned-messy-main`)
**Time:** ../plot_archive/480fea3_20250714_011936_plot1.png  
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/480fea3_20250714_011936_plot1.png)  
![](../plot_archive/480fea3_20250714_011936_plot2.png)  

## Commit [480fea3](https://github.com/naszhu/REM_E3_model_fixed/commit/480fea3) (branch: `save-uncleaned-messy-main`)
**Time:** 2025-07-12 00:13:37  
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/480fea3_20250712_001337_plot1.png)  
![](../plot_archive/480fea3_20250712_001337_plot2.png)  

## Commit [0064b1a](https://github.com/naszhu/REM_E3_model_fixed/commit/0064b1a) (branch: `main`)
**Time:** 2025-07-12 00:12:52  
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/0064b1a_20250712_001252_plot1.png)  
![](../plot_archive/0064b1a_20250712_001252_plot2.png)  

## Commit [8d3f94a](https://github.com/naszhu/REM_E3_model_fixed/commit/8d3f94a) (branch: `main`)
**Time:**   
**Message:**
```
feat(all): add log .md and html automatic tracking for each time of predplots in commits

- NOTE: add pre-commit automatic run, not post-commit
- currently is ignoring the plots so won't be able to see the html nor see the plots
```
**Changed Files:**
- `.gitignore`  
- `log/model_progress.html`  
- `log/model_progress.json`  
- `log/model_progress.md`  
- `scripts/generate_html_from_json.py`  
- `scripts/generate_md_from_json.py`  
- `scripts/log_plot.sh`  
- `scripts/update_plot_log.py`  
![](../plot_archive/8d3f94a__plot1.png)  
![](../plot_archive/8d3f94a__plot2.png)  

