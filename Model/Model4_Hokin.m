%% Sensorimotor2022Jan11Model
% p = v + b
clear;
close all;
rng(7);
b = 0;             
quit = 1;
targetarray = [0 0];
for i = 1:20
    targetarray(i) = randi(30);
end 
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
    if ((pmap-vmap)~=(pmap-vonline))
         b = b + (pmap - vonline)/10;
    end 
    bmap(quit) = b;
    quit = quit + 1;
end
figure;
hold on ;
abserr = [0 0];
for i = 1:length(mcmap)
    abserr(i) = abs(vonlinearray(i) - targetarray(i));
end 
plot(mcmap, '-o', 'Color', 'green');
plot(targetarray, '-x', 'Color', 'red');
figure;
plot(abserr);
%plot(vonlinearray, '-*', 'Color', 'black');
%plot(proprioarray, '-.', 'Color', 'yellow');