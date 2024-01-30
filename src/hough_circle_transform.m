function [accumulator, centers_x, centers_y, radii] = hough_circle_transform(image, radius_range)
    start_time = tic;  % Record the start time
    
    [Ny, Nx] = size(image);
    max_radius = max(radius_range);
    
    % Initialize accumulator array
    accumulator = zeros(Ny, Nx, max_radius);
    
    % Create a theta array
    thetas = linspace(0, 2 * pi, 360);
    
    % Find edge pixels in the image
    [edge_pixels_y, edge_pixels_x] = find(image > 0);
    bigger = 0; %holds the value of the bigger value of circles centers passing that particular centerpoint
    
    % Iterate over each pixel in the image
    for edge_pixel_idx = 1:length(edge_pixels_y)
        y = edge_pixels_y(edge_pixel_idx);
        x = edge_pixels_x(edge_pixel_idx);
        
        % Iterate over possible radii
        for radius_idx = 1:length(radius_range)
            radius = radius_range(radius_idx);
            
            % Iterate over theta values
            for theta_idx = 1:length(thetas)
                theta = thetas(theta_idx);
                
                % Calculate circle center coordinates
                center_x = round(x - radius * cos(theta));
                center_y = round(y - radius * sin(theta));
                
                % Check if the center coordinates are within the image bounds
                if 1 <= center_x && center_x <= Nx && 1 <= center_y && center_y <= Ny
                    % Update the accumulator
                    accumulator(center_y, center_x, radius_idx) = accumulator(center_y, center_x, radius_idx) + 1;
                    if accumulator(center_y, center_x, radius_idx) > bigger
                        bigger = accumulator(center_y, center_x, radius_idx);
                        bigger_idx = [center_y, center_x, radius_idx];
                    end
                end
            end
        end
    end

    % Find the peaks in the accumulator
    %threshold = max(accumulator(:)) * 0.5;
    %Since we are looking for only one ball, only the max value will be
    %used
    %threshold = max(accumulator(:));
    %[center_y, center_x, radii_idx] = find(accumulator >= threshold);
    %radii = radius_range(radii_idx);
    
    % Find the peaks in the accumulator
    %threshold = max(accumulator(:)) * 0.8;
    %peak_mask = imregionalmax(accumulator);
    %[centers_y, centers_x, radii_idx] = find(peak_mask);
    %radii = radius_range(radii_idx);
    
    centers_y = bigger_idx(1);
    centers_x = bigger_idx(2);
    radius_idx = bigger_idx(3);
    radii = radius_range(radius_idx);
    
    end_time = toc(start_time);  % Record the end time
    fprintf('Hough execution time: %.4f seconds\n', end_time);
    fprintf('Circle information: C(%i,%i) R= %i\n', centers_x,centers_y,radii);
    
end