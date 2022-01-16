%% This code is for Controller data processing.
% Updated Version by Hokin Deng, at John Hopkins. 
xCenter = 960;
yCenter = 540;
finaldata = [0 0];
targetdata = [0 0];
abovefinal = zeros(240, 1);
abovetarget = zeros(240, 1);
belowfinal = zeros(240, 1);
belowtarget = zeros(240, 1);


%% Plot Overlapping Trajectories
figure;
hold on;
for i = 1:3
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        
        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        plot(targety,targetx,"o");
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        finaldata((i-1)*30+j) = atand(finaly/finalx);
        targetdata((i-1)*30+j) = atand(targety/targetx);
        if (finalx > 0)
            abovefinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            abovetarget((i-1)*30+j) = atand(targety/targetx);
        end 
        if (finalx < 0)
            belowfinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            belowtarget((i-1)*30+j) = atand(targety/targetx);
        end 
    end
    cd(currentfolder);
end

for i = 4:7
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        
        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        plot(targety,targetx,"o");
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        finaldata((i-1)*30+j) = atand(finaly/finalx);
        targetdata((i-1)*30+j) = atand(targety/targetx);
        if (finalx > 0)
            abovefinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            abovetarget((i-1)*30+j) = atand(targety/targetx);
        end 
        if (finalx < 0)
            belowfinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            belowtarget((i-1)*30+j) = atand(targety/targetx);
        end 
    end
    cd(currentfolder);
end

for i = 8
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        
        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        plot(targety,targetx,"o");
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        finaldata((i-1)*30+j) = atand(finaly/finalx);
        targetdata((i-1)*30+j) = atand(targety/targetx);
        if (finalx > 0)
            abovefinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            abovetarget((i-1)*30+j) = atand(targety/targetx);
        end 
        if (finalx < 0)
            belowfinal((i-1)*30+j) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            belowtarget((i-1)*30+j) = atand(targety/targetx);
        end 
    end
    cd(currentfolder);
end

axis equal;


%% Absolute Plot of Position
x = linspace(0,240,240);
figure;
plot(x, finaldata,"o", x, targetdata, "x");
axis([0 240 -30 30]);
xlabel("Trial Number");
ylabel("Abs Degree");

figure;
plot(x, finaldata, "-*", "Color","green");
hold on;
plot(x, targetdata, "-o", "Color","blue");
axis([0 240 -30 30]);
xlabel("Trial Number");
ylabel("Abs Degree");

%% Plotting Error (anti-clock wise would be positive)
error = [0 0];
for i = 1:240
error(i) = finaldata(i) - targetdata(i);
end

figure;
plot(x, error, "*", "Color","red");
xlabel("Trial Number");
ylabel("directional error: anti-clockwise would be positive");

%% Plot Abs Error
abserr= [0 0];
% for i = 1:210
%     if error(i) < 180
%             abserr(i) = abs(abs(error(i)));
%         else
%             abserr(i) = 360 - abs(abs(error(i)));
%     end
% end
for i = 1:240
    abserr(i) = abs(error(i));
end 

figure;
plot(x, abserr, "-o", "Color","blue");
xlabel("Trial Number");
ylabel("Absolute error");
axis([0 250 0 50]);

%% Plot Above/Below Data
figure;
axis([0 250 -40 40]);
plot(x, abovefinal, "*", x, abovetarget, "o", "Color","red");
hold on;
plot(x, belowfinal, "*", x, belowtarget, "o", "Color","blue");
xlabel("Trial Number");
ylabel("Above in red, below in blue");
% Dimensional shift
figure;
aboveshift = zeros(240, 1);
belowshit = zeros(240, 1);
aboveshift = abovefinal + 90;
belowshit = belowfinal - 90;
plot(x, aboveshift, "*", x, abovetarget + 90, "o", "Color","red");
hold on;
plot(x, belowshit, "*", x, belowtarget - 90, "o", "Color","blue");
axis([0 250 -200 200]);
xlabel("Trial Number");
ylabel("Shift for seperation");
% Seperate Above and Below
figure;
plot(x, abovefinal, "*", x, abovetarget, "o", "Color","red");
axis([0 250 -40 40]);
xlabel("Trial Number");
ylabel("Above");
figure; 
plot(x, belowfinal, "*", x, belowtarget, "o", "Color","blue");
axis([0 250 -40 40]);
xlabel("Trial Number");
ylabel("Below");

