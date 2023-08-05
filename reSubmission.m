%% Resubmission Figures
% Xueqian Deng 2022

%% Initialize

clear
close all

xCenter = 960;
yCenter = 540;

filePath = matlab.desktop.editor.getActiveFilename;
workingDirectory = erase(filePath,'reSubmission.m');
cd(workingDirectory);

Data = struct;

figure;
for i = 1:3 % 3 experiments
    cd(workingDirectory);
    currentExp = fullfile(workingDirectory, strcat('Experiment',num2str(i)));
    cd(currentExp);
    Exp = struct;
    for j = 1:8 % 8 participants per experiment
        currentSubj = fullfile(currentExp, num2str(j));
        cd(currentSubj);
        Sub = struct;
        aboveFinal = zeros(210, 1);
        aboveTarget = zeros(210, 1);
        belowFinal = zeros(210, 1);
        belowTarget = zeros(210, 1);

        allFinal = [0 0];
        allTarget = [0 0];
        expFinal = [0 0];
        expTarget = [0 0];
        parFinal = [0 0];
        parTarget = [0 0];
        % Plot all trajectories
        for k = 1:7 % 7 blocks per participant
            evefinal = [0 0];
            evetarget = [0 0];
            abfinal = [0 0];
            befinal = [0 0];
            abtarget = [0 0];
            betarget = [0 0];
            if (k <= 3)
                currentBlock = fullfile(currentSubj, strcat('Block',num2str(k)));
                cd(currentBlock);
                target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
                for l = 1:30 % 30 trials per block
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
                    evefinal(l) = atand(finaly/finalx);
                    parTarget((k-1)*30+l) = atand(targety/targetx);
                    evetarget(l) = atand(targety/targetx);
                    % Separate above and below
                    if (finalx > 0)
                        aboveFinal((k-1)*30+l) = atand(finaly/finalx);
                        abfinal(l) =  atand(finaly/finalx);
                    end

                    if (targetx > 0)
                        aboveTarget((k-1)*30+l) = atand(targety/targetx);
                        abtarget(l) = atand(targety/targetx);
                    end

                    if (finalx < 0)
                        belowFinal((k-1)*30+l) = atand(finaly/finalx);
                        befinal(l) = atand(finaly/finalx);
                    end

                    if (targetx < 0)
                        belowTarget((k-1)*30+l) = atand(targety/targetx);
                        betarget(l) = atand(targety/targetx);
                    end
                end
                
            else
                currentBlock = fullfile(currentSubj, strcat('Block',num2str(k)));
                cd(currentBlock);
                
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

                    switch i
                        case 1
                            targety = -(targety - yCenter);
                        case 2
                            targety = -(targety - yCenter);
                        case 3
                            targety = targety - yCenter;
                    end

                    parFinal((k-1)*30+l) = atand(finaly/finalx);
                    evefinal(l) = atand(finaly/finalx);
                    parTarget((k-1)*30+l) = atand(targety/targetx);
                    evetarget(l) = atand(targety/targetx);

                    if (finalx > 0)
                        aboveFinal((k-1)*30+l) = atand(finaly/finalx);
                        abfinal(l) = atand(finaly/finalx);
                    end 

                    if (targetx > 0)
                        aboveTarget((k-1)*30+l) = atand(targety/targetx);
                        abtarget(l) = atand(targety/targetx);
                    end 

                    if (finalx < 0)
                        belowFinal((k-1)*30+l) = atand(finaly/finalx);
                        befinal(l) = atand(finaly/finalx);
                    end

                    if (targetx < 0)
                        belowTarget((k-1)*30+l) = atand(targety/targetx);
                        betarget(l) = atand(targety/targetx);
                    end 
                end
            end
            cd ..;
            Sub.blockfinal{k} = evefinal;
            Sub.blocktarget{k} = evetarget;
            Sub.aboveTarget{k} = abtarget;
            Sub.belowTarget{k} = betarget;
            Sub.aboveFinal{k} = abfinal;
            Sub.belowFinal{k} = befinal;
        end
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


%% Directional Error 

