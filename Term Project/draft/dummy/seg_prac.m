image_name = 'picture/pic1.tif';
read_image = imread(image_name);
% l: # layer
[h , w , l] = size(read_image);
result = read_image;
result2 = read_image;

[L,N] = superpixels(read_image,100);
pixel_idx = label2idx(L);
Ln = numel(L);

% image_LAB = rgb2lab(read_image);
% Aplab = image_LAB;

for k = 1:N
    idx = pixel_idx{k};
%     Aplab(idx) = mean(image_LAB(idx));
%     Aplab(idx+Ln) = mean(image_LAB(idx+Ln));
%     Aplab(idx+2*Ln) = mean(image_LAB(idx+2*Ln));
    result2(idx) = mean(read_image(idx));
    result2(idx+Ln) = mean(read_image(idx+Ln));
    result2(idx+2*Ln) = mean(read_image(idx+2*Ln));
end

% 
% BW = boundarymask(L);
% result = lab2rgb(Aplab);

result3 = result2;
[L2,N2] = superpixels(result2 , 50);
pixel_idx = label2idx(L2);
Ln = numel(L);
% BW2 = boundarymask(bound);
for k = 1:N2
    idx = pixel_idx{k};
    result3(idx) = mean(result2(idx));
    result3(idx+Ln) = mean(result2(idx+Ln));
    result3(idx+2*Ln) = mean(result2(idx+2*Ln));
end

result4 = result3;
[L3,N3] = superpixels(result3 , 4);
pixel_idx = label2idx(L3);
Ln = numel(L);
% BW2 = boundarymask(bound);
for k = 1:N3
    idx = pixel_idx{k};
    result4(idx) = mean(result3(idx));
    result4(idx+Ln) = mean(result3(idx+Ln));
    result4(idx+2*Ln) = mean(result3(idx+2*Ln));
end

result5 = result4;
[L4,N4] = superpixels(result4 , 2);
pixel_idx = label2idx(L4);
Ln = numel(L);
% BW2 = boundarymask(bound);
for k = 1:N4
    idx = pixel_idx{k};
    result5(idx) = mean(result4(idx));
    result5(idx+Ln) = mean(result4(idx+Ln));
    result5(idx+2*Ln) = mean(result4(idx+2*Ln));
end


subplot(2,3,1);
imshow(result);
subplot(2,3,2);
imshow(result2);
subplot(2,3,3);
imshow(result3);
subplot(2,3,4);
imshow(result4);
subplot(2,3,5);
imshow(result5);
subplot(2,3,6);
imshow(imoverlay(result,BW2,'black'),'InitialMagnification',67);



% imshow(uint8(L));

% disp part : 
% disp(size(L));
% disp(size(image_LAB));
% disp(N);
% disp(size(L));
% disp(L(15:45 , 5:30));
% disp(pixel_idx{1});
% disp(pixel_idx);
% disp(size(idx));
% disp(result(pixel_idx{1}));
% disp('---------------')
% disp(result(pixel_idx{2}));
% disp('---------------')
% disp(pixel_idx{1})




















% subplot(1,2,1)
% imshow(read_image);
% 
% img_mod = read_image;
% 
% for i=1:h
%     for j=1:w
%         if(img_mod(i , j , 2) > 50 && img_mod(i , j , 1) < 150 && img_mod(i , j , 3) < 150) 
%             img_mod(i , j , :) = 0;
%         end
%     end
% end
% 
% subplot(1,2,2)
% imshow(img_mod);