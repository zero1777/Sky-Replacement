function result_img = GaussianLowpass(input_img , b)
    [row, column, ~] = size(input_img);
    result_img = input_img;
    K = 1;
    sigma = 1;
    kernel_size = 3;
    center = ceil(kernel_size/2);
    kernel = zeros(kernel_size , kernel_size);
    for i=1:kernel_size
        for j=1:kernel_size
            kernel(i , j) = K * exp( -( ( abs(i-center)^2 + abs(j-center)^2 ) / (2*sigma^2) ));
        end
    end
    for j = center:1:column-center
        temp = result_img(b(j)-(kernel_size-center):b(j)+(kernel_size-center) , j-(kernel_size-center):j+(kernel_size-center), : );
        temp1 = sum((temp(: , : , 1) .* kernel) , 'all') / sum(kernel , 'all');
        temp2 = sum((temp(: , : , 2) .* kernel) , 'all') / sum(kernel , 'all');
        temp3 = sum((temp(: , : , 3) .* kernel) , 'all') / sum(kernel , 'all');
        result_img(b(j),j,1) = temp1;
        result_img(b(j),j,2) = temp2;
        result_img(b(j),j,3) = temp3;
    end
end