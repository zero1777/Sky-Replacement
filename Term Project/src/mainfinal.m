% src_name = '../picture/final_test/house.jpg';
% src_name = '../picture/final_test/Hill.tif';
src_name = '../picture/final_test/countryroad.tif';
tgt_nameC = '../picture/final_test/clear.tif';
tgt_nameD = '../picture/final_test/dusk_cut.tif';
tgt_nameS = '../picture/final_test/sunny.tif';
tgt_nameCL = '../picture/final_test/cloudy.tif';
tgt_nameN = '../picture/final_test/night.tif';
src_img = imread(src_name); 
tgt_imgC = imread(tgt_nameC);
tgt_imgD = imread(tgt_nameD);
tgt_imgS = imread(tgt_nameS);
tgt_imgCL = imread(tgt_nameCL);
tgt_imgN = imread(tgt_nameN);
% % show original image
figure(1);
subplot(2,3,1);
imshow(src_img);
subplot(2,3,2);
imshow(tgt_imgC);
subplot(2,3,3);
imshow(tgt_imgD);
subplot(2,3,4);
imshow(tgt_imgS);
subplot(2,3,5);
imshow(tgt_imgCL);
subplot(2,3,6);
imshow(tgt_imgN);


% % preprocess: (src,tgt) image resize / get source image size
src_img = imresize(src_img, [600,800], 'bilinear');
tgt_imgC = imresize(tgt_imgC, [600,800], 'bilinear');
tgt_imgD = imresize(tgt_imgD, [600,800], 'bilinear');
tgt_imgS = imresize(tgt_imgS, [600,800], 'bilinear');
tgt_imgCL = imresize(tgt_imgCL, [600,800], 'bilinear');
tgt_imgN = imresize(tgt_imgN, [600,800], 'bilinear');
[row, column, ~] = size(src_img);

% % -------------------------------------------------------
% % SEGMENTATION

% test_src_img = imColorSep(src_img);
num = 350;
[output,bw] = Segmentation(src_img, num);

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

% % -------------------------------------------------------
% % SKY STYLE TRANSFORMATION

if (Is_Blue_sky(tgt_imgC)) 
    rslt_imgC = ColorTransformation3(src_img , tgt_imgC);
else
    rslt_imgC = imhistmatch(src_img , tgt_imgC);
    rslt_imgC = im2double(rslt_imgC);
end
if (Is_Blue_sky(tgt_imgD)) 
    rslt_imgD = ColorTransformation3(src_img , tgt_imgD);
else
    rslt_imgD = imhistmatch(src_img , tgt_imgD);
    rslt_imgD = im2double(rslt_imgD);
end
if (Is_Blue_sky(tgt_imgS)) 
    rslt_imgS = ColorTransformation3(src_img , tgt_imgS);
else
    rslt_imgS = imhistmatch(src_img , tgt_imgS);
    rslt_imgS = im2double(rslt_imgS);
end
if (Is_Blue_sky(tgt_imgCL)) 
    rslt_imgCL = ColorTransformation3(src_img , tgt_imgCL);
else
    rslt_imgCL = imhistmatch(src_img , tgt_imgCL);
    rslt_imgCL = im2double(rslt_imgCL);
end
if (Is_Blue_sky(tgt_imgN)) 
    rslt_imgN = ColorTransformation3(src_img , tgt_imgN);
else
    rslt_imgN = imhistmatch(src_img , tgt_imgN);
    rslt_imgN = im2double(rslt_imgN);
end


% % -------------------------------------------------------
% % SKY REPLACE
% % Note: rslt_histmatch: uint8
for i = 1:1:row
    for j = 1:1:column
        if i <= b(j)
            rslt_imgC(i,j,:) = im2double(tgt_imgC(i,j,:));
            rslt_imgD(i,j,:) = im2double(tgt_imgD(i,j,:));
            rslt_imgS(i,j,:) = im2double(tgt_imgS(i,j,:));
            rslt_imgCL(i,j,:) = im2double(tgt_imgCL(i,j,:));
            rslt_imgN(i,j,:) = im2double(tgt_imgN(i,j,:));
%             src_img(i,j,:) = tgt_img(i,j,:);
        end
    end
end

% % Edge smooth
% % average filter
rslt_img_avgC = rslt_imgC;
rslt_img_avgD = rslt_imgD;
rslt_img_avgS = rslt_imgS;
rslt_img_avgCL = rslt_imgCL;
rslt_img_avgN = rslt_imgN;

% figure(3);
% imshow(rslt_hsv);
% title('ReinhardB');

avg_size = 5;
for j = 1:1:column
    rslt_img_avgC(b(j),j,:) = mean(rslt_img_avgC(max(b(j)-avg_size , 1):min(b(j)+avg_size , row),j,:));
    rslt_img_avgD(b(j),j,:) = mean(rslt_img_avgD(max(b(j)-avg_size , 1):min(b(j)+avg_size , row),j,:));
    rslt_img_avgS(b(j),j,:) = mean(rslt_img_avgS(max(b(j)-avg_size , 1):min(b(j)+avg_size , row),j,:));
    rslt_img_avgCL(b(j),j,:) = mean(rslt_img_avgCL(max(b(j)-avg_size , 1):min(b(j)+avg_size , row),j,:));
    rslt_img_avgN(b(j),j,:) = mean(rslt_img_avgN(max(b(j)-avg_size , 1):min(b(j)+avg_size , row),j,:));
%     src_img(b(j),j,:) = mean(src_img(b(j)-avg_size:b(j)+avg_size,j,:));
end

% lowpass Gaussian
% img_clt_trans_avg = img_clt_trans;
% % b : the sky / land segment line
rslt_img_finalC = GaussianLowpass(rslt_img_avgC , b);
rslt_img_finalD = GaussianLowpass(rslt_img_avgD , b);
rslt_img_finalS = GaussianLowpass(rslt_img_avgS , b);
rslt_img_finalCL = GaussianLowpass(rslt_img_avgCL , b);
rslt_img_finalN = GaussianLowpass(rslt_img_avgN , b);

figure(2);
subplot(2,3,1);
imshow(src_img);
title('Origin Picture');
subplot(2,3,2);
imshow(rslt_img_finalC);
title('Clear Replace');
subplot(2,3,3);
imshow(rslt_img_finalD);
title('Dusk Replace');
subplot(2,3,4);
imshow(rslt_img_finalS);
title('Sunny Replace');
subplot(2,3,5);
imshow(rslt_img_finalCL);
title('Cloudy Replace');
subplot(2,3,6);
imshow(rslt_img_finalN);
title('Night Replace');


