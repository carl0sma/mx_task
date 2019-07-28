clear all;
close all;

%% Example 1: multitasking with intertask data transfer

%% define intertask variables
global myMatrix
myMatrix = randn(3,3);

%% define tasks
task_math = mx_task(@()math, 1/1000);    % 1000 Hz
task_print = mx_task(@()printer, 1/1);   % 1 Hz

%% main loop
time_start = mx_sleep(0);  % thread sleep for 0 seconds and mark down sys time in seconds
time_now = time_start;

while (time_now <= time_start + 10) % run tasks for 10 seconds
    time_now = mx_sleep(0.000001);   % scheduler base rate at 1 MHz
    
    task_math.run(time_now);        % arrange tasks according to their priorities
    task_print.run(time_now);
end

%% task definition
function math()
global myMatrix          % define intertask variables
myMatrix = myMatrix * rand(3,3);
myMatrix = myMatrix ./ norm(myMatrix);
end

function printer()
global myMatrix          % define intertask variables
fprintf("Matrix: \n \t %.2f \t %.2f \t %.2f \n \t %.2f \t %.2f \t %.2f \n \t %.2f \t %.2f \t %.2f \n\n", ...
        myMatrix(1,1), myMatrix(1,2), myMatrix(1,3),...
        myMatrix(2,1), myMatrix(2,2), myMatrix(2,3),...
        myMatrix(3,1), myMatrix(3,2), myMatrix(3,3));
end