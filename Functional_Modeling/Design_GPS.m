


function [AGPS,CGPS,lGPS,obs_GPS,XyeniGPS,ZHD,ZWD,prevGPS,trop,satElevationGPS,GPS_SNR,satAzimuth]=Design_GPS(mod_Opt,stoc,cut_Off_Elev, tro_prmtr,pro_Sel,X,xsat,obs_GPS,rec_Pre_Info,Sat_Info_GPS,satOffset,recOffset,rnxzaman,prevGPS,s)


%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci



% %%%%
% mod_Opt.MCoffset=1;
% mod_Opt.solid_tides=1;
% mod_Opt.anten1=1;
% mod_Opt.eclipse=1;
% mod_Opt.pco=1;
% mod_Opt.anten_height1=1;
% mod_Opt.windEf=1;

lightSpeed=299792458;
Std_Code_GPS=stoc.code_std;
Std_Phase_GPS=stoc.phase_std;
code_GPS_weight=stoc.code_GPS_weight;
phase_GPS_weight=stoc.phase_GPS_weight;

%%%%
sat_position=Sat_Info_GPS.sat_position;
sat_clk_off=Sat_Info_GPS.sat_clk_off;
relEffect=Sat_Info_GPS.relEffect;
satAzimuth=Sat_Info_GPS.satAzimuth;
satElevation=Sat_Info_GPS.satElevation;
GPS_SNR=Sat_Info_GPS.GPS_SNR;

recPosition=rec_Pre_Info.recPosition;


latitude=rec_Pre_Info.latitude;
longitude=rec_Pre_Info.longitude;
anten_Pos=rec_Pre_Info.anten_Pos;
hellp=rec_Pre_Info.hellp;


sat=obs_GPS(1:size(obs_GPS,1)/2,2);
A1=zeros(size(obs_GPS,1)/2,size(obs_GPS,1)/2);
A2=eye(size(obs_GPS,1)/2,size(obs_GPS,1)/2);
l=zeros(size(obs_GPS,1),1);

freqL1=1575.42;
freqL2=1227.60;
lambdaL1=lightSpeed/freqL1/1e6; %gps L1 frequency
lambdaL2=lightSpeed/freqL2/1e6; %gps L2 frequency


