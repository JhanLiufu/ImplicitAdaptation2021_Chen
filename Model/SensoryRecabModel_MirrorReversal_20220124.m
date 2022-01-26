%% Written by Jhan Liufu at UChicago to test model robustness over arbitary paramters

%% parameters
xCenter = 960;
yCenter = 540;

sigma = linspace(4,4+19*0.5,20);
eta = linspace(0.0003,0.0003+19*0.00005,20);
sat_limit = 15;
seed_rng =48;

sigma_noise = 2;
rng (seed_rng);

delta_c = 0.05;
c = -60:delta_c:60;
priop = -60:.5:60; 
w = zeros(size(c));

Ntrials = 120;
blocksize = 30;
blocknum = Ntrials/blocksize;

[u_out,y_out,te] = deal(NaN(1,Ntrials));
absoluteerror = zeros(length(sigma)*length(eta),Ntrials);
signederror = zeros(length(sigma)*length(eta),Ntrials);
visualerror = zeros(length(sigma)*length(eta),Ntrials);
taskerror = zeros(length(sigma)*length(eta),Ntrials);
prioperror = zeros(length(sigma)*length(eta),Ntrials);

%% Load visual targets data used in experiments
root_dir = pwd;
cd('RawData\');
vision = cell2mat(struct2cell(load("targetdata210trials.mat")));
cd(root_dir);
vision = vision(1:120);
possibleivusalgoals = [-12;-9;-6;-3;0;3;6;9;12;15];

%% Simulation
for k = 1:length(sigma)
    for j = 1:length(eta)
        w_sat_limit = sat_limit*delta_c/sigma(k)/sqrt(2*pi);
        %basis functions
        B = NaN(length(c),length(priop));
        for i=1:length(c)
            B(i,:) =  exp(-(priop-c(i)).^2/(2*sigma(k)^2));
        end
        priop_map = NaN(Ntrials,length(priop));
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
            prioperror((k-1)*length(eta)+j,i) = -(prioprime(i) - priopout(i));
            visualerror((k-1)*length(eta)+j,i) = -(onlinecursor(i)-vision(i));
            taskerror((k-1)*length(eta)+j,i) = -(priopout(i)-vision(i));
            % Absolute and signed Error
            absoluteerror((k-1)*length(eta)+j,i) = abs(priopout(i) - vision(i));
            signederror((k-1)*length(eta)+j,i) = priopout(i) - vision(i);
          
            % learning update
            w = w + eta(j)*prioperror((k-1)*length(eta)+j,i)*B(:,i_selected)';
        end
    end
end

%% Load real Exp3 baseline data
subject_list = linspace(1,9,9);
abserr_allsubject_raw = zeros(length(subject_list),3*blocksize);
abserr_allsubject_avg = zeros(3*blocksize,1);

cd('SelectedData\Experiment3\');
currentexperiment = pwd;
for i = 1:length(subject_list)
    cd(num2str(subject_list(i)));
    currentsubject = pwd;
    for j = 1:3
        currentblock = strcat('Block',num2str(j));
        cd(currentblock);
        target = cell2mat(struct2cell(load('Trial1.mat','targetarray')));
        for k = 1:blocksize
            currenttrial = strcat('Trial',num2str(j),'.mat');
            trajectory = cell2mat(struct2cell(load(currenttrial,'trialtrajectory')));
            trajsize = size(trajectory);
            final = trajsize(1);
            finalx = trajectory(final,2) - xCenter;
            finaly = trajectory(final,3) - yCenter;

            n = target(k);
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
            abserr_allsubject_raw(i,(j-1)*blocksize+k) = abserr;
        end
        cd(currentsubject);
    end
    cd(currentexperiment);
end

for i = 1:length(abserr_allsubject_avg)
    trialsum = 0;
    for j = 1:length(subject_list)
        trialsum = trialsum + abserr_allsubject_raw(j,i);
    end
    abserr_allsubject_avg(i,1) = trialsum/length(subject_list);
end

%% Run ANOVA btw exp3 baseline data and model simulated perturbation data
group = cell(1,length(abserr_allsubject_avg)+length(absoluteerror(1,:)));
for m = 1:length(abserr_allsubject_avg)
    group{1,m} = 'Baseline';
end

for m = (length(abserr_allsubject_avg)+1):(length(abserr_allsubject_avg)+length(absoluteerror(1,:)))
    group{1,m} = 'Perturbation';
end

anova_all = zeros(length(sigma),length(eta));
for i = 1:length(sigma)
    for j = 1:length(eta)
        current_perturbation = absoluteerror((i-1)*length(eta)+j,:);
        anova_mat = [abserr_allsubject_avg' current_perturbation];
        anova_all(length(sigma)-(i-1),j) = anova1(anova_mat,group,'off');
    end
end

anova_min = min(min(anova_all));
anova_max = max(max(anova_all));

%% Plot color coded ANOVA
color_upperbound = 256;
color_lowerbound = 1;

colorMap = parula(color_upperbound);
colormap(colorMap);

anova_intp = interp1([anova_min,anova_max], ...
                     [color_lowerbound,color_upperbound], ...
                     anova_all);
image(anova_intp);

yticks([2:2:20]); yticklabels([13:-1:4]);
xticks([2:2:20]); xticklabels([3:1:12])

xlabel('Learning rate, \eta(\times10^{-4})');
ylabel('Basis function width, \sigma(\circ)');
txt = sprintf('%d Degree asymptote',sat_limit); title(txt);

caxis([color_lowerbound,color_upperbound])
cb = colorbar('XTick',[color_lowerbound,color_upperbound/2,color_upperbound], ...
              'XTickLabel',{num2str(anova_min),num2str((anova_max+anova_min)/2),num2str(anova_max)});
cb.Label.String = 'p-value (ANOVA)';

% cd(root_dir);
% cd('Results\');
% filename = sprintf('Asymptote%dSimulationAnova',sat_limit);
% figfilename = strcat(filename,'_Jhan','20220126','_1','.png');
% saveas(gcf,figfilename);

%% Save simulation results
% cd(root_dir);
% cd('Model\');
% save(filename,"anova_all",'prioperror','abserr_allsubject_raw');
% cd(root_dir);

%% Scripts
function y = sigmoid_saturation(x,sat_limit)

y = sat_limit*erf(sqrt(pi)/2*x/sat_limit); end