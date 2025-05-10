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
using RCall
using BenchmarkTools, ProfileView, Profile, Base.Threads
using QuadGK
Threads.nthreads()
# JULIA_NUM_THREADS=8 julia



include("constants.jl") 
# recall_odds_threshold = 1e5;

println("prob of each feature change between list $(1-(1-p_driftAndListChange)^n_between_listchange)")
println("prob of each feature drift between study and test $(1-(1-p_driftAndListChange)^n_driftStudyTest[1])")
aa = (1 - (1 - p_driftAndListChange)^n_between_listchange);
println("prob of feature change after 4 lists $(1-(1-aa)^8)")
println("prob of each all features had reinstate after 3 $(1-(1-p_reinstate_rate)^3)")


a = [1 1 1; 1 1 1]
include("utils.jl")

include("feature_updates.jl")
include("data_structures.jl")

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
    @by([:list_number, :is_target, :test_position, :simulation_number], :meanx = mean(:decision_isold))
    @by([:list_number, :is_target, :test_position], :meanx = mean(:meanx))
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
using RCall

function plot_initial_test_results(all_results)
    @rput all_results
    R"""
    library(dplyr)
    library(ggplot2)

    df1 = all_results %>%
        mutate(is_target = case_when(is_target ~ 1, TRUE ~ 0),
               correct = decision_isold == is_target) %>%
        group_by(test_position, is_target, simulation_number) %>%
        summarize(meanx = mean(correct)) %>%
        group_by(test_position, is_target) %>%
        summarize(meanx = mean(meanx)) %>%
        mutate(is_target = as.factor(is_target)) %>%
        group_by(test_position) %>%
        mutate(meanx_m = mean(meanx))

    ggplot(data = df1, aes(x = test_position, y = meanx, group = is_target)) +
        geom_line(aes(color = is_target), size = 1.5) +
        geom_line(aes(x = test_position, y = meanx_m), color = "black", size = 1.5) +
        geom_point() +
        ylim(c(0.5, 1)) +
        theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),
            plot.margin = margin(t = 10, b = 40),
            text = element_text(size = 20)
        )
    """
end

# In your main script, you can call this function after running the simulation:
# include("rcall_visualizations.jl")
# plot_initial_test_results(all_results)
# """

@rput DF
@rput all_results #all intial results
# using RCall
# RCall.RBin

R"""
library(dplyr)
library(ggplot2)
library(tidyr)


df1=all_results%>%mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position)%>%
    mutate(meanx_m=mean(meanx))

p_in_20=ggplot(data=df1,aes(x=test_position,y=meanx,group=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",size=1.5)+
    geom_point()+ylim(c(0.5,1))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )

"""




R"""
device_number = 2
# ensure_device <- function(dev_num) {
#   devs <- dev.list()
#   if (is.null(devs) || !(dev_num %in% devs)) {
#     while (length(dev.list()) < dev_num) {
#       windows()  # use quartz() on macOS or X11() on Linux
#     }
#   }
#   dev.set(dev_num)
# }
library(dplyr)
library(ggplot2)
library(tidyr)
ensure_device <- function(dev_num) {
  devs <- dev.list()
  
  # Check if the specified device number exists
  if (is.null(devs) || !(dev_num %in% devs)) {
    
    # Open devices until the desired device is available
    while (length(dev.list()) < dev_num) {
      if (.Platform$OS.type == "windows") {
        windows()  # Use windows() on Windows
      } else if (Sys.info()["sysname"] == "Darwin") {
        quartz()  # Use quartz() on macOS
      } else {
        x11()  # Use x11() on Linux
      }
    }
  }
  
  # Set the specified device as active
  dev.set(dev_num)
}


df1=all_results%>%mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position)%>%
    mutate(meanx_m=mean(meanx))

p_in_20=ggplot(data=df1,aes(x=test_position,y=meanx,group=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",size=1.5)+
    geom_point()+ylim(c(0.5,1))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )


df2=all_results%>%mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number,list_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target,list_number)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position,list_number)%>%
    mutate(meanx_m=mean(meanx))

p_in_20in10=ggplot(data=df2%>%filter(list_number==1),aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    geom_point()+
    facet_grid(list_number~.)

p_in_20in10

p_in_20in100=ggplot(data=df2,aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    # geom_point()+
    facet_grid(list_number~.)

p_in_20in100

df3=all_results%>%mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(listbreak=case_when(list_number<=5~1,TRUE~2))%>%
    group_by(test_position,is_target,simulation_number,listbreak)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target,listbreak)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position,listbreak)%>%
    mutate(meanx_m=mean(meanx))
    
p_in_20in10_break2=ggplot(data=df3,aes(x=test_position,y=meanx,group=interaction(listbreak,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    geom_point()+
    facet_grid(listbreak~.)

    p_in_20in10_break2
    p_in_20in100
# The error "could not load symbol 'set_symvalue'" typically occurs when there is an issue with loading a shared library or a function from a shared library in Julia. 
# This could be due to a missing dependency, incorrect library path, or an incompatible version of the library.

# To debug and resolve this issue, you can try the following steps:

# 1. Verify the library path:
#    Ensure that the library you are trying to load is in the correct path and accessible. 
#    You can use the `Libdl.dlopen` function to explicitly load the library and check if it succeeds.

# 2. Check the function name:
#    Ensure that the function name `set_symvalue` is correctly spelled and matches the exported symbol in the library.

# 3. Check library compatibility:
#    Ensure that the library version is compatible with your Julia version and the platform you are using.

# 4. Use `Libdl` to debug:
#    Use the `Libdl` module in Julia to load the library and inspect its symbols. 
#    For example:
# using Libdl
# lib = Libdl.dlopen("path_to_your_library.so")
# Libdl.dlsym(lib, :set_symvalue)  # Check if the symbol exists

# 5. Update or reinstall the library:
#    If the library is outdated or corrupted, try updating or reinstalling it.

# 6. Provide more context:
#    If the issue persists, provide more details about the library you are using, the platform, and the code causing the error.


"""


