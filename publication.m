%% This code is for collective data processing.

%% Initiali

clear
close all

xCenter = 960;
yCenter = 540;

aboveFinal = zeros(210, 1);
aboveTarget = zeros(210, 1);
belowFinal = zeros(210, 1);
belowTarget = zeros(210, 1);

allFinal = cell(1,3);
allTarget = cell(1,3);
expFinal = cell(1,8);
expTarget = cell(1,8);
parFinal = [0 0];
parTarget = [0 0];

filePath = matlab.desktop.editor.getActiveFilename;
workingDirectory = erase(filePath,'submission.m');
cd(workingDirectory);
% if ~isfolder('FigOut')
%    mkdir(FigOut)
% end

%% Load all data and make plots

fAll1 = figure('Name','ErrorAll3Experiments','NumberTitle','off');
fAll2 = figure('Name','AllTrajectory','NumberTitle','off');

fSec1 = figure('name','Experiment1_RelativeError','NumberTitle','off','visible','off');
fSec2 = figure('name','Experiment1vs2_RelativeError','NumberTitle','off','visible','off');
fSec3 = figure('name','Experiment3_RelativeError','NumberTitle','off','visible','off');

for i = 1:3 % 3 experiments
    cd(workingDirectory);
    currentExp = fullfile(workingDirectory, strcat('Experiment',num2str(i)));
    cd(currentExp);

    for j = 1:8 % 8 participants per experiment
        currentSubj = fullfile(currentExp, num2str(j));
        cd(currentSubj);

        Sub = struct;


        % Plot all trajectories
        for k = 1:7 % 7 blocks per participant

            if (k <= 3)
                currentBlock = fullfile(currentSubj, strcat('Block',num2str(k)));
                cd(currentBlock);
                target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));

                for l = 1:30 % 30 trials per block
                    figure(fAll2);
                    hold on;

                    currentTrial = fullfile(currentBlock,strcat('Trial',num2str(l),'.mat'));
                    trajectory = cell2mat(struct2cell(load(currentTrial,'trialtrajectory')));
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

                    % All final and target

                    parFinal((k-1)*30+l) = atand(finaly/finalx);
                    parTarget((k-1)*30+l) = atand(targety/targetx);

                    block_final(l) =  parFinal((k-1)*30+l);
                    block_target(l) = parTarget((k-1)*30+l);

                    % Separate above and below
                    if (finalx > 0)
                        aboveFinal((k-1)*30+l) = atand(finaly/finalx);
                        block_above_final(l) = aboveFinal((k-1)*30+l);
                    end

                    if (targetx > 0)
                        aboveTarget((k-1)*30+l) = atand(targety/targetx);
                        block_above_target(l) = aboveTarget((k-1)*30+l);
                    end
                end
            end
        end
        %% Plot relative errors of all three experiments
        
        figure(fAll1);
        hold on;

        relError = parFinal - parTarget;
        
        x = linspace(1,210,210);

        if i == 1
            plot(x,relError,'-o','Color','red');
        elseif i == 2
            plot(x,relError,'-o','Color','green');
        else
            plot(x,relError,'-o','Color','blue');
        end
        cd ..;
        cd(workingDirectory);
        axis equal;
        
        %% Plot Section 1, 2, 3 figures
        
        if i == 1            
            figure(fSec1);
            hold on;
            plot(x,relError,'-o','Color','red');
            hold off;
            axis([0 210 -60 60]);
            
            figure(fSec2);
            hold on;
            plot(x,relError,'-o','Color','red');
            hold off;
            axis([0 210 -60 60]);
            
        elseif i == 2
            figure(fSec2);
            hold on;
            plot(x,relError,'-o','Color','green');
            hold off;
            axis([0 210 -60 60]);
            
        else
            figure(fSec3);
            hold on;
            plot(x,relError,'-o','Color','blue');
            hold off;
            axis([0 210 -60 60]);
            
        end

        %% Absolute plot of Position
        
        f1 = figure('name','AbsolutePosition','NumberTitle','off','visible','off');
        plot(x, parFinal, "o", x, parTarget, "x");
        axis([0 210 -30 30]);
        xlabel("Trial Number");
        ylabel("Abs Degree");
        % saveas(f1,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr')),'pdf');

        f2 = figure('name','AbsolutePosition_DifferentColor','NumberTitle','off','visible','off');
        plot(x, parFinal, "-*", "Color","green");
        hold on;
        plot(x, parTarget, "-o", "Color","blue");
        axis([0 210 -30 30]);
        xlabel("Trial Number");
        ylabel("Abs Degree");
        % saveas(f2,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr_Color')),'pdf');

        %% Plotting Error (anti-clock wise would be positive)
        
        error = [0 0];
        for k = 1:210
        error(k) = parFinal(k) - parTarget(k);
        end

        f3 = figure('name','RelativeError_Scattered','NumberTitle','off','visible','off');
        plot(x, error, "*", "Color","red");
        xlabel("Trial Number");
        ylabel("directional error: anti-clockwise would be positive");
        % saveas(f3,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_RelErr_Scattered')),'pdf');

        %% plot Abs Error
        
        abserr= [0 0];
        for k = 1:210
            abserr(k) = abs(error(k));
        end 

        f4 = figure('name','AbsoluteError','NumberTitle','off','visible','off');
        plot(x, abserr, "-o", "Color","blue");
        xlabel("Trial Number");
        ylabel("Absolute error");
        axis([0 220 0 50]);
        % saveas(f4,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr')),'pdf');


        %% plot Above/Below Data
        
        f5 = figure('name','Above/below','NumberTitle','off','visible','off');
        plot(x, aboveFinal, "*", x, aboveTarget, "o", "Color","red");
        axis([0 220 -40 40]);
        hold on;
        plot(x, belowFinal, "*", x, belowTarget, "o", "Color","blue");
        xlabel("Trial Number");
        ylabel("Above in red, below in blue");
        % saveas(f5,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AboveAndBelow')),'pdf');
        
        % Dimensional shift
        f6 = figure('name','DimensionalShift','NumberTitle','off','visible','off');
        aboveshift = aboveFinal + 90;
        belowshit = belowFinal - 90;
        plot(x, aboveshift, "*", x, aboveTarget + 90, "o", "Color","red");
        hold on;
        plot(x, belowshit, "*", x, belowTarget - 90, "o", "Color","blue");
        axis([0 220 -200 200]);
        xlabel("Trial Number");
        ylabel("Shift for seperation");
        % saveas(f6,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_DimShift')),'pdf');
        
        % Seperate Above and Below
        f7 = figure('name','Above','NumberTitle','off','visible','off');
        plot(x, aboveFinal, "*", x, aboveTarget, "o", "Color","red");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Above");
        % saveas(f7,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Above')),'pdf');
        
        f8 = figure('name','Below','NumberTitle','off','visible','off');
        plot(x, belowFinal, "*", x, belowTarget, "o", "Color","blue");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Below");
        % saveas(f8,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Below')),'pdf');

        %% Calculate Above/Below Error
        
        f9 = figure('name','AbsoluteError_Above','NumberTitle','off','visible','off');
        aboveerrorabs = abs(aboveFinal - aboveTarget);
        plot(x, aboveerrorabs, "-o", "Color","red");
        axis([0 220 0 40]);
        xlabel("Trial Number");
        ylabel("Above Error Absolute");
        % saveas(f9,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr_Above')),'pdf');

        % Below Error
        f10 = figure('name','AbsoluteError_Below','NumberTitle','off','visible','off');
        belowerrorabs = abs(belowFinal - belowTarget);
        plot(x, belowerrorabs, "-o", "Color","green");
        axis([0 220 0 40]);
        xlabel("Trial Number");
        ylabel("Below Error Absolute");
        % saveas(f10,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr_Below')),'pdf');


        %% Learning direction considering Above/Below Seperately
        
        f11 = figure('name','RelativeError_Above','NumberTitle','off','visible','off');
        aber = aboveFinal - aboveTarget;
        plot(x, aber, "*", "Color","red");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Above Error Signed");
        % saveas(f11,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_RelErr_Above')),'pdf');

        % Below Error
        f12 = figure('name','RelativeError_Below','NumberTitle','off','visible','off');
        beer = belowFinal - belowTarget;
        plot(x, beer, "o", "Color","blue");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Below Error Signed");
        % saveas(f12,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_RelErr_Below')),'pdf');

        % Compress aber to compare error with the previous one.
        counter = 1;
        next = 1;
        aberdirection = [0 0];
        previous = 0;
        while counter <= 210
            if aber(counter) ~= 0
                aberdirection(next) = aber(counter) - previous; 
                previous = aber(counter);
                next = next + 1;
            end 
            counter = counter + 1;
        end
        f13 = figure('name','LearningDirection_Above','NumberTitle','off','visible','off');
        plot(aberdirection);
        xlabel("Correction Number");
        ylabel("Correction Signed");
        title("Above Correction");
        % saveas(f13,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_LearnDir_Above')),'pdf');

        counter = 1;
        next = 1;
        beerdirrection = [0 0];
        previous = 0;
        while counter <= 210
            if beer(counter) ~= 0
                beerdirrection(next) = beer(counter) - previous; 
                previous = beer(counter);
                next = next + 1;
            end 
            counter = counter + 1;
        end
        f14 = figure('name','LearningDirection_Below','NumberTitle','off','visible','off');
        plot(beerdirrection);
        xlabel("Correction Number");
        ylabel("Correction Signed");
        title("Below Correction");
        % saveas(f14,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_LearnDir_Below')),'pdf');

        % plot Them Together
        totalerrordirection = [0 0];
        counter = 1;
        benext = 1;
        abnext = 1;
        while (counter <= 210)
            if beer(counter) ~= 0
                totalerrordirection(counter) = beerdirrection(benext); 
                benext = benext + 1;
            end
            if aber(counter) ~= 0
                totalerrordirection(counter) = aberdirection(abnext); 
                abnext = abnext + 1;
            end
            counter = counter + 1;
        end 
        f15 = figure('name','LearningDirection_All','NumberTitle','off','visible','off');
        plot(totalerrordirection);
        xlabel("Correction Number");
        ylabel("Correction Signed");
        title("Above and Below Together Correction");
        axis([0 220 -60 60]);
        % saveas(f15,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_LearnDir_All')),'pdf');

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
            currentBlock = fullfile(currentSubj, strcat('Block',num2str(k)));
            cd(currentBlock);
            f16to18 = figure('name',strcat('Trajectory_NoPerturbation_Block',num2str(k)),'NumberTitle','off','visible','off');
            hold on;
            title(currentBlock);
            for l = 1:30
                currentTrial = fullfile(currentBlock,strcat('Trial',num2str(l),'.mat'));
                trajectory = cell2mat(struct2cell(load(currentTrial,'trialtrajectory')));
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
                if finalx > 0
                    blockabovefinal(k,l) = atand(finaly/finalx);
                end 
                if targetx > 0
                    blockabovetarget(k,l) = atand(targety/targetx);
                end 
                if finalx < 0
                    blockbelowfinal(k,l) = atand(finaly/finalx);
                end 
                if targetx < 0
                    blockbelowtarget(k,l) = atand(targety/targetx);
                end 
            end
            axis equal;
            % saveas(f16to18,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Block',num2str(k),'_TrajNoPerturb')),'pdf');
            cd(workingDirectory);
        end

        for k = 4:7
            currentBlock = fullfile(currentSubj, strcat('Block',num2str(k)));
            cd(currentBlock);
            target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
            f19to22 = figure('name',strcat('Trajectory_WithPerturbation_Block',num2str(k)),'NumberTitle','off','visible','off');
            hold on;
            title(currentBlock);
            for l = 1:30
                currentTrial = fullfile(currentBlock,strcat('Trial',num2str(l),'.mat'));
                trajectory = cell2mat(struct2cell(load(currentTrial,'trialtrajectory')));
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
                
                blockfinaldata(k,l) = atand(finaly/finalx);
                blocktargetdata(k,l) = atand(targety/targetx);
                if finalx > 0
                    blockabovefinal(k,l) = atand(finaly/finalx);
                end 
                if targetx > 0
                    blockabovetarget(k,l) = atand(targety/targetx);
                end 
                if finalx < 0
                    blockbelowfinal(k,l) = atand(finaly/finalx);
                end 
                if targetx < 0
                    blockbelowtarget(k,l) = atand(targety/targetx);
                end 
            end
            axis equal;
            % saveas(f19to22,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Block',num2str(k),'_TrajWPerturb')),'pdf');
            cd(workingDirectory);
        end

        f23 = figure('name','Reaching_NoPerturbation','NumberTitle','off','visible','off');
        hold on;
        for k = 1:3
            x = linspace(1,30,30);
            plot(x, blockfinaldata(k,:));   
            plot(x, blocktargetdata(k,:), ':','LineWidth', 9);
        end 
        % saveas(f23,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_ReachNoPerturb')),'pdf');

        
        f24 = figure('name','Reaching_WPerturbation','NumberTitle','off','visible','off');
        hold on;
        for k = 4:7
            x = linspace(1,30,30);
            plot(x, blockfinaldata(k,:));   
            plot(x, blocktargetdata(k,:), ':','LineWidth', 9);
        end
        % saveas(f24,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_ReachWPerturb')),'pdf');
        Sub.parFinal = parFinal;
        Sub.parTarget = parTarget;
        Sub.beT = belowTarget;
        Sub.abT = aboveTarget;
        Sub.abF = aboveFinal;
        sub.abT = aboveTarget;
        Exp.Sub{j} = Sub;
    end
    Data.Exp{i} = Exp;
end

% saveas(fSec1,fullfile(workingDirectory,'figOut',strcat('Fig1_Exp1','_RelErr')),'pdf');
% saveas(fSec2,fullfile(workingDirectory,'figOut',strcat('Fig2_Exp1vs2','_RelErr')),'pdf');
% saveas(fSec3,fullfile(workingDirectory,'figOut',strcat('Fig3_Exp3','_RelErr')),'pdf');

% saveas(fAll1,fullfile(workingDirectory,'figOut','RelErr_All3Expe'),'pdf');
% saveas(fAll2,fullfile(workingDirectory,'figOut','trajectory_All3Expe'),'pdf');

%% ANOVA on behavioral data



%% Fitting behavioral data

% Fit within block across subjects for each experiment
% colorMap = [[22,114,182]/255;[216,84,38]/255;[117,171,66]/255;[127,46,138]/255;[162,29,49]/255;
%     [234,177,32]/255;[182,194,154]/255;[222,156,83]/255;[201,186,131]/255;[117,36,35]/255;[224,160,158]/255];
% 
% for i = 1:3
%     fFitWBlk = figure('name',strcat('ReachVSTarget_Both_WithinBlock_Exp',num2str(i)),'NumberTitle','off','visible','on');
%     hold on;
%     for k = 4:7
%         xAll = linspace(1,240,240);
%         yAll = linspace(1,240,240);
%         for j = 1:8
%             xAll((j-1)*30+1:j*30) = allTarget{1,i}{1,j}(1,(k-1)*30+1:k*30);
%             if i ~= 2 % Needs confirmation: H-T or C-T?
%                 yAll((j-1)*30+1:j*30) = allFinal{1,i}{1,j}(1,(k-1)*30+1:k*30);
%             else
%                 yAll((j-1)*30+1:j*30) = -allFinal{1,i}{1,j}(1,(k-1)*30+1:k*30);
%             end
%         end
%         combinedXY = table(round(xAll.'),yAll.');
%         statsArrayXY = grpstats(combinedXY,'Var1');
%         x = table2array(statsArrayXY(:,1));
%         y = table2array(statsArrayXY(:,3));
%         p = polyfit(x,y,1);
%         y_fitted = polyval(p,x);
%         RGB = colorMap(k-3,:);
%         scatter(x,y,50,RGB,'filled','o');
%         plot(x,y_fitted,'color',RGB,'linewidth',1.5);
%     end
%     axis([-15 15 -30 30]);
%     plot(x,x,'--','color',[169,169,169]/255);
%     % saveas(fFitWBlk,fullfile(workingDirectory,'figOut',strcat('RchVSTgt_Both_WBlk_','Exp',num2str(i))),'pdf');
% end

% Fit within subject, within block for the last block of experiments 2 and
% 3

colorMap = [[22,114,182]/255;[216,84,38]/255;[117,171,66]/255;[127,46,138]/255;[162,29,49]/255;
     [234,177,32]/255;[182,194,154]/255;[222,156,83]/255;[201,186,131]/255;[117,36,35]/255;[224,160,158]/255];

for i = 2:3
    fFitWSubjWBlk = figure('name',strcat('ReachVSTarget_Both_WithinSubjectWithinBlock_Exp',num2str(i)),'NumberTitle','off','visible','on');
    hold on;
    for j = 1:8
        xRaw = allTarget{1,i}{1,j}(1,181:210);
        if i ~= 2
            yRaw = allFinal{1,i}{1,j}(1,181:210);
        else 
            yRaw = -allFinal{1,i}{1,j}(1,181:210);
        end
        combinedXY = table(round(xRaw.'),yRaw.');
        statsArrayXY = grpstats(combinedXY,'Var1');
        x = table2array(statsArrayXY(:,1));
        y = table2array(statsArrayXY(:,3));
        p = polyfit(x,y,1); % Question: average first then fit, or fit first then average?
        y_fitted = polyval(p,x);
        RGB = colorMap(j,:);
        scatter(x,y,50,RGB,'filled','o');
        plot(x,y_fitted,'color',RGB,'linewidth',1.5);
        
        % Calculate MSE
        mse = sum((y_fitted - y).^2)./60;
    end
    axis([-15 15 -30 30]);
    plot(x,x,'--','color',[169,169,169]/255);
    hold off
    legend('location','bestoutside')
    % saveas(fFitWSubjWBlk,fullfile(workingDirectory,'figOut',strcat('RchVSTgt_Both_WSubjWBlk_','Exp',num2str(i))),'pdf');
    
end

save('allData.mat','allFinal','allTarget')

% 
% f1dot = figure('Name','dot plot for relative error of exp 1 and 2','NumberTitle','off');
% hold on
% 
% % Plot exp 1
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,1}{1,i} - allTarget{1,1}{1,i};
%     p1 = plot(x,y,'.b','Color','#77AC30','MarkerSize',5);
% end
% 
% % Plot exp 2
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,2}{1,i} - allTarget{1,2}{1,i};
%     p2 = plot(x,y,'.','Color','#4DBEEE','MarkerSize',5);
% end
% 
% % Plot exp 3
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,3}{1,i} - allTarget{1,3}{1,i};
%     p3 = plot(x,y,'.b','Color','#A2142F','MarkerSize', 5);
% end
% 
% 
% xline(90,'--','LineWidth',3)
% yline(0,'--')
% xlabel("Trial Number",'FontSize',12);
% ylabel("Relative Error/Degree",'FontSize',12)
% xlim([0 210])
% ylim([-70 70])
% legend([p1,p2,p3],{'Experiment 1','Experiment 2', 'Experiment 3'},'FontSize',12)
% hold off


%Directional Error 

Fig1_Dir = figure('Name','Directional Error','NumberTitle','off');
hold on;

fhandle = Fig1_Dir;% get the 'figure handle' for this figure so you can change its properties
% Plot exp 1
for i = 1:8
    x = linspace(1,210,210);
    y = Data.Exp{1}.Sub{i}.parFinal - Data.Exp{1}.Sub{i}.parTarget;
    Fig1p1 = plot(x,y,'.b','Color','#77AC30','MarkerSize',15);
end

box1=[-1 -1 60 60];
box2=[150 150 220 220];
boxy=[-1 1 1 -1]*70*1.2;
patch(box1,boxy,[0 0 0],'FaceAlpha',0.1)
patch(box2,boxy,[0 0 0],'FaceAlpha',0.1)

xline(90,'--','LineWidth',3)
yline(0,'--')
xlabel("Trial Number",'FontSize',50);
ylabel("Directional Error in Degree",'FontSize',50)
xlim([0 210])
ylim([-70 70])
legend(Fig1p1,{'Endpoint Feeback'},'FontSize',15);
set(gca,'Fontsize',30)
title('Endpoint Feedback')
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;

%% Absolute Error

Fig1_Abs = figure('Name','Absolute Error','NumberTitle','off');
hold on;
fhandle = Fig1_Abs;% get the 'fi

raw_exp1 = zeros(8,210);

for i = 1:8
    raw_exp1(i,:) = abs(Data.Exp{1}.Sub{i}.parFinal - Data.Exp{1}.Sub{i}.parTarget);
end

mean_exp1 = zeros(1,210);

for i = 1:210
    mean_exp1(i) = mean(raw_exp1(:,i));
end 

std_exp1 = zeros(1,210);
std_exp1_up = zeros(1,210);
std_exp1_down = zeros(1,210);

for i = 1:210
    std_exp1(i) = std(raw_exp1(:,i));
    std_exp1_up(i) = std_exp1(i) + mean_exp1(i);
    std_exp1_down(i) = - std_exp1(i) + mean_exp1(i);
end 

inBetweenRegionX = [1:length(std_exp1_up), length(std_exp1_down):-1:1];
inBetweenRegionY = [std_exp1_up, fliplr(std_exp1_down)];
Fig1_Abs_fill = fill(inBetweenRegionX, inBetweenRegionY, 'g', 'FaceAlpha', 0.3);

x = linspace(1,210,210);
Fig1_Abs_line = plot(x,mean_exp1,'-','Color','#77AC30','LineWidth',2);

xlim([0 210])
ylim([0 45])

box1=[-1 -1 60 60];
box2=[150 150 220 220];
boxy=[-1 1 1 -1]*70*1.2;
patch(box1,boxy,[0 0 0],'FaceAlpha',0.1)
patch(box2,boxy,[0 0 0],'FaceAlpha',0.1)

xline(90,'--','LineWidth',3)
yline(0,'--')
xlabel("Trial Number",'FontSize',15);
ylabel("Absolute Error in Degree",'FontSize',15)
legend(Fig1_Abs_line,{'Endpoint Feeback'},'FontSize',15)
title('Endpoint Feedback')
set(gca, 'Fontsize', 30)
set(fhandle, 'Position', [600, 100, 1200, 800]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
set(gca,'Fontsize',30)
title('Endpoint Feedback')
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;

%% Statistical Testing 

exp1_baseline = raw_exp1(:,1:60);
exp1_experimental = raw_exp1(:,151:210);

exp1_baseline_average_across_participant = zeros(1,60);
exp1_experimental_average_across_participant = zeros(1,60);

exp1_baseline_average_across_t = zeros(1,7);
exp1_experimental_average_across_t = zeros(1,7);

for i = 1:60
    exp1_baseline_average_across_participant(i) = mean(exp1_baseline(:,i));
    exp1_experimental_average_across_participant(i) = mean(exp1_experimental(:,i));
end 

for i = 1:7
    exp1_baseline_average_across_t(i) = mean(exp1_baseline(i,:));
    exp1_experimental_average_across_t(i) = mean(exp1_experimental(i,:));
end 

exp1_baseline_reshape = reshape(exp1_baseline,1,[]);
exp1_experimental_reshape = reshape(exp1_experimental,1 ,[]);

%% 
var_exp1_mean_exp = std(exp1_experimental_average_across_t) 
var_exp1_mean_base = std(exp1_baseline_average_across_t)

%%

% Kolmogorov-Smirnov Test Normality Check

[exp1_base_h,exp1_base_p,exp1_base_ksstat,exp1_base_cv] = kstest(exp1_baseline_reshape)

[exp1_exp_h,exp1_exp_p,exp1_exp_ksstat,exp1_exp_cv] = kstest(exp1_experimental_reshape)

%%

% Bartlett's test for Homogenity of Variance Across Subjects
[exp1_base_acrossSubject_p,exp1_base_acrossSubject_stats] = vartestn(exp1_baseline)
[exp1_exp_acrossSubject_p,exp1_exp_acrossSubject_stats] = vartestn(exp1_experimental)
%%

% Bartlett's test for Homogenity of Variance Across Subjects
[exp1_base_acrosstrials_p,exp1_base_acrosstrials_stats] = vartestn(exp1_baseline');
[exp1_exp_acrosstrials_p,exp1_exp_acrosstrials_stats] = vartestn(exp1_experimental');
%%

% One Way Anova Total 
one_way_anova = zeros(480,2);
one_way_anova(:,1) = exp1_baseline_reshape';
one_way_anova(:,2) = exp1_experimental_reshape';
[exp1_anova1_p,exp1_anova1_tbl, exp1_anova1_stats] = anova1(one_way_anova);
%%

% One Way Anova Across 
one_way_anova_across_participants1 = zeros(60,2);
one_way_anova_across_participants1(:,1) = exp1_baseline_average_across_participant';
one_way_anova_across_participants1(:,2) = exp1_experimental_average_across_participant';
[exp1_anova1_p_a_p,exp1_anova1_tbl_a_p, exp1_anova1_stats_a_p] = anova1(one_way_anova_across_participants1)
%%

% One Way Anova Across Participants
one_way_anova_across_t1 = zeros(7,2);
one_way_anova_across_t1(:,1) = exp1_baseline_average_across_t';
one_way_anova_across_t1(:,2) = exp1_experimental_average_across_t';
[exp1_anova1_p_a_t,exp1_anova1_tbl_a_t, exp1_anova1_stats_a_t] = anova1(one_way_anova_across_t1)

% Two Sample ttest
[h,p, ci, stat] = ttest2(exp1_baseline_average_across_t,exp1_experimental_average_across_t)

%%

f_stat1 = figure();
hold on
fhandle = f_stat1;% get the 'fi

[h_p111,p_p112,ci_p113,stat_p114] = ttest(exp1_baseline_average_across_t)
[h_p122,p_p123,ci_p122,stat_p124] = ttest(exp1_experimental_average_across_t)

% Bar
x = [1 2];
data = [mean(exp1_baseline_average_across_t) mean(exp1_experimental_average_across_t)]';
errhigh = [stat_p114.sd stat_p124.sd];
errlow  = [stat_p114.sd stat_p124.sd];

bar(x,data,'FaceColor','#77AC30','EdgeColor','#77AC30','LineWidth',1.5, 'FaceAlpha', 0.5)                

er = errorbar(x,data,errlow,errhigh);    
er.Color = '#77AC30';                            
er.LineStyle = 'none';  
er.LineWidth = 3;
name = {'Baseline';'Experimental'};
set(gca,'XTick',1:length(name),'XTickLabel',name, 'fontsize', 15)
ylabel('Absolute Error in Degree');
%title('Condition 1: Endpoint Feedback');
comtemporyx = linspace(0.75,2.25);
comtemporyy = linspace(0.75,2.25);
comtemporyy(:) = 5.15;
plot(comtemporyx, comtemporyy, '-k', 'LineWidth',4)
text(1.425, 5.4, 'ns','Fontsize',20)
title('Endpoint Feedback')
set(gca, 'Fontsize', 15)
ylim([0 7])
set(gca,'Fontsize',30)
title('Endpoint Feedback')
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;
%%
% Plot exp 2
Fig2 = figure('Name','Directional Error','NumberTitle','off');
fhandle = Fig2;% get the 'fi
hold on;
for i = 1:8
    x = linspace(1,210,210);
    y = Data.Exp{2}.Sub{i}.parFinal - Data.Exp{2}.Sub{i}.parTarget;
    Fig1p2 = plot(x,y,'.b','Color','#4DBEEE','MarkerSize',15);
end
xline(90,'--','LineWidth',3)
yline(0,'--')
xlabel("Trial Number",'FontSize',15);
ylabel("Directional Error in Degree",'FontSize',15)

box1=[-1 -1 60 60];
box2=[150 150 220 220];
boxy=[-1 1 1 -1]*70*1.2;
patch(box1,boxy,[0 0 0],'FaceAlpha',0.1)
patch(box2,boxy,[0 0 0],'FaceAlpha',0.1)

xlim([0 210])
ylim([-70 70])
legend(Fig1p2,{'Online Feeback'},'FontSize',15)
title('Online Feedback')
set(gca, 'Fontsize', 15)
set(gca,'Fontsize',30)
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;

%% Absolute Error

Fig2_Abs = figure('Name','Absolute Error','NumberTitle','off');
fhandle = Fig2_Abs;% get the 'fi
hold on;

raw_exp2 = zeros(8,210);

% for i = 1:8
%     raw_exp2(i,:) = abs(Data.Exp{2}.Sub{i}.parFinal - Data.Exp{2}.Sub{i}.parTarget);
% end

for i = 1:8
     raw_exp2(i,:) = Data.Exp{2}.Sub{i}.parFinal - Data.Exp{2}.Sub{i}.parTarget;
end
mean_exp2 = zeros(1,210);

for i = 1:210
    mean_exp2(i) = mean(raw_exp2(:,i));
end 

std_exp2 = zeros(1,210);
std_exp2_up = zeros(1,210);
std_exp2_down = zeros(1,210);

for i = 1:210
    std_exp2(i) = std(raw_exp2(:,i));
    std_exp2_up(i) = std_exp2(i) + mean_exp2(i);
    std_exp2_down(i) = - std_exp2(i) + mean_exp2(i);
end 

inBetweenRegionX = [1:length(std_exp2_up), length(std_exp2_down):-1:1];
inBetweenRegionY = [std_exp2_up, fliplr(std_exp2_down)];
Fig2_Abs_fill = fill(inBetweenRegionX, inBetweenRegionY,'cyan', 'FaceAlpha', 0.3);

x = linspace(1,210,210);
Fig2_Abs_line = plot(x,mean_exp2,'-','Color',[0.3010 0.7450 0.9330],'LineWidth',2);

xlim([0 210])
ylim([0 45])

box1=[-1 -1 60 60];
box2=[150 150 220 220];
boxy=[-1 1 1 -1]*70*1.2;
patch(box1,boxy,[0 0 0],'FaceAlpha',0.1)
patch(box2,boxy,[0 0 0],'FaceAlpha',0.1)

xline(90,'--','LineWidth',3)
yline(0,'--')
xlabel("Trial Number",'FontSize',15);
ylabel("Absolute Error in Degree",'FontSize',15)
legend(Fig2_Abs_line,{'Online Feeback'},'FontSize',15)
title('Online Feedback')
set(gca,'Fontsize',30)
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;

%% Statistical Testing 


exp2_baseline = raw_exp2(:,1:60);
exp2_experimental = raw_exp2(:,151:210);

exp2_baseline_average_across_participant = zeros(1,60);
exp2_experimental_average_across_participant = zeros(1,60);

exp2_baseline_average_across_t = zeros(1,7);
exp2_experimental_average_across_t = zeros(1,7);

for i = 1:60
    exp2_baseline_average_across_participant(i) = mean(exp2_baseline(:,i));
    exp2_experimental_average_across_participant(i) = mean(exp2_experimental(:,i));
end 

for i = 1:7
    exp2_baseline_average_across_t(i) = mean(exp2_baseline(i,:));
    exp2_experimental_average_across_t(i) = mean(exp2_experimental(i,:));
end 

exp2_baseline_reshape = reshape(exp2_baseline,1,[]);
exp2_experimental_reshape = reshape(exp2_experimental,1 ,[]);

% Kolmogorov-Smirnov Test Normality Check
[exp2_base_h,exp2_base_p,exp2_base_ksstat,exp2_base_cv] = kstest(exp2_baseline_reshape)
[exp2_exp_h,exp2_exp_p,exp2_exp_ksstat,exp2_exp_cv] = kstest(exp2_experimental_reshape)

%%
% Bartlett's test for Homogenity of Variance Across Subjects
[exp2_base_acrossSubject_p,exp2_base_acrossSubject_stats] = vartestn(exp2_baseline);
[exp2_exp_acrossSubject_p,exp2_exp_acrossSubject_stats] = vartestn(exp2_experimental);
%%
% Bartlett's test for Homogenity of Variance Across Subjects
[exp2_base_acrosstrials_p,exp2_base_acrosstrials_stats] = vartestn(exp2_baseline');
[exp2_exp_acrosstrials_p,exp2_exp_acrosstrials_stats] = vartestn(exp2_experimental');
%%
mean_base = mean(mean(exp2_baseline'))
mean_exp = mean(mean(exp2_experimental'))
std_base = std(mean(exp2_baseline'))
std_exp = std(mean(exp2_experimental'))
%% 
% One Way Anova Total 
one_way_anova = zeros(480,2);
one_way_anova(:,1) = exp2_baseline_reshape';
one_way_anova(:,2) = exp2_experimental_reshape';
[exp2_anova1_p,exp2_anova1_tbl, exp2_anova1_stats] = anova1(one_way_anova);
%%

% One Way Anova Across Subjects
one_way_anova_across_participants = zeros(60,2);
one_way_anova_across_participants2(:,1) = exp2_baseline_average_across_participant';
one_way_anova_across_participants2(:,2) = exp2_experimental_average_across_participant';
[exp2_anova1_p_a_p,exp2_anova1_tbl_a_p, exp2_anova1_stats_a_p] = anova1(one_way_anova_across_participants)
%%
% One Way Anova Across Trials
one_way_anova_across_t2 = zeros(7,2);
one_way_anova_across_t2(:,1) = exp2_baseline_average_across_t';
one_way_anova_across_t2(:,2) = exp2_experimental_average_across_t';
[exp2_anova1_p_a_t,exp2_anova1_tbl_a_t, exp2_anova1_stats_a_t] = anova1(one_way_anova_across_t2)



%% 
% TWO WAY
two_way = [one_way_anova_across_t1; one_way_anova_across_t2]
p = anova2(two_way,7)
%% 
% Two Sample ttest
[h,p, ci, stat] = ttest2(exp2_baseline_average_across_t,exp2_experimental_average_across_t)

sd = figure;
fhandle = sd
hold on
[h_p111,p_p112,ci_p113,stat_p114] = ttest(exp2_baseline_average_across_t)
[h_p122,p_p123,ci_p122,stat_p124] = ttest(exp2_experimental_average_across_t)

% Bar
x = [1 2];
data = [mean(exp2_baseline_average_across_t) mean(exp2_experimental_average_across_t)]';
errhigh = [stat_p114.sd stat_p124.sd];
errlow  = [stat_p114.sd stat_p124.sd];

bar(x,data,'FaceColor','#4DBEEE','EdgeColor','#4DBEEE','LineWidth',1.5, 'FaceAlpha', 0.5)                

er = errorbar(x,data,errlow,errhigh);    
er.Color = '#4DBEEE';                            
er.LineStyle = 'none';  
er.LineWidth = 3;
name = {'Baseline';'Experimental'};
set(gca,'XTick',1:length(name),'XTickLabel',name, 'fontsize', 15)
ylabel('Absolute Error in Degree');
%title('Condition 2: Online Feedback');
comtemporyx = linspace(0.75,2.25);
comtemporyy = linspace(0.75,2.25);
comtemporyy(:) = 22.75;
plot(comtemporyx, comtemporyy, '-k', 'LineWidth',4)
plot(1.425, 23.5, '*k')
plot(1.475, 23.5, '*k')
plot(1.525, 23.5, '*k')
plot(1.575, 23.5, '*k')
title('Online Feedback')
set(gca, 'Fontsize', 15)
ylim([0 27])
set(gca,'Fontsize',30)
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;

%%
% Plot exp 3
Fig3 = figure('Name','Directional Error','NumberTitle','off');
fhandle = Fig3;
hold on;
for i = 1:8
    x = linspace(1,210,210);
    y = Data.Exp{3}.Sub{i}.parFinal - Data.Exp{3}.Sub{i}.parTarget;
    Fig1p3 = plot(x,y,'.b','Color','#A2142F','MarkerSize', 15);
end

box1=[-1 -1 60 60];
box2=[150 150 220 220];
boxy=[-1 1 1 -1]*70*1.2;
patch(box1,boxy,[0 0 0],'FaceAlpha',0.1)
patch(box2,boxy,[0 0 0],'FaceAlpha',0.1)


xline(90,'--','LineWidth',3)
yline(0,'--')
xlabel("Trial Number",'FontSize',15);
ylabel("Directional Error in Degree",'FontSize',15)
xlim([0 210])
ylim([-70 70])
legend(Fig1p3,{'Conflict Feeback'},'FontSize',15)
title('Conflict Feedback')
set(gca, 'Fontsize', 15)
set(gca,'Fontsize',30)
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;


%% Absolute Error

Fig3_Abs = figure('Name','Directional Error','NumberTitle','off');
fhandle = Fig3_Abs;
hold on;

raw_exp3 = zeros(8,210);

for i = 1:8
    raw_exp3(i,:) = abs(Data.Exp{3}.Sub{i}.parFinal - Data.Exp{3}.Sub{i}.parTarget);
end

mean_exp3 = zeros(1,210);

for i = 1:210
    mean_exp3(i) = mean(raw_exp3(:,i));
end 

std_exp3 = zeros(1,210);
std_exp3_up = zeros(1,210);
std_exp3_down = zeros(1,210);

for i = 1:210
    std_exp3(i) = std(raw_exp3(:,i));
    std_exp3_up(i) = std_exp3(i) + mean_exp3(i);
    std_exp3_down(i) = - std_exp3(i) + mean_exp3(i);
end 

inBetweenRegionX = [1:length(std_exp3_up), length(std_exp3_down):-1:1];
inBetweenRegionY = [std_exp3_up, fliplr(std_exp3_down)];
Fig3_Abs_fill = fill(inBetweenRegionX, inBetweenRegionY,'r', 'FaceAlpha', 0.3);

x = linspace(1,210,210);
Fig3_Abs_line = plot(x,mean_exp3,'-','Color','#A2142F','LineWidth',2);

xlim([0 210])
ylim([0 45])

box1=[-1 -1 60 60];
box2=[150 150 220 220];
boxy=[-1 1 1 -1]*70*1.2;
patch(box1,boxy,[0 0 0],'FaceAlpha',0.1)
patch(box2,boxy,[0 0 0],'FaceAlpha',0.1)

xline(90,'--','LineWidth',3)
yline(0,'--')
xlabel("Trial Number",'FontSize',15);
ylabel("Absolute Error in Degree",'FontSize',15)
legend(Fig3_Abs_line,{'Conflict Feeback'},'FontSize',15)
title('Conflict Feedback')
set(gca, 'Fontsize', 15)
set(gca,'Fontsize',30)
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;
%% Statistical Testing 

exp3_baseline = raw_exp3(:,1:60);
exp3_experimental = raw_exp3(:,151:210);

exp3_baseline_average_across_participant = zeros(1,60);
exp3_experimental_average_across_participant = zeros(1,60);

exp3_baseline_average_across_t = zeros(1,7);
exp3_experimental_average_across_t = zeros(1,7);

for i = 1:60
    exp3_baseline_average_across_participant(i) = mean(exp3_baseline(:,i));
    exp3_experimental_average_across_participant(i) = mean(exp3_experimental(:,i));
end 

for i = 1:7
    exp3_baseline_average_across_t(i) = mean(exp3_baseline(i,:));
    exp3_experimental_average_across_t(i) = mean(exp3_experimental(i,:));
end 

exp3_baseline_reshape = reshape(exp3_baseline,1,[]);
exp3_experimental_reshape = reshape(exp3_experimental,1 ,[]);

% Kolmogorov-Smirnov Test Normality Check
[exp3_base_h,exp3_base_p,exp3_base_ksstat,exp3_base_cv] = kstest(exp3_baseline_reshape)
[exp3_exp_h,exp3_exp_p,exp3_exp_ksstat,exp3_exp_cv] = kstest(exp3_experimental_reshape)



%%%%

%%
% Bartlett's test for Homogenity of Variance Across Subjects

[exp2_base_acrosstrials_p,exp2_base_acrosstrials_stats] = vartestn(exp3_baseline');
[exp2_exp_acrosstrials_p,exp2_exp_acrosstrials_stats] = vartestn(exp3_experimental');
%%
mean_base = mean(mean(exp3_baseline'))
mean_exp = mean(mean(exp3_experimental'))
std_base = std(mean(exp3_baseline'))
std_exp = std(mean(exp3_experimental'))
%% 
% Bartlett's test for Homogenity of Variance Across Subjects
[exp3_base_acrossSubject_p,exp3_base_acrossSubject_stats] = vartestn(exp3_baseline)
[exp3_exp_acrossSubject_p,exp3_exp_acrossSubject_stats] = vartestn(exp3_experimental)

%%

% Bartlett's test for Homogenity of Variance Across Subjects
[exp3_base_acrosstrials_p,exp3_base_acrosstrials_stats] = vartestn(exp3_baseline')
[exp3_exp_acrosstrials_p,exp3_exp_acrosstrials_stats] = vartestn(exp3_experimental')

%%

% One Way Anova Total 
one_way_anova = zeros(480,2);
one_way_anova(:,1) = exp3_baseline_reshape';
one_way_anova(:,2) = exp3_experimental_reshape';
[exp3_anova1_p,exp3_anova1_tbl, exp3_anova1_stats] = anova1(one_way_anova);

%%
% One Way Anova Across Subjects
one_way_anova_across_participants = zeros(60,2);
one_way_anova_across_participants(:,1) = exp3_baseline_average_across_participant';
one_way_anova_across_participants(:,2) = exp3_experimental_average_across_participant';
[exp3_anova1_p_a_p,exp3_anova1_tbl_a_p, exp3_anova1_stats_a_p] = anova1(one_way_anova_across_participants)
%%
% One Way Anova Across Trials
one_way_anova_across_t3 = zeros(7,2);
one_way_anova_across_t3(:,1) = exp3_baseline_average_across_t';
one_way_anova_across_t3(:,2) = exp3_experimental_average_across_t';
[exp3_anova1_p_a_t,exp3_anova1_tbl_a_t, exp3_anova1_stats_a_t] = anova1(one_way_anova_across_t3)

V = var(one_way_anova_across_t3)
M = mean(one_way_anova_across_t3)

%%
two_way = [one_way_anova_across_t1; one_way_anova_across_t3]
p = anova2(two_way,7)
%%

% Two Sample ttest
[h,p, ci, stat] = ttest2(exp3_baseline_average_across_t,exp3_experimental_average_across_t)
%%

fff = figure;
fhandle = fff;
hold on
[h_p111,p_p112,ci_p113,stat_p114] = ttest(exp3_baseline_average_across_t)
[h_p122,p_p123,ci_p122,stat_p124] = ttest(exp3_experimental_average_across_t)

% Bar
x = [1 2];
data = [mean(exp3_baseline_average_across_t) mean(exp3_experimental_average_across_t)]';
errhigh = [stat_p114.sd stat_p124.sd];
errlow  = [stat_p114.sd stat_p124.sd];

bar(x,data,'FaceColor','#A2142F','EdgeColor','#A2142F','LineWidth',1.5, 'FaceAlpha', 0.5)                
er = errorbar(x,data,errlow,errhigh);    
er.Color = '#A2142F';                            
er.LineStyle = 'none';  
er.LineWidth = 3;
name = {'Baseline';'Experimental'};
set(gca,'XTick',1:length(name),'XTickLabel',name, 'fontsize', 15)
ylabel('Absolute Error in Degree');
title('Condition 3: Conflict Feedback');
comtemporyx = linspace(0.75,2.25);
comtemporyy = linspace(0.75,2.25);
comtemporyy(:) = 9;
plot(comtemporyx, comtemporyy, '-k', 'LineWidth',4)
plot(1.425, 9.4, '*k')
plot(1.475, 9.4, '*k')
plot(1.525, 9.4, '*k')
plot(1.575, 9.4, '*k')
ylim([0 11])
title('Conflict Feedback')
set(gca, 'Fontsize', 15)
set(gca,'Fontsize',30)
set(fhandle, 'Position', [600, 100, 810, 540]); % set size and loction on screen
set(fhandle, 'Color','w') % set background color to white
legend off
hold off;

%% Anova 
one_way_anova_across_t = zeros(7,3);
one_way_anova_across_t(:,1) = exp3_baseline_average_across_t';
one_way_anova_across_t(:,2) = exp2_baseline_average_across_t';
one_way_anova_across_t(:,3) = exp1_baseline_average_across_t';
[base_p,base_tb, base_stats] = anova1(one_way_anova_across_t)
one_way_anova_across_t = zeros(7,3);
one_way_anova_across_t(:,1) = exp3_experimental_average_across_t';
one_way_anova_across_t(:,2) = exp2_experimental_average_across_t';
one_way_anova_across_t(:,3) = exp1_experimental_average_across_t';
[ex_p,ex_tb, ex_stats] = anova1(one_way_anova_across_t)