if s==1 && pro_Sel==1 %G
    X=zeros(size(obs_GPS,1)/2+5,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==2 %GR
    X=zeros(size(obs_GPS,1)/2+6,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==3 %GE
    X=zeros(size(obs_GPS,1)/2+6,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==4 %GRE
    X=zeros(size(obs_GPS,1)/2+7,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==5 %GREC2
    X=zeros(size(obs_GPS,1)/2+8,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==6 %GREC3
    X=zeros(size(obs_GPS,1)/2+8,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==7 %GREC2C3
    X=zeros(size(obs_GPS,1)/2+9,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==8 %GREC2C3J
    X=zeros(size(obs_GPS,1)/2+10,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==9 %GJ
    X=zeros(size(obs_GPS,1)/2+6,1); X(1:3,1)=recPosition;


end




[The_sun_pos, The_moon_pos]= sun_moon_pos(rnxzaman(s,3));

for j=1:size(obs_GPS,1)/2


    rot_sat_positon=sat_position{j,1};
    [sec_Rel_Eff]=second_rel_Eff(rot_sat_positon,recPosition);


    if obs_GPS(j,2)> length(satOffset) || cellfun('size',(satOffset(1,obs_GPS(j,2))),1)==0  %for satellite antenna offset
        satElevation(j,1)=-85;

    else

        switch mod_Opt.MCoffset
            case 1
                [MCoffset]=sat_anten_offset(The_sun_pos,satOffset,sat_position{j,1},obs_GPS(j,2),1);
            case 0
                [MCoffset]=[0;0;0];
        end
        rot_sat_positon=sat_position{j,1}+MCoffset;
    end


    otl_COR=0;%cal_otl(recPosition,sat_position{j,1},latitude,longitude,otl,rnxzaman(s,3));

    switch mod_Opt.solid_tides
        case 1

            [solid_tides]=solidTides(rnxzaman(s,3),recPosition,rot_sat_positon,The_sun_pos ,The_moon_pos);
        case 0
            solid_tides=0;
    end



    switch mod_Opt.anten1
        case 1

            if iscell(recOffset.GPS) 
                [anten1]=rec_Anten_Offset(recPosition,rot_sat_positon,latitude,longitude,recOffset.GPS,obs_GPS(j,2),1);
            else;   anten1=0; %for u-blox
            end

        case 0
            anten1=0;
    end


    switch mod_Opt.eclipse
        case 1

            [eclipse] =eclipse_control(The_sun_pos,rot_sat_positon);
        case 0
            eclipse=0;
    end
    if eclipse==1 ; satElevation(j,1)=-85; end


    if satElevation(j,1)<cut_Off_Elev% || sum(recOffset.GPS)==0
        pco=0;
       % disp("pco: [0 0 0] ..!!!");

    else


        switch mod_Opt.pco
            case 1
                if iscell(recOffset.GPS)    %for u-blox
                    [pco]=Antex_PCO(recOffset.GPS,satElevation(j,1),satAzimuth(j,1),[],1);

                else;  [pco]=0; 

                end

            case 0

                [pco]=0;
        end

    end



    switch mod_Opt.anten_height1
        case 1
            [anten_height1]=rec_Anten_Height(recPosition,rot_sat_positon,latitude,longitude,anten_Pos);
        case 0
            anten_height1=0;
    end

    anten=-anten1-(pco/1000);
    anten_height=-anten_height1;


    vind=find(obs_GPS(j,2)==prevGPS(:,1));

    if isempty(vind)
        wup2 = windup_Effect(The_sun_pos,rot_sat_positon,recPosition,0,latitude,longitude);

        prevGPS1(j,2)=wup2;
        windEf=iono_free_obs(wup2*lambdaL1/2/pi,wup2*lambdaL2/2/pi,[],1);


    else
        wup2 = windup_Effect(The_sun_pos,rot_sat_positon,recPosition,prevGPS(vind,2),latitude,longitude);
        prevGPS1(j,2)=wup2;
        windEf=iono_free_obs(wup2*lambdaL1/2/pi,wup2*lambdaL2/2/pi,[],1);
    end


    switch mod_Opt.windEf
        case 0; windEf=0; end




        if tro_prmtr.Trop_Model<5

            [ZHD, ZWD, MFH,MFW ]=tro_cal(tro_prmtr,rnxzaman(s,3) , latitude*pi/180,longitude*pi/180,hellp,(90-satElevation(j,1))*pi/180);
            slantdelay=(MFH*ZHD)+(MFW*(ZWD+X(5,1)));


        elseif tro_prmtr.Trop_Model==5

            [MFH,MFW ,ZWD,ZHD]=NiellUNB(latitude,rnxzaman(s,2),satElevation(j,1),hellp);
            slantdelay=(MFH*ZHD)+(MFW*(ZWD+X(5,1)));

        else

            disp('No troposphere model: slant delay : 0 !!!')
            slantdelay=0;
        end


        trop=ZHD+ZWD;


        ro=norm(rot_sat_positon-X(1:3,1));
        if pro_Sel ==1
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW ];
        elseif pro_Sel == 2  || pro_Sel ==3 || pro_Sel ==9
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 ];
        elseif pro_Sel == 4
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 0];
        elseif pro_Sel == 5 ||  pro_Sel == 6
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 0 0];

        elseif pro_Sel == 7
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 0 0 0];
        elseif pro_Sel == 8
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 0 0 0 0];

        end

        l(j,1)=obs_GPS(j,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)+solid_tides+sec_Rel_Eff+anten+anten_height;
        arasatir=find(obs_GPS(j,2)==xsat.G(:,1));

        if ~isempty(arasatir)
            l(j+size(obs_GPS,1)/2,1)=obs_GPS(j+size(obs_GPS,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-xsat.G(arasatir,2)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height;
            Xyeni1(j,1)=xsat.G(arasatir,2);
        else
            l(j+size(obs_GPS,1)/2,1)=obs_GPS(j+size(obs_GPS,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height;
            Xyeni1(j,1)=0;
        end

      

        C1(j,j)=weighting_code(Std_Code_GPS,code_GPS_weight,satElevation(j,1),  GPS_SNR(j,1),GPS_SNR(j,2),stoc.model);
        C1(j+size(obs_GPS,1)/2,j+size(obs_GPS,1)/2)=weighting_phase(Std_Phase_GPS,phase_GPS_weight,satElevation(j,1),  GPS_SNR(j,1),GPS_SNR(j,2),stoc.model);





end

satElevationGPS=satElevation;


A1(:,satElevation(1:size(obs_GPS,1)/2,1)<cut_Off_Elev)=[];
A2(:,satElevation(1:size(obs_GPS,1)/2,1)<cut_Off_Elev)=[];
sat(satElevation(:,1)<cut_Off_Elev,:)=[];
Xyeni1(satElevation(:,1)<cut_Off_Elev,:)=[];
prevGPS1(satElevation(:,1)<cut_Off_Elev,:)=[];
GPS_SNR(satElevation(:,1)<cut_Off_Elev,:)=[];
satAzimuth(satElevation(:,1)<cut_Off_Elev,:)=[];
satElevation=[satElevation;satElevation];

A=[A0 A1; A0 A2];


A(satElevation(:,1)<cut_Off_Elev,:)=[];
l(satElevation(:,1)<cut_Off_Elev,:)=[];

prevGPS=[];
prevGPS(:,1)=sat ;prevGPS(:,2)=prevGPS1(:,2);

C=C1;

C(satElevation(:,1)<cut_Off_Elev,:)=[];
C(:,satElevation(:,1)<cut_Off_Elev)=[];

satElevationGPS(satElevationGPS(:,1)<cut_Off_Elev,:)=[];


AGPS=A; CGPS=C; lGPS=l;

if pro_Sel ==1
    Xyeni0=X(1:5,1);
    XyeniGPS=[Xyeni0;Xyeni1];
elseif pro_Sel == 2 || pro_Sel == 3 || pro_Sel == 9
    Xyeni0=X(1:6,1);
    XyeniGPS=[Xyeni0;Xyeni1];
elseif pro_Sel == 4
    Xyeni0=X(1:7,1);
    XyeniGPS=[Xyeni0;Xyeni1];
elseif pro_Sel == 5 || pro_Sel == 6
    Xyeni0=X(1:8,1);
    XyeniGPS=[Xyeni0;Xyeni1];
elseif pro_Sel == 7
    Xyeni0=X(1:9,1);
    XyeniGPS=[Xyeni0;Xyeni1];
elseif pro_Sel == 8
    Xyeni0=X(1:10,1);
    XyeniGPS=[Xyeni0;Xyeni1];
end

obs_GPS(satElevation(:,1)<cut_Off_Elev,:)=[];

end



