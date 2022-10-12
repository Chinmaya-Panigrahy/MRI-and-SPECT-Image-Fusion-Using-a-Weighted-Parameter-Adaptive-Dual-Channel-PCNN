function bc=dbcbox(im,ws)
    x=floor(ws/2);
    im=padarray(im,[x x],'replicate');
    [row col]=size(im);
    re=zeros(row,col);
    for i=2:row-1
        for j=2:col-1
            mask=im(i-x:i+x,j-x:j+x);
            max_mask=max(mask(:));
            min_mask=min(mask(:));
            re(i,j)=max_mask-min_mask;
        end
    end
    bc=re(2:end-1,2:end-1);
    