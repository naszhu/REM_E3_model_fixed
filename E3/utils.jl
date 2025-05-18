
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