%% This code is for collective data processing & presentation.
% By Charles Xu @ UCSD, adopted from "Controller data processing" by Hokin
% Deng at JHU

clear
close all

xCenter = 960;
yCenter = 540;
finaldata = [0 0];
targetdata = [0 0];
abovefinal = zeros(210, 1);
abovetarget = zeros(210, 1);
belowfinal = zeros(210, 1);
belowtarget = zeros(210, 1);

filePath = matlab.desktop.editor.getActiveFilename;
path = erase(filePath,'BUMProcessor.m');
workingdirectory = path;

%% Plot Relative Errors of All 3 Experiments & Overlapping Trajectories

f1 = figure('Name','All3Experiments','NumberTitle','off');
hold on;
x = linspace(1,210,210);

f2 = figure('Name','AllTrajectory','NumberTitle','off');
hold on;

for i = 1:3
    cd(workingdirectory);
    currentexp = strcat('Experiment', num2str(i));
    cd(currentexp);
    
    for j = 1:8
        currentsubj = num2str(j);
        cd(currentsubj);

        for k = 1:3
            currentblock = strcat('Block',num2str(k));
            cd(currentblock);
            target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
            
            for l = 1:30
                figure(f2)
                
                currenttrial = strcat('Trial',num2str(l),'.mat');
                trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
                trajsize = size(trajectory);
                final = trajsize(1);
                finalx = trajectory(final,2) - xCenter;
                finaly = trajectory(final,3) - yCenter;
                plot(trajectory(:,3),trajectory(:,2));

                n = target(l);
                
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
                finaldata((k-1)*30+l) = atand(finaly/finalx);
                targetdata((k-1)*30+l) = atand(targety/targetx);
                
                if (finalx > 0)
                    abovefinal((k-1)*30+l) = atand(finaly/finalx);
                end
                
                if (targetx > 0)
                    abovetarget((k-1)*30+l) = atand(targety/targetx);
                end
                
                if (finalx < 0)
                    belowfinal((k-1)*30+l) = atand(finaly/finalx);
                end
                
                if (targetx < 0)
                    belowtarget((k-1)*30+l) = atand(targety/targetx);
                end
            end
            cd ..;
        end

        for k = 4:7
            currentblock = strcat('Block',num2str(k));
            cd(currentblock);
            target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
            
            for l = 1:30
                currenttrial = strcat('Trial',num2str(l),'.mat');
                trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
                trajsize = size(trajectory);
                final = trajsize(1);
                finalx = trajectory(final,2) - xCenter;
                finaly = trajectory(final,3) - yCenter;
                plot(trajectory(:,3),trajectory(:,2));

                n = target(l);
                
                if n < 10
                    targetx = xCenter+546.5*cosd(abs(n*3-15));
                    targety = yCenter+546.5*sind(n*3-15);
                else
                    targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
                    targety = yCenter+546.5*sind((n-9)*3-15);
                end
                
                plot(targety,targetx,"o");
                targetx = targetx - xCenter;
                
                if i == 1
                    targety = -(targety - yCenter);
                else
                    targety = targety - yCenter;
                end
                
                finaldata((k-1)*30+l) = atand(finaly/finalx);
                targetdata((k-1)*30+l) = atand(targety/targetx);
                
                if (finalx > 0)
                    abovefinal((k-1)*30+l) = atand(finaly/finalx);
                end 
                
                if (targetx > 0)
                    abovetarget((k-1)*30+l) = atand(targety/targetx);
                end 
                
                if (finalx < 0)
                    belowfinal((k-1)*30+l) = atand(finaly/finalx);
                end
                
                if (targetx < 0)
                    belowtarget((k-1)*30+l) = atand(targety/targetx);
                end 
            end
            cd ..;
        end
        
        % Plot relative errors of all three experiments
        figure(f1);
        hold on;

        relError = finaldata - targetdata;
        
        if i == 1
            plot(x,relError,'-o','Color','red');
        elseif i == 2
            plot(x,relError,'-o','Color','green');
        else
            plot(x,relError,'-o','Color','blue');
        end
        cd ..;
        
    end
    cd ..;
    
end

cd(workingdirectory);

axis equal;


%% Absolute Plot of Position
x = linspace(1,210,210);
figure;
plot(x, finaldata,"o", x, targetdata, "x");
axis([0 210 -30 30]);
xlabel("Trial Number");
ylabel("Abs Degree");

figure;
plot(x, finaldata, "-*", "Color","green");
hold on;
plot(x, targetdata, "-o", "Color","blue");
axis([0 210 -30 30]);
xlabel("Trial Number");
ylabel("Abs Degree");

%% Plotting Error (anti-clock wise would be positive)
error = [0 0];
for k = 1:210
error(k) = finaldata(k) - targetdata(k);
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
for k = 1:210
    abserr(k) = abs(error(k));
end 

