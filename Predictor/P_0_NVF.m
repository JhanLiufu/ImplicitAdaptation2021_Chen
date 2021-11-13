%% This code is for no-perturbation predictor experiment.
% By Mengzhan Liufu, July 2021 at Chen Juan's Lab at South China Normal
% University, Guangzhou.

%% Clear up Variables and Set Up New

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

%% Introduction Page
HideCursor;
PsychDefaultSetup(2);
AssertOpenGL;
screenNumber = max(Screen('Screens'));
[wPtr,rect]=Screen('OpenWindow',0);
[xCenter,yCenter] = WindowCenter(wPtr);

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

%% NVF Block 3
writeDigitalPin(a, 'D10', 0); % open the goggle
cd(currentfolder);
nvf_jpg = imread('nvf.jpg');
nvf_img = Screen('MakeTexture',wPtr,nvf_jpg);
Screen('DrawTexture',wPtr,nvf_img);
Screen('Flip',wPtr);
WaitSecs(2);
    
for j = 1 : 30
    % Show Instruction Note
    pl_jpg = imread('img5.jpg');
    pl_img = Screen('MakeTexture',wPtr,pl_jpg);
    Screen('DrawTexture',wPtr,pl_img);
    Screen('Flip',wPtr);
    
    KbStrokeWait;
    writeDigitalPin(a, 'D10', 1); % close
        
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
    WaitSecs(2);

    % Reach Out Movement
    trialfilename = strcat("Trial",num2str(j));
    trialtrajectory = [0 0 0];
    trialestimation = [0 0 0];

    SetMouse(xCenter,yCenter,wPtr);
    d = 0;
    [x,y] = GetMouse(wPtr);

    trialtrajectory(1,2) = x;
    trialtrajectory(1,3) = y;
    counter = 1;
    
    [stimulusaudio, frequency] = audioread('1.wav');
    sound(stimulusaudio, frequency);
    
    while d <= 546.5
        [x,y] = GetMouse(wPtr);
        trialtrajectory(counter, 1)= counter;
        trialtrajectory(counter, 2)= x;
        trialtrajectory(counter, 3)= y;
        counter = counter + 1;
        d=sqrt((x-xCenter)^2+(y-yCenter)^2);
    end
    
    [stimulusaudio, frequency] = audioread('1.wav');
    sound(stimulusaudio, frequency);
    writeDigitalPin(a, 'D10', 0); % open

    % Estimation
    ei_jpg = imread('img1.png');
    ei_img = Screen('MakeTexture',wPtr,ei_jpg);
    Screen('DrawTexture',wPtr,ei_img);
    Screen('Flip',wPtr);
    KbStrokeWait;

    SetMouse(xCenter,yCenter,wPtr);
    [x0,y0] = GetMouse();
    counter = 1;
    
    while 1
        [touch,secs,KeyCode]=KbCheck;
        if KeyCode(SpaceKey)
            buttonIsPressed=1;
            trialestimation(counter, 1)= counter;
            trialestimation(counter, 2)= x0;
            trialestimation(counter, 3)= y0;
            counter = counter+1;
            break;
        else
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);

            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.6*cosd(15),yCenter+546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.6*cosd(15),yCenter+546.5*sind(15),5);

            [x0,y0] = GetMouse();
            Screen('FillOval',wPtr,0,[x0-10,y0-10,x0+10,y0+10]);
            Screen('DrawLine',wPtr,[0,0,255],xCenter,yCenter,x0,y0,5); %Blue line
            Screen('Flip',wPtr);
        end
    end
    cd(currentparticipant);
    save(trialfilename, 'trialtrajectory', 'trialestimation');
    cd(currentfolder);
end