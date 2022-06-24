function [output,bw] = Segmentation(img, num, origin_img)
    [L,N] = superpixels(img, num);
    % L ---> region of matrix (enumrate the number to distinguish the areas)
    % N ---> total number of superpixels
    bound_idx = label2idx(L);
    % bound_idx ---> like a cells array, each cell has every indexs of that
    % region
    Ln = numel(L);
    % Ln ---> total pixels of the image
    output = img;
    
    % color the region we divide
    for k = 1:N
        idx = bound_idx{k};
        output(idx) = mean(img(idx));
        output(idx+Ln) = mean(img(idx+Ln));
        output(idx+2*Ln) = mean(img(idx+2*Ln)); 
        r = mean(img(idx));
        g = mean(img(idx+Ln));
        b = mean(img(idx+2*Ln));
        if b >= 200 && r >= 200 && g >= 200
           %output(idx) = 50;
           %output(idx+Ln) = 50;
           %output(idx+2*Ln)
        end
    end
    
    bw = boundarymask(L);
    figure(2)
    subplot(1,2,1),imshow(output),title('segmentation result');
    subplot(1,2,2),imshow(imoverlay(origin_img,bw,'black'),'InitialMagnification',100),title('segmentation line');
    
end