Fig1 = figure('Name','Directional Error','NumberTitle','off');
hold on;
% Plot exp 1
for i = 1:8
    x = linspace(1,210,210);
    y = Data.Exp{1}.Sub{i}.parFinal - Data.Exp{1}.Sub{i}.parTarget;
    Fig1p1 = plot(x,y,'.b','Color','#4DBEEE','MarkerSize',5);
end
% Plot exp 2
for i = 1:8
    x = linspace(1,210,210);
    y = Data.Exp{2}.Sub{i}.parFinal - Data.Exp{1}.Sub{i}.parTarget;
    Fig1p2 = plot(x,y,'.b','Color','#A2142F','MarkerSize',5);
end
% % Plot exp 3
% for i = 1:8
%     x = linspace(1,210,210);
%     y = Data.Exp{3}.Sub{i}.parFinal - Data.Exp{1}.Sub{i}.parTarget;
%     Fig1p3 = plot(x,y,'.b','Color','#77AC30','MarkerSize',5);
% end


xline(90,'--','LineWidth',3)
yline(0,'--')
xlabel("Trial Number",'FontSize',12);
ylabel("Relative Error/Degree",'FontSize',12)
xlim([0 210])
ylim([-70 70])
legend([Fig1p1,Fig1p2, Fig1p3],{'Endpoint Feeback','Online Feedback', 'Conflict Feedback'},'FontSize',12)
hold off

%% 
Fig2 = figure('Name', 'Target versus Reach', 'NumberTitle', 'off');
hold on;
% Plot exp 1
for i = 1:8
    for j = 1:3
    Fig2p1 = plot(Data.Exp{1}.Sub{i}.belowTarget{j},Data.Exp{1}.Sub{i}.belowFinal{j},'.b','Color','#4DBEEE','MarkerSize',15);
    end 
    for j = 4:7
    Fig2p2 = plot(Data.Exp{1}.Sub{i}.belowTarget{j},Data.Exp{1}.Sub{i}.belowFinal{j},'.b','Color','#77AC30','MarkerSize',15);
    end 
end


