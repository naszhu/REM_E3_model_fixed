
function fast_concat(vectors::Vector{Vector{T}}) where {T}
    total_length = sum(length(v) for v in vectors)  # Compute total length
    result = Vector{T}(undef, total_length)  # Preallocate memory

    pos = 1
    for v in vectors
        copyto!(result, pos, v, 1, length(v))  # Copy each vector
        pos += length(v)
    end

    return result
end


log_transform(x; k=10) = log1p(k*x) / log1p(k)
# “Notch” or band-stop style transform: strong suppression in mid-range, mild/no suppression at extremes
notch_transform(x; α=10.0, μ=0.5, σ=0.2) = x / (1 + α * exp(-((x - μ)^2) / (2*σ^2)))

# multiplicative-notch version
valley_transform(x; α=0.8, μ=0.5, σ=0.2) = x * (1 - α * exp(-((x - μ)^2) / (2*σ^2)))

"""
   For criterion change across lists: generate a power function that asymptotically increases and flattens out near position 4, here's a simplified version of the code:

   p: # Power exponent for the asymptotic increase; p = 2.0 , roughly stop increasing at 4th position

   currently, this function only have argument inputs p, and though should include arguments of how dimn1 change as well 
"""
function generate_asymptotic_values(p::Float64, within_list_start::Float64, within_list_end::Float64,  between_list_start::Float64,  between_list_end::Float64 )::Matrix{Float64}
    # Generate linearly decreasing dim1 from 6 to 4
    dim1 = LinRange(within_list_start, within_list_end, n_probes)
    
    t = LinRange(between_list_start, between_list_end, n_lists)   # Normalized range for column positions (0 to 1)
    dim2 = t .^ p  # Apply the power-law to create the asymptotic increase
    
    # 3) Create the 2D matrix by outer-product of dim1 and dim2
    M = dim1 .* transpose(dim2)     # M is of size (n_probes, n_lists)
    
    return M
end



"""
the fixed start asympotopically changes vector: gradually decrease the level of increase  
"""
function generate_asymptotic_increase_fixed_start(start_at::Float64, rate::Float64, num_values::Int64)::Vector{Float64}
    values = zeros(num_values)
    for i in 1:num_values
        values[i] = start_at + (1 - exp(-rate * (i - 1))) * (1 - start_at)
    end
    return values
end

# """
# generate_asymptotic_increase_fixed_start(start_val, rate, length)
# Generates a vector of asymptotically increasing values starting from start_val
# The increase is asymptotic with a fixed rate, not targeting a specific end value
# """
# function generate_asymptotic_increase_fixed_start(start_val::Float64, rate::Float64, beta::Float64, length::Int64)::Vector{Float64}
#     # Generates a vector of asymptotically increasing values starting from start_val
#     # The increase is asymptotic with a fixed rate, not targeting a specific end value
#     vals = [start_val * (1 + rate * (1 - exp(-beta * (i-1)/(length-1)))) for i in 1:length]
#     return vals
# end

"""
generate_asymptotic_increase_fixed_start(start_val, rate, length)
Generates a vector of asymptotically increasing values starting from start_val
The increase is asymptotic with a fixed rate, not targeting a specific end value
"""
function generate_asymptotic_increase_fixed_start(start_val, rate, beta, length)
    # Generates a vector of asymptotically increasing values starting from start_val
    # The increase is asymptotic with a fixed rate, not targeting a specific end value
    vals = [start_val * (1 + rate * (1 - exp(-beta * (i-1)/(length-1)))) for i in 1:length]
    return vals
end


function generate_asymptotic_increase_fixed_start_nb(start_val, rate, length)
    # Generates a vector of asymptotically increasing values starting from start_val
    # The increase is asymptotic with a fixed rate, not targeting a specific end value
    vals = [start_val * (1 + rate * (1 - exp(-0.5 * (i-1)/(length-1)))) for i in 1:length]
    return vals
end

generate_asymptotic_increase_fixed_start_nb(0.2, 0.03, 10)
generate_asymptotic_increase_fixed_start(0.2, 0.03, 0.5, 10)
