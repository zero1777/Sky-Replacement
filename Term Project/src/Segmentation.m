function [output,bw] = Segmentation(img, num)
%     [h,w,l] = size(img);
%     for i=1:h
%         for j=1:w
%             if(img(i , j , 1) > img(i , j , 2) && img(i , j , 1) > img(i , j , 3))
%                 k = 1;
%             elseif(img(i , j , 2) > img(i , j , 3))
%                 k = 2;
%             else
%                 k = 3;
%             end
%             img(i , j , k) = 255;
%         end
%     end

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
    end
    
    bw = boundarymask(L);
%     figure(1)
%     subplot(1,2,1),imshow(output),title('segmentation result');
%     subplot(1,2,2),imshow(imoverlay(img,bw,'black'),'InitialMagnification',100),title('segmentation line');
    
end