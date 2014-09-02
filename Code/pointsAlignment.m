function [PointsAligned,TransformData] = pointsAlignment(ref_points,Points2Align,base_points,transformtype)

% Alignment of Points based on 6 still points.

nFrames = size(ref_points,1);
if nargin<4 || isempty(transformtype)
    transformtype = 'nonreflective similarity';
end
   
TFORM = cell(nFrames,1);
for i=1:nFrames
    input_points = squeeze(Points2Align(i,:,:)); %Remove singleton dimensions
    TFORM{i} = cp2tform(input_points, base_points, transformtype); 
    %TFORM = cp2tform(movingPoints,fixedPoints, transformtype) 
    %infers a spatial transformation from control point pairs and returns this transformation as a TFORM structure.
end
% Apply the transformation
for i=1:nFrames   
    x = squeeze(ref_points(i,:,1));
    y = squeeze(ref_points(i,:,2));
    [xout, yout] = tformfwd(TFORM{i}, x, y); %Apply forward spatial transformation
    ref_points(i,:,1) = xout;
    ref_points(i,:,2) = yout;
end
% Output Variables
PointsAligned = ref_points;

if nargout>1 
   TransformData = TFORM;
end
































end

