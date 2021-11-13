%% This code is for no-perturbation controller experiment.
% By Mengzhan Liufu, July 2021 at Chen Juan's Lab at South China Normal
% University, Guangzhou.

%@targetarray - generating random targets, one per three degrees
%@trialtrajectory - storing trajectory points
%@trialestimation - storing direction estimation per trial
%@[x,y] - trajectory points
%@[x0,y0] - target points
%% Clear up Variables and Set Up New
close all;
clearvars;
sca;
commandwindow;

%% Set up keys

KbName('UnifyKeyNames');
SpaceKey=KbName('space');
EscapeKey=KbName('ESCAPE');
RestrictKeysForKbCheck([EscapeKey,SpaceKey]);

HideCursor;
PsychDefaultSetup(2);
AssertOpenGL;
screenNumber = max(Screen('Screens'));
[wPtr,rect]=Screen('OpenWindow',0);
[xCenter,yCenter] = WindowCenter(wPtr);

start_jpg = imread('img3.png');
start_img = Screen('MakeTexture',wPtr,start_jpg);
Screen('DrawTexture',wPtr,start_img);
Screen('Flip',wPtr);
KbStrokeWait;

%% Data Return for Experiment

currentfolder = pwd;
mkdir("currentparticipant");
currentparticipant = "currentparticipant";
cd(currentparticipant);
currentparticipant = pwd;

%% Familiarization Block 1 - 2
for i = 1:2
    cd(currentfolder);
    targetarray = round(rand(1,30)*17)+1;
    
    familiarization_jpg = imread('familiarization.jpg');
    familiarization_img = Screen('MakeTexture',wPtr,familiarization_jpg);
    Screen('DrawTexture',wPtr,familiarization_img);
    Screen('Flip',wPtr);
    WaitSecs(1);
    
    cd(currentparticipant);
    currentblock = strcat("Block", num2str(i));
    mkdir(currentblock);
    cd(currentblock);
    currentblock = pwd;
    
    for j = 1:30
        cd(currentfolder);
        % Show instruction note
        target_jpg = imread('img5.png');
        target_img = Screen('MakeTexture',wPtr,target_jpg);
        Screen('DrawTexture',wPtr,target_img);
        Screen('Flip',wPtr);
        KbStrokeWait;
        
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
        
        while d <= 546.5
            Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.6*cosd(15),yCenter+546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.6*cosd(15),yCenter+546.5*sind(15),5);
            Screen('Flip',wPtr,[],1,[],[]);
            
            [x,y] = GetMouse(wPtr);
            trialtrajectory(counter, 1)= counter;
            trialtrajectory(counter, 2)= x;
            trialtrajectory(counter, 3)= y;
            counter = counter + 1;
            
            d=sqrt((x-xCenter)^2+(y-yCenter)^2);
        end
        
        ti_jpg = imread('targetinstruction.jpg');
        ti_img = Screen('MakeTexture',wPtr,ti_jpg);
        Screen('DrawTexture',wPtr,ti_img);
        Screen('Flip',wPtr);
        WaitSecs(1);
        
        Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.5*cosd(15),yCenter-546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.6*cosd(15),yCenter+546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.5*cosd(15),yCenter-546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.6*cosd(15),yCenter+546.5*sind(15),5);
        Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
        Screen('DrawLine',wPtr,[255,0,0],xCenter,yCenter,x,2*yCenter-y,5);
        Screen('Flip',wPtr);
        WaitSecs(2);
        
        cd(currentblock);
        save(trialfilename, 'trialtrajectory', 'targetarray');
        cd(currentparticipant);
    end
end

