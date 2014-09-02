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
fileNames = cell(size(videoNames));
for i = 1:size(videoNames,1)
    fileNames{i} = videoNames{i}(1:end-4);
    labelNames{i} = strcat(videoNames{i}(1:end-4),'_labels.csv');
end

%% output dir
outputPathPts = 'data/points_mat/';
outputPathImgs = 'data/images_mat/';
outputPathLabels = 'data/labels_mat/';
if ~exist(outputPathPts,'dir')
    mkdir(outputPathPts);
end
if ~exist(outputPathImgs,'dir')
    mkdir(outputPathImgs);
end
if ~exist(outputPathLabels,'dir')
    mkdir(outputPathLabels);
end

% intialization for extract videos
[Models,option] = xx_initialize;

noVideos = size(videoNames);

for i = 375%1:noVideos
    [videoData, label] = extractDataFromVideo(strcat(labelDir,labelNames{i}),strcat(videoDir,videoNames{i}));
    [imgs,frame_idx,pts] = getDataFromVideoData(videoData);
    [labels.normal_face,...
    labels.eating,...
    labels.talking,...
    labels.looking_away,...
    labels.occluded,...
    labels.other_problem] = extractLabels(label);
    save(strcat(outputPathImgs,fileNames{i},'.mat'),'imgs');
    save(strcat(outputPathPts,fileNames{i},'.mat'),'pts','frame_idx');
    save(strcat(outputPathLabels,fileNames{i},'.mat'),'labels');
end