%% Calculate Above/Below Error
figure;
aboveerrorabs = abs(abovefinal - abovetarget);
plot(x, aboveerrorabs, "-o", "Color","red");
axis([0 250 0 40]);
xlabel("Trial Number");
ylabel("Above Error Absolute");

figure;
% Below Error
belowerrorabs = abs(belowfinal - belowtarget);
plot(x, belowerrorabs, "-o", "Color","green");
axis([0 250 0 40]);
xlabel("Trial Number");
ylabel("Below Error Absolute");

%% Learning direction considering Above/Below Seperately
figure;
aber = abovefinal - abovetarget;
plot(x, aber, "*", "Color","red");
axis([0 250 -40 40]);
xlabel("Trial Number");
ylabel("Above Error Signed");

figure;
% Below Error
beer = belowfinal - belowtarget;
plot(x, beer, "o", "Color","blue");
axis([0 250 -40 40]);
xlabel("Trial Number");
ylabel("Below Error Signed");

% Compress aber to compare error with the previous one.
counter = 1;
next = 1;
aberdirection = [0 0];
previous = 0;
while (counter <= 240) 
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
while (counter <= 240) 
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
while (counter <= 240)
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
axis([0 250 -60 60]);
%% Section Specific Analysis
blockfinaldata = zeros(8,30);
blocktargetdata = zeros(8,30);
blockabovefinal = zeros(8,30);
blockbelowfinal = zeros(8,30);
blockabovetarget = zeros(8,30);
blockbelowtarget = zeros(8,30);
blockerroers = zeros(8,30);
abblockerrors = zeros(8,30);
beblockerrors = zeros(8,30);

for i = 1:3
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    figure; 
    hold on;
    title(currentblock);
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly =  trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        plot(targety,targetx,"o");
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        blockfinaldata(i,j) = atand(finaly/finalx);
        blocktargetdata(i,j) = atand(targety/targetx);
        if (finalx > 0)
            blockabovefinal(i,j) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            blockabovetarget(i,j) = atand(targety/targetx);
        end 
        if (finalx < 0)
            blockbelowfinal(i,j) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            blockbelowtarget(i,j) = atand(targety/targetx);
        end 
    end
    axis equal;
    cd(currentfolder);
end

for i = 4:7
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    figure; 
    hold on;
    title(currentblock);
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly =  trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        plot(targety,targetx,"o");
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        blockfinaldata(i,j) = atand(finaly/finalx);
        blocktargetdata(i,j) = atand(targety/targetx);
        if (finalx > 0)
            blockabovefinal(i,j) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            blockabovetarget(i,j) = atand(targety/targetx);
        end 
        if (finalx < 0)
            blockbelowfinal(i,j) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            blockbelowtarget(i,j) = atand(targety/targetx);
        end 
    end
    axis equal;
    cd(currentfolder);
end

for i = 8
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    figure; 
    hold on;
    title(currentblock);
    for j = 1:30
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly =  trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        plot(targety,targetx,"o");
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        blockfinaldata(i,j) = atand(finaly/finalx);
        blocktargetdata(i,j) = atand(targety/targetx);
        if (finalx > 0)
            blockabovefinal(i,j) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            blockabovetarget(i,j) = atand(targety/targetx);
        end 
        if (finalx < 0)
            blockbelowfinal(i,j) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            blockbelowtarget(i,j) = atand(targety/targetx);
        end 
    end
    axis equal;
    cd(currentfolder);
end

figure;
hold on;
for i = 1:3
    x = linspace(0,30,30);
    plot(x, blockfinaldata(i,:));   
    plot(x, blocktargetdata(i,:), ':', 'LineWidth', 9);
end 
figure;
hold on;
for i = 4:8
    x = linspace(0,30,30);
    plot(x, blockfinaldata(i,:));   
    plot(x, blocktargetdata(i,:), ':', 'LineWidth', 9);
end 


