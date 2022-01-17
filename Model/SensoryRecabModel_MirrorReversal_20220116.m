sigma =6;
eta =0.0001;
sat_limit =18;
seed_rng =48;

sigma_noise = 2;
txt = sprintf('Kernel Width=%f\nAsymptote=%f\nLearning rate=%f',sigma,sat_limit,eta);
rng (seed_rng); % fix randomization so simulations are reproducible

% initiate basis functions
delta_c = 0.05;
c = -60:delta_c:60;
priop = -60:.5:60; 
w = zeros(size(c));
% proprio is the kernel of proprioception

% Learning (note that Ntrials is more than needed to simulate Experiment 2,
% which is 24 cycles (168 trials, i.e. 7 targets x 24 trials; and steady-state
% analysis uses cycles 13:24)
Ntrials = 120;
blocksize = 30;
blocknum = Ntrials/blocksize;

[u_out,y_out,te] = deal(NaN(1,Ntrials));

root_dir = pwd;
% Load targets used in experiments
cd('RawData\');
vision = cell2mat(struct2cell(load("targetdata210trials.mat")));
cd(root_dir);
vision = vision(1:120);
possibleivusalgoals = [-12;-9;-6;-3;0;3;6;9;12;15];
w_sat_limit = sat_limit*delta_c/sigma/sqrt(2*pi);

%basis functions
B = NaN(length(c),length(priop));
for i=1:length(c)
    B(i,:) =  exp(-(priop-c(i)).^2/(2*sigma^2));
end

priop_map = NaN(Ntrials,length(priop));
absoluteerror = [0 0];
signederror = [0 0];
visualerror = [0 0];
taskerror = [0 0];
for i=1:Ntrials
    priop_map(i,:) = priop + sigmoid_saturation(w,w_sat_limit)*B;
    % current map
    
    [~,i_t] = min((priop-vision(i)).^2);
    %supposedly output
    
    priopout(i) = priop_map(i,i_t) + sigma_noise*randn;
    %add randomness
    
    % apply perturbation
    onlinecursor(i) = - priopout(i); % mirroring
    [~,i_thokin] = min((priop-onlinecursor(i)).^2);
    prioprime(i) = priop_map(i,i_thokin) + sigma_noise*randn;
    [~,i_selected] = min(abs(priop-vision(i)));
    
    %priop and visual error
    prioperror(i) = -(prioprime(i) - priopout(i));
    visualerror(i) = -(onlinecursor(i)-vision(i));
    taskerror(i) = -(priopout(i)-vision(i));
    % Absolute and signed Error
    absoluteerror(i) = abs(priopout(i) - vision(i));
    signederror(i) = priopout(i) - vision(i);
    
    % learning update
    w = w + eta*prioperror(i)*B(:,i_selected)';
    %w = w + eta*visualerror(i)*B(:,i_selected)';
    %w = w + eta*taskerror(i)*B(:,i_selected)';
end

lins = lines;
figure; 
hold on;
mycolor = colormap("jet");
xlim_right = 60;
ylim_up = 60;
plot(linspace(-80,80,161),linspace(-80,80,161),'--','color','black');
for i = 1:Ntrials
    plot(linspace(-60,60,241),priop_map(i,:),'color',mycolor(round(i*(length(mycolor)/Ntrials)),:));
end
xlim([-xlim_right,xlim_right]);
ylim([-ylim_up,ylim_up]);
%title('Proprio-Visual Sensory Map (visual error)');
title('Proprio-Visual Sensory Map (proprio error)');
text(15-xlim_right,ylim_up-15,txt);
caxis([0,Ntrials]);
c=colorbar;
c.Label.String = 'Trial Number';
xlabel('Proprioceptive Cue');
ylabel('Visual Cue');

cd('Results\');
saveas(gcf,'MirrorReversalModelSensoryMapChange_LauFoo_20220116_1.png');
%saveas(gcf,'MirrorReversalModelSensoryMapChange_LauFoo_20220116_2.png');
cd(root_dir);

reachbyblock = zeros(blocknum,blocksize);
for i = 1:blocknum
    for j = 1:blocksize
        reachbyblock(i,j) = priopout((i-1)*blocksize+j);
    end
end

figure; 
hold on;
grid on;
caxis([1,blocknum]);
mycolor2 = colormap('autumn');
c3=colorbar('XTick',1:1:4,'XTickLabel',{'1','2','3','4'});
c3.Label.String = 'Block Number';
for i = 1:blocknum
    RGB = mycolor2(round((i/blocknum)*length(mycolor2)),:);
    plot(reachbyblock(i,:),'color',RGB,'LineWidth',1.5);
end

xlabel('Trial # (Within Block)');
ylabel('Reach Direction');
%title('Reach Direction By Block (with Visual Error)');
title('Reach Direction By Block (with proprio error)');

cd('Results\');
saveas(gcf,'MirrorReversalModelReacByBlock_LauFoo_20220116_1.png');
%saveas(gcf,'MirrorReversalModelReacByBlock_LauFoo_20220116_2.png');
cd(root_dir);

figure;
hold on;
xlabel('Trial Number');
ylabel('Degree');
ylim_up = 30;
ylim([-ylim_up,ylim_up]);
plot(priopout,'Color','r');
plot(vision,'Color','b');
text(10,ylim_up-5,txt);
title('Reaching movement across trial (with proprio error)');
%title('Reaching movement across trial (with visual error)');
legend('Hand angle','Target angle');

cd('Results\');
saveas(gcf,'MirrorReversalModelHandVersusTarget_LauFoo_20220116_1.png');
%saveas(gcf,'MirrorReversalModelHandVersusTarget_LauFoo_20220116_2.png');
cd(root_dir);

figure; 
hold on;
plot(signederror);
xlabel('Trial Number');
ylabel('Error Degree (Clockwise is Positive)');
title('Signed Error Across Trial (with proprio error)');
%title('Signed Error Across Trial (with visual error)');

cd('Results\');
saveas(gcf,'MirrorReversalModelSignedError_LauFoo_20220116_1.png');
%saveas(gcf,'MirrorReversalModelSignedError_LauFoo_20220116_2.png');
cd(root_dir);

figure; 
hold on;
plot(absoluteerror);
xlabel('Trial Number');
ylabel('Absolute Error Degree');
title('Absolute Error Across Trial (with proprio error)');
%title('Absolute Error Across Trial (with visual error)');

cd('Results\');
saveas(gcf,'MirrorReversalModelAbsoluteError_LauFoo_20220116_1.png');
%saveas(gcf,'MirrorReversalModelAbsoluteError_LauFoo_20220116_2.png');
cd(root_dir);

reachbytarget = zeros(9,1);
targetidx = zeros(Ntrials,1);
blocksize = 30;
blocknum = length(onlinecursor)/blocksize;

for i = 1:length(onlinecursor)
    targetidx(i) = round(5+vision(i)/3);
    reachbytarget(targetidx(i),end+1) = priopout(i);
end

reachbytarget_size = size(reachbytarget);
reachbytarget_len = reachbytarget_size(1);
reachbytarget_width = reachbytarget_size(2);
avg_reach_bytarget = zeros(length(reachbytarget_len),blocknum);

for i = 1:reachbytarget_len
    for j = 1:blocknum
        valid_num = 0;
        reach_sum = 0;
        for k = 1:blocksize
            if(reachbytarget(i,(j-1)*30+k)~=0)
                valid_num = valid_num + 1;
                reach_sum  = reach_sum + reachbytarget(i,(j-1)*30+k);
            end
        end
        avg_reach_bytarget(i,j) = reach_sum/valid_num;
    end
end

figure; 
hold on;
xlabel('Target Direction');
ylabel('Reach Direction');
text(-10,25,txt);
grid on;

plot(linspace(-12,12,9),linspace(-12,12,9),'Color','black','LineWidth',1.5,'LineStyle','--');
caxis([1,blocknum]);
mycolor3 = colormap('hsv');
c3=colorbar('XTick',1:1:4,'XTickLabel',{'1','2','3','4'});
c3.Label.String = 'Block Number';

up_slope = zeros(blocknum,1);
up_offset = zeros(blocknum,1);

for i=1:blocknum
    RGB = mycolor3(round((i/blocknum)*length(mycolor)),:);
    scatter(linspace(-12,12,9),avg_reach_bytarget(:,i),50,RGB,'filled','o');
    p = polyfit(linspace(-12,12,9),avg_reach_bytarget(:,i),1);
    up_slope(i) = p(1);
    up_offset(i) = p(2);
    y_fitted = polyval(p,linspace(-12,12,9));
    plot(linspace(-12,12,9),y_fitted,'Color',RGB,'LineWidth',1.5);
end
%title('Reach Direction versus Target Direction (with visual error)');
title('Reach Direction versus Target Direction (with proprio error)');

cd('Results\');
saveas(gcf,'MirrorReversalModelReachByTarget_LauFoo_20220116_1.png');
%saveas(gcf,'MirrorReversalModelReachByTarget_LauFoo_20220116_2.png');
cd(root_dir);

figure; 
hold on;
grid on;
subplot(1,2,1);
bar(up_slope);
title('Expansion (with visual error)');
xlabel('Block Number');
ylabel('Slope');

subplot(1,2,2);
bar(abs(up_offset));
%title('Shift (with visual error)');
title('Shift (with proprio error)');
xlabel('Block Number');
ylabel('Abs. of offset');

cd('Results\');
saveas(gcf,'MirrorReversalModelSlopeOffset_LauFoo_20220116_1.png');
%saveas(gcf,'MirrorReversalModelSlopeOffset_LauFoo_20220116_2.png');
cd(root_dir);

function y = sigmoid_saturation(x,sat_limit)

y = sat_limit*erf(sqrt(pi)/2*x/sat_limit); end