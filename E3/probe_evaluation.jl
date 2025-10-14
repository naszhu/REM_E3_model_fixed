



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


        # if probes[i].image.word.type_specific== :T
        #     println(probes[i].image.word.initial_testpos)
        # end

        nl = length(content_LL_ratios_filtered)
        odds = (1 / nl * sum(content_LL_ratios_filtered))^power_taken
        odds_context = 1 / length(context_LL_ratios) * sum(context_LL_ratios)

        if (isnan(odds))
            println("Current context_tau is too high, there are some simulations that have no tarce passing context filter in first step", nl, content_LL_ratios_filtered)
        end

        if (odds>criterion_initial[i_testpos,ilist_probe]) && (odds > recall_odds_threshold) #recall which?
            imgMax = image_pool_currentlist[argmax(content_LL_ratios_filtered)]
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
        
        filtered_content_LL_ratios_inOriginalLength_to_11thpower= filtered_content_LL_ratios_inOriginalLength .^ power_taken # raise to 1/11 power, so that the sampling is more likely to sample the higher LL ratios, but not too much
        # Step 3: Assign probabilities proportionally
        total_sum_LL = sum(filtered_content_LL_ratios_inOriginalLength_to_11thpower)
        sampling_probabilities = total_sum_LL == 0 ? zeros(length(filtered_content_LL_ratios_inOriginalLength_to_11thpower)) : [filtered_content_LL_ratios_inOriginalLength_to_11thpower[i_LL_proportion] ./ total_sum_LL  for i_LL_proportion in eachindex(filtered_content_LL_ratios_inOriginalLength_to_11thpower)]
         ################

        # Sample or select item BEFORE decision logic
        sampled_item = nothing
        is_same_item = false  # Initialize is_same_item
        is_sampled = false    # Initialize is_sampled
        if (odds > criterion_initial[i_testpos, ilist_probe]) && (odds > recall_odds_threshold)

            is_sampled = true
            
            if sampling_method
                # Use sampling probabilities
                cdf_each_boral_sets = Categorical(sampling_probabilities)
                index_sampled = rand(cdf_each_boral_sets)
                sampled_item = image_pool_currentlist[index_sampled]
                
                # Check if the sampled item is the same as the probe being tested
                
                is_same_item = sampled_item.word.item_code == probes[i].image.word.item_code
            # Debug print when items don't match
            # if !is_same_item
            #     println("Item codes don't match:")
            #     println("  Sampled item code: ", sampled_item.word.item_code)
            #     println("  Sampled item type: ", sampled_item.word.type_specific)
            #     println("  Probe item code: ", probes[i].image.word.item_code)
            #     println("  Probe item type: ", probes[i].image.word.type_specific)
            # end


            else
                # Pick the image with maximum content_LL_ratios value
                imax = argmax([ill==344523466743 ? -Inf : ill for ill in content_LL_ratios_org])
                sampled_item = image_pool_currentlist[imax]
                
                # Check if the sampled item is the same as the probe being tested
                is_same_item = sampled_item.word.item_code == probes[i].image.word.item_code
            end
        end

        # Decision logic - same structure but configurable type source
        if odds > criterion_initial[i_testpos, ilist_probe] 
            if odds > recall_odds_threshold
                # Determine which list number and type to use for decision
                # if use_sampled_item_for_decision && !isnothing(sampled_item)
                #     # Use sampled item's list number and type
                #     decision_list_number = sampled_item.list_number
                #     decision_type = sampled_item.word.type_specific
                # else
                #     # Use probe's list number and type (original behavior)
                #     decision_list_number = ilist_probe
                #     decision_type = probes[i].image.word.type_specific
                # end
                
                # if decision_list_number == 1
                #     decision_isold = 1 #if list 1, always recall
                # elseif decision_list_number > 1
                #     product = get(z_time_p_val, decision_type, zeros(Float64, n_lists-1)) 
                #     decision_isold = rand() < product[decision_list_number-1] ? 0 : 1   
                # else
                #     # For list 0 or other invalid cases, default to new
                #     error("List number mistaken initial")
                #     decision_isold = 0
                # end
                @assert !isnothing(sampled_item) "sampled item is nothing"
                if ilist_probe !=1 #if not in first list
                    # println("listi",ilist_probe)
                    ranv = rand() 
                    if use_Z_feature && !isnothing(sampled_item) && ranv < h_j[ilist_probe-1]
                        # Use OT feature from sampled item
                        # println("test")
                        # println("listi",ilist_probe)
                        # println("  ranv ", ranv, " hj: ", h_j[ilist_probe-1])
                        Z_value = get_Z_feature_value(sampled_item.word)
                        if Z_value === 1 && sampled_item.word.type_general === :T
                            # println(ilist_probe,":", Z_value, " sampled_item:", sampled_item.word.type_general)
                            # println("is_same_item:", sampled_item.word.item_code == probes[i].image.word.item_code)
                        end
                        if Z_value === 1
                            decision_isold = 0  # OT=1 means judged new
                        else
                            decision_isold = 1  # OT=0 means judged old
                        end
                        
                        # OT feature disabled or no sampled item - use fallback logic
                    else #if not OT feature: use familarity and so pass recall threshold is old
                        decision_isold = 1 #This is the bug issue partially
                    end


                    probe_type_specific = probes[i].image.word.type_specific
                    if use_Z_decision_approximation && !use_Z_feature
                        
                        if probe_type_specific in (:T, Symbol("Tn+1"))
                            decision_isold = rand() < κu[ilist_probe-1]*h_j[ilist_probe-1] ? 0 : 1

                        elseif probe_type_specific == Symbol("SOn")

                            decision_isold = rand() < κs[ilist_probe-1]*h_j[ilist_probe-1] ? 0 : 1

                        elseif probe_type_specific == Symbol("Tn")
                            decision_isold = rand() < κb[ilist_probe-1]*h_j[ilist_probe-1] ? 0 : 1

                        elseif probe_type_specific == Symbol("Fn")
                            decision_isold = rand() < κt[ilist_probe-1]*h_j[ilist_probe-1] ? 0 : 1

                        elseif probe_type_specific in (:F, Symbol("Fn+1")) # when F, Fn+1, 
                            # error("probe type specific not found")
                            decision_isold = rand() < h_j[ilist_probe-1] ? 0 : 1
                        else #SO, SOn+1, FF shouldn't appear here
                            error("probe type specific not found")
                        end
                    end
                else
                    decision_isold = 1 #first list use famialrity only, not considering Z feature #FIXME, is this true?
                end

            else
                decision_isold = 1
            end
        else #if didn't pass, directly judge new
            decision_isold = 0
        end

        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool_currentlist)
            nimages_activated = count(ii -> (image_pool_currentlist[ii].list_number == j) && (content_LL_ratios_org[ii] != 344523466743), eachindex(image_pool_currentlist))
            
            # Calculate Z values for current list targets ONLY (not all memory pool)
            # Only calculate Z for the list being currently tested (j == currentlist)
            Z_sum = 0
            Z_proportion = 0.0
            
            if j == currentlist  # Only calculate Z for the list being tested
                current_list_targets = filter(img -> img.list_number == j && (img.word.type_specific === :T || img.word.type_specific === Symbol("Tn+1")), image_pool_currentlist)
                if !isempty(current_list_targets)
                    Z_sum = sum(get_Z_feature_value(target.word) for target in current_list_targets)
                    Z_proportion = Z_sum / length(current_list_targets)
                end
            end
            
            #i is each probe, j is list number
            # testpos=i
            # println(probes[i].ProbeTypeSimple,probes[i].ProbeTypeSimple==:target)
            results[n_listimagepool*(i-1)+j] = (decision_isold=decision_isold, 
            # type_general=probes[i].image.word.type_general,
            type_general=probes[i].image.word.type_general,
            type_specific=probes[i].image.word.type_specific, 
            is_target=probes[i].ProbeTypeSimple==:target,  
            odds=odds, ilist_image=j, Nratio_imageinlist=nimages_activated / nimages, N_imageinlist=nimages_activated, Nratio_iprobe=nav, testpos=i, studypos=probes[i].image.word.initial_studypos, diff=diff, is_same_item=is_same_item, is_sampled=is_sampled, Z_sum=Z_sum, Z_proportion=Z_proportion)
            # println(nl, " ",nimages_activated)
        end
    

        if is_restore_initial
            restore_intest(image_pool, probes[i].image, decision_isold, odds, content_LL_ratios_org, sampled_item, criterion_initial[i_testpos, ilist_probe])  
        end

        # println("i, $i, i_testpos, $i_testpos")
        # for i in image_pool
        #     if i.word.type_general==:T
        #         println(i.word.initial_testpos)
        #     end
        # end



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
        odds = (1 / length(content_LL_ratios_filtered) * sum(content_LL_ratios_filtered))^power_taken
        
        
        criterion_final_i = criterion_final[currchunk] #this need to be changed if 
        
        ############### Add new sampling LL preparing lines
        filtered_content_LL_ratios_inOriginalLength = content_LL_ratios_org |> x -> map(e -> e == 344523466743 ? 0 : e, x)

        # Step 2: Calculate the total sum of the filtered likelihood ratios
        total_sum_LL = sum(filtered_content_LL_ratios_inOriginalLength)

        filtered_content_LL_ratios_inOriginalLength_to_11thpower= filtered_content_LL_ratios_inOriginalLength .^ (1/11) # raise to 1/11 power, so that the sampling is more likely to sample the higher LL ratios, but not too much
        # Step 3: Assign probabilities proportionally
        total_sum_LL = sum(filtered_content_LL_ratios_inOriginalLength_to_11thpower);

        sampling_probabilities = total_sum_LL == 0 ? 
            zeros(length(filtered_content_LL_ratios_inOriginalLength_to_11thpower)) : 
            [filtered_content_LL_ratios_inOriginalLength_to_11thpower[i_LL_proportion] ./ total_sum_LL  for i_LL_proportion in eachindex(filtered_content_LL_ratios_inOriginalLength_to_11thpower)];

        # Sample or select item BEFORE decision logic for final test
        sampled_item = nothing
        is_same_item = false  # Initialize is_same_item
        is_sampled = false    # Initialize is_sampled
        if odds > criterion_final_i && odds > recall_odds_threshold
            is_sampled = true  # Item was sampled
            if sampling_method
                # Use sampling probabilities
                cdf_each_boral_sets = Categorical(sampling_probabilities)
                index_sampled = rand(cdf_each_boral_sets)
                sampled_item = image_pool[index_sampled]
                
                # Check if the sampled item is the same as the probe being tested
                is_same_item = sampled_item.word.item_code == probes[i].image.word.item_code
                
            else
                # Pick the image with maximum content_LL_ratios value
                imax = argmax([ill==344523466743 ? -Inf : ill for ill in content_LL_ratios_org])
                sampled_item = image_pool[imax]
                
                # Check if the sampled item is the same as the probe being tested
                is_same_item = sampled_item.word.item_code == probes[i].image.word.item_code
            end
        end

        # Decision logic for final test - same structure but configurable type source
        
        if odds > criterion_final_i
            decision_isold = 1
        else #if didn't pass, directly judge new
            decision_isold = 0
        end

        # Calculate Z values for targets in current chunk ONLY (not all memory pool)
        current_chunk_targets = filter(img -> img.list_number == currchunk && (img.word.type_specific === :T || img.word.type_specific === Symbol("Tn+1")), image_pool)
        Z_sum = 0
        Z_proportion = 0.0
        
        if !isempty(current_chunk_targets)
            Z_sum = sum(get_Z_feature_value(target.word) for target in current_chunk_targets)
            Z_proportion = Z_sum / length(current_chunk_targets)
        end

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
        odds=odds, list_num=probes[i].image.list_number, is_same_item=is_same_item, is_sampled=is_sampled, Z_sum=Z_sum, Z_proportion=Z_proportion) #! made changes to results, format different than that in inital
        
        imax = argmax([ill==344523466743 ? -Inf : ill for ill in content_LL_ratios_org]);
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(content_LL_ratios_filtered));
        
        # println(probes[i].image.word.type_specific)
        # if probes[i].image.word.type_specific== :T
        #     println(probes[i].image.word.initial_testpos)
        # end
        if is_restore_final

            #Issue 12
            restore_intest_final(image_pool, probes[i].image, decision_isold, odds, i, content_LL_ratios_org, sampled_item, criterion_final_i);  #have to pass final testpos 
        end
    end

    return results
end
