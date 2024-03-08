function HI=heat_index_noaa(T,RH)

    
T=9*T/5+32;

init = 0.5 * (T + 61.0 + ((T-68.0)*1.2) + (RH*0.094));

if 0.5*(init + T) >80 % Fahrenheight
    % Full Forumal
    HI = -42.379 + 2.04901523*T + 10.14333127*RH - .22475541*T*RH - .00683783*T*T - ... 
    .05481717*RH*RH + .00122874*T*T*RH + .00085282*T*RH*RH - .00000199*T*T*RH*RH;

    if RH < 13 & (T>=80 & T < 112)
     HI = HI-((13-RH)/4)*sqrt((17-abs(T-95.))/17);
    end

    if RH > 85 & (T>= 80 & T< 87)  
        HI = HI+ ((RH-85)/10) * ((87-T)/5);
    end

else

    HI=init;
end

end




