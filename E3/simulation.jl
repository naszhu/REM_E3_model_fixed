


function run_single_simulation(sim_num::Int)
    # Single simulation logic extracted for parallelization
    # Fix: Each thread gets its own RNG to avoid contention
    rng = Random.MersenneTwister(sim_num + 1000)
    image_pool = EpisodicImage[]
    
    # Pre-allocate results arrays for this simulation (with safety margin)
    # List 1 has n_inEachChunk[1] tests, others have n_inEachChunk[2] tests
    expected_initial_rows = n_inEachChunk[1] + (n_lists-1) * n_inEachChunk[2]
    expected_final_rows = is_finaltest ? n_finalprobs : 0
    
    # Use generous size based on observed usage
    initial_results = Vector{Any}(undef, 2000)  # Generous size to avoid resizing
    final_results = Vector{Any}(undef, max(1000, round(Int, expected_final_rows * 1.2)))
    initial_count = 0
    final_count = 0

    # Pre-allocate context arrays to avoid deepcopy in loops
    temp_context = Vector{Int64}(undef, w_allcontext)
    
    #    sim_num=1

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
                # Optimized: avoid deepcopy by reusing pre-allocated array
                temp_context[1:length(general_context_features)] = general_context_features
                temp_context[length(general_context_features)+1:length(general_context_features)+length(list_change_context_features)] = list_change_context_features
                current_context_features = temp_context


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
                drift_ctx_betweenStudyAndTest!(test_list_context_change, p_driftStudyTest, Geometric(g_context))

                if is_UnchangeCtxDriftAndReinstate #false
                    drift_ctx_betweenStudyAndTest!(test_list_context_unchange, p_driftStudyTest, Geometric(g_context))
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
                deepcopy(current_list_words),
                studied_pool;
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

            # Optimized: collect results instead of push!
            for (ires, res) in enumerate(results) #1D array, length is 20 words
                initial_count += 1
                if initial_count > length(initial_results)
                    println("Warning: initial_count ($initial_count) exceeds array size ($(length(initial_results))). Expanding array.")
                    resize!(initial_results, initial_count * 2)
                end
                initial_results[initial_count] = [list_num, res.testpos, sim_num, res.decision_isold, res.is_target, String(res.type_general), String(res.type_specific), res.odds, res.Nratio_iprobe, res.Nratio_imageinlist, res.N_imageinlist, res.ilist_image, res.studypos, res.diff, res.is_same_item, res.is_sampled, res.Z_sum, res.Z_proportion]
            end

            # Update list_change_context_features 

            drift_between_lists!(list_change_context_features, n_between_listchange[list_num], p_driftBetweenList)   # println([i.value for i in list_change_context_features])

            # list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_driAndndListChange,rand(Geometric(g_context),length(list_change_context_features)) .+ 1,list_change_context_features)
            # println([i.value for i in list_change_context_features])

            # The following part is for OT drift between this two...
            # for i_img in image_pool
            #     i_img.word.word_features[tested_before_feature_pos] = rand() < κ_update_between_list ? i_img.word.word_features[tested_before_feature_pos]+ ot_value_between_lists : i_img.word.word_features[tested_before_feature_pos];
            # end

            # The Z drift between list (is applied for studied only items):
            # Update Z features for single-appearance studied items between lists
            update_Z_features_single_appearance_studied_items!(image_pool, studied_pool, list_num, n_studyitem)
            
            # # Update studied_pool items with their initial_testpos from the initial test
            # for (i, probe) in enumerate(probes)
            #     # if probe.ProbeTypeSimple == :target && (probe.ProbeTypeGeneral == :T || probe.ProbeTypeGeneral == :Tn)
            #         # Find the corresponding item in studied_pool and update its initial_testpos
            #         for j in 1:n_studyitem
            #             if !isnothing(studied_pool[list_num][j]) && 
            #                (studied_pool[list_num][j].word.type_general == :T || studied_pool[list_num][j].word.type_general == :Tn) &&
            #                studied_pool[list_num][j].word.item_code == probe.image.word.item_code
            #                 studied_pool[list_num][j].word.initial_testpos = i
            #                 break
            #             end
            #         end
            #     # end
            # end


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

                # Optimized: collect final results instead of push!
                for ii in eachindex(results_final)
                    res = results_final[ii]
                    final_count += 1
                    if final_count > length(final_results)
                        println("Warning: final_count ($final_count) exceeds array size ($(length(final_results))). Expanding array.")
                        resize!(final_results, final_count * 2)
                    end
                    final_results[final_count] = [res.list_num, res.test_position, res.initial_studypos, res.initial_testpos, replace(string(res.type_specific), r"n\+1" => "n_p1"), String(res.type_general), res.is_target, sim_num, String(icondition), res.decision_isold, res.odds, res.is_same_item, res.is_sampled, res.Z_sum, res.Z_proportion]
                end
            end
        end

    # Return collected results from this simulation
    return initial_results[1:initial_count], final_results[1:final_count]
end

