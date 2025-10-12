########### Z feature functions here
function update_Z_feature_study!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κs value (no asymptotic effect yet)
        if list_number === 1
            # κ_value = κu_list_1_value
            κ_value = ku_base # this number doesn't matter because first list  won't use Z (is this true?)
        else
            κ_index = list_number - 1
            κ_value = κu[κ_index]
        end
        
        # omit if the value=0 part becuase it should always be 0 during study
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0 #change back to 0 and 1 structure rather than accumulation structure
        
    end
    return nothing
end
function update_Z_feature_study!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κs value (no asymptotic effect yet)
        if list_number === 1
            # κ_value = κu_list_1_value
            κ_value = ku_base # this number doesn't matter because first list  won't use Z (is this true?)
        else
            κ_index = list_number - 1
            κ_value = κu[κ_index]
        end
        
        # omit if the value=0 part becuase it should always be 0 during study
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0 #change back to 0 and 1 structure rather than accumulation structure
        
    end
    return nothing
end

"""
This is for studied only confusing foils.
"""
function update_Z_feature_SOn_CFs!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κb value (no asymptotic effect yet)
        if list_number === 1 || list_number === 0
            κ_value = 1-ks_base
        else
            κ_index = list_number - 1
            κ_value = κs[κ_index] #updated by ks
        end
        
        # if word.word_features[tested_before_feature_pos] === 0 && rand() < κ_value
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0 #change 
    end
    return nothing
end


"""
This is for previous target confusing foil
"""
function update_Z_feature_Tn_CFs!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κb value (no asymptotic effect yet)
        if list_number === 1 || list_number === 0
            κ_value = 1-kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0 #change 
    end
    return nothing
end

"""
This is for previous foil, confusing foil.
"""
function update_Z_feature_Fn_CFs!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κt value (no asymptotic effect yet)
        # println(list_number)
        if list_number === 1 || list_number === 0 #list number of final foil FF is 0, this is a temp fix but essentially maybe this shouldn't be used but i don't know what to
            κ_value = 1-kt_base
            # println("κ_value: ", κ_value)
        else
            # println("list number: ", list_number)
            # println("list number next: ", list_number)
            κ_index = list_number - 1
            κ_value = κt[κ_index]
            # println("κ_value: ", κ_value)
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0 #change 
    end
    return nothing
end


function get_Z_feature_value(word::Word)::Int64
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        return word.word_features[tested_before_feature_pos]
    else
        return 0
    end
end

"""
 Set initial Z value for probe generation based on probe type.
According to new rules:
- Confusing probes (SON, FN, TN types) → Z = 1
- Target probes (T, Symbol("TN+1")) → Z = 0  
- Foil probes (F, Symbol("FN+1")) → Z = 0
"""
function set_initial_Z_value_for_probe!(word::Word, probe_type::Symbol)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # Define confusing probe types that should have Z = 1
        confusing_types = (:SOn, :Fn, :Tn)
        
        if probe_type in confusing_types
            word.word_features[tested_before_feature_pos] = 1  # Truth value for confusing probes
        else
            # Target probes (:T, Symbol("Tn+1")) and Foil probes (:F, Symbol("Fn+1")) get Z = 0
            word.word_features[tested_before_feature_pos] = 0  # Truth value for targets and foils
        end
    end
    return nothing
end

"""
Update Z feature for recalled+new case (confusing foil - list version used).
For strengthened trace: Replace Z=0 with KB, keep Z=1 as is
"""
function update_Z_feature_recalled_new_strengthen!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        current_z = word.word_features[tested_before_feature_pos]
        
        # If Z = 0 (incorrect/missing) → Replace with KB
        if current_z == 0
            # κ parameters: for list 1 use base, else use array
            if list_number === 1 || list_number === 0
                κ_value = kb_base
            else
                κ_index = list_number - 1
                κ_value = κb[κ_index]
            end
            
            # Only replace if original value is 0, keep 1 if it was already 1
            if word.word_features[tested_before_feature_pos] == 0
                word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
            end
        end
        # If Z = 1 → Keep as 1 (no change needed)
    end
    return nothing
end

"""
Update Z feature for recalled+new case when adding new trace.
Store Z = 1 with probability KB
"""
function update_Z_feature_recalled_new_add_trace!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for recalled+old case.
Store Z = 1 with probability KB (both strengthening and adding trace)
"""
function update_Z_feature_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+new case (really new foil).
Add new trace with Z = 1 with probability KT
"""
function update_Z_feature_not_recalled_new!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kt_base
        else
            κ_index = list_number - 1
            κ_value = κt[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+old case (target with no trace recalled).
Add trace with Z = 1 with probability KB
"""
function update_Z_feature_not_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z features for all studied-only items between lists.
According to new rules: all studied-only features get updated with Z=1 with probability KS.
"""
function update_Z_features_single_appearance_studied_items!(
    image_pool::Vector{EpisodicImage}, 
    studied_pool::Vector{Vector{EpisodicImage}}, 
    list_num::Int64, 
    n_studyitem::Int64
)::Nothing
    
    for img in image_pool

        
        if img.word.word_features[tested_before_feature_pos] == 0
            
            if list_num === 1 || list_num === 0
                κ_value = 1-ks_base
            else
                κ_index = list_num - 1
                κ_value = κs[κ_index] #updated by ks
            end
            img.word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
        end

        # Check if this image is from the current list (not a foil)
        # if img.list_number == list_num
        #     # Check if this is a studied item (not a foil) by looking at its position in studied_pool
        #     # Studied items are in positions 1:n_studyitem
        #     is_studied_item = false
        #     for j in 1:n_studyitem
        #         if !isnothing(studied_pool[list_num][j]) && 
        #            studied_pool[list_num][j].word.item_code == img.word.item_code
        #             is_studied_item = true
        #             break
        #         end
        #     end
            
        #     # If it's a studied item, update its Z feature with KS probability
        #     if is_studied_item
        #         appearance_count = 0
        #         for list_idx in 1:list_num
        #             if !isnothing(studied_pool[list_idx])
        #                 for item in studied_pool[list_idx]
        #                     if !isnothing(item) && item.word.item_code == img.word.item_code
        #                         appearance_count += 1
        #                     end
        #                 end
        #             end
        #         end
                
        #         # If the item appears only once (not doubling), update its Z feature
        #         if appearance_count == 1
        #             update_Z_feature_SOn_CFs!(img.word, list_num)
        #         end
        #     end
        # end

    end
    
    return nothing
end

"""
Update Z features for studied-only items between lists.
All studied-only features are updated with Z=1 with probability KS.
"""
function update_Z_feature_between_lists_studied_only!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # Use KS parameter for studied-only items between lists
        if list_number === 1 || list_number === 0
            κ_value = ks_base
        else
            κ_index = list_number - 1
            κ_value = κs[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end
