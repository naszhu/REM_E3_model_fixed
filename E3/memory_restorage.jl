



"""
restore content and/or context, here, context include change,unchange, and positioncode. position code is not restored but add to new trace when don't restore context
"""
# flagn = Int64[];
# data_flag = Array{Vector{Any}}(undef, n_simulations)  # Create an array to hold vectors for each simulation
# for i in 1:n_simulations
#     data_flag[i] = Vector{Any}()  # Initialize each row as an empty vector
# end

# function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, odds::Float64, likelihood_ratios::Vector{Float64}, simu_i::Int64, initial_testpos::Int64)
function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, odds::Float64 )::Nothing


    if is_onlyaddtrace
        error("not coded here")
    end
    #is_onlyaddtrace is false
    # println("nothere")

    if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold))) #just get a new empty EI

        iimage = EpisodicImage(
            #Word:
            Word(iprobe_img.word.item_code, #item_code
                fill(0, length(iprobe_img.word.word_features)), #word features
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
        
    elseif ((decision_isold==1) & (odds > recall_odds_threshold) )

        #recall; restore old
        iimage = image_pool[imax] 
    else
        error("decision_isold is not well defined")
    end



    # if new, or old but didn't pass threshold -- ADD TRACE 
    # (start with empty EI, then add features)

    if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))


        for _ in 1:n_units_time_restore
            # Update word features
            add_features_from_empty!(iimage.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest, g_word)

            # Update context features
            # u_advFoilInitialT is the adv for foil (judged new, add trace) in initial test, to see if final test p overlappsss....u_advFoilInitialT=0 currently
            @assert u_star_context[end] == u_star_context[1] "u_star_context is not well defined to be used in restore_intest for intial test, final test is dependant on u_star_context[ilist], but not yet like that in inital test, initial doens't have a u_star_context difference right now, notice"
            add_features_from_empty!(iimage.context_features, iprobe_img.context_features, u_star_context[end] + u_advFoilInitialT, c_context, g_context)
        end



    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    elseif ((decision_isold==1) & (odds > recall_odds_threshold) )

        if is_strengthen_contextandcontent
            restore_features!(iimage.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore)

            restore_features!(iimage.context_features, iprobe_img.context_features, p_recallFeatureStore)
        end

        # the following makes sure that we actually must need to restore context.
        !is_restore_context ? error("context restored in initial is not well written this part") : nothing

    end


    if (decision_isold == 0) | ((decision_isold == 1) & (odds < recall_odds_threshold))
        push!(image_pool, iimage)
        # println("pass, decision_isold $(decision_isold); is pass $(odds < recall_odds_threshold)")

    end

    return nothing


end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, odds::Float64, finaltest_pos::Int64 )::Nothing
#     iimage = decision_isold == 1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)
# # println(iimage.initial_testpos_img)

    if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))

        iimage = EpisodicImage(
            #Word:
            Word(iprobe_img.word.item_code, #item_code
                fill(0, length(iprobe_img.word.word_features)), #word features
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


    elseif ((decision_isold==1) & (odds > recall_odds_threshold) )

        #recall; restore old
        iimage = image_pool[imax] 
    else
        error("decision_isold is not well defined")
    end


    ############# ADD TRACE ######################
    # if new, or old but didn't pass threshold -- ADD TRACE
    if (decision_isold == 0)| ((decision_isold == 1) & (odds < recall_odds_threshold))

        for _ in 1:n_units_time_restore

            add_features_from_empty!(iimage.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest, g_word)

            # if iprobe_img.list_number == 1

            # Issue 12, 13(ambigiou use const array)
            # this problem occur u_star_context[probe_img.list_number] has problem here because should not use probe's list number but final test order list number, but I don't have that in my structure right now

            iprobe_chunk_boundaries = cumsum([total_probe_L1 * nItemPerUnit_final * 2; fill(total_probe_Ln * nItemPerUnit_final * 2, 9)])  # First chunk has 15*2*2 items, rest 9 chunks have 12*2*2 items

            # Determine the chunk index for the current probe
            iprobe_chunk = findfirst(x -> finaltest_pos <= x, iprobe_chunk_boundaries)  

            add_features_from_empty!(iimage.context_features, iprobe_img.context_features, u_star_context[iprobe_chunk], c_context, g_context);
            # else
                # add_features_from_empty!(iimage.context_features, iprobe_img.context_features, u_star_context[end]+u_advFoilInitialT+0.1, c_context, g_context)
            
            # end


        end


    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    elseif ((decision_isold==1) & (odds > recall_odds_threshold) )

        # pass: strenghten
        #single parameter for missing or replacing
        # WARNING: rand(Geometric(g_word)) + 1) is not used here, there is no chance of an incorrect random value storage when judging old 

        if !is_store_mismatch
            error("current prog is not written when doesn't store mismatch")
        end

        restore_features!(iimage.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore)

        restore_features!(iimage.context_features, iprobe_img.context_features, p_recallFeatureStore)

        !is_restore_context ? error("context restored in initial is not well written this part") : nothing


    end

    # if (decision_isold == 0)
    if (decision_isold == 0) | ((decision_isold == 1) & (odds < recall_odds_threshold))
        push!(image_pool, iimage)
    end

    return nothing


    # if decision_isold ==1 println("afterchange",iimage) end
end