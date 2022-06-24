clear all;
image_name = "test.jpg";
image = imread(image_name);
[row, column, ~] = size(image);
img = image;

thresh_min = 5;
thresh_max = 5;
search_step = 5;
border = Energy_func_opt(img, thresh_min, thresh_max, search_step);

for j = 1:1:column
    for i = 1:1:row
        if i <= border(j)
            img(i,j,1) = 0;
            img(i,j,2) = 0;
            img(i,j,3) = 0;
        end
    end
end

subplot(1,2,1),imshow(image),title('spatial domain result');
subplot(1,2,2),imshow(img),title('');