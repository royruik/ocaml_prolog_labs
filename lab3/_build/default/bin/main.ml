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
let read_location () =
  print_endline "Enter location name:";
  let name = read_line () in
  print_endline "Enter X coordinate:";
  let x = float_of_string (read_line ()) in
  print_endline "Enter Y coordinate:";
  let y = float_of_string (read_line ()) in
  print_endline "Enter priority:";
  let priority = int_of_string (read_line ()) in
  { name; x; y; priority }

let rec read_locations n =
  if n <= 0 then []
  else read_location () :: read_locations (n - 1)

let read_vehicle id =
  print_endline ("Enter capacity for vehicle " ^ string_of_int id ^ ":");
  let capacity = int_of_string (read_line ()) in
  { id; capacity }

let rec read_vehicles n id =
  if n <= 0 then []
  else read_vehicle id :: read_vehicles (n - 1) (id + 1)

(* Step 4: Sort Locations by Priority *)
let sort_by_priority locations =
  List.sort (fun l1 l2 -> compare l2.priority l1.priority) locations

(* Step 5: Assign Locations to Vehicles *)
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

(* Step 6: Optimize Routes for Each Vehicle *)
let distance loc1 loc2 =
  sqrt ((loc2.x -. loc1.x) ** 2. +. (loc2.y -. loc1.y) ** 2.)

let calculate_route_distance route =
  let rec aux dist prev_location = function
    | [] -> dist
    | loc :: rest ->
        let new_dist = dist +. distance prev_location loc in
        aux new_dist loc rest
  in
  match route with
  | [] -> 0.0
  | start :: rest -> aux 0.0 start rest

(* Step 7: Display the Results *)
let display_results assignments =
  List.iter (fun (vehicle_id, route) ->
    Printf.printf "Vehicle %d route: %s\n" vehicle_id
      (String.concat " -> " (List.map (fun loc -> loc.name) route));
    Printf.printf "Total distance: %.2f km\n\n" (calculate_route_distance route)
  ) assignments

(* Main Function *)
let main () =
  print_endline "Enter the number of delivery locations:";
  let num_locations = int_of_string (read_line ()) in
  let locations = read_locations num_locations in
  let sorted_locations = sort_by_priority locations in

  print_endline "Enter the number of vehicles:";
  let num_vehicles = int_of_string (read_line ()) in
  let vehicles = read_vehicles num_vehicles 1 in

  let assignments = assign_locations sorted_locations vehicles in

  display_results assignments

(* Execute the main function *)
let () = main ()
