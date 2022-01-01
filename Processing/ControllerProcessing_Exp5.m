%% This code is for Experiment 5 controller data processing.
%% Four symmetric targets pseudorandom presentation, mirror reversal perturbation
% By Mengzhan Liufu, January 2022 at UChicago

clearvars;
xCenter = 960;
yCenter = 540;
abserr = zeros(240,1);
targeterr = zeros(4,1);

for i = 1:3
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetmatrix')));
    for j = 1:40
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = yCenter - trajectory(final,3);
        
        n = target(j);
        if n <= 5
            x1 = xCenter + 546.5*cosd(abs(7.5*(n-1)-15));
            y1 = yCenter + 546.5*sind(7.5*(n-1)-15);
        else
            x1 = xCenter - 546.5*cosd(abs(7.5*(n-6)-15));
            y1 = yCenter + 546.5*sind(7.5*(n-6)-15);
        end
        targetx = targetx - xCenter;
        targety = yCenter - targety;
        
        error = abs(abs(atand(finaly/finalx) - atand(targety/targetx)));
        if error > 180
            error = 360 - error;
        end
        abserr((i-1)*40+j) = error;

        target_num;
        switch n
            case 1
                target_num = 1;
            case 5
                target_num = 2;
            case 6
                target_num = 3;
            otherwise
                target_num = 4;
        end
        targeterr(target_num,end+1)=error;

    end
    cd(currentfolder);
end

for i = 4:6
    currentfolder = pwd;
    currentblock = strcat('Block',num2str(i));
    cd(currentblock);
    target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    for j = 1:40
        currenttrial = strcat('Trial',num2str(j),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = yCenter - trajectory(final,3);
        
        n = target(j);
        if n <= 5
            x1 = xCenter + 546.5*cosd(abs(7.5*(n-1)-15));
            y1 = yCenter + 546.5*sind(7.5*(n-1)-15);
        else
            x1 = xCenter - 546.5*cosd(abs(7.5*(n-6)-15));
            y1 = yCenter + 546.5*sind(7.5*(n-6)-15);
        end
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        
        error = abs(abs(atand(finaly/finalx) - atand(targety/targetx)));
        if error < 180
            abserr((i-1)*40+j) = error;
        else
            abserr((i-1)*30+j) = 360 - error;
        end
    end
    cd(currentfolder);
end

figure(1);
hold on;
title('Absolute Error at each trial')
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

figure(2);
hold on;
title('Average error in 5-trial bins')
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

figure(3);
hold on;
title('Variation of Absolute Error in 10-trial bins')
plot(vararray,'-','linewidth',2);
set(gca,'FontSize',15);
xlabel('Trial Chunk');
ylabel('Variance');
grid on;

for i=1:4
    figure(i+3);
    hold on;
    title('Absolute Error for target '+num2str(i));
    plot(targeterr(i,:));
    xlabel("Target Trial Number");
    ylabel("Absolute Error");
    grid on;
end