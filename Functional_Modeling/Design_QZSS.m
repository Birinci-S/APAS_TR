function [AQZSS,CQZSS,lQZSS,obs_QZSS,XyeniQZSS,satElevationQZSS,prevQZSS,QZSS_SNR,satAzimuth]=Design_QZSS(mod_Opt,stoc,cut_Off_Elev, tro_prmtr,pro_Sel,X,xsat,obs_QZSS,rec_Pre_Info,Sat_Info_QZSS,satOffset,recOffset,rnxzaman,prevQZSS,s)


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
Std_Code_QZSS=stoc.code_std;
Std_Phase_QZSS=stoc.phase_std;
code_QZSS_weight=stoc.code_QZSS_weight;
phase_QZSS_weight=stoc.phase_QZSS_weight;



%%%%
sat_position=Sat_Info_QZSS.sat_position;
sat_clk_off=Sat_Info_QZSS.sat_clk_off;
relEffect=Sat_Info_QZSS.relEffect;
satAzimuth=Sat_Info_QZSS.satAzimuth;
satElevation=Sat_Info_QZSS.satElevation;
QZSS_SNR=Sat_Info_QZSS.QZSS_SNR;

recPosition=rec_Pre_Info.recPosition;
latitude=rec_Pre_Info.latitude;
longitude=rec_Pre_Info.longitude;
anten_Pos=rec_Pre_Info.anten_Pos;
hellp=rec_Pre_Info.hellp;





sat=obs_QZSS(1:size(obs_QZSS,1)/2,2);
A1=zeros(size(obs_QZSS,1)/2,size(obs_QZSS,1)/2);
A2=eye(size(obs_QZSS,1)/2,size(obs_QZSS,1)/2);
l=zeros(size(obs_QZSS,1),1);

freqL1=1561.098 ;
freqL2=1227.60;
lambdaL1=lightSpeed/freqL1/1e6;
lambdaL2=lightSpeed/freqL2/1e6;





if s==1 && pro_Sel==8
    X=zeros(size(obs_QZSS,1)/2+10,1); X(1:3,1)=recPosition;
elseif s==1 && pro_Sel==9
    X=zeros(size(obs_QZSS,1)/2+6,1); X(1:3,1)=recPosition;

end





