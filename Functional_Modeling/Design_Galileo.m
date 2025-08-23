function [AGAL,CGAL,lGAL,obs_GAL,XyeniGAL,satElevationGAL,prevGAL,GAL_SNR,satAzimuth]=Design_Galileo(mod_Opt,stoc,cut_Off_Elev,tro_prmtr,pro_Sel,X,xsat,obs_GAL,rec_Pre_Info,Sat_Info_GAL,satOffset,recOffset,rnxzaman,prevGAL,s)

%%% This function is a component of APAS-TR. 10.02.2024, S. Birinci



% %%%%
% mod_Opt.MCoffset=1;
% mod_Opt.solid_tides=1;
% mod_Opt.anten1=1;
% mod_Opt.eclipse=1;
% mod_Opt.pco=1;
% mod_Opt.anten_height1=1;
% mod_Opt.windEf=1;

lightSpeed=299792458;
Std_Code_GAL=stoc.code_std;
Std_Phase_GAL=stoc.phase_std;
code_GAL_weight=stoc.code_GAL_weight;
phase_GAL_weight=stoc.phase_GAL_weight;
%cut_Off_Elev=8;



freqL1=154*10.23;
freqL2=115*10.23;
lambdaL1=lightSpeed/freqL1/1e6;
lambdaL2=lightSpeed/freqL2/1e6;


%%%%
sat_position=Sat_Info_GAL.sat_position;
sat_clk_off=Sat_Info_GAL.sat_clk_off;
relEffect=Sat_Info_GAL.relEffect;
satAzimuth=Sat_Info_GAL.satAzimuth;
satElevation=Sat_Info_GAL.satElevation;
GAL_SNR=Sat_Info_GAL.GAL_SNR;

recPosition=rec_Pre_Info.recPosition;
latitude=rec_Pre_Info.latitude;
longitude=rec_Pre_Info.longitude;
anten_Pos=rec_Pre_Info.anten_Pos;
hellp=rec_Pre_Info.hellp;


sat=obs_GAL(1:size(obs_GAL,1)/2,2);
A1=zeros(size(obs_GAL,1)/2,size(obs_GAL,1)/2);
A2=eye(size(obs_GAL,1)/2,size(obs_GAL,1)/2);
l=zeros(size(obs_GAL,1),1);



