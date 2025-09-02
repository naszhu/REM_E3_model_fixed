


# parameters
p_copy = 0.3
p_drift = 0.9
p_orig_correct = p_copy*(1-p_drift) 
println("original correcrt = ", p_orig_correct)
p_strenghten = 0.8
p_no_strengthen = 1 - p_strenghten
p_cor_if_strenghten = 1-p_drift #this is probabiltiy of whats prob of the CC feature of last list is still the CC used in current list, when CC changed on the background, then this value will be incorrect  

# conditional probabilities
p_now_correct_given_orig_correct   = p_no_strengthen*1    + p_strenghten*p_cor_if_strenghten
p_now_correct_given_orig_incorrect = p_no_strengthen*0    + p_strenghten*p_cor_if_strenghten

# overall probability
p_now_correct = p_orig_correct * p_now_correct_given_orig_correct +
                (1 - p_orig_correct) * p_now_correct_given_orig_incorrect

println("P(now correct | orig correct)   = ", p_now_correct_given_orig_correct)
println("P(now correct | orig incorrect) = ", p_now_correct_given_orig_incorrect)
println("P(now correct)                  = ", p_now_correct)


# calculation of the second part of the term in the equation of calculating p(match) when considering random generation "accidently" makes the feature match 


# see manual draft in the issue 
g = 0.02

# before is when no strenghten
a_before = 0.3*(1-g)*0.6*g

# after is when strenghten
a_after = 0.3*(1-g)* (0.6*g*0.8 + 0.8*0.4 + 0.2*0.6*g)

println("a_before = ", a_before)
println("a_after = ", a_after)