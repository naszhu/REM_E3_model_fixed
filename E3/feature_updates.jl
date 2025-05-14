


# Combine the two loops into one function to avoid redundancy
# the following is used within function probe_generation
function reinstate_context_duringTest!(context_array::Vector{Int64}, reference_array::Vector{Int64};p_reinstate_context::Float64=p_reinstate_context,
    p_reinstate_rate::Float64=p_reinstate_rate)::Nothing

        nct = length(context_array)
        for ict in eachindex(context_array)
            if ict < Int(round(nct * p_reinstate_context))
                if (context_array[ict] != reference_array[ict]) & (rand() < p_reinstate_rate)
                    context_array[ict] = reference_array[ict]
                end
            end
        end
end   


# this and the following function might could be renamed, and they essentially are the same.. but I'll leave that optimization for later change.......
# the following and the one next to that is just replace feature with certain prob, with or without n steps
function drift_ctx_betweenStudyAndTest!(
    context_features::Vector{Int64}, 
    probability::Float64, 
    distribution::Distribution

    )::Nothing

    
    for cf in eachindex(context_features)
        if rand() < probability
            context_features[cf] = rand(distribution) + 1
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
                

    for _ in 1:n_drift
        for i in eachindex(context_features)
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


function add_features_from_empty!(target_features::Vector{Int}, probe_features::Vector{Int}, u_star::Float64, c_param::Float64, g_param::Float64; u_adv=0.0)::Nothing
    for i in eachindex(probe_features)
        j = target_features[i]
        if j == 0
            target_features[i] = rand() < u_star ? (rand() < c_param ? probe_features[i] : rand(Geometric(g_param)) + 1) : j
        end
    end
end


function restore_features!(target_features::Vector{Int}, source_features::Vector{Int}, p_recallFeatureStore::Float64; is_store_mismatch::Bool=is_store_mismatch)::Nothing
    for i in eachindex(source_features)
        current_value = target_features[i]
        source_value = source_features[i]

        if (current_value == 0) || ((current_value != 0) && (current_value != source_value) && is_store_mismatch)
            target_features[i] = rand() < p_recallFeatureStore ? source_value : current_value
        end
    end
end

