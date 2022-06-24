function result_img = ColorTransformation2(src_img , tgt_img)
% % tgt_img (source image) : gives the color style                         
% % trgt_img(target image) : the picture whose color style to be changed  
db_src_img = im2double(src_img);
db_tgt_img = im2double(tgt_img);
% % --------------------------------------
% % mr => mean of R
% % mg => mean of G
% % mb => mean of B
src_mr = mean(db_src_img(: , : , 1) , 'all');
src_mg = mean(db_src_img(: , : , 2) , 'all');
src_mb = mean(db_src_img(: , : , 3) , 'all');

tgt_mr = mean(db_tgt_img(: , : , 1) , 'all');
tgt_mg = mean(db_tgt_img(: , : , 2) , 'all');
tgt_mb = mean(db_tgt_img(: , : , 3) , 'all');

% % --------------------------------------
% % eigr => eigenvalue of R
src_eigr = eig(cov(db_src_img(: , : , 1)));
src_eigg = eig(cov(db_src_img(: , : , 2)));
src_eigb = eig(cov(db_src_img(: , : , 3)));
tgt_eigr = eig(cov(db_tgt_img(: , : , 1)));
tgt_eigg = eig(cov(db_tgt_img(: , : , 2)));
tgt_eigb = eig(cov(db_tgt_img(: , : , 3)));
% disp(2);
result_img = src_eigr
% % --------------------------------------
% % translation matrix
src_T_matrix = eye(4);
src_T_matrix(1:3 , 4) = [-src_mr , -src_mg , -src_mb];
tgt_T_matrix = eye(4);
tgt_T_matrix(1:3 , 4) = [tgt_mr , tgt_mg , tgt_mb];
% % rotation    matrix 
src_R_matrix = eye(4);
tgt_R_matrix = eye(4);
% % scaling     matrix
src_S_matrix = eye(4);
tgt_S_matrix = eye(4);
end