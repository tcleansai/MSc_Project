load('data/classification_result/SVM/features.mat');
%% cross validation using shape feature and appearance feature
% label:
%   1 - normal_face
%   2 - eating
%   3 - talking
%   4 - looking_away
%   5 - occluded
%   6 - other_problem

% process data
data_nf = [normal_face.feature_appearance,normal_face.feature_shape];
noNormalFace = size(data_nf,1);
label_nf = ones(noNormalFace,1);
data_e = [eating.feature_appearance,eating.feature_shape];
noEating = size(data_e,1);
label_e = zeros(noEating,1);
label_e(:) = 2;
data_t = [talking.feature_appearance,talking.feature_shape];
noTalking = size(data_t,1);
label_t = zeros(noTalking,1);
label_t(:) = 3;
data_la = [looking_away.feature_appearance,looking_away.feature_shape];
noLookingAway = size(data_la,1);
label_la = zeros(noLookingAway,1);
label_la(:) = 4;
data_o = [occluded.feature_appearance,occluded.feature_shape];
noOccluded = size(data_o,1);
label_o = zeros(noOccluded,1);
label_o(:) = 5;
data_op = [other_problem.feature_appearance,other_problem.feature_shape];
noOtherProblem = size(data_op,1);
label_op = zeros(noOtherProblem,1);
label_op(:) = 6;

for i = 1:2
% data processing
[dataX_train,dataY_train,dataX_test,dataY_test] = deal([]);
[data_train,label_train,data_test,label_test] = splitData_SVM(...
    data_nf,label_nf,i+round(rand(1)*8),10);
dataX_train = [dataX_train;data_train];
dataY_train = [dataY_train;label_train];
dataX_test = [dataX_test;data_test];
dataY_test = [dataY_test;label_test];
[data_train,label_train,data_test,label_test] = splitData_SVM(...
    data_e,label_e,i+round(rand(1)),3);
dataX_train = [dataX_train;data_train];
dataY_train = [dataY_train;label_train];
dataX_test = [dataX_test;data_test];
dataY_test = [dataY_test;label_test];
[data_train,label_train,data_test,label_test] = splitData_SVM(...
    data_t,label_t,i,2);
dataX_train = [dataX_train;data_train];
dataY_train = [dataY_train;label_train];
dataX_test = [dataX_test;data_test];
dataY_test = [dataY_test;label_test]   ;

% [data_train,label_train,data_test,label_test] = splitData_SVM(...
%     data_la,label_la,i,10);
% dataX_train = [dataX_train;data_train];
% dataY_train = [dataY_train;label_train];
% dataX_test = [dataX_test;data_test];
% dataY_test = [dataY_test;label_test];
% [data_train,label_train,data_test,label_test] = splitData_SVM(...
%     data_o,label_o,i,10);
% dataX_train = [dataX_train;data_train];
% dataY_train = [dataY_train;label_train];
% dataX_test = [dataX_test;data_test];
% dataY_test = [dataY_test;label_test];
% [data_train,label_train,data_test,label_test] = splitData_SVM(...
%     data_op,label_op,i,10);
% dataX_train = [dataX_train;data_train];
% dataY_train = [dataY_train;label_train];
% dataX_test = [dataX_test;data_test];
% dataY_test = [dataY_test;label_test];

% normalization
dataX_train = normc(dataX_train);
dataX_test = normc(dataX_test);
%clearvars -except dataX_train dataY_train dataX_test dataY_test
%train
tmp = dataY_train;
dataY_train = zeros(size(dataY_train,1),3);
for j = 1:size(dataX_train,1)
    dataY_train(j,tmp(j)) = 1;
end

net1 = feedforwardnet([15 6],'trainrp' );
net1.trainParam.epochs = 20;
net1.trainParam.max_fail = 3;
net1.trainParam.lr = 0.0001;
net1 = configure(net1,dataX_train',dataY_train');
net1.divideFcn = 'dividerand';
net1.divideParam.trainRatio = 90/100;
net1.divideParam.valRatio = 10/100;
net1.divideParam.testRatio = 0/100;
[net1,tr] = train(net1,dataX_train',dataY_train');

net2 = feedforwardnet([15 6],'trainrp' );
net2.trainParam.epochs = 20;
net2.trainParam.max_fail = 3;
net2.trainParam.lr = 0.0001;
net2 = configure(net2,net1(dataX_train'),dataY_train');
net2.divideFcn = 'dividerand';
net2.divideParam.trainRatio = 90/100;
net2.divideParam.valRatio = 10/100;
net2.divideParam.testRatio = 0/100;
[net2,tr] = train(net2,net1(dataX_train'),dataY_train');

% testing

end