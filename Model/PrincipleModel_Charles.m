%% Sensorimotor2022Jan11Model
% p = v + b
clear;
close all;
rng(40);
b = 0;
quit = 1;
targetarray = [0 0];
for i = 1:50
    targetarray(i) = randi(30);
end

% targetarray = randperm(25,200);

% targetarray(1) = -100;
% targetarray(2) = 200;

rand
vmaparray = [0 0];
proprioarray = [0 0];
vonlinearray = [0 0];
ponlinearray = [0 0];
mcmap = [0 0];
bmap = [0 0];
while quit < length(targetarray)
    target = targetarray(quit);
    h = rand;
    if h < 0.5 
        target = - target;
        targetarray(quit) = target;
    end 
    vmap = target;
    vmaparray(quit) = vmap;
    pmap = vmap + b;
    proprioarray(quit) = pmap;
    mc = pmap;
    mcmap(quit) = mc;
    vonline = pmap - 30;
    vonlinearray(quit) = vonline;
    %Update
    b = pmap + (pmap - (vonline + b)) - vmap;
    % = (pmap-vmap) + (pmap-vonline-b)
    %       b_old       b_new - b_old
    bmap(quit) = b;
    quit = quit + 1;
end

figure(3);
hold on;
plot(mcmap, '-o', 'Color', 'green');
plot(targetarray, '-x', 'Color', 'red');
plot(vonlinearray, '-*', 'Color', 'blue');
plot(proprioarray, '-.', 'Color', 'yellow');

figure(4);
hold on;
abserr = [0 0];
for i = 1:length(mcmap)
    abserr(i) = vonlinearray(i) - targetarray(i);
end
plot(abserr);