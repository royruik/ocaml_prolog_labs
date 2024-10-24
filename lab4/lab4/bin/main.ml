(* Step 1: Define the Sudoku *)
let sudoku = [
  [0; 2; 0; 4];
  [0; 0; 1; 0];
  [0; 1; 0; 0];
  [4; 0; 0; 0]
]

(* Step 2: Check Number is Valid *)
let is_valid grid row col num =
  let check_row () = 
    not (List.mem num (List.nth grid row))
  in
  let check_column () =
    let column = List.map (fun r -> List.nth r col) grid in
    not (List.mem num column)
  in
  let check_subgrid () =
    let start_row = (row / 2) * 2 in
    let start_col = (col / 2) * 2 in
    not (List.exists (fun r ->
      List.exists (fun c ->
        List.nth (List.nth grid r) c = num
      ) [start_col; start_col + 1]
    ) [start_row; start_row + 1])
  in
  match check_row (), check_column (), check_subgrid () with
| true, true, true -> true
| _ -> false

  let copy_grid grid =
    List.map (fun row -> List.map (fun cell -> cell) row) grid
  
  (* Step 3: Verify the Initial Grid *)
  let verify_initial_grid grid =
    let is_valid_placement row col num =
      let temp_grid = copy_grid grid in
      let temp_grid = List.mapi (fun r l ->
        if r = row then
          List.mapi (fun c v -> if c = col then 0 else v) l
        else l
      ) temp_grid in
      is_valid temp_grid row col num
    in
    let rec check_row row =
      if row = 4 then true
      else
        let rec check_col col =
          if col = 4 then check_row (row + 1)
          else
            let cell = List.nth (List.nth grid row) col in
            if cell = 0 || is_valid_placement row col cell then check_col (col + 1)
            else false
        in
        check_col 0
    in
    check_row 0

(* Step 4: Backtracking Algorithm *)
let solve_sudoku grid =
  let find_empty_cell grid =
    let rec aux row col =
      if row = 4 then None
      else if col = 4 then aux (row + 1) 0
      else if List.nth (List.nth grid row) col = 0 then Some (row, col)
      else aux row (col + 1)
    in
    aux 0 0
  in

  let rec solve grid =
    match find_empty_cell grid with
    | None -> Some grid  (* Solution found *)
    | Some (row, col) ->
        let rec fill_number n =
          if n > 4 then None
          else if is_valid grid row col n then
            let new_grid = 
              List.mapi (fun r row_list ->
                if r = row then 
                  List.mapi (fun c v -> if c = col then n else v) row_list
                else row_list
              ) grid
            in
            match solve new_grid with
            | Some solution -> Some solution
            | None -> fill_number (n + 1)
          else fill_number (n + 1)
        in
        fill_number 1
  in
  solve grid

(* Step 5: Display the Sudoku Grid *)
let print_grid grid =
  Printf.printf "+---+---+---+---+\n";
  List.iteri (fun i row ->
    Printf.printf "|";
    List.iteri (fun j cell ->
      Printf.printf " %d " cell;
      if j mod 2 = 1 then Printf.printf "|"
    ) row;
    Printf.printf "\n";
    if i mod 2 = 1 then Printf.printf "+---+---+---+---+\n"
  ) grid

(* Step 6: other exception *)
let hanle_edge_case grid =
  if not (verify_initial_grid grid) then
    Printf.printf "Invalid input grid\n"
  else
    match solve_sudoku grid with
    | Some solved_grid ->
        Printf.printf "Sudoku solved successfully:\n";
        print_grid solved_grid
    | None ->
        Printf.printf "No solution exists for this Sudoku puzzle.\n"

(* Main function *)
let () =
  Printf.printf "Initial 4x4 Sudoku Grid:\n";
  print_grid sudoku;
  Printf.printf "\n";
  hanle_edge_case sudoku