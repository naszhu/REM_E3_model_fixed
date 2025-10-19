



"""
restore content and/or context, here, context include change,unchange, and positioncode. position code is not restored but add to new trace when don't restore context
"""
# flagn = Int64[];
# data_flag = Array{Vector{Any}}(undef, n_simulations)  # Create an array to hold vectors for each simulation
# for i in 1:n_simulations
#     data_flag[i] = Vector{Any}()  # Initialize each row as an empty vector
# end

# function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, odds::Float64, likelihood_ratios::Vector{Float64}, simu_i::Int64, initial_testpos::Int64)
function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, odds::Float64, content_LL_ratios::Vector{Float64}, sampled_item::Union{EpisodicImage, Nothing}, criterion::Float64)::Nothing


    if is_onlyaddtrace
        error("not coded here")
    end
    #is_onlyaddtrace is false
    # println("nothere")

    # if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))| ((decision_isold==1) & (odds > recall_odds_threshold)) #just get a new empty EI

        iimage_toadd = EpisodicImage(
            #Word:
            Word(iprobe_img.word.item_code, #item_code
                fill(0, w_word + n_ot_features), #word features - always 25 (24 normal + 1 OT) #word features
                iprobe_img.word.type_general, #type_general
                iprobe_img.word.type_specific, #type_specific
                iprobe_img.word.initial_studypos, #initial_studypos
                iprobe_img.word.initial_testpos, #initial_studypos
                iprobe_img.word.is_repeat_type, #is_repeat_type
                iprobe_img.word.type1, #type1
                iprobe_img.word.type2 #type2
            ), 
            # zeros(length(iprobe_img.context_features)),#Context_features: 
            fill(0, length(iprobe_img.context_features)),#Context_features: 
            iprobe_img.list_number,#List_Number; 
            iprobe_img.appearnum #appearnum
        )
    # end

        
    if (((odds > criterion)) && (odds > recall_odds_threshold) )

        if !isnothing(sampled_item)
            # Use the pre-sampled item
            iimage_tostrenghten = sampled_item
        else
            # If nothing was sampled, criteria didn't pass, so no restoration should happen
            # This case should not occur in normal operation since sampling happens before decision logic
            error("No item was sampled but restoration was attempted. This indicates a logic error.")
        end
    
    end



    # if new, or old but didn't pass threshold -- ADD TRACE 
    # (start with empty EI, then add features)

    c_storeintest_ilist = c_storeintest[iprobe_img.list_number];
    c_context_ilist_cc = c_context_c[iprobe_img.list_number];
    c_context_ilist_cu = c_context_un[iprobe_img.list_number];

    # if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))| ((decision_isold==1) & (odds > recall_odds_threshold))


        for _ in 1:n_units_time_restore
            #shouldn't have this in adding trace

        # println(iprobe_img.word.type_general)
        # for _ in 1:n_units_time #shouldn't have this in adding trace
            # Update word features
            add_feature_during_restore!(iimage_toadd.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest_ilist, g_word, iprobe_img.list_number)
            @assert length(iprobe_img.context_features) == length(iimage_toadd.context_features) "context features should be the same length"

            # Update context features
            # u_advFoilInitialT is the adv for foil (judged new, add trace) in initial test, to see if final test p overlappsss....u_advFoilInitialT=0 currently
            @assert u_star_context[end] == u_star_context[1] "u_star_context is not well defined to be used in restore_intest for intial test, final test is dependant on u_star_context[ilist], but not yet like that in inital test, initial doens't have a u_star_context difference right now, notice"
            add_feature_during_restore!(iimage_toadd.context_features, iprobe_img.context_features, u_star_context[end] + u_advFoilInitialT, c_context_ilist_cc, g_context, iprobe_img.list_number; cu = c_context_ilist_cu) 
        end



    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    if ((decision_isold==1) & (odds > recall_odds_threshold) )

        # println(iprobe_img.word.type_general)
        if is_strengthen_contextandcontent #true
            strengthen_features!(iimage_tostrenghten.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore, iprobe_img.list_number)


            strengthen_features!(iimage_tostrenghten.context_features, iprobe_img.context_features, p_recallFeatureStore, iprobe_img.list_number, is_ctx=true)

            # Use new Z-update rules based on decision type
            if decision_isold == 0  # Recalled + New (confusing foil)
                update_Z_feature_recalled_new_strengthen!(iimage_tostrenghten.word, iprobe_img.list_number)
            else  # decision_isold == 1, Recalled + Old
                update_Z_feature_recalled_old!(iimage_tostrenghten.word, iprobe_img.list_number)
            end

        else
            # error("should strenghen here")
        end

        # the following makes sure that we actually must need to restore context.
        !is_restore_context ? error("context restored in initial is not well written this part") : nothing

    end

    is_strenghten = (odds > criterion) && (odds > recall_odds_threshold) 

    
    if (odds < criterion) || ((odds > criterion) && (odds < recall_odds_threshold))|| ((odds > criterion) && (odds > recall_odds_threshold) && (odds<recall_to_addtrace_threshold)) 
        
        if is_strenghten #Add trace while strengthening is also happening.
            # Use new Z-update rules based on decision type
            if decision_isold == 0  # Recalled + New (confusing foil)
                update_Z_feature_recalled_new_add_trace!(iimage_toadd.word, iprobe_img.list_number)
            else  # decision_isold == 1, Recalled + Old
                update_Z_feature_recalled_old!(iimage_toadd.word, iprobe_img.list_number)
            end
        else #  use the update add trace only - not recalled cases
            if decision_isold == 0  # Not recalled + New (really new foil)
                update_Z_feature_not_recalled_new!(iimage_toadd.word, iprobe_img.list_number)
            else  # decision_isold == 1, Not recalled + Old (target with no trace recalled)
                update_Z_feature_not_recalled_old!(iimage_toadd.word, iprobe_img.list_number)
            end
        end
        
        
        push!(image_pool, iimage_toadd)
        # println("pass, decision_isold $(decision_isold); is pass $(odds < recall_odds_threshold)")
    else
        # print("here")
    end

    return nothing


