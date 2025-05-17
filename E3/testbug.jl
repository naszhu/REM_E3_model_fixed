n_between_listchange = LinRange(8, 20, 10)
p = 0.03
result = (1 - (1 - p)^n_between_listchange[1])  # Fails in whole file

