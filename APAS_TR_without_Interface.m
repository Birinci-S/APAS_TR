%%%%%--------------------------------------------
%%% This code is a component of APAS-TR. 11.06.2024, S. Birinci
%%%%%--------------------------------------------


%%%%%%%%%%%%------APAS-TR---%%%%%%%%%%%%%%


clc; clear; format long g;
tic;
lightSpeed=299792458; %lightspeed m/s
%%%%----------------------------------------
apas_tr_Info=what('APAS_TR');
apas_tr_path=apas_tr_Info.path;
cd(apas_tr_path);
addpath(genpath(pwd))



%%%%%%%% Inputs Files %%%%%%%%%%%%%%%

rinexFilename='KARR00AUS_R_20233440000_01D_30S_MO.rnx';
sp3Filename='COD0MGXFIN_20233440000_01D_05M_ORB.SP3';
clkFilename='COD0MGXFIN_20233440000_01D_30S_CLK.CLK';
antennaFilename='igs20_2303.atx';
DCBFilename='CAS0MGXRAP_20233440000_01D_01D_DCB.BSX';
SinexFilename='IGS0OPSSNX_20233440000_07D_07D_SOL.SNX';
TropFilename='COD0OPSFIN_20233440000_01D_01H_TRO.TRO';

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%%%%%%%%Observation Data %%%%%%%%

%%%rinex version
version_Rinex=rinex_Version(rinexFilename);


if version_Rinex == 3

    [rnxdata, rnxtime, recPosition1, antennaPosition, antenType, markerName]=read_Rinex_Ver3(rinexFilename);


    [rnx_GPS]=signals_GPS_v3(rnxdata);
    [rnx_GLO]=signals_GLO_v3(rnxdata);
    [rnx_GAL]=signals_GAL_v3(rnxdata);
    [rnx_BDS]=signals_BDS_v3(rnxdata);
    [rnx_QZSS]=signals_QZSS_v3(rnxdata);


elseif version_Rinex == 2

    [rnxdata, rnxtime, recPosition1, antennaPosition, antenType, markerName]=read_Rinex_Ver2(rinexFilename);
    [rnx_GPS]=signals_GPS_v2(rnxdata);
    [rnx_GLO]=signals_GLO_v2(rnxdata);
    [rnx_GAL]=signals_GAL_v2(rnxdata);
    [rnx_BDS]=signals_BDS_v2;
    [rnx_QZSS]=signals_QZSS_v2;

end


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%READ SP3 FİLE
[sp3data,sp3time]=read_Sp3(sp3Filename);
GPSsp3=sp3data.GPS;
GLONASSsp3=sp3data.GLONASS;
GALILEOsp3=sp3data.GALILEO;
BEIDOUsp3=sp3data.BEIDOU;
QZSSsp3=sp3data.QZSS;


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%READ CLOCK FİLE
    [clk_version ] = read_Clock_version(clkFilename);
    if clk_version > 3.02
        [clockdata,clocktime ] = read_ClockFile_multi(clkFilename);

    elseif clk_version <= 3.02
        [clockdata,clocktime ] = read_ClockFile(clkFilename);
    end

    GPSclock=clockdata.GPS_clkbias;
    GLONASSclock=clockdata.GLONASS_clkbias;
    GALILEOclock=clockdata.GALILEO_clkbias;
    BEIDOUclock=clockdata.BEIDOU_clkbias;
    QZSSclock=clockdata.QZSS_clkbias;



%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%READ ANTENNA FİLE

MJD=rnxtime(1,3);
[satOffset, recOffset]=read_AntexFile(MJD,antennaFilename,antenType );


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%DCB Applied
if version_Rinex == 3
    [rnxdata]=applied_DCB(rnxdata,rnx_GPS,rnx_GLO, DCBFilename);
end

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%Clock Jump Control
[rnxdata]=clock_Jump_Control(rnxdata,rnxtime,rnx_GPS,rnx_GLO,rnx_GAL,rnx_BDS,rnx_QZSS);


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%%%Elevation and C/N0 cut-off values
elev_cut=8;
SNR_cutoff=20;


Smooth=0;

%Cycle Slip Control
%[rnxdata]=cycle_Slip_Control_TuEdit(clockdata, clocktime, sp3data, sp3time,rnxdata,rnxtime,recPosition1,rnx_GPS,rnx_GLO,rnx_GAL,rnx_BDS,rnx_QZSS,elev_cut,Smooth);
[rnxdata]=cycle_Slip_Control(clockdata, clocktime, sp3data, sp3time,rnxdata,rnxtime,recPosition1,rnx_GPS,rnx_GLO,rnx_GAL,rnx_BDS,rnx_QZSS,elev_cut,Smooth);




