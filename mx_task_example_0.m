clear all;
close all;

%% Example 0: single tasking

%% define tasks
task_print = mx_task(@()printer, 1/10);    % 10 Hz

%% main loop
time_start = mx_sleep(0);  % thread sleep for 0 seconds and mark down sys time in seconds
time_now = time_start;

while (time_now <= time_start + 10) % run tasks for 10 seconds
    time_now = mx_sleep(0.001);     % scheduler base rate at 1000 Hz
    
    task_print.run(time_now);       % runs task_print if the desired period is reached    
end

%% task definition
function printer()
fprintf("Single task running at 10 Hz.\n");
end