%% 
% %% Initialize
% clear;
% close all;
% 
% xCenter = 960;
% yCenter = 540;
% 
% Data = struct;
% 
% filePath = matlab.desktop.editor.getActiveFilename;
% workingDirectory = erase(filePath,'reSubmission.m');
% cd(workingDirectory);
% 
% %% Plot all Data Directional Error
% for i = 1:3 % 3 experiments
%     cd(workingDirectory);
%     currentExp = fullfile(workingDirectory, strcat('Experiment',num2str(i)));
%     cd(currentExp);
%     Exp = struct;
%     for j = 1:8 % 8 participants per experiment
%         currentSubj = fullfile(currentExp, num2str(j));
%         cd(currentSubj);
%         Sub = struct;
%         eveFinal = [0 0];
%         eveTarget = [0 0];
%         % Plot all trajectories
%         for k = 1:7 % 7 blocks per participant
%             parFinal = [0 0];
%             parTarget = [0 0];
%             aboveFinal = [0 0];
%             belowFinal = [0 0];
%             aboveTarget = [0 0];
%             belowTarget = [0 0];
%             if (k <= 3)
%                 currentBlock = fullfile(currentSubj, strcat('Block',num2str(k)));
%                 cd(currentBlock);
%                 target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
%                 for l = 1:30 % 30 trials per block
%                     currentTrial = fullfile(currentBlock,strcat('Trial',num2str(l),'.mat'));
%                     trajectory = cell2mat(struct2cell(load(currentTrial,'trialtrajectory')));
%                     trajsize = size(trajectory);
%                     final = trajsize(1);
%                     finalx = trajectory(final,2) - xCenter;
%                     finaly = trajectory(final,3) - yCenter;
% 
%                     n = target(l);
% 
%                     if n < 10
%                         targetx = xCenter+546.5*cosd(abs(n*3-15));
%                         targety = yCenter+546.5*sind(n*3-15);
%                     else
%                         targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
%                         targety = yCenter+546.5*sind((n-9)*3-15);
%                     end
% 
%                     targetx = targetx - xCenter;
%                     targety = targety - yCenter;
% 
%                     % All final and target
%                     parFinal(l) = atand(finaly/finalx);
%                     parTarget(l) = atand(targety/targetx);
%                     eveFinal((k-1)*30+l) = atand(finaly/finalx);
%                     eveTarget((k-1)*30+l) = atand(targety/targetx);
% 
%                     % Separate above and below
%                     if (finalx > 0)
%                         aboveFinal(l) = atand(finaly/finalx);
%                     end
% 
%                     if (targetx > 0)
%                         aboveTarget(l) = atand(targety/targetx);
%                     end
% 
%                     if (finalx < 0)
%                         belowFinal(l) = atand(finaly/finalx);
%                     end
% 
%                     if (targetx < 0)
%                         belowTarget(l) = atand(targety/targetx);
%                     end
%                 end
%                 
%             else
%                 currentBlock = fullfile(currentSubj, strcat('Block',num2str(k)));
%                 cd(currentBlock);
%                 
%                 for l = 1:30
%                     currentTrial = fullfile(currentBlock,strcat('Trial',num2str(l),'.mat'));
%                     trajectory = cell2mat(struct2cell(load(currentTrial,'trialtrajectory')));
%                     trajsize = size(trajectory);
%                     final = trajsize(1);
%                     finalx = trajectory(final,2) - xCenter;
%                     finaly = trajectory(final,3) - yCenter;
% 
%                     n = target(l);
% 
%                     if n < 10
%                         targetx = xCenter+546.5*cosd(abs(n*3-15));
%                         targety = yCenter+546.5*sind(n*3-15);
%                     else
%                         targetx = xCenter-546.5*cosd(abs((n-9)*3-15));
%                         targety = yCenter+546.5*sind((n-9)*3-15);
%                     end
% 
%                     targetx = targetx - xCenter;
% 
%                     if i == 1
%                         targety = -(targety - yCenter);
%                     else
%                         targety = targety - yCenter;
%                     end
% 
%                     parFinal(l) = atand(finaly/finalx);
%                     parTarget(l) = atand(targety/targetx);
%                     eveFinal((k-1)*30+l) = atand(finaly/finalx);
%                     eveTarget((k-1)*30+l) = atand(targety/targetx);
% 
%                     if (finalx > 0)
%                         aboveFinal(l) = atand(finaly/finalx);
%                     end 
% 
%                     if (targetx > 0)
%                         aboveTarget(l) = atand(targety/targetx);
%                     end 
% 
%                     if (finalx < 0)
%                         belowFinal(l) = atand(finaly/finalx);
%                     end
% 
%                     if (targetx < 0)
%                         belowTarget(l) = atand(targety/targetx);
%                     end 
%                 end
%             end
%             cd ..;
%             Sub.BlockFinal{k} = parFinal;
%             Sub.BlockTarget{k} = parTarget;
%             Sub.aboveFinal{k} = aboveFinal;
%             Sub.aboveTarget{k} = aboveTarget;
%             Sub.belowFinal{k} = belowFinal;
%             Sub.belowTarget{k} = belowTarget;
%         end
%         Exp.Sub{j} = Sub;
%         Exp.Sub{j}.evefinal = eveFinal;
%         Exp.Sub{j}.evetarget = eveTarget;
%     end 
%     Data.Exp{i} = Exp;
% end 
% 
% %% Target-Reach
% 
% Fig1 = figure('Name','Target versus Reach', 'NumberTitle', 'off');
% hold on;
% 
% for i = 1:7
%     plot(Data.Exp{1}.Sub{1}.BlockTarget{i}, Data.Exp{1}.Sub{1}.BlockFinal{i});
% end 
% 
% %% 
% Fig2 = figure('Name','Directional Error','NumberTitle','off');
% hold on;
% 
% % Plot exp 1
% for i = 1:8
%     x = linspace(1,210,210);
%     y = Data.Exp{1}.Sub{i}.evefinal - Data.Exp{1}.Sub{i}.evetarget;
%     p1 = plot(x,y,'.b','Color','#77AC30','MarkerSize',5);
% end

