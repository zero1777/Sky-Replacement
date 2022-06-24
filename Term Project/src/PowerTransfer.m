function result_img = PowerTransfer(src_img , tgt_img , pow_c)
    mean_tgt_B = mean(tgt_img(: , : , 3) , 'all');
    if mean_tgt_B < 50
        pow_gma = 20 - mean_tgt_B / 10;
    elseif mean_tgt_B > 200
        pow_gma = 1 + (mean_tgt_B / (-10) + 26);
    else
        pow_gma = 1 + (mean_tgt_B / (-15) + 15);    % origin +18 (not +15)
    end
    result_img = pow_c * (im2double(src_img)) .^ pow_gma;
end