if s==1 && pro_Sel==3
    X=zeros(size(obs_GAL,1)/2+6,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==4
    X=zeros(size(obs_GAL,1)/2+7,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==5
    X=zeros(size(obs_GAL,1)/2+8,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==6
    X=zeros(size(obs_GAL,1)/2+8,1); X(1:3,1)=recPosition;

elseif s==1 && pro_Sel==7
    X=zeros(size(obs_GAL,1)/2+9,1); X(1:3,1)=recPosition;
elseif s==1 && pro_Sel==8
    X=zeros(size(obs_GAL,1)/2+10,1); X(1:3,1)=recPosition;
end






[The_sun_pos, The_moon_pos]= sun_moon_pos(rnxzaman(s,3));

for j=1:size(obs_GAL,1)/2


    if obs_GAL(j,2)> length(satOffset) ||  cellfun('size',(satOffset(1,obs_GAL(j,2))),1)==0
        satElevation(j,1)=-85;

    else

        rot_sat_positon=sat_position{j,1};
        [sec_Rel_Eff]=second_rel_Eff(rot_sat_positon,recPosition);


        switch mod_Opt.MCoffset
            case 1
                [MCoffset]=sat_anten_offset(The_sun_pos,satOffset,sat_position{j,1},obs_GAL(j,2),3);
            case 0
                [MCoffset]=[0;0;0];
        end

        rot_sat_positon=sat_position{j,1}+MCoffset;
    end
    % [sagnac_Cor]=sagnac_Effect(recPosition,rot_sat_positon);
    [sagnac_Cor]=0;

    otl_COR=0;%cal_otl(recPosition,sat_position{j,1},enlem,boylam,otl,rnxzaman(s,3));


    switch mod_Opt.solid_tides
        case 1
            [solid_tides]=solidTides(rnxzaman(s,3),recPosition,rot_sat_positon,The_sun_pos ,The_moon_pos);
        case 0
            solid_tides=0;
    end


    switch mod_Opt.anten1
        case 1
            [anten1]=rec_Anten_Offset(recPosition,rot_sat_positon,latitude,longitude,recOffset.GPS,[],3);
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
        %disp("pco: [0 0 0] ..!!!");

    else
        switch mod_Opt.pco
            case 1
                [pco]=Antex_PCO(recOffset.GPS,satElevation(j,1),satAzimuth(j,1),[],3);
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


    vind=find(obs_GAL(j,2)==prevGAL(:,1));
    if isempty(vind)

        wup2 = windup_Effect(The_sun_pos,rot_sat_positon,recPosition,0,latitude,longitude);

        prevGAL1(j,2)=wup2;

        windEf=iono_free_obs(wup2*lambdaL1/2/pi,wup2*lambdaL2/2/pi,[],3);

    else

        wup2 = windup_Effect(The_sun_pos,rot_sat_positon,recPosition,prevGAL(vind,2),latitude,longitude);

        prevGAL1(j,2)=wup2;
        windEf=iono_free_obs(wup2*lambdaL1/2/pi,wup2*lambdaL2/2/pi,[],3);

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



        ro=norm(rot_sat_positon-X(1:3,1));

        if pro_Sel == 3
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 1 ];
        elseif pro_Sel == 4
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 1];
        elseif pro_Sel == 5 ||  pro_Sel == 6
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 1 0];

        elseif pro_Sel == 7
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 1 0 0];
        elseif pro_Sel ==8
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 1 0 0 0 ];


        end



        if pro_Sel==3
            l(j,1)=obs_GAL(j,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(6,1);

        else
            l(j,1)=obs_GAL(j,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(7,1);
        end

        arasatir=find(obs_GAL(j,2) == xsat.E(:,1));

        if ~isempty(arasatir)
            if pro_Sel ==3
                l(j+size(obs_GAL,1)/2,1)=obs_GAL(j+size(obs_GAL,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-xsat.E(arasatir,2)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(6,1);
            else
                l(j+size(obs_GAL,1)/2,1)=obs_GAL(j+size(obs_GAL,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-xsat.E(arasatir,2)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(7,1);
            end
            Xyeni1(j,1)=xsat.E(arasatir,2);
        else
            if pro_Sel==3
                l(j+size(obs_GAL,1)/2,1)=obs_GAL(j+size(obs_GAL,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(6,1);
            else
                l(j+size(obs_GAL,1)/2,1)=obs_GAL(j+size(obs_GAL,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(7,1);

            end

            Xyeni1(j,1)=0;
        end



       
        C1(j,j)=weighting_code(Std_Code_GAL,code_GAL_weight,satElevation(j,1),  GAL_SNR(j,1),GAL_SNR(j,2),stoc.model);
        C1(j+size(obs_GAL,1)/2,j+size(obs_GAL,1)/2)=weighting_phase(Std_Phase_GAL,phase_GAL_weight,satElevation(j,1),  GAL_SNR(j,1),GAL_SNR(j,2),stoc.model);


end


satElevationGAL=satElevation;

A1(:,satElevation(1:size(obs_GAL,1)/2,1)<cut_Off_Elev)=[];
A2(:,satElevation(1:size(obs_GAL,1)/2,1)<cut_Off_Elev)=[];
sat(satElevation(:,1)<cut_Off_Elev,:)=[];
Xyeni1(satElevation(:,1)<cut_Off_Elev,:)=[];
prevGAL1(satElevation(:,1)<cut_Off_Elev,:)=[];
GAL_SNR(satElevation(:,1)<cut_Off_Elev,:)=[];
satAzimuth(satElevation(:,1)<cut_Off_Elev,:)=[];

satElevation=[satElevation;satElevation];

A=[A0 A1; A0 A2];


A(satElevation(:,1)<cut_Off_Elev,:)=[];
l(satElevation(:,1)<cut_Off_Elev,:)=[];

prevGAL=[];
prevGAL(:,1)=sat ;prevGAL(:,2)=prevGAL1(:,2);

C=C1;
C(satElevation(:,1)<cut_Off_Elev,:)=[];
C(:,satElevation(:,1)<cut_Off_Elev)=[];

satElevationGAL(satElevationGAL(:,1)<cut_Off_Elev,:)=[];
AGAL=A; CGAL=C; lGAL=l;


if pro_Sel == 3
    Xyeni0=X(1:6,1);
    XyeniGAL=[Xyeni0;Xyeni1];
elseif pro_Sel == 4
    Xyeni0=X(1:7,1);
    XyeniGAL=[Xyeni0;Xyeni1];
elseif pro_Sel == 5 || pro_Sel == 6
    Xyeni0=X(1:8,1);
    XyeniGAL=[Xyeni0;Xyeni1];
elseif pro_Sel == 7
    Xyeni0=X(1:9,1);
    XyeniGAL=[Xyeni0;Xyeni1];
elseif pro_Sel == 8
    Xyeni0=X(1:10,1);
    XyeniGAL=[Xyeni0;Xyeni1];
end


obs_GAL(satElevation(:,1)<cut_Off_Elev,:)=[];

end