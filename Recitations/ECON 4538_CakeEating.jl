using Plots

function cake_eating_solver(β,k_grid,inf_correction=-100)
    n = length(k_grid)
    V0 = zeros(n)
    V1 = V0
    h = V0
    for t = 1:10000
        println("Iteration number $t")
        M1 = repeat(k_grid,1,n)
        M2 = repeat(transpose(V0),n,1)
        M3 = repeat(transpose(k_grid),n,1)
        M4 = M1 .- M3
        M4[M4 .<= 0] .= 0
        M5 = log.(M4) .+ β .* M2
        V1 = maximum(M5, dims=2)
        V1[V1 .== -Inf] .= inf_correction
        h_index = argmax(M5, dims=2)
        h_index = getindex.(h_index,2)
        h = k_grid[h_index]
        d = maximum(abs.(V1 .- V0))
        println("Difference = $d")
        if d >= 10^(-7)
            V0 = V1
        else
            break
        end
    end

    return V1,h
end

k_grid = LinRange(0,10,100)

V,h = cake_eating_solver(.95,k_grid)

plot(k_grid,V)
plot(k_grid,h)