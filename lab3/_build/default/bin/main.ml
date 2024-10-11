(* Step 1: Define the Location Structure *)
type location = {
  name: string;
  x: float;
  y: float;
  priority: int;
}

(* Step 2: Define the Vehicle Structure *)
type vehicle = {
  id: int;
  capacity: int;
}

(* Step 3: Get User Input for Locations and Vehicles *)
let read_int_with_prompt prompt =
  Printf.printf "%s" prompt;
  flush stdout;
  let rec read_valid_int () =
    try
      int_of_string (read_line ())
    with
    | Failure _ ->
        print_endline "Invalid input. Please enter a valid integer.";
        read_valid_int ()
  in
  read_valid_int ()

let read_float_with_prompt prompt =
  Printf.printf "%s" prompt;
  flush stdout;
  float_of_string (read_line ())

let read_string_with_prompt prompt =
  Printf.printf "%s" prompt;
  flush stdout;
  read_line ()

let read_location () =
  let name = read_string_with_prompt "Location name: " in
  let x = read_float_with_prompt "X coordinate: " in
  let y = read_float_with_prompt "Y coordinate: " in
  let priority = read_int_with_prompt "Priority: " in
  { name; x; y; priority }

let rec read_locations n =
  if n <= 0 then []
  else read_location () :: read_locations (n - 1)

(* Step 4: Define the default home location *)
let home = { name = "Home"; x = 0.0; y = 0.0; priority = 0 }

let get_other_locations () =
  let num_locations = read_int_with_prompt "Enter the number of delivery locations: " in
  read_locations num_locations

let read_vehicle id =
  let capacity =
    let rec read_valid_capacity () =
      Printf.printf "Enter capacity for vehicle %d: " id;
      flush stdout;
      try
        int_of_string (read_line ())
      with
      | Failure _ ->
          print_endline "Invalid input. Please enter a valid integer.";
          read_valid_capacity ()
    in
    read_valid_capacity ()
  in
  { id; capacity }

let rec read_vehicles n id =
  if id > n then []
  else
    let vehicle = read_vehicle id in
    vehicle :: read_vehicles n (id + 1)

(* Step 5: Sort Locations by Priority *)
let sort_by_priority locations =
  List.sort (fun l1 l2 -> compare l2.priority l1.priority) locations

(* Step 6: Assign Locations to Vehicles *)
let rec assign_locations locations vehicles =
  let rec assign_to_vehicle locations vehicle assigned =
    match locations with
    | [] -> (assigned, [])
    | loc :: rest ->
        if List.length assigned < vehicle.capacity then
          assign_to_vehicle rest vehicle (loc :: assigned)
        else
          (assigned, locations)
  in
  match vehicles with
  | [] -> []
  | v :: vs ->
      let (assigned, remaining) = assign_to_vehicle locations v [] in
      (v.id, List.rev assigned) :: assign_locations remaining vs

(* Step 7: Optimize Routes for Each Vehicle *)
let distance loc1 loc2 =
  sqrt ((loc2.x -. loc1.x) ** 2. +. (loc2.y -. loc1.y) ** 2.)

let calculate_route_distance route home =
  let rec aux dist prev_location = function
    | [] -> dist
    | loc :: rest ->
        let new_dist = dist +. distance prev_location loc in
        aux new_dist loc rest
  in
  match route with
  | [] -> 0.0
  | start :: rest ->
      let total_dist = aux 0.0 start rest in
      total_dist +. distance (List.hd (List.rev route)) home

(* Step 8: Display the Results *)
let display_results assignments home =
  List.iter (fun (vehicle_id, route) ->
    let full_route = route @ [home] in
    Printf.printf "Vehicle %d route: %s\n" vehicle_id
      (String.concat " -> " (List.map (fun loc -> loc.name) full_route));
    Printf.printf "Total distance: %.2f km\n\n"
      (calculate_route_distance full_route home)
  ) assignments

(* Main Function *)
let main () =
  let locations = get_other_locations () in
  let sorted_locations = sort_by_priority locations in

  let num_vehicles = read_int_with_prompt "Enter the number of vehicles: " in
  let vehicles = read_vehicles num_vehicles 1 in

  let assignments = assign_locations sorted_locations vehicles in

  display_results assignments home

(* Execute the main function *)
let () = main ()
