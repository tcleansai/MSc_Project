function [pred_seq, label_seq,pred_frame,label_frame,params]= totalResult(result)
nFold = size(result,1);
[nVideo,nParam] = size(result{1,1});
pred_seq = cell(1,nParam);
label_seq = cell(1,nParam);
pred_frame = cell(1,nParam);
label_frame = cell(1,nParam);
params = zeros(nParam,2);
for i = 1:nFold
    for j = 1:nVideo
        for k = 1:nParam
            params(k,:) = result{i}{j,k}.param; 
            pred_seq{k} = [pred_seq{k};result{i}{j,k}.pred_seq];
            label_seq{k} = [label_seq{k};result{i}{j,k}.seq];
            pred_frame{k} = [pred_frame{k};result{i}{j,k}.pred_frame];
            label_frame{k} = [label_frame{k};result{i}{j,k}.dataY];
        end
    end
end
end