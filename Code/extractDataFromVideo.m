function [videoData,label] = extractDataFromVideo(labelPath, video)
disp(strcat('extacting: ',video));
label = dlmread(labelPath,';',1,0);
[noFrames,~] = size(label);
[Models,option] = xx_initialize;

% check video
if exist(video,'file') == 2 % if it is a file
  cap = cv.VideoCapture(video);
else
  error('video file not exist');
end

% initial data extraction
stop_pressed = false;
output.pred = [];   % prediction set to null enabling detection
videoData = cell(noFrames,1);
count = 1;

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
    % main function for tracking. previous prediction is used as an input to
    % initialize the tracker for the next frame.
    output = xx_track_detect(Models,im,output.pred,option);
    % te = toc;
    videoData{count}.im = im;
    videoData{count}.pred = output.pred;
    videoData{count}.pose = output.pose;
    %videoData{count}.conf = output.conf;
    %videoData{count}.conf = output.lambda;
    count = count + 1;
end
end