R"""
library(ggplot2)
library(dplyr)
library(gridExtra)

DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))
p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    ylim(c(0.65,1))+
    scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )


DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))
p2=ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target),size=5)+
facet_grid(list_number~.)

DF3 = all_results %>% 
group_by(list_number, simulation_number)%>%
summarize(meanx=mean(Nratio_iprobe))%>%
group_by(list_number)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.integer(list_number))
# Adding a manual legend

# mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))
p3=ggplot(data=DF3, aes(x=list_number,y=meanx))+
geom_point(aes(x=list_number,y=meanx))+
geom_line(aes(x=list_number,y=meanx))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01)+
labs(title="Ratio of activated trace in each list",y="N (number of activated trace)")+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+
theme(
        plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
    plot.margin = margin(t = 10, b = 40),
    text=element_text(size=20) # Increase font size globally
)

# head(all_results)
# Nratio_imageinlist, ilist_image
# p4

p2
"""


R"""
DF3 = all_results %>% 
group_by(list_number, simulation_number, ilist_image)%>%
# summarize(meanx=mean(Nratio_iimageinlist))%>%
summarize(meanx=mean(N_imageinlist))%>%
group_by(list_number, ilist_image)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.factor(list_number))
# mutate(ilist_image=as.factor(ilist_image))
# mutate(test_position=as.factor(test_position))

p4=ggplot(data=DF3, aes(x=ilist_image,y=meanx, group=list_number))+
geom_point(aes(color=list_number))+
geom_line(aes(color=list_number))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01,size=10)+
labs(title="Ratio of activated trace for 10 lists in 10 color")+
# scale_x_continuous(name="list",breaks = rev(1:10),labels=as.character(rev(1:10)))
scale_x_reverse(name="traces from which list, left end - recent list, right, right end - prior list",breaks = 1:10,labels=as.character(1:10)) +
theme(text = element_text(size = 30))  # Increase font size globally

"""




R"""
df_serial=all_results%>%
    mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(study_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(study_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))

p_serial=ggplot(data=df_serial,aes(x=study_position,meanx))+
    geom_line(aes(color=is_target),size=2)+
    geom_point(size=2,aes(color=is_target))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )+
    ylim(c(0.75,1))

df_rt=all_results%>%
    mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(diff_rt=diff_rt^(1/11))%>%
    group_by(is_target,simulation_number,test_position)%>%
    summarize(rtm=mean(diff_rt))%>%
    group_by(is_target,test_position)%>%
    summarize(rt=mean(rtm))%>%
    mutate(is_target=as.factor(is_target))

testpos_rt=ggplot(data=df_rt,aes(x=test_position,y=rt,group=interaction(is_target)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )+ylim(c(0.75,1))


df_rt_list=all_results%>%
    mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(diff_rt=diff_rt^(1/11))%>%
    group_by(is_target,simulation_number,list_number)%>%
    summarize(rtm=mean(diff_rt))%>%
    group_by(is_target,list_number)%>%
    summarize(rt=mean(rtm))%>%
    mutate(is_target=as.factor(is_target),list_number=as.factor(list_number))

list_rt=ggplot(data=df_rt_list,aes(x=list_number,y=rt,group=interaction(is_target)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )

# df_rt

# names(all_results)

# grid.arrange(p4,p1,p_serial,p_in_20,p_in_20in10,p_in_20in10_break2,ncol = 2,nrow=3)
# grid.arrange(p4,p1,p_serial,p_in_20,p_in_20in10,testpos_rt,list_rt,ncol = 2,nrow=4)
# MARKING: inital test plots/figures here
ensure_device(2)
dev.set(2)  # Target window for Plot 1
grid.arrange(p1,list_rt,p_in_20,testpos_rt,p_serial,p4,ncol = 2,nrow=4)
# summary(all_results$diff_rt)
# df_rt_list

all_results%>%filter(!complete.cases(diff_rt))
# length(all_results$diff_rt)
"""

