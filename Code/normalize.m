function [ output ] = normalize( input )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
n = size(input,1);
input = input - repmat(mean(input),n,1);
output = input./(repmat(std(input),n,1) + eps);
end

