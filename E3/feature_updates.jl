


# Combine the two loops into one function to avoid redundancy
# the following is used within function probe_generation
function reinstate_context_duringTest!(context_array::Vector{Int64}, reference_array::Vector{Int64},
    p_reinstate_context::Float64,
    p_reinstate_rate::Float64)::Nothing

        nct = length(context_array)
        for ict in eachindex(context_array)
            # if ict < Int(round(nct * p_reinstate_context))
                if (context_array[ict] != reference_array[ict]) & (rand() < p_reinstate_rate)
                    context_array[ict] = reference_array[ict]
                end
            # end
        end
end   


# this and the following function might could be renamed, and they essentially are the same.. but I'll leave that optimization for later change.......
# the following and the one next to that is just replace feature with certain prob, with or without n steps
function drift_ctx_betweenStudyAndTest!(
    context_or_content_features::Vector{Int64}, 
    probability::Float64, 
    distribution::Distribution
    )::Nothing

    for cf in eachindex(context_or_content_features)
        if rand() < probability
            context_or_content_features[cf] = rand(distribution) + 1
        end
    end
end



# function drift_with_n!(
function drift_between_lists!(
    context_features::Vector{Int64}, 
    n_drift::Int64, 
    p_drift::Float64; 
    g_context::Float64=g_context
    
    )::Nothing
                

    # for _ in 1:n_drift
    #     for i in eachindex(context_features)
    #         if rand() < p_drift
    #             context_features[i] = rand(Geometric(g_context)) + 1
    #         end
    #     end
    # end

    # for i in eachindex(context_features)
    #     for _ in 1:40
    #             if rand() < 0.03
    #                 context_features[i] = rand(Geometric(g_context)) + 1
    #             end
    #     end
    # end

    for i in eachindex(context_features)
        for _ in 1:n_drift
                if rand() < p_drift
                    context_features[i] = rand(Geometric(g_context)) + 1
                end
        end
    end

end  

function drift_between_lists_final!(
    context_features::Vector{Int64}, 
    # n_drift::Int64, 
    p_drift::Float64; 
    g_context::Float64=g_context
    )::Nothing
                

    # for _ in 1:n_drift
        for i in eachindex(context_features)
            if rand() < p_drift
                context_features[i] = rand(Geometric(g_context)) + 1
            end
        end
    # end
end

"""
Context drift during final test - updates context features with probability p_drift
This function is specifically for final test context changes, separate from study-test drift
"""
function drift_context_during_final_test!(
    context_features::Vector{Int64}, 
    p_drift::Float64; 
    g_context::Float64=g_context
    )::Nothing
    
    for i in eachindex(context_features)
        if rand() < p_drift
            context_features[i] = rand(Geometric(g_context)) + 1
        end
    end
end  



"""
store during study
"""
function store_word_features!(target::Vector{Int}, source::Vector{Int}, 
    u_star_value::Float64, c_value::Float64, 
    g_word::Float64, skip_index::Int)
    for i in eachindex(target)

        
        i === skip_index && continue  # Skip OT feature, this works as if i==...
        
        if target[i] === 0  # If nothing stored yet
            stored_val = (rand() < u_star_value ? 1 : 0) * source[i]
            stored_val === 0 && continue  # Skip if storage failed
            
            # Determine copied value
            copied_val = rand() < c_value ? stored_val : rand(Geometric(g_word)) + 1
            target[i] = copied_val
        end
    end
end

# New function for updating context features
function update_context_features_during_study!(image::EpisodicImage, context_features::Vector{Int64}, word::Word, list_num::Int64)
    for ic in eachindex(image.context_features)
        j = image.context_features[ic]

        if j == 0 # if nothing is stored
            # Apply initial advantage only to changing context features at first position
            if ((ic > nU) && (word.initial_studypos == 1))
                stored_val = (rand() < u_star_context[list_num] + u_adv_firstpos ? 1 : 0) * context_features[ic]
            else
                stored_val = (rand() < u_star_context[list_num] ? 1 : 0) * context_features[ic]
            end

            # Determine which context parameter to use
            which_ctx_use = ic > nU ? c_context_c[list_num] : c_context_un[list_num]

            if stored_val != 0 # if successfully stored
                copied_val = rand() < which_ctx_use ? stored_val : rand(Geometric(g_context)) + 1
                image.context_features[ic] = copied_val
            end
        end
    end
end



"""
assume read nU from constant.jl
cu and cc is copying parameter value
"""
function add_feature_during_restore!(target_features::Vector{Int}, probe_features::Vector{Int}, u_star::Float64, cc::Float64, g_param::Float64, list_number::Int64; u_adv=0.0, cu::Float64=0.0)::Nothing

    @assert length(target_features) == length(probe_features) "LENGTH NOT MATCH"

    is_content = cu === 0.0 #if cu is 0, then this is a content


    for i in eachindex(probe_features)

         # Special handling for OT feature (last feature) - only if enabled
        # skip the OT feature here, this will be specifically handled later
        if use_ot_feature && i === tested_before_feature_pos && is_content
            # OT feature: use κs probability for incorrect test info
             #do nothing for when OT feature here,this will be specifically handled later

        else#when feature i is not OT feature, or all other else situations
            # Normal features: use existing geometric distribution logic

            if is_content #cu?==0.0? this means when this is a content (so no cu will be inputed)
                c_param = cc
            else     

                if i > nU #FIXME: fast workaround here
                    c_param = cc
                else
                    c_param = cu
                end
            end
            
            j = target_features[i]
            if j === 0
                target_features[i] = rand() < u_star ? (rand() < c_param ? probe_features[i] : rand(Geometric(g_param)) + 1) : j
            end
        end
        
    end

    return nothing
