clc;
clear;
resultPath = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/result/';
tmp = dir(resultPath);
resultNames = {tmp(3:end).name}'; clear tmp;
resultNames = sort(resultNames);
noResult = size(resultNames,1); % number of videos
resultFile = cell(noResult,1);
for i = 1:noResult
    resultFile{i} = resultNames{i}(1:end-4);
end
clear resultNames;
outputPath = '/vol/bitbucket/aaaaaaaaaaaaaaaaaa/data/aresult/';
if ~exist(outputPath,'dir')
    mkdir(outputPath);
end
a = 1;
for i = 1:noResult
    i
    tmppath = strcat(resultPath,resultFile{i},'.mat');
    load(tmppath);
    [label_seq,pred_seq,label_frame,pred_frame,param] = alg4SVMResult(result);
    nparam = size(label_seq,2);
    [cm_seq,cm_frame,...
        rr_seq,pr_seq,rr_frame,pr_frame,...
        F1Measure_Seq,F1Measure_frame] = deal(cell(1,nparam));
    for j = 1:nparam
        cm_seq{j} = confusionmat(label_seq{j},pred_seq{j});
        [rr_seq{j}, pr_seq{j} ] = CalAverageRecallPrecision(cm_seq{j});
        [ F1Measure_Seq{j} ] = CalFaMeasure( a, rr_seq{j},pr_seq{j} );
        cm_frame{j} = confusionmat(label_frame{j},pred_frame{j});
        [rr_frame{j}, pr_frame{j} ] = CalAverageRecallPrecision(cm_frame{j});
        [ F1Measure_frame{j} ] = CalFaMeasure( a, rr_frame{j},pr_frame{j} );
    end
    save(strcat(outputPath,'a',resultFile{i},'.mat'),'cm_seq','cm_frame',...
        'rr_seq','pr_seq','rr_frame','pr_frame',...
        'F1Measure_Seq','F1Measure_frame','param');
end