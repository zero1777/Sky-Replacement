function jn = Calculate_energy_func(img, b)
    [row, column,~] = size(img);
    gamma = 2;
    
    % calculate the mean of S, G
    cnt_sky = 0;
    cnt_ground = 0;
    sum_sky = zeros(3,1);
    sum_ground = zeros(3,1);
    for j = 1:1:column
        for i = 1:1:b(j)
            cnt_sky = cnt_sky + 1;
            % read the RGB values
            tmp = zeros(3,1);
            tmp(1) = image(i,j,1);
            tmp(2) = image(i,j,2);
            tmp(3) = image(i,j,3);
            tmp = tmp.';
            sum_sky = sum_sky + tmp;
        end
        for i = (b(j)+1):1:row
            cnt_ground = cnt_ground + 1;
            % read the RGB values
            tmp = zeros(3,1);
            tmp(1) = image(i,j,1);
            tmp(2) = image(i,j,2);
            tmp(3) = image(i,j,3);
            tmp = tmp.';
            sum_ground = sum_ground + tmp;
        end
    end
    mean_sky = sum_sky / cnt_sky;
    mean_ground = sum_ground / cnt_ground;
    
    % calculate the covariance of S, G
    covar_sky = zeros(3,3);
    covar_ground = zeros(3,3);
    for j = 1:1:column
        for i = 1:1:b(j)
            % read the RGB values
            tmp = zeros(3,1);
            tmp(1) = image(i,j,1);
            tmp(2) = image(i,j,2);
            tmp(3) = image(i,j,3);
            tmp = tmp - mean_sky;
            tmp2 = tmp.'; 
            covar_sky = covar_sky + tmp2 * tmp;
        end
        for i = b(j)+1:1:row
            % read the RGB values
            tmp = zeros(3,1);
            tmp(1) = image(i,j,1);
            tmp(2) = image(i,j,2);
            tmp(3) = image(i,j,3);
            tmp = tmp - mean_ground;
            tmp2 = tmp.';   
            covar_ground = covar_ground + tmp2 * tmp;
        end 
    end
    covar_sky = covar_sky / cnt_sky;
    covar_ground = covar_ground / cnt_ground;
    
    % calculate the eigenvalues of the covariance matrix of sky and ground 
    % we only take the max eigenvalue for calculation
    eigen_sky = max(eig(covar_sky));
    eigen_ground = max(eig(covar_ground));
    jn = 1 / (gamma*det(covar_sky) + covar_ground + gamma*det(eigen_sky) + eigen_ground);
end