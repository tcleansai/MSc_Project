clear;
%% set paths
% video path
videoDir = 'data/videos/';
listNativeVideoFileNames = dir(videoDir);
videoNames = {listNativeVideoFileNames(3:end).name}'; clear listNativeVideoFileNames;
videoNames = sort(videoNames);

% label path
labelDir = 'data/labels/';
labelNames = cell(size(videoNames));
for i = 1:size(videoNames,1)
    labelNames{i} = strcat(videoNames{i}(1:end-4),'_labels.csv');
end


%for i = 1:size(videoNames,1)
%    videoNames{i}  = videoNames{i}(1:end-4);
%end
% isequal(labelNames, videoNames)

% output path
frameData = 'data/framesAll/';
if ~exist(frameData,'dir')
    mkdir(frameData);
end

%% Main Process
% auto matic initialize
[Models,option] = xx_initialize;

[nVideos, ~] = size(videoNames);
for i = 1:nVideos
    video = strcat(videoDir,videoNames{i});

    % check video
    if exist(video,'file') == 2 % if it is a file
      cap = cv.VideoCapture(video);
    else
      error('video file not exist');
    end
    % initial data extraction
    stop_pressed = false;
    count = 1;
    writingDir = strcat(frameData,videoNames{i}(1:end-4),'/');
    if ~exist(writingDir,'dir')
        mkdir(writingDir);
    end

    %% tracking and detection
    % a while loop is used because OpenCV's 'get_number_frames' has a bug
    % Press 'Esc' to quit.
    while true && ~stop_pressed
        % tic
        % read image
        im = cap.read;  
        if isempty(im), 
         warning('EOF'); 
          break ;
        end
        imwrite(im,strcat(writingDir,num2str(count,'%04i'),'.jpg'));
        count = count + 1;
    end
    close all;
end