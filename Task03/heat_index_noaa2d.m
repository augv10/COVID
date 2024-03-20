%%% Heat index from relative humidity and celcius

function rhi=heat_index_noaa2d(rh,t2m)

% modify celcius to fareneight

ix=size(rh,2);
jx=size(rh,1);

tf=9*t2m/5+32;

%if tf >70

rhi = -42.379 + 2.04901523*tf + 10.14333127*rh - .22475541*tf.*rh - .00683783*tf.*tf - .05481717*rh.*rh + .00122874*(tf.*tf).*rh + .00085282*(tf.*rh).*rh - .00000199*((tf.*tf).*rh).*rh;


multi1=zeros(jx*ix,1);
multi2=zeros(jx*ix,1);
z1=reshape(tf,jx*ix,1);
z2=reshape(rh,jx*ix,1);
clear oo1 oo2 oo3
oo1=find(z2<13);
multi1(oo1)=1;
oo2=find(z1<112 & z1>=80);
multi2(oo2)=1;
multip=reshape(multi1.*multi2,jx,ix);
rhi=rhi- multip.*((13-rh)/4).*sqrt((17-abs(tf-95.))/17);

%if rh < 13 & (tf >80 & tf < 112)
%rhi=rhi- ((13-rh)/4)*sqrt((17-abs(tf-95.))/17);
%end

multi1=zeros(jx*ix,1);
multi2=zeros(jx*ix,1);
clear oo1 oo2 oo3
oo1=find(z2>85);
multi1(oo1)=1;
oo2=find(z1<87 & z1>=80);
multi2(oo2)=1;
multip=reshape(multi1.*multi2,jx,ix);
rhi=rhi+multip.*((rh-85)/10).*((87-tf)/5);

%if rh >85 & (tf>80 & tf < 87)
%rhi=rhi+((rh-85)/10)*((87-tf)/5);
%end

clear z3
z3=reshape(rhi,jx*ix,1);
multi1=zeros(jx,ix,1);
clear oo1
oo1= find(z3<=82.5);
rhi(oo1) = 0.5 * (tf(oo1) + 61.0 + ((tf(oo1)-68.0)*1.2) + (rh(oo1)*0.094));

clear oo1 multi1
multi1=nan(jx*ix,1);
oo1=find(z1>=70);
multi1(oo1)=1;
rhi=reshape(multi1,jx,ix).*rhi;
%if rhi <= 80
%rhi = 0.5 * (tf + 61.0 + ((tf-68.0)*1.2) + (rh*0.094));
%end

%else
%rhi=NaN;
%end


end

