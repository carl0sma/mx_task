clear all;
close all;

%% Example 2: Benchmarking
benchmark_test = 2; % 1 for mx_task; 2 for tic toc; 3 for robotics.rate

global periods idx T1 T2 T3 myMatrix
periods = zeros(100000, 3);
idx = zeros(1, 3);
myMatrix = rand(10, 10);

%% define tasks
T1 = mx_task(@()task1, 1/2000);
T2 = mx_task(@()task2, 1/1000);
T3 = mx_task(@()task3, 1/500);

%% main loop
switch (benchmark_test)
    case 2
        time_start = mx_sleep(0);
        time_now = time_start;
        tic;
    case 3
        r = robotics.Rate(1000000);
        reset(r);
        time_start = mx_sleep(0);
        time_now = time_start;
    otherwise
        time_start = mx_sleep(0);
        time_now = time_start;
end


while (time_now <= time_start + 10) % run tasks for 10 seconds
    
    switch (benchmark_test)
        case 2
            pause(0.000001);
            time_now = toc + time_start;
        case 3
            waitfor(r);
            time_now = r.TotalElapsedTime + time_start;
        otherwise
            time_now = mx_sleep(0.000001);  % mx_sleep(0) for full cpu scheduling
    end
    
    T1.run(time_now);
    T2.run(time_now);
    T3.run(time_now);
end

%% printing
fig1 = figure(1);
hold on;
h1 = histogram(periods(1:idx(1), 1));
h2 = histogram(periods(1:idx(2), 2));
h3 = histogram(periods(1:idx(3), 3));
hold off
h1.BinWidth = 1e-5;
h2.BinWidth = h1.BinWidth;
h3.BinWidth = h1.BinWidth;

legend(sprintf("T1 periods: min.: %.6f, avg.: %.6f, max.: %.6f [s]",...
                            min(periods(1:idx(1), 1)),...
                            mean(periods(1:idx(1), 1)),...
                            max(periods(1:idx(1), 1))),...
       sprintf("T2 periods: min.: %.6f, avg.: %.6f, max.: %.6f [s]",...
                            min(periods(1:idx(2), 2)),...
                            mean(periods(1:idx(2), 2)),...
                            max(periods(1:idx(2), 2))),...
       sprintf("T3 periods: min.: %.6f, avg.: %.6f, max.: %.6f [s]",...
                            min(periods(1:idx(3), 3)),...
                            mean(periods(1:idx(3), 3)),...
                            max(periods(1:idx(3), 3))));    
xlim([0, 0.0025])
xlabel('Periods [s]')
ylabel('Samples')
grid on
switch (benchmark_test)
    case 2
        saveas(fig1, 'benchmark_tictoc', 'png')
    case 3
        saveas(fig1, 'benchmark_rbtRate', 'png')
    otherwise
        saveas(fig1, 'benchmark_mx_task', 'png')
end


%% task definition
function task1()
global T1 periods idx myMatrix

myMatrix = sin(myMatrix * randn(10, 10)); % artificial load
idx(1) = idx(1) + 1;
periods(idx(1), 1) = T1.lastPeriod;
end

function task2()
global T2 periods idx myMatrix

myMatrix = cos(myMatrix * randn(10, 10)); % artificial load
idx(2) = idx(2) + 1;
periods(idx(2), 2) = T2.lastPeriod;
end

function task3()
global T3 periods idx myMatrix

myMatrix = tan(myMatrix * randn(10, 10)); % artificial load
idx(3) = idx(3) + 1;
periods(idx(3), 3) = T3.lastPeriod;
end
