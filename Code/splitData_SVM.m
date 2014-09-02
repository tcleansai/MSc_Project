function [data_train,label_train,data_test,label_test] = splitData_SVM(data,label,ith,nFolder)
% input:
%   data   n X noDim
%   label  n X 1
%   ith  integer
%   totalFolder   integer must be larger than ith
n = size(data,1);
n = round(n/nFolder);% object per folder
if ~(ith==nFolder)
    data_test = data(n*(ith - 1)+1:n*ith,:);
    label_test = label(n*(ith - 1)+1:n*ith,:);
    data(n*(ith - 1)+1:n*ith,:) = [];
    data_train = data;
    label(n*(ith - 1)+1:n*ith,:) = [];
    label_train = label;
else
    data_test = data(n*(ith - 1)+1:end,:);
    label_test = label(n*(ith - 1)+1:end,:);
    data(n*(ith - 1)+1:end,:) = [];
    data_train = data;
    label(n*(ith - 1)+1:end,:) = [];
    label_train = label;
end
end