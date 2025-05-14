#===============================================
===============================================#
# Data Structures      

#general: 
# T; Tn; SO; SOn; F; Fn 
#      + FF for final t

# :T (B) --         appearnum=1=T; 1=T; 2=none
# :Tn+1 (Dn+1) --   appearnum=1=T; 1=T; 2=Fb
# :SO (A) --        appearnum=1=SO; 1=SO; 2=none
# :SOn+1 (Cn+1) --  appearnum=1=SO; 1=SO; 2=Fb
# :SOn (Cn) --      appearnum=2=Fb; 1=SO; 2=Fb
# :Tn (Dn) --       appearnum=2=Fb; 1=T; 2=Fb
# :Fn+1 (Fnn+1) --  appearnum=1=F; 1=F; 2=Fb
# :F (Fn)  --       appearnum=1=F; 1=F; 2=none
# :Fn (Fnn) --      appearnum=2=Fb; 1=F; 2=Fb


"""
OK, right now, I'm using mutable sturct word, later can change this (and EI) to unmutable struct, by changing all current test specific properties to be studypos_appear1, _appear2, then don't assign any current property in structure of word,maybe just do that in episodic image.... Welll. I will leave that for later optimization...
"""
mutable struct Word
    item_code::String #modify from name item
    word_features::Vector{Int64} #just renadom code assigned 
    type_general::Symbol #modified from name: general
    
    # 3 current test specific properties
    type_specific::Symbol # specific current type; 
    initial_studypos::Int64 #change this to make it consistent 
    initial_testpos::Int64 #CURRENT! TESTPOS (don't have prior study/test pos right now)
    
    is_repeat_type::Bool #True if this word is a repeatiive one, False if not
    type1:: Symbol #general type; of first appear, of type T, F, SO, Fb or none
    type2:: Symbol #general type; possible to be :none, which means not exist
end

"""
I am not making EI specific to a list right now, to make it more general so that it could be put into image pool without more worries.
"""
mutable struct EpisodicImage
    word::Word
    context_features::Vector{Int64}
    list_number::Int64 #TODO: check later; only hold initial test list number for now
    # type_current::Symbol #all 9 kinds of types; tell img of current list 
    appearnum::Int64 #number of times this image appears across list
end


"""
Classification:
discard classfication in this version later; all store in word, using word structure
(Delete studypos and testpos properties here)
(modified probetype names...)
"""
struct Probe
    image::EpisodicImage
    ProbeTypeSimple::Symbol #simply :target or :foil; modified from name classfication
    ProbeTypeGeneral::Symbol # :T; :F, :Fb (3 kinds, new Target, new Foil, and all inherented are foils)
    # ProbeTypeDetail::Symbol # 7 kinds: :T; :Tn+1; :F; :Fn+1; :Tn :Fn :SOn
    # appearnum::Int64 #appearnum used here but not for study list, because only Foil will have a second appear anyways
end