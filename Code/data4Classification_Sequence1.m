function [features_train,videoSeq_test] = data4Classification_Sequence1(nBlock,train_videoNames,test_videoNames)
%% set path
% feature data path
featurePath = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/features_mat/';
featurePath = strcat(featurePath,num2str(nBlock),'/');
labelsDir = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/labels_mat/';

%% processing data

[normal_face.feature_appearance,eating.feature_appearance,...
    talking.feature_appearance,looking_away.feature_appearance,...
    occluded.feature_appearance,other_problem.feature_appearance]...
    = deal([]);
[normal_face.feature_shape,eating.feature_shape,...
    talking.feature_shape,looking_away.feature_shape,...
    occluded.feature_shape,other_problem.feature_shape]...
    = deal([]);
[ref_nf,ref_e,ref_t,ref_la,ref_o,ref_op] = deal([]);
noTrainVideos = size(train_videoNames);
for i = 1:noTrainVideos
    load(strcat(featurePath,train_videoNames(i).fileName,'.mat'));
    load(strcat(labelsDir,train_videoNames(i).fileName,'.mat'));
    
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
features_train.normal_face = normal_face;
features_train.eating = eating;
features_train.talking = talking;
features_train.looking_away = looking_away;
features_train.occluded = occluded;
features_train.other_problem = other_problem;
features_train.ref_nf = ref_nf;
features_train.ref_e = ref_e;
features_train.ref_t = ref_t;
features_train.ref_la = ref_la;
features_train.ref_o = ref_o;
features_train.ref_op = ref_op;

noTestVideos = length(test_videoNames);
videoSeq_test = cell(noTestVideos,4);
for i = 1:noTestVideos
    
    load(strcat(featurePath,test_videoNames(i).fileName,'.mat'));
    load(strcat(labelsDir,test_videoNames(i).fileName,'.mat'));
    videoSeq_test{i,1} = test_videoNames(i).fileName;
    videoSeq_test{i,1}
    videoSeq_test{i,2} = feature_appearance;
    videoSeq_test{i,3} = feature_shape;
    videoSeq_test{i,4} = updateLable4SeqProcessing(frame_idx,labels);
end
end