end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, odds::Float64, finaltest_pos::Int64, content_LL_ratios::Vector{Float64}, sampled_item::Union{EpisodicImage, Nothing}, criterion::Float64)::Nothing
#     iimage = decision_isold == 1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)
# # println(iimage.initial_testpos_img)

    # if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))| ((decision_isold==1) & (odds > recall_odds_threshold)) 
    
        iimage_toadd = EpisodicImage(
            #Word:
            Word(iprobe_img.word.item_code, #item_code
                fill(0, w_word + 1), #word features - always 25 (24 normal + 1 OT)#word features
                iprobe_img.word.type_general, #type_general
                iprobe_img.word.type_specific, #type_specific
                iprobe_img.word.initial_studypos, #initial_studypos
                iprobe_img.word.initial_testpos, #initial_studypos
                iprobe_img.word.is_repeat_type, #is_repeat_type
                iprobe_img.word.type1, #type1
                iprobe_img.word.type2 #type2
            ), 
            zeros(length(iprobe_img.context_features)),#Context_features: 
            iprobe_img.list_number,#List_Number; 
            iprobe_img.appearnum #appearnum
        )

    # end
    if ((odds > criterion) && (odds > recall_odds_threshold_final) )

        if !isnothing(sampled_item)
            # Use the pre-sampled item
            iimage_tostrenghten = sampled_item
        else
            # If nothing was sampled, criteria didn't pass, so no restoration should happen
            # This case should not occur in normal operation since sampling happens before decision logic
            error("No item was sampled but restoration was attempted. This indicates a logic error.")
        end

    end

    
    ############# ADD TRACE ######################
    # if new, or old but didn't pass threshold -- ADD TRACE
    # if (decision_isold == 0)| ((decision_isold == 1) & (odds < recall_odds_threshold_final))| ((decision_isold==1) & (odds > recall_odds_threshold_final)) 

        # Check if c varies by list and show error if it doesn't
        @assert length(unique(c_storeintest)) == 1 "c_storeintest does vary by list. This may indicate a configuration issue."

        c_storeintest_ilist = c_storeintest[end];
        c_context_ilist_cc = c_context_c[end];
        c_context_ilist_cu = c_context_un[end];
        
        for _ in 1:n_units_time_restore

            add_feature_during_restore!(iimage_toadd.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest_ilist[end], g_word, iprobe_img.list_number) #TODO

            # if iprobe_img.list_number == 1

            # Issue 12, 13(ambigiou use const array)
            # this problem occur u_star_context[probe_img.list_number] has problem here because should not use probe's list number but final test order list number, but I don't have that in my structure right now

            iprobe_chunk_boundaries = cumsum([total_probe_L1 * nItemPerUnit_final * 2; fill(total_probe_Ln * nItemPerUnit_final * 2, 9)])  # First chunk has 15*2*2 items, rest 9 chunks have 12*2*2 items

            # Determine the chunk index for the current probe
            iprobe_chunk = findfirst(x -> finaltest_pos <= x, iprobe_chunk_boundaries)  

            # add_feature_during_restore!(iimage_toadd.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest[end], g_word, iprobe_img.list_number) #TODO

            add_feature_during_restore!(iimage_toadd.context_features, iprobe_img.context_features, u_star_context[end] + u_advFoilInitialT, c_context_ilist_cc, g_context, iprobe_img.list_number; cu = c_context_ilist_cu) 
        

            # else
                # add_features_from_empty!(iimage.context_features, iprobe_img.context_features, u_star_context[end]+u_advFoilInitialT+0.1, c_context_ilist, g_context)
            
            # end


        end


    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    if ((odds > criterion) & (odds > recall_odds_threshold_final) )

        # pass: strenghten
        #single parameter for missing or replacing
        # WARNING: rand(Geometric(g_word)) + 1) is not used here, there is no chance of an incorrect random value storage when judging old 

        if !is_store_mismatch
            error("current prog is not written when doesn't store mismatch")
        end

        if is_strengthen_contextandcontent #true
            strengthen_features!(iimage_tostrenghten.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore, iprobe_img.list_number)


            strengthen_features!(iimage_tostrenghten.context_features, iprobe_img.context_features, p_recallFeatureStore, iprobe_img.list_number, is_ctx=true)

            # Use new Z-update rules based on decision type
            if decision_isold == 0  # Recalled + New (confusing foil)
                update_Z_feature_recalled_new_strengthen!(iimage_tostrenghten.word, iprobe_img.list_number)
            else  # decision_isold == 1, Recalled + Old
                update_Z_feature_recalled_old!(iimage_tostrenghten.word, iprobe_img.list_number)
            end

        else
             # nothing for now
        end

        !is_restore_context ? error("context restored in initial is not well written this part") : nothing


    end

    # if (decision_isold == 0)
    is_strenghten = (odds > criterion) && (odds > recall_odds_threshold_final) 

    if (odds <= criterion) || ((odds > criterion) && (odds < recall_odds_threshold_final))|| ((odds > criterion) && (odds > recall_odds_threshold_final) && (odds<recall_to_addtrace_threshold)) 
        
   
        if is_strenghten #Add trace while strengthening is also happening.
            # Use new Z-update rules based on decision type
            if decision_isold == 0  # Recalled + New (confusing foil)
                update_Z_feature_recalled_new_add_trace!(iimage_toadd.word, iprobe_img.list_number)
            else  # decision_isold == 1, Recalled + Old
                update_Z_feature_recalled_old!(iimage_toadd.word, iprobe_img.list_number)
            end
        else  
            # Not recalled cases - add trace only
            if decision_isold == 0  # Not recalled + New (really new foil)
                update_Z_feature_not_recalled_new!(iimage_toadd.word, iprobe_img.list_number)
            else  # decision_isold == 1, Not recalled + Old (target with no trace recalled)
                update_Z_feature_not_recalled_old!(iimage_toadd.word, iprobe_img.list_number)
            end
        end

        push!(image_pool, iimage_toadd)

    elseif odds<recall_to_addtrace_threshold
        error("there is no recall to add trace threshold but somehow not all traces were added")
    
    end

    return nothing


    # if decision_isold ==1 println("afterchange",iimage) end
end