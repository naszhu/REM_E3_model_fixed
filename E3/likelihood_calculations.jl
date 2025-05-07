




function calculate_likelihood_ratio(probe::Vector{Int64}, image::Vector{Int64}, g::Float64, c::Float64)::Float64

    lambda = Vector{Float64}(undef, length(probe))

    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0
            lambda[k] = 1
        elseif image[k] != 0
            if image[k] != probe[k]# for those that doesn't match
                lambda[k] = 1 - c
                # println(1-c)
            elseif image[k] == probe[k]
                lambda[k] = (c + (1 - c) * g * (1 - g)^(image[k] - 1)) / (g * (1 - g)^(image[k] - 1))
            else
                error("error image match")
            end
        else
            error("error here")
        end
    end

    return prod(lambda)
end




"""
Initial test stage
Input: A probe and the whole image_pool
adding the filter here

firststg_allctx removed
( combine content and context in frist stage for a test,)
"""
function calculate_two_step_likelihoods(probe_img::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}
    context_likelihoods = Vector{Float64}(undef, length(image_pool))
    word_likelihoods = Vector{Float64}(undef, length(image_pool))

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        probe_context = probe_img.context_features
        image_context = image.context_features



        if is_test_allcontext  
            #FALSE, don't test all context here
            #here is secon  stage would be wrong, including position code, unchage, change

            error("testing all context is mistaken right here")
           
        else  #not testing all context but change only, no unchange or position code
            context_likelihood = calculate_likelihood_ratio(probe_context[nU+1:w_context], image_context[nU+1:w_context], g_context, c)  # this step give prod(lambda); odds
        end

        # println(length(probe_context))
        context_likelihoods[ii] = context_likelihood

        if is_firststage #true

            # second stage
            if context_likelihood > context_tau # if pass context criterion 

                ## take off word_features[1:round(Int, w_word * p)]; just give the whole word features
                word_likelihoods[ii] = calculate_likelihood_ratio(probe_img.word.word_features, image.word.word_features, g_word, c) 


            else
                # do not calculate real word_likelihoods for word didn't pass first stage threshold
                word_likelihoods[ii] = 344523466743  
            end
        else #don't pass through
            error("first stage must be tested here")
            word_likelihoods[ii] = calculate_likelihood_ratio(probe_img.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
        end


    end

    return context_likelihoods, word_likelihoods
end



function calculate_two_step_likelihoods2(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}

    context_likelihoods = Vector{Float64}(undef, length(image_pool))
    word_likelihoods = Vector{Float64}(undef, length(image_pool))
    probe_context = probe.context_features

    #all unchanging first half + partial changing 
    probe_context_f = fast_concat([probe_context[1:nU_f], probe_context[nU_f+1:nU_f+nC_f]])

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        image_context = image.context_features

       

        if is_test_allcontext2  #true; currently goes here; first half unchange
            image_context_f = fast_concat([image_context[1:nU_f], image_context[nU_f+1:nU_f+nC_f]])
            context_likelihood = calculate_likelihood_ratio(probe_context_f, image_context_f, g_context, c)  # .#  Context calculation

        elseif is_test_changecontext2 #false
            error("no")
            context_likelihood = calculate_likelihood_ratio(probe_context[nU+1:end], image_context[nU+1:end], g_context, c)
        else #only test general context (first part)
            error("no" )
            context_likelihood = calculate_likelihood_ratio(probe_context[1:nU], image_context[1:nU], g_context, c)  # .#  Context calculation
        end


        context_likelihoods[ii] = context_likelihood

        if is_firststage #true

            # second stage
            if context_likelihood > context_tau_final # if pass context criterion 

                word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)

                # if iprobe !== 1 #CONTEXT FILTER: if not first probe tested, using the filter, 
                #     # taking  out the very low similarity word_likelihoods
                #     if word_likelihoods[ii] < tau_filter ##adding a filter
                #         word_likelihoods[ii]=344523466743
                #     end
                # end
            else
                # println("now")
                word_likelihoods[ii] = 344523466743  # Or another value to indicate context mismatch
            end
        else
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
        end


    end

    return context_likelihoods, word_likelihoods
end
