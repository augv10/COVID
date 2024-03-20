function [rh,qs]=rh_qs(T,Td,P)

% Kelvin, mb, %, g/Kg

%if T> 273.15
    a=17.2693882;
    b=35.86;
%else
%    a=21.8745584;
%    b=7.66;
%end

es=6.1078*exp(a*(T-273.16)./(T-b));
e=6.1078*exp(a*(Td-273.16)./(Td-b));

rh=100*e./es;
rh=min(rh,100);
rh=max(rh,0);
qs=1000*0.622*e./((P/100)-0.378*e);

end
