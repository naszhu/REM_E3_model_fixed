# Memory Pool for EpisodicImage reuse
# This reduces garbage collection pressure by reusing objects

mutable struct EpisodicImagePool
    available::Vector{EpisodicImage}
    in_use::Vector{EpisodicImage}
    max_size::Int
end

function EpisodicImagePool(initial_size::Int = 1000)
    # Pre-allocate pool of EpisodicImages
    available = Vector{EpisodicImage}()
    for i in 1:initial_size
        # Create dummy EpisodicImage with proper structure
        dummy_word = Word("dummy", zeros(Int64, w_word + 1), :F, :F, 0, 0, false, 1, 2)
        dummy_context = zeros(Int64, w_allcontext)
        push!(available, EpisodicImage(dummy_word, dummy_context, 1, 1))
    end
    
    EpisodicImagePool(available, EpisodicImage[], initial_size * 2)
end

function get_image!(pool::EpisodicImagePool, word::Word, context_features::Vector{Int64}, list_num::Int64, type_current::Int64)
    if isempty(pool.available)
        # Create new if pool exhausted
        dummy_word = Word("dummy", zeros(Int64, w_word + 1), :F, :F, 0, 0, false, 1, 2)
        dummy_context = zeros(Int64, w_allcontext)
        img = EpisodicImage(dummy_word, dummy_context, 1, 1)
    else
        img = pop!(pool.available)
    end
    
    # Reset and configure the image
    img.word = word
    img.context_features = context_features
    img.list_number = list_num
    img.type_current = type_current
    
    push!(pool.in_use, img)
    return img
end

function return_image!(pool::EpisodicImagePool, img::EpisodicImage)
    # Find and remove from in_use
    idx = findfirst(x -> x === img, pool.in_use)
    if idx !== nothing
        deleteat!(pool.in_use, idx)
        if length(pool.available) < pool.max_size
            push!(pool.available, img)
        end
    end
end

function reset_pool!(pool::EpisodicImagePool)
    # Return all in_use images to available
    append!(pool.available, pool.in_use)
    empty!(pool.in_use)
end

# Global pool instance
const GLOBAL_IMAGE_POOL = Ref{Union{EpisodicImagePool, Nothing}}(nothing)

function get_global_pool()
    if GLOBAL_IMAGE_POOL[] === nothing
        GLOBAL_IMAGE_POOL[] = EpisodicImagePool()
    end
    return GLOBAL_IMAGE_POOL[]
end