%%

% %% Figure 1 - dot plot for relative error of exp 1 and 2
% % Used data: allFinal allTarget
% f1dot = figure('Name','dot plot for relative error of exp 1 and 2','NumberTitle','off');
% hold on
% 
% % Plot exp 1
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,2}{1,i} - allTarget{1,2}{1,i};
%     p1 = plot(x,y,'.b','Color','#77AC30','MarkerSize',5);
% end
% 
% % Plot exp 2
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,1}{1,i} - allTarget{1,1}{1,i};
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
% legend([p1,p2],{'Experiment 1','Experiment 2'},'FontSize',12)
% hold off

% %% Figure 1 - line plot for absolute error of exp 1 and 2
% % Used data: allFinal allTarget
% f1line = figure('Name','line plot for absolute error of exp 1 and 2','NumberTitle','off');
% hold on
% 
% 
% % Plot exp 1
% y = zeros(1,210);
% for i = 1:8
%     y = y + abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i});
% end
% x = linspace(1,210,210);
% y = y/8;
% p1 = plot(x,y,'.-','Color','#77AC30','MarkerSize',15);
% 
% % Plot exp 2
% y = zeros(1,210);
% for i = 1:8
%     y = y + abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i});
% end
% x = linspace(1,210,210);
% y = y/8;
% p2 = plot(x,y,'.-','Color','#4DBEEE','MarkerSize',15);
% 
% clear x y
% 
% clear x y
% 
% xline(90,'--', 'LineWidth', 3)
% %xline(60,'--')
% yline(0,'--')
% xlim([0 210])
% ylim([0 35])
% xlabel("Trial Number",'FontSize',12)
% ylabel("Absolute Error/Degree", 'FontSize',12)
% legend([p1,p2],{'Experiment 1','Experiment 2'},'FontSize',12)
% hold off

%% 


