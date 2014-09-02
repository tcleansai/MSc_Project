function FinalROIs = ScaleROI2FixedSize(ROIs,FinalRes,method,visualize)

% DownSample ROIs

if nargin<4 || isempty(visualize)
    visualize = 1;
end

if nargin<3 || isempty(method)
    method = 'bilinear';
end

if iscell(ROIs)
    nFrames = numel(ROIs);
else
    nFrames = size(ROIs,3);
end

FinalROIs = zeros([nFrames FinalRes]);
if visualize==1
    h = figure;
end
for i=1:nFrames
    % set(h,'Units','Normalized', 'OuterPosition', [0 0 1 1],'name','ROI'); 
    if iscell(ROIs)
        FinalROIs(i,:,:) = imresize(ROIs{i},FinalRes,method);
    else
        FinalROIs(i,:,:) = imresize(ROIs(i,:,:),FinalRes,method);
    end
        
    if visualize==1
        imshow(squeeze(FinalROIs(i,:,:)),[]);
        iptsetpref('ImshowAxesVisible','Off')
        iptsetpref('ImshowBorder','tight')
        iptsetpref('ImshowInitialMagnification',300)
        drawnow
        pause(0.1)
    end
end

end

