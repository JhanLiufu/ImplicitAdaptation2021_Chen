%% This code is for predictor data processing.
% Updated Version by Hokin Deng, at John Hopkins. 
clear;
xCenter = 960;
yCenter = 540;
finaldata = [0 0];
estmdata = [0 0];
abovefinal = zeros(210, 1);
aboveestm = zeros(210, 1);
belowfinal = zeros(210, 1);
belowestm = zeros(210, 1);


for i = 1:3
    currentfolder = pwd; %% the current predictor folder
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        estimation = cell2mat(struct2cell(load(currenttrial,'trialestimation')));
        %% move the zero to the center of the screen
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
        estmx = estimation(1,2) - xCenter;
        estmy = yCenter - estimation(1,3);
        finaldata((i-1)*30+j) = atand(finaly/finalx);
        estmdata((i-1)*30+j) = atand(estmy/estmx);
        if (finalx > 0)
            abovefinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (estmx > 0)
            aboveestm((i-1)*30+j) = atand(estmy/estmx);
        end 
        if (finalx < 0)
            belowfinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (estmx < 0)
            belowestm((i-1)*30+j) = atand(estmy/estmx);
        end 
    end
    cd(currentfolder);
end

for i = 4:7
    currentfolder = pwd; %% the current predictor folder
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        estimation = cell2mat(struct2cell(load(currenttrial,'trialestimation')));
        % move the zero to the center of the screen
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
        estmx = estimation(1,2) - xCenter;
        estmy = estimation(1,3) - yCenter;
        finaldata((i-1)*30+j) = atand(finaly/finalx);
        estmdata((i-1)*30+j) = atand(estmy/estmx);
        if (finalx > 0)
            abovefinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (estmx > 0)
            aboveestm((i-1)*30+j) = atand(estmy/estmx);
        end 
        if (finalx < 0)
            belowfinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (estmx < 0)
            belowestm((i-1)*30+j) = atand(estmy/estmx);
        end 
    end
    cd(currentfolder);
end

%% Absolute Plot of Position
x = linspace(0,210,210);
figure;
plot(x, finaldata,"o", x, estmdata, "x");
axis([0 210 -30 30]);
xlabel("Trial Number");
ylabel("Abs Degree");

figure;
plot(x, finaldata, "-*", "Color","green");
hold on;
plot(x, estmdata, "-o", "Color","blue");
axis([0 210 -30 30]);
xlabel("Trial Number");
ylabel("Abs Degree");

%% 
figure;
plot(finaldata(1:90), estmdata(1:90), "rx");
hold on;
plot(finaldata(91:210), estmdata(91:210), "go");
plot([-10,20], [-10,20], "k-");
plot(finaldata(91:95), estmdata(91:95), "b.-");
plot(finaldata(91), estmdata(91), "bo");
plot([-10,20], [10,-20], "k--");
%% Plotting Error (anti-clock wise would be positive)
error = [0 0];
for i = 1:210
error(i) = estmdata(i) - finaldata(i);
end

figure;
plot(x, error, "*", "Color","red");
xlabel("Trial Number");
ylabel("directional error: anti-clockwise would be positive");

%% Plot Abs Error
abserr= [0 0];
for i = 1:210
    abserr(i) = abs(error(i));
end 

figure;
plot(x, abserr, "-o", "Color","blue");
xlabel("Trial Number");
ylabel("Absolute error");
axis([0 220 0 50]);

%% Plot Above/Below Data
figure;
axis([0 220 -40 40]);
plot(x, abovefinal, "*", x, aboveestm, "o", "Color","red");
hold on;
plot(x, belowfinal, "*", x, belowestm, "o", "Color","blue");
xlabel("Trial Number");
ylabel("Above in red, below in blue");
% Dimensional shift
figure;
aboveshift = zeros(210, 1);
belowshit = zeros(210, 1);
aboveshift = abovefinal + 90;
belowshit = belowfinal - 90;
plot(x, aboveshift, "*", x, aboveestm + 90, "o", "Color","red");
hold on;
plot(x, belowshit, "*", x, belowestm - 90, "o", "Color","blue");
axis([0 220 -200 200]);
xlabel("Trial Number");
ylabel("Shift for seperation");
% Seperate Above and Below
figure;
plot(x, abovefinal, "*", x, aboveestm, "o", "Color","red");
axis([0 220 -40 40]);
xlabel("Trial Number");
ylabel("Above");
figure; 
plot(x, belowfinal, "*", x, belowestm, "o", "Color","blue");
axis([0 220 -40 40]);
xlabel("Trial Number");
ylabel("Below");

%% Calculate Above/Below Error
figure;
aboveerrorabs = abs(abovefinal - aboveestm);
plot(x, aboveerrorabs, "-o", "Color","red");
axis([0 220 0 40]);
xlabel("Trial Number");
ylabel("Above Error Absolute");

figure;
% Below Error
belowerrorabs = abs(belowfinal - belowestm);
plot(x, belowerrorabs, "-o", "Color","green");
axis([0 220 0 40]);
xlabel("Trial Number");
ylabel("Below Error Absolute");

%% Learning direction considering Above/Below Seperately
figure;
aber = abovefinal - aboveestm;
plot(x, aber, "*", "Color","red");
axis([0 220 -40 40]);
xlabel("Trial Number");
ylabel("Above Error Signed");

figure;
% Below Error
beer = belowfinal - belowestm;
plot(x, beer, "o", "Color","blue");
axis([0 220 -40 40]);
xlabel("Trial Number");
ylabel("Below Error Signed");

% Compress aber to compare error with the previous one.
counter = 1;
next = 1;
aberdirection = [0 0];
previous = 0;
while (counter <= 210) 
    if (aber(counter) ~= 0) 
        aberdirection(next) = aber(counter) - previous; 
        previous = aber(counter);
        next = next + 1;
    end 
    counter = counter + 1;
end
figure;
plot(aberdirection);
xlabel("Correction Number");
ylabel("Correction Signed");
title("Above Correction");

counter = 1;
next = 1;
beerdirrection = [0 0];
previous = 0;
while (counter <= 210) 
    if (beer(counter) ~= 0) 
        beerdirrection(next) = beer(counter) - previous; 
        previous = beer(counter);
        next = next + 1;
    end 
    counter = counter + 1;
end
figure;
plot(beerdirrection);
xlabel("Correction Number");
ylabel("Correction Signed");
title("Below Correction");

% Plot Them Together
totalerrordirection = [0 0];
counter = 1;
benext = 1;
abnext = 1;
while (counter <= 210)
    if (beer(counter) ~= 0) 
        totalerrordirection(counter) = beerdirrection(benext); 
        benext = benext + 1;
    end
    if (aber(counter) ~= 0) 
        totalerrordirection(counter) = aberdirection(abnext); 
        abnext = abnext + 1;
    end
    counter = counter + 1;
end 
figure;
plot(totalerrordirection);
xlabel("Correction Number");
ylabel("Correction Signed");
title("Above and Below Together Correction");
axis([0 220 -60 60]);
