# REM_E3_model_fixed

This repository contains the core modeling code for Experiment 3 (E3) of the `project-context` research. It focuses on the implementation, simulation, and analysis of the E3 model.

## 🔗 Parent Repository

This is a child repository of the main `project-context` repository. For overall project documentation, experimental design details, and other related materials, please refer to the [project-context](https://github.com/naszhu/project-context) repository. *(Please replace `https://github.com/naszhu/project-context` with the actual URL to your parent repository if it's different or you want to link it directly).*

## 🎯 Purpose

The primary purpose of this repository is to house the development and versioning of the computational model for Experiment 3. This includes:
* Julia scripts for model implementation and simulation.
* R scripts for data analysis and plotting of model outputs.
* Supporting files and data relevant to the E3 model.

## 💻 Tech Stack

* **Primary Language:** Julia (for core modeling and simulation)
* **Secondary Language:** R (for data analysis and visualization)

## 📂 Repository Structure

The main working directory for the E3 model is the `E3/` folder.

* **`E3/`**: Contains all core files for the Experiment 3 model.
    * `main_JL_E3_V0.jl`: Main Julia script for running the E3 model simulations.
    * `*.jl`: Various Julia modules and scripts for different components of the model (e.g., `constants.jl`, `data_structures.jl`, `feature_generation.jl`, `simulation.jl`, `probe_evaluation.jl`, etc.).
    * `R_plots.r`, `R_plots_finalt.r`: R scripts for generating plots and analyses from the model output.
    * `LOG.txt`: Log file, likely for tracking simulation runs or debugging.
    * Other supporting files.
* **`.github/ISSUE_TEMPLATE/`**: Contains templates for reporting issues.
* **`.gitignore`**: Specifies intentionally untracked files that Git should ignore (e.g., large CSV files).
* **`DF.csv`**: Example or output data file.
* **`Rplots.pdf`, `plot1.png`, `plot2.png`**: Example plot outputs.

All development and commits are currently pushed to the `main` branch.

## 🚀 Getting Started

*(You might want to add specific instructions here on how to set up the environment, install dependencies, and run the model or analysis scripts. For example:)*

1.  **Prerequisites:**
    * Julia (specify version, e.g., v1.10 as seen in parent repo context)
    * R (specify version)
    * Required Julia packages (list them if known, or mention a `Project.toml` / `Manifest.toml` if used)
    * Required R packages (list them if known)
2.  **Running the Model:**
    ```bash
    # Example: Navigate to the E3 directory and run the main Julia script
    cd E3
    julia main_JL_E3_V0.jl
    ```
3.  **Running Analysis:**
    ```R
    # Example: Open R and source the analysis script
    # source("E3/R_plots.r")
    ```

## ©️ Commit Style Convention

This repository follows the same commit style convention as the parent `project-context` repository:
**`type(scope): message`**

Examples:
* `refactor(model-d3): add content c change as well`
* `feat(model-e3): a working v. Final Test Sim work as well`
* `test(model-e3): add back predplot`

## 🐛 Issue Tracking

Issues are tracked using GitHub Issues. Please use the provided templates in `.github/ISSUE_TEMPLATE/` when creating new issues.

There are currently many valuable [open issues](https://github.com/naszhu/REM_E3_model_fixed/issues) in this repository, highlighting ongoing development areas and potential improvements. *(Please replace `https://github.com/naszhu/REM_E3_model_fixed/issues` with the actual URL to your issues page).*

## 🏷️ Versioning and Releases

* While active development and all commits are currently pushed to the `main` branch, this repository also utilizes [tags](https://github.com/naszhu/REM_E3_model_fixed/tags) to mark specific, ready-to-run versions of the model (e.g., `v0.1`, `v0.2`, `v0.3`, `v0.4`). *(Please replace `https://github.com/naszhu/REM_E3_model_fixed/tags` with the actual URL to your tags page).*
* Stable, runnable versions of the experiment will continue to be tagged and published as releases here.

## 🤝 Contributing

*(You can add guidelines for contributing if you expect others to contribute to this repository).*

---

*This README was generated based on the information available. Please review and update it with more specific details as needed.*
