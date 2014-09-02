function texture_base = getTextureBase(vertices, triangles, resolution)
  
  % getTextureBase 
  
  % Texture base to build warp image
  texture_base = zeros(resolution(1), resolution(2));

  for i=1:size(triangles,1)
    
    % Vertices for each triangle
    X = vertices(triangles(i,:),1);
    Y = vertices(triangles(i,:),2);

    % Mask of each triangle : ROI polygon to ROI mask
    mask = poly2mask(X,Y,resolution(1), resolution(2)) .* i;
    
    % The complete texture
    texture_base = max(texture_base,mask);
    
  end

end