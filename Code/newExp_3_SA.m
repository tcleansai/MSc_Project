% decide n-crossvalidation

% take n-1 class of file
% take get the feautures 
% train a model
% use the model to do classfication on each small sequence of videos
% classify according to majority voting.
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters defined here
nBlock = 3;
nCross = 10;
fea_param = 'AS';
param_idx = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% cross validation using shape feature and appearance feature
% label:
%   1 - normal_face
%   2 - eating
%   3 - talking
%   4 - looking_away
%   5 - occluded
%   6 - other_problem
addpath('libsvm-3.18/matlab');
addpath('libsvm-3.18/');
% process data
featurePath = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/features_mat/';
featurePath = strcat(featurePath,num2str(nBlock),'/');

tmp = dir(featurePath);
videoNames = {tmp(3:end).name}'; clear tmp;
videoNames = sort(videoNames);
noVideos = size(videoNames,1); % number of videos
fileNames = cell(noVideos,1);
for i = 1:noVideos
    fileNames{i} = videoNames{i}(1:end-4);
end
clear videoNames;
fileNames{51} = [];
fileNames{52} = [];
fileNames{53} = [];
fileNames{73} = [];
fileNames{239} = [];
fileNames{247} = [];
fileNames{248} = [];
fileNames{255} = [];
fileNames{256} = [];
fileNames{310} = [];
fileNames{313} = [];
fileNames = fileNames(~cellfun(@isempty, fileNames));
nameList = cell2struct(fileNames,'fileName',2);
clear fileNames;


models = cell(nCross,1);
acc = cell(nCross,1);
pred_pro = cell(nCross,1);
pred_label = cell(nCross,1);
result = cell(nCross,1);
noVideos = size(nameList,1);
for i = 1:10
    nPerFold = floor(noVideos/nCross);
    idx_test = (nPerFold*(i-1)+1):nPerFold*i;
    test_videoNames = nameList(idx_test);
    train_videoNames = nameList;
    train_videoNames(idx_test) = [];
    [features_train,videoSeq_test] = data4Classification_Sequence(...
        nBlock,train_videoNames,test_videoNames);
    if strcmp(fea_param,'AS')
        data_nf = [features_train.normal_face.feature_appearance,features_train.normal_face.feature_shape];
        noNormalFace = size(data_nf,1);
        label_nf = ones(noNormalFace,1);
        data_e = [features_train.eating.feature_appearance,features_train.eating.feature_shape];
        noEating = size(data_e,1);
        label_e = zeros(noEating,1);
        label_e(:) = 2;
        data_t = [features_train.talking.feature_appearance,features_train.talking.feature_shape];
        noTalking = size(data_t,1);
        label_t = zeros(noTalking,1);
        label_t(:) = 3;
        data_la = [features_train.looking_away.feature_appearance,features_train.looking_away.feature_shape];
        noLookingAway = size(data_la,1);
        label_la = zeros(noLookingAway,1);
        label_la(:) = 4;
        data_o = [features_train.occluded.feature_appearance,features_train.occluded.feature_shape];
        noOccluded = size(data_o,1);
        label_o = zeros(noOccluded,1);
        label_o(:) = 5;
        data_op = [features_train.other_problem.feature_appearance,features_train.other_problem.feature_shape];
        noOtherProblem = size(data_op,1);
        label_op = zeros(noOtherProblem,1);
        label_op(:) = 6;
    elseif strcmp(fea_param,'A')
        data_nf = features_train.normal_face.feature_appearance;
        noNormalFace = size(data_nf,1);
        label_nf = ones(noNormalFace,1);
        data_e = features_train.eating.feature_appearance;
        noEating = size(data_e,1);
        label_e = zeros(noEating,1);
        label_e(:) = 2;
        data_t = features_train.talking.feature_appearance;
        noTalking = size(data_t,1);
        label_t = zeros(noTalking,1);
        label_t(:) = 3;
        data_la = features_train.looking_away.feature_appearance;
        noLookingAway = size(data_la,1);
        label_la = zeros(noLookingAway,1);
        label_la(:) = 4;
        data_o = features_train.occluded.feature_appearance;
        noOccluded = size(data_o,1);
        label_o = zeros(noOccluded,1);
        label_o(:) = 5;
        data_op = features_train.other_problem.feature_appearance;
        noOtherProblem = size(data_op,1);
        label_op = zeros(noOtherProblem,1);
        label_op(:) = 6;
    elseif strcmp(fea_param, 'S')
        data_nf = features_train.normal_face.feature_shape;
        noNormalFace = size(data_nf,1);
        label_nf = ones(noNormalFace,1);
        data_e = features_train.eating.feature_shape;
        noEating = size(data_e,1);
        label_e = zeros(noEating,1);
        label_e(:) = 2;
        data_t = features_train.talking.feature_shape;
        noTalking = size(data_t,1);
        label_t = zeros(noTalking,1);
        label_t(:) = 3;
        data_la = features_train.looking_away.feature_shape;
        noLookingAway = size(data_la,1);
        label_la = zeros(noLookingAway,1);
        label_la(:) = 4;
        data_o = features_train.occluded.feature_shape;
        noOccluded = size(data_o,1);
        label_o = zeros(noOccluded,1);
        label_o(:) = 5;
        data_op = features_train.other_problem.feature_shape;
        noOtherProblem = size(data_op,1);
        label_op = zeros(noOtherProblem,1);
        label_op(:) = 6;
    end;
    % data processing
    n_nf = size(data_nf,1);
    n_e = size(data_e,1);
    n_t = size(data_t,1);
    n_all = n_nf+ n_e+ n_t;
    w_nf = (n_e+n_t)/n_all;
    w_e = (n_nf+ n_t)/n_all;
    w_t = (n_e+n_t)/n_all;
    dataX = [data_nf;data_e;data_t];
    dataY = [ones(n_nf,1);(ones(n_e,1)*2);(ones(n_t,1)*3)];
