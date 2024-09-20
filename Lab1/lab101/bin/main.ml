exception Unequal_lengths

let rec map2 f l1 l2 = 
  match (l1, l2) with
  | ([], []) -> []
  | (head::tail, head2::tail2) -> (f head head2)  :: (map2 f tail tail2)
  | _ -> raise Unequal_lengths



let () =
  let result = map2 (fun x y -> x + y) [1;2;3] [4;5;6] in
  Printf.printf "int list = [";
  Printf.printf "%s" (String.concat ";" (List.map string_of_int result));
  Printf.printf "]\n"