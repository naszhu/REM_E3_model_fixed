



function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end



function generate_study_list(list_num::Int, g_word::Float64,w_word::Int64 )::Vector{Word}

    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)

    #  T; SO; Tn; SOn #Target and/or will inherent type (n), studied only n and not n
    # nItemPerUnit=3; Tn+1=4; T=1; SO=4; SOn+1=1;
    # Create the symbol array based on the counts
    types = reduce(vcat, fill(symbol, count*nItemPerUnit) for (symbol, count) in probeTypeDesign_study) |> shuffle!
    # println(length(types), " nw:",n_words)
    @assert length(types) == n_words "The number of types does not match the number of words"
    type_general = map(x -> occursin(r"\+1$", String(x)) ? Symbol(replace(String(x), r"\+1$" => "")) : x, types)   


    for i in eachindex(word_list)
        # Generate 24 normal features using Geometric distribution
        features = rand(Geometric(g_word), w_word) .+ 1
        
        # Add OT feature (always added)
        push!(features, 0)  # For study items, OT feature starts as 0 (not tested before)
        
        word_list[i] = Word(
            randstring(8), #"Word$(i)L$(list_num)", # item_code
            features, # word_features with OT feature
            type_general[i], # type_general
            types[i], # type_specific
            i,# initial_studypos
            0, # initial_testpos' initialize as 0
            type_general[i] in (:Tn, :SOn) ? true : false, # is_repeat_type
            type_general[i] in (:Tn, :T) ? :T : :SO, # type1
            type_general[i] in (:SOn, :Tn) ? :Fb : :none, # type2
        )
     # check for end.. stuff. might accidently delete somthing
    end 


    return word_list

end
