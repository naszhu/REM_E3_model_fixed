


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