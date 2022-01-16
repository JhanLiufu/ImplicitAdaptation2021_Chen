%% This code is for controller data processing.
% By Mengzhan Liufu, August 2021 at ChenLab at South China Normal
% University, Guangzhou.

clearvars;
xCenter = 960;
yCenter = 540;
abserr = [0 0];

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
        finaly = yCenter - trajectory(final,3);
        
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
        
        error = abs(abs(atand(finaly/finalx) - atand(targety/targetx)));
        if error < 180
            abserr((i-1)*30+j) = error;
        else
            abserr((i-1)*30+j) = 360 - error;
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
        
        error = abs(abs(atand(finaly/finalx) - atand(targety/targetx)));
        if error < 180
            abserr((i-1)*30+j) = error;
        else
            abserr((i-1)*30+j) = 360 - error;
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
        finaly = yCenter - trajectory(final,3);
        
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
        
        error = abs(abs(atand(finaly/finalx) - atand(targety/targetx)));
        if error < 180
            abserr((i-1)*30+j) = error;
        else
            abserr((i-1)*30+j) = 360 - error;
        end
    end
    cd(currentfolder);
end

figure;
plot(abserr,'-','linewidth',2);
set(gca,'FontSize',15);
xlabel('Trial number');
ylabel('Absolute Error (Degree)');
grid on

avg = 0;
avgarray = [0 0];
counter = 0;
for i = 1:length(abserr)
    counter  = counter + 1;
    if counter < 5
        avg = avg + abserr(i);
    else
        avg = avg + abserr(i);
        avg = avg/5;
        avgarray(i/5) = avg;
        counter = 0;
        avg = 0;
    end
end

figure;
plot(avgarray,'-','linewidth',2);
set(gca,'FontSize',15);
xlabel('Trial Chunk');
ylabel('Average Absolute Error (Degree)');
grid on

vararray = [0 0];
varinput = [0 0];
counter = 0;
for i = 1:length(abserr)
    counter = counter + 1;
    if counter < 10
        varinput(counter) = abserr(i);
    else
        varinput(counter) = abserr(i);
        vararray(i/10) = var(varinput);
        counter = 0;
    end
end

figure;
plot(vararray,'-','linewidth',2);
set(gca,'FontSize',15);
xlabel('Trial Chunk');
ylabel('Variance');
grid on;