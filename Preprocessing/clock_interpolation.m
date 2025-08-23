function  [clock_value, answer]=clock_interpolation(data,zaman,t,satname)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci


answer=1; clock_value=0;

[~, sat_posi]=min(abs(t-zaman));


if t-zaman(sat_posi,1)<0
    sat_posi=sat_posi-1;
end

if satname>size(data,2) %%%% 23.09.2023
    answer=0;

else



    if t>zaman(1,1) && t< zaman(length(zaman),1)

        sub_data=data((sat_posi:sat_posi+1),satname);
        if ~isempty(find(data((sat_posi:sat_posi+1),satname) ==0, 1)) || ~isempty(find(data((sat_posi:sat_posi+1),satname) ==999999.999999*10^-6, 1)) ...
                || ~isempty(find(data((sat_posi:sat_posi+1),satname) ==999999.999999, 1))
            answer=0;
            return
        end


    elseif t<zaman(1,1)
        sat_posi=1;

        sub_data=data((sat_posi:sat_posi+1),satname);
        if ~isempty(find(data((sat_posi:sat_posi+1),satname) ==0, 1)) || ~isempty(find(data((sat_posi:sat_posi+1),satname) ==999999.999999*10^-6, 1)) ...
                || ~isempty(find(data((sat_posi:sat_posi+1),satname) ==999999.999999, 1))
            answer=0;
            return
        end


    end







    if   t>zaman(1,1) && t< zaman(length(zaman),1)
        extract_time_clck=zaman((sat_posi:sat_posi+1),1);
        clock_value=sub_data(1,1)+((sub_data(2,1)-sub_data(1,1))/(extract_time_clck(2,1)-extract_time_clck(1,1)))*(t-extract_time_clck(1,1));





    elseif t<zaman(1,1)
        extract_time_clck=zaman((1:2),1);
        k1=(t-extract_time_clck(2,1))/(extract_time_clck(1,1)-extract_time_clck(2,1));
        clock_value=k1*(sub_data(1,1)-sub_data(2,1)) + sub_data(2,1);


    end

end


end







