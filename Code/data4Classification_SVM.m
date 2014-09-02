%% set path
% feature data path
featurePath = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/features_mat/1/';
labelsDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/labels_mat/';

% output path
resultPath = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/classification_result/SVM/';
if ~exist(resultPath,'dir')
    mkdir(resultPath);
end

%% processing data
% processing file names
tmp = dir(featurePath);
videoNames = {tmp(3:end).name}'; clear tmp;
videoNames = sort(videoNames);
noVideos = size(videoNames,1); % number of videos
fileNames = cell(noVideos,1);
for i = 1:noVideos
    fileNames{i} = videoNames{i}(1:end-4);
end
clear videoNames;

[normal_face.feature_appearance,eating.feature_appearance,...
    talking.feature_appearance,looking_away.feature_appearance,...
    occluded.feature_appearance,other_problem.feature_appearance]...
    = deal([]);
[normal_face.feature_shape,eating.feature_shape,...
    talking.feature_shape,looking_away.feature_shape,...
    occluded.feature_shape,other_problem.feature_shape]...
    = deal([]);
[ref_nf,ref_e,ref_t,ref_la,ref_o,ref_op] = deal([]);

for i = 1:noVideos
    i
    load(strcat(featurePath,fileNames{i},'.mat'));
    load(strcat(labelsDir,fileNames{i},'.mat'));
    
    %feature_appearance = normalize(feature_appearance);
    [feature_appearance,ref_idx_app] = dealFeatures(feature_appearance,frame_idx,labels);
    normal_face.feature_appearance = ...
        [normal_face.feature_appearance;feature_appearance.normal_face];
    eating.feature_appearance = ...
        [eating.feature_appearance;feature_appearance.eating];
    talking.feature_appearance = ...
        [talking.feature_appearance;feature_appearance.talking];
    looking_away.feature_appearance = ...
        [looking_away.feature_appearance;feature_appearance.looking_away];
    occluded.feature_appearance = ...
        [occluded.feature_appearance;feature_appearance.occluded];
    other_problem.feature_appearance = ...
        [other_problem.feature_appearance;feature_appearance.other_problem];
    
    %feature_shape = normalize(feature_shape);
    [feature_shape,ref_idx_shape] = dealFeatures(feature_shape,frame_idx,labels);
    normal_face.feature_shape = ...
        [normal_face.feature_shape;feature_shape.normal_face];
    eating.feature_shape = ...
        [eating.feature_shape;feature_shape.eating];
    talking.feature_shape = ...
        [talking.feature_shape;feature_shape.talking];
    looking_away.feature_shape = ...
        [looking_away.feature_shape;feature_shape.looking_away];
    occluded.feature_shape = ...
        [occluded.feature_shape;feature_shape.occluded];
    other_problem.feature_shape = ...
        [other_problem.feature_shape;feature_shape.other_problem];
    
    tmp = zeros(numel(ref_idx_shape.normal_face),1);
    tmp(:) = i;
    ref_nf = [ref_nf;[tmp,ref_idx_shape.normal_face]];
    tmp = zeros(numel(ref_idx_shape.eating),1);
    tmp(:) = i;
    ref_e = [ref_e;[tmp,ref_idx_shape.eating]];
    tmp = zeros(numel(ref_idx_shape.talking),1);
    tmp(:) = i;
    ref_t = [ref_t;[tmp,ref_idx_shape.talking]];
    tmp = zeros(numel(ref_idx_shape.looking_away),1);
    tmp(:) = i;
    ref_la = [ref_la;[tmp,ref_idx_shape.looking_away]];
    tmp = zeros(numel(ref_idx_shape.occluded),1);
    tmp(:) = i;
    ref_o = [ref_o;[tmp,ref_idx_shape.occluded]];
    tmp = zeros(numel(ref_idx_shape.other_problem),1);
    tmp(:) = i;
    ref_op = [ref_op;[tmp,ref_idx_shape.other_problem]];
       
end
save(strcat(resultPath,'features_11.mat'),'normal_face',...
    'eating','talking','looking_away','occluded','other_problem',...
    'ref_nf','ref_e','ref_t','ref_la','ref_o','ref_op');

