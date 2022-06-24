function b_opt = Energy_func_opt(img, thresh_min, thresh_max, search_step)
    [~,column,~] = size(img);
    n = (thresh_max - thresh_min) / search_step + 1;
    jn_max = 0;
    b_opt = zeros(column,1);
    [grad,~] = imgradient(rgb2gray(img));
    for k = 1:1:n
        t = thresh_min + (search_step) * (k-1);
        disp(grad);
        b_opt = Calculate_border(grad, 300);
        % Calculate jn(t) with its corresponding b_tmp %
        %{
        jn = Calculate_energy_func(img, b_tmp);
        if jn > jn_max
            jn_max = jn;
            b_opt = b_tmp;
        end
        %}
    end
end
