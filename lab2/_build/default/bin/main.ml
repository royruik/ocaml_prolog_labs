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


let read_jobs index =
  Printf.printf "For job %d, please enter the following details:\n" index;

  let start_hour = read_int "-Start Time (hours): " in

  let start_minute = read_int "-Start Time (minutes): " in

  let start_time = time_to_minutes start_hour start_minute in

  let duration = read_int "-Duration (minutes): " in

  let priority = read_int "-Priority: " in

  { priority = priority; duration = duration; start_time = start_time }



let () =
  let num_of_jobs = read_int "How many jobs do you want to schedule? " in

  let rec insert_loop tmp_list i = 
    if i = 0 then tmp_list
    else
      insert_loop (read_jobs (1 + num_of_jobs + i) :: tmp_list) (i+1)
    in

  let jobs = insert_loop [] (0 - num_of_jobs) in

  let sort_jobs jobs = 
    List.sort (fun job1 job2 -> 
      let primary = compare (job1.priority) (job2.priority) in
      if primary = 0 then compare (job1.start_time) (job2.start_time) else primary
    ) 
    jobs in
  let sorted_jobs = sort_jobs jobs in


  let print_job_details job =
    Printf.printf "Job Details - Priority: %d, Duration: %d minutes, Start Time: %d minutes past midnight\n"
      job.priority job.duration job.start_time in

  List.iter print_job_details sorted_jobs
