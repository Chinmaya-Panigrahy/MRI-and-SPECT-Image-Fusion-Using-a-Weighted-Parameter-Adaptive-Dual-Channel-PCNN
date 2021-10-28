 %If you use this code, Please cite our Paper "MRI and SPECT Image Fusion Using a Weighted Parameter Adaptive Dual Channel PCNN"  
 %in IEEE Signal Processing Letters, vol. 27, pp. 690-694, 2020, doi: 10.1109/LSP.2020.2989054


 clear all
 P=imread('MRI.png');  % A MxN matrix
 Q=imread('SPECT.png');  % A MxNx3 matrix

  if size(Q,3)==3       % For MRI-SPECT Image Fusion
        tic
        FD1=IDBC(P);     % Finding FD using Improved DBC Method
        P=double(P)/255;
        Q=double(Q)/255;
        Q_YUV=ConvertRGBtoYUV(Q);
        Q_Y=Q_YUV(:,:,1);
        inQ=uint8(Q_Y*255);
        FD2=IDBC(inQ);   % Finding FD using Improved DBC Method
        [hei, wid]=size(P);
        F_Y=FUSION_NSST_ABS_MSMG_IDBC_WPADCPCNN(P,Q_Y,FD1,FD2);  % Performing Image Fusion
        F_YUV=zeros(hei,wid,3);
        F_YUV(:,:,1)=F_Y;
        F_YUV(:,:,2)=Q_YUV(:,:,2);
        F_YUV(:,:,3)=Q_YUV(:,:,3);
        F=ConvertYUVtoRGB(F_YUV);
        F=uint8(F*255);
        toc
        figure, imshow(F)          
  else                       % For Medical Image Fusion where both the source images are gray-scale                       
        tic
        FD1=IDBC(P); % Finding FD using Improved DBC Method
        FD2=IDBC(Q); % Finding FD using Improved DBC Method
        P=double(P)/255;
        Q=double(Q)/255;
        F=FUSION_NSST_ABS_MSMG_IDBC_WPADCPCNN(P,Q,FD1,FD2);   % Performing Image Fusion
        F=uint8(F*255);
        toc
        figure, imshow(F) 
  end
       
   

         

