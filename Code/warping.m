function [warpedImage,pts_new] = warping(imgs,pts,frame_idx,ptsIndices,PDM)
%    
% Input:
%   imgs: cell(noFrames, 1) each cell contain one frame
%   pts: matrix noFrames X noPoints X noDim(2)
%   frame_idx: array with frame index with points
%   ptsIndices: array contain point indices that is necessary
%   PDM: model for decomposition
% Output:
%   warpedImage: warped images
%   pts_new: corresponding points

% remove pts space without pts 
pts = pts(frame_idx,:,:);

% frame number of frame tracked
noFrames = numel(frame_idx);
pts_new = zeros(size(pts));
for i = 1:noFrames
    % get global points and local points
    [pglobl, plocal, PDM] = shape_decomp([pts(i,:,1),pts(i,:,2)],PDM);
    
    % set head pose to 0
    pglobl_new = pglobl;
    pglobl_new(2:4) = 0;
    
    % calculate new head pose at format [x1,x2...,y1,y2...]
    s_new = shape_reconstr(pglobl_new,plocal,PDM);
    pts_new(i,:,1) = s_new(1:49);
    pts_new(i,:,2) = s_new(50:98);
end
%deformedPts = pts_new;
%save(strcat(outputDir,'deformedPoints.mat'),'deformedPts');
warpedImage = cell(noFrames,1);
pts_new = pts_new(:,ptsIndices,:);
for i = 1:noFrames
    pts_new(i,:,1) = pts_new(i,:,1)-min(pts_new(i,:,1))+1;
    pts_new(i,:,2) = pts_new(i,:,2)-min(pts_new(i,:,2))+1;
end
%cmap = colormap('gray');
for i = 1:noFrames
    resolution = calResolution(pts_new(i,:,:));
    image = double(rgb2gray(imgs{frame_idx(i)}));
    triangles = round(delaunay(squeeze(pts(i,ptsIndices,1)), squeeze(pts(i,ptsIndices,2)))); 
    texture_base = getTextureBase(squeeze(pts_new(i,:,:)), triangles, resolution);
    warpedImage{i} = warpImage(squeeze(pts_new(i,:,:)),texture_base,...
        triangles,resolution,squeeze(pts(i,ptsIndices,:)),image,'bilinear');
    %print(warpedImage{i},'-dpng',strcat(outputDir,num2str(frame_idx(i)),'.png'));
    warpedImage{i} = mat2gray(warpedImage{i},[0 255]);
    %imwrite(mat2gray(warpedImage{i},[0 255]),strcat(outputDir,num2str(frame_idx(i)),'.png'),'png');
end
% noFrames = size(imgs,1);
% noPoints = size(ptsIndices,2);
% imgs_new = cell(noFrames,1);
% for i = 1:size(frame_idx,2)
%     imgs_new{frame_idx(i)} = warpedImage{i};
% end
% tmp = pts_new(:,:,:);
% pts_new = zeros(noFrames,noPoints,2);
% pts_new(frame_idx,:,:) = tmp;
end
function [resolution] =calResolution(pts)
pts = squeeze(pts);
minX = min(pts(:,1));
maxX = max(pts(:,1));
minY = min(pts(:,2));
maxY = max(pts(:,2));
resX = ceil(maxX - minX + 1);
resY = ceil(maxY - minY + 1);
resolution = [resY, resX];
end