


# Combine the two loops into one function to avoid redundancy
# the following is used within function probe_generation
function reinstate_context_duringTest!(context_array::Vector{Int64}, reference_array::Vector{Int64},
    p_reinstate_context::Float64,
    p_reinstate_rate::Float64)::Nothing

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
assume read nU from constant.jl
cu and cc is copying parameter value
"""
function add_features_from_empty!(target_features::Vector{Int}, probe_features::Vector{Int}, u_star::Float64, cc::Float64, g_param::Float64; u_adv=0.0, cu::Float64=0.0)::Nothing

    @assert length(target_features) == length(probe_features) "LENGTH NOT MATCH"

    for i in eachindex(probe_features)

        if cu==0.0
            c_param = cc
        else
            if i > nU #FIXME: fast workaround here
                c_param = cc
            else
                c_param = cu
            end
        end
        j = target_features[i]
        if j == 0
            target_features[i] = rand() < u_star ? (rand() < c_param ? probe_features[i] : rand(Geometric(g_param)) + 1) : j
        end
    end

end


function restore_features!(target_features::Vector{Int}, source_features::Vector{Int}, p_recallFeatureStore::Float64; is_store_mismatch::Bool=is_store_mismatch, is_ctx::Bool=false)::Nothing

    
    for _ in 1:n_units_time_restore
        for i in eachindex(source_features)
            current_value = target_features[i]
            source_value = source_features[i]

            if is_ctx
                @assert length(target_features)==nU+nC "not same length"
                if i>nU # for CC
                    # pps = 0.8
                    c_usenow = 0.9 # c_context_c[1] #, perfect storage 
                    u_star_now = u_star_context[1] + u_advFoilInitialT #u_advFoilInitialT is the adv for foil (judged new, add trace) in initial test, to see if final test p overlappsss....u_advFoilInitialT=0 currently
                else # for unchanging 
                    # pps = 0.8
                    c_usenow = 0.9 # c_context_c[1]
                    u_star_now = u_star_context[1] + u_advFoilInitialT 
                end
            else #if content
                # pps = 0.8
                c_usenow = 0.9#c[1] 
                u_star_now = u_star[1] + u_advFoilInitialT 
            end
            
            # if (current_value === 0) || ((current_value !== 0) && (current_value !== source_value) && is_store_mismatch)
            #     target_features[i] = rand() < pps ? source_value : current_value
            # end
            
            # if (current_value !== 0) 
            #     target_features[i] = rand() < pps ? source_value : current_value
            # end
            #is_store_mismatch is false now so no mismatch stored
            if (current_value === 0) || ((current_value !== 0) && (current_value !== source_value) && is_store_mismatch)
                target_features[i] = rand() < u_star_now[1]+0.1 ? (rand() < c_usenow[1] ? source_value : rand(Geometric(g_context)) + 1) : current_value
            end

            
        end 
    end # for _ in 1:n_units_time_restore
    # end
end
