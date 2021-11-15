%% This code is for Controller data processing, changes of absolute error for each target.
% Written by Mengzhan Liufu at UChicago. 
xCenter = 960;
yCenter = 540;
finaldata = [0 0];
targetdata = [0 0];
error_by_target = zeros(18, 1);

% figure;
% hold on;

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

        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        targetx = targetx - xCenter;
        targety = targety - yCenter;

        abserr = abs(atand(finaly/finalx)-atand(targety/targetx));
        error_by_target(n,end+1)=abserr;
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

        n = target(j);
        if n < 10
            targetx = xCenter+546.5*cosd(abs(n*3-15));
            targety = yCenter+546.5*sind(n*3-15);
        else
            targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
            targety = yCenter+546.5*sind((n-9)*3-15);
        end
        targetx = targetx - xCenter;
        targety = yCenter - targety;

        abserr = abs(atand(finaly/finalx)-atand(targety/targetx));
        error_by_target(n,end+1)=abserr;
    end
    cd(currentfolder);
end

%% Plot absolute errors for upper targets
for i = 1:9
    figure(i);
    hold on;
    plot(error_by_target(i,:));
    title(strcat("Target "+num2str(i)+" (Upper)"));
    xlabel("Target Trial Number");
    ylabel("Absolute Error");
    %axis([0 221 0 20])
end

%% Plot absolute errors for upper targets
for i = 10:18
    figure(i);
    hold on;
    plot(error_by_target(i,:));
    title(strcat("Target "+num2str(i)+" (Lower)"));
    xlabel("Target Trial Number");
    ylabel("Absolute Error");
    %axis([0 221 0 20])
end

%% Plot absolute errors for left-side targets
for i = 1:4
    figure(i);
    hold on;
    plot(error_by_target(i,:));
    title(strcat("Target "+num2str(i)+" (Left)"));
    xlabel("Target Trial Number");
    ylabel("Absolute Error");
    %axis([0 221 0 20])
end

for i = 10:14
    figure(i);
    hold on;
    plot(error_by_target(i,:));
    xlabel("Target Trial Number");
    ylabel("Absolute Error");
    %axis([0 221 0 20])
end

%% Plot absolute errors for right-side targets
for i = 6:9
    figure(i);
    hold on;
    plot(error_by_target(i,:));
    title(strcat("Target "+num2str(i)+" (Left)"));
    xlabel("Target Trial Number");
    ylabel("Absolute Error");
    %axis([0 221 0 20])
end

for i = 15:18
    figure(i);
    hold on;
    plot(error_by_target(i,:));
    xtitle(strcat("Target "+num2str(i)+" (Right)"));
    xlabel("Target Trial Number");
    ylabel("Absolute Error");
    %axis([0 221 0 20])
end