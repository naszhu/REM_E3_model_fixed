



function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end



function generate_study_list(list_num::Int, g_word::Float64,w_word::Int64 )::Vector{Word}

    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = fast_concat(fill.([:T_target, :T_nontarget], [Int(n_probes / 2), Int(n_probes / 2)])) |> shuffle!

    for i in 1:n_words
        # word_list[i] = Word(
        #     item = "Word$(i)L$(list_num)",
        #     word_features = rand(Geometric(g_word), w_word) .+ 1,
        #     type_general = types[i],
        #     initial_studypos = i,
        #     initial_testpos = 0
        # ) 
            word_list[i] = Word("Word$(i)L$(list_num)",rand(Geometric(g_word), w_word) .+ 1,types[i],i,0) 
    end 


    return word_list
end
