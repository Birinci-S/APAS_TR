function [Sat_Info]=Sat_Information(rec_Pre_Info,measures,rnxzaman,sat_SP3,sp3zaman,clock_data,clcktime,s)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

lightSpeed=299792458;

travel_time=zeros(size(measures,1),1);
sat_position=cell(size(measures,1),1);
satElevation=zeros(size(measures,1),1);
satAzimuth=zeros(size(measures,1),1);
for j=1:size(measures,1)
    travel_time(j,1)=(measures(j,1)/lightSpeed);
    transmit_time =(rnxzaman(s,1))-travel_time(j,1);

    [clck_bias1, clk_answer]=clock_interpolation(clock_data,clcktime,transmit_time,measures(j,2));
    transmit_time=transmit_time-clck_bias1;

    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %interpolation

    orbit_int = orbit_interpolation(sat_SP3,sp3zaman,transmit_time,measures(j,2));
    orbit_int1 = orbit_interpolation(sat_SP3,sp3zaman,transmit_time-0.5,measures(j,2));
    orbit_int2 = orbit_interpolation(sat_SP3,sp3zaman,transmit_time+0.5,measures(j,2));

    if orbit_int2.answer==0 || orbit_int1.answer==0
        orbit_int.answer=0; %% final control
        orbit_int.coordinates=[0;0;0;0];  %% final control 23.04.2024
    end



    satellite_Pos= (orbit_int.coordinates((1:3),1));
    travel_time1 = norm(satellite_Pos - rec_Pre_Info.recPosition)/lightSpeed;
    rot_sat_positon = rot_Sat( satellite_Pos,travel_time1);
    sat_position{j,1}=rot_sat_positon;
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    %******************************************************************************************
    [elevation,  satAzi] = calElev(rec_Pre_Info.latitude,rec_Pre_Info.longitude,rot_sat_positon,rec_Pre_Info.recPosition);
    satElevation(j,1)=elevation;
    satAzimuth(j,1)=satAzi;






    sat_vel=((orbit_int2.coordinates((1:3),1))-(orbit_int1.coordinates((1:3),1)))./1;
    deltarel = rel_Effect(rot_sat_positon,sat_vel);

    relEffect(j,1)=deltarel;

    %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    if clk_answer~=0

        clck_bias=clck_bias1;
        clock_offset=lightSpeed*(clck_bias);
    elseif clk_answer==0 && orbit_int.answer~=0

        [clck_bias1, ~]=clock_interpolation(sat_SP3{2,4},sp3zaman,transmit_time,measures(j,2));


        if clck_bias1==0
            satElevation(j,1)=-85;
            clock_offset=0;
        else
            clck_bias=clck_bias1*10^-6;
            clock_offset=lightSpeed*(clck_bias); %% sp3
        end

    else
       
        clock_offset=0;

        satElevation(j,1)=-85;
    end
    sat_clk_off(j,1)=clock_offset;
    %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

end

satElevation(:,2)=measures(:,2);
Sat_Info.sat_position=sat_position;
Sat_Info.sat_clk_off=sat_clk_off;
Sat_Info.relEffect=relEffect;
Sat_Info.satElevation=satElevation;
Sat_Info.satAzimuth=satAzimuth;

end