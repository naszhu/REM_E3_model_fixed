

""" 
This is the store during study period. E3 has all study images being new items, so all images are to be just add to new trace.
Initial adv only for changing context
"""
function store_episodic_image(image_pool::Vector{EpisodicImage}, word::Word, context_features::Vector{Int64}, list_num::Int64)
    # new_image = EpisodicImage(word, copy(context_features)) # Start with a copy
    # println(length(context_features))
    # intial_testpos_img, initilaize with 0, change whatever it is in probe creating. Well, the probe is created independently anyways
    new_image = EpisodicImage(
        #word
        Word(word.item_code, 
            zeros(Int64, w_word + 1),  # Always 25 features (24 normal + 1 OT)
            word.type_general, 
            word.type_specific,
            word.initial_studypos,
            word.initial_testpos,
            word.is_repeat_type,
            word.type1,
            word.type2            
            ), 
        #context_features
        zeros(length(context_features)), 
        #list_number
        list_num,
        #type_current
        1 #will be the first time appearance for all studied img
        ) # Zero word features

    #######Storage process: CONTENT & CONTEXT
        # go storage for n_units_time times
    #############STORAGE - content
    
    # update OT 
    if use_ot_feature
        update_ot_feature_study!(new_image.word.word_features, list_num)
    end

    for _ in 1:n_units_time #content intial adv??? . Maybe not needed but.. 

       # In your storage function:
        store_word_features!(
            new_image.word.word_features, 
            word.word_features,
            u_star[list_num],
            c[1], #caution here
            g_word,
            tested_before_feature_pos
        )

        #############STORAGE - context
            # a[length(a)/2]1-3 4-7; 3,3
        
        update_context_features_during_study!(new_image, context_features, word, list_num)
    end

    # if new_image.word.type_general==:F
    #     println(new_image.word.initial_studypos)
    # end
    push!(image_pool, new_image)

    # println("Studied word: ", new_image.word.item, " List: ", new_image.list_number, " Study Position: ", new_image.word.studypos," ",[iimg.word.item for iimg in image_pool])
    # println("Word Features: ", new_image.word.word_features)

    # return image_pool
end

