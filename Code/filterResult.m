%pred
seq_nf = [];
seq_pred_nf = [];
seq_e = [];
seq_pred_e = [];
seq_t = [];
seq_pred_t = [];
threshold = 0;
for i = 1:430
    if isfield(pred{i,3},'normal_face')
        n = size(pred{i,3}.normal_face,1);
        for j = 1:n
            if pred{i,5}.normal_face(j)> threshold
                seq_nf = [seq_nf;pred{i,4}.normal_face(j)];
                seq_pred_nf = [seq_pred_nf;1];
            end
        end
    end
    if isfield(pred{i,3},'eating')
        n = size(pred{i,3}.eating,1);
        for j = 1:n
            if pred{i,5}.eating(j)> threshold
                seq_e = [seq_e;pred{i,4}.eating(j)];
                seq_pred_e = [seq_pred_e;2];
            end
        end
    end
    if isfield(pred{i,3},'talking')
        n = size(pred{i,3}.talking,1);
        for j = 1:n
            if pred{i,5}.talking(j)> threshold
                seq_t = [seq_t;pred{i,4}.talking(j)];
                seq_pred_t = [seq_pred_t;3];
            end
        end
    end
end