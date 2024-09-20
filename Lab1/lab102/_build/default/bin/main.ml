let rec filter_even l1 =
  match l1 with
  | [] -> []
  | head :: tail ->
      if head mod 2 = 0 then head :: filter_even tail
      else filter_even tail

let () =
  let result = filter_even [1; 2; 3; 4; 5; 6; 7; 8] in
  Printf.printf "The int list = [";
  List.iter (Printf.printf "%d ") result;
  Printf.printf "]";
  Printf.printf "\n"
      
