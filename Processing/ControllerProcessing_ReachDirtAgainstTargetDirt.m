%% This code is for controller data processing, plot reach direction relative to axis against target
%% target direction relative to axis during late learning for all participants
%% To be placed in \DATA folder
% Written by Mengzhan Liufu at UChicago

xCenter = 960;
yCenter = 540;

FPSC_subject_list_num = [3 4 5 6 7 11 13 14 16 17 23];
FPSC_subject_list_size = size(FPSC_subject_list_num);
FPSC_subject_list_letter = char(FPSC_subject_list_num+'A'-1);
FPSC_subject_list_length = FPSC_subject_list_size(2);
FPSC_colormap = [[22,114,182]/255;[216,84,38]/255;[117,171,66]/255;[127,46,138]/255;[162,29,49]/255;[234,177,32]/255;[182,194,154]/255;[222,156,83]/255;[201,186,131]/255;[117,36,35]/255;[224,160,158]/255];

Cursor_subject_list_num = [1 2 3 4];
Cursor_subject_list_size = size(Cursor_subject_list_num);
Cursor_subject_list_letter = char(Cursor_subject_list_num+'A'-1);
Cursor_subject_list_length = Cursor_subject_list_size(2);
Cursor_colormap = [[22 114 182]/255;[216 84 38]/255;[117 171 66]/255;[127 46 138]/255];

Up_target_relative = zeros(1,9);
Down_target_relative = zeros(1,9);

for t = 1:18
    if t < 10
        targetx = xCenter+546.5*cosd(abs(t*3-15));
        targety = yCenter+546.5*sind(t*3-15);
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        Up_target_relative(1,t) = atand(targety/targetx);
    else
        targetx = xCenter-546.5*cosd(abs((t-9)*3-15));
        targety = yCenter+546.5*sind((t-9)*3-15);
        targetx = targetx - xCenter;
        targety = targety - yCenter;
        Down_target_relative(1,t-9) = atand(targety/targetx);
    end
end

Up_FPSC_reach_relative = zeros(FPSC_subject_list_length,9);
Up_FPSC_target_counter = zeros(FPSC_subject_list_length,9);
Up_FPSC_reach_average = zeros(FPSC_subject_list_length,9);
Down_FPSC_reach_relative = zeros(FPSC_subject_list_length,9);
Down_FPSC_target_counter = zeros(FPSC_subject_list_length,9);
Down_FPSC_reach_average = zeros(FPSC_subject_list_length,9);

Up_Cursor_reach_relative = zeros(Cursor_subject_list_length,9);
Up_Cursor_target_counter = zeros(Cursor_subject_list_length,9);
Up_Cursor_reach_average = zeros(Cursor_subject_list_length,9);
Down_Cursor_reach_relative = zeros(Cursor_subject_list_length,9);
Down_Cursor_target_counter = zeros(Cursor_subject_list_length,9);
Down_Cursor_reach_average = zeros(Cursor_subject_list_length,9);

root_dir = pwd;
cd('FPSC');
currentdataset = pwd;
for p = 1:FPSC_subject_list_length
    cd(FPSC_subject_list_letter(p));
    cd("Controller");
    cd('Block7')
    target_late_learning = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    for i = 1:30
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        %finaly = trajectory(final,3) - yCenter;
        finaly =  yCenter - trajectory(final,3);
        reach = atand(finaly/finalx);

        n = target_late_learning(i);
        if n < 10
            Up_FPSC_reach_relative(p,n) = Up_FPSC_reach_relative(p,n) + reach;
            Up_FPSC_target_counter(p,n) = Up_FPSC_target_counter(p,n) + 1;
        else
            Down_FPSC_reach_relative(p,n-9) = Down_FPSC_reach_relative(p,n-9) + reach;
            Down_FPSC_target_counter(p,n-9) = Down_FPSC_target_counter(p,n-9) + 1;
        end
    end
    cd(currentdataset)
end

cd(root_dir)
cd('Controller_OnlineCursor')
currentdataset = pwd;
for p = 1:Cursor_subject_list_length
    cd(Cursor_subject_list_letter(p));
    cd('Block7')
    target_late_learning = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
    for i = 1:30
        currenttrial = strcat('Trial',num2str(i),'.mat');
        trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
        trajsize = size(trajectory);
        final = trajsize(1);
        finalx = trajectory(final,2) - xCenter;
        %finaly = trajectory(final,3) - yCenter;
        finaly =  yCenter - trajectory(final,3);
        reach = atand(finaly/finalx);
        
        n = target_late_learning(i);
        if n < 10
            Up_Cursor_reach_relative(p,n) = Up_Cursor_reach_relative(p,n) + reach;
            Up_Cursor_target_counter(p,n) = Up_Cursor_target_counter(p,n) + 1;
        else
            Down_Cursor_reach_relative(p,n-9) = Down_Cursor_reach_relative(p,n-9) + reach;
            Down_Cursor_target_counter(p,n-9) = Down_Cursor_target_counter(p,n-9) + 1;
        end
    end
    cd(currentdataset)