[The_sun_pos, The_moon_pos]= sun_moon_pos(rnxzaman(s,3));
for j=1:size(obs_QZSS,1)/2

    rot_sat_positon=sat_position{j,1};
    [sec_Rel_Eff]=second_rel_Eff(rot_sat_positon,recPosition);

    if obs_QZSS(j,2)> length(satOffset) || cellfun('size',(satOffset(1,obs_QZSS(j,2))),1)==0
        satElevation(j,1)=-85;

    else


        switch mod_Opt.MCoffset
            case 1
                [MCoffset]=sat_anten_offset(The_sun_pos,satOffset,sat_position{j,1},obs_QZSS(j,2),5);
            case 0
                [MCoffset]=[0;0;0];
        end

        rot_sat_positon=sat_position{j,1}+MCoffset;

    end
    %[sagnac_Cor]=sagnac_Effect(recPosition,rot_sat_positon);
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
            [anten1]=rec_Anten_Offset(recPosition,rot_sat_positon,latitude,longitude,recOffset.GPS,[],5);
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
                [pco]=Antex_PCO(recOffset.GPS,satElevation(j,1),satAzimuth(j,1),[],5);
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



    vind=find(obs_QZSS(j,2)==prevQZSS(:,1));
    if isempty(vind)
        wup2 = windup_Effect(The_sun_pos,rot_sat_positon,recPosition,0,latitude,longitude);
        prevQZSS1(j,2)=wup2;

        windEf=iono_free_obs(wup2*lambdaL1/2/pi,wup2*lambdaL2/2/pi,[],5);

    else
        wup2 = windup_Effect(The_sun_pos,rot_sat_positon,recPosition,prevQZSS(vind,2),latitude,longitude);

        prevQZSS1(j,2)=wup2;
        windEf=iono_free_obs(wup2*lambdaL1/2/pi,wup2*lambdaL2/2/pi,[],5);

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



        if pro_Sel == 8 %||  pro_Sel == 6
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW 0 0 0 0 1];
        elseif pro_Sel == 9
            A0(j,:)=[(X(1,1)-rot_sat_positon(1,1))/ro (X(2,1)-rot_sat_positon(2,1))/ro (X(3,1)-rot_sat_positon(3,1))/ro 1 MFW  1];
        end
     
        if pro_Sel == 8
            l(j,1)=obs_QZSS(j,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(10,1);

        elseif pro_Sel == 9
            l(j,1)=obs_QZSS(j,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(6,1);

        else
            %  disp('dizayn matrix error ')
        end

        arasatir=find(obs_QZSS(j,2)==xsat.J(:,1));
        if ~isempty(arasatir)

            if pro_Sel==8
                l(j+size(obs_QZSS,1)/2,1)=obs_QZSS(j+size(obs_QZSS,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-xsat.J(arasatir,2)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(10,1);
            elseif pro_Sel==9
                l(j+size(obs_QZSS,1)/2,1)=obs_QZSS(j+size(obs_QZSS,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-xsat.J(arasatir,2)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(6,1);

            end
          
            Xyeni1(j,1)=xsat.J(arasatir,2);
        else

            if pro_Sel==8
                l(j+size(obs_QZSS,1)/2,1)=obs_QZSS(j+size(obs_QZSS,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(10,1);
            elseif pro_Sel==9
                l(j+size(obs_QZSS,1)/2,1)=obs_QZSS(j+size(obs_QZSS,1)/2,1)-ro + sat_clk_off(j,1)+lightSpeed*relEffect(j,1)-slantdelay-X(4,1)-windEf+solid_tides+sec_Rel_Eff+anten+anten_height+sagnac_Cor-X(6,1);

            end
         
            Xyeni1(j,1)=0;
        end
   
        C1(j,j)=weighting_code(Std_Code_QZSS,code_QZSS_weight,satElevation(j,1),  QZSS_SNR(j,1),QZSS_SNR(j,2),stoc.model);
        C1(j+size(obs_QZSS,1)/2,j+size(obs_QZSS,1)/2)=weighting_phase(Std_Phase_QZSS,phase_QZSS_weight,satElevation(j,1),  QZSS_SNR(j,1),QZSS_SNR(j,2),stoc.model);


end



satElevationQZSS=satElevation;
A1(:,satElevation(1:size(obs_QZSS,1)/2,1)<cut_Off_Elev)=[];
A2(:,satElevation(1:size(obs_QZSS,1)/2,1)<cut_Off_Elev)=[];
sat(satElevation(:,1)<cut_Off_Elev,:)=[];
Xyeni1(satElevation(:,1)<cut_Off_Elev,:)=[];

prevQZSS1(satElevation(:,1)<cut_Off_Elev,:)=[];
QZSS_SNR(satElevation(:,1)<cut_Off_Elev,:)=[];
satAzimuth(satElevation(:,1)<cut_Off_Elev,:)=[];
satElevation=[satElevation;satElevation];

A=[A0 A1; A0 A2];


A(satElevation(:,1)<cut_Off_Elev,:)=[];
l(satElevation(:,1)<cut_Off_Elev,:)=[];



prevQZSS=[];
prevQZSS(:,1)=sat ;prevQZSS(:,2)=prevQZSS1(:,2);

C=C1;


C(satElevation(:,1)<cut_Off_Elev,:)=[];
C(:,satElevation(:,1)<cut_Off_Elev)=[];

satElevationQZSS(satElevationQZSS(:,1)<cut_Off_Elev,:)=[];
AQZSS=A; CQZSS=C; lQZSS=l;




if pro_Sel == 8 
    Xyeni0=X(1:10,1);
    XyeniQZSS=[Xyeni0;Xyeni1];
elseif pro_Sel == 9 
    Xyeni0=X(1:6,1);
    XyeniQZSS=[Xyeni0;Xyeni1];
end

obs_QZSS(satElevation(:,1)<cut_Off_Elev,:)=[];

end