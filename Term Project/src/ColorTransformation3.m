function result_img = ColorTransformation3(src_img , tgt_img)
% % tgt_img (source image) : gives the color style                         
% % trgt_img(target image) : the picture whose color style to be changed  

tgt_blue_enhance = tgt_img;
tgt_blue_enhance(: , : , 1:2) = 0;

src_hsv = rgb2hsv(src_img);
tgt_hsv = rgb2hsv(tgt_blue_enhance);

% % mv : mean               of hsv's value
% % sv : standard deviation of hsv's value
src_mh = mean(src_hsv(: , : , 1) , 'all');
src_ms = mean(src_hsv(: , : , 2) , 'all');
src_mv = mean(src_hsv(: , : , 3) , 'all');
src_sh = std2(src_hsv(: , : , 1));
src_ss = std2(src_hsv(: , : , 2));
src_sv = std2(src_hsv(: , : , 3));
tgt_mh = mean(tgt_hsv(: , : , 1) , 'all');
tgt_ms = mean(tgt_hsv(: , : , 2) , 'all');
tgt_mv = mean(tgt_hsv(: , : , 3) , 'all');
tgt_sh = std2(tgt_hsv(: , : , 1));
tgt_ss = std2(tgt_hsv(: , : , 2));
tgt_sv = std2(tgt_hsv(: , : , 3));

src_final = src_hsv;
src_final(: , : , 3) = (tgt_sv/src_sv) * ((src_hsv(: , : , 3) - src_mv)) + tgt_mv;
% src_final(: , : , 2) = (tgt_ss/src_ss) * ((src_hsv(: , : , 2) - src_ms)) + tgt_ms;
% src_final(: , : , 1) = (tgt_sh/src_sh) * ((src_hsv(: , : , 1) - src_mh)) + tgt_mh;
result_img = hsv2rgb(src_final);


end