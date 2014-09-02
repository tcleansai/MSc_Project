load('data/classification_result/SVM/features_3.mat');
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

for i = 1:10
    % data processing 5183
    % take out 5183 data for each group
    dataX = zeros(5183*3,size(data_nf,2));
    dataY = zeros(5183*3,1);
    idx = randperm(size(data_nf,1));
    dataX(1:5183,:) = data_nf(idx(1:5183),:);
    dataY(1:5183,:) = label_nf(idx(1:5183),:);
    idx = randperm(size(data_e,1));
    dataX(5184:5183*2,:) = data_e(idx(1:5183),:);
    dataY(5184:5183*2,:) = label_e(idx(1:5183),:);
    idx = randperm(size(data_t,1));
    dataX(5183*2+1:end,:) = data_t(idx(1:5183),:);
    dataY(5183*2+1:end,:) = label_t(idx(1:5183),:);
    
    % normalization
    dataX = normalize(dataX);
    
    % mix traning data
    n = 5183*3;
    tmp = randperm(n);
    dataX = dataX(tmp,:);
    dataY = dataY(tmp,1);

    % normalization
    dataX = normc(dataX);

    y = logspace(-3,3,10); 
    [xx,yy] = meshgrid(y); 
    z = [xx(:),yy(:)]; 
    clear y xx yy;
    c_sigma_nf = zeros(size(z,1),3);
    c_sigma_e = zeros(size(z,1),3);
    c_sigma_t = zeros(size(z,1),3);
    for j = 1:size(z,1)
        % train svmstruct of normal face
        [data_train,label_train,data_test,label_test] = ...
            splitData_SVM(dataX,dataY,i,10);
        dataY_train = label_train;
        dataY_train(dataY_train ~= 1) = -1;
        c = cvpartition(length(dataY_train),'kfold',10);
        minfn = @(z)crossval('mcr',data_train,dataY_train,'Predfun',...
            @(xtrain,ytrain,xtest)crossfun(xtrain,ytrain,...
            xtest,exp(z(1)),exp(z(2))),'partition',c);
        opts = optimset('TolX',5e-4,'TolFun',5e-4);
        [c_sigma_nf(j,1:2),c_sigma_nf(j,3)] = fminsearch(minfn,z(j,:),opts);
        
%         svmstruct_nf = svmtrain(data_train, dataY_train,...
%             'autoscale',false,...
%             'Kernel_Function', 'rbf',...
%             'RBF_Sigma', sigma(k),...
%             'BoxConstraint', c_param(j));
        dataY_train = label_train;
        dataY_train(dataY_train ~= 2) = -1;
        dataY_train(dataY_train == 2) = 1;
        minfn = @(z)crossval('mcr',data_train,dataY_train,'Predfun',...
            @(xtrain,ytrain,xtest)crossfun(xtrain,ytrain,...
            xtest,exp(z(1)),exp(z(2))),'partition',c);
        [c_sigma_e(j,1:2),c_sigma_e(j,3)] = fminsearch(minfn,z(j,:),opts);
%         svmstruct_e = svmtrain(data_train, dataY_train,...
%             'autoscale',false,...
%             'Kernel_Function', 'rbf',...
%             'RBF_Sigma', sigma(k),...
%             'BoxConstraint', c_param(j));
        dataY_train = label_train;
        dataY_train(dataY_train ~= 3) = -1;
        dataY_train(dataY_train == 3) = 1;
        minfn = @(z)crossval('mcr',data_train,dataY_train,'Predfun',...
            @(xtrain,ytrain,xtest)crossfun(xtrain,ytrain,...
            xtest,exp(z(1)),exp(z(2))),'partition',c);
        [c_sigma_t(j,1:2),c_sigma_t(j,3)] = fminsearch(minfn,z(j,:),opts);
%         svmstruct_t = svmtrain(data_train, dataY_train,...
%             'autoscale',false,...
%             'Kernel_Function', 'rbf',...
%             'RBF_Sigma', sigma(k),...
%             'BoxConstraint', c_param(j));
    end
end