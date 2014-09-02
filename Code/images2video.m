function [ ] = images2video( imgs_dir )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if ~exist(imgs_dir,'dir')
    error('No a valid directory!');
end
listNativeImageFileNames = dir(imgs_dir);
imgsNames = {listNativeImageFileNames(3:end).name}'; clear listNativeImageFileNames;
imgsNames = sort(imgsNames);
noImgs = size(imgsNames,1);
folderName = dir(strcat(imgs_dir,'../'));
folderName = folderName(3).name;
close all;
writeObj = VideoWriter(strcat(imgs_dir,folderName,'.avi'));
open(writeObj);
Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');
%writerObj.Width = videoInfo.frame_w;
%writerObj.Height = videoInfo.frame_h;
i = 1;
HASMOREFILE = 1;
while HASMOREFILE
    imageDir = strcat(imgs_dir,num2str(i),'.jpg');
    if exist(imageDir,'file')
        img = imread(imageDir);
        writeVideo(writeObj,img); 
        i = i + 1;
    else
        HASMOREFILE = 0;
    end
end
close(writeObj);
close all;
end

