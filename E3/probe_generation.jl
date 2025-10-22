


"""generate probe for inital test for a given list,
input: studied word list; context features; content features
Return: probe, foil_collection

Parameters:
- content_before_distort: word list with drifted content (REINSTATEMENT TARGET for content)
- content_after_distort: word list with drifted+distorted content (CURRENT for content)
- CC_before_distort: drifted CC context (REINSTATEMENT TARGET for CC)
- CC_after_distort: drifted+distorted CC context (CURRENT for CC)
- UC_before_distort: drifted UC context (REINSTATEMENT TARGET for UC)
- UC_after_distort: drifted+distorted UC context (CURRENT for UC)
- list_num: current list number
- studied_pool_ref: reference to original studied_pool

Reinstatement: probes after the first one will partially reinstate toward "before_distort" versions
"""
function generate_probes(
    content_before_distort::Vector{Word}, 
    content_after_distort::Vector{Word},
    CC_before_distort::Vector{Int64}, 
    CC_after_distort::Vector{Int64},
    UC_before_distort::Vector{Int64}, 
    UC_after_distort::Vector{Int64},
    list_num::Int64,
    studied_pool_ref::Vector{Vector{EpisodicImage}} # Reference to original studied_pool
    
    ; #following are defult vars
    # the next be an optional input, because list 1 dones't have lastlist_studeidpool...
    studied_pool_lastList = nothing,

    probeTypeDesign_testProbe_L1::Dict{Symbol, Int} = probeTypeDesign_testProbe_L1,
    probeTypeDesign_testProbe_Ln::Dict{Symbol, Int} = probeTypeDesign_testProbe_Ln
    )::Tuple{Vector{Probe}, Vector{EpisodicImage}}   # here, not deep copy word_change_features is safe because even if it influences the original index, the word-change context features will be discarded when this list ends  

  # 
    if list_num == 1
        probetypes = reduce(vcat, (fill(key, value * nItemPerUnit) for (key, value) in probeTypeDesign_testProbe_L1)) |> shuffle!
    else 
        probetypes = reduce(vcat, (fill(key, value * nItemPerUnit) for (key, value) in probeTypeDesign_testProbe_Ln)) |> shuffle!
    end
    
    foilnew_symbol_tuple = (:F, Symbol("Fn+1"));
    Fb_symbol_tuple = (:Tn, :Fn, :SOn);
    T_target_tuple = (:T, Symbol("Tn+1"));

    probes = Vector{Probe}(undef, length(probetypes))

    # STEP 1: Create all probe words BEFORE distortion
    # Group content_before_distort (NOT distorted yet) by their type_general into a dictionary
    ####Type general:
    # T; Tn; SO; SOn; F; Fn

    #only 2 kinds need to be drawn from current studypool; those of type target  
    studied_pool_currlist_by_type = Dict(
        :T => filter(iword -> iword.type_general == :T, content_before_distort)|> shuffle!,
        Symbol("Tn+1") => filter(iword -> iword.type_general == Symbol("Tn"), content_before_distort)|> shuffle!,
    )

    # 3 types, last target, last foil, last studyonly
    # only when list > 1, assign a prior list Dict, and then do the append in combining the two Dict, 
    # else, don't do anything just combine 
    if list_num>1
        #make dict
        studied_pool_priorlist_by_type = Dict(
            Symbol("Tn") => filter(iword -> iword.type_general == Symbol("Tn"), studied_pool_lastList)|> shuffle! ,

            Symbol("Fn") => filter(iword -> iword.type_general == Symbol("Fn"), studied_pool_lastList) |> shuffle!,

            :SOn => filter(iword -> iword.type_general == :SOn, studied_pool_lastList)|> shuffle!
        )
        #combine the two dictionaries
        for key in keys(studied_pool_priorlist_by_type)
            if haskey(studied_pool_currlist_by_type, key) #check if current key exist in other Dict. it actually shouldn'T
    
                error("Should have key overlaps")
                append!(studied_pool_currlist_by_type[key], studied_pool_priorlist_by_type[key])
            else
                studied_pool_currlist_by_type[key] = studied_pool_priorlist_by_type[key]
            end
        end
        
    end
    
    # would equal study_poolcurrlist no matter list 1 or >list1
    combined_studied_pool_by_type = studied_pool_currlist_by_type

    # Create array to hold all probe words (will be distorted together)
    probe_words = Vector{Word}(undef, length(probetypes))
    
    foils_collection = Vector{EpisodicImage}()
    for i in eachindex(probetypes) #should be 1-30
        # println("probe$(i)")
        # println(probetypes[i])
        # haskey(Dict(:a => 1, :b => 2), :ff) => return false
        # println(probetypes[i])
        if haskey(combined_studied_pool_by_type, probetypes[i]) # Check if probetype matches a key in the combined dictionary
            
            probe_words[i] = pop!(combined_studied_pool_by_type[probetypes[i]]) # Pop an item from the corresponding array
            # probe_words[i].initial_studypos = probetypes[i] in Fb_symbol_tuple ? 0 : probe_words[i].initial_studypos; # if from last list, studypos=0, else if current list (:T ,:Tn+1 ) or (:F, :Fn+1), studypos=keep current word studypos
            probe_words[i].initial_testpos = i # if from last list, studypos=0, if current list, studypos=current test num
            probe_words[i].type_specific = probetypes[i] #update the type_specific
            
            # Update the original item in studied_pool with the initial_testpos
            if probetypes[i] in [:T, Symbol("Tn+1")]
                for j in 1:length(studied_pool_ref[list_num])
                    if !isnothing(studied_pool_ref[list_num][j]) && 
                       studied_pool_ref[list_num][j].word.item_code == probe_words[i].item_code
                        studied_pool_ref[list_num][j].word.initial_testpos = i
                        break
                    end
                end
            end
            
            # Set initial Z value based on probe type according to new rules
            set_initial_Z_value_for_probe!(probe_words[i], probetypes[i])

        elseif probetypes[i] in foilnew_symbol_tuple

            # println("Foil")
            #if combined_studiedpool doesn't have it, (don't have the type in prior list, don't have it in current list, that means the type is either F or Fn+1)
                    
        # out of T; Tn; SO; SOn; F; Fn
            pt_general = probetypes[i] == :F ? :F : Symbol("Fn")

            features = generate_features(Geometric(g_word), w_word)
            
            # Add OT feature (always added)
            push!(features, 0)  # For new probes, OT feature starts as 0 (not tested before)

            probe_words[i] = 
            Word(
                randstring(8), #item_code
                features, 
                pt_general, #type_general, either F or Fn (not Fn+1)

                probetypes[i], #type_specific
                0, #study pos: 0
                i, #test position 

                probetypes[i] == :F ? false : true, #is_repeat_type
                :F, #type1, will be :F whatsoever
                probetypes[i]== :F ? :none : :Fb #type2, general type, 

                #the last two assignment could check in const beginning clarification line on 1, 2 for each line
            ) # Insert studypos 0
            
            # Set initial Z value based on probe type according to new rules
            set_initial_Z_value_for_probe!(probe_words[i], probetypes[i])
        else
            error("probetype not in the list")
        end
    end
    
    # STEP 2: Apply CONTENT DISTORTION to all probe words at once (all probe types)
    probe_words_before_distort = deepcopy(probe_words)  # Save for reinstatement
    probe_words_after_distort = deepcopy(probe_words)   # Will be distorted
    
    if is_content_distort_between_study_and_test
        distort_probe_words_content!(probe_words_after_distort, base_distortion_prob, g_word, w_word)
    end
    
    # STEP 3: Now iterate through probes, applying reinstatement and creating probes
    for i in eachindex(probetypes)
        target_word = probe_words_after_distort[i]  # Get the (possibly distorted) word

        ############ Context and content reinstatement below
        # Reinstate changing context, unchanging context, and content for each test position
        if i>1   
            # REINSTATE CC (changing context): reinstate from after_distort toward before_distort
            reinstate_context_duringTest!(CC_after_distort, CC_before_distort, p_reinstate_context, p_reinstate_rate)

            # REINSTATE UC (unchanging context): reinstate from after_distort toward before_distort
            if is_UC_distort_between_study_and_test
                reinstate_context_duringTest!(UC_after_distort, UC_before_distort, p_reinstate_context, p_reinstate_rate)
            end

            # REINSTATE CONTENT: reinstate THIS probe's word features from after_distort toward before_distort
            if is_content_distort_between_study_and_test
                reinstate_word_content_duringTest!(target_word, probe_words_before_distort[i], p_reinstate_rate, w_word)
            end
        end 
        #Target word is unique deep copied, so shouldn't overlap. get only current studypos, not a prior one
        current_studypos = target_word.initial_studypos;
        current_testpos = i; 

        # Build context from UC_after_distort and CC_after_distort (which may have been reinstated)
        current_context_features = fast_concat([deepcopy(UC_after_distort), deepcopy(CC_after_distort)]) #here needs a deepcopy, otherwise the front remembered context change with later ones  
        

        probes[i] = Probe( #create prob from current created target word i
            # appearnum: if old kind, second time appear
            EpisodicImage(target_word, current_context_features, list_num, probetypes[i] in Fb_symbol_tuple ? 2 : 1),

            probetypes[i] in T_target_tuple ? :target : :foil, #target or foil
            probetypes[i] in  T_target_tuple ? :T : probetypes[i] in Fb_symbol_tuple ? :Fb : :F #general type of probe, F, Fb or T
        )

        if probetypes[i] in foilnew_symbol_tuple
            # Store NON-DISTORTED foil for final test (uses probe_words_before_distort)
            non_distorted_foil = EpisodicImage(
                probe_words_before_distort[i],  # NON-DISTORTED word content
                current_context_features,        # Context (doesn't matter for final test)
                list_num,
                probetypes[i] in Fb_symbol_tuple ? 2 : 1
            )
            push!(foils_collection, deepcopy(non_distorted_foil))
        end   # Commented the following lines because studied_pool is not carried in current function right now, but study_pool did have its images to be stored during study, meaning they won't have a test position assigned, 
        # BUT this is currently IGNORED (unassigned testpos for studied_pool), because the current testpos will not be used for prediction yet in final test, as a start 
        # Later, modify the testpos (of either appear 1 or appear 2 if we need, but now, ignore)  

        # if probetypes[i] == :target

        #     matching_image = findfirst(img -> img.word.item == target_word.item, studied_pool)

        #     if matching_image !== nothing
        #         studied_pool[matching_image].initial_testpos_img = current_testpos #update the test position of the image in the studied pool
        #     else
        #         error("Image not found in studied pool")
        #     end
        # end
        # println("List $(list_num),probe $(i)")
        # # println("contextf1 $(list_change_features_ref)")
        # println("contextf2 $(current_context_features[31:end])")

    end


    if is_content_distort_between_study_and_test
        # NOTE: This section applies ADDITIONAL linear decay distortion on top of the
        # constant distortion already applied at line 162. This appears to be legacy code
        # from an older distortion scheme.
        #
        # The foils_collection was properly populated at line 209 with non-distorted content
        # from probe_words_before_distort, so it remains unaffected by this additional distortion.
        distorted_probes, original_probes = distort_probes_with_linear_decay(
            probes,
            max_distortion_probes;  # Use constant from constants.jl
            base_distortion_prob = base_distortion_prob,  # Use constant from constants.jl
            g_word = g_word  # Use the constant defined in constants.jl
        )

        # Replace probes with distorted versions for testing
        probes = distorted_probes

        # Note: original_probes are kept for reference but not returned
    end

    # Apply UC (unchanging context) distortion if enabled (Issue #50)
    if is_UC_distort_between_study_and_test
        distorted_probes_uc, original_probes_uc = distort_probe_context_range_with_linear_decay(
            probes,
            1,  # Start at first UC feature
            nU,  # End at last UC feature
            "UC",  # Context type name for debug
            max_distortion_probes;
            base_distortion_prob = base_distortion_prob_UC,
            g_context = g_context
        )

        probes = distorted_probes_uc
    end

    # Apply CC (changing context) distortion if enabled (Issue #50)
    if is_CC_distort_between_study_and_test
        distorted_probes_cc, original_probes_cc = distort_probe_context_range_with_linear_decay(
            probes,
            nU + 1,  # Start after UC features
            nU + nC,  # End at last CC feature
            "CC",  # Context type name for debug
            max_distortion_probes;
            base_distortion_prob = base_distortion_prob_CC,
            g_context = g_context
        )

        probes = distorted_probes_cc
    end

    return probes, foils_collection