%%%%Reference Coordinates
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[ground_truth_coor,ref_coord_std]=read_Sinex2(SinexFilename,markerName);
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

%%%Available satellite systems
fprintf(' GPS: %d, GLONASS: %d, GALILEO:%d, BDS:%d, QZSS:%d \n',rnx_GPS.GPS_system,rnx_GLO.GLO_system,...
    rnx_GAL.GAL_system,rnx_BDS.BDS_system,rnx_QZSS.QZSS_system);

%%%Select combination
combination=input([' 1:G \n 2:GR \n 3:GE \n 4:GRE \n 5:GREC2 \n ' ...
    '6:GREC3 \n 7:GREC2C3 \n 8:GREC2C3J \n' ...
    'Select combination:']);

[combiProCont]= Combi_ProductContol(sp3data,combination);
if combiProCont==1; pause; end

[latitude,longitude,hellp]=xyz2eby(recPosition1);
grid_control=zeros(8,1);
Trop_Model=input([' 1:VMF3 \n 2:VMF1 \n 3:GPT3 \n 4:GPT2 \n 5:NMF \n ' ...
    '\n' ...
    'Troposphere Model:']);


if    Trop_Model==1

    VMF3_parameter_Download(rnxtime(1,4), rnxtime(1,5),rnxtime(1,6));
    VMF3_parameter_Download(rnxtime(1,4),rnxtime(1,5),rnxtime(1,6)+1);


elseif  Trop_Model==2
    VMF1_parameter_Download(rnxtime(1,4),rnxtime(1,5),rnxtime(1,6));
    VMF1_parameter_Download(rnxtime(1,4), rnxtime(1,5),rnxtime(1,6));
    VMF1_parameter_Download(rnxtime(1,4), rnxtime(1,5),rnxtime(1,6)+1);

end



