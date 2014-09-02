function [label_seq,pred_seq,label_frame,pred_frame,params] = alg4SVMResult(result)
nfold = size(result,1);
[nfiles,nparam] = size(result{1,1});
pred_seq = cell(1,nparam);
label_seq = cell(1,nparam);
pred_frame = cell(1,nparam);
label_frame = cell(1,nparam);
params = zeros(nparam,2);
for i = 1:nfold 
    for j = 1:nfiles
        for k = 1:nparam
            pred_seq{k} = [pred_seq{k};result{i}{j,k}.pred_seq];
            label_seq{k} = [label_seq{k};result{i}{j,k}.seq];
            pred_frame{k} = [pred_frame{k};result{i}{j,k}.pred_frame];
            label_frame{k} = [label_frame{k};result{i}{j,k}.dataY];
            params(k,:) = result{i}{j,k}.param;
        end
    end
end
end