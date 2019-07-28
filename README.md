# mx_task
A simple to use MATLAB library for "real-time" multi-tasking.

Multitasking with tic-toc and robotics.Rate require full CPU usage which is sometimes undesired. 

The new mx_task class allows users to achieve an almost real-time multitasking functionality in MATLAB, whilst not requiring full CPU usage.

--- 
Currently supports Linux only.

Functionality verified on a 18.04LTS machine with MATLAB R2016b and R2019a.

Example 0 shows the basic functionalities of the mx_task library.

Example 1 shows how to implement multi-tasking.

Example 2 is a benchmarking script for comparisons between the scheduling capabilities of mx_task, tictoc, and robotics.Rate.

--- Usage ---
1. First define a task with a function and affix it to a new mx_task instance. Define the desired task period at the second input. 

myTask = mx_task(@()myFunc, 1/10);
function myFunc()
fprintf("Hello world.\n");
end

2. Capture the start time in [seconds since epoch] with mx_sleep().
time_start = mx_sleep(0); % sleeps for 0 seconds
time_now = time_start;

3. Create a while loop with a simulation time trap in the condition. mx_sleep for 1us for an almost real-time scheduling quality. Run task by task.run(time_now).
while (time_now <= time_start + 10) % run tasks for 10 seconds.
  time_now = mx_sleep(1/1000000);
  
  myTask.run(time_now);
end

--- Installation ---
Run the install script.


--- Future plans ---
Windows support.

