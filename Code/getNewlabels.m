function [fileNames,newLabels] = getNewlabels(test_videoNames)
%% set path
% feature data path
nBlock = 1;
featurePath = 'data/features_mat/';
featurePath = strcat(featurePath,num2str(nBlock),'/');
labelsDir = 'data/labels_mat/';

noTestVideos = length(test_videoNames);
fileNames = cell(noTestVideos,1);
newLabels = cell(noTestVideos,1);

for i = 1:noTestVideos
    load(strcat(featurePath,test_videoNames{i},'.mat'));
    load(strcat(labelsDir,test_videoNames{i},'.mat'));
    fileNames{i} = test_videoNames{i};
    newLabels{i} = updateLable4SeqProcessing(frame_idx,labels);
end
end
