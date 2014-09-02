% add necessary programmes
addpath('shape/');
addpath('auxiliary/');

% input dir
imgsDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/images_mat/';
pointsDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/points_mat/';
labelsDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/labels_mat/';

% ROI dir
ROIDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/ROI_mat/';
if ~exist(ROIDir,'dir')
    mkdir(ROIDir);
end

% processing to get file name
tmp = dir(imgsDir);
videoNames = {tmp(3:end).name}'; clear tmp;
videoNames = sort(videoNames);
noVideos = size(videoNames,1); % number of videos
fileNames = cell(noVideos,1);
for i = 1:noVideos
    fileNames{i} = videoNames{i}(1:end-4);
end
clear videoNames;

% initialization of model for remove head pose
PDM = shape_load_PDM();
mouthIndices = 32:49;
resolution = [16 64];
for i = 1:noVideos
    i
    % load imgs, pts, frame_idx, labels
    load(strcat(imgsDir,fileNames{i},'.mat'));
    load(strcat(pointsDir,fileNames{i},'.mat'));
    load(strcat(labelsDir,fileNames{i},'.mat'));
    %outputDir = 'C:/Users/Sidney/Desktop/4report/Intraface/160954/wapedImages/';
    % warping to img only with mouth
    [warpedImage,pts_new] = warping(imgs,pts,frame_idx,mouthIndices,PDM);
    
    % rescale pts
    pts_new = rescalePoints(pts_new,warpedImage,resolution);
    
    %resize imgs
    ROI = ScaleROI2FixedSize(warpedImage,resolution,[],0);
    outputFile = strcat(ROIDir,fileNames{i},'.mat');
    save(outputFile,'ROI','pts_new','frame_idx');
    
end
