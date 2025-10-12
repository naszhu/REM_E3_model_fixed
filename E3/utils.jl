
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

###############################################################
# E3 Unified Asymptotic Functions
###############################################################

# Core exponential asymptotic function
# Used internally by all increase/decrease variants.
function _asym_core(start::Float64, asymptote::Float64, rate::Float64, n::Int)
    @assert n ≥ 1
    Δ = asymptote - start
    return [start + Δ * (1 - exp(-rate * k)) for k in 0:n-1]
end


###############################################################
# 1. asymptotic_value
# Generic asymptotic approach to a target value
###############################################################
function asymptotic_value(start::Float64, asymptote::Float64, rate::Float64, n::Int)::Vector{Float64}
    return _asym_core(start, asymptote, rate, n)
end


###############################################################
# 2. asymptotic_decrease
# Same as above but ensures we actually reach asymptote (≤1% diff)
###############################################################
function asymptotic_decrease(start::Float64, asymptote::Float64, rate::Float64, n::Int)::Vector{Float64}
    @assert asymptote < start "Asymptote must be less than start value for decrease"
    values = _asym_core(start, asymptote, rate, n)
    if abs(values[end] - asymptote) > 0.01 * abs(asymptote)
        adjusted_rate = -log(0.01) / (n - 1)
        return _asym_core(start, asymptote, max(rate, adjusted_rate), n)
    end
    return values
end


###############################################################
# 3. asym_increase_shift_hj  (h_j parameter increase)
###############################################################
function asym_increase_shift_hj(start_at::Float64,
                                how_much::Float64,
                                how_fast::Float64,
                                n::Int)::Vector{Float64}
    asymptote = start_at + how_much
    return _asym_core(start_at, asymptote, how_fast, n)
end


###############################################################
# 4. asym_decrease_shift_fj  (κ_u parameter decrease)
###############################################################
function asym_decrease_shift_fj(start_at::Float64,
                                how_much::Float64,
                                how_fast::Float64,
                                n::Int)::Vector{Float64}
    asymptote = start_at - how_much
    return _asym_core(start_at, asymptote, how_fast, n)
end


###############################################################
# 5. asym_decrease  (between two arbitrary values)
###############################################################
function asym_decrease(start_val::Float64,
                       end_val::Float64,
                       beta::Float64,
                       n::Int)::Vector{Float64}
    @assert n ≥ 1
    return [end_val + (start_val - end_val) * exp(-beta * (i - 1) / (n - 1))
            for i in 1:n]
end


###############################################################
# 6. generate_asymptotic_increase_fixed_start
# (Used for p_switch * pOld; increase toward 1)
###############################################################
function generate_asymptotic_increase_fixed_start(start_at::Float64,
                                                  rate::Float64,
                                                  num_values::Int64)::Vector{Float64}
    return _asym_core(start_at, 1.0, rate, num_values)
end


###############################################################
# 7. generate_asymptotic_values
# (Criterion change across lists)
#
# Generates a 2D matrix combining within-list asymptotic decrease
# and between-list power-law increase that flattens by ~4th position.
###############################################################
function generate_asymptotic_values(p::Float64,
                                    within_list_start::Float64,
                                    within_list_end::Float64,
                                    between_list_start::Float64,
                                    between_list_end::Float64,
                                    b_rate::Float64)::Matrix{Float64}
    @assert @isdefined(n_probes) "n_probes must be defined globally before calling this function."
    @assert @isdefined(n_lists) "n_lists must be defined globally before calling this function."

    # 1. Within-list (row dimension): asymptotic *decrease*
    dim1 = asym_decrease(within_list_start, within_list_end, b_rate, n_probes)

    # 2. Between-list (column dimension): asymptotic *increase* with power law
    between_curve = _asym_core(between_list_start, between_list_end, 5.0, n_lists)
    dim2 = between_curve .^ p  # asymptotic + power flattening near list 4

    # 3. Outer product: M[row, col] = dim1[row] * dim2[col]
    return dim1 .* transpose(dim2)
end