% %% Figure 1 - dot plot for relative error of exp 1 and 2
% % Used data: allFinal allTarget
% f1dot = figure('Name','dot plot for relative error of exp 1 and 2','NumberTitle','off');
% hold on
% 
% % Plot exp 1
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,2}{1,i} - allTarget{1,2}{1,i};
%     p1 = plot(x,y,'.b','Color','#77AC30','MarkerSize',7);
% end
% 
% % Plot exp 2
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,1}{1,i} - allTarget{1,1}{1,i};
%     p2 = plot(x,y,'.','Color','#4DBEEE','MarkerSize',7);
% end
% 
% 
% xline(90,'--','LineWidth',3)
% % xline(60,'--')
% yline(0,'--')
% xlabel("Trial Number",'FontSize',12);
% ylabel("Relative Error/Degree",'FontSize',12)
% xlim([0 210])
% ylim([-70 70])
% legend([p1,p2],{'Experiment 1','Experiment 2'},'FontSize',12)
% hold off
% 
% %% Figure 1 - line plot for absolute error of exp 1 and 2
% % Used data: allFinal allTarget
% f1line = figure('Name','line plot for absolute error of exp 1 and 2','NumberTitle','off');
% hold on
% 
% 
% % Plot exp 1
% y = zeros(1,210);
% for i = 1:8
%     y = y + abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i});
% end
% x = linspace(1,210,210);
% y = y/8;
% p1 = plot(x,y,'.-','Color','#77AC30','MarkerSize',15);
% 
% % Plot exp 2
% y = zeros(1,210);
% for i = 1:8
%     y = y + abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i});
% end
% x = linspace(1,210,210);
% y = y/8;
% p2 = plot(x,y,'.-','Color','#4DBEEE','MarkerSize',15);
% 
% clear x y
% 
% clear x y
% 
% xline(90,'--', 'LineWidth', 3)
% %xline(60,'--')
% yline(0,'--')
% xlim([0 210])
% ylim([0 35])
% xlabel("Trial Number",'FontSize',12)
% ylabel("Absolute Error/Degree", 'FontSize',12)
% legend([p1,p2],{'Experiment 1','Experiment 2'},'FontSize',12)
% hold off
% 
% %% Figure 1 - distribution of relative error test phase of exp 1 and 2
% % Used data
% f1histRel = figure('Name','distribution of relative error during test phase of exp 1 and 2','NumberTitle','off');
% hold on
% 
% x = [];
% for i = 1:8
%     rel = (allFinal{1,1}{1,i} - allTarget{1,1}{1,i});
%     rel = rel(1,91:end);
%     x = [x rel];
% end
% p1 = histogram(x,[-70:2:70], 'FaceColor','#4DBEEE');
% 
% y = [];
% for i = 1:8
%     rel = (allFinal{1,2}{1,i} - allTarget{1,2}{1,i});
%     rel = rel(1,91:end);
%     y = [y rel];
% end
% p2 = histogram(y,[-70:2:70], 'FaceColor','#77AC30');
% 
% xlim([-80 80])
% ylim([0 220])
% legend([p1,p2],{'Experiment 1','Experiment 2'},'FontSize',12)
% hold off
% 
% clear x y
% 
% %% Figure 2 - dot plot for relative error of exp 2 and 3
% % Used data: allFinal allTarget
% f2dot = figure('Name','dot plot for relative error of exp 2 and 3','NumberTitle','off');
% hold on
% 
% % Plot exp 1
% %for i = 1:8
% %    x = linspace(1,210,210);
% %    y = allFinal{1,1}{1,i} - allTarget{1,1}{1,i};
% %    p1 = plot(x,y,'.','Color','#4DBEEE','MarkerSize',7);
% %end
% 
% % Plot exp 3
% for i = 1:8
%     x = linspace(1,210,210);
%     y = allFinal{1,3}{1,i} - allTarget{1,3}{1,i};
%     p3 = plot(x,y,'.b','Color','#A2142F','MarkerSize',7);
% end
% 
% xline(90,'--','LineWidth',3)
% yline(0,'--')
% xlabel("Trial Number", 'FontSize',12)
% ylabel("Relative Error/Degree",'FontSize',12)
% xlim([0 210])
% ylim([-50 50])
% legend([p3],{'Experiment 3'}, 'FontSize', 12)
% hold off
% 
% %% Figure 2 - line plot for absolute error of exp 2 and 3
% % Used data: allFinal allTarget
% f2line = figure('Name','line plot for absolute error of exp 2 and 3','NumberTitle','off');
% hold on
% 
% % Plot exp 2
% y = zeros(1,210);
% for i = 1:8
%     y = y + abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i});
% end
% x = linspace(1,210,210);
% y = y/8;
% p1 = plot(x,y,'.-','Color','#4DBEEE','MarkerSize',15);
% 
% clear x y
% 
% % Plot exp 3
% y = zeros(1,210);
% for i = 1:8
%     y = y + abs(allFinal{1,3}{1,i} - allTarget{1,3}{1,i});
% end
% x = linspace(1,210,210);
% y = y/8;
% p2 = plot(x,y,'.-','Color','#A2142F','MarkerSize',15);
% 
% clear x y
% 
% xline(90,'--')
% yline(0,'--')
% xlim([0 210])
% ylim([0 20])
% legend([p1,p2],{'Experiment 1','Experiment 3'}, 'FontSize',12)
% hold off
% 
% %% Figure 2 - distribution of relative error test phase of exp 2 and 3
% % Used data: allFinal allTarget
% f2histRel = figure('Name','distribution of relative error during test phase of exp 2 and 3','NumberTitle','off');
% hold on
% 
% x = [];
% for i = 1:8
%     rel = (allFinal{1,1}{1,i} - allTarget{1,1}{1,i});
%     rel = rel(1,91:end);
%     x = [x rel];
% end
% p1 = histogram(x,[-70:2:70], 'FaceColor','#4DBEEE');
% 
% y = [];
% for i = 1:8
%     rel = (allFinal{1,3}{1,i} - allTarget{1,3}{1,i});
%     rel = rel(1,91:end);
%     y = [y rel];
% end
% p2 = histogram(y,[-70:2:70], 'FaceColor','#A2142F');
% 
% xlim([-70 70])
% ylim([0 200])
% legend([p1,p2],{'Experiment 1','Experiment 3'})
% hold off
% 
% clear x y
% 
% %% Paired-samples t test for baseline vs test
% % Used data: allFinal allTarget
% 
% % Exp 1
% baseline1 = [];
% test1 = [];
% for i = 1:8
%     par = abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i}); % Compare between absolute errors
%     parBaseline = mean(par(1,1:90));
%     baseline1 = [baseline1 parBaseline];
%     parTest = mean(par(1,91:end));
%     test1 = [test1 parTest];
% end
% 
% meanBaseline1 = mean(baseline1);
% stdBaseline1 = std(baseline1);
% meanTest1 = mean(test1);
% stdTest1 = std(test1);
% 
% [exp1h,exp1p] = ttest(baseline1,test1); % Paired-sample t test between baseline and test
% exp1d = computeCohen_d(baseline1,test1); % Cohen's d for baseline vs test
% 
% % Note: according to Cohen and Sawilowsky:
% %
% % d = 0.01 --> very small effect size
% % d = 0.20 --> small effect size
% % d = 0.50 --> medium effect size
% % d = 0.80 --> large effect size
% % d = 1.20 --> very large effect size
% % d = 2.00 --> huge effect size
% 
% % Exp 2
% baseline2 = [];
% test2 = [];
% for i = 1:8
%     par = abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i}); % Compare between absolute errors
%     parBaseline = mean(par(1,1:90));
%     baseline2 = [baseline2 parBaseline];
%     parTest = mean(par(1,91:end));
%     test2 = [test2 parTest];
% end
% 
% meanBaseline2 = mean(baseline2);
% stdBaseline2 = std(baseline2);
% meanTest2 = mean(test2);
% stdTest2 = std(test2);
% 
% [exp2h,exp2p] = ttest(baseline2,test2); % Paired-sample t test between baseline and test
% exp2d = computeCohen_d(baseline2,test2); % Cohen's d for baseline vs test
% 
% % Exp 3
% baseline3 = [];
% test3 = [];
% for i = 1:8
%     par = abs(allFinal{1,3}{1,i} - allTarget{1,3}{1,i}); % Compare between absolute errors
%     parBaseline = mean(par(1,1:90));
%     baseline3 = [baseline3 parBaseline];
%     parTest = mean(par(1,91:end));
%     test3 = [test3 parTest];
% end
% 
% meanBaseline3 = mean(baseline3);
% stdBaseline3 = std(baseline3);
% meanTest3 = mean(test3);
% stdTest3 = std(test3);
% 
% [exp3h,exp3p] = ttest(baseline3,test3); % Paired-sample t test between baseline and test
% exp3d = computeCohen_d(baseline3,test3); % Cohen's d for baseline vs test
% 
% %% OKK 1 - barplot for experiments 1 and 2
% xAxis = categorical({'Experiment 1' 'Experiment 2' 'Experiment 3'});
% xAxis = reordercats(xAxis,{'Experiment 1' 'Experiment 2' 'Experiment 3'});
% bars12 = [meanBaseline2 meanTest2; meanBaseline1 meanTest1;meanBaseline3 meanTest3];
% err12 = [stdBaseline2 stdTest2; stdBaseline1 stdTest1;stdBaseline3 stdTest3];
% 
% f12bar = figure('Name','absolute error between baseline vs test in experiments 1 and 2','NumberTitle','off');
% hold on
% p1 = bar(xAxis,bars12);
% 
% [ngroups,nbars] = size(bars12); % Calculate the number of groups and number of bars in each group
% xErr = nan(nbars, ngroups); % Get the x coordinate of the bars
% for i = 1:nbars
%     xErr(i,:) = p1(i).XEndPoints;
% end
% 
% errorbar(xErr',bars12,err12,'Color','k','LineStyle','none','LineWidth',3)
% legend({'Baseline' 'Test'},'FontSize',12)
% ylabel("Absolute Error/Degree", 'FontSize',12)
% set(findall(gcf,'-property','FontSize'),'FontSize',12)
% hold off
% 
% %% Figure 2 - barplot for experiments 2 and 3
% xAxis = categorical({'Experiment 1' 'Experiment 3'});
% xAxis = reordercats(xAxis,{'Experiment 1' 'Experiment 3'});
% bars23 = [meanBaseline1 meanTest1; meanBaseline3 meanTest3];
% err23 = [stdBaseline1 stdTest1; stdBaseline3 stdTest3];
% 
% f23bar = figure('Name','absolute error between baseline vs test in experiments 2 and 3','NumberTitle','off');
% hold on
% p1 = bar(xAxis,bars23);
% 
% [ngroups,nbars] = size(bars23); % Calculate the number of groups and number of bars in each group
% xErr = nan(nbars, ngroups); % Get the x coordinate of the bars
% for i = 1:nbars
%     xErr(i,:) = p1(i).XEndPoints;
% end
% 
% errorbar(xErr',bars23,err23,'Color','k','LineStyle','none')
% legend({'Baseline' 'Test'})
% hold off
% 
% %% Figure 23 - barplot for experiments 2 and 3
% xAxis = categorical({'Experiment 3'});
% xAxis = reordercats(xAxis,{'Experiment 3'});
% bars3 = [meanBaseline3 meanTest3];
% err3 = [stdBaseline3 stdTest3];
% 
% f23bar = figure('Name','absolute error between baseline vs test in experiments 2 and 3','NumberTitle','off');
% hold on
% p1 = bar(xAxis,bars3);
% 
% [ngroups,nbars] = size(bars3); % Calculate the number of groups and number of bars in each group
% xErr = nan(nbars, ngroups); % Get the x coordinate of the bars
% for i = 1:nbars
%     xErr(i,:) = p1(i).XEndPoints;
% end
% 
% errorbar(xErr',bars3,err3,'Color','k','LineStyle','none')
% legend({'Baseline' 'Test'})
% hold off
% %% Two-way ANOVA for time (baseline and test) and experiments
% % Used data: allFinal allTarget
% 
% latetest1 = [];
% for i = 1:8
%     par = abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i}); % Compare between absolute errors
%     parLatetest = mean(par(1,121:end));
%     latetest1 = [latetest1 parLatetest];
% end
% 
% latetest2 = [];
% for i = 1:8
%     par = abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i}); % Compare between absolute errors
%     parLatetest = mean(par(1,121:end));
%     latetest2 = [latetest2 parLatetest];
% end
% 
% latetest3 = [];
% for i = 1:8
%     par = abs(allFinal{1,3}{1,i} - allTarget{1,3}{1,i}); % Compare between absolute errors
%     parLatetest = mean(par(1,121:end));
%     latetest3 = [latetest3 parLatetest];
% end
% 
% % Two-way ANOVA for experiments 1 vs 2
% ANOVAData12 = [baseline1 latetest1; baseline2 latetest2]'; % Columns: experiment; rows: time
% [exp12p,exp12table,exp12stats] = anova2(ANOVAData12,8);
% 
% % Two-way ANOVA for experiments 2 vs 3
% ANOVAData23 = [baseline2 latetest2; baseline3 latetest3]'; % Columns: experiment; rows: time
% [exp23p,exp23table,exp23stats] = anova2(ANOVAData23,8);
% 
% 
% % Two-way ANOVA for experiments 2 vs 3
% ANOVAData3 = [baseline3 latetest3]'; % Columns: experiment; rows: time
% [exp3p,exp3table,exp3stats] = anova2(ANOVAData23,8);
% 
% %% Save figures
% 
% saveas(f1dot,'F2A.pdf')
% saveas(f1line,'F2C.pdf')
% saveas(f1histRel,'F2B.pdf')
% saveas(f12bar,'F2D.pdf')
% saveas(f2dot,'F3A.pdf')
% saveas(f2line,'F3C.pdf')
% saveas(f2histRel,'F3B.pdf')
% saveas(f23bar,'F3D.pdf')

%% 
% ps = polyshape([0 0 4 8],[1 0 0 4]);
% pg = plot(ps);
% pg.FaceAlpha = 0.5;
% lw = pg.LineWidth;
