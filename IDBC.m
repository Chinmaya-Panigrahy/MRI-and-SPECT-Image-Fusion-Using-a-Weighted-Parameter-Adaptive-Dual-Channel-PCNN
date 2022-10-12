function [D]=IDBC(I)
I=double(I);
[M,N]=size(I); %Here square images are considered, hence M=N. 
smin=2;
smax=M/2; %Square image i.e., M=N
%G1=256;
for s=smin:smax
Y1(s)=0;
%s1=s*G1/M;
for i=1:s:M
for j=1:s:M  %M=N
MX=I(i,j);
if rem(M,s)~=0 && (i==1+floor(M/s)*s || j==1+floor(M/s)*s)
    MN=0;
else
    MN=I(i,j);
end
for m=i:(i+s-1)
for n=j:(j+s-1)
if m<(M+1)&&n<(M+1)
if MX<I(m,n)
MX=I(m,n);
end
if MN>I(m,n)
MN=I(m,n);
end
end
end
end
X=MX-MN+1;
Y1(s)=Y1(s)+X;
end
end
end
for i=smin:smax
      Y(i-smin+1)=log(Y1(i));
      Z(i-smin+1)=log(M/i);
end
sumx=sum(Z);
    sumx2=sum(Z.*Z); 
    sumy=sum(Y);
    sumxy=sum(Z.*Y);
p=smax-smin+1;
D=(p*sumxy-sumx*sumy)/(p*sumx2-sumx*sumx);

c=(sumx2*sumy-sumxy*sumx)/(p*sumx2-sumx*sumx);

   sumDc=sum((D*Z+c-Y).*(D*Z+c-Y));
DE=((sumDc/(1+D*D))^(1/2))/p;
