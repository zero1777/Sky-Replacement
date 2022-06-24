function result_img = ColorTransformation(src_img , tgt_img , w1)
% % tgt_img (source image) : gives the color style                         
% % src_img(target image) : the picture whose color style to be changed  

% db_tgt_img = im2double(tgt_img);
% db_src_img = im2double(src_img);
result_lab_img = zeros(size(src_img));
% result_img = zeros(size(tgt_img));

% % lyr: # layer
% [h1 , w1 , lyr1] = size(tgt_img);
% [h2 , w2 , lyr2] = size(src_img);
src_img_lab = rgb2lab(double(src_img));
tgt_img_lab = rgb2lab(double(tgt_img));
% src_img_lab = (src_img);
% tgt_img_lab = (tgt_img);
 
% % mli => mean of L of image i   % % sli => standard deviation of L of image i
% % mai => mean of A of image i   % % sai => standard deviation of A of image i
% % mbi => mean of B of image i   % % sbi => standard deviation of B of image i
src_ml = mean(src_img_lab(: , : , 1) , 'all');
src_ma = mean(src_img_lab(: , : , 2) , 'all');
src_mb = mean(src_img_lab(: , : , 3) , 'all');
src_sl = std2(src_img_lab(: , : , 1));
src_sa = std2(src_img_lab(: , : , 2));
src_sb = std2(src_img_lab(: , : , 3));
tgt_ml = mean(tgt_img_lab(: , : , 1) , 'all');
tgt_ma = mean(tgt_img_lab(: , : , 2) , 'all');
tgt_mb = mean(tgt_img_lab(: , : , 3) , 'all');
tgt_sl = std2(tgt_img_lab(: , : , 1));
tgt_sa = std2(tgt_img_lab(: , : , 2));
tgt_sb = std2(tgt_img_lab(: , : , 3));

% ----------------------------------------------------
% l(*) = each point's L - mean of L
% src_l_star : l(*) of target image 
src_l_star = src_img_lab(: , : , 1) - src_ml;
src_a_star = src_img_lab(: , : , 2) - src_ma;
src_b_star = src_img_lab(: , : , 3) - src_mb;

% l' = (tgt_sl / src_sl) * l(*)
% src_l_prompt : l' of target image 
w2 = 1 - w1;
src_l_prompt = w1 * (tgt_sl / src_sl) * src_l_star + w2;
src_a_prompt = w1 * (tgt_sa / src_sa) * src_a_star + w2;
src_b_prompt = w1 * (tgt_sb / src_sb) * src_b_star + w2;
% ----------------------------------------------------
src_l_final = src_l_prompt + tgt_ml;
src_a_final = src_a_prompt + tgt_ma;
src_b_final = src_b_prompt + tgt_mb;

result_lab_img(: , : , 1) = src_l_final;
result_lab_img(: , : , 2) = src_a_final;
result_lab_img(: , : , 3) = src_b_final;

result_img = uint8(lab2rgb(result_lab_img));
% result_img = result_lab_img;
end