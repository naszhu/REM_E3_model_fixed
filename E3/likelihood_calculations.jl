

"""
NOTE: cu and U_ctx has to appear at the same time, or both not appear, can't just have one appear
"""
# Example:
# calculate_likelihood_ratio([1, 2, 2],[1, 3, 0], g_context, c_context_c[1], true, 1; cu = c_context_un[1], U_ctx = nU_in[1])
c= c_storeintest[1] #copying parameter - 0.8 for context copying
g = g_context #general context copying parameter
jj=7
(c + (1 - c) * g * (1 - g)^(jj - 1)) / (g * (1 - g)^(jj - 1))

function calculate_likelihood_ratio(probe_img::Vector{Int64}, image::Vector{Int64}, g::Float64, cc::Float64, isctx_ll::Bool, listnum::Int64; cu:: Float64 = 0.0, U_ctx::Int64 = 0 )::Float64

    lambda = Vector{Float64}(undef, length(probe_img))

    # @assert (cu===0.0 && U_ctx===0) || (cu !==0.0 && U_ctx !==0) "STH wrong!$(cu), $(U_ctx), $(!(cu !==0.0 && U_ctx !==0.0))"

    @assert length(probe_img)==length(probe_img) "NOT SAME LENGTH"

    for k in eachindex(probe_img) # 1:length(probe_img)

        # The following: if different copying parameter for CC and UC, then how to decide wich one to use?
        if cu==0.0 #FIXME: quick work around here
            c = cc
        else #if there is an input of cu
            if k > U_ctx
                c=cc
            else 
                c=cu
            end
        end


        if image[k] == 0
            lambda[k] = 1
        elseif image[k] != 0
            if image[k] != probe_img[k]# for those that doesn't match
                lambda[k] = 1 - c
                # println(1-c)
            elseif image[k] == probe_img[k]
                lk_prior = (c + (1 - c) * g * (1 - g)^(image[k] - 1)) / (g * (1 - g)^(image[k] - 1));

                if isctx_ll
                    lambda[k] = lk_prior
                else
                    lambda[k] = lk_prior 
                    # lambda[k] = lk_prior ^ (LinRange(1.6, 1,n_lists)[listnum])
                    # notch_transform(lk_prior; α=LinRange(0,0, 10)[listnum], μ=10, σ=0.1)
                    # valley_transform(lk_prior; α=0.8, μ=0.5, σ=0.1)
                end


        if k>U_ctx #if changing ctx

            lambda[k] = lambda[k] ^ LLpower # for the second half of context features, which is changing context
        else
            # lambda[k] = lambda[k]^ 0.7 # for the first half of context features, which is unchanging context
        end
                # lambda[k] = log_transform(lk_prior; k=1.2)
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
Input: A probe_img and the whole image_pool
adding the filter here

