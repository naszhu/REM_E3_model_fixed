


# Combine the two loops into one function to avoid redundancy
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