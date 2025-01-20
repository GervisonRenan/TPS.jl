nclude("instance.jl")
include("model.jl")


println("Choose an option (1 - Open archive, 2 - Random instance, 3 - Save and open): ")
choice = parse(Int, readline())

if choice == 1
    println("Enter the archive name (.txt): ")
    name = readline()
    instance = load_instance(name)
    tour_edges, cost = build_tsp_model(instance)
elseif choice == 2
    instance = generate_distance()
    tour_edges, cost = build_tsp_model(instance)
elseif choice == 3
    println("Enter the archive name (.txt): ")
    name = readline()
    instance = create_instance(name)
    tour_edges, cost = build_tsp_model(instance)
else
    println("Invalid option")
end