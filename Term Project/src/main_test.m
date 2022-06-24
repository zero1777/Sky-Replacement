% src_name = '../picture/pic2.tif';
src_name = "../picture/nature/wasteland.tif";
% src_name = '../picture/resort/dusk.tif';
% tgt_name = '../picture/pic0.tif';                       % fig.4 bset
% tgt_name = '../picture/resort/dusk.tif';                % fig.3,5 bset              
% tgt_name = '../picture/skybase/dawn.tif';               % fig.2,3 bset
tgt_name = '../picture/skybase/dust.tif';               % fig.3 bset
% tgt_name = '../picture/skybase/testnight.tif';          % fig.3,5 bset
% tgt_name = '../picture/skybase/day.tif';                % fig.4 bset
% tgt_name = '../picture/skybase/bluesky2.tif';           % no bset
% tgt_name = '../picture/skybase/cloudy.tif';             % fig.2 bset
% tgt_name = '../picture/skybase/test2.tif';              % no or fig.4 bset
% tgt_name = '../picture/skybase/dust.tif';  
% tgt_name = '../picture/skybase2/night.tif';             % fig.3,4,5 bset
% tgt_name = '../picture/skybase2/purple.tif';            % fig.2,3 bset
% tgt_name = '../picture/skybase2/mountain.tif';          % no or fig.4,5 bset
src_img = imread(src_name); 
tgt_img = imread(tgt_name);

figure(1);
subplot(1,2,1);
imshow(src_img);
subplot(1,2,2);
imshow(tgt_img);

% % preprocess_tgt : resize target image to same size as source image
% preprocess_tgt = imresize(tgt_img , [682,1024] , 'bilinear');
preprocess_tgt = imresize(tgt_img , [682,1024]);
preprocess_src = src_img;

[h , w , ~] = size(preprocess_tgt);
for i=1:300
    for j=1:w
        preprocess_src(i , j , :) = preprocess_tgt(i , j , :);
    end
end

[rslt_lab] = ColorTransformation(src_img , tgt_img , 1);
% gray_src_img = rgb2gray(src_img);
% gray_tgt_img = rgb2gray(tgt_img);
% gray_rslt_histmatch = imhistmatch(gray_src_img , gray_tgt_img);
% rslt_histmatch = gray2rgb(gray_rslt_histmatch);
rslt_histmatch = imhistmatch(src_img , tgt_img);
% K(: , : , 3) = K(: , : , 3)*0.85;
% [rslt_hsv] = ColorTransformation3(src_img , tgt_img(100:194 , : , :));
[rslt_hsv] = ColorTransformation3(src_img , tgt_img);

rslt_reinhard = cf_reinhard(src_img , tgt_img);
rslt_stainnorm_reinhard = stainnorm_reinhard(src_img , tgt_img);
% [result_img] = ColorTransformation3(clr_transfer , tgt_img);

pow_c = 2;
mean_tgt_B = mean(tgt_img(: , : , 3) , 'all');
if mean_tgt_B < 50
    pow_gma = 20 - mean_tgt_B / 10;
elseif mean_tgt_B > 200
    pow_gma = 1 + (mean_tgt_B / (-10) + 26);
else
    pow_gma = 1 + (mean_tgt_B / (-15) + 15);    % origin +18 (not +15)
end
rslt_pow = pow_c * (im2double(src_img)) .^ pow_gma;

figure(2);
imshow(rslt_lab);
figure(3);
imshow(rslt_histmatch);
figure(4);
imshow(rslt_hsv);
figure(5);
imshow(rslt_reinhard);
% figure(6)
% imshow(rslt_stainnorm_reinhard);
figure(7)
imshow(rslt_pow);


























% [clr_tnsfr_img] = ColorTransformation(src_img , tgt_img);
% [result_img] = ColorTransformation3(clr_tnsfr_img , tgt_img);

% % mean R of source image
% tgt_mr = mean(tgt_img(: , : , 1) , 'all');

% if (tgt_mr > 100)
%     [clr_tnsfr_img] = ColorTransformation(src_img , tgt_img);
%     [result_img] = ColorTransformation3(clr_tnsfr_img , tgt_img);
% else 
%     clr_tnsfr_img = zeros(size(clr_tnsfr_img));
%     [result_img] = ColorTransformation3(src_img , tgt_img);
% end






















% I = imread('pout.tif');
% figure
% subplot(2,2,1)
% imshow(I)
% subplot(2,2,2)
% imhist(I,32)
% subplot(2,2,3)
% imhist(I,64)
% subplot(2,2,4)
% imhist(I,128)

% [result_img] = ColorTransformation(src_img , tgt_img(81:207 , : , :));
% result_img2 = result_img;
% tgt_img = imresize(tgt_img , 4);
% [h , w , lyr] = size(result_img);
% for j=1:w
%     result_img(1:320 , j , :) = im2double(tgt_img(1:320 , j , :));
% end
% 
% % figure(1)
% % subplot(1,2,1)
% % imshow(src_img)
% % subplot(1,2,2)
% % imshow(tgt_img)
% figure(1)
% imshow(tgt_img)
% figure(2)
% imshow(result_img)
% figure(3)
% imshow(result_img2)