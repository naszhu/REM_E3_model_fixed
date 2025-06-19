



""" 
First stage
,test_list_context::Vector{Int64}
"""
function probe_evaluation(image_pool::Vector{EpisodicImage}, probes::Vector{Probe}, list_change_features::Vector{Int64}, general_context_features::Vector{Int64},simu_i::Int64)::Array{Any}

    unique_list_numbers = unique([image.list_number for image in image_pool])
    n_listimagepool = length(unique_list_numbers)
    
    results = Array{Any}(undef, n_probes * n_listimagepool)
    currentlist = probes[1].image.list_number #first stage, any probe number of current list will be the list of the current
    image_pool_currentlist = image_pool

    ### GO through test of each probe
    for i in eachindex(probes)

        ##The following is adding an exploring for if only current list tested
        if is_onlytest_currentlist #false
            error("can't test only current list")
            image_pool_currentlist = filter(img -> img.list_number == currentlist, image_pool)#it's ok even when new probe were add to the image pool, because new probe has current list numebr as well. It will be kept
        
        else #current must be whole pool being in memory
            image_pool_currentlist = image_pool
        end
        # println("this is list $(currentlist),there are $(length(image_pool_currentlist)) images in the current pool")


        context_LL_ratios, content_LL_ratios_org = calculate_two_step_likelihoods(probes[i].image, image_pool_currentlist, 1.0, i) #proportion is all

        content_LL_ratios_filtered = content_LL_ratios_org |> x -> filter(e -> e != 344523466743, x)
        # println(length(content_LL_ratios_org)== length(image_pool_currentlist) )


        ilist_probe = probes[i].image.list_number
        i_testpos = probes[i].image.word.initial_testpos#1:20

        nl = length(content_LL_ratios_filtered)
        odds = 1 / nl * sum(content_LL_ratios_filtered)
        odds_context = 1 / length(context_LL_ratios) * sum(context_LL_ratios)

        if (isnan(odds))
            println("Current context_tau is too high, there are some simulations that have no tarce passing context filter in first step", nl, content_LL_ratios_filtered)
        end

        
        if odds>criterion_initial[i_testpos,ilist_probe] #val=1; if pass, possible to recall 
            if odds> recall_odds_threshold #100, do a recall
                if odds_context > context_threshold_filter #context familiar enough
                    # println("Recall, odds: $odds, context: $odds_context, threshold: $(context_threshold_filter)")
                    decision_isold = rand() < p1_old_after_filter[ilist_probe] ? 1 : 0  #recall, judge old
                else
                    # println("Recall, but context not familiar enough, odds: $odds, context: $odds_context, threshold: $(context_threshold_filter)")
                    decision_isold = rand() < p2_old_after_filter[ilist_probe] ? 1 : 0 #recall but not familiar enough, might be confusing foils, judge new

                end

            else #doesn't do recall,judge old
                decision_isold = 1 #still old, but not recall
            end
        else #if didn't pass, directly judge new
            decision_isold = 0
        end


        diff = 1 / (abs(odds - criterion_initial[i_testpos,ilist_probe]) + 1e-10)

        #criterion change by test position

        # decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0;

        nav = length(content_LL_ratios_filtered) / (length(image_pool_currentlist))
        # println(nav)
        # if (decision_isold == 1) && (odds > recall_odds_threshold)
        #     imgMax = image_pool_currentlist[argmax(content_LL_ratios_filtered)]
        # end

        ############### Add new sampling LL preparing lines
        filtered_content_LL_ratios_inOriginalLength = content_LL_ratios_org |> x -> map(e -> e == 344523466743 ? 0 : e, x)

        # Step 2: Calculate the total sum of the filtered likelihood ratios
        total_sum_LL = sum(filtered_content_LL_ratios_inOriginalLength)

        # Step 3: Assign probabilities proportionally
        sampling_probabilities = total_sum_LL == 0 ? zeros(length(filtered_content_LL_ratios_inOriginalLength)) : [filtered_content_LL_ratios_inOriginalLength[i_LL_proportion] ./ total_sum_LL  for i_LL_proportion in eachindex(filtered_content_LL_ratios_inOriginalLength)]
        ################

        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool_currentlist)
            nimages_activated = count(ii -> (image_pool_currentlist[ii].list_number == j) && (content_LL_ratios_org[ii] != 344523466743), eachindex(image_pool_currentlist))
            
            #i is each probe, j is list number
            # testpos=i
            # println(probes[i].ProbeTypeSimple,probes[i].ProbeTypeSimple==:target)
            results[n_listimagepool*(i-1)+j] = (decision_isold=decision_isold, 
            # type_general=probes[i].image.word.type_general,
            type_general=probes[i].image.word.type_general,
            type_specific=probes[i].image.word.type_specific, 
            is_target=probes[i].ProbeTypeSimple==:target,  
            odds=odds, ilist_image=j, Nratio_imageinlist=nimages_activated / nimages, N_imageinlist=nimages_activated, Nratio_iprobe=nav, testpos=i, studypos=probes[i].image.word.initial_studypos, diff=diff)
            # println(nl, " ",nimages_activated)
        end
    

        if is_restore_initial
            restore_intest(image_pool, probes[i].image, decision_isold, sampling_probabilities, odds) 
        end

        # println("i, $i, i_testpos, $i_testpos")



    end



    return results
