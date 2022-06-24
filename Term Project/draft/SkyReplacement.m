function replace_img = SkyReplacement(image, sky_image, label)
    % k-means will make the sky-region in image be the value 2
    % and the ground-region in image be the value 1
    % label is the result of the values in image
    % each_column indicates there are how many 2s in each column 
    each_column = sum(label==2);
    sky_row = max(each_column);
    [row, column, ~] = size(image);
    sky_column = column;

    sky_resize_image = imresize(sky_image, [sky_row, sky_column], 'bilinear');

    replace_img = ColorTransformation(image, sky_resize_image);

    
    for i = 1:row
        for j = 1:column
            % if the index is in the range of the sky-region,
            % then we take the sky_resized_image pixel
            % otherwise, we remain the original image pixel
            if i <= each_column(j) && j <= sky_column
                replace_img(i,j, :) =  sky_resize_image(i,j,:);
            end
        end
    end
    
    figure(4)
    imshow(replace_img);
end