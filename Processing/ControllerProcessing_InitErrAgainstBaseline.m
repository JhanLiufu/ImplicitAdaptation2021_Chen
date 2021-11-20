%% This code is for controller processing, plot initial deviation against baseline bias
%% To be placed in the \DATA file to access both FPSC and OnlineCursor folders
% Written by Mengzhan Liufu at UChicago.
xCenter = 960;
yCenter = 540;

FPSC_subject_list_num = [3 4 5 6 7 11 13 14 16 17 23];
FPSC_subject_list_size = size(FPSC_subject_list_num);
FPSC_subject_list_letter = char(FPSC_subject_list_num+'A'-1);
FPSC_subject_list_length = FPSC_subject_list_size(2);

Cursor_subject_list_num = [1 2 3 4];
Cursor_subject_list_size = size(Cursor_subject_list_num);
Cursor_subject_list_letter = char(Cursor_subject_list_num+'A'-1);
Cursor_subject_list_length = Cursor_subject_list_size(2);

% Baseline bias - the average error in the No-Visual-Feedback block
baseline_absbias = zeros(1,FPSC_subject_list_length+Cursor_subject_list_length);
baseline_signedbias = zeros(1,FPSC_subject_list_length+Cursor_subject_list_length);
% Initial deviation - the average error in the first Mirror Reversal block
initial_absdeviation = zeros(1,FPSC_subject_list_length+Cursor_subject_list_length);
initial_signeddeviation = zeros(1,FPSC_subject_list_length+Cursor_subject_list_length);

%the DATA folder directory
root_dir = pwd;

cd('FPSC');
currentdataset = pwd;

for p = 1:FPSC_subject_list_length
    cd(FPSC_subject_list_letter(p));
    cd("Controller");
    currentfolder = pwd;

    cd('Block3')
    target_nvf = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    baseline_sum_abserr = 0;
    baseline_sum_signederr = 0;
    for i = 1:30
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
   
        n = target_nvf(i);
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
        signederr = atand(finaly/finalx)-atand(targety/targetx);

        baseline_sum_abserr = baseline_sum_abserr + abserr;
        baseline_sum_signederr = baseline_sum_signederr + signederr;
    end
    baseline_absbias(1,p) = baseline_sum_abserr/30;
    baseline_signedbias(1,p) = baseline_sum_signederr/30;
    
    cd(currentfolder)
    cd('Block4')
    target_reversal = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    reversal_sum_abserr = 0;
    reversal_sum_signederr = 0;
    for j = 1:30
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
    
        baseline_sum_abserr = 0;
        baseline_sum_signederr = 0;
        n = target_reversal(i);
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
        signederr = atand(finaly/finalx)-atand(targety/targetx);

        reversal_sum_abserr = reversal_sum_abserr + abserr;
        reversal_sum_signederr = reversal_sum_signederr + signederr;
    end
    initial_absdeviation(1:p) = reversal_sum_abserr/30;
    initial_signeddeviation(1:p) = reversal_sum_signederr/30;

    cd(currentdataset)
end

cd(root_dir)
cd('Controller_OnlineCursor')
currentdataset = pwd;

for p = 1:Cursor_subject_list_length
    cd(Cursor_subject_list_letter(p));
    currentfolder = pwd;

    cd('Block3')
    target_nvf = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    baseline_sum_abserr = 0;
    baseline_sum_signederr = 0;
    for i = 1:30
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
   
        n = target_nvf(i);
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
        signederr = atand(finaly/finalx)-atand(targety/targetx);
        baseline_sum_abserr = baseline_sum_abserr + abserr;
        baseline_sum_signederr = baseline_sum_signederr + signederr;
    end
    baseline_absbias(1,Cursor_subject_list_length+p) = baseline_sum_abserr/30;
    baseline_signedbias(1,Cursor_subject_list_length+p) = baseline_sum_signederr/30;

    cd(currentfolder)
    cd('Block4')
    target_reversal = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    reversal_sum_abserr = 0;
    reversal_sum_signedeerr = 0;
    for i = 1:30
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
   
        n = target_nvf(i);
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
        signederr = atand(finaly/finalx)-atand(targety/targetx);
        reversal_sum_abserr = reversal_sum_abserr + abserr;
        reversal_sum_signederr = reversal_sum_signederr + signederr;
    end
    initial_absdeviation(1,FPSC_subject_list_length+p) = reversal_sum_abserr/30;
    initial_signeddeviation(1,FPSC_subject_list_length+p) = reversal_sum_signederr/30;

    cd(currentdataset)
end

cd(root_dir)

% Plot (absolute) baseline_absbias against initial_absdeviation
figure;
hold on;
abs_baselinebias = scatter(baseline_absbias,initial_absdeviation,'r','filled','^');
xlabel('Absolute Baseline Bias (Degree)');
ylabel('Absolute Average Initial Deviation (Degree)');

% Plot (relative) baseline_signedbias against initial_signeddeviation
figure;
hold on;
signed_baselinebias = scatter(baseline_signedbias,initial_signeddeviation,'r','filled','v');
xlabel('Signed Baseline Bias (Degree)');
ylabel('Signed Average Initial Deviation (Degree)');