%% This code is for controller processing, plot Cursor/Endpoint feedback abs errors
%% To be placed in the DATA file to access both FPSC and OnlineCursor folders
% Written by Mengzhan Liufu at UChicago. 
xCenter = 960;
yCenter = 540;
finaldata = [0 0];
targetdata = [0 0];

% Calculate All Subjects Avg Abs Err for Endpoint Feedback grouop
FPSC_subject_list_num = [3 4 5 6 7 11 13 14 16 17 23];
FPSC_subject_list_size = size(FPSC_subject_list_num);
FPSC_subject_list_letter = char(FPSC_subject_list_num+'A'-1);
FPSC_subject_list_length = FPSC_subject_list_size(2);
FPSC_allsubject_abserr = zeros(FPSC_subject_list_length,210);
FPSC_avgsubject_abserr = zeros(1,210);

% Calculate All Subjects Avg Abs Err for Cursor Feedback grouop
Cursor_subject_list_num = [1 2 3];
Cursor_subject_list_size = size(Cursor_subject_list_num);
Cursor_subject_list_letter = char(Cursor_subject_list_num+'A'-1);
Cursor_subject_list_length = Cursor_subject_list_size(2);
Cursor_allsubject_abserr = zeros(Cursor_subject_list_length,210);
Cursor_avgsubject_abserr = zeros(1,210);

%the DATA folder directory
root_dir = pwd;

% Log FPSC group data, calculate abserr across trials
cd('FPSC');
currentdataset = pwd;
for p = 1:11
    cd(FPSC_subject_list_letter(p));
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
            FPSC_allsubject_abserr(p,(i-1)*30+j) = abserr;
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
            FPSC_allsubject_abserr(p,(i-1)*30+j) = abserr;
        end
        cd(currentfolder);
    end
    cd(currentdataset);
end

for m = 1:210 
    FPSC_avgsubject_abserr(1,m) = sum(FPSC_allsubject_abserr(:,m))/FPSC_subject_list_length;
end

cd(root_dir);
cd('Controller_OnlineCursor');

% Log Cursor group data, calculate abserr across trials
currentdataset = pwd;
for p = 1:3
    cd(Cursor_subject_list_letter(p));
    %cd("Controller");
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
            Cursor_allsubject_abserr(p,(i-1)*30+j) = abserr;
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
            Cursor_allsubject_abserr(p,(i-1)*30+j) = abserr;
        end
        cd(currentfolder);
    end
    cd(currentdataset);
end

cd(root_dir);

for m = 1:210 
    Cursor_avgsubject_abserr(1,m) = sum(Cursor_allsubject_abserr(:,m))/Cursor_subject_list_length;
end

% Plot absolute error
figure;
hold on;
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times');
xlabel('Trial Number')
ylabel('Absolute Error (Degree)')
title('Absolute Reach Error on each Trial')
plot(FPSC_avgsubject_abserr,'ok-','linewidth',1.1,'markerfacecolor',[254, 67, 101]/255);
plot(Cursor_avgsubject_abserr,'ok-','linewidth',1.1,'markerfacecolor',[38, 188, 213]/255);
% ar = area(0:25,61:90);
% ar.FaceColor = [200,200,169]/255;
% ar.FaceAlpha = 0.5;
legend('Endpoint','Cursor')
grid on;
axis([0 210 0 25])

% ANOVA analysis for Cursor reversal blocks and Endpoint reversal blocks
Reversal_avgsubject_abserr = zeros(1,180);
for k = 91:210
    Reversal_avgsubject_abserr(k-90) = FPSC_avgsubject_abserr(k);
    Reversal_avgsubject_abserr(k+30) = Cursor_avgsubject_abserr(k);
end

Reversal_group = cell(1,240);
for m = 1:120
    Reversal_group{1,m} = 'Endpoint Feedback Reversal';
end

for m = 121:240
    Reversal_group{1,m} = 'Cursor Feedback Reversal';
end

[p,tbl,stats] = anova1(Reversal_avgsubject_abserr,Reversal_group);