firststg_allctx removed
( combine content and context in frist stage for a test,)
"""
function calculate_two_step_likelihoods(probe_img::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}
    context_likelihood_imgi_ratios = Vector{Float64}(undef, length(image_pool))
    word_likelihood_imgi_ratios = Vector{Float64}(undef, length(image_pool))
    ilist = probe_img.list_number     

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        probe_context = probe_img.context_features
        image_context = image.context_features


        if is_test_allcontext  #true


            U_ctx = nU_in[ilist]
            C_ctx = nC_in[ilist]

            # println("$ilist, $U_ctx, $C_ctx, $(probe_context[1 : U_ctx]), $(probe_context[(U_ctx +1) : (C_ctx + U_ctx)])")

            probe_context_adjusted = fast_concat([probe_context[1 : U_ctx], probe_context[(nU +1) : (nU + C_ctx)]]) #take the first half unchange and the second half change
            image_context_adjusted = fast_concat([image_context[1 : U_ctx], image_context[(nU +1) : (nU + C_ctx)]]) #take the first half unchange and the second half change

            # context LL of trace i in memory
            context_likelihood_imgi_ratio = calculate_likelihood_ratio(probe_context_adjusted, image_context_adjusted, g_context, c_context_c[ilist], true, ilist; cu = c_context_un[ilist], U_ctx = U_ctx)    #a bug fixed here #FIXME: a tech quick skipthrough here

        
        else  #not testing all context but change only, no unchange or position code
            error("HALT here, not written")
            context_likelihood_imgi_ratio = calculate_likelihood_ratio(probe_context[nU+1:w_context], image_context[nU+1:w_context], c_context[ilist], c, true, ilist)  # this step give prod(lambda); odds
        end

        # println(length(probe_context))
        context_likelihood_imgi_ratios[ii] = context_likelihood_imgi_ratio

        if is_firststage #true

            # second stage
            if context_likelihood_imgi_ratio > context_tau[probe_img.list_number]; # if pass context criterion 

                ## take off word_features[1:round(Int, w_word * p)]; just give the whole word features
                w_word_use = round(Int, w_word * p_word_feature_use[probe_img.list_number])
                
                word_likelihood_imgi_ratios[ii] = calculate_likelihood_ratio(probe_img.word.word_features[1:w_word_use], image.word.word_features[1:w_word_use], g_word, c[1],false,ilist ) 
                # println("$(probe_img.word.word_features), $(image.word.word_features), $(g_word), $(c), $(word_likelihood_imgi_ratios)")


            else
                # do not calculate real word_likelihood_imgi_ratios for word didn't pass first stage threshold
                word_likelihood_imgi_ratios[ii] = 344523466743  
            end
        else #don't pass through
            error("first stage must be tested here")
            word_likelihood_imgi_ratios[ii] = calculate_likelihood_ratio(probe_img.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c, false,ilist)
        end


    end

    return context_likelihood_imgi_ratios, word_likelihood_imgi_ratios
end



function calculate_two_step_likelihoods2(probe_img::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, currchunk::Int64)::Tuple{Vector{Float64},Vector{Float64}}

    context_likelihood_imgi_ratios = Vector{Float64}(undef, length(image_pool))
    word_likelihood_imgi_ratios = Vector{Float64}(undef, length(image_pool))
    probe_context = probe_img.context_features

    #all unchanging first half + partial changing 
    nU_f_i = nU_f[currchunk] 
    nC_f_i = nC_f[currchunk]
    probe_context_f = fast_concat([probe_context[1:nU_f_i], probe_context[(nU + 1) : (nU + nC_f_i)]])

    listnum = probe_img.list_number;
    for ii in eachindex(image_pool)
        image = image_pool[ii]
        image_context = image.context_features

       

        #ok, idk how much context; differetiate or not will be used in liklihood calc of final test for now, so just keep it as what it was for now
        if is_test_allcontext2  #true; currently goes here; first half unchange
            image_context_f = fast_concat([image_context[1:nU_f_i], image_context[(nU + 1) : (nU + nC_f_i)]])
            context_likelihood_imgi_ratio = calculate_likelihood_ratio(probe_context_f, image_context_f, g_context, c_context_c[end], true, listnum; cu = c_context_un[end], U_ctx = nU_f_i)  # .#  Context calculation TODO, FIXME end here?

        elseif is_test_changecontext2 #false
            error("no")
            context_likelihood_imgi_ratio = calculate_likelihood_ratio(probe_context[nU+1:end], image_context[nU+1:end], g_context, c, true, listnum)
        else #only test general context (first part)
            error("no" )
            context_likelihood_imgi_ratio = calculate_likelihood_ratio(probe_context[1:nU], image_context[1:nU], g_context, c, true, listnum)  # .#  Context calculation
        end


        context_likelihood_imgi_ratios[ii] = context_likelihood_imgi_ratio

        if is_firststage #true

            # second stage
            if context_likelihood_imgi_ratio > context_tau_final # if pass context criterion 

                word_likelihood_imgi_ratios[ii] = calculate_likelihood_ratio(probe_img.word.word_features, image.word.word_features, g_word, c[end], false, listnum) #TODO

                # if iprobe !== 1 #CONTEXT FILTER: if not first probe_img tested, using the filter, 
                #     # taking  out the very low similarity word_likelihood_imgi_ratios
                #     if word_likelihood_imgi_ratios[ii] < tau_filter ##adding a filter
                #         word_likelihood_imgi_ratios[ii]=344523466743
                #     end
                # end
            else
                # println("now")
                word_likelihood_imgi_ratios[ii] = 344523466743  # Or another value to indicate context mismatch
            end
        else

            error("first stage must be tested here")
            word_likelihood_imgi_ratios[ii] = calculate_likelihood_ratio(probe_img.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c, false, listnum)
        end


    end

    return context_likelihood_imgi_ratios, word_likelihood_imgi_ratios
end