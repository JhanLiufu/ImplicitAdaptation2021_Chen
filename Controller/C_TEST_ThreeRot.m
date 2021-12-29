%% This Code is for targeted reach-out experiment with visuomotor rotation
%% Random presentation of 4 feedback types: 0, 5, 15, 30 degree clockwise rotation
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
   rotsequence = randperm(4,4);
   rotationmatrix(i,1) = rotsequence(1);
   rotationmatrix(i,2) = rotsequence(2);
   rotationmatrix(i,3) = rotsequence(3);
   rotationmatrix(i,4) = rotsequence(4);
end

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
        
        %% Stage 1 Reach: cursor feedback on, target off
        while d <= 189
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
            [x,y] = GetMouse(wPtr);
            [x_rot, y_rot] = rotate(2*xCenter-x, 2*yCenter-y, rot_degree);
            Screen('FillOval',wPtr,[255,0,0],[x_rot-10,y_rot-10,x_rot+10,y_rot+10]);

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
        
        %% Stage 2 Reach: cursor feedback on, target on
        while (d > 189 && d <= 546.5)
            Screen('FrameArc',wPtr,0,[xCenter-546.5,yCenter-546.5,xCenter+546.5,yCenter+546.5],0,360,5);
            Screen('FillOval',wPtr,[0,0,255],[x1-10,2*yCenter-y1-10,x1+10,2*yCenter-y1+10]);
            [x,y] = GetMouse(wPtr);
            [x_rot, y_rot] = rotate(2*xCenter-x, 2*yCenter-y, rot_degree);
            Screen('FillOval',wPtr,[255,0,0],[x_rot-10,y_rot-10,x_rot+10,y_rot+10]);

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


% ---------------------- scripts ------------------------------

function [x_rot, y_rot] = rotate(x, y, degree)
    % Input mirror reversed GetMouse() coords, so subject always see
    % non-reversed clockwise rotated cursor feedback
    %param x: **mirror reversed** hand x coord
    %param y: **mirror reversed** hand y coord
    %param degree: rotate clockwise by * degrees
    %return [x_rot, y_rot]: [x, y] rotated around Center by * degree
    x_c = abs(x-xCenter);
    y_c = abs(y-yCenter);
    hand_angle = atand(x_c/y_c);
    base_angle = (180-degree)/2;
    base_length = (546.5*sind(degree/2))*2;
    if (x>=xCenter && y>=yCenter)
        calc_angle = 180-base_angle-hand_angle;
        x_rot = x + base_length*cosd(calc_angle);
        y_rot = y - base_length*sind(calc_angle);
    elseif (x>xCenter && y<yCenter)
        calc_angle = 180-base_angle-(90-hand_angle);
        x_rot = x + base_length*sind(calc_angle);
        y_rot = y - base_length*cosd(calc_angle);
    elseif (x<xCenter && y>yCenter)
        calc_angle = 180-base_angle-(90-hand_angle);
        x_rot = x + base_length*sind(calc_angle);
        y_rot = y + base_length*cosd(calc_angle);
    else
        calc_angle = 180-base_angle-hand_angle;
        x_rot = x - base_length*cosd(calc_angle);
        y_rot = y + base_length*sind(calc_angle);
    end
end