[tro_prmtr]=trop_Option(Trop_Model,rnxtime(1,3) , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
rec_Pre_Info.recPosition=recPosition1;
rec_Pre_Info.latitude=latitude;
rec_Pre_Info.longitude=longitude;
rec_Pre_Info.anten_Pos=antennaPosition;
rec_Pre_Info.hellp=hellp;

CXX=[1000000 0 0 0 ; 0 1000000 0 0 ; 0 0 10000000 0 ;0 0 0 10^10];

X=0;

[Lat_ground_trut,Lon_ground_trut,hellp1]=xyz2eby(ground_truth_coor);


prevGPS=0; prevGLO=0; prevGAL=0; prevBDS2=0; prevBDS3=0; prevQZSS=0;

xsat.G=0; xsat.R=0; xsat.E=0; xsat.C2=0; xsat.C3=0; xsat.GE=0; xsat.GR=0;  xsat.GRE=0; xsat.GREC2=0; xsat.GREC3=0;
xsat.GREC2C3=0; xsat.J=0; xsat.GREC2C3J=0; xsat.GJ=0;


%%%Selections for the Functional Model
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
mod_Opt.MCoffset=1;
mod_Opt.solid_tides=1;
mod_Opt.anten1=1;
mod_Opt.eclipse=1;
mod_Opt.pco=1;
mod_Opt.anten_height1=1;
mod_Opt.windEf=1;

%%%Selections for the Stochastic Model
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
stoc.code_std=0.30;
stoc.phase_std=0.002;
stoc.code_GPS_weight=1;
stoc.code_GLO_weight=2;
stoc.code_GAL_weight=1;
stoc.code_BDSmeo_weight=1;
stoc.code_BDSgeo_weight=3;
stoc.code_BDSigso_weight=3;
stoc.code_QZSS_weight=1;

stoc.phase_GPS_weight=1;
stoc.phase_GLO_weight=1;
stoc.phase_GAL_weight=1;
stoc.phase_BDSmeo_weight=1;
stoc.phase_BDSgeo_weight=3;
stoc.phase_BDSigso_weight=3;
stoc.phase_QZSS_weight=1;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
stoc.model=1;
cut_Off_Elev=elev_cut;
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

%%%Kalman filtering settings
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
filter_par.int_coord=1000; filter_par.int_GPS_rec=1000;
filter_par.int_zenit_wet=0.5; filter_par.int_Amb=20;
filter_par.int_IBSs=1000;

filter_par.noise_coord=0;  filter_par.noise_GPS_rec=1000;
filter_par.noise_zenit_wet=0.01;  filter_par.noise_Amb=0;
filter_par.noise_IBSs=1000;


%%%% START PPPP
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
for s=1:length(rnxtime)

    if Trop_Model==1 || Trop_Model==2
        [tro_prmtr,grid_control]=trop_Grid_Control(rnxtime(s,3),latitude,longitude,hellp,grid_control,Trop_Model,tro_prmtr);
    end

    [obs_C_GPS,obs_L_GPS, GPS_SNR]=observation_GPS(rnxdata,rnx_GPS,SNR_cutoff,s);
    obs_GPS1=[obs_C_GPS;obs_L_GPS];


    [Sat_Info_GPS]=Sat_Information(rec_Pre_Info,obs_C_GPS,rnxtime,GPSsp3,sp3time,GPSclock,clocktime,s);
    Sat_Info_GPS.GPS_SNR=GPS_SNR;

    [AGPS,CGPS,lGPS,obs_GPS,XyeniGPS,ZHD,ZWD,prevGPS,trop,satElevationGPS,G_SNR,satAzimuth]=Design_GPS(mod_Opt,stoc,cut_Off_Elev,tro_prmtr,combination,X,xsat,obs_GPS1,rec_Pre_Info,Sat_Info_GPS,satOffset.GPS,recOffset,rnxtime,prevGPS,s);

    GPS_matrix.A=AGPS;  GPS_matrix.C=CGPS;  GPS_matrix.l=lGPS; GPS_matrix.obs=obs_GPS;
    GPS_matrix.Elev=satElevationGPS;  GPS_matrix.SNR=G_SNR; GPS_matrix.azi=satAzimuth;




    if combination ==2 || (combination>=4 && combination<=8)

        [obs_C_GLO,obs_L_GLO,GLO_SNR]=observation_GLO(rnxdata,rnx_GLO,SNR_cutoff,s);
        obs_GLO1=[obs_C_GLO;obs_L_GLO];



        if isempty(obs_C_GLO)

            AGLO=[];CGLO=[];lGLO=[];obs_GLO=[];XyeniGLO=[];satElevationGLO=[];prevGLO=0;R_SNR=[];R_satAzimuth=[];

        else
            [Sat_Info_GLO]=Sat_Information(rec_Pre_Info,obs_C_GLO,rnxtime,GLONASSsp3,sp3time,GLONASSclock,clocktime,s);
            Sat_Info_GLO.GLO_SNR=GLO_SNR;

            [AGLO,CGLO,lGLO,obs_GLO,XyeniGLO,satElevationGLO,prevGLO,R_SNR,R_satAzimuth]=Design_GLONASS(mod_Opt,stoc,cut_Off_Elev,tro_prmtr,combination,X,xsat,obs_GLO1,rec_Pre_Info,Sat_Info_GLO,satOffset.GLONASS,recOffset,rnxtime,prevGLO,s);

        end


        GLO_matrix.A=AGLO;  GLO_matrix.C=CGLO;  GLO_matrix.l=lGLO; GLO_matrix.obs=obs_GLO;
        GLO_matrix.Elev=satElevationGLO;  GLO_matrix.SNR=R_SNR; GLO_matrix.azi=R_satAzimuth;

    end


    if combination >2


        [obs_C_GAL,obs_L_GAL,GAL_SNR]=observation_GAL(rnxdata,rnx_GAL,SNR_cutoff,s);
        obs_GAL1=[obs_C_GAL;obs_L_GAL];

        if isempty(obs_C_GAL)

            AGAL=[];CGAL=[];lGAL=[];obs_GAL=[];XyeniGAL=[];satElevationGAL=[];prevGAL=0;E_SNR=[];E_azimuth=[];
        else



            [Sat_Info_GAL]=Sat_Information(rec_Pre_Info,obs_C_GAL,rnxtime,GALILEOsp3,sp3time,GALILEOclock,clocktime,s);
            Sat_Info_GAL.GAL_SNR=GAL_SNR;
            [AGAL,CGAL,lGAL,obs_GAL,XyeniGAL,satElevationGAL,prevGAL,E_SNR,E_azimuth]=Design_Galileo(mod_Opt,stoc,cut_Off_Elev,tro_prmtr,combination,X,xsat,obs_GAL1,rec_Pre_Info,Sat_Info_GAL,satOffset.GALILEO,recOffset,rnxtime,prevGAL,s);
        end



        GAL_matrix.A=AGAL;  GAL_matrix.C=CGAL;  GAL_matrix.l=lGAL; GAL_matrix.obs=obs_GAL;
        GAL_matrix.Elev=satElevationGAL; GAL_matrix.SNR=E_SNR;  GAL_matrix.azi=E_azimuth;

    end



    if combination==5 || combination==7 || combination==8


        [obs_C_BDS,obs_L_BDS, BDS2_SNR]=observation_BDS2(rnxdata,rnx_BDS,SNR_cutoff,s);
        obs_BDS21=[obs_C_BDS;obs_L_BDS];


        if isempty(obs_C_BDS)

            ABDS2=[];CBDS2=[];lBDS2=[];obs_BDS2=[];XyeniBDS2=[];satElevationBDS2=[];prevBDS2=0;C2_SNR=[];C2_azimuth=[];

        else

            [Sat_Info_BDS2]=Sat_Information(rec_Pre_Info,obs_C_BDS,rnxtime,BEIDOUsp3,sp3time,BEIDOUclock,clocktime,s);
            Sat_Info_BDS2.BDS2_SNR=BDS2_SNR;


            [ABDS2,CBDS2,lBDS2,obs_BDS2,XyeniBDS2,satElevationBDS2,prevBDS2,C2_SNR,C2_azimuth]=Design_BDS2(mod_Opt,stoc,cut_Off_Elev, tro_prmtr,combination,X,xsat,obs_BDS21,rec_Pre_Info,Sat_Info_BDS2,satOffset.BEIDOU,recOffset,rnxtime,prevBDS2,s);

        end
        BDS2_matrix.A=ABDS2;  BDS2_matrix.C=CBDS2;  BDS2_matrix.l=lBDS2; BDS2_matrix.obs=obs_BDS2;
        BDS2_matrix.Elev=satElevationBDS2; BDS2_matrix.SNR=C2_SNR;  BDS2_matrix.azi=C2_azimuth;




    end



    if combination>5

        [obs_C_BDS3,obs_L_BDS3,BDS3_SNR]=observation_BDS3(rnxdata,rnx_BDS,SNR_cutoff,s);

        obs_BDS31=[obs_C_BDS3;obs_L_BDS3];

        if isempty(obs_C_BDS3)

            ABDS3=[];CBDS3=[];lBDS3=[];obs_BDS3=[];XyeniBDS3=[];satElevationBDS3=[];prevBDS3=0;C3_SNR=[];C3_azimuth=[];

        else


            [Sat_Info_BDS3]=Sat_Information(rec_Pre_Info,obs_C_BDS3,rnxtime,BEIDOUsp3,sp3time,BEIDOUclock,clocktime,s);
            Sat_Info_BDS3.BDS3_SNR=BDS3_SNR;


            [ABDS3,CBDS3,lBDS3,obs_BDS3,XyeniBDS3,satElevationBDS3,prevBDS3,C3_SNR,C3_azimuth]=Design_BDS3(mod_Opt,stoc,cut_Off_Elev, tro_prmtr,combination,X,xsat,obs_BDS31,rec_Pre_Info,Sat_Info_BDS3,satOffset.BEIDOU,recOffset,rnxtime,prevBDS3,s);

        end

        BDS3_matrix.A=ABDS3;  BDS3_matrix.C=CBDS3;  BDS3_matrix.l=lBDS3; BDS3_matrix.obs=obs_BDS3;

        BDS3_matrix.Elev=satElevationBDS3; BDS3_matrix.SNR=C3_SNR;  BDS3_matrix.azi=C3_azimuth;

    end




    if combination>7

        [obs_C_QZSS,obs_L_QZSS,QZSS_SNR]=observation_QZSS(rnxdata,rnx_QZSS,SNR_cutoff,s);
        obs_QZSS1=[obs_C_QZSS;obs_L_QZSS];

        if isempty(obs_C_QZSS)
            AQZSS=[];CQZSS=[];lQZSS=[];obs_QZSS=[];XyeniQZSS=[];satElevationQZSS=[];prevQZSS=0;J_SNR=[];J_azimuth=[];


        else

            [Sat_Info_QZSS]=Sat_Information(rec_Pre_Info,obs_C_QZSS,rnxtime,QZSSsp3,sp3time,QZSSclock,clocktime,s);
            Sat_Info_QZSS.QZSS_SNR=QZSS_SNR;

            [AQZSS,CQZSS,lQZSS,obs_QZSS,XyeniQZSS,satElevationQZSS,prevQZSS,J_SNR,J_azimuth]=Design_QZSS(mod_Opt,stoc,cut_Off_Elev, tro_prmtr,combination,X,xsat,obs_QZSS1,rec_Pre_Info,Sat_Info_QZSS,satOffset.QZSS,recOffset,rnxtime,prevQZSS,s);


        end
        QZSS_matrix.A=AQZSS;  QZSS_matrix.C=CQZSS;  QZSS_matrix.l=lQZSS; QZSS_matrix.obs=obs_QZSS;
        QZSS_matrix.Elev=satElevationQZSS;
        QZSS_matrix.SNR=J_SNR;  QZSS_matrix.azi=J_azimuth;

    end





    %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    %%%%% ................. PPP .................
    %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    switch combination

        case 1 %%%G

            [X,CXX,xsat,fin_results]=PPP_G(CXX,xsat,XyeniGPS,GPS_matrix,filter_par,rnxtime,s);

            res{s,1}=fin_results;
            DOP_values(s,:)=fin_results.DOPS;
            [north2,east2,up2,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northG(s,1)=north2;  eastG(s,1)=east2; upG(s,1)=up2;  d3G(s,1)=total_error;
            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2), rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), 0, 0, 0, 0, 0];



        case 2 %%%GR

            [X,CXX,xsat,fin_results]=PPP_GR(XyeniGPS,XyeniGLO,CXX,xsat,GPS_matrix,GLO_matrix,filter_par,rnxtime,s);

            res{s,1}=fin_results;
            DOP_values(s,:)=fin_results.DOPS;
            [north2,east2,up2,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northGR(s,1)=north2;  eastGR(s,1)=east2; upGR(s,1)=up2;  d3GR(s,1)=total_error;
            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2),rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), X(6,1), 0, 0, 0, 0];

        case 3 %%%GE

            [X,CXX,xsat,fin_results]=PPP_GE(XyeniGPS,XyeniGAL,CXX,xsat,GPS_matrix,GAL_matrix,filter_par,rnxtime,s);
            res{s,1}=fin_results;
            [north3,east3,up3,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northGE(s,1)=north3;  eastGE(s,1)=east3; upGE(s,1)=up3;  d3GE1(s,1)=total_error;
            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2),rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), 0, X(6,1), 0, 0, 0];


        case 4 %%%GRE

            [X,CXX,xsat,fin_results]=PPP_GRE(XyeniGPS,XyeniGLO,XyeniGAL,CXX,xsat,GPS_matrix,GLO_matrix,GAL_matrix,filter_par,rnxtime,s);
            res{s,1}=fin_results;
            DOP_values(s,:)=fin_results.DOPS;
            [north4,east4,up4,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northGRE(s,1)=north4;  eastGRE(s,1)=east4; upGRE(s,1)=up4;  d3GRE(s,1)=total_error;
            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2),rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), X(6,1), X(7,1), 0, 0, 0];



        case 5 %%%GREC2

            [X,CXX,xsat,fin_results]=PPP_GREC2(XyeniGPS,XyeniGLO,XyeniGAL,XyeniBDS2,CXX,xsat,GPS_matrix,GLO_matrix,GAL_matrix,BDS2_matrix,filter_par,rnxtime,s);
            res{s,1}=fin_results;
            DOP_values(s,:)=fin_results.DOPS;
            [north5,east5,up5,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northGREC2(s,1)=north5;  eastGREC2(s,1)=east5; upGREC2(s,1)=up5;  d3GREC2(s,1)=total_error;
            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2),rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), X(6,1), X(7,1), X(8,1), 0, 0];


        case 6 %%%GREC3

            [X,CXX,xsat,fin_results]=PPP_GREC3(XyeniGPS,XyeniGLO,XyeniGAL,XyeniBDS3,CXX,xsat,GPS_matrix,GLO_matrix,GAL_matrix,BDS3_matrix,filter_par,rnxtime,s);
            res{s,1}=fin_results;
            DOP_values(s,:)=fin_results.DOPS;
            [north6,east6,up6,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northGREC3(s,1)=north6;  eastGREC3(s,1)=east6; upGREC3(s,1)=up6;  d3GREC3(s,1)=total_error;
            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2),rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), X(6,1), X(7,1), 0,  X(8,1), 0];



        case 7 %%%GREC2C3

            [X,CXX,xsat,fin_results]=PPP_GREC2C3(XyeniGPS,XyeniGLO,XyeniGAL,XyeniBDS2,XyeniBDS3,CXX,xsat,GPS_matrix,GLO_matrix,GAL_matrix,BDS2_matrix,BDS3_matrix,filter_par,rnxtime,s);
            res{s,1}=fin_results;
            DOP_values(s,:)=fin_results.DOPS;
            [north7,east7,up7,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northGREC2C3(s,1)=north7;  eastGREC2C3(s,1)=east7; upGREC2C3(s,1)=up7;  d3GREC2C3(s,1)=total_error;

            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2),rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), X(6,1), X(7,1), X(8,1), X(9,1), 0];


        case 8 %%%GREC2C3J


            [X,CXX,xsat,fin_results]=PPP_GREC2C3J(XyeniGPS,XyeniGLO,XyeniGAL,XyeniBDS2,XyeniBDS3,XyeniQZSS,CXX,xsat,GPS_matrix,GLO_matrix,GAL_matrix,BDS2_matrix,BDS3_matrix,QZSS_matrix,filter_par,rnxtime,s);
            res{s,1}=fin_results;
            DOP_values(s,:)=fin_results.DOPS;
            [north8,east8,up8,total_error]=cal_topoError(X,ground_truth_coor,Lat_ground_trut,Lon_ground_trut);
            northGREC2C3J(s,1)=north8;  eastGREC2C3J(s,1)=east8; upGREC2C3J(s,1)=up8;  d3GREC2C3J(s,1)=total_error;

            output(s,:)=[s,rnxtime(s,4),rnxtime(s,2),rnxtime(s,1), X(1:3,1)', X(4,1), trop+X(5,1), X(6,1), X(7,1), X(8,1), X(9,1), X(10,1)];

    end



    AGPS =[]; CGPS=[]; lGPS=[]; obs_GPS1=[]; obs_C_GPS=[]; obs_L_GPS=[]; obs_GPS=[];
    Sat_Info_GPS=[]; XyeniGPS=[]; satElevationGPS=[];



    AGLO =[]; CGLO=[]; lGLO=[]; obs_GLO1=[]; obs_C_GLO=[]; obs_L_GLO=[]; obs_GLO=[];
    Sat_Info_GLO=[]; XyeniGLO=[]; satElevationGLO=[];


    AGAL =[]; CGAL=[]; lGAL=[]; obs_GAL1=[]; obs_C_GAL=[]; obs_L_GAL=[]; obs_GAL=[];
    Sat_Info_GAL=[]; XyeniGAL=[]; satElevationGAL=[];


    ABDS2 =[]; CBDS2=[]; lBDS2=[]; obs_BDS21=[]; obs_C_BDS2=[]; obs_L_BDS2=[]; obs_BDS2=[];
    Sat_Info_BDS2=[]; XyeniBDS2=[]; satElevationBDS2=[];


    ABDS3 =[]; CBDS3=[]; lBDS3=[]; obs_BDS31=[]; obs_C_BDS3=[]; obs_L_BDS3=[]; obs_BDS3=[];
    Sat_Info_BDS3=[]; XyeniBDS3=[]; satElevationBDS3=[];


    AQZSS =[]; CQZSS=[]; lQZSS=[]; obs_QZSS1=[]; obs_C_QZSS=[]; obs_L_QZSS=[]; obs_QZSS=[];
    Sat_Info_QZSS=[]; XyeniQZSS=[]; satElevationQZSS=[];

end

%READ Troposphere File
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[ref_ZTD]=read_Troposphere(TropFilename,markerName);
[ZTD_rms,int_ZTD]=trop_rms(ref_ZTD,rnxtime,output(:,9));

%Statistical results
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
delta_time=rnxtime(2,1)-rnxtime(1,1);
conv_criteria=0.10;
[rms_values,conv_time,north_PPP,east_PPP,up_PPP]=acc_cal_PPP(output,ground_truth_coor,Lat_ground_trut,Lon_ground_trut,delta_time,conv_criteria);
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ZTD_rms
rms_values   %%%[north_RMS;east_RMS;up;3D_RMS]
conv_time


%Outputs for satellite systems
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[GPS_output,GLO_output,GAL_output,BDS2_output,...
    BDS3_output,QZSS_output]=final_results(combination,res);
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%%%%%store of PPP results
store_PPPresults(output,markerName,combination);
