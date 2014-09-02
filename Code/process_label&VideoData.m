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

% output path
videoDataPath = 'data/videoDataPath/';
if ~exist(videoDataPath,'dir')
    mkdir(videoDataPath);
end

%% Main Process
% auto matic initialize
[Models,option] = xx_initialize;

[nVideos, ~] = size(videoNames);
for i = 1:noVideo
    [videoData,label] = extractDataFromVideo(strcat(labelDir,labelNames{i}),strcat(videoDir,videoNames{i}));
    [labels.normal_face,...
        labels.eating,...
        labels.talking,...
        labels.looking_away,...
        labels.occluded,...
        labels.other_problem] = extractLabels(label);
    save(strcat(videoDataPath,videoNames{i}(1:end-4),'.mat'),'videoData','labels');
end
clear label;clear videoData;