end


function strengthen_features!(target_features::Vector{Int}, source_features::Vector{Int}, p_recallFeatureStore::Float64,  list_number::Int64; is_store_mismatch::Bool=is_store_mismatch, is_ctx::Bool=false)::Nothing

    
    for _ in 1:n_units_time_restore
        for i in eachindex(source_features)
            current_value = target_features[i]
            source_value = source_features[i]

            if use_ot_feature && i === tested_before_feature_pos && !is_ctx
                # OT feature: use κs probability for incorrect test info during restoration
                # have tested this does happen               
            else
                 # Normal features: use existing logic

                if is_ctx
                    @assert length(target_features)==nU+nC "not same length"
                    if i>nU # for CC
                        # pps = 0.8
                        # c_usenow = 0.9 # c_context_c[1] #, perfect storage
                        c_usenow = c_context_c[1] #, perfect storage 
                        u_star_now = u_star_context[1] + u_advFoilInitialT #u_advFoilInitialT is the adv for foil (judged new, add trace) in initial test, to see if final test p overlappsss....u_advFoilInitialT=0 currently
                    else # for unchanging 
                        # pps = 0.8
                        # c_usenow = 0.9 # c_context_c[1]
                        c_usenow =c_context_c[1]
                        u_star_now = u_star_context[1] + u_advFoilInitialT 
                    end
                else #if content
                    # pps = 0.8
                    # c_usenow = 0.9#c[1] 
                    c_usenow = c[1] 
                    u_star_now = u_star[1] + u_advFoilInitialT 
                end
            
            # if (current_value === 0) || ((current_value !== 0) && (current_value !== source_value) && is_store_mismatch)
            #     target_features[i] = rand() < pps ? source_value : current_value
            # end
            
            # if (current_value !== 0) 
            #     target_features[i] = rand() < pps ? source_value : current_value
            # end
            #is_store_mismatch is false now so no mismatch stored
                if (current_value === 0) 
                    target_features[i] = rand() < u_star_now[1]+0.06 ? (rand() < c_usenow[1]+0.1 ? source_value : rand(Geometric(g_context)) + 1) : current_value
                end

            end #end of the OT feature judgement

            
        end 
    end # for _ in 1:n_units_time_restore
    # end
end




# =============================================================================
# OT Feature Update Functions
# =============================================================================

"""
Directly set the OT feature (tested before) to a specific value
"""
function update_ot_feature!(word::Word, value::Int64, list_number::Int64)::Nothing
    if use_ot_feature && length(word.word_features) >= tested_before_feature_pos
        word.word_features[tested_before_feature_pos] = value
    end
    return nothing
end

"""
Update OT feature during strengthening process with probability κs for specific list
"""
function update_ot_feature_study!(word_features::Vector{Int64}, list_number::Int64)::Nothing
    if use_ot_feature && length(word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κs value (no asymptotic effect yet)
        if list_number === 1
            κ_value = κs_list_1_value
        else
            κ_index = list_number - 1
            κ_value = κs[κ_index]
        end
        
        # omit if the value=0 part becuase it should always be 0 during study
        word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : word_features[tested_before_feature_pos]
        
    end
    return nothing
end

"""
This function is exactly the same as update_ot_feature_add_trace_strengthen! below because during all strenghten, kb is being used, for now
"""
function update_ot_feature_strengthen!(word::Word, list_number::Int64)::Nothing
    if use_ot_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κb value (no asymptotic effect yet)
        if list_number === 1
            κ_value = κb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        if word.word_features[tested_before_feature_pos] === 0 && rand() < κ_value
            word.word_features[tested_before_feature_pos] = 1
        end
    end
    return nothing
end

"""
Update OT feature when adding traces during strengthening with probability κb for specific list
"""
function update_ot_feature_add_trace_strengthen!(word::Word, list_number::Int64)::Nothing
    if use_ot_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κb value (no asymptotic effect yet)
        if list_number == 1
            κ_value = κb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        if word.word_features[tested_before_feature_pos] == 0 && rand() < κ_value
            word.word_features[tested_before_feature_pos] = 1
        end
    end
    return nothing
end

"""
Update OT feature when adding traces without strengthening with probability κt for specific list
"""
function update_ot_feature_add_trace_only!(word::Word, list_number::Int64)::Nothing
    if use_ot_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κt value (no asymptotic effect yet)
        if list_number === 1
            κ_value = κt_base
        else
            κ_index = list_number - 1
            κ_value = κt[κ_index]
        end
        
        if word.word_features[tested_before_feature_pos] === 0 && rand() < κ_value
            word.word_features[tested_before_feature_pos] = 1
        end
    end
    return nothing
end

"""
Get the current value of the OT feature
"""
function get_ot_feature_value(word::Word)::Int64
    if use_ot_feature && length(word.word_features) >= tested_before_feature_pos
        return word.word_features[tested_before_feature_pos]
    else
        return 0
    end
end
