%% This code is for no-perturbation controller experiment.
%% Feedback type: online cursor feedback
% By Mengzhan Liufu, November 2021 at Chen Juan's Lab at South China Normal
% University, Guangzhou.

%@targetarray - generating random targets, one per three degrees
%@trialtrajectory - storing trajectory points
%@trialestimation - storing direction estimation per trial
%@[x,y] - trajectory points
%@[x0,y0] - target points
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
targetarray = round(rand(1,30)*17)+1;

for j = 1:30
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
    n = targetarray(j);
    if n < 10
        x1 = xCenter+546.5*cosd(abs(n*3-15));
        y1 = yCenter+546.5*sind(n*3-15);
    else
        x1 = xCenter-546.5*cosd(abs((n-9)*3-15));
        y1 = yCenter+546.5*sind((n-9)*3-15);
    end

    trialfilename = strcat("Trial",num2str(j));
    trialtrajectory = [0 0 0];
    trialestimation = [0 0 0];

    SetMouse(xCenter,yCenter,wPtr);
    d = 0;
    [x,y] = GetMouse(wPtr);

    trialtrajectory(1,2) = x;
    trialtrajectory(1,3) = y;
    counter = 1;
    
    writeDigitalPin(a, 'D10', 0); %open the goggle
    
    %% Reaching out with mirror-reversed visual feedback
    while d <= 546.5
        Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
        Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.5*cosd(15),yCenter-546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.6*cosd(15),yCenter+546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.5*cosd(15),yCenter-546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.6*cosd(15),yCenter+546.5*sind(15),5);
        Screen('Flip',wPtr,[],1,[],[]);

        [x,y] = GetMouse(wPtr);
        Screen('FillOval',wPtr,[255,0,0],[x1-10,y1-10,x1+10,y1+10]);
        trialtrajectory(counter, 1)= counter;
        trialtrajectory(counter, 2)= x;
        trialtrajectory(counter, 3)= y;
        counter = counter + 1;

        d=sqrt((x-xCenter)^2+(y-yCenter)^2);
    end
    
    cd(currentparticipant);
    save(trialfilename, 'trialtrajectory', 'targetarray');
    cd(currentfolder);
end