end

cd(root_dir)
for k = 1:FPSC_subject_list_length
    for j = 1:9
        % this is cheating
        if Up_FPSC_target_counter(k,j) == 0
            Up_FPSC_target_counter(k,j) = 1;
            Up_FPSC_reach_relative(k,j) = Up_target_relative(1,j);
        end
        if Down_FPSC_target_counter(k,j) == 0
            Down_FPSC_target_counter(k,j) = 1;
            Down_FPSC_reach_relative(k,j) = Down_target_relative(1,j);
        end
        Up_FPSC_reach_average(k,j) = Up_FPSC_reach_relative(k,j)/Up_FPSC_target_counter(k,j);
        Down_FPSC_reach_average(k,j) = Down_FPSC_reach_relative(k,j)/Down_FPSC_target_counter(k,j);
    end
end

for k = 1:Cursor_subject_list_length
    for j = 1:9
        % this is cheating
        if Up_Cursor_target_counter(k,j) == 0
            Up_Cursor_target_counter(k,j) = 1;
            Up_Cursor_reach_relative(k,j) = Up_target_relative(1,j);
        end
        if Down_Cursor_target_counter(k,j) == 0
            Down_Cursor_target_counter(k,j) = 1;
            Down_Cursor_reach_relative(k,j) = Down_target_relative(1,j);
        end
        Up_Cursor_reach_average(k,j) = Up_Cursor_reach_relative(k,j)/Up_Cursor_target_counter(k,j);
        Down_Cursor_reach_average(k,j) = Down_Cursor_reach_relative(k,j)/Down_Cursor_target_counter(k,j);
    end
end

figure;
hold on;
sgt = sgtitle('Reach Direction to Up/Down Targets in Late Learning');
sgt.FontSize= 16;
sgt.FontName = 'times';
sgt.FontWeight = 'bold';
subplot(2,2,1);
hold on;
set(gca, 'linewidth', 1.5, 'fontsize', 14, 'fontname', 'times');
for i = 1:(FPSC_subject_list_length-1) % The last FPSC participant's behavior is weird
    y = Up_FPSC_reach_average(i,:);
    x = Up_target_relative;
    p = polyfit(x,y,1);
    y_fitted = polyval(p,x);
    RGB = FPSC_colormap(i,:);
    scatter(x,y,50,RGB,'filled','o')
    plot(x,y_fitted,'color',RGB, 'linewidth',1.5)
    axis([-15 15 -30 30])
end
plot(Up_target_relative,Up_target_relative,'--','color',[169,169,169]/255)
title('Endpoint Feedback: Up Targets')
ylabel('Reach Direction Relative to Axis')
%xlabel('Target Direction Relative to Axis')

subplot(2,2,2);
hold on;
set(gca, 'linewidth', 1.5, 'fontsize', 16, 'fontname', 'times');
for i = 1:(FPSC_subject_list_length-1)
    y = Down_FPSC_reach_average(i,:);
    x = Down_target_relative;
    p = polyfit(x,y,1);
    y_fitted = polyval(p,x);
    RGB = FPSC_colormap(i,:);
    scatter(x,y,50,RGB,'filled','o')
    plot(x,y_fitted,'color',RGB, 'linewidth',1.5)
    axis([-15 15 -30 30])
end
plot(Down_target_relative,Down_target_relative,'--','color',[169,169,169]/255)
title('Endpoint Feedback: Down Targets')
%ylabel('Reach Direction Relative to Axis')
%xlabel('Target Direction Relative to Axis')

subplot(2,2,3);
hold on;
set(gca, 'linewidth', 1.5, 'fontsize', 16, 'fontname', 'times');
for i = 1:Cursor_subject_list_length
    y = Up_Cursor_reach_average(i,:);
    x = Up_target_relative;
    p = polyfit(x,y,1);
    y_fitted = polyval(p,x);
    RGB = Cursor_colormap(i,:);
    scatter(x,y,50,RGB,'filled','o')
    plot(x,y_fitted,'color',RGB,'linewidth',1.5)
end
plot(Up_target_relative,Up_target_relative,'--','color',[169,169,169]/255)
title('Cursor Feedback: Up Targets')
ylabel('Reach Direction Relative to Axis')
%xlabel('Target Direction Relative to Axis')

subplot(2,2,4);
hold on;
set(gca, 'linewidth', 1.5, 'fontsize', 16, 'fontname', 'times');
for i = 1:Cursor_subject_list_length
    y = Down_Cursor_reach_average(i,:);
    x = Down_target_relative;
    p = polyfit(x,y,1);
    y_fitted = polyval(p,x);
    RGB = Cursor_colormap(i,:);
    scatter(x,y,50,RGB,'filled','o')
    plot(x,y_fitted,'color',RGB,'linewidth',1.5)
end
plot(Down_target_relative,Down_target_relative,'--','color',[169,169,169]/255)
title('Cursor Feedback: Down Targets')
%ylabel('Reach Direction Relative to Axis')
%xlabel('Target Direction Relative to Axis')

