image_name = '../picture/skybase/dust_cut.tif';
read_image = imread(image_name);
figure(1);
imshow(imresize(read_image , 10));
figure(2);
imshow(read_image);