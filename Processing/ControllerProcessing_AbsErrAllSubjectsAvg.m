%% This code is for Controller data processing, changes of absolute error for each target.
%% To be placed in the FPSC or FCSP folder
% Written by Mengzhan Liufu at UChicago. 
xCenter = 960;
yCenter = 540;
finaldata = [0 0];
targetdata = [0 0];
subject_list_num = [3 4 5 6 7 11 13 14 16 17 23];
subject_list_size = size(subject_list_num);
subject_list_letter = char(subject_list_num+'A'-1);
subject_list_length = subject_list_size(2);
allsubject_abserr = zeros(subject_list_length,210);
avgsubject_abserr = zeros(1,210);

currentdataset = pwd;
for p = 1:11
    cd(subject_list_letter(p));
    cd("Controller");
    currentfolder = pwd;
    for i = 1:3
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
            allsubject_abserr(p,(i-1)*30+j) = abserr;
        end
        cd(currentfolder)
    end

    for i = 4:7
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
            allsubject_abserr(p,(i-1)*30+j) = abserr;
        end
        cd(currentfolder);
    end
    cd(currentdataset);
end

for m = 1:210 
    avgsubject_abserr(1,m) = sum(allsubject_abserr(:,m))/subject_list_length;
end

figure;
title("Across Subject Averaged Absolute Error")
plot(avgsubject_abserr);
axis([0 210 0 20])

figure;
title("Across Subject Absolute Error Scatter")
x = linspace(1,210,210);
scatter(x,avgsubject_abserr)
axis([0 210 0 20])
