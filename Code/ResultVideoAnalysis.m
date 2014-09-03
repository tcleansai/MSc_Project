clc;
clear;
load('data/testNameList.mat');
resultPath = 'data/result/';
tmp = dir(resultPath);
resultNames = {tmp(3:end).name}'; clear tmp;
resultNames = sort(resultNames);
noResult = size(resultNames,1); % number of videos
resultFile = cell(noResult,1);
for i = 1:noResult
    resultFile{i} = resultNames{i}(1:end-4);
end
clear resultNames;
outputPath = 'data/aresult/';
if ~exist(outputPath,'dir')
    mkdir(outputPath);
end
paramidx = [1 2 3 1 1 2 1 2 3 2 2 2];
pred = cell(340,5);
for i = 1:noResult
    i
    tmppath = strcat(resultPath,resultFile{i},'.mat');
    load(tmppath);
    for j = 1:10
    [fileNames,newLabels] = getNewlabels(struct2cell(testNameList{j})');
    for n = 1:43
        pred_result_frame{n,1} = pred_label{j}{n,paramidx(i)};
    end
    pred_result_seq = cell(43,1);
    frame_number = cell(43,1);
        for k = 1:43
            if ~isempty(pred_result_frame{k})
                if isfield(pred_result_frame{k},'talking')
                    nseq = size(pred_result_frame{k}.talking);
                    pred_result_seq{k}.talking = zeros(nseq);
                    frame_number{k}.talking = zeros(nseq);
                    for l = 1:nseq
                        pred_result_seq{k}.talking(l) = mode(pred_result_frame{k}.talking{l});
                        frame_number{k}.talking(l) = length(pred_result_frame{k}.talking{l});
                    end
                end
                if isfield(pred_result_frame{k},'eating')
                    nseq = size(pred_result_frame{k}.eating);
                    pred_result_seq{k}.eating = zeros(nseq);
                    frame_number{k}.eating = zeros(nseq);
                    for l = 1:nseq
                        pred_result_seq{k}.eating(l) = mode(pred_result_frame{k}.eating{l});
                        frame_number{k}.eating(l) = length(pred_result_frame{k}.eating{l});
                    end
                end
                if isfield(pred_result_frame{k},'normal_face')
                    nseq = size(pred_result_frame{k}.normal_face);
                    pred_result_seq{k}.normal_face = zeros(nseq);
                    frame_number{k}.normal_face = zeros(nseq);
                    for l = 1:nseq
                        pred_result_seq{k}.normal_face(l) = mode(pred_result_frame{k}.normal_face{l});
                        frame_number{k}.normal_face(l) = length(pred_result_frame{k}.normal_face{l});
                    end
                end
            end
        end
        for m = 1:43  
            pred{43*(j-1)+m,1} = fileNames{m};
            pred{43*(j-1)+m,2} = newLabels{m};
            pred{43*(j-1)+m,3} = pred_result_frame{m};
            pred{43*(j-1)+m,4} = pred_result_seq{m};
            pred{43*(j-1)+m,5} = frame_number{m};
        end
    end
    save(strcat(outputPath,'b',resultFile{i},'.mat'),'pred');
end