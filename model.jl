using JuMP
using MathOptInterface
import GLPK
import Plots





#############################################################
# 1. function subtours para encontrar o subtours mais curto # 
# 2. function selected edges selecionar arestas >0.5        #
# 3. Plotar o tour                                          #
#############################################################
function subtour(edges::Vector{Tuple{Int, Int}}, n)   #edges = arestas e n = pontos
    shortest_subtour, unvisited = collect(1:n), Set(collect(1:n))
    while !isempty(unvisited)
        this_cycle, neighbors = Int[], unvisited
        while !isempty(neighbors)
            current = pop!(neighbors)
            push!(this_cycle, current)
            if length(this_cycle) > 1
                pop!(unvisited, current)
            end
            neighbors = 
                [j for (i, j) in edges if i == current && j in unvisited]
        end
        if length(this_cycle) < length(shortest_subtour)
            shortest_subtour = this_cycle
        end
    end
    return shortest_subtour
end

function selected_edges(x::Matrix{Float64}, n)
    return Tuple{Int, Int}[(i, j) for i in 1:n, j in 1:n if x[i, j] > 0.5]
end

function plot_tour(X, Y, x)
    plot = Plots.plot()
    for (i, j) in selected_edges(x, size(x, 1))
        Plots.plot!([X[i], X[j]], [Y[i], Y[j]]; legend = false)
    end
    display(plot)
    return plot
end

subtour(x::AbstractMatrix{VariableRef}) = subtour(value.(x))
subtour(x::Matrix{Float64}) = subtour(selected_edges(x, size(x, 1)), size(x, 1))


function tsp_model(instance)


    n = instance.n
    model = Model(GLPK.Optimizer)

    @variable(model, x[1:instance.n, 1:instance.n], Bin, Symmetric)
    
    @objective(model, Min, sum(instance.d * x) / 2)
   
    @constraint(model, [i in 1:instance.n], sum(x[i, :]) == 2)
    @constraint(model, [i in 1:instance.n], x[i, i] == 0)

    
    lazy_model = model
function subtour_elimination_callback(cb_data)
    status = callback_node_status(cb_data, lazy_model)
    if status != MOI.CALLBACK_NODE_STATUS_INTEGER
        return  # Only run at integer solutions
    end
    cycle = subtour(callback_value.(cb_data, lazy_model[:x]))
    if !(1 < length(cycle) < n)
        return  # Only add a constraint if there is a cycle
    end
    println("Found cycle of length $(length(cycle))")
    S = [(i, j) for (i, j) in Iterators.product(cycle, cycle) if i < j]
    con = @constraint(
        lazy_model, sum(lazy_model[:x][i, j] for (i, j) in S) <= length(cycle) - 1
    )
    MOI.submit(lazy_model, MOI.LazyConstraint(cb_data), con)
    return
end

set_attribute(
    lazy_model,
    MOI.LazyConstraintCallback(),
    subtour_elimination_callback
)

optimize!(lazy_model)

plot_tour(instance.X, instance.Y, value.(lazy_model[:x]))

results = reorganize(collect(tour_edges_sym))      
return results, objective_value(lazy_model)
        end
    end
end