
let compose_functions f g x = f (g x)
let composed = compose_functions (fun x -> x * 2) (fun y -> y + 3);;
let result = composed 5 in
Printf.printf "int = %d\n" result
