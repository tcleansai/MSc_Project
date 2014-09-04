clc;
clear;
load('data/testNameList.mat');
resultPath = 'data/bresult/';
tmp = dir(resultPath);
resultNames = {tmp(3:end).name}'; clear tmp;
resultNames = sort(resultNames);
noResult = size(resultNames,1); % number of videos
resultFile = cell(noResult,1);
for i = 1:noResult
    resultFile{i} = resultNames{i}(1:end-4);
end
clear resultNames;
outputPath = 'data/cresult/';
if ~exist(outputPath,'dir')
    mkdir(outputPath);
end
for l = 1:noResult
    l
    load(strcat(resultPath,resultFile{l},'.mat'));
nframe_nf = [];
nframe_e = [];
nframe_t = [];
for i = 1:430
    if(isfield(pred{i,5},'normal_face'))
        nframe_nf = [nframe_nf;pred{i,5}.normal_face];
    end
    if(isfield(pred{i,5},'eating'))
        nframe_e = [nframe_e;pred{i,5}.eating];
    end
    if(isfield(pred{i,5},'talking'))
        nframe_t = [nframe_t;pred{i,5}.talking];
    end
end
[nnframe_nf,~,idx] =unique(nframe_nf);
nnframe_nf = [nnframe_nf,zeros(length(nnframe_nf),1)];
for i  = 1:size(nnframe_nf)
    nnframe_nf(i,2) = sum(idx==i);
end
[nnframe_e,~,idx] =unique(nframe_e);
nnframe_e = [nnframe_e,zeros(length(nnframe_e),1)];
for i  = 1:size(nnframe_e)
    nnframe_e(i,2) = sum(idx==i);
end
[nnframe_t,~,idx] =unique(nframe_t);
nnframe_t = [nnframe_t,zeros(length(nnframe_t),1)];
for i  = 1:size(nnframe_t)
    nnframe_t(i,2) = sum(idx==i);
end
result_seq2 = [];
for i = 1:430
    if(isfield(pred{i,5},'normal_face'))
        n = size(pred{i,5}.normal_face,1);
        tmp_nf = zeros(n,5);
        tmp_nf(:,1) = i;
        tmp_nf(:,2) = 1;
        tmp_nf(:,3) = pred{i,4}.normal_face;
        tmp_nf(:,4) = pred{i,5}.normal_face;
        tmp_nf(:,5) = (1:n)';
        result_seq2 = [result_seq2;tmp_nf];
    end
    if(isfield(pred{i,5},'eating'))
        n = size(pred{i,5}.eating,1);
        tmp_e = zeros(n,5);
        tmp_e(:,1) = i;
        tmp_e(:,2) = 2;
        tmp_e(:,3) = pred{i,4}.eating;
        tmp_e(:,4) = pred{i,5}.eating;
        tmp_e(:,5) = (1:n)';
        result_seq2 = [result_seq2;tmp_e];
    end
    if(isfield(pred{i,5},'talking'))
        n = size(pred{i,5}.talking,1);
        tmp_t = zeros(n,5);
        tmp_t(:,1) = i;
        tmp_t(:,2) = 3;
        tmp_t(:,3) = pred{i,4}.talking;
        tmp_t(:,4) = pred{i,5}.talking;
        tmp_t(:,5) = (1:n)';
        result_seq2 = [result_seq2;tmp_t];
    end
end
a = result_seq2;
correct_nf = result_seq2(a(:,2)==1&a(:,2)==a(:,3),:);
correct_e = result_seq2(a(:,2)==2&a(:,2)==a(:,3),:);
correct_t = result_seq2(a(:,2)==3&a(:,2)==a(:,3),:);
wrong_nf = result_seq2(a(:,2)==1&~(a(:,2)==a(:,3)),:);
wrong_e = result_seq2(a(:,2)==2&~(a(:,2)==a(:,3)),:);
wrong_t = result_seq2(a(:,2)==3&~(a(:,2)==a(:,3)),:);
save(strcat(outputPath,'c',resultFile{l}(2:13),'.mat'),'testNameList',...
    'result_seq2','pred',...
    'correct_nf','correct_e','correct_t',...
    'wrong_nf','wrong_e','wrong_t',...
    'nnframe_nf','nnframe_e','nnframe_t');
end