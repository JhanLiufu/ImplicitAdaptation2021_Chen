%% This Code is for targeted reach-out experiment
%% No Visual Feedback block: no feedback
% By Mengzhan Liufu, January 2022 at UChicago

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

%% Generate target array
targetmatrix = zeros(4,10);
for i = 1:4
    targetsequence = randperm(10,10);
    for j = 1:10
        targetmatrix(i,j) = targetsequence(j);
    end
end

rotationmatrix = zeros(10,4);
for i = 1:10
    for j = 1:4
        rotationmatrix(i,j) = 4;
    end
end
% have a rotationmatrix for baseline block so same analysis code can be
% applied to all block types; also easier to maintain experiment codes

%% Introduction page
start_jpg = imread('img3.jpg');
start_img = Screen('MakeTexture',wPtr,start_jpg);
Screen('DrawTexture',wPtr,start_img);
Screen('Flip',wPtr);
KbStrokeWait;

%% Save Data
currentfolder = pwd;
currentparticipant = "currentparticipant";
mkdir currentparticipant;
cd(currentparticipant);
currentparticipant = pwd;

%% Trial Body
writeDigitalPin(a, 'D10', 0); % open the goggle
cd(currentfolder);

for i = 1:4
    for j = 1:10
        %% Target and rotation degree for currenttrial
        target_num = targetmatrix(i,j); % target #
        if target_num <=5
            target_x = xCenter + 546.5*cosd(abs(7.5*(target_num-1)-15));
            target_y = yCenter + 546.5*sind(7.5*(target_num-1)-15);
        else
            target_x = xCenter - 546.5*cosd(abs(7.5*(target_num-6)-15));
            target_y = yCenter + 546.5*sind(7.5*(target_num-6)-15);
        end

        rot_num = rotationmatrix(target,i); % rotation degree #
        rot_degree = 0;
        switch rot_num
            case 1
                rot_degree = 5;
            case 2
                rot_degree = 15;
            case 3
                rot_degree = 30;
        end

        %% Show instruction note
        target_jpg = imread('img5.jpg');
        target_img = Screen('MakeTexture',wPtr,target_jpg);
        Screen('DrawTexture',wPtr,target_img);
        Screen('Flip',wPtr);
        
        KbStrokeWait;
        writeDigitalPin(a, 'D10', 1); % close the goggle
            
        %% Active blind relocation
        [x_find,y_find] = GetMouse(wPtr);
        d_find =sqrt((x_find-xCenter)^2+(y_find-yCenter)^2);
        while 1
            [touch,secs,KeyCode]=KbCheck;
            if KeyCode(SpaceKey)
               break;
            else
                [x_find,y_find] = GetMouse(wPtr);
                d_find =sqrt((x_find-xCenter)^2+(y_find-yCenter)^2);
                if d_find <= 50
                    % play the sound stimulus when at center
                    [stimulusaudio, frequency] = audioread('1.wav');
                    sound(stimulusaudio, frequency);
                end
            end
        end
        
        trialfilename = strcat("Trial",num2str(j));
        trialtrajectory = [0 0 0];

        SetMouse(xCenter,yCenter,wPtr);
        d = 0;
        [x,y] = GetMouse(wPtr);
    
        trialtrajectory(1,2) = x;
        trialtrajectory(1,3) = y;
        counter = 1;

        writeDigitalPin(a, 'D10', 0); % open the goggle
        
        %% Stage 1 Reach: veridical feedback on, target off
        while d <= 189
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
            [x,y] = GetMouse(wPtr);

            trialtrajectory(counter, 1)= counter;
            trialtrajectory(counter, 2)= x;
            trialtrajectory(counter, 3)= y;
            counter = counter + 1;

            d=sqrt((x-xCenter)^2+(y-yCenter)^2);
            %Screen('Flip',wPtr,[],1,[],[]);
            Screen('Flip',wPtr);
        end

        [stimulusaudio, frequency] = audioread('1.wav');
        sound(stimulusaudio, frequency);
        
        %% Stage 2 Reach: veridical feedback on, target on
        while (d > 189 && d <= 546.5)
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
            Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
            [x,y] = GetMouse(wPtr);

            trialtrajectory(counter, 1)= counter;
            trialtrajectory(counter, 2)= x;
            trialtrajectory(counter, 3)= y;
            counter = counter + 1;

            d=sqrt((x-xCenter)^2+(y-yCenter)^2);
            %Screen('Flip',wPtr,[],1,[],[]);
            Screen('Flip',wPtr);
        end
        
        WaitSecs(2);
        
        %% Endpoint feedback
        Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
        Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
        Screen('FillOval',wPtr,[255,0,0],[x-10,2*yCenter-y-10,x+10,2*yCenter-y+10]);
        KbStrokeWait;
        Screen('Flip',wPtr);
        
        %% Save data
        cd(currentparticipant);
        save(trialfilename, 'trialtrajectory', 'targetmatrix', 'rotationmatrix');
        cd(currentfolder);
    end
end