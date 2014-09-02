function [features,ref_idx]...
    = dealFeatures(feature,frame_idx,labels)
% deal appearance feature
noDim = size(feature,2);
noFrames = max(frame_idx);
tmp =  zeros(noFrames,noDim);
tmp(frame_idx,:) = feature;
feature = tmp;
[features.normal_face,ref_idx.normal_face] = dealOneTypeFeature(feature,labels.normal_face);
[features.eating,ref_idx.eating] = dealOneTypeFeature(feature,labels.eating);
[features.talking,ref_idx.talking] = dealOneTypeFeature(feature,labels.talking);
[features.looking_away,ref_idx.looking_away] = dealOneTypeFeature(feature,labels.looking_away);
[features.occluded,ref_idx.occluded] = dealOneTypeFeature(feature,labels.occluded);
[features.other_problem,ref_idx.other_problem] = dealOneTypeFeature(feature,labels.other_problem);
end

function [feature, idx] = dealOneTypeFeature(features, label)
feature = [];
idx = [];
maxFrame = size(features,1);
if ~isempty(label)
    noPart = size(label,1);
    for i = 1:noPart
        for j = label(i,1):label(i,2)
            if  j < maxFrame && ~all(features(j,:)==0)
                feature = [feature;features(j,:)];
                idx = [idx;j];
            end
        end
    end
end
end