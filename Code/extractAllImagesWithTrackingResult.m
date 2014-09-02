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
observDataDir = 'data/imagesObservation/';
if ~exist(observDataDir,'dir')
    mkdir(observDataDir);
end

%% Main Process
% auto matic initialize
[Models,option] = xx_initialize;

[nVideos, ~] = size(videoNames);
for i = 396
    [frames, videoInfo] = extractDataForObservation(strcat(labelDir,labelNames{i}),strcat(videoDir,videoNames{i}));
    writingDir = strcat(observDataDir,videoNames{i}(1:end-4),'/');
    if ~exist(writingDir,'dir')
        mkdir(writingDir);
    end
    close all;
    writerObj = VideoWriter(strcat(writingDir,videoNames{i}(1:end-4),'.avi'));
    open(writerObj);
    Z = peaks; surf(Z); 
    axis tight
    set(gca,'nextplot','replacechildren');
    set(gcf,'Renderer','zbuffer');
    %writerObj.Width = videoInfo.frame_w;
    %writerObj.Height = videoInfo.frame_h;
    for k=1:videoInfo.noFrames
        surf(sin(2*pi*k/20)*Z,Z)
        F = frames{k};
        imwrite(frame2im(F),strcat(writingDir,videoNames{i}(1:end-4),'_',num2str(k),'.jpg'));
        writeVideo(writerObj,F);
    end
    close(writerObj);
    close all;
end