function simulate_rem()
    # 1. Initialization - Pre-allocate main DataFrames
    println("Starting optimized simulation with $(Threads.nthreads()) threads...")
    
    # Estimate total result sizes (use generous estimate based on observed usage)
    total_initial_rows = n_simulations * 2000  # Generous estimate to avoid resizing
    total_final_rows = is_finaltest ? n_simulations * n_finalprobs : 0
    
    df_inital = DataFrame(
        list_number=Vector{Int}(undef, total_initial_rows),
        testpos=Vector{Int}(undef, total_initial_rows), 
        simulation_number=Vector{Int}(undef, total_initial_rows),
        decision_isold=Vector{Int}(undef, total_initial_rows),
        is_target=Vector{Bool}(undef, total_initial_rows),
        type_general=Vector{String}(undef, total_initial_rows),
        type_specific=Vector{String}(undef, total_initial_rows),
        odds=Vector{Float64}(undef, total_initial_rows),
        Nratio_iprobe=Vector{Float64}(undef, total_initial_rows),
        Nratio_imageinlist=Vector{Float64}(undef, total_initial_rows),
        N_imageinlist=Vector{Float64}(undef, total_initial_rows),
        ilist_image=Vector{Int}(undef, total_initial_rows),
        studypos=Vector{Int}(undef, total_initial_rows),
        diff=Vector{Float64}(undef, total_initial_rows),
        is_same_item=Vector{Bool}(undef, total_initial_rows),
        is_sampled=Vector{Bool}(undef, total_initial_rows),
        Z_sum=Vector{Int}(undef, total_initial_rows),
        Z_proportion=Vector{Float64}(undef, total_initial_rows)
    )

    df_final = DataFrame(
        list_number=Vector{Int}(undef, total_final_rows),
        test_position=Vector{Int}(undef, total_final_rows),
        initial_studypos=Vector{Int}(undef, total_final_rows),
        initial_testpos=Vector{Int}(undef, total_final_rows),
        type_specific=Vector{String}(undef, total_final_rows),
        type_general=Vector{String}(undef, total_final_rows),
        is_target=Vector{Bool}(undef, total_final_rows),
        simulation_number=Vector{Int}(undef, total_final_rows),
        condition=Vector{String}(undef, total_final_rows),
        decision_isold=Vector{Int}(undef, total_final_rows),
        odds=Vector{Float64}(undef, total_final_rows),
        is_same_item=Vector{Bool}(undef, total_final_rows),
        is_sampled=Vector{Bool}(undef, total_final_rows),
        Z_sum=Vector{Int}(undef, total_final_rows),
        Z_proportion=Vector{Float64}(undef, total_final_rows)
    )

    # Run simulations in parallel
    println("Running $(n_simulations) simulations in parallel...")
    results = Vector{Tuple{Vector{Any}, Vector{Any}}}(undef, n_simulations)
    
    Threads.@threads for sim_num in 1:n_simulations
        if sim_num % max(1, n_simulations ÷ 10) == 0
            println("Progress: $(sim_num * 100 ÷ n_simulations)% simulations completed.")
        end
        results[sim_num] = run_single_simulation(sim_num)
    end
    
    # Combine results from all simulations
    println("Combining results...")
    total_initial_count = 0
    total_final_count = 0
    
    for sim_num in 1:n_simulations
        initial_res, final_res = results[sim_num]
        
        # Copy initial results
        for i in eachindex(initial_res)
            total_initial_count += 1
            row = initial_res[i]
            df_inital[total_initial_count, :list_number] = row[1]
            df_inital[total_initial_count, :testpos] = row[2]
            df_inital[total_initial_count, :simulation_number] = row[3]
            df_inital[total_initial_count, :decision_isold] = row[4]
            df_inital[total_initial_count, :is_target] = row[5]
            df_inital[total_initial_count, :type_general] = row[6]
            df_inital[total_initial_count, :type_specific] = row[7]
            df_inital[total_initial_count, :odds] = row[8]
            df_inital[total_initial_count, :Nratio_iprobe] = row[9]
            df_inital[total_initial_count, :Nratio_imageinlist] = row[10]
            df_inital[total_initial_count, :N_imageinlist] = row[11]
            df_inital[total_initial_count, :ilist_image] = row[12]
            df_inital[total_initial_count, :studypos] = row[13]
            df_inital[total_initial_count, :diff] = row[14]
            df_inital[total_initial_count, :is_same_item] = row[15]
            df_inital[total_initial_count, :is_sampled] = row[16]
            df_inital[total_initial_count, :Z_sum] = row[17]
            df_inital[total_initial_count, :Z_proportion] = row[18]
        end
        
        # Copy final results if they exist
        for i in eachindex(final_res)
            total_final_count += 1
            row = final_res[i]
            df_final[total_final_count, :list_number] = row[1]
            df_final[total_final_count, :test_position] = row[2]
            df_final[total_final_count, :initial_studypos] = row[3]
            df_final[total_final_count, :initial_testpos] = row[4]
            df_final[total_final_count, :type_specific] = row[5]
            df_final[total_final_count, :type_general] = row[6]
            df_final[total_final_count, :is_target] = row[7]
            df_final[total_final_count, :simulation_number] = row[8]
            df_final[total_final_count, :condition] = row[9]
            df_final[total_final_count, :decision_isold] = row[10]
            df_final[total_final_count, :odds] = row[11]
            df_final[total_final_count, :is_same_item] = row[12]
            df_final[total_final_count, :is_sampled] = row[13]
            df_final[total_final_count, :Z_sum] = row[14]
            df_final[total_final_count, :Z_proportion] = row[15]
        end
    end
    
    # Trim DataFrames to actual size
    df_inital = df_inital[1:total_initial_count, :]
    if is_finaltest
        df_final = df_final[1:total_final_count, :]
    else
        df_final = df_final[1:0, :] # Empty DataFrame
    end
    
    println("Simulation completed successfully!")
    return df_inital, df_final
end


