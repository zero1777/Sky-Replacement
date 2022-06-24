src_name = 'sky/364215.jpg';
% src_name = '../picture/building/Japan2.tif';
% src_name = "../picture/nature/wasteland.tif";
% src_name = '../picture/resort/dusk.tif';
% tgt_name = '../picture/pic0.tif';                       % fig.4 bset
% tgt_name = '../picture/resort/dusk.tif';                % fig.3,5 bset              
% tgt_name = '../picture/skybase/dawn.tif';               % fig.2,3 bset
tgt_name = 'sky/cloud.jpg';               % fig.3 bset
% tgt_name = '../picture/skybase/testnight.tif';          % fig.3,5 bset
% tgt_name = '../picture/skybase/day.tif';                % fig.4 bset
% tgt_name = '../picture/skybase/bluesky2.tif';           % no bset
% tgt_name = '../picture/skybase/cloudy.tif';             % fig.2 bset
% tgt_name = '../picture/skybase/cloudy2.tif';             % fig.2 bset
% tgt_name = '../picture/skybase/test2.tif';              % no or fig.4 bset
% tgt_name = '../picture/skybase/dust.tif';  
% tgt_name = '../picture/skybase2/night.tif';             % fig.3,4,5 bset
% tgt_name = '../picture/skybase2/purple.tif';            % fig.2,3 bset
% tgt_name = '../picture/skybase2/mountain.tif';          % no or fig.4,5 bset
src_img = imread(src_name); 
tgt_img = imread(tgt_name);
% % show original image
figure(1);
subplot(1,2,1);
imshow(src_img);
title('source image');
subplot(1,2,2);
imshow(tgt_img);
title('target image');

% % preprocess: (src,tgt) image resize / get source image size
src_img = imresize(src_img, [600,800], 'bilinear');
tgt_img = imresize(tgt_img, [600,800], 'bilinear');
[row, column, ~] = size(src_img);

% % -------------------------------------------------------
% % SEGMENTATION

% test_src_img = imColorSep(src_img);
num = 350;
[output,bw] = Segmentation(src_img, num);

gray_opt = rgb2gray(output);
[grad, ~] = imgradient(gray_opt);
% bdr = Calculate_border(grad, 80);

tmp = src_img;
hsv_img = rgb2hsv(output);
b = zeros(column,1);
for x = 1:1:column
    b(x) = row;
    for y = 1:1:row
        if ~((hsv_img(y,x,1) >= 190/360 && hsv_img(y,x,1) <= 290/360) || (hsv_img(y,x,3) >= 0.85))
            b(x) = y;
            
            break;
        end
        tmp(x,y,:) = 0;
    end
end

% % -------------------------------------------------------
% % SKY STYLE TRANSFORMATION

% % --------------
[rslt_lab] = ColorTransformation(src_img , tgt_img , 0.6);
% % --------------
[rslt_histmatch] = imhistmatch(src_img , tgt_img);
% % --------------
[rslt_hsv] = ColorTransformation3(src_img , tgt_img);
% % --------------
[rslt_reinhard] = cf_reinhard(src_img , tgt_img);
% % --------------
power = 2;
[rslt_pow] = PowerTransfer(src_img , tgt_img , power);
% % --------------
[rslt_CFX , rslt_CFX_r] = CF_Xiao06(src_img , tgt_img);
% rslt_CFX = imresize(rslt_CFX, [600,800], 'bilinear');
% rslt_CFX_r = imresize(rslt_CFX_r, [600,800], 'bilinear');
% % --------------
rslt_lab = im2double(rslt_lab);
rslt_histmatch = im2double(rslt_histmatch);

% % -------------------------------------------------------
% % SKY REPLACE
% % Note: rslt_histmatch: uint8
for i = 1:1:row
    for j = 1:1:column
        if i <= b(j)
            rslt_lab(i,j,:) = im2double(tgt_img(i,j,:));
            rslt_histmatch(i,j,:) = im2double(tgt_img(i,j,:));
            rslt_hsv(i,j,:) = im2double(tgt_img(i,j,:));
            rslt_reinhard(i,j,:) = im2double(tgt_img(i,j,:));
            rslt_pow(i,j,:) = im2double(tgt_img(i,j,:));
            rslt_CFX(i,j,:) = im2double(tgt_img(i,j,:));
            rslt_CFX_r(i,j,:) = im2double(tgt_img(i,j,:));
%             src_img(i,j,:) = tgt_img(i,j,:);
        end
    end
end

% % Edge smooth
% % average filter
rslt_lab_avg = rslt_lab;
rslt_histmatch_avg = rslt_histmatch;
rslt_hsv_avg = rslt_hsv;
rslt_reinhard_avg = rslt_reinhard;
rslt_pow_avg = rslt_pow;
rslt_CFX_avg = rslt_CFX;
rslt_CFX_r_avg = rslt_CFX_r;

avg_size = 5;
for j = 1:1:column
    rslt_lab_avg(b(j),j,:) = mean((rslt_lab_avg(max(b(j)-avg_size , 1):b(j)+avg_size,j,:)));
    rslt_histmatch_avg(b(j),j,:) = mean(rslt_histmatch_avg(max(b(j)-avg_size , 1):b(j)+avg_size,j,:));
    rslt_hsv_avg(b(j),j,:) = mean(rslt_hsv_avg(max(b(j)-avg_size , 1):b(j)+avg_size,j,:));
    rslt_reinhard_avg(b(j),j,:) = mean(rslt_reinhard_avg(max(b(j)-avg_size , 1):b(j)+avg_size,j,:));
    rslt_pow_avg(b(j),j,:) = mean(rslt_pow_avg(max(b(j)-avg_size , 1):b(j)+avg_size,j,:));
    rslt_CFX_avg(b(j),j,:) = mean(rslt_CFX(max(b(j)-avg_size , 1):b(j)+avg_size,j,:));
    rslt_CFX_r_avg(b(j),j,:) = mean(rslt_CFX_r(max(b(j)-avg_size , 1):b(j)+avg_size,j,:));
%     src_img(b(j),j,:) = mean(src_img(b(j)-avg_size:b(j)+avg_size,j,:));
end

% lowpass Gaussian
% img_clt_trans_avg = img_clt_trans;
% % b : the sky / land segment line
rslt_lab_final = GaussianLowpass(rslt_lab_avg , b);
rslt_histmatch_final = GaussianLowpass(rslt_histmatch_avg , b);
rslt_hsv_final = GaussianLowpass(rslt_hsv_avg , b);
rslt_reinhard_final = GaussianLowpass(rslt_reinhard_avg , b);
rslt_pow_final = GaussianLowpass(rslt_pow_avg , b);
rslt_CFX_final = GaussianLowpass(rslt_CFX_avg , b);
rslt_CFX_r_final = GaussianLowpass(rslt_CFX_r_avg , b);

figure(9);
imshow(output);
title('Segmentation')
figure(2);
imshow(rslt_lab_final);
title('Lab transfer');
figure(3);
imshow(rslt_histmatch_final);
title('Histmatch');
figure(4);
imshow(rslt_hsv_final);
title('HSV with v change');
figure(5);
imshow(rslt_reinhard_final);
title('Reinhard');
figure(6);
imshow(rslt_pow_final);
title('Power');
figure(7);
imshow(rslt_CFX_final);
title('CFX');
figure(8);
imshow(rslt_CFX_r_final);
title('CFX_r');




% img_TMR = TMR(im2double(src_img) , img_clt_trans , 1);
% figure(7)
% imshow(img_TMR);