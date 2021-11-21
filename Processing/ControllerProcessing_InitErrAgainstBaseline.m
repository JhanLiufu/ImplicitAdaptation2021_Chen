%% This code is for controller processing, plot initial deviation against baseline bias
%% To be placed in the \DATA file to access both FPSC and OnlineCursor folders
% Written by Mengzhan Liufu at UChicago.
xCenter = 960;
yCenter = 540;

%FPSC_subject_list_num = [3 4 5 6 7 11 13 14 16 17 23];
% Exclude Subject 7 due to its unusually large initial deviation
FPSC_subject_list_num = [3 4 5 6 11 13 14 16 17 23];
FPSC_subject_list_size = size(FPSC_subject_list_num);
FPSC_subject_list_letter = char(FPSC_subject_list_num+'A'-1);
FPSC_subject_list_length = FPSC_subject_list_size(2);

Cursor_subject_list_num = [1 2 3 4];
Cursor_subject_list_size = size(Cursor_subject_list_num);
Cursor_subject_list_letter = char(Cursor_subject_list_num+'A'-1);
Cursor_subject_list_length = Cursor_subject_list_size(2);

% Absolute Error

% FPSC_baseline_absbias = zeros(1,FPSC_subject_list_length);
% FPSC_baseline_signedbias = zeros(1,FPSC_subject_list_length);
% Cursor_baseline_absbias = zeros(1,Cursor_subject_list_length);
% Cursor_baseline_signedbias = zeros(1,Cursor_subject_list_length);

Up_FPSC_baseline_absbias = zeros(1,FPSC_subject_list_length);
Down_FPSC_baseline_absbias = zeros(1,FPSC_subject_list_length);
Up_FPSC_initial_absdeviation = zeros(1,FPSC_subject_list_length);
Down_FPSC_initial_absdeviation = zeros(1,FPSC_subject_list_length);
Up_Cursor_initial_absdeviation = zeros(1,Cursor_subject_list_length);
Down_Cursor_initial_absdeviation = zeros(1,Cursor_subject_list_length);
Up_Cursor_baseline_absbias = zeros(1,Cursor_subject_list_length);
Down_Cursor_baseline_absbias = zeros(1,Cursor_subject_list_length);

% Signed Error

% FPSC_initial_absdeviation = zeros(1,FPSC_subject_list_length);
% FPSC_initial_signeddeviation = zeros(1,FPSC_subject_list_length);
% Cursor_initial_absdeviation = zeros(1,Cursor_subject_list_length);
% Cursor_initial_signeddeviation = zeros(1,Cursor_subject_list_length);