if is_finaltest
    @rput allresf
    R"""
    # head(allresf)
    DF00 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(test_position=as.numeric(test_position))%>%
    mutate(test_position_group=ntile(test_position,10))%>%
    group_by(test_position_group,is_target,condition)%>%
    summarize(meanx=mean(correct))

    p10=ggplot(data=DF00, aes(x=test_position_group,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)


    
    DF001 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(list_number=as.numeric(list_number))%>%
    group_by(list_number,is_target,condition)%>%
    summarize(meanx=mean(correct))



    p101=ggplot(data=DF001, aes(x=list_number,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p10, p101,p1,p3 ,p_in_20,p_in_20in10,ncol = 2,nrow=3)
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)

    
    df_allfinal=DF001%>%mutate(test_position_group=list_number)%>%ungroup()%>%select(-list_number)%>%
    full_join(DF00,by=c("is_target","condition","test_position_group"))%>%
    mutate(initial_list_order=meanx.x,final_test_order=meanx.y)%>%
    select(-c("meanx.x","meanx.y"))%>%
    pivot_longer(cols=c("initial_list_order","final_test_order"),names_to="position_kind",values_to="val")


    pf1=ggplot(data=df_allfinal, aes(test_position_group,val,group=interaction(position_kind,condition,is_target)))+
        geom_point(aes(color=is_target,group=is_target))+
        geom_line(aes(color=is_target,group=is_target),size=1.5)+
        facet_grid(condition~position_kind)+
        labs(x="Final test position cut in 10 chunks (left column), Initial test list order (right column)",
            y="prediction (Hits/Correct Rejection)",
            caption="Figure 3. Between List Final Test Results seen in Final Testing",
            color="Type",fill="Type")+
        scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
        theme(
                plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
            plot.margin = margin(t = 10, b = 40),
            text=element_text(size=30) # Increase font size globally
        )+
        ylim(c(0.5,1))

        DFff = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(initial_studypos = as.numeric(initial_studypos))%>%
    # mutate(test_position_group=ntile(test_position,10))%>%
    group_by(initial_studypos,is_target,condition)%>%
    summarize(meanx=mean(correct))

    pf3=ggplot(data=DFff, aes(x=initial_studypos,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=2)+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )+
    # scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))


    DFff2 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(initial_testpos = as.numeric(initial_testpos))%>%
    # mutate(test_position_group=ntile(test_position,10))%>%
    group_by(initial_testpos,is_target,condition)%>%
    summarize(meanx=mean(correct))

    pf4=ggplot(data=DFff2, aes(x=initial_testpos,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=2)+
    # scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)
        # grid.arrange(p4,p1,p_serial,p_in_20,p10,p101,ncol = 2,nrow=3)

    # DF001

    DF_fbyi = allresf %>% 
        mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
        select(correct,initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
        pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")%>%
        # mutate(list_number=as.numeric(list_number))%>%
        group_by(pos_factor,posSum,is_target,simulation_number)%>%
        summarize(meanx=mean(correct))%>%
        group_by(pos_factor,posSum,is_target)%>%
        summarize(meanx=mean(meanx))
        # filter(condition!="true_random")
    # DF_fbyi

    pf4= ggplot(data=DF_fbyi,aes(x=posSum,meanx))+
        geom_point(aes(color=is_target))+
        geom_line(aes(color=is_target),size=2)+
        facet_grid(.~pos_factor)+
        labs(title="Final test by initial test position")+
        ylim(c(0.5,1))+
        theme(
                plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
            plot.margin = margin(t = 10, b = 40),
            text=element_text(size=30) # Increase font size globally
        )+
        scale_color_manual(values=c("grey","red","blue","green"))
    # pf3
    # pf4
    ensure_device(3)
    dev.set(3)  # Target window for Plot 1
    grid.arrange(pf1, pf4,ncol = 1,nrow=2)
 

    # allresf %>% 
    # mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    # select(initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
    # pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")
    # allresf %>% 
    # mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    # select(correct,initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
    # pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")%>%
    # # mutate(list_number=as.numeric(list_number))%>%
    # group_by(pos_factor,posSum,is_target,condition,simulation_number)%>%
    # summarize(meanx=mean(correct))
    """
end


# all_results[all_results.list_number.!==all_results.ilist_image,:]