figure;
plot(x, abserr, "-o", "Color","blue");
xlabel("Trial Number");
ylabel("Absolute error");
axis([0 220 0 50]);

%% Plot Above/Below Data
figure;
plot(x, abovefinal, "*", x, abovetarget, "o", "Color","red");
axis([0 220 -40 40]);
hold on;
plot(x, belowfinal, "*", x, belowtarget, "o", "Color","blue");
xlabel("Trial Number");
ylabel("Above in red, below in blue");
% Dimensional shift
figure;
aboveshift = zeros(210, 1);
belowshit = zeros(210, 1);
aboveshift = abovefinal + 90;
belowshit = belowfinal - 90;
plot(x, aboveshift, "*", x, abovetarget + 90, "o", "Color","red");
hold on;
plot(x, belowshit, "*", x, belowtarget - 90, "o", "Color","blue");
axis([0 220 -200 200]);
xlabel("Trial Number");
ylabel("Shift for seperation");
% Seperate Above and Below
figure;
plot(x, abovefinal, "*", x, abovetarget, "o", "Color","red");
axis([0 220 -40 40]);
xlabel("Trial Number");
ylabel("Above");
figure; 
plot(x, belowfinal, "*", x, belowtarget, "o", "Color","blue");
axis([0 220 -40 40]);
xlabel("Trial Number");
ylabel("Below");

%% Calculate Above/Below Error
figure;
aboveerrorabs = abs(abovefinal - abovetarget);
plot(x, aboveerrorabs, "-o", "Color","red");
axis([0 220 0 40]);
xlabel("Trial Number");
ylabel("Above Error Absolute");

figure;
% Below Error
belowerrorabs = abs(belowfinal - belowtarget);
plot(x, belowerrorabs, "-o", "Color","green");
axis([0 220 0 40]);
xlabel("Trial Number");
ylabel("Below Error Absolute");

%% Learning direction considering Above/Below Seperately
figure;
aber = abovefinal - abovetarget;
plot(x, aber, "*", "Color","red");
axis([0 220 -40 40]);
xlabel("Trial Number");
ylabel("Above Error Signed");

figure;
% Below Error
beer = belowfinal - belowtarget;
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

%% Section Specific Analysis
blockfinaldata = zeros(7,30);
blocktargetdata = zeros(7,30);
blockabovefinal = zeros(7,30);
blockbelowfinal = zeros(7,30);
blockabovetarget = zeros(7,30);
blockbelowtarget = zeros(7,30);
blockerroers = zeros(7,30);
abblockerrors = zeros(7,30);
beblockerrors = zeros(7,30);

for k = 1:3
    currentblock = strcat('Block',num2str(k));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    figure; 
    hold on;
    title(currentblock);
    for l = 1:30
        currenttrial = strcat('Trial',num2str(l),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly =  trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        n = target(l);
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
        blockfinaldata(k,l) = atand(finaly/finalx);
        blocktargetdata(k,l) = atand(targety/targetx);
        if (finalx > 0)
            blockabovefinal(k,l) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            blockabovetarget(k,l) = atand(targety/targetx);
        end 
        if (finalx < 0)
            blockbelowfinal(k,l) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            blockbelowtarget(k,l) = atand(targety/targetx);
        end 
    end
    axis equal;
    cd(workingdirectory);
end

for k = 4:7
    currentblock = strcat('Block',num2str(k));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    figure; 
    hold on;
    title(currentblock);
    for l = 1:30
        currenttrial = strcat('Trial',num2str(l),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
        plot(trajectory(:,3),trajectory(:,2));
        
        n = target(l);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        plot(targety,targetx,"o");
        targetx = targetx - xCenter;
        targety = -(targety - yCenter);
        % edit later
%         if i == 1
%             targety = -(targety - yCenter);
%         else
%             targety = targety - yCenter;
%         end
        %
        blockfinaldata(k,l) = atand(finaly/finalx);
        blocktargetdata(k,l) = atand(targety/targetx);
        if (finalx > 0)
            blockabovefinal(k,l) = atand(finaly/finalx);
        end 
        if (targetx > 0)
            blockabovetarget(k,l) = atand(targety/targetx);
        end 
        if (finalx < 0)
            blockbelowfinal(k,l) = atand(finaly/finalx);
        end 
        if (targetx < 0)
            blockbelowtarget(k,l) = atand(targety/targetx);
        end 
    end
    axis equal;
    cd(workingdirectory);
end

figure;
hold on;
for k = 1:3
    x = linspace(1,30,30);
    plot(x, blockfinaldata(k,:));   
    plot(x, blocktargetdata(k,:), ':', 'LineWidth', 9);
end 
figure;
hold on;
for k = 4:7
    x = linspace(1,30,30);
    plot(x, blockfinaldata(k,:));   
    plot(x, blocktargetdata(k,:), ':', 'LineWidth', 9);
end 

