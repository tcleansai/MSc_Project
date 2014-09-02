function feature = getAppFeature(imgs,number)
% this function is to iterate all images and get the appearance feature
noFrames = size(imgs,1);
if number ==1
    feature = zeros(noFrames,59);
elseif number == 3
    feature = zeros(noFrames,177); % block 1,3
end
for i = 1:noFrames
    image = squeeze(imgs(i,:,:));
    if number == 1
        feature(i,:) = blockFeatures(image,1,1,'lbp');
    elseif number == 3
        feature(i,:) = blockFeatures(image,1,3,'lbp');
    end
end
end