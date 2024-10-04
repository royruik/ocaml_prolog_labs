(* Step 1*)
type job = {
  start_time: int;
  duration: int;
  priority: int
}

(* Step 2 *)
let time_to_minutes hours minutes =
  hours * 60 + minutes

(* Step 3 *)
let rec read_int prompt =
  Printf.printf "%s" prompt;
  flush stdout;
  try
    int_of_string (String.trim (input_line stdin))
  with
  | Failure _ ->
      Printf.printf "Invalid input. Please enter a valid integer.\n";
      read_int prompt

(* Step 3 *)
let read_job numbers =
  Printf.printf "For job %d, please enter the following details:\n" numbers;
  let hours = read_int "- Start Time (hours): " in
  let minutes = read_int "- Start Time (minutes): " in
  let duration = read_int "- Duration (minutes): " in
  let priority = read_int "- Priority: " in
  {
    start_time = time_to_minutes hours minutes;
    duration = duration;
    priority = priority
  }

(* Step 3 *)
let read_jobs jobs_num =
  let rec read_job_aux n acc =
    if n > jobs_num then acc
    else
      let job = read_job n in
      read_job_aux (n+1) (job :: acc)
  in
  List.rev (read_job_aux 1 [])

(* Step 4  stragety 1*)
let schedule_jobs jobs =
  List.sort (fun j1 j2 -> compare j1.start_time j2.start_time) jobs

(* Step 4  stragety 2 *)
let schedule_jobs_max_priority jobs =
  List.sort (fun j1 j2 -> compare j2.priority j1.priority) jobs

(* Step 4  stragety 3 *)
let schedule_jobs_min_idle jobs =
  let sorted_jobs = List.sort (fun j1 j2 -> compare j1.start_time j2.start_time) jobs in
  let rec minimize_idle acc = function
    | [] -> List.rev acc
    | head :: tail ->
        let new_start_time = match acc with
          | [] -> head.start_time
          | prev :: _ -> max head.start_time (prev.start_time + prev.duration)
        in
        let new_job = {head with start_time = new_start_time} in
        minimize_idle (new_job :: acc) tail
  in
  minimize_idle [] sorted_jobs

(* Step 5 *)
let print_schedule strategy jobs =
  let sorted_jobs = 
    if strategy = 2 then 
      List.sort (fun j1 j2 -> compare j2.priority j1.priority) jobs
    else
      jobs
  in
  List.iter (fun job ->
    Printf.printf "Job scheduled: Start Time = %d minutes, Duration = %d minutes, Priority = %d\n"
      job.start_time job.duration job.priority
  ) sorted_jobs

(* Step 6 *)
let main () =
  let num_jobs = read_int "How many jobs do you want to schedule? " in
  let jobs = read_jobs num_jobs in
  
  let strategy = read_int "Choose a scheduling strategy (1 for No Overlaps, 2 for Max Priority, 3 for Minimize Idle Time): " in
  
  let scheduled_jobs = match strategy with
    | 1 -> 
        Printf.printf "Scheduled Jobs (No Overlaps):\n";
        schedule_jobs jobs
    | 2 -> 
        Printf.printf "Scheduled Jobs (Max Priority):\n";
        schedule_jobs_max_priority jobs
    | 3 -> 
        Printf.printf "Scheduled Jobs (Minimize Idle Time):\n";
        schedule_jobs_min_idle jobs
    | _ -> 
        Printf.printf "Invalid strategy chosen.\n";
        schedule_jobs jobs
  in
  
  print_schedule strategy scheduled_jobs

let () = main ()