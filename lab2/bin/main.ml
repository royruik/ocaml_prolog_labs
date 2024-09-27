type job_scheduling = {
  priority of int
  duration of int
  start_time of int
}


let time_to_minutes hour minute = 
  hour * 60 + minute

let read_jobs 
