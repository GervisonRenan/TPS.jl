include("model.jl")
include("instance.jl")

println("Which of the following option do you want? (1 - Open archive) (2 - Random option) (3 - Create a random archive) ?: ")    
assistant = parse(Int, readline())


if assistant == 1
    println(" Name the file(put '.txt'): ")
    name = readline()

    insta = Tsp_model.load_instance(name)
    tour_edges, cost = build_tsp_model(insta)

elseif assistant == 2

    insta = Tsp_model.generate_distance()
    tour_edges, cost = build_tsp_model(insta)

elseif assistant == 3

    println(" Name the file(put '.txt'): ")
    name = readline()

    Tsp_model.create_instance(name)
    insta = Tsp_model.load_instance(name)
    tour_edges, cost = build_tsp_model(insta)

else
    println("Invalid option! Please enter a valid option")
end


open("tsp_solution.txt", "w") do io
    write(io, "Edges traveled:\n")
    for (i, j) in tour_edges
        write(io, "($i, $j)\n")
    end
    write(io, "\nDistance: $cost\n")
end