exception Unequal_lengths

let rec map2 f l1 l2 = 
  match (l1, l2) with
  | ([], []) -> []
  | (x1::xs1, x2::xs2) -> (f x1 x2) :: (map2 f xs1 xs2)
  | _ -> raise Unequal_lengths



  let () =
  let result = map2 (fun x y -> x + y) [1; 2; 3] [4; 5; 6] in
  Printf.printf "[";
  List.iteri (fun i x ->
    if i < List.length result - 1 then
      Printf.printf "%d; " x
    else
      Printf.printf "%d" x
  ) result;
  Printf.printf "]\n"

