%% Sensorimotor2022Jan11Model
% p = v + b
clear;
close all;
rng(34);
b = 0;
quit = 1;
targetarray = randperm(25,20);
targetarray(1) = -100;
targetarray(2) = 200;
rand
vmaparray = [0 0];
proprioarray = [0 0];
vonlinearray = [0 0];
ponlinearray = [0 0];
mcmap = zeros(length(targetarray));
bmap = zeros(length(targetarray));
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
    if((pmap-vmap)~=(pmap-vonline))
        b = b + (pmap - vonline)/10;
    end
    bmap(quit) = b;
    quit = quit + 1;
end
figure;
hold on;
plot(mcmap, '-o', 'Color', 'green');
plot(targetarray, '-x', 'Color', 'red');
plot(vonlinearray, '-*', 'Color', 'blue');
plot(proprioarray, '-.', 'Color', 'yellow');
