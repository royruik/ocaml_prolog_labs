exception Unequal_lengths

let rec map2 f l1 l2 = 
  match (l1, l2) with
  | ([], []) -> []
  | (head::tail, head1::tail2) -> (f head head1) :: (map2 f tail tail1)
  | _ -> raise Unequal_lengths



let () =
  let result = map2 (fun x y -> x + y) [1;2;3] [4;5;6] in
  Printf.printf "int list = [";
  List.iter (Printf.printf " %d ") result;
  Printf.printf "]";
  Printf.printf "\n"
