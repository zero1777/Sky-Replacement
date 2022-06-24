clear all;

src = 'clear_sun.jpg';
img = imread(src);
img = imresize(img, [600,800], 'bilinear');

[row, column, ~] = size(img);

hsv_img = rgb2hsv(img);
r = hsv_img(:,:,1);
variance = var(r(:));
% disp(var(r(:)));
% disp(max(r(:)))
% disp(min(r(:)))
% 0.01

cnt = 0;
for i = 1:row
    for j = 1:column
        if (hsv_img(i,j,1) >= 200/360 && hsv_img(i,j,1) <= 280/360) && (hsv_img(i,j,3) >= 0.5)
            cnt = cnt + 1;
        end
    end
end

% disp(cnt/(row * column));


disp(['variance: ' num2str(variance)])
disp(['pixel proportion: ' num2str(cnt/(row * column))])

if variance <= 0.01 && cnt/(row * column) >= 0.78
    disp('True');
else
    disp('False');
end