end


function probe_evaluation2(image_pool::Vector{EpisodicImage}, probes::Vector{Probe})::Array{Any}

    results = Array{Any}(undef, length(probes))
    # println("now#$(length(probes))")
    for i in eachindex(probes)

        # _, content_LL_ratios_filtered = [calculate_two_step_likelihoods(probes[i].image, image) for image in image_pool] 
        # Determine the current list based on the index `i`
        # global currchunk
        if i <= n_inEachChunk[1]
            currchunk = 1
        else
            currchunk = div(i - n_inEachChunk[1] - 1, n_inEachChunk[2]) + 2
        end
        # println(" ", i, " ", currchunk)
        # chunk assign correct here after printed check

        _, content_LL_ratios_org = calculate_two_step_likelihoods2(probes[i].image, image_pool, 1.0, currchunk)
        content_LL_ratios_filtered = content_LL_ratios_org |> x -> filter(e -> e != 344523466743, x)
        #    if ii==1 println(size(image_pool),"of", size(content_LL_ratios_filtered)) end

        # println(content_LL_ratios_filtered)
        odds = 1 / length(content_LL_ratios_filtered) * sum(content_LL_ratios_filtered)
        
        
        criterion_final_i = criterion_final[currchunk] #this need to be changed if 
        
        decision_isold = odds > criterion_final_i ? 1 : 0;


        # println("$(probes[i].image.word.type_specific), $(probes[i].ProbeTypeSimple) , des: $(decision_isold), chunki: $(currchunk), npass: $(length(content_LL_ratios_filtered)), cri $(criterion_final[currchunk]) ,odds: $(odds)")

        # pold = pcrr_EZddf(log(odds))
        # rt = Brt + Pi * abs(log(odds))

        # Store results (modify as needed)
        results[i] = (decision_isold=decision_isold, 

        test_position = i, #final test pos 
        initial_testpos = probes[i].image.word.initial_testpos, 
        initial_studypos=probes[i].image.word.initial_studypos,
        type_specific =probes[i].image.word.type_specific,
        type_general=probes[i].image.word.type_general,
        is_repeat_type=probes[i].image.word.is_repeat_type,

        is_target = probes[i].ProbeTypeSimple==:target,
        odds=odds, list_num=probes[i].image.list_number ) #! made changes to results, format different than that in inital
        
        imax = argmax([ill==344523466743 ? -Inf : ill for ill in content_LL_ratios_org]);
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(content_LL_ratios_filtered));
        if is_restore_final

            #Issue 12
            restore_intest_final(image_pool, probes[i].image, decision_isold, decision_isold == 1 ? imax : 1, odds, i);  #have to pass final testpos 
        end
    end

    return results
end
