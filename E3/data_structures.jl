#===============================================
===============================================#
# Data Structures    
# word types: T_target; T_nontarget, but now add multiple kinds   

#general: 
# Fb_SO; Fb_T; Fb_F; T; F; SO

# :Fb_SO_l
# :Fb_SO
# :Fb_T_l
# :Fb_T
# :Fb_F_l
# :Fb_F
# :T
# :F
# :SO




struct Word
    item::String
    word_features::Vector{Int64}
    type_general::Symbol #modified from general
    initial_studypos::Int64 #change this to make it constant 
    initial_testpos::Int64
end


mutable struct EpisodicImage
    word::Word
    context_features::Vector{Int64}
    list_number::Int64
    type_current::Symbol
end


"""
Classification:
discard classfication in this version later; all store in word, using word structure
"""
struct Probe
    image::EpisodicImage
    classification::Symbol #simply :target or :foil
    # initial_testpos::Int64
    # initial_studypos::Int64
    
end