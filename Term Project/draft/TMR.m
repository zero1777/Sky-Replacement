function K = TMR(I,J,n)

%TMR Transportation Maps Regularisation -- Artefact-free color and contrast
%    modification. This can be used for color transfer denoising.
%   J = TMR(I_s, I_t, n) returns the artifact-removed color change output
%   where I_s is the original input image, I_t is the defective colour
%   changed result and the variable n is the number of iteration.
%   Copyright 2017 Han Gong <gong@fedoraproject.org>, University of East
%   Anglia
%   References:
%      Removing Artefacts From Color and Contrast Modifications, 
%      IEEE Transactions on Image Processing (TIP),
%      J. Rabin, J. Delon, and Y. Gousseau, 2011.
    if ~exist('n','var'), n=5; end 
    K = J;
    [ny,nx,~] = size(I);
    c_map = ones(ny,nx);
    for i = 1:n
        disp('mabi')
        [K,c_map] = y_transfer(I,K,c_map);
    end
end
function [K,C_map] = y_transfer(I,J,c_map,win,sig)
% please check the paper for the detailed explanations of the parameters.
% c_map -- convergence map
% win -- filter window size
% sig -- the sigma value for filter
[ny,nx,~] = size(I);
if ~exist('sig','var'), sig = 10; end
if ~exist('win','var'), win = 10; end
D = sig^-2;
fI = reshape(I,[],3);
fJ = reshape(J,[],3);
fmap = fJ-fI;
fNL_map = zeros(ny*nx,3);
fc_map = reshape(c_map,[],1);
% search on the whole image
for px = 1:nx
    for py= 1:ny
        % current index
        i = sub2ind([ny,nx],py,px);
        
        if fc_map(i)>0
            minx = max(1,px-win);  maxx = min(nx-1,px+win);
            miny = max(1,py-win);  maxy = min(ny-1,py+win);
            [X,Y] = meshgrid(minx:maxx,miny:maxy);
            Y = reshape(Y,[],1); X = reshape(X,[],1);
            j_set = sub2ind([ny,nx],Y,X);
            dIiI = fI(i,:) - fI(j_set,:);
            d = exp(sum(dIiI.^2,2)*D);
            poi = sum(d);
            meanRGB = fmap(j_set,:).*d;
            fNL_map(i,:) = sum(meanRGB,1)/poi;
        else
            fNL_map(i,:) = fmap(i,:);
        end
    end
end
fK = fI + fNL_map;
fC_map = zeros(size(fc_map));
msk = fc_map>0;
fC_map(msk) = sqrt(sum((fK(msk,:)-fJ(msk,:)).^2,2));
K = reshape(fK,[ny,nx,3]);
C_map = reshape(fC_map,[ny,nx]);
end