end




"""Input the flattened studied pool, first 30 are t/n/f in list 1, and etc; give last list's list_change_cf to change from list to list for probes
    
    Add, make initial_testpos in probes
Vec type for episodic image
    """
function generate_finalt_probes(studied_pool::Vector{EpisodicImage}, condition::Symbol, unchange_features_ref::Vector{Int64}, list_change_context_features::Vector{Int64})::Vector{Probe}

    listcg = deepcopy(list_change_context_features)
    unchangecg = deepcopy(unchange_features_ref);
    
    # Track previous chunk to detect chunk boundaries
    previous_chunk = 0
    
    # num_images = length(studied_pool)
    studyPool_Img_byList = Dict{Int64,Vector{EpisodicImage}}()
    for img in studied_pool
        push!(get!(studyPool_Img_byList, img.list_number, Vector{EpisodicImage}()), img)
    end

# println(img.initial_testpos_img)

    lists = keys(studyPool_Img_byList) |> collect |> sort
    probes = Vector{Probe}()
    if condition == :backward
        lists = reverse(lists)
    elseif condition == :true_random

        # true random doesn't change list context during final test
        all_images = reduce(vcat, values(studyPool_Img_byList))  # Combine all lists efficiently   shuffle!(all_images)  # Shuffle all images together
        studyPool_Img_byList = Dict{Int64,Vector{EpisodicImage}}(1 => all_images)
        lists = keys(studyPool_Img_byList)
        # println(lists)
    end

    icount = 0
    for list_number in lists #lists is [1] for random condition

        icount += 1
        #update the list_change_context_features for each list as they go in final test, but this doens't apply to random condi
        if (icount !=1) && (condition != :true_random) 
            error("there is no other condition than true_random")
            drift_context_during_final_test!(listcg, p_ListChange_finaltest[icount])
            drift_context_during_final_test!(unchangecg, p_ListChange_finaltest[icount])
        end


        # for cf in eachindex(unchangecg)
        #     if rand() < 0.01 #cf.change_probability # this equals p_change
        #         unchangecg[cf] = rand(Geometric(g_context)) + 1
        #     end
        # end

        # images hold pool_image of the current list, 
        images = studyPool_Img_byList[list_number]
        # for i in images
        #     if i.word.type_general==:T
        #                         # if probe[iprobe]==:SO
        #             println(i.word.initial_studypos)
        #         # end
        #     end
        # end
        image_groups = Dict(type => filter(img -> img.word.type_general == type, images) |> shuffle! for type in [:T, :Tn, :SO, :SOn, :F, :Fn]);
        # println(length(image_groups[:T]), " T images in list ")

        # images_T, images_Tn, Images_SO, images_Son, images_F, images_Fn = image_groups[:T], image_groups[:Tn], image_groups[:SO], image_groups[:SOn], image_groups[:F], image_groups[:Fn]   # Generate targets from shuffled list and foils anew

        if condition != :true_random

            probe = reduce(vcat, (fill(key, value * nItemPerUnit_final) for (key, value) in probeTypeDesign_finalTest_L1)) |> shuffle!   
        else
            # random condition, 
            # TODO: reduce complexity below, redesign Dict
            # issue 9

            probe = reduce(vcat, (fill(key, (probeTypeDesign_finalTest_Ln[key]*9 + probeTypeDesign_finalTest_L1[key]*1 ) * nItemPerUnit_final) for key in keys(probeTypeDesign_finalTest_Ln))) |> shuffle!
        end

        # Flagging when iprobe_chunk changes value

        

        for iprobe in eachindex(probe) #iprobe is final test testing position (maybe in group)
        

            
            if condition == :true_random

                # Only make changes at the start of every chunk (excluding the start of the first chunk)
                # Calculate the chunk boundaries dynamically - matching data analysis: 8 chunks of 49, then 2 chunks of 50
                # iprobe_chunk_boundaries = [49, 98, 147, 196, 245, 294, 343, 392, 442, 492]
                iprobe_chunk = findfirst(x -> iprobe <= x, iprobe_chunk_boundaries)   
            # println(iprobe_chunk, " iprobe: ", iprobe)
                
                # println(i)
                # println("iprobe: ", iprobe)
                # println("iprobe_chunk_boundaries: ", iprobe_chunk_boundaries)
                # println([iprobe <= x for x in iprobe_chunk_boundaries])
                # println("iprobe_chunk: ", iprobe_chunk, " previous_chunk: ", get(previous_chunk, 0, 0))

                ### change listcg based on iprobe_chunk
                # only change ctx when moving to a new chunk (excluding the first chunk)

                if (iprobe != 1) && (iprobe_chunk > 1) && (iprobe_chunk != previous_chunk)

                    # println("iprobe ", iprobe, " iprobe_chunk ", iprobe_chunk, " flag - CHUNK BOUNDARY DETECTED")
                    # have checked iprobe_chunk here is correctly asigned

                    #issue 14, inconsistent prob use
                    drift_between_lists_final!(listcg, p_ListChange_finaltest)
                    drift_between_lists_final!(unchangecg, p_ListChange_finaltest)

                end   
                previous_chunk = iprobe_chunk

            else
                error("other conditions not well written")
            end # end true trandom condition 

            global img = nothing  # Initialize img as nothing to refresh its value in each iteration

            crrcontext = fast_concat([deepcopy(unchangecg), deepcopy(listcg)]);

            ######### If true, current probe is target and so get new prob from past 

            # if (img.word.initial_testpos>30)
            #     println(img.list_number, img.word.initial_testpos)
            # end

            if haskey(image_groups, probe[iprobe])
                # println(length(image_groups[probe[iprobe]]), " images in group ", probe[iprobe], " in list ", list_number, " .length probe: ", length(probe), " iprobe: ", iprobe)
                global img = pop!(image_groups[probe[iprobe]])
                # println(img)
                # if probe[iprobe]==:SO
                #     println(img.word.initial_testpos)
                # end
               
                push!(probes, 
                Probe(EpisodicImage(
                    img.word,
                    crrcontext,
                    img.list_number, #list number
                    img.appearnum, #test position
                ), 
                    :target, #has to be target right here  
                    probe[iprobe]# the 5 general types are what as simple target foil in final test
                ))
                # println(img.word.initial_testpos)

                # println(probe[iprobe], image_groups)
 
            elseif probe[iprobe] == :FF

                if condition == :true_random


                    features = generate_features(Geometric(g_word), w_word)
                    push!(features, 0)  # For FF probes, OT feature starts as 0 (not tested before)

                    word_ff = Word(randstring(8),
                        features,
                        :FF, 
                        
                        :FF, #type_specific; mathces above in final
                        0, #study pos: 0
                        0,  #inital test position is 0

                        false, #is_repeat_type
                        :none, #type1, doesnt have a first or second appearr
                        :none
                        )
                    
                    # Set initial Z value for FF probe (foil type, so Z = 0)
                    set_initial_Z_value_for_probe!(word_ff, :FF)
                    
                    global img = EpisodicImage(word_ff, crrcontext, 0, 0)

                    # for F, the list_number will always be only [1]
                    push!(probes, 
                    Probe(
                        img, 
                        :foil, #has to be foil here 
                        :FF  #FF again
                        ))
                
                else #the difference is where set listnumber for other conditions, not valid here. 
                end
            
            else
                error("probe type wrong!")
            end  
        end

        # println([i.value for i in listcg])

    end


    return probes
end