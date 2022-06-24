function b = Calculate_border(grad, threshold) 
    % grad --> gradient image %
    [row, column] = size(grad);
    b = zeros(column,1);
    for x = 1:1:column
        b(x) = row;
        for y = 1:1:row
            if grad(y,x) > threshold
                b(x) = y;
                break;
            end
        end
    end
end