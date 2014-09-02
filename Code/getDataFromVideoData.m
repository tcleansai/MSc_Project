function [imgs, frame_idx,pts] = getDataFromVideoData(videoData)
% tmp = strsplit(videoDataFile,'/');
% fileName = tmp{end}(1:end-4);
noFrames = size(videoData,1);
imgs = cell(noFrames,1);
% assume there are 49 points
pts = zeros(noFrames,49,2);
frame_idx = [];
for i = 1:noFrames
    imgs{i} = videoData{i}.im;
    if ~isempty(videoData{i}.pred)
        frame_idx = [frame_idx,i];
        pts(i,:,:) = videoData{i}.pred;
    end
end
end