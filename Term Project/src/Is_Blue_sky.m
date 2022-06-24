function bool = Is_Blue_sky(img)

[row, column, ~] = size(img);

hsv_img = rgb2hsv(img);
r = hsv_img(:,:,1);
variance = var(r(:));

cnt = 0;
for i = 1:row
    for j = 1:column
        if (hsv_img(i,j,1) >= 200/360 && hsv_img(i,j,1) <= 280/360) && (hsv_img(i,j,3) >= 0.5)
            cnt = cnt + 1;
        end
    end
end


if variance <= 0.01 && cnt/(row * column) >= 0.78
    bool = 1;
else
    bool = 0;
end

