%% ImplicitAdaptationFigures
% This code is used to statistically analyze data output by BUMProcessor.m,
% and produce raw figures for data presentation
%
% By Charles Xu @ UCSD
%
%% Initialize
load('allData.mat')

%% Figure 1 - dot plot for relative error of exp 1 and 2
% Used data: allFinal allTarget
f1dot = figure('Name','dot plot for relative error of exp 1 and 2','NumberTitle','off');
hold on

% Plot exp 1
for i = 1:8
    x = linspace(1,210,210);
    y = allFinal{1,1}{1,i} - allTarget{1,1}{1,i};
    p1 = plot(x,y,'.','Color','#0072BD','MarkerSize',10);
end

% Plot exp 2
for i = 1:8
    x = linspace(1,210,210);
    y = allFinal{1,2}{1,i} - allTarget{1,2}{1,i};
    p2 = plot(x,y,'.b','Color','#D95319','MarkerSize',10);
end

xline([60 90],'--')
yline(0,'--')
xlim([0 210])
ylim([-70 70])
legend([p1,p2],{'Experiment 1','Experiment 2'})
hold off

%% Figure 1 - line plot for absolute error of exp 1 and 2
% Used data: allFinal allTarget
f1line = figure('Name','line plot for absolute error of exp 1 and 2','NumberTitle','off');
hold on

% Plot exp 1
y = zeros(1,210);
for i = 1:8
    y = y + abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i});
end
x = linspace(1,210,210);
y = y/8;
p1 = plot(x,y,'.-','Color','#0072BD','MarkerSize',10);

clear x y

% Plot exp 2
y = zeros(1,210);
for i = 1:8
    y = y + abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i});
end
x = linspace(1,210,210);
y = y/8;
p2 = plot(x,y,'.-','Color','#D95319','MarkerSize',10);

clear x y

xline([60 90],'--')
yline(0,'--')
xlim([0 210])
ylim([0 35])
legend([p1,p2],{'Experiment 1','Experiment 2'})
hold off

%% Figure 1 - distribution of relative error test phase of exp 1 and 2
% Used data
f1histRel = figure('Name','distribution of relative error during test phase of exp 1 and 2','NumberTitle','off');
hold on

x = [];
for i = 1:8
    rel = (allFinal{1,1}{1,i} - allTarget{1,1}{1,i});
    rel = rel(1,91:end);
    x = [x rel];
end
p1 = histogram(x,[-70:2:70]);

y = [];
for i = 1:8
    rel = (allFinal{1,2}{1,i} - allTarget{1,2}{1,i});
    rel = rel(1,91:end);
    y = [y rel];
end
p2 = histogram(y,[-70:2:70]);

xlim([-70 70])
ylim([0 200])
legend([p1,p2],{'Experiment 1','Experiment 2'})
hold off

clear x y

%% Figure 2 - dot plot for relative error of exp 2 and 3
% Used data: allFinal allTarget
f2dot = figure('Name','dot plot for relative error of exp 2 and 3','NumberTitle','off');
hold on

% Plot exp 2
for i = 1:8
    x = linspace(1,210,210);
    y = allFinal{1,2}{1,i} - allTarget{1,2}{1,i};
    p1 = plot(x,y,'.','Color','#0072BD','MarkerSize',10);
end

% Plot exp 3
for i = 1:8
    x = linspace(1,210,210);
    y = allFinal{1,3}{1,i} - allTarget{1,3}{1,i};
    p2 = plot(x,y,'.b','Color','#D95319','MarkerSize',10);
end

xline([60 90],'--')
yline(0,'--')
xlim([0 210])
ylim([-70 70])
legend([p1,p2],{'Experiment 2','Experiment 3'})
hold off

%% Figure 2 - line plot for absolute error of exp 2 and 3
% Used data: allFinal allTarget
f2line = figure('Name','line plot for absolute error of exp 2 and 3','NumberTitle','off');
hold on

% Plot exp 2
y = zeros(1,210);
for i = 1:8
    y = y + abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i});
end
x = linspace(1,210,210);
y = y/8;
p1 = plot(x,y,'.-','Color','#0072BD','MarkerSize',10);

clear x y

% Plot exp 3
y = zeros(1,210);
for i = 1:8
    y = y + abs(allFinal{1,3}{1,i} - allTarget{1,3}{1,i});
end
x = linspace(1,210,210);
y = y/8;
p2 = plot(x,y,'.-','Color','#D95319','MarkerSize',10);

clear x y

xline([60 90],'--')
yline(0,'--')
xlim([0 210])
ylim([0 35])
legend([p1,p2],{'Experiment 2','Experiment 3'})
hold off

%% Figure 2 - distribution of relative error test phase of exp 2 and 3
% Used data: allFinal allTarget
f2histRel = figure('Name','distribution of relative error during test phase of exp 2 and 3','NumberTitle','off');
hold on

x = [];
for i = 1:8
    rel = (allFinal{1,2}{1,i} - allTarget{1,2}{1,i});
    rel = rel(1,91:end);
    x = [x rel];
end
p1 = histogram(x,[-70:2:70]);

y = [];
for i = 1:8
    rel = (allFinal{1,3}{1,i} - allTarget{1,3}{1,i});
    rel = rel(1,91:end);
    y = [y rel];
end
p2 = histogram(y,[-70:2:70]);

xlim([-70 70])
ylim([0 200])
legend([p1,p2],{'Experiment 2','Experiment 3'})
hold off

