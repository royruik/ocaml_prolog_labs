type job_scheduling = {
  priority : int;
  duration : int;
  start_time : int;
}


let time_to_minutes hour minute = hour * 60 + minute

(* implemented from chatGPT *)
let read_int prompt =
  Printf.printf "%s" prompt;
  flush stdout;
  let input = input_line stdin |> String.trim in
  int_of_string input


let read_jobs () =

  let start_hour = read_int "-Start Time (hours): " in

  let start_minute = read_int "-Start Time (minutes): " in

  let start_time = time_to_minutes start_hour start_minute in

  let duration = read_int "-Duration (minutes): " in

  let priority = read_int "-Priority: " in

  { priority = priority; duration = duration; start_time = start_time }



let () =
  let num_of_jobs = read_int "How many jobs do you want to schedule? " in
  

  let initial_list = {priority = 0; duration = 0; start_time = 0} in
  let list_of_job = 
    let rec insert_loop tmp_list i = 

      if i = 0 then tmp_list
      else
        Printf.printf "For job %d, please enter the following details:\n" i;
        let job = read_jobs() :: tmp_list in
        insert_loop job (i-1)
    in
  insert_loop initial_list num_of_jobs

  (* let rec insert_loop tmp_list i =
    if i = 1 then tmp_list
    else
      let job = read_jobs i in
      insert_loop (job :: tmp_list) (i - 1)
  
  let list_of_jobs num_of_jobs =
    insert_loop [] num_of_jobs *)

  (* Printf.printf "Choose a scheduling strategy (1 for No Overlaps, 2 for Max Priority, 3 for Minimize Idle Time): " *)