function [ dataX_test,dataY_test] = getData4Testing( feature_app,feature_shape, label,fea_param )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if strcmp(fea_param, 'AS')
    dataX_test = [feature_app,feature_shape];
elseif strcmp(fea_param, 'A')
    dataX_test = feature_app;
elseif strcmp(fea_param, 'S')
    dataX_test = feature_shape;
end
i = 1;
while i <= size(label.normal_face,1)
    

end

