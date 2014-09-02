function [warped_img] = warpImage(shape_mean_scaled, texture_base, triangles, resolution, shape, img, interpolation)
  
  % warpImage Summary of this function goes here
  % Detailed explanation goes here

  % Preamble
  n_triangles = size(triangles,1);
  height = size(img, 1);
  width = size(img, 2);

  % Compute gray version of img
  if (size(img,3) > 1)
      target_gray = rgb2gray(img);   
  else 
      target_gray = img;   
  end

  % Initialize piece-affine affine warp coefficients
  a = zeros(1,6);

  % Initialize warped_image and p1, p2, p3, p4
  warped_img = zeros(resolution(1), resolution(2));

  for t = 1:n_triangles

    % Compute a = [a1,a2,a3,a4,a5,a6] for each triangle in the shape

    % Coordinates of three vertices of a triangle in reference frame
    U = shape_mean_scaled(triangles(t,:),1);
    V = shape_mean_scaled(triangles(t,:),2);

    % Coordinates of three vertices of a triangle in shape
    X = shape(triangles(t,:),1);
    Y = shape(triangles(t,:),2);

    denominator = (U(2) - U(1)) * (V(3) - V(1)) - (V(2) - V(1)) * (U(3) - U(1));

    a(1) = X(1) + ((V(1) * (U(3) - U(1)) - U(1)*(V(3) - V(1))) * (X(2) - X(1)) + (U(1) * (V(2) - V(1)) - V(1)*(U(2) - U(1))) * (X(3) - X(1))) / denominator;
    a(2) = ((V(3) - V(1)) * (X(2) - X(1)) - (V(2) - V(1)) * (X(3) - X(1))) / denominator;
    a(3) = ((U(2) - U(1)) * (X(3) - X(1)) - (U(3) - U(1)) * (X(2) - X(1))) / denominator;

    a(4) = Y(1) + ((V(1) * (U(3) - U(1)) - U(1) * (V(3) - V(1))) * (Y(2) - Y(1)) + (U(1) * (V(2) - V(1)) - V(1)*(U(2) - U(1))) * (Y(3) - Y(1))) / denominator;
    a(5) = ((V(3) - V(1)) * (Y(2) - Y(1)) - (V(2) - V(1)) * (Y(3) - Y(1))) / denominator;
    a(6) = ((U(2) - U(1)) * (Y(3) - Y(1)) - (U(3) - U(1)) * (Y(2) - Y(1))) / denominator;

    % Warp image into the reference frame through shape base
    max_indexes_img = width * height;

    [v,u] = find(texture_base == t);

    if (~isempty(v) && ~isempty(u))

      indexes_base = v + (u-1) * resolution(1);

      target_pixels_x = a(1) + a(2) .* u + a(3) .* v;
      target_pixels_y = a(4) + a(5) .* u + a(6) .* v;

      indexes_img = round(target_pixels_y) + (round(target_pixels_x)-1) * height;

      % Find pixel coordinates in img
      indexes_img = indexes_img(indexes_img > 0 & indexes_img <= max_indexes_img);

      switch interpolation

        case 'none'

          % Pixel translation
          warped_img(indexes_base) = target_gray(indexes_img);

        case 'bilinear'

          % Bilinear interpolation
          delta_x = target_pixels_x - floor(target_pixels_x);
          delta_y = target_pixels_y - floor(target_pixels_y);
          
          
          % check first if needed pixels are inside the image
          tg_size = size(target_gray,1) * size(target_gray,2);
          for i = 1:size(target_pixels_y,1)
              pos1 = (floor(target_pixels_y(i)))   + (floor(target_pixels_x(i))-1) * height;
              pos2 = (floor(target_pixels_y(i)))   + (floor(target_pixels_x(i)))   * height;
              pos3 = (floor(target_pixels_y(i))+1) + (floor(target_pixels_x(i))-1) * height;
              pos4 = (floor(target_pixels_y(i))+1) + (floor(target_pixels_x(i)))   * height;
              w1 = (1-delta_x(i)) * (1-delta_y(i));
              w2 = delta_x(i)     * (1-delta_y(i));
              w3 = (1-delta_x(i)) *  delta_y(i);
              w4 = delta_x(i)     *  delta_y(i);
              
              pos = [pos1 pos2 pos3 pos4];
              w = [w1 w2 w3 w4];
              valid = (pos <= tg_size) & (pos >= 1);
              w = valid .* w;
              
              res = 0;
              if sum(w) > 0
                  w = w/sum(w);
                  for j = 1:4
                      if valid(j)
                          res = res + w(j) * target_gray(pos(j));
                      end
                  end
              end
              warped_img(indexes_base(i)) = res;
          end
          
%           warped_img(indexes_base) =  (1-delta_x) .* (1-delta_y) .* target_gray((floor(target_pixels_y))   + (floor(target_pixels_x)-1) * height) +...
%                                        delta_x    .* (1-delta_y) .* target_gray((floor(target_pixels_y))   + (floor(target_pixels_x))   * height) +...
%                                       (1-delta_x) .*  delta_y    .* target_gray((floor(target_pixels_y)+1) + (floor(target_pixels_x)-1) * height) +...
%                                        delta_x    .*  delta_y    .* target_gray((floor(target_pixels_y)+1) + (floor(target_pixels_x))   * height);

      end

    end
    
  end
  
end
