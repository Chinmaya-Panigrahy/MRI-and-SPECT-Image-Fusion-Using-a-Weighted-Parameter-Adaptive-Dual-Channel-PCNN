function [F]=FUSION_NSST_ABS_MSMG_IDBC_WPADCPCNN(A,B,FD1,FD2)

addpath(genpath('Shearlet_Transform'));


pfilt = 'maxflat';
shear_parameters.dcomp =[3,3,4,4];
shear_parameters.dsize =[8,8,16,16];

%NSST Decomposition

[y1,shear_f1]=nsst_dec2(A,shear_parameters,pfilt);
[y2,shear_f2]=nsst_dec2(B,shear_parameters,pfilt);


Fused=y1;

%Fusion of Low-pass Sub-bands
ALow1= y1{1};
BLow1 =y2{1};

        PW=[-1 -4 -1;-4 20 -4;-1 -4 -1];
        scalemsmfm=5;
        msmfmA1=multiscale_morph(ALow1,scalemsmfm);
        msmfmB1=multiscale_morph(BLow1,scalemsmfm);
        wmsmfmA1=conv2(msmfmA1,PW,'same');
        wmsmfmB1=conv2(msmfmB1,PW,'same');
        wmsmfmA1=abs(wmsmfmA1);
        wmsmfmB1=abs(wmsmfmB1);
        map1=(wmsmfmA1>=wmsmfmB1);
        Fused{1}=map1.*ALow1+~map1.*BLow1;  
 
        
%Fusion of High-pass Sub-bands
for m=2:length(shear_parameters.dcomp)+1
    temp=size((y1{m}));temp=temp(3);
    for n=1:temp
        Ahigh=y1{m}(:,:,n);
        Bhigh=y2{m}(:,:,n);
        
                AH=abs(Ahigh);
                BH=abs(Bhigh);
                map=WPADCPCNN(AH,BH,FD1,FD2);  %Weighted Parameter Adaptive Dual Channel PCNN (WPADCPCNN)
                Fused{m}(:,:,n)=map.*Ahigh+~map.*Bhigh;
        
    end
end


%Inverse NSST Transform
F=nsst_rec2(Fused,shear_f1,pfilt);
        

end








