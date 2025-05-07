



function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end



function generate_study_list(list_num::Int, g_word::Float64,w_word::Int64 )::Vector{Word}

    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = fast_concat(fill.([:T_target, :T_nontarget], [Int(n_probes / 2), Int(n_probes / 2)])) |> shuffle!

    #  T; SO; Tn; SOn #Target and/or will inherent type (n), studied only n and not n
    # nItemPerUnit=3; T=4; Tn=1; SO=4; SO=1;

    # Define a dictionary to associate each symbol type with its number of repetitions


    # Create the symbol array based on the counts
    types = reduce(vcat, fill(symbol, count) for (symbol, count) in probeTypeDesign_study) |> shuffle!

    for i in 1:n_words
        word_list[i] = Word(
            # item
            "Word$(i)L$(list_num)", 
            # word_features
            rand(Geometric(g_word), w_word) .+ 1, 
            # type_general
            types[i], 
            # initial_studypos
            i, 
            # initial_testpos' test position initialize as 0
            0 
        )
     # check for end.. stuff. might accidently delete somthing
    end 


    return word_list

end
