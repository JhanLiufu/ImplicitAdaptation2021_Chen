%% This code is for Controller data processing, changes of absolute error for each target
%% averaged across all participants.
%% To be placed in FPSC, FCSP or Controller_OnlineCursor folder
% Written by Mengzhan Liufu at UChicago. 

xCenter = 960;
yCenter = 540;
finaldata = [0 0];
targetdata = [0 0];
%subject_list_num = [3 4 5 6 7 11 13 14 16 17 23];
subject_list_num = [1 2 3];
subject_list_size = size(subject_list_num);
subject_list_letter = char(subject_list_num+'A'-1);
subject_list_length = subject_list_size(2);
error_by_target = zeros(18, 1);
