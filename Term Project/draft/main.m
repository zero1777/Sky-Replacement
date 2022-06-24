clear all;
image_name = "valley.tif";
image = imread(image_name);
image = imresize(image, [600,800], 'bilinear');
[row, column, ~] = size(image);



%figure(1)
%imshow(image);
%title('original image');
num = 300;
[output,bw] = Segmentation(image, num, image);
%output = imcomplement(output);
%disp(output);

for num = 200:-2:8
    [output,bw] = Segmentation(output, num, image);
end

%{
[row, column, ~] = size(output);

gray_opt = rgb2gray(output);
[grad, ~] = imgradient(gray_opt);
bdr = Calculate_border(grad, 300);
%}
%{
for i = 1:1:row
    for j = 1:1:column
        if i <= b(j)
            output(i,j,:) = 0;
        end
    end
end
%}
%l = zeros(row, column);

%{
l = zeros(column);
for j = 1:1:column
    for i = 1:1:row
        r = output(i,j,1);
        g = output(i,j,2);
        b = output(i,j,3);
        if b <= 100 && grad(i,j) >= 50
            l(j) = i;
            break;
        end
    end
end

for j = 1:1:column
    for i = 1:1:l(j)
        image(i,j,:) = 0;
    end
end
figure(3)
imshow(image);
%}

wavelength = 2.^(0:5) * 3;
orientation = 0:45:135;
g = gabor(wavelength,orientation);
I = rgb2gray(im2single(output));  
gabormag = imgaborfilt(I,g);
for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),3*sigma); 
end
nrows = size(output,1);
ncols = size(output,2);
[X,Y] = meshgrid(1:ncols,1:nrows);
featureSet = cat(3,I,gabormag,X,Y);

[l, bw] = imsegkmeans(output, 2);

result = labeloverlay(image, l);
figure(3)
imshow(result);

% image_name = 'twilight.jpg';
% sky_image = imread(image_name);
% sky_replace_img = SkyReplacement(image, sky_image, l);
% 
% figure(4)
% imshow(sky_replace_img);
% sky_image = imresize(sky_image, [600,800], 'bilinear');
% l = l-1;

        



