


function simulate_rem()
    # 1. Initialization

    df_inital = DataFrame(list_number=Int[], testpos=Int[], simulation_number=Int[], decision_isold=Int[], is_target=Bool[], type_general=String[], type_specific=String[], odds=Float64[], Nratio_iprobe=Float64[], Nratio_imageinlist=Float64[], N_imageinlist=Float64[], ilist_image=Int[], studypos=Int[], diff=Float64[], is_same_item=Bool[], is_sampled=Bool[], Z_sum=Int[], Z_proportion=Float64[])

    df_final = DataFrame(
        list_number=Int[], #initial list number, not containing final list num yet 
    test_position=Int[],
    initial_studypos=Int[],
    initial_testpos=Int[],
    
    type_specific=String[],
    type_general=String[],
    is_target=Bool[],

    simulation_number=Int[], 
    condition=String[], 
    decision_isold=Int[],  odds=Float64[], is_same_item=Bool[], is_sampled=Bool[], Z_sum=Int[], Z_proportion=Float64[])

    for sim_num in 1:n_simulations

        if sim_num % (n_simulations ÷ 10) == 0
            println("Progress: $(sim_num * 100 ÷ n_simulations)% simulations completed.")
        end
        #    sim_num=1
        image_pool = EpisodicImage[]

        # studied_pool contains all single appear img in iniital test, and no repeatition  
        ## DEFINE STUDIED POOL
        studied_pool = Vector{Vector{EpisodicImage}}(undef, n_lists) # Create a vector of vectors for each list
        for list_num in 1:n_lists
            studied_pool[list_num] = Vector{EpisodicImage}(undef, list_num == 1 ? total_probe_L1 * nItemPerUnit : total_probe_Ln * nItemPerUnit) # Different lengths for the first row vs. later rows
            # println(length(studied_pool[list_num]))
        end
        ## STUDIED POOL DEFINE FINISH  
        general_context_features = rand(Geometric(g_context), nU) .+ 1#
        list_change_context_features = rand(Geometric(g_context), nC) .+ 1
        
        for list_num in 1:n_lists
            
            


            # There can't be any undefined elements from last list in current study list, add this check here
            ##FETCH last list studied_pool (including foil):

            if list_num > 1
                # if (length(filter(!missing,studied_pool[list_num-1]))>=1)
                #     error("studied_pool[:, list_num-1] contains undefined elements")
                # end
                # println(studied_pool[list_num-1])
                last_list_words = [iimg.word for iimg in studied_pool[list_num-1]]
            end

            # position_code_all = [fill(0, w_positioncode) for _ in 1:n_words]

            word_list = generate_study_list(list_num, g_word, w_word) #::Vector{Word}
            # word_change_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1;

            for j in eachindex(word_list)

                # if j == 1
                #     position_code_features_study = rand(Geometric(g_context), w_positioncode) .+ 1
                # else
                #     position_code_features_study = deepcopy(position_code_all[j-1])
                #     for ij in 1:w_positioncode
                #         if rand() < p_poscode_change * (j - 1) #cf.change_probability # this equals p_change
                #             position_code_features_study[ij] = rand(Geometric(g_context)) + 1
                #         end
                #     end
                #     # println("previous code$(position_code_all[j-1]),current code$(position_code_features_study)")
                # end

                # position_code_all[j] = position_code_features_study
                current_context_features = fast_concat([deepcopy(general_context_features), deepcopy(list_change_context_features)]) #dlete position code in this line in concatenation


                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num, 0)

                # study in here
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num)
            # for i in image_pool
            #     if i.word.type_general == :T
            #         println(i.word.initial_testpos)
            #     end
            # end
            # for i in image_pool
                # if episodic_image.word.type_general == :T
                #     println(episodic_image.word.initial_testpos)
                # end
            # end

                # for cf in eachindex(word_change_context_features)
                #     if rand() <  p_wordchange #cf.change_probability # this equals p_change
                #         word_change_context_features[cf] = rand(Geometric(g_context)) + 1 
                #     end
                # end

                # target and nontarget stored into studied pool 
                studied_pool[list_num][j] = episodic_image
                
                # if episodic_image.word.type_general == :T
                #     println(episodic_image.word.initial_testpos)
                #     # println("list $(list_num), word $(j), initial_studypos $(episodic_image.word.initial_studypos)")
                #     # println("word type_general: ", episodic_image.word.type_general)
                #     # println("word type_specific: ", episodic_image.word.type_specific)
                # end
                
            end

            # println(studied_pool[list_num])

            current_list_words = [iimg.word for iimg in studied_pool[list_num][1:n_studyitem]] #] Get the first n_studyitem elements


            # study_list_context = deepcopy(list_change_context_features);
            test_list_context_change = deepcopy(list_change_context_features)
            test_list_context_unchange = deepcopy(general_context_features)

            # word_list_content_whole_list = Vector{Any}(undef, length(word_list))
            # for i_word in eachindex(word_list)
            #     content_i = deepcopy(word_list[i_word].word_features)
            #     word_list_content_whole_list[i_word] = content_i
            # end

            # list_change_context_features only change between lists, change after each list;
            # list_change_context_features use as a record, to reinstate in probe generation 
            # Define a function for drifting context features


            # Apply the drift function to both changing and unchanging contexts
            ##DRIFT between study and test
            # this essentially could be moved to drfit_between_list function, but I'll leave that for now....
            for _ in 1:n_driftStudyTest[list_num]
                drift_ctx_betweenStudyAndTest!(test_list_context_change, p_driftAndListChange, Geometric(g_context))

                if is_UnchangeCtxDriftAndReinstate #false
                    drift_ctx_betweenStudyAndTest!(test_list_context_unchange, p_driftAndListChange, Geometric(g_context))
                end

                # if is_content_drift_between_study_and_test #true

                #     for iword in eachindex(word_list_content_whole_list)

                #         drift_ctx_betweenStudyAndTest!(word_list_content_whole_list[iword], p_driftAndListChange, Geometric(g_word))
                #     end
                # end
            end   #studied_pool[:, list_num]
            # studied_pool[j, list_num]


            # println("list $(list_num), ")
            # @assert length(filter(prb -> prb.classification == :foil, probes)) == Int(n_probes / 2) "wrong number!"
            # Assuming `generate_probes` now returns a tuple (probes, foils)
            last_lw = list_num > 1 ? (last_list_words = deepcopy(last_list_words)) : () # last_lw is the last list words, if list_num == 1, then it is undef;

            # for i in image_pool
            #     if i.word.type_general == :T
            #         println(i.word.initial_testpos)
            #     end
            # end
            probes, foils = generate_probes(
                list_change_context_features,
                test_list_context_change,
                general_context_features,
                test_list_context_unchange,
                list_num,
                deepcopy(current_list_words);
                studied_pool_lastList=last_lw
            )

            # if any(isundef, studied_pool[list_num])
            #     error("studied_pool[:, list_num] contains undefined elements. Ensure all elements are initialized before accessing.")
            # Fill the rest of the studied pool with the foils
            # studied_pool[list_num][n_studyitem+1:end] = filter(x -> !isnothing(x), [foil.image for foil in foils])

            @assert length(filter(isnothing, studied_pool[list_num][1:n_studyitem])) == 0 "There are still undefined items in studied_pool[:, list_num]"   # the place to start in each list is the same, becuase there are same number of new study item in each list 
            # println(list_num)
            studied_pool[list_num][n_studyitem+1:end] = foils

            results = probe_evaluation(image_pool, probes, list_change_context_features, general_context_features, sim_num)
            # println(results)
            # println("ImagePoolNow", [i.word.item for i in image_pool])

            # df_inital = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], decision_isold=Int[], is_target=Bool[], type_general=String[], type_specific=String[], odds=Float64[], Nratio_iprobe=Float64[], Nratio_iimageinlist=Float64[], N_imageinlist=Float64[], ilist_image=Int[], study_position=Int[], diff_rt=Float64[])

            for (ires, res) in enumerate(results) #1D array, length is 20 words
                # tt = res.is_target == :target ? true : false

                row = [list_num, res.testpos, sim_num, res.decision_isold, res.is_target, String(res.type_general), String(res.type_specific), res.odds, res.Nratio_iprobe, res.Nratio_imageinlist, res.N_imageinlist, res.ilist_image, res.studypos, res.diff, res.is_same_item, res.is_sampled, res.Z_sum, res.Z_proportion] # Add Z_sum and Z_proportion columns
                
                push!(df_inital, row)
            end

            # Update list_change_context_features 

            drift_between_lists!(list_change_context_features, n_between_listchange[list_num], p_driftAndListChange)   # println([i.value for i in list_change_context_features])

            # list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_driAndndListChange,rand(Geometric(g_context),length(list_change_context_features)) .+ 1,list_change_context_features)
            # println([i.value for i in list_change_context_features])

            # The following part is for OT drift between this two...
            # for i_img in image_pool
            #     i_img.word.word_features[tested_before_feature_pos] = rand() < κ_update_between_list ? i_img.word.word_features[tested_before_feature_pos]+ ot_value_between_lists : i_img.word.word_features[tested_before_feature_pos];
            # end

            # The Z drift between list (is applied for studied only items):
            # Update Z features for single-appearance studied items between lists
            update_Z_features_single_appearance_studied_items!(image_pool, studied_pool, list_num, n_studyitem)


        end

        studied_pool = vcat(studied_pool...)
        # println(studied_pool)
        #final test here

        #update change and unchanging context between study and test...
        drift_ctx_betweenStudyAndTest!(general_context_features, final_gap_change, Geometric(g_context))

        drift_ctx_betweenStudyAndTest!(list_change_context_features, final_gap_change, Geometric(g_context))
        # list_change_context_features

        # for i in studied_pool
        #     if i.word.type_general==:T
        #         println(i.word.initial_testpos)
        #     end
        # end

        if is_finaltest
            # for icondition in [:forward, :backward, :true_random]
            for icondition in [:true_random]
                image_pool_bc = deepcopy(image_pool)
                finalprobes = generate_finalt_probes(studied_pool, icondition, general_context_features, list_change_context_features)
                results_final = probe_evaluation2(image_pool_bc, finalprobes)

                for ii in eachindex(results_final)

                    res = results_final[ii]

                    push!(df_final, 
                    [res.list_num,  
                    res.test_position,
                    res.initial_studypos,   
                    res.initial_testpos,

                    replace(string(res.type_specific, r"n\+1" => "n_p1")),
                    String(res.type_general),   
                    res.is_target,

                    sim_num, 
                    String(icondition), 
                    res.decision_isold, res.odds, res.is_same_item, res.is_sampled, res.Z_sum, res.Z_proportion])
                end
            end
        end


    end

    return df_inital, df_final
end


