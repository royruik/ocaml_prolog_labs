
let compose_functions f g x = f (g x)
let composed = compose_functions (fun x -> x * 2) (fun y -> y + 4);;
let result = composed 5 in
Printf.printf "Result of composed function applied to 5 is: %d\n" result
