function [ rate ] = ClassificationRate( confusion_matrix )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rate = sum(diag(confusion_matrix))/(sum(sum(confusion_matrix)));

end