%     minSize = min([size(data_nf,1),size(data_e,1),size(data_t,1)]);
%     dataX = zeros(minSize*3,size(data_nf,2));
%     dataY = zeros(minSize*3,1);
%     idx = randperm(size(data_nf,1));
%     dataX(1:minSize,:) = data_nf(idx(1:minSize),:);
%     dataY(1:minSize,:) = label_nf(idx(1:minSize),:);
%     idx = randperm(size(data_e,1));
%     dataX(minSize+1:minSize*2,:) = data_e(idx(1:minSize),:);
%     dataY(minSize+1:minSize*2,:) = label_e(idx(1:minSize),:);
%     idx = randperm(size(data_t,1));
%     dataX(minSize*2+1:end,:) = data_t(idx(1:minSize),:);
%     dataY(minSize*2+1:end,:) = label_t(idx(1:minSize),:);
    
    % normalization
    %dataX = normalize(dataX);
    mean_train = mean(dataX);
    dataX = dataX-repmat(mean_train,n_all,1);
    std_train = std(dataX);
    dataX = dataX./(repmat(std_train,n_all,1)+eps);
    min_train = min(dataX);
    dataX = dataX-repmat(min_train,n_all,1);
    max_train = max(dataX);
    dataX = dataX./repmat(max_train,n_all,1);
    % mix traning data
    n = n_all;
    tmp = randperm(n);
    dataX = dataX(tmp,:);
    dataY = dataY(tmp,1);

    x = 0.92;
    y = 0.94;
    %y = logspace(-3,3,10); 
    [xx,yy] = meshgrid(x,y); 
    z = [xx(:),yy(:)]; 
    clear y xx yy;
    n = size(param_idx,2);
    model = cell(1,n);
    accuracy = cell(nPerFold,n);
    pro_estimates = cell(nPerFold,n);
    predicted_label = cell(nPerFold,n);
    result_predict = cell(nPerFold,n);
    for j = 1:n
        j
        n_folder_cross = 4;
        libsvm_option = strcat(...
            '-s ',{' '},num2str(0),...
            ' -t',{' '},num2str(2),...
            ' -g',{' '},num2str(exp(z(param_idx(j),2))),...
            ' -c',{' '},num2str(exp(z(param_idx(j),1))),...
            ' -m',{' '},num2str(4096),...
            ' -h',{' '},num2str(1),...
            ' -b',{' '},num2str(1),...
            ' -w1',{' '},num2str(w_nf),...
            ' -w2',{' '},num2str(w_e),...
            ' -w3',{' '},num2str(w_t),...
            ' -q');%,...
            %' -v',{' '},num2str(4));
        model{j} = svmtrain(dataY,dataX,libsvm_option{1});
        for k = 1:nPerFold
            k
            if strcmp(fea_param, 'AS')
                dataX_test = [videoSeq_test{k,2},videoSeq_test{k,3}];
            elseif strcmp(fea_param, 'A')
                dataX_test = videoSeq_test{k,2};
            elseif strcmp(fea_param, 'S')
                dataX_test = videoSeq_test{k,3};
            end
            dataX_test = dataX_test - repmat(mean_train,size(dataX_test,1),1);
            dataX_test = dataX_test./(repmat(std_train,size(dataX_test,1),1)+eps);
            dataX_test = dataX_test - repmat(min_train,size(dataX_test,1),1);
            dataX_test = dataX_test./ repmat(max_train,size(dataX_test,1),1);
            dataX_save = [];
            dataY_save = [];
            dataPred_save = [];
            dataSeqPred_save = [];
            dataSeq_save = [];
            if ~isempty(videoSeq_test{k,4}.normal_face)
                display('1');
                nSeq = size(videoSeq_test{k,4}.normal_face,1);
                predicted_label{k,j}.normal_face = cell(nSeq,1);
                accuracy{k,j}.normal_face = cell(nSeq,1);
                pro_estimates{k,j}.normal_face = cell(nSeq,1);
                for l = 1:nSeq
                    dataY_test = zeros(size(dataX_test(videoSeq_test{k,4}.normal_face{l},:),1),1);
                    dataY_test(:) = 1;
                    [predicted_label{k,j}.normal_face{l},accuracy{k,j}.normal_face{l},pro_estimates{k,j}.normal_face{l}] = svmpredict(...
                        dataY_test,dataX_test(videoSeq_test{k,4}.normal_face{l},:),model{j},'-b 1');
                    dataX_save = [dataX_save;dataX_test(videoSeq_test{k,4}.normal_face{l},:)];
                    dataY_save = [dataY_save;dataY_test];
                    dataPred_save = [dataPred_save;predicted_label{k,j}.normal_face{l}];
                    dataSeqPred_save = [dataSeqPred_save;mode(predicted_label{k,j}.normal_face{l})];
                end
                dataSeq_save = [dataSeq_save;ones(nSeq,1)];
            end
            if ~isempty(videoSeq_test{k,4}.eating)
                display('2');
                nSeq = size(videoSeq_test{k,4}.eating,1);
                predicted_label{k,j}.eating = cell(nSeq,1);
                accuracy{k,j}.eating = cell(nSeq,1);
                pro_estimates{k,j}.eating = cell(nSeq,1);
                seq_true = 0;
                for l = 1:nSeq
                    dataY_test = zeros(size(dataX_test(videoSeq_test{k,4}.eating{l},:),1),1);
                    dataY_test(:) = 2;
                    [predicted_label{k,j}.eating{l},accuracy{k,j}.eating{l},pro_estimates{k,j}.eating{l}] = svmpredict(...
                        dataY_test,dataX_test(videoSeq_test{k,4}.eating{l},:),model{j},'-b 1');
                    dataX_save = [dataX_save;dataX_test(videoSeq_test{k,4}.eating{l},:)];
                    dataY_save = [dataY_save;dataY_test];
                    dataPred_save = [dataPred_save;predicted_label{k,j}.eating{l}];
                    dataSeqPred_save = [dataSeqPred_save;mode(predicted_label{k,j}.eating{l})];
                end
                dataSeq_save = [dataSeq_save;ones(nSeq,1).*2];
            end
            if ~isempty(videoSeq_test{k,4}.talking)
                display('3');
                nSeq = size(videoSeq_test{k,4}.talking,1);
                predicted_label{k,j}.talking = cell(nSeq,1);
                accuracy{k,j}.talking = cell(nSeq,1);
                pro_estimates{k,j}.talking = cell(nSeq,1);
                seq_true = 0;
                for l = 1:nSeq
                    dataY_test = zeros(size(dataX_test(videoSeq_test{k,4}.talking{l},:),1),1);
                    dataY_test(:) = 3;
                    [predicted_label{k,j}.talking{l},accuracy{k,j}.talking{l},pro_estimates{k,j}.talking{l}] = svmpredict(...
                        dataY_test,dataX_test(videoSeq_test{k,4}.talking{l},:),model{j},'-b 1');
                    dataX_save = [dataX_save;dataX_test(videoSeq_test{k,4}.talking{l},:)];
                    dataY_save = [dataY_save;dataY_test];
                    dataPred_save = [dataPred_save;predicted_label{k,j}.talking{l}];
                    dataSeqPred_save = [dataSeqPred_save;mode(predicted_label{k,j}.talking{l})];
                end
                dataSeq_save = [dataSeq_save;ones(nSeq,1).*3];
            end
            result_predict{k,j}.dataX = dataX_save;
            result_predict{k,j}.dataY = dataY_save;
            result_predict{k,j}.pred_frame = dataPred_save;
            result_predict{k,j}.param = z(param_idx(j),:);
            result_predict{k,j}.pred_seq = dataSeqPred_save;
            result_predict{k,j}.seq = dataSeq_save;
            display(sum(dataY_save==dataPred_save)/length(dataY_save));
        end
    end
    models{i} = model;
    acc{i} = accuracy;
    pred_pro{i} = pro_estimates;
    pred_label{i} = predicted_label;
    result{i} = result_predict;
end
tmpPath = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/newResult/';


save(strcat(tmpPath,'result',num2str(nBlock),fea_param,mat2str(z(param_idx,:)),'.mat'),...
    'models','acc','pred_pro','pred_label','result');

