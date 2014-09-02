function [ newLabels ] = updateLable4SeqProcessing( frame_idx,labels )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
tmpvet = zeros(max(frame_idx),1);
tmpvet(frame_idx) = 1:length(frame_idx);
maxIdx = max(frame_idx);
if(isempty(labels.normal_face))
    newLabels.normal_face = [];
else
    newLabels.normal_face = cell(size(labels.normal_face,1),1);
    for i = 1:size(labels.normal_face,1)
        idx_start = labels.normal_face(i,1);
        idx_end = labels.normal_face(i,2);
        if (idx_start <= maxIdx) && (idx_end <= maxIdx)
            newLabels.normal_face{i} = tmpvet(labels.normal_face(i,1):labels.normal_face(i,2));
            newLabels.normal_face{i}(newLabels.normal_face{i} == 0) = [];
        elseif (idx_start <= maxIdx) && (idx_end > maxIdx)
            newLabels.normal_face{i} = tmpvet(labels.normal_face(i,1):maxIdx);
            newLabels.normal_face{i}(newLabels.normal_face{i} == 0) = [];
        elseif (idx_start > maxIdx)
            newLabels.normal_face{i} = [];
        end
    end
    newLabels.normal_face = newLabels.normal_face(~cellfun(@isempty, newLabels.normal_face));
end
if(isempty(labels.eating))
    newLabels.eating = [];
else
    newLabels.eating = cell(size(labels.eating,1),1);
    for i = 1:size(labels.eating,1)
        idx_start = labels.eating(i,1);
        idx_end = labels.eating(i,2);
        if (idx_start <= maxIdx) && (idx_end <= maxIdx)
            newLabels.eating{i} = tmpvet(labels.eating(i,1):labels.eating(i,2));
            newLabels.eating{i}(newLabels.eating{i} == 0) = [];
        elseif (idx_start <= maxIdx) && (idx_end > maxIdx)
            newLabels.eating{i} = tmpvet(labels.eating(i,1):maxIdx);
            newLabels.eating{i}(newLabels.eating{i} == 0) = [];
        elseif (idx_start > maxIdx)
            newLabels.eating{i} = [];
        end
    end
    newLabels.eating = newLabels.eating(~cellfun(@isempty, newLabels.eating));
end
if(isempty(labels.talking))
    newLabels.talking = [];
else
    newLabels.talking = cell(size(labels.talking,1),1);
    for i = 1:size(labels.talking,1)
        idx_start = labels.talking(i,1);
        idx_end = labels.talking(i,2);
        if (idx_start <= maxIdx) && (idx_end <= maxIdx)
            newLabels.talking{i} = tmpvet(labels.talking(i,1):labels.talking(i,2));
            newLabels.talking{i}(newLabels.talking{i} == 0) = [];
        elseif (idx_start <= maxIdx) && (idx_end > maxIdx)
            newLabels.talking{i} = tmpvet(labels.talking(i,1):maxIdx);
            newLabels.talking{i}(newLabels.talking{i} == 0) = [];
        elseif (idx_start > maxIdx)
            newLabels.talking{i} = [];
        end
    end
    newLabels.talking = newLabels.talking(~cellfun(@isempty, newLabels.talking));
end
if(isempty(labels.looking_away))
    newLabels.looking_away = [];
else
    newLabels.looking_away = cell(size(labels.looking_away,1),1);
    for i = 1:size(labels.looking_away,1)
        idx_start = labels.looking_away(i,1);
        idx_end = labels.looking_away(i,2);
        if (idx_start <= maxIdx) && (idx_end <= maxIdx)
            newLabels.looking_away{i} = tmpvet(labels.looking_away(i,1):labels.looking_away(i,2));
            newLabels.looking_away{i}(newLabels.looking_away{i} == 0) = [];
        elseif (idx_start <= maxIdx) && (idx_end > maxIdx)
            newLabels.looking_away{i} = tmpvet(labels.looking_away(i,1):maxIdx);
            newLabels.looking_away{i}(newLabels.looking_away{i} == 0) = [];
        elseif (idx_start > maxIdx)
            newLabels.looking_away{i} = [];
        end
    end
    newLabels.looking_away = newLabels.looking_away(~cellfun(@isempty, newLabels.looking_away));
end
if(isempty(labels.occluded))
    newLabels.occluded = [];
else
    newLabels.occluded = cell(size(labels.occluded,1),1);
    for i = 1:size(labels.occluded,1)
        idx_start = labels.occluded(i,1);
        idx_end = labels.occluded(i,2);
        if (idx_start <= maxIdx) && (idx_end <= maxIdx)
            newLabels.occluded{i} = tmpvet(labels.occluded(i,1):labels.occluded(i,2));
            newLabels.occluded{i}(newLabels.occluded{i} == 0) = [];
        elseif (idx_start <= maxIdx) && (idx_end > maxIdx)
            newLabels.occluded{i} = tmpvet(labels.occluded(i,1):maxIdx);
            newLabels.occluded{i}(newLabels.occluded{i} == 0) = [];
        elseif (idx_start > maxIdx)
            newLabels.occluded{i} = [];
        end
    end
    newLabels.occluded = newLabels.occluded(~cellfun(@isempty, newLabels.occluded));
end
if(isempty(labels.other_problem))
    newLabels.other_problem = [];
else
    newLabels.other_problem = cell(size(labels.other_problem,1),1);
    for i = 1:size(labels.other_problem,1)
        idx_start = labels.other_problem(i,1);
        idx_end = labels.other_problem(i,2);
        if (idx_start <= maxIdx) && (idx_end <= maxIdx)
            newLabels.other_problem{i} = tmpvet(labels.other_problem(i,1):labels.other_problem(i,2));
            newLabels.other_problem{i}(newLabels.other_problem{i} == 0) = [];
        elseif (idx_start <= maxIdx) && (idx_end > maxIdx)
            newLabels.other_problem{i} = tmpvet(labels.other_problem(i,1):maxIdx);
            newLabels.other_problem{i}(newLabels.other_problem{i} == 0) = [];
        elseif (idx_start > maxIdx)
            newLabels.other_problem{i} = [];
        end
    end
    newLabels.other_problem = newLabels.other_problem(~cellfun(@isempty, newLabels.other_problem));
end
end

