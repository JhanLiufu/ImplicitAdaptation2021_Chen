%% This code is for no-perturbation controller experiment.
%% Feedback type: online cursor feedback and endpoint feedback
% By Mengzhan Liufu, Januarary 2022 at Chen Juan's Lab at UChicago

%@targetmarix - pseudorandom target matrix, 4 per set
%@trialtrajectory - storing trajectory points
%% This code is for no-perturbation controller experiment.
%% Feedback type: online cursor feedback and endpoint feedback
% By Mengzhan Liufu, Januarary 2022 at Chen Juan's Lab at UChicago

%@targetarray - pseudorandom target array, 4 per set
%@trialtrajectory - storing trajectory points
%@[x,y] - trajectory points
%@[x1,y1] - target points

close all;
clearvars;
sca;
commandwindow;

%% Set up Arduino at COM4
a = arduino('COM4', 'Uno');
writeDigitalPin(a, 'D10', 1); % close

%% Set up keys
KbName('UnifyKeyNames');
SpaceKey=KbName('space');
EscapeKey=KbName('ESCAPE');
RestrictKeysForKbCheck([EscapeKey,SpaceKey]);

%% Open up the window
HideCursor;
PsychDefaultSetup(2);
AssertOpenGL;
screenNumber = max(Screen('Screens'));
[wPtr,rect]=Screen('OpenWindow',0);
[xCenter,yCenter] = WindowCenter(wPtr);

%% Introduction page
start_jpg = imread('img3.jpg');
start_img = Screen('MakeTexture',wPtr,start_jpg);
Screen('DrawTexture',wPtr,start_img);
Screen('Flip',wPtr);
KbStrokeWait;

%% Data Return for Experiment
currentfolder = pwd;
currentparticipant = "currentparticipant";
mkdir currentparticipant;
cd(currentparticipant);
currentparticipant = pwd;

writeDigitalPin(a, 'D10', 0); % open the goggle
cd(currentfolder);

%% Prepare Target Matrix
targetarray = zeros(40,1);
for i = 1:10
    targetsequence = randperm(4,4);
    for j = 1:4
        switch targetsequence(j)
            case 1
                targetarray((i-1)*4+j) = 1;
            case 2
                targetarray((i-1)*4+j) = 5;
            case 3
                targetarray((i-1)*4+j) = 6;
            otherwise
                targetarray((i-1)*4+j) = 10;
        end
    end
end

for i =1:40
    %% Show instruction note
    target_jpg = imread('img5.jpg');
    target_img = Screen('MakeTexture',wPtr,target_jpg);
    Screen('DrawTexture',wPtr,target_img);
    Screen('Flip',wPtr);

    KbStrokeWait;
    writeDigitalPin(a, 'D10', 1); % close

    %% Active hand relocation
    [x_find,y_find] = GetMouse(wPtr);
    d_find =sqrt((x_find-xCenter)^2+(y_find-yCenter)^2);
    while 1
        [touch,secs,KeyCode]=KbCheck;
        if KeyCode(SpaceKey)
           break;
           % break out when space key is pressed
        else
            % recalculate d_find
            [x_find,y_find] = GetMouse(wPtr);
            d_find =sqrt((x_find-xCenter)^2+(y_find-yCenter)^2);
            if d_find <= 50
                % play the sound stimulus when at center
                [stimulusaudio, frequency] = audioread('1.wav');
                sound(stimulusaudio, frequency);
            end
        end
    end

    % Draw the Framework
    n = targetarray(i);
    if n <= 5
        x1 = xCenter + 546.5*cosd(abs(7.5*(n-1)-15));
        y1 = yCenter + 546.5*sind(7.5*(n-1)-15);
    else
        x1 = xCenter - 546.5*cosd(abs(7.5*(n-6)-15));
        y1 = yCenter + 546.5*sind(7.5*(n-6)-15);
    end

    trialfilename = strcat("Trial",num2str(i));
    trialtrajectory = [0 0 0];
    trialestimation = [0 0 0];

    SetMouse(xCenter,yCenter,wPtr);
    d = 0;
    [x,y] = GetMouse(wPtr);

    trialtrajectory(1,2) = x;
    trialtrajectory(1,3) = y;
    counter = 1;

    writeDigitalPin(a, 'D10', 0); %open the goggle

    %% Reaching out with veridical cursor feedback
    while d <= 546.5
        [x,y] = GetMouse(wPtr);
        d=sqrt((x-xCenter)^2+(y-yCenter)^2);
        Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
        Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
        Screen('FillOval',wPtr,[255,0,0],[x-10,2*yCenter-y-10,x+10,2*yCenter-y+10]);
        Screen('Flip',wPtr)

        trialtrajectory(counter, 1)= counter;
        trialtrajectory(counter, 2)= x;
        trialtrajectory(counter, 3)= y;
        counter = counter + 1;
    end

    WaitSecs(1);
    %% No perturbation endpoint feedback
    Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
    Screen('FillOval',wPtr,[255,0,0],[x-10,2*yCenter-y-10,x+10,2*yCenter-y+10]);
    Screen('Flip',wPtr);
    KbStrokeWait;
      
    cd(currentparticipant);
    save(trialfilename, 'trialtrajectory', 'targetarray');
    cd(currentfolder);
end