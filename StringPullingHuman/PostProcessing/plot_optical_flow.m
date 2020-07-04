function plot_optical_flow(handles,fignum,fn,img1,img2,uv,step,scale_factor,minmax)
% mask = get_mask(handles,fn,'hands');
hf = figure(fignum);clf;
if isreal(uv)
%     imagesc(uv,minmax);
%     imagesc(find_mask_threshold(uv,2));
    imagesc(uv,minmax);
    axis equal;
    colorbar;
else
    % subplot 131;
    % imagesc(img1);
    % axis equal
    % subplot 132;
    % imagesc(img2);
    % axis equal
    u = real(uv);
    v = imag(uv);
    subplot 121;
    imagesc(img1);
    axis equal
    hold on;
    lenx = size(u,2);
    leny = size(u,1);
    [X Y] = meshgrid(1:lenx,1:leny);
    % step = 10;
    idxs = 1:step:leny;
    idys = 1:step:lenx;
    X = X(idxs,idys);
    Y = Y(idxs,idys);
    u = u(idxs,idys);
    v = v(idxs,idys);
    quiver(X,Y,u*scale_factor,v*scale_factor,'AutoScale','off','color','w')
    subplot 122
    uv = abs(u+i*v);
    uv = imresize(uv,4);
    imagesc(uv);
    axis equal;
    colorbar;
end