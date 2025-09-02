# Optimization utilities to reduce memory allocations

# Pre-allocated context buffer pool
mutable struct ContextPool
    buffers::Vector{Vector{Int64}}
    index::Int
end

function ContextPool(size::Int, buffer_length::Int)
    buffers = [Vector{Int64}(undef, buffer_length) for _ in 1:size]
    ContextPool(buffers, 1)
end

function get_context_buffer!(pool::ContextPool, general_features, list_features)
    buffer = pool.buffers[pool.index]
    pool.index = pool.index % length(pool.buffers) + 1
    
    # Fill buffer without allocation
    n_general = length(general_features)
    buffer[1:n_general] = general_features
    buffer[n_general+1:n_general+length(list_features)] = list_features
    
    return view(buffer, 1:n_general+length(list_features))
end

# Pre-allocated result collectors to avoid push!
mutable struct ResultCollector{T}
    data::Vector{T}
    count::Int
end

function ResultCollector{T}(capacity::Int) where T
    ResultCollector{T}(Vector{T}(undef, capacity), 0)
end

function add_result!(collector::ResultCollector{T}, item::T) where T
    collector.count += 1
    if collector.count > length(collector.data)
        resize!(collector.data, collector.count * 2)
    end
    collector.data[collector.count] = item
end

function get_results(collector::ResultCollector{T}) where T
    return view(collector.data, 1:collector.count)
end

# Faster alternatives to commonly used operations
@inline function fast_copy_to!(dest::Vector{T}, src::Vector{T}, dest_start::Int) where T
    @inbounds for i in eachindex(src)
        dest[dest_start + i - 1] = src[i]
    end
end