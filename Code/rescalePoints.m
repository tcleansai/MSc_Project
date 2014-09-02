function [pts_new] = rescalePoints(pts,imgs, resolution)
noFrames = size(pts,1);
pts_new = zeros(size(pts));
for i = 1:noFrames
    resizeRatio = resolution./size(imgs{i});
    pts_new(i,:,1) = round(pts(i,:,1)*resizeRatio(2));
    pts_new(i,:,2) = round(pts(i,:,2)*resizeRatio(1));
end