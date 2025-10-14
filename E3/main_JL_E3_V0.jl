#= ===========================================================================================================
Author      : Shuchun (Lea) Lai
Date        : 2024-04-29, modified from 6-3-1!
Description :



=========================================================================================================== =#


# using RCall
# R"""
# # Add X11 font path in-session
# system("xset +fp /usr/share/fonts/X11/75dpi")
# system("xset fp rehash")
# """

# R"""
# library("ggplot2")
# ggplot(data.frame(x=1:10, y=1:10), aes(x=x, y=y)) + geom_point()

# # X11.options()
# """

# using Pkg
# Pkg.add([ "Random", "Distributions","Statistics", "DataFrames", "DataFramesMeta","BenchmarkTools", "ProfileView", "Profile", "QuadGK"])
# Pkg.add("RCall")
using Random, Distributions, Statistics, DataFrames, DataFramesMeta
# using RCall
using BenchmarkTools, ProfileView, Profile, Base.Threads
using QuadGK
# Performance optimization packages
# using StaticArrays  # For fixed-size arrays with no allocations
JULIA_NUM_THREADS=20 #julia
Threads.nthreads()

include("data_structures.jl")
include("utils.jl")
include("constants.jl") 
# recall_odds_threshold = 1e5;

# println("prob of each feature change between list $(1-(1-p_driftAndListChange)^n_between_listchange[1])")
# println("prob of each feature drift between study and test $(1-(1-p_driftAndListChange)^n_driftStudyTest[1])")
# aa = (1 - (1 - p_driftAndListChange)^n_between_listchange[1]);
# println("prob of feature change after 4 lists $(1-(1-aa)^8)")
# println("prob of each all features had reinstate after 3 $(1-(1-p_reinstate_rate)^3)")


a = [1 1 1; 1 1 1]

include("feature_updates.jl")
include("feature_origin.jl")

include("feature_generation.jl")

include("likelihood_calculations.jl")

include("memory_storage.jl")
include("memory_restorage.jl")

include("probe_generation.jl")
include("probe_evaluation.jl")

include("simulation.jl")
# @benchmark simulate_rem()

all_results, allresf = simulate_rem()
# all_results 
DF = @chain all_results begin
    @by([:list_number, :is_target, :testpos, :simulation_number,:type_general,:type_specific], :meanx = mean(:decision_isold))
    @by([:list_number, :is_target, :testpos,:type_general,:type_specific], :meanx = mean(:meanx))
end

if is_finaltest
    DFf = @chain allresf begin
        @by([:list_number, :is_target, :test_position, :condition, :simulation_number], :meanx = mean(:decision_isold))
        @by([:list_number, :is_target, :test_position, :condition], :meanx = mean(:meanx))
        @transform(:condition = string.(:condition))
    end



    allresf = @chain allresf begin
        @transform(:condition = string.(:condition))
    end
end


@chain allresf begin
    # @by([:list_number, :type_general], :meanx = mean(:decision_isold))
    @by([:type_general], :meanx = mean(:decision_isold))
    # @by([:list_number, :is_target, :test_position, :condition], :meanx = mean(:meanx))
    # @transform(:condition = string.(:condition))
end

# DFf
# using CSV
# CSV.write("temp.csv", DF)

# using RCall
# R"""
# library(ggplot2)
# ggplot()

# It is a good practice to modularize your code for better readability, maintainability, and reusability. Here's how you can organize your code:

# 1. **Separate Julia Functions into Modules/Files**:
#    - Group related functions into separate files. For example:
#      - `data_structures.jl`: Define your `Word`, `EpisodicImage`, and `Probe` structs.
#      - `feature_generation.jl`: Functions like `generate_features`, `generate_study_list`, etc.
#      - `likelihood_calculations.jl`: Functions like `calculate_likelihood_ratio`, `calculate_two_step_likelihoods`, etc.
#      - `probe_generation.jl`: Functions like `generate_probes`, `generate_finalt_probes`, etc.
#      - `simulation.jl`: Functions like `simulate_rem`.

#    - Then, include these files in your main script using `include`.

# 2. **Handle RCall Separately**:
#    - Since the R code might change frequently, you can keep it in a separate file (e.g., `rcall_visualizations.jl`) and include it in your main script.
#    - Alternatively, if the R code is highly dynamic and specific to each version, you can keep it in the main script but clearly separate it from the Julia code.

# Example Directory Structure:
# ```
# /model/
# ├── data_structures.jl
# ├── feature_generation.jl
# ├── likelihood_calculations.jl
# ├── probe_generation.jl
# ├── simulation.jl
# ├── rcall_visualizations.jl
# └── main.jl
# ```

# Example `rcall_visualizations.jl`:
# using RCall

# In your main script, you can call this function after running the simulation:
# include("rcall_visualizations.jl")
# plot_initial_test_results(all_results)
# """
DF

using DataFrames, CSV
csv_path1 = "DF.csv"
csv_path2 = "all_results.csv"
csv_path3 = "allresf.csv"
CSV.write(csv_path1, DF)
CSV.write(csv_path2, all_results)

# println(pwd())
# run(`bash -c "feh plot1.png &"`)
# run(`xdg-open plot1.png`)
# Using eog (Eye of GNOME, a lightweight image viewer):
run(`Rscript E3/R_plots.r`)
run(`bash -c "eog plot1.png & disown"`)

if is_finaltest
    CSV.write(csv_path3, allresf)
    run(`Rscript E3/R_plots_finalt.r`)
    # run(`bash -c "feh plot2.png &"`)
    run(`bash -c "eog plot2.png & disown"`)
end



# all_results[all_results.list_number.!==all_results.ilist_image,:]