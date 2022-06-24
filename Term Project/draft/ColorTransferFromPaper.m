clear all;

img1 = 'pic2.jpg';
image1 = imread(img1);
image1 = imresize(image1, [600,800], 'bilinear');
img2 = 'sky.jpg';
image2 = imread(img2);
img3 = 'ground.jpg';
image3 = imread(img3);
% image2 = imresize(image2, [600,800], 'bilinear');
% img1 = double(image1/255);
% img2 = double(image2/255);
% img1 = rgb2lab(img1);
% img2 = rgb2lab(img2);
% result = colour_transfer_MKL(img2,img1);

num = 350;
[output,bw] = Segmentation(image1, num, image1);
hsv_img = rgb2hsv(output);
[row, column, ~] = size(hsv_img);
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

% result = rgb2lab(result);
% result(:,:,1) = result(:,:,1) - 20;
% result = lab2rgb(result);
% imshow(result);

img1lab = rgb2lab(image1);
img2lab = rgb2lab(image2);
image1a = img1lab(:,:,2);
image1b = img1lab(:,:,3);
image2a = img2lab(:,:,2);
image2b = img2lab(:,:,3);
hist2a = imhist(image2a);
hist2b = imhist(image2b);
out = image1;
out(:,:,2) = histeq(image1a, hist2a);
out(:,:,3) = histeq(image1b, hist2b);

la = 0;
lb = 0;
Ra = 0;
Rb = 0;
count_l = 0;
count_R = 0;
val_l = 0;
val_R = 0;
val_2 = 0;
count_lab_l = 0;
count_lab_2 = 0;
count_lab_R = 0;
lab_l = rgb2lab(image1);
lab_2 = rgb2lab(image2);
lab_R = rgb2lab(image3);
[row, column, ~] = size(lab_l);
for i = 1:column
    for j = 1:row
        if j < b(i)
            la = la + lab_l(j,i,2);
            lb = lb + lab_l(j,i,3);
            count_l = count_l + 1;
        else
            val_l = val_l + lab_l(j,i,1);
            count_lab_l = count_lab_l + 1;
        end
    end
end
[row, column, ~] = size(image2);
for i = 1:column
    for j = 1:row
        Ra = Ra + lab_2(j,i,2);
        Rb = Rb + lab_2(j,i,3);
        count_lab_2 = count_lab_2 + 1;
    end
end
[row, column, ~] = size(image3);
for i = 1:column
    for j = 1:row
        val_R = val_R + lab_R(j,i,1);
        count_lab_R = count_lab_R + 1;
    end
end
la_sky = la / count_l;
lb_sky = lb / count_l;
Ra_sky = Ra / count_lab_2;
Rb_sky = Rb / count_lab_2;
beta_A = tanh(abs(la_sky - Ra_sky));
beta_B = tanh(abs(lb_sky - Rb_sky));
beta = mean([beta_A beta_B]);

L_in = val_l / count_lab_l;
L_Rn = val_R / count_lab_R;
out(:,:,1) = img1lab(:,:,1) + beta * (L_Rn - L_in);
figure(6)
imshow(out);

function IR = colour_transfer_MKL(I0, I1)

    if (ndims(I0)~=3)
        error('pictures must have 3 dimensions');
    end

    X0 = reshape(I0, [], size(I0,3));
    X1 = reshape(I1, [], size(I1,3));

    A = cov(X0);
    B = cov(X1);

    T = MKL(A, B);
%     T = [7.5,0,0;0,7.5,0;0,0,7.5];
    
    mX0 = repmat(mean(X0), [size(X0,1) 1]);
    mX1 = repmat(mean(X1), [size(X0,1) 1]);

    XR = (X0-mX0)*T + mX1;

    IR = reshape(XR, size(I0));
end

function [T] = MKL(A, B)
    N = size(A,1);
    [Ua,Da2] = eig(A); 
    Da2 = diag(Da2); 
    Da2(Da2<0) = 0;
    Da = diag(sqrt(Da2 + eps));
    C = Da*Ua'*B*Ua*Da;
    [Uc,Dc2] = eig(C); 
    Dc2 = diag(Dc2);
    Dc2(Dc2<0) = 0;
    Dc = diag(sqrt(Dc2 + eps));
    [row,~] = size(Dc);
    for i = 1:row
        if (Dc(i,i)<7.5)
            Dc(i,i) = 7.5;
        end
    end
    Da_inv = diag(1./(diag(Da)));
    T = Ua*Da_inv*Uc*Dc*Uc'*Da_inv*Ua';
end