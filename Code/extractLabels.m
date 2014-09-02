function [normal_face_label,...
    eating_label,...
    talking_label,...
    looking_away_label,...
    occluded_label,...
    other_problem_label]...
        = extractLabels(label)
%%Initialization
[normal_face_label,...
    eating_label,...
    talking_label,...
    looking_away_label,...
    occluded_label,...
    other_problem_label]...
    =deal([]);
[idx_nf,idx_e,idx_t,idx_la,idx_o,idx_op] = deal(1);

%% processing from 2 row to lastrow -1
for i = 2:(size(label,1)-1)
    [result,saveResult] = logics(idx_nf,i,3);
    if saveResult == 1
        normal_face_label = [normal_face_label;idx_nf,i-1,label(idx_nf,2),label(i-1,2)];
    end
    idx_nf = result;
    
    [result,saveResult] = logics(idx_e,i,4);
    if saveResult == 1
        eating_label = [eating_label;idx_e,i-1,label(idx_e,2),label(i-1,2)];
    end
    idx_e = result;
    
    [result,saveResult] = logics(idx_t,i,5);
    if saveResult == 1
        talking_label = [talking_label;idx_t,i-1,label(idx_t,2),label(i-1,2)];
    end
    idx_t = result;

    
    [result,saveResult] = logics(idx_la,i,6);
    if saveResult == 1
        looking_away_label = [looking_away_label;idx_la,i-1,label(idx_la,2),label(i-1,2)];
    end
    idx_la = result;

    
    [result,saveResult] = logics(idx_o,i,7);
    if saveResult == 1
        occluded_label = [occluded_label;idx_o,i-1,label(idx_o,2),label(i-1,2)];
    end
    idx_o = result;
    
    [result,saveResult] = logics(idx_op,i,8);
    if saveResult == 1
        other_problem_label = [other_problem_label;idx_op,i-1,label(idx_op,2),label(i-1,2)];
    end
    idx_op = result;   
end
%% processing at lastrow
    i = i+1;
    [saveResult] = spec_logics(idx_nf,i,3);
    if saveResult == 1
        normal_face_label = [normal_face_label;i,i,label(i,2),label(i,2)];
    elseif saveResult == 2
        normal_face_label = [normal_face_label;idx_nf,i-1,label(idx_nf,2),label(i-1,2)];
    elseif saveResult == 3
        normal_face_label = [normal_face_label;idx_nf,i,label(idx_nf,2),label(i,2)];
    end
    
    [saveResult] = spec_logics(idx_e,i,4);
    if saveResult == 1
        eating_label = [eating_label;i,i,label(i,2),label(i,2)];
    elseif saveResult == 2
        eating_label = [eating_label;idx_e,i-1,label(idx_e,2),label(i-1,2)];
    elseif saveResult == 3
        eating_label = [eating_label;idx_e,i,label(idx_e,2),label(i,2)];
    end
    
    [saveResult] = spec_logics(idx_t,i,5);
    if saveResult == 1
        talking_label = [talking_label;i,i,label(i,2),label(i,2)];
    elseif saveResult == 2
        talking_label = [talking_label;idx_t,i-1,label(idx_t,2),label(i-1,2)];
    elseif saveResult == 3
        talking_label = [talking_label;idx_t,i,label(idx_t,2),label(i,2)];
    end
    
    [saveResult] = spec_logics(idx_la,i,6);
    if saveResult == 1
        looking_away_label = [looking_away_label;i,i,label(i,2),label(i,2)];
    elseif saveResult == 2
        looking_away_label = [looking_away_label;idx_la,i-1,label(idx_la,2),label(i-1,2)];
    elseif saveResult == 3
        looking_away_label = [looking_away_label;idx_la,i,label(idx_la,2),label(i,2)];
    end
    
    [saveResult] = spec_logics(idx_o,i,7);
    if saveResult == 1
        occluded_label = [occluded_label;i,i,label(i,2),label(i,2)];
    elseif saveResult == 2
        occluded_label = [occluded_label;idx_o,i-1,label(idx_o,2),label(i-1,2)];
    elseif saveResult == 3
        occluded_label = [occluded_label;idx_o,i,label(idx_o,2),label(i,2)];
    end
    
    [saveResult] = spec_logics(idx_op,i,8);
    if saveResult == 1
        other_problem_label = [other_problem_label;i,i,label(i,2),label(i,2)];
    elseif saveResult == 2
        other_problem_label = [other_problem_label;idx_op,i-1,label(idx_op,2),label(i-1,2)];
    elseif saveResult == 3
        other_problem_label = [other_problem_label;idx_op,i,label(idx_op,2),label(i,2)];
    end

%% assistant function
% this function indicate how the idx would change and when to save the
% result, logic is as follows:
% idx: the old index of the row number
% new_idx: the new idx of the row number
% four situations:
% label result stored at each position
% idx : 0 and new_idx : 0 || idx = new_idx, not save result
% idx : 0 and new_idx : 1 || idx = new_idx, not save result
% idx : 1 and new_idx : 0 || idx = new_idx, save result [idx to new_idx-1]
% idx : 1 and new_idx : 1 || idx = idx, not save result
    function [result,saveResult] = logics(idx,new_idx,col_no)
        if(label(idx,col_no)==1&&label(new_idx,col_no)==1)
            result = idx;
            saveResult = 0;
        elseif(label(idx,col_no)==1&&label(new_idx,col_no)==0)
            result = new_idx;
            saveResult = 1;
        else
            result = new_idx;
            saveResult = 0;
        end   
    end
% when label goes to the end of the matrix, logic changes to follows:
% idx: the old index of the row number
% new_idx: the new idx of the row number
% four situations:
% saveResult = 0; idx : 0 and new_idx : 0 || not save result
% saveResult = 1; idx : 0 and new_idx : 1 || save result [new_idx,new_idx]
% saveResult = 2; idx : 1 and new_idx : 0 || save result [idx, new_idx - 1]
% saveResult = 3; idx : 1 and new_idx : 1 || save result [idx, new_idx]
    function [saveResult] = spec_logics(idx,new_idx,col_no)
        if(label(idx,col_no) == 0 && label(new_idx,col_no) == 0)
            saveResult = 0;
        elseif(label(idx,col_no) == 0 && label(new_idx,col_no) == 1)
            saveResult = 1;
        elseif(label(idx,col_no) == 1 && label(new_idx,col_no) == 0)
            saveResult = 2;
        elseif(label(idx,col_no) == 1 && label(new_idx,col_no) == 1)
            saveResult = 3;
        end
    end
end

