image_name1 = '../picture/pic2.tif';
image_name2 = '../picture/resort/dusk.tif';
% image_name2 = '../picture/skybase/dust_color.tif';
% image_name2 = '../picture/skybase/starnight.tif';
read_image1 = imread(image_name1);
read_image2 = imread(image_name2);

db_img1 = im2double(read_image1);
db_img2 = im2double(read_image2);
result_lab_img = zeros(size(read_image1));
result_img = zeros(size(read_image1));

% l: # layer
[h1 , w1 , l1] = size(read_image1);
[h2 , w2 , l2] = size(read_image2);
img_lab1 = rgb2lab(read_image1);
img_lab2 = rgb2lab(read_image2);
 
% mli => mean of L of image i    sli => standard deviation of L of image i
% mai => mean of A of image i    sai => standard deviation of A of image i
% mbi => mean of B of image i    sbi => standard deviation of B of image i
ml1 = mean(img_lab1(: , : , 1) , 'all');
ma1 = mean(img_lab1(: , : , 2) , 'all');
mb1 = mean(img_lab1(: , : , 3) , 'all');
ml2 = mean(img_lab2(: , : , 1) , 'all');
ma2 = mean(img_lab2(: , : , 2) , 'all');
mb2 = mean(img_lab2(: , : , 3) , 'all');
sl1 = std2(img_lab1(: , : , 1));
sa1 = std2(img_lab1(: , : , 2));
sb1 = std2(img_lab1(: , : , 3));
sl2 = std2(img_lab2(: , : , 1));
sa2 = std2(img_lab2(: , : , 2));
sb2 = std2(img_lab2(: , : , 3));

% ----------------------------------------------------
% l(*) = each point's L - mean of L
% l1_star : l(*) of image 1 
l1_star = img_lab1(: , : , 1) - ml1;
a1_star = img_lab1(: , : , 2) - ma1;
b1_star = img_lab1(: , : , 3) - mb1;

% l' = (sl2 / sl1) * l(*)
% l1_prompt : l' of image 1 
l1_prompt = (sl2 / sl1) * l1_star;
a1_prompt = (sa2 / sa1) * a1_star;
b1_prompt = (sb2 / sb1) * b1_star;
% ----------------------------------------------------
l1_final = l1_prompt + ml2;
a1_final = a1_prompt + ma2;
b1_final = b1_prompt + mb2;

result_lab_img(: , : , 1) = l1_final;
result_lab_img(: , : , 2) = a1_final;
result_lab_img(: , : , 3) = b1_final;

result_img = mat2gray(lab2rgb(result_lab_img));

figure(1)
subplot(1,2,1)
imshow(read_image1)
subplot(1,2,2)
imshow(read_image2)
figure(2)
subplot(1,2,1)
imshow(img_lab1)
subplot(1,2,2)
imshow(img_lab2)
figure(3)
subplot(1,2,1)
imshow(db_img1)
subplot(1,2,2)
imshow(result_img)

% math_lab = zeros(size(read_image1));
% LMS_matrix = [
%     0.3811 , 0.5783 , 0.0402;
%     0.1967 , 0.7244 , 0.0782;
%     0.0241 , 0.1288 , 0.8444;
% ];
% waste1 = 1 / sqrt(3);
% waste2 = 1 / sqrt(6);
% waste3 = 1 / sqrt(2);
% lab_matrix = [
%    waste1 , waste1 , waste1;
%    waste2 , waste2 , (-2) * waste2;
%    waste3 , (-1) * waste3 , 0;
% ];
% for i=1:h
%     for j=1:w
%         math_lab(i , j , :) = lab_matrix * log(LMS_matrix * reshape(db_img1(1 , 1 , :) , 3 , 1));
%     end
% end