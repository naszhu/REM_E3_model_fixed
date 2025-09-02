# Constants needed for the test
total_probe_L1 = 15
total_probe_Ln = 12
nItemPerUnit_final = 2
n_finalprobs = 492

# Initialize tracking variable
previous_chunk = 0

for iprobe in 1:n_finalprobs
    iprobe_chunk_boundaries = cumsum([total_probe_L1 * nItemPerUnit_final * 2; fill(total_probe_Ln * nItemPerUnit_final * 2, 9)])
    iprobe_chunk = findfirst(x -> iprobe <= x, iprobe_chunk_boundaries)   

    if (iprobe != 1) && (iprobe_chunk > 1) && (iprobe_chunk != previous_chunk)
        println("Probe $iprobe: Chunk boundary from $previous_chunk to $iprobe_chunk")
    end

    # Update tracking variable
    previous_chunk = iprobe_chunk
end




#### below is the mistaken one
# Constants needed for the test
total_probe_L1 = 15
total_probe_Ln = 12
nItemPerUnit_final = 2
n_finalprobs = 492



for iprobe in 1:n_finalprobs
    iprobe_chunk_boundaries = cumsum([total_probe_L1 * nItemPerUnit_final * 2; fill(total_probe_Ln * nItemPerUnit_final * 2, 9)])  # First chunk has 15*2*2 items, rest 9 chunks have 12*2*2 items
    iprobe_chunk = findfirst(x -> iprobe <= x, iprobe_chunk_boundaries)   

    if (iprobe != 1) && (iprobe_chunk != findlast(x -> (iprobe - 1) > x, iprobe_chunk_boundaries)) && (iprobe_chunk > 1) 
        println("Probe $iprobe")
    end

end



