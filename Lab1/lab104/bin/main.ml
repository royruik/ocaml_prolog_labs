let rec reduce f acc lst = 
  match lst with
  |[] -> acc
  |head :: tail->
    reduce f (f acc head) tail 


let () =
  let result = reduce (fun x y -> x + y) 0 [1;2;3;4] in
  Printf.printf "int = : %d\n" result