Up_FPSC_baseline_signedbias = zeros(1,FPSC_subject_list_length);
Down_FPSC_baseline_signedbias = zeros(1,FPSC_subject_list_length);
Up_FPSC_initial_signeddeviation = zeros(1,FPSC_subject_list_length);
Down_FPSC_initial_signeddeviation = zeros(1,FPSC_subject_list_length);
Up_Cursor_initial_signeddeviation = zeros(1,Cursor_subject_list_length);
Down_Cursor_initial_signeddeviation = zeros(1,Cursor_subject_list_length);
Up_Cursor_baseline_signedbias = zeros(1,Cursor_subject_list_length);
Down_Cursor_baseline_signedbias = zeros(1,Cursor_subject_list_length);

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
    Up_baseline_sum_abserr = 0;
    Down_baseline_sum_abserr = 0;
    Up_baseline_sum_signederr = 0;
    Down_baseline_sum_signederr = 0;

    Up_counter = 0;
    Down_counter = 0;
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
        
        if n < 10
            Up_baseline_sum_abserr = Up_baseline_sum_abserr + abserr;
            Up_baseline_sum_signederr = Up_baseline_sum_signederr + signederr;
            Up_counter = Up_counter + 1;
        else
            Down_baseline_sum_abserr = Down_baseline_sum_abserr + abserr;
            Down_baseline_sum_signederr = Down_baseline_sum_signederr + signederr;
            Down_counter = Down_counter + 1;
        end
    end
    Up_FPSC_baseline_absbias(1,p) = Up_baseline_sum_abserr/Up_counter;
    Down_FPSC_baseline_absbias(1,p) = Down_baseline_sum_abserr/Down_counter;
    Up_FPSC_baseline_signedbias(1,p) = Up_baseline_sum_signederr/Up_counter;
    Down_FPSC_baseline_signedbias(1,p) = Down_baseline_sum_signederr/Down_counter;
    
    cd(currentfolder)
    cd('Block4')
    target_reversal = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    Up_reversal_sum_abserr = 0;
    Down_reversal_sum_abserr = 0;
    Up_reversal_sum_signederr = 0;
    Down_reversal_sum_signederr = 0;

    Up_counter = 0;
    Down_counter = 0;
    for j = 1:30
        n = target_reversal(j);
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
    
        baseline_sum_abserr = 0;
        baseline_sum_signederr = 0;
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
        
        if n < 10
            Up_reversal_sum_abserr = Up_reversal_sum_abserr + abserr;
            Up_reversal_sum_signederr = Up_reversal_sum_signederr + signederr;
            Up_counter = Up_counter + 1;
        else
            Down_reversal_sum_abserr = Down_reversal_sum_abserr + abserr;
            Down_reversal_sum_signederr = Down_reversal_sum_signederr + signederr;
            Down_counter = Down_counter + 1;
        end
    end
    Up_FPSC_initial_absdeviation(1,p) = Up_reversal_sum_abserr/Up_counter;
    Down_FPSC_initial_absdeviation(1,p) = Down_reversal_sum_abserr/Down_counter;
    Up_FPSC_initial_signeddeviation(1,p) = Up_reversal_sum_signederr/Up_counter;
    Down_FPSC_initial_signeddeviation(1,p) = Down_reversal_sum_signederr/Down_counter;

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
    Up_baseline_sum_abserr = 0;
    Down_baseline_sum_abserr = 0;
    Up_baseline_sum_signederr = 0;
    Down_baseline_sum_signederr = 0;

    Up_counter = 0;
    Down_counter = 0;
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

        if n < 10
            Up_baseline_sum_abserr = Up_baseline_sum_abserr + abserr;
            Up_baseline_sum_signederr = Up_baseline_sum_signederr + signederr;
            Up_counter = Up_counter + 1;
        else
            Down_baseline_sum_abserr = Down_baseline_sum_abserr + abserr;
            Down_baseline_sum_signederr = Down_baseline_sum_signederr + signederr;
            Down_counter = Down_counter + 1;
        end
    end
    Up_Cursor_baseline_absbias(1,p) = Up_baseline_sum_abserr/Up_counter;
    Down_Cursor_baseline_absbias(1,p) = Down_baseline_sum_abserr/Down_counter;
    Up_Cursor_baseline_signedbias(1,p) = Up_baseline_sum_signederr/Up_counter;
    Down_Cursor_baseline_signedbias(1,p) = Down_baseline_sum_signederr/Down_counter;

    cd(currentfolder)
    cd('Block4')
    target_reversal = cell2mat(struct2cell(load('Trial1.mat','targetarray')));

    Up_reversal_sum_abserr = 0;
    Down_reversal_sum_abserr = 0;
    Up_reversal_sum_signedeerr = 0;
    Down_reversal_sum_signedeerr = 0;

    Up_counter = 0;
    Down_counter = 0;
    for i = 1:30
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        finaly = trajectory(final,3) - yCenter;
   
        n = target_reversal(i);
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

        if n < 10
            Up_reversal_sum_abserr = Up_reversal_sum_abserr + abserr;
            Up_reversal_sum_signederr = Up_reversal_sum_signedeerr + signederr;
            Up_counter = Up_counter + 1;
        else
            Down_reversal_sum_abserr = Down_reversal_sum_abserr + abserr;
            Down_reversal_sum_signederr = Down_reversal_sum_signederr + signederr;
            Down_counter = Down_counter + 1;
        end
    end
    Up_Cursor_initial_absdeviation(1,p) = Up_reversal_sum_abserr/Up_counter;
    Up_Cursor_initial_signeddeviation(1,p) = Up_reversal_sum_signederr/Up_counter;
    Down_Cursor_initial_absdeviation(1,p) = Down_reversal_sum_abserr/Down_counter;
    Down_Cursor_initial_signeddeviation(1,p) = Down_reversal_sum_signederr/Down_counter;

    cd(currentdataset)
end

cd(root_dir)

% Plot (absolute) baseline_absbias against initial_absdeviation
figure;
hold on;
Up_FPSC_abs = scatter(Up_FPSC_baseline_absbias,Up_FPSC_initial_absdeviation,'r','filled','^');
set(Up_FPSC_abs,{'DisplayName'},{'Up&Endpoint'})
Down_FPSC_abs = scatter(Down_FPSC_baseline_absbias,Down_FPSC_initial_absdeviation,'r','^');
set(Down_FPSC_abs,{'DisplayName'},{'Down&Endpoint'})
Up_Cursor_abs = scatter(Up_Cursor_baseline_absbias,Up_Cursor_initial_absdeviation,'b','filled','v');
set(Up_Cursor_abs,{'DisplayName'},{'Up&Cursor'})
Down_Cursor_abs = scatter(Down_Cursor_baseline_absbias,Down_Cursor_initial_absdeviation,'b','v');
set(Down_Cursor_abs,{'DisplayName'},{'Down&Cursor'})
legend;
xlabel('Absolute Baseline Bias (Degree)');
ylabel('Absolute Average Initial Deviation (Degree)');
grid on;

% Plot (relative) baseline_signedbias against initial_signeddeviation
figure;
hold on;
Up_FPSC_signed = scatter(Up_FPSC_baseline_signedbias,Up_FPSC_initial_signeddeviation,'r','filled','^');
set(Up_FPSC_signed,{'DisplayName'},{'Up&Endpoint'})
Down_FPSC_signed = scatter(Down_FPSC_baseline_signedbias,Down_FPSC_initial_signeddeviation,'r','^');
set(Down_FPSC_signed,{'DisplayName'},{'Down&Endpoint'})
Up_Cursor_signed = scatter(Up_Cursor_baseline_signedbias,Up_Cursor_initial_signeddeviation,'b','filled','v');
set(Up_Cursor_signed,{'DisplayName'},{'Up&Cursor'})
Down_Cursor_signed = scatter(Down_Cursor_baseline_signedbias,Down_Cursor_initial_signeddeviation,'b','v');
set(Down_Cursor_signed,{'DisplayName'},{'Down&Cursor'})
legend;
xlabel('Signed Baseline Bias (Degree)');
ylabel('Signed Average Initial Deviation (Degree)');
grid on;

