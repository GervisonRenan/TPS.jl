module Tsp_model

using Random

struct dist_matrix 
    X::Vector{Float64}
    Y::Vector{Float64}
    m::Matrix{Float64}
    n::Int64
end

function verify_instance(instance, name)  #Verificar instancias 
    
    open(name, "r") do file 
        
        n2 = parse(Int, readline(file))

        X2 = [parse(Float64, readline(file)) for i in 1:n2]
        Y2 = [parse(Float64, readline(file)) for i in 1:n2]

        m2 = [parse(Float64, readline(file)) for i in 1:(n2 * n2)]
        m2 = reshape(m2, n2, n2)

        if (instance.X != X2) || (instance.Y != Y2) || (instance.m != m2)
            return false
        else
            return true
        end
    end
end

function load_instance(name)
    open(name, "r") do file 
        n1 = parse(Int, readline(file))

        X1 = [parse(Float64, readline(file)) for i in 1:n1]
        Y1 = [parse(Float64, readline(file)) for i in 1:n1]

        m1 = [parse(Float64, readline(file)) for i in 1:(n1 * n1)]
        m1 = reshape(m1, n1, n1)

        return distance_matrix(X1, Y1, m1, n1)
    end
end

function create_instance(name)  #Criar instancias 
    
    n1 = 10
    rng = Random.MersenneTwister(3)
    X1 = 10 * rand(rng, n1)
    Y1 = 10 * rand(rng, n1)
    m1 = [sqrt((X1[i] - X1[j])^2 + (Y1[i] - Y1[j])^2) for i in 1:n1, j in 1:n1]
    instance = dist_matrix(X1, Y1, m1, n1)

    open(name, "w") do io
        println(io, n1)
        for i in X1
            println(io, i)
        end
        for j in Y1
            println(io, j)
        end

        for i in 1:n1
            for j in 1:n1
                println(io, d1[i, j])
            end
        end
    end
end
end 