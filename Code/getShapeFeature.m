function feature = getShapeFeature(pts)
% input
%   pts : noFrame X noPoint X dimension
% output:
%   shape feature
[noFrames,noPoints,dim] = size(pts);
feature = zeros(noFrames,noPoints*dim);
for i = 1:noFrames
    for j = 1:dim
        feature(i,(j-1)*noPoints+1:noPoints*j) = pts(i,:,j);
    end
end
end