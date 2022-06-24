% image_name = 'picture/pic2.tif';
image_name = '../picture/nature/wasteland.tif';
read_image = imread(image_name);

out = read_image;
result = read_image;
% num_components = 100;
% [out , L] = Segmentation(read_image , num_components);
% 
% num_components = 50;
% [out , L] = Segmentation(out , num_components);
% 
% num_components = 2;
% [out , L] = Segmentation(out , num_components);
% [h , w , l] = size(read_image);
% for i=1:h
%     for j=1:w
%         rg = abs(read_image(i , j , 1) - read_image(i , j , 2));
%         gb = abs(read_image(i , j , 2) - read_image(i , j , 3));
%         rb = abs(read_image(i , j , 1) - read_image(i , j , 3));
%         if((rg < 50) && (gb < 50) && (rb < 50) && read_image(i , j , 1) > 190 && read_image(i , j , 2) > 190 && read_image(i , j , 3) > 190)
%            out(i,j,1) = 57;
%            out(i,j,2) = 132;
%            out(i,j,3) = 190;
%         else
%            out(i , j , :) = read_image(i , j , :);
%         end
%     end
% end

% for i = 200:-1:199
%     num_components = i;
%     [out , L] = Segmentation(out , num_components);
% end

[h , w , l] = size(out);
Hue = zeros(h,w);
for i=1:h
    for j=1:w
        R = im2double(out(i , j , 1));
        G = im2double(out(i , j , 2));
        B = im2double(out(i , j , 3));
        if B <= G
            Hue(i , j) = acos( (0.5 * ((R-G) + (R-B))) / ((R-G)^2 + ((R-B)*(G-B))^0.5));
        else 
            Hue(i , j) = 360 - acos( (0.5 * ((R-G) + (R-B))) / ((R-G)^2 + ((R-B)*(G-B))^0.5));
        end
    end
end

disp('Finish Hue');

ver_grad = zeros(h , w);
for i=2:h-1
   for j=1:w
        ver_grad(i,j) = -1*Hue(i-1,j)+Hue(i+1,j);
   end
end

for j=1:w
   [M , idx] = max(ver_grad(: , j)); 
   result(1:idx , j , :) = 0;
end
% J(:,:,1) = imadjust(read_image(:,:,1));
% J(:,:,2) = imadjust(read_image(:,:,2));
% J(:,:,3) = imadjust(read_image(:,:,3));
% figure(1);
% imshow(out);
figure(2);
imshow(read_image);
figure(3);
imshow(result);