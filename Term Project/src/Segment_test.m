% image_name = "../picture/nature/wasteland.tif";
image_name = "../picture/pic2.tif";
% sky_image_name = '../picture/skybase2/night.tif';
sky_image_name = '../picture/skybase/dust.tif';               % fig.3 bset
image = imread(image_name);
sky_image = imread(sky_image_name);
image = imresize(image, [600,800], 'bilinear');
sky_image = imresize(sky_image, [500,800], 'bilinear');
[row, column, ~] = size(image);

% test_image = imColorSep(image);
figure(1)
imshow(image);
title('original image');
num = 350;
[output,bw] = Segmentation(image, num);

gray_opt = rgb2gray(output);
[grad, ~] = imgradient(gray_opt);
% bdr = Calculate_border(grad, 80);

hsv_img = rgb2hsv(output);
b = zeros(column,1);
for x = 1:1:column
    b(x) = row;
    for y = 1:1:row
        if ~((hsv_img(y,x,1) >= 190/360 && hsv_img(y,x,1) <= 290/360) || (hsv_img(y,x,3) >= 0.85))
            b(x) = y;
            break;
        end
    end
end

% img_clt_trans = ColorTransformation3(image , sky_image);
img_clt_trans = im2double(imhistmatch(image , sky_image));

for i = 1:1:row
    for j = 1:1:column
        if i <= b(j)
            img_clt_trans(i,j,:) = im2double(sky_image(i,j,:));
            image(i,j,:) = sky_image(i,j,:);
        end
    end
end

figure(3)
imshow(img_clt_trans);

% % use function
% for j = 1:1:column
%     rshp = reshape(img_clt_trans(b(j)-4:b(j)+4,j,:), 3 , 3 , size(img_clt_trans,3));
%     lowps(: , : , 1) = lowpass(rshp(: , : , 1) , 150);
%     lowps(: , : , 2) = lowpass(rshp(: , : , 2) , 150);
%     lowps(: , : , 3) = lowpass(rshp(: , : , 3) , 150);
%     img_clt_trans(b(j)-4:b(j)+4,j,:) = reshape(lowps, [] , 9 , size(lowps,3));
% end
% ------------------------

% average filter
img_clt_trans_avg = img_clt_trans;
avg_size = 5;
for j = 1:1:column
    img_clt_trans_avg(b(j),j,:) = mean(img_clt_trans_avg(b(j)-avg_size:b(j)+avg_size,j,:));
    image(b(j),j,:) = mean(image(b(j)-avg_size:b(j)+avg_size,j,:));
end
figure(4)
imshow(img_clt_trans_avg);

% lowpass Gaussian
img_clt_trans_avg = img_clt_trans;
K = 1;
sigma = 1;
kernel_size = 3;
center = ceil(kernel_size/2);
kernel = zeros(kernel_size , kernel_size);
for i=1:kernel_size
    for j=1:kernel_size
        kernel(i , j) = K * exp( -( ( abs(i-center)^2 + abs(j-center)^2 ) / (2*sigma^2) ));
    end
end
for j = center:1:column-center
    temp = img_clt_trans_avg( b(j)-(kernel_size-center):b(j)+(kernel_size-center) , j-(kernel_size-center):j+(kernel_size-center), : );
    temp1 = sum((temp(: , : , 1) .* kernel) , 'all') / sum(kernel , 'all');
    temp2 = sum((temp(: , : , 2) .* kernel) , 'all') / sum(kernel , 'all');
    temp3 = sum((temp(: , : , 3) .* kernel) , 'all') / sum(kernel , 'all');
    img_clt_trans_avg(b(j),j,1) = temp1;
    img_clt_trans_avg(b(j),j,2) = temp2;
    img_clt_trans_avg(b(j),j,3) = temp3;
end

figure(5)
% imshow(img_clt_trans_gau);
imshow(img_clt_trans_avg);

% img_TMR = TMR(im2double(image) , img_clt_trans , 1);
% 
% figure(7)
% imshow(img_TMR);






%output = imcomplement(output);
%disp(output);

% for num = 200:-2:8
%     [output,bw] = Segmentation(output, num, image);
% end

%{
[row, column, ~] = size(output);

gray_opt = rgb2gray(output);
[grad, ~] = imgradient(gray_opt);
bdr = Calculate_border(grad, 300);
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

% wavelength = 2.^(0:5) * 3;
% orientation = 0:45:135;
% g = gabor(wavelength,orientation);
% I = rgb2gray(im2single(output));  
% gabormag = imgaborfilt(I,g);
% for i = 1:length(g)
%     sigma = 0.5*g(i).Wavelength;
%     gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),3*sigma); 
% end
% nrows = size(output,1);
% ncols = size(output,2);
% [X,Y] = meshgrid(1:ncols,1:nrows);
% featureSet = cat(3,I,gabormag,X,Y);
% 
% [l, bw] = imsegkmeans(featureSet, 2);
% 
% result = labeloverlay(image, l);
% figure(3)
% imshow(result);

% image_name = 'twilight.jpg';
% sky_image = imread(image_name);
% sky_replace_img = SkyReplacement(image, sky_image, l);