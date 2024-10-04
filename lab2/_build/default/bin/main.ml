type job_scheduling = {
  priority : int;
  duration : int;
  start_time : int;
}

let time_to_minutes hour minute = hour * 60 + minute

let read_int prompt =
  Printf.printf "%s" prompt;
  flush stdout;
  let input = input_line stdin |> String.trim in
  int_of_string input

let read_jobs index =
  Printf.printf "For job %d, please enter the following details:\n" index;

  let start_hour = read_int "-Start Time (hours): " in
  let start_minute = read_int "-Start Time (minutes): " in
  let start_time = time_to_minutes start_hour start_minute in

  let duration = read_int "-Duration (minutes): " in
  let priority = read_int "-Priority: " in

  { priority = priority; duration = duration; start_time = start_time }

(* No Overlaps: Schedule jobs without overlaps, adjusting start times if needed. *)
let schedule_no_overlaps jobs =
  let rec adjust_schedule jobs acc last_end_time =
    match jobs with
    | [] -> List.rev acc
    | job::tail ->
      let start_time = max job.start_time last_end_time in
      let end_time = start_time + job.duration in
      adjust_schedule tail ({ job with start_time = start_time } :: acc) end_time
  in
  adjust_schedule jobs [] 0

(* Max Priority: Schedule jobs based only on priority. *)
let schedule_max_priority jobs =
  List.sort (fun job1 job2 -> compare job1.priority job2.priority) jobs

(* Minimize Idle Time: Schedule jobs back-to-back to reduce idle time. *)
let schedule_minimize_idle_time jobs =
  let rec back_to_back_schedule jobs acc last_end_time =
    match jobs with
    | [] -> List.rev acc
    | job::tail ->
      let start_time = if last_end_time > job.start_time then last_end_time else job.start_time in
      let end_time = start_time + job.duration in
      back_to_back_schedule tail ({ job with start_time = start_time } :: acc) end_time
  in
  back_to_back_schedule jobs [] 0

let () =
  let num_of_jobs = read_int "How many jobs do you want to schedule? " in

  let rec insert_loop tmp_list i = 
    if i = 0 then tmp_list
    else
      insert_loop (read_jobs (num_of_jobs - i + 1) :: tmp_list) (i-1)
  in

  let jobs = insert_loop [] num_of_jobs in

  let strategies = read_int "Choose a scheduling strategy (1 for No Overlaps, 2 for Max Priority, 3 for Minimize Idle Time): " in

  let sorted_jobs = 
    match strategies with
    | 1 -> schedule_no_overlaps jobs
    | 2 -> schedule_max_priority jobs
    | 3 -> schedule_minimize_idle_time jobs
    | _ -> failwith "Invalid strategy" 
  in

  let print_job_details job =
    let hours = job.start_time  in
    let minutes = job.start_time  in
    Printf.printf "Job scheduled: Start Time = %02d:%02d, Duration = %d minutes, Priority = %d\n"
      hours minutes job.duration job.priority
  in

  List.iter print_job_details sorted_jobs