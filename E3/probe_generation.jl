


"""generate probe for inital test for a given list,
input: studied word list; context features (word_change will modifed from the current list last word's context features)
Return: probe

list_change_features_ref: This is to be stored as a correction of the list-change context features
list feature, same as studied one
list_change_features_dynamic: changed RI after study, continuous reinstate in test

add probe type now.. 

Delete : position_code_all::Vector{Vector{Int64}}

* probe generation use context of current (flowed) context, so will be the same for any probe types
"""
function generate_probes(
    list_change_features_ref::Vector{Int64}, # Change_ctx reference
    list_change_features_dynamic::Vector{Int64},   #Change ctx to be changed
    unchange_features_ref::Vector{Int64}, # Unchange_ctx reference
    unchange_features_dynamic::Vector{Int64}, #Unchange ctx to be changed
    list_num::Int64,
    studied_pool_currList::Vector{Word} #Pass word kinds in! Do not need IMG part
    
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

    # Group studied_pool_currList images by their type_general into a dictionary
    ####Type general:
    # T; Tn; SO; SOn; F; Fn

    #only 2 kinds need to be drawn from current studypool; those of type target  
    # Keep in mind to check later: needs a deepcopy???
    studied_pool_currlist_by_type = Dict(
        :T => filter(iword -> iword.type_general == :T, studied_pool_currList)|> shuffle!,
        Symbol("Tn+1") => filter(iword -> iword.type_general == Symbol("Tn"), studied_pool_currList)|> shuffle!,
    )

    # 3 types, last target, last foil, last studyonly
    # only when list > 1, assign a prior list Dict, and then do the append in combinging the two Dict, 
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


    foils_collection = Vector{EpisodicImage}()
    for i in eachindex(probetypes) #should be 1-30
        # println("probe$(i)")
        # println(probetypes[i])
        # haskey(Dict(:a => 1, :b => 2), :ff) => return false
        # println(probetypes[i])
        if haskey(combined_studied_pool_by_type, probetypes[i]) # Check if probetype matches a key in the combined dictionary
            
            target_word = pop!(combined_studied_pool_by_type[probetypes[i]]) # Pop an item from the corresponding array
            target_word.initial_studypos = probetypes[i] in Fb_symbol_tuple ? 0 : target_word.initial_studypos; # if from last list, studypos=0, else if current list (:T ,:Tn+1 ) or (:F, :Fn+1), studypos=keep current word studypos
            target_word.initial_testpos = i # if from last list, studypos=0, if current list, studypos=current test num
            target_word.type_specific = probetypes[i] #update the type_specific

        elseif probetypes[i] in foilnew_symbol_tuple

            # println("Foil")
            #if combined_studiedpool dones't have it, (don't have the type in prior list, don't have it in current list, that means the type is either Fn or Fn)
                    
        # out of T; Tn; SO; SOn; F; Fn
            pt_general = probetypes[i] == :F ? :F : Symbol("Fn")

            target_word = 
            Word(
                randstring(8), 
                generate_features(Geometric(g_word), w_word), 
                pt_general, #type_general, either F or Fn (not Fn+1)

                probetypes[i], #type_specific
                0, #study pos: 0
                i, #test position 

                probetypes[i] == :F ? false : true, #is_repeat_type
                :F, #type1, will be :F whatsoever
                probetypes[i]== :F ? :none : :Fb #type2, general type, 

                #the last two assignment could check in const beginnig clarification line on 1, 2 for each line
            ) # Insert studypos 0
        else
            error("probetype not in the list")
        end


        # Combine the two loops into one function to avoid redundancy
        # Reinstate changing context for each test position
        reinstate_context_duringTest!(list_change_features_dynamic, list_change_features_ref)

        # Reinstate unchanging context if applicable
        if is_UnchangeCtxDriftAndReinstate #true
            reinstate_context_duringTest!(unchange_features_dynamic, unchange_features_ref)
        end   # println("$(list_change_features_dynamic)")
            
        #Target word is unique deep copied, so shouldn't overlap. get only current studypos, not a prior one
        current_studypos = target_word.initial_studypos;
        current_testpos = i; 

        current_context_features = fast_concat([deepcopy(unchange_features_dynamic), deepcopy(list_change_features_dynamic)]) #here needs a deepcopy, otherwise the front remembered context change with later ones  
        

        probes[i] = Probe( #create prob from current created target word i
            # appearnum: if old kind, second time appear
            EpisodicImage(target_word, current_context_features, list_num, probetypes[i] in Fb_symbol_tuple ? 2 : 1),
            
            probetypes[i] in T_target_tuple ? :target : :foil, #target or foil
            probetypes[i] in  T_target_tuple ? :T : probetypes[i] in Fb_symbol_tuple ? :Fb : :F #general type of probe, F, Fb or T
        )

        if probetypes[i] in foilnew_symbol_tuple
            # println("foil")
            push!(foils_collection, deepcopy(probes[i].image)) # Append a deep copy of the foil to the collection
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


    return probes, foils_collection
end




"""Input the flattened studied pool, first 30 are t/n/f in list 1, and etc; give last list's list_change_cf to change from list to list for probes
    
    Add, make initial_testpos in probes
Vec type for episodic image
    """
function generate_finalt_probes(studied_pool::Vector{EpisodicImage}, condition::Symbol, unchange_features_ref::Vector{Int64}, list_change_context_features::Vector{Int64})::Vector{Probe}

    listcg = deepcopy(list_change_context_features)
    unchangecg = deepcopy(unchange_features_ref);
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
            for cf in eachindex(listcg)
                if rand() < p_ListChange_finaltest[icount] #cf.change_probability # this equals p_change
                    listcg[cf] = rand(Geometric(g_context)) + 1
                end
            end
        end


        # for cf in eachindex(unchangecg)
        #     if rand() < 0.01 #cf.change_probability # this equals p_change
        #         unchangecg[cf] = rand(Geometric(g_context)) + 1
        #     end
        # end

        # images hold pool_image of the current list, 
        images = studyPool_Img_byList[list_number]
        image_groups = Dict(type => filter(img -> img.word.type_general == type, images) |> shuffle! for type in [:T, :Tn, :SO, :SOn, :F, :Fn]);

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

                # Only make changes at the start of every list (excluding the start of the first list)
                # Calculate the chunk boundaries dynamically
                iprobe_chunk_boundaries = cumsum([total_probe_L1 * nItemPerUnit_final * 2; fill(total_probe_Ln * nItemPerUnit_final * 2, 9)])  # First chunk has 15*2*2 items, rest 9 chunks have 12*2*2 items

                # Determine the chunk index for the current probe
                iprobe_chunk = findfirst(x -> iprobe <= x, iprobe_chunk_boundaries)   
                # iprobe_chunk = findlast(x -> iprobe > x, iprobe_chunk_boundaries)
                
                # println(i)
                # println("iprobe: ", iprobe)
                # println("iprobe_chunk_boundaries: ", iprobe_chunk_boundaries)
                # println([iprobe <= x for x in iprobe_chunk_boundaries])
                # println(iprobe_chunk)

                if (iprobe != 1) && (iprobe_chunk != findlast(x -> (iprobe - 1) > x, iprobe_chunk_boundaries)) && (iprobe_chunk > 1) 

                    # println("iprobe ", iprobe, " iprobe_chunk ", iprobe_chunk, " flag ")
                    for cf in eachindex(listcg)
                        if rand() < p_ListChange_finaltest[icount] # cf.change_probability, this equals p_change
                            listcg[cf] = rand(Geometric(g_context)) + 1
                        end
                    end
                end   # println("iprobe ",iprobe, " iprobe_chunk ", iprobe_chunk, " flag ", iprobe_chunk != findlast(x -> (iprobe - 1) > x, iprobe_chunk_boundaries))

                # TODO: check iprobe_chunk correct use here, previously i was using count because i didn't add change into random condition throughout final random condi 

                for cf in eachindex(listcg)
                    if rand() < p_ListChange_finaltest[iprobe_chunk] #cf.change_probability # this equals p_change
                        listcg[cf] = rand(Geometric(g_context)) + 1
                    end
                end
                

                # for cf in eachindex(unchangecg)
                #     if rand() < p_driftAndListChange_final_ #cf.change_probability # this equals p_change
                #         unchangecg[cf] = rand(Geometric(g_context)) + 1
                #     end
                # end

            end

            global img = nothing  # Initialize img as nothing to refresh its value in each iteration

            crrcontext = fast_concat([deepcopy(unchangecg), deepcopy(listcg)]);

            ######### If true, current probe is target and so get new prob from past 

            # if (img.word.initial_testpos>30)
            #     println(img.list_number, img.word.initial_testpos)
            # end

            if haskey(image_groups, probe[iprobe])

                global img = pop!(image_groups[probe[iprobe]])

               
                push!(probes, 
                Probe(img, 
                    :target, #has to be target right here  
                    probe[iprobe]# the 5 general types are what as simple target foil in final test
                ))
                # println(img.word.initial_testpos)

                # println(probe[iprobe], image_groups)
 
            elseif probe[iprobe] == :FF

                if condition == :true_random

                    global img = EpisodicImage(
                        Word(randstring(8),
                            rand(Geometric(g_word), w_word) .+ 1,
                            :FF, 
                            
                            :FF, #type_specific; mathces above in final
                            0, #study pos: 0
                            0,  #inital test position is 0

                            false, #is_repeat_type
                            :none, #type1, doesnt have a first or second appearr
                            :none
                            ), crrcontext, 0, 0)

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