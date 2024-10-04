(* Job type definition *)
type job = {
  start_time: int;
  duration: int;
  priority: int
}

(* Helper function to convert time to minutes *)
let time_to_minutes hours minutes =
  hours * 60 + minutes

(* Function to safely read an integer from user input *)
let rec read_int prompt =
  Printf.printf "%s" prompt;
  flush stdout;
  try
    int_of_string (String.trim (input_line stdin))
  with
  | Failure _ ->
      Printf.printf "Invalid input. Please enter a valid integer.\n";
      read_int prompt

(* Function to read a single job from user input *)
let read_job job_number =
  Printf.printf "For job %d, please enter the following details:\n" job_number;
  let hours = read_int "- Start Time (hours): " in
  let minutes = read_int "- Start Time (minutes): " in
  let duration = read_int "- Duration (minutes): " in
  let priority = read_int "- Priority: " in
  {
    start_time = time_to_minutes hours minutes;
    duration = duration;
    priority = priority
  }

(* Function to read jobs from user input *)
let read_jobs num_jobs =
  let rec read_job_helper n acc =
    if n > num_jobs then acc
    else
      let job = read_job n in
      read_job_helper (n+1) (job :: acc)
  in
  List.rev (read_job_helper 1 [])

(* Function to schedule jobs with no overlaps *)
let schedule_jobs jobs =
  List.sort (fun j1 j2 -> compare j1.start_time j2.start_time) jobs

(* Function to schedule jobs by maximum priority *)
let schedule_jobs_max_priority jobs =
  List.sort (fun j1 j2 -> compare j2.priority j1.priority) jobs

(* Function to schedule jobs with minimum idle time *)
let schedule_jobs_min_idle jobs =
  let sorted_jobs = List.sort (fun j1 j2 -> compare j1.start_time j2.start_time) jobs in
  let rec minimize_idle acc = function
    | [] -> List.rev acc
    | job :: rest ->
        let new_start_time = match acc with
          | [] -> job.start_time
          | prev :: _ -> max job.start_time (prev.start_time + prev.duration)
        in
        let new_job = {job with start_time = new_start_time} in
        minimize_idle (new_job :: acc) rest
  in
  minimize_idle [] sorted_jobs

(* Function to print scheduled jobs *)
let print_schedule strategy jobs =
  let sorted_jobs = 
    if strategy = 2 then  (* Max Priority *)
      List.sort (fun j1 j2 -> compare j2.priority j1.priority) jobs
    else
      jobs
  in
  List.iter (fun job ->
    Printf.printf "Job scheduled: Start Time = %d minutes, Duration = %d minutes, Priority = %d\n"
      job.start_time job.duration job.priority
  ) sorted_jobs

(* Main function *)
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
        Printf.printf "Invalid strategy chosen. Using No Overlaps by default.\n";
        schedule_jobs jobs
  in
  
  print_schedule strategy scheduled_jobs

let () = main ()