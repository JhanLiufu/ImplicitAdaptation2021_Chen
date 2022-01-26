%% This code is for collective data processing & presentation.
% By Charles Xu @ UCSD, adopted from "Controller data processing" by Hokin
% Deng at JHU
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
workingDirectory = erase(filePath,'BUMProcessor.m');
cd(workingDirectory);
if ~isfolder('FigOut')
   mkdir(FigOut)
end


%% Load all data and make plots
fAll1 = figure('Name','ErrorAll3Experiments','NumberTitle','off');
hold on;

fAll2 = figure('Name','AllTrajectory','NumberTitle','off');
hold on;

for i = 1:3 % 3 experiments
    cd(workingDirectory);
    currentExp = strcat(workingDirectory, 'Experiment', num2str(i), '/');
    cd(currentExp);
    
    for j = 1:8 % 8 participants per experiment
        currentSubj = strcat(currentExp, num2str(j), '/');
        cd(currentSubj);

        % Plot all trajectories
        for k = 1:7 % 7 blocks per participant
            
            if (k <= 3)
                currentBlock = strcat(currentSubj,'Block',num2str(k), '/');
                cd(currentBlock);
                target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));

                for l = 1:30 % 30 trials per block
                    figure(fAll2);

                    currentTrial = strcat(currentBlock, 'Trial',num2str(l),'.mat');
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

                    % Separate above and below
                    if (finalx > 0)
                        aboveFinal((k-1)*30+l) = atand(finaly/finalx);
                    end

                    if (targetx > 0)
                        aboveTarget((k-1)*30+l) = atand(targety/targetx);
                    end

                    if (finalx < 0)
                        belowFinal((k-1)*30+l) = atand(finaly/finalx);
                    end

                    if (targetx < 0)
                        belowTarget((k-1)*30+l) = atand(targety/targetx);
                    end
                end
                
            else
                currentBlock = strcat(currentSubj, 'Block', num2str(k), '/');
                cd(currentBlock);
                
                for l = 1:30
                    currentTrial = strcat(currentBlock, 'Trial',num2str(l),'.mat');
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

                    if i == 1
                        targety = -(targety - yCenter);
                    else
                        targety = targety - yCenter;
                    end

                    parFinal((k-1)*30+l) = atand(finaly/finalx);
                    parTarget((k-1)*30+l) = atand(targety/targetx);

                    if (finalx > 0)
                        aboveFinal((k-1)*30+l) = atand(finaly/finalx);
                    end 

                    if (targetx > 0)
                        aboveTarget((k-1)*30+l) = atand(targety/targetx);
                    end 

                    if (finalx < 0)
                        belowFinal((k-1)*30+l) = atand(finaly/finalx);
                    end

                    if (targetx < 0)
                        belowTarget((k-1)*30+l) = atand(targety/targetx);
                    end 
                end
            end
            cd ..;
            expFinal{1,j} = parFinal;
            expTarget{1,j} = parTarget;
            allFinal{1,i} = expFinal;
            allTarget{1,i} = expTarget;
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

        %% Absolute plot of Position
        f1 = figure('name','AbsolutePosition','NumberTitle','off','visible','off');
        plot(x, parFinal, "o", x, parTarget, "x");
        axis([0 210 -30 30]);
        xlabel("Trial Number");
        ylabel("Abs Degree");
        saveas(f1,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr')),'pdf');

        f2 = figure('name','AbsolutePosition_DifferentColor','NumberTitle','off','visible','off');
        plot(x, parFinal, "-*", "Color","green");
        hold on;
        plot(x, parTarget, "-o", "Color","blue");
        axis([0 210 -30 30]);
        xlabel("Trial Number");
        ylabel("Abs Degree");
        saveas(f2,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr_Color')),'pdf');

        %% Plotting Error (anti-clock wise would be positive)
        error = [0 0];
        for k = 1:210
        error(k) = parFinal(k) - parTarget(k);
        end

        f3 = figure('name','RelativeError_Scattered','NumberTitle','off','visible','off');
        plot(x, error, "*", "Color","red");
        xlabel("Trial Number");
        ylabel("directional error: anti-clockwise would be positive");
        saveas(f3,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_RelErr_Scattered')),'pdf');

        %% plot Abs Error
        abserr= [0 0];
        % for i = 1:210
        %     if error(i) < 180
        %             abserr(i) = abs(abs(error(i)));
        %         else
        %             abserr(i) = 360 - abs(abs(error(i)));
        %     end
        % end
        for k = 1:210
            abserr(k) = abs(error(k));
        end 

        f4 = figure('name','AbsoluteError','NumberTitle','off','visible','off');
        plot(x, abserr, "-o", "Color","blue");
        xlabel("Trial Number");
        ylabel("Absolute error");
        axis([0 220 0 50]);
        saveas(f4,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr')),'pdf');


        %% plot Above/Below Data
        f5 = figure('name','Above/below','NumberTitle','off','visible','off');
        plot(x, aboveFinal, "*", x, aboveTarget, "o", "Color","red");
        axis([0 220 -40 40]);
        hold on;
        plot(x, belowFinal, "*", x, belowTarget, "o", "Color","blue");
        xlabel("Trial Number");
        ylabel("Above in red, below in blue");
        saveas(f5,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AboveAndBelow')),'pdf');
        
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
        saveas(f6,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_DimShift')),'pdf');
        
        % Seperate Above and Below
        f7 = figure('name','Above','NumberTitle','off','visible','off');
        plot(x, aboveFinal, "*", x, aboveTarget, "o", "Color","red");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Above");
        saveas(f7,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Above')),'pdf');
        
        f8 = figure('name','Below','NumberTitle','off','visible','off');
        plot(x, belowFinal, "*", x, belowTarget, "o", "Color","blue");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Below");
        saveas(f8,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Below')),'pdf');

        %% Calculate Above/Below Error
        f9 = figure('name','AbsoluteError_Above','NumberTitle','off','visible','off');
        aboveerrorabs = abs(aboveFinal - aboveTarget);
        plot(x, aboveerrorabs, "-o", "Color","red");
        axis([0 220 0 40]);
        xlabel("Trial Number");
        ylabel("Above Error Absolute");
        saveas(f9,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr_Above')),'pdf');

        % Below Error
        f10 = figure('name','AbsoluteError_Below','NumberTitle','off','visible','off');
        belowerrorabs = abs(belowFinal - belowTarget);
        plot(x, belowerrorabs, "-o", "Color","green");
        axis([0 220 0 40]);
        xlabel("Trial Number");
        ylabel("Below Error Absolute");
        saveas(f10,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_AbsErr_Below')),'pdf');


        %% Learning direction considering Above/Below Seperately
        f11 = figure('name','RelativeError_Above','NumberTitle','off','visible','off');
        aber = aboveFinal - aboveTarget;
        plot(x, aber, "*", "Color","red");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Above Error Signed");
        saveas(f11,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_RelErr_Above')),'pdf');

        % Below Error
        f12 = figure('name','RelativeError_Below','NumberTitle','off','visible','off');
        beer = belowFinal - belowTarget;
        plot(x, beer, "o", "Color","blue");
        axis([0 220 -40 40]);
        xlabel("Trial Number");
        ylabel("Below Error Signed");
        saveas(f12,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_RelErr_Below')),'pdf');

        % Compress aber to compare error with the previous one.
        counter = 1;
        next = 1;
        aberdirection = [0 0];
        previous = 0;
        while (counter <= 210) 
            if (aber(counter) ~= 0) 
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
        saveas(f13,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_LearnDir_Above')),'pdf');

        counter = 1;
        next = 1;
        beerdirrection = [0 0];
        previous = 0;
        while (counter <= 210) 
            if (beer(counter) ~= 0) 
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
        saveas(f14,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_LearnDir_Below')),'pdf');

        % plot Them Together
        totalerrordirection = [0 0];
        counter = 1;
        benext = 1;
        abnext = 1;
        while (counter <= 210)
            if (beer(counter) ~= 0) 
                totalerrordirection(counter) = beerdirrection(benext); 
                benext = benext + 1;
            end
            if (aber(counter) ~= 0) 
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
        saveas(f15,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_LearnDir_All')),'pdf');

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
            currentBlock = strcat(currentSubj,'Block',num2str(k), '/');
            cd(currentBlock);
            f16to18 = figure('name',strcat('Trajectory_NoPerturbation_Block',k),'NumberTitle','off','visible','off');
            hold on;
            title(currentBlock);
            for l = 1:30
                currentTrial = strcat(currentBlock,'Trial',num2str(l),'.mat');
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
                if (finalx > 0)
                    blockabovefinal(k,l) = atand(finaly/finalx);
                end 
                if (targetx > 0)
                    blockabovetarget(k,l) = atand(targety/targetx);
                end 
                if (finalx < 0)
                    blockbelowfinal(k,l) = atand(finaly/finalx);
                end 
                if (targetx < 0)
                    blockbelowtarget(k,l) = atand(targety/targetx);
                end 
            end
            axis equal;
            saveas(f16to18,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Block',num2str(k),'_TrajNoPerturb')),'pdf');
            cd(workingDirectory);
        end

        for k = 4:7
            currentBlock = strcat(currentSubj, 'Block',num2str(k), '/');
            cd(currentBlock);
            target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
            f19to22 = figure('name',strcat('Trajectory_WithPerturbation_Block',k),'NumberTitle','off','visible','off');
            hold on;
            title(currentBlock);
            for l = 1:30
                currentTrial = strcat(currentBlock, 'Trial',num2str(l),'.mat');
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
                if (finalx > 0)
                    blockabovefinal(k,l) = atand(finaly/finalx);
                end 
                if (targetx > 0)
                    blockabovetarget(k,l) = atand(targety/targetx);
                end 
                if (finalx < 0)
                    blockbelowfinal(k,l) = atand(finaly/finalx);
                end 
                if (targetx < 0)
                    blockbelowtarget(k,l) = atand(targety/targetx);
                end 
            end
            axis equal;
            saveas(f19to22,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_Block',num2str(k),'_TrajWPerturb')),'pdf');
            cd(workingDirectory);
        end

        f23 = figure('name','Reaching_NoPerturbation','NumberTitle','off','visible','off');
        hold on;
        for k = 1:3
            x = linspace(1,30,30);
            plot(x, blockfinaldata(k,:));   
            plot(x, blocktargetdata(k,:), ':', 'LineWidth', 9);
        end 
        saveas(f23,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_ReachNoPerturb')),'pdf');

        
        f24 = figure('name','Reaching_WPerturbation','NumberTitle','off','visible','off');
        hold on;
        for k = 4:7
            x = linspace(1,30,30);
            plot(x, blockfinaldata(k,:));   
            plot(x, blocktargetdata(k,:), ':', 'LineWidth', 9);
        end
        saveas(f24,fullfile(workingDirectory,'figOut',strcat('Exp',num2str(i),'_Par',num2str(j),'_ReachWPerturb')),'pdf');

    end
end

saveas(fAll1,fullfile(workingDirectory,'figOut','RelErr_All3Expe'),'pdf');
saveas(fAll2,fullfile(workingDirectory,'figOut','trajectory_All3Expe'),'pdf');


