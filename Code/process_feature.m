% suppress warning
warning('OFF');
% add necessary programmes
addpath('LBPs');

% ROI dir
ROIDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/ROI_mat/';

% feature dir
featuresDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/features_mat/1/';
if ~exist(featuresDir,'dir')
    mkdir(featuresDir);
end

% processing to get file name
tmp = dir(ROIDir);
videoNames = {tmp(3:end).name}'; clear tmp;
videoNames = sort(videoNames);
noVideos = size(videoNames,1); % number of videos
fileNames = cell(noVideos,1);
for i = 1:noVideos
    fileNames{i} = videoNames{i}(1:end-4);
end
clear videoNames;

for i = 1:noVideos
    i
    % load imgs, pts, frame_idx, labels
    load(strcat(ROIDir,fileNames{i},'.mat'));
    
    % set output file
    outputFile = strcat(featuresDir,fileNames{i},'.mat');
    
    %get appearance feature
    feature_appearance = getAppFeature(ROI,1);% divide ROI into serveral block
    
    %get Shape Feature
    feature_shape = getShapeFeature(pts_new);

    save(outputFile,'feature_appearance','feature_shape','frame_idx');
    
end
