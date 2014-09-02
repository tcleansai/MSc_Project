function [ confusionMatrix ] = CalConfusionMatrix( predictions, targets )
%CONFUSIONMATRIX Summary of this function goes here
%   Detailed explanation goes here
if size(predictions,1) ~= size(targets,1)  || size(predictions,2) ~= 1 || size(targets,2) ~= 1
     disp('invalid inputs');
     return
else
    n = size(unique(targets));
    confusionMatrix = zeros(n,n); 
    for i = 1:n
      for j = 1:n
          confusionMatrix(i,j) = length(find(predictions(targets==i)==j));
      end
    end
end

