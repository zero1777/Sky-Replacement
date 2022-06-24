function result_img = ColorTransformation(trgt_img , src_img)
% % src_img (source image) : gives the color style                         
% % trgt_img(target image) : the picture whose color style to be changed  

% db_src_img = im2double(src_img);
% db_trgt_img = im2double(trgt_img);
result_lab_img = zeros(size(trgt_img));
% result_img = zeros(size(src_img));

% % lyr: # layer
% [h1 , w1 , lyr1] = size(src_img);
% [h2 , w2 , lyr2] = size(trgt_img);
trgt_img_lab = rgb2lab(trgt_img);
src_img_lab = rgb2lab(src_img);
 
% % mli => mean of L of image i   % % sli => standard deviation of L of image i
% % mai => mean of A of image i   % % sai => standard deviation of A of image i
% % mbi => mean of B of image i   % % sbi => standard deviation of B of image i
trgt_ml = mean(trgt_img_lab(: , : , 1) , 'all');
trgt_ma = mean(trgt_img_lab(: , : , 2) , 'all');
trgt_mb = mean(trgt_img_lab(: , : , 3) , 'all');
trgt_sl = std2(trgt_img_lab(: , : , 1));
trgt_sa = std2(trgt_img_lab(: , : , 2));
trgt_sb = std2(trgt_img_lab(: , : , 3));
src_ml = mean(src_img_lab(: , : , 1) , 'all');
src_ma = mean(src_img_lab(: , : , 2) , 'all');
src_mb = mean(src_img_lab(: , : , 3) , 'all');
src_sl = std2(src_img_lab(: , : , 1));
src_sa = std2(src_img_lab(: , : , 2));
src_sb = std2(src_img_lab(: , : , 3));

% ----------------------------------------------------
% l(*) = each point's L - mean of L
% trgt_l_star : l(*) of target image 
trgt_l_star = trgt_img_lab(: , : , 1) - trgt_ml;
trgt_a_star = trgt_img_lab(: , : , 2) - trgt_ma;
trgt_b_star = trgt_img_lab(: , : , 3) - trgt_mb;

% l' = (src_sl / trgt_sl) * l(*)
% trgt_l_prompt : l' of target image 
trgt_l_prompt = (src_sl / trgt_sl) * trgt_l_star;
trgt_a_prompt = (src_sa / trgt_sa) * trgt_a_star;
trgt_b_prompt = (src_sb / trgt_sb) * trgt_b_star;
% ----------------------------------------------------
trgt_l_final = trgt_l_prompt + src_ml;
trgt_a_final = trgt_a_prompt + src_ma;
trgt_b_final = trgt_b_prompt + src_mb;

result_lab_img(: , : , 1) = trgt_l_final;
result_lab_img(: , : , 2) = trgt_a_final;
result_lab_img(: , : , 3) = trgt_b_final;

result_img = lab2rgb(result_lab_img);
result_img = uint8(255 * mat2gray(result_img));

end