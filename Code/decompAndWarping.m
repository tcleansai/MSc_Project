addpath('shape/');
addpath('auxiliary/');
imgsDir = 'data/images_mat/';
tmp = dir(imgsDir);
videoNames = {tmp(3:end).name}'; clear tmp;
videoNames = sort(videoNames);

noVideos = size(videoNames,1);
fileNames = cell(noVideos,1);
for i = 1:noVideos
    fileNames{i} = videoNames{i}(1:end-4);
end
clear videoNames;
pointsDir = 'data/points_mat/';
if ~exist('data/pts_new_v2/','dir')
    mkdir('data/pts_new_v2/');
end

PDM = shape_load_PDM();
for i = 1:20
    load(strcat(imgsDir,fileNames{i},'.mat'));
    load(strcat(pointsDir,fileNames{i},'.mat'));
    outputDir = strcat('data/WarpedImage_V2/',fileNames{i},'/');
    if ~exist(outputDir,'dir')
        mkdir(outputDir);
    end
    [warpedImage,pts_new] = warping(imgs,pts,frame_idx,PDM,outputDir);
    tmp = strcat('data/pts_new_v2/',fileNames{i},'.mat');
    save(tmp,'pts_new'); 
end