clear x y

%% Paired-samples t test for baseline vs test
% Used data: allFinal allTarget

% Exp 1
baseline1 = [];
test1 = [];
for i = 1:8
    par = abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i}); % Compare between absolute errors
    parBaseline = mean(par(1,1:90));
    baseline1 = [baseline1 parBaseline];
    parTest = mean(par(1,91:end));
    test1 = [test1 parTest];
end

meanBaseline1 = mean(baseline1);
stdBaseline1 = std(baseline1);
meanTest1 = mean(test1);
stdTest1 = std(test1);

[exp1h,exp1p] = ttest(baseline1,test1); % Paired-sample t test between baseline and test
exp1d = computeCohen_d(baseline1,test1); % Cohen's d for baseline vs test

% Note: according to Cohen and Sawilowsky:
% 
% d = 0.01 --> very small effect size
% d = 0.20 --> small effect size
% d = 0.50 --> medium effect size
% d = 0.80 --> large effect size
% d = 1.20 --> very large effect size
% d = 2.00 --> huge effect size

% Exp 2
baseline2 = [];
test2 = [];
for i = 1:8
    par = abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i}); % Compare between absolute errors
    parBaseline = mean(par(1,1:90));
    baseline2 = [baseline2 parBaseline];
    parTest = mean(par(1,91:end));
    test2 = [test2 parTest];
end

meanBaseline2 = mean(baseline2);
stdBaseline2 = std(baseline2);
meanTest2 = mean(test2);
stdTest2 = std(test2);

[exp2h,exp2p] = ttest(baseline2,test2); % Paired-sample t test between baseline and test
exp2d = computeCohen_d(baseline2,test2); % Cohen's d for baseline vs test

% Exp 3
baseline3 = [];
test3 = [];
for i = 1:8
    par = abs(allFinal{1,3}{1,i} - allTarget{1,3}{1,i}); % Compare between absolute errors
    parBaseline = mean(par(1,1:90));
    baseline3 = [baseline3 parBaseline];
    parTest = mean(par(1,91:end));
    test3 = [test3 parTest];
end

meanBaseline3 = mean(baseline3);
stdBaseline3 = std(baseline3);
meanTest3 = mean(test3);
stdTest3 = std(test3);

[exp3h,exp3p] = ttest(baseline3,test3); % Paired-sample t test between baseline and test
exp3d = computeCohen_d(baseline3,test3); % Cohen's d for baseline vs test

%% Figure 1 - barplot for experiments 1 and 2
xAxis = categorical({'Baseline' 'Test'});
xAxis = reordercats(xAxis,{'Baseline' 'Test'});
bars12 = [meanBaseline1 meanTest1; meanBaseline2 meanTest2];
err12 = [stdBaseline1 stdTest1; stdBaseline2 stdTest2];

f12bar = figure('Name','absolute error between baseline vs test in experiments 1 and 2','NumberTitle','off');
hold on
p1 = bar(xAxis,bars12);

[ngroups,nbars] = size(bars12); % Calculate the number of groups and number of bars in each group
xErr = nan(nbars, ngroups); % Get the x coordinate of the bars
for i = 1:nbars
    xErr(i,:) = p1(i).XEndPoints;
end

errorbar(xErr',bars12,err12,'Color','k','LineStyle','none')
hold off

%% Figure 2 - barplot for experiments 2 and 3
xAxis = categorical({'Baseline' 'Test'});
xAxis = reordercats(xAxis,{'Baseline' 'Test'});
bars23 = [meanBaseline2 meanTest2; meanBaseline3 meanTest3];
err23 = [stdBaseline2 stdTest2; stdBaseline3 stdTest3];

f23bar = figure('Name','absolute error between baseline vs test in experiments 2 and 3','NumberTitle','off');
hold on
p1 = bar(xAxis,bars23);

[ngroups,nbars] = size(bars23); % Calculate the number of groups and number of bars in each group
xErr = nan(nbars, ngroups); % Get the x coordinate of the bars
for i = 1:nbars
    xErr(i,:) = p1(i).XEndPoints;
end

errorbar(xErr',bars23,err23,'Color','k','LineStyle','none')
hold off

%% Two-way ANOVA for time (baseline and test) and experiments
% Used data: allFinal allTarget

latetest1 = [];
for i = 1:8
    par = abs(allFinal{1,1}{1,i} - allTarget{1,1}{1,i}); % Compare between absolute errors
    parLatetest = mean(par(1,121:end));
    latetest1 = [latetest1 parLatetest];
end

latetest2 = [];
for i = 1:8
    par = abs(allFinal{1,2}{1,i} - allTarget{1,2}{1,i}); % Compare between absolute errors
    parLatetest = mean(par(1,121:end));
    latetest2 = [latetest2 parLatetest];
end

latetest3 = [];
for i = 1:8
    par = abs(allFinal{1,3}{1,i} - allTarget{1,3}{1,i}); % Compare between absolute errors
    parLatetest = mean(par(1,121:end));
    latetest3 = [latetest3 parLatetest];
end

% Two-way ANOVA for experiments 1 vs 2
ANOVAData12 = [baseline1 latetest1; baseline2 latetest2]';
[exp12p,exp12table,exp12stats] = anova2(ANOVAData12,8);

% Two-way ANOVA for experiments 2 vs 3
ANOVAData23 = [baseline2 latetest2; baseline3 latetest3]';
[exp23p,exp23table,exp23stats] = anova2(ANOVAData23,8);

