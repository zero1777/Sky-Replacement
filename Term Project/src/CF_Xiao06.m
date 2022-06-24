function [IR1 , IR2] = CF_Xiao06(src_img , tgt_img)
    I0 = im2double(src_img);
    I1 = im2double(tgt_img);

    % Process without additional ruggedisation processing.
    IR1 = cf_Xiao06_ruggedised(I0,I1,false);
    % Process with additional ruggedisation processing.
    IR2 = cf_Xiao06_ruggedised(I0,I1,true);
end