%% No visual feedback block
for i = 3
    cd(currentfolder);
    targetarray = round(rand(1,30)*17)+1;
    
    nvf_jpg = imread('nvf.jpg');
    nvf_img = Screen('MakeTexture',wPtr,nvf_jpg);
    Screen('DrawTexture',wPtr,nvf_img);
    Screen('Flip',wPtr);
    WaitSecs(1);
    
    
    cd(currentparticipant);
    currentblock = strcat("Block", num2str(i));
    mkdir(currentblock);
    cd(currentblock);
    currentblock = pwd;
    
    for j = 1:30
        cd(currentfolder);
        % Show instruction note
        target_jpg = imread('img5.png');
        target_img = Screen('MakeTexture',wPtr,target_jpg);
        Screen('DrawTexture',wPtr,target_img);
        Screen('Flip',wPtr);
        KbStrokeWait;
        
        % Draw the Framework
        n = targetarray(j);
        if n < 10
            x1 = xCenter+546.5*cosd(abs(n*3-15));
            y1 = yCenter+546.5*sind(n*3-15);
        else
            x1 = xCenter-546.5*cosd(abs((n-9)*3-15));
            y1 = yCenter+546.5*sind((n-9)*3-15);
        end
        
        %         trialfilename = "Trial" + num2str(j);
        trialtrajectory = [0 0 0];
        trialestimation = [0 0 0];
        
        SetMouse(xCenter,yCenter,wPtr);
        d = 0;
        [x,y] = GetMouse(wPtr);
        
        trialtrajectory(1,2) = x;
        trialtrajectory(1,3) = y;
        counter = 1;
        
        while d <= 546.5
            Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.6*cosd(15),yCenter+546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.6*cosd(15),yCenter+546.5*sind(15),5);
            Screen('Flip',wPtr,[],1,[],[]);
            
            [x,y] = GetMouse(wPtr);
            trialtrajectory(counter, 1)= counter;
            trialtrajectory(counter, 2)= x;
            trialtrajectory(counter, 3)= y;
            counter = counter + 1;
            
            d=sqrt((x-xCenter)^2+(y-yCenter)^2);
            cd(currentblock);
            save(trialfilename, 'trialtrajectory', 'targetarray');
            cd(currentparticipant);
        end
    end
end

%% Pertubation blocks
for i = 4:6
    cd(currentfolder);
    targetarray = round(rand(1,30)*17)+1;
    perturbation_jpg = imread('perturbation.jpg');
    perturbation_img = Screen('MakeTexture',wPtr,perturbation_jpg);
    Screen('DrawTexture',wPtr,perturbation_img);
    Screen('Flip',wPtr);
    WaitSecs(1);
    cd(currentparticipant);
    currentblock = strcat("Block", num2str(i));
    mkdir(currentblock);
    cd(currentblock);
    currentblock = pwd;
    for j = 1:30
        cd(currentfolder);
        % Show instruction note
        target_jpg = imread('img5.png');
        target_img = Screen('MakeTexture',wPtr,target_jpg);
        Screen('DrawTexture',wPtr,target_img);
        Screen('Flip',wPtr);
        KbStrokeWait;
        
        % Draw the Framework
        n = targetarray(j);
        if n < 10
            x1 = xCenter+546.5*cosd(abs(n*3-15));
            y1 = yCenter+546.5*sind(n*3-15);
        else
            x1 = xCenter-546.5*cosd(abs((n-9)*3-15));
            y1 = yCenter+546.5*sind((n-9)*3-15);
        end
        
        %         trialfilename = "Trial" + num2str(j);
        trialtrajectory = [0 0 0];
        trialestimation = [0 0 0];
        
        SetMouse(xCenter,yCenter,wPtr);
        d = 0;
        [x,y] = GetMouse(wPtr);
        
        trialtrajectory(1,2) = x;
        trialtrajectory(1,3) = y;
        counter = 1;
        
        while d <= 546.5
            Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.6*cosd(15),yCenter+546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.5*cosd(15),yCenter-546.5*sind(15),5);
            Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.6*cosd(15),yCenter+546.5*sind(15),5);
            Screen('Flip',wPtr,[],1,[],[]);
            
            [x,y] = GetMouse(wPtr);
            trialtrajectory(counter, 1)= counter;
            trialtrajectory(counter, 2)= x;
            trialtrajectory(counter, 3)= y;
            counter = counter + 1;
            
            d=sqrt((x-xCenter)^2+(y-yCenter)^2);
        end
        
        ti_jpg = imread('targetinstruction.jpg');
        ti_img = Screen('MakeTexture',wPtr,ti_jpg);
        Screen('DrawTexture',wPtr,ti_img);
        Screen('Flip',wPtr);
        WaitSecs(1);
        
        Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.5*cosd(15),yCenter-546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter+546.6*cosd(15),yCenter+546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.5*cosd(15),yCenter-546.5*sind(15),5);
        Screen('DrawLine',wPtr,[0,0,0],xCenter,yCenter,xCenter-546.6*cosd(15),yCenter+546.5*sind(15),5);
        Screen('FillOval',wPtr,[0,0,255],[x1-10,y1-10,x1+10,y1+10]);
        Screen('DrawLine',wPtr,[255,0,0],xCenter,yCenter,x,2*yCenter-y,5);
        Screen('Flip',wPtr);
        WaitSecs(2);
        cd(currentblock);
        save(trialfilename, 'trialtrajectory', 'targetarray');
        cd(currentparticipant);
    end
end