function R=WPADCPCNN(A,B,C1,C2)
%Code for WPADCPCNN
%Absolute values can be used
stdA=std2(A);
stdB=std2(B);
w1=C1/(C1+C2);
w2=1-w1;
rstd=w1*stdA+w2*stdB;
alpha_u=log10(1.0/rstd); 
LA=max(A(:));
LB=max(B(:));

LAO=graythresh(A);
LBO=graythresh(B);

xA=LA/LAO;
xB=LB/LBO;
xy=w1*LAO+w2*LBO;

lambda=(w1*xA+w2*xB-1.0)/6;

C_E=exp(-alpha_u)+w1*xA+w2*xB;

Y=(1-exp(-3*alpha_u))/(1- exp(-alpha_u))+(w1*xA+w2*xB-1)*exp(-alpha_u);
alpha_e=log(C_E / (xy * Y));

C_L=1.0;

betaA1=dbcbox(A,3);
betaB1=dbcbox(B,3);
betaA=1-exp(-0.02.*betaA1);
betaB=1-exp(-0.02.*betaB1);

iteration_times=150;

%WPADCPCNN

[p,q]=size(A);
F1=abs(A);
F2=abs(B);
U=zeros(p,q);
Y=zeros(p,q);
E=ones(p,q);


W=[0.5 1 0.5;1 0 1;0.5 1 0.5];

for n=1:iteration_times
    K = C_L*conv2(Y,W,'same');
    U1=F1.* (1 + betaA .* K);
    U2=F2.* (1 + betaB .* K);
    map=(U1>=U2);
    U3=map.*U1+~map.*U2;
    U = exp(-alpha_u) * U + U3;
    Y = im2double( U > E );
    E = exp(-alpha_e) * E + C_E * Y;
end

R =(U1>=U2);
end


