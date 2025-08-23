
function[X_final,CXX,xsat,fin_results]=PPP_GREC3(XyeniGPS,XyeniGLO,XyeniGAL,XyeniBDS3,CXX,xsat,GPS_matrix,GLO_matrix,GAL_matrix,BDS3_matrix,filter_par,rnxtime,s)


%%% This function is a component of APAS-TR. 10.02.2024, S. Birinci



AGPS=GPS_matrix.A;   CGPS=GPS_matrix.C;  lGPS=GPS_matrix.l; obs_GPS=GPS_matrix.obs;
satElevationGPS=GPS_matrix.Elev;
G_SNR=GPS_matrix.SNR; G_azimuth=GPS_matrix.azi;

AGLO=GLO_matrix.A;   CGLO=GLO_matrix.C;  lGLO=GLO_matrix.l; obs_GLO=GLO_matrix.obs;
satElevationGLO=GLO_matrix.Elev;
R_SNR=GLO_matrix.SNR; R_azimuth=GLO_matrix.azi;

AGAL=GAL_matrix.A;   CGAL=GAL_matrix.C;  lGAL=GAL_matrix.l; obs_GAL=GAL_matrix.obs;
satElevationGAL=GAL_matrix.Elev;
E_SNR=GAL_matrix.SNR;   E_azimuth=GAL_matrix.azi;

ABDS3=BDS3_matrix.A;   CBDS3=BDS3_matrix.C;  lBDS3=BDS3_matrix.l; obs_BDS3=BDS3_matrix.obs;
satElevationBDS3=BDS3_matrix.Elev;
C3_SNR=BDS3_matrix.SNR; C3_azimuth=BDS3_matrix.azi;



if isempty(obs_BDS3) || isempty(obs_GLO)  || isempty(obs_GAL)

    if length(xsat.GREC3)>1


        xsat.G=xsat.GREC3(1:(size(xsat.G,1)),1:2+(size(xsat.G,1)));
        XyeniGPS(6:8,:)=[]; % for GPS,GLO,GAL,BDS3 ISB
        AGPS(:,6:8)=[]; GPS_matrix.A=AGPS ; % for GPS,GLO,GAL,BDS3 ISB
        CXX(6:8,:)=[];   CXX(:,6:8)=[]; % for GPS,GLO,GAL,BDS3 ISB

    elseif  length(xsat.GREC3)==1

        XyeniGPS(6:8,:)=[];
        AGPS(:,6:8)=[]; GPS_matrix.A=AGPS ;
    end

    [X,CXX,xsat,fin_results]=PPP_G(CXX,xsat,XyeniGPS,GPS_matrix,filter_par,rnxtime,s);
    fin_results.order_num(3:8,1)=[0;0;0;0;0;0]; %for GPS,GLO,GAL,BDS3 code and phase

    satGPS=obs_GPS(1:(size(obs_GPS,1)/2),2);
    xsat.G=[satGPS,X(6:end,1),(CXX(6:end,6:end))];
    xsat.R=0; xsat.E=0; xsat.C3=0; xsat.GREC3=0;

    X_final=X(1:5,1);
    X_final(6:8,1)=0;



else


    int_coord=filter_par.int_coord; int_GPS_rec=filter_par.int_GPS_rec;
    int_zenit_wet=filter_par.int_zenit_wet; int_Amb=filter_par.int_Amb;
    int_IBSs=filter_par.int_IBSs;

    noise_coord=filter_par.noise_coord;  noise_GPS_rec=filter_par.noise_GPS_rec;
    noise_zenit_wet=filter_par.noise_zenit_wet;  noise_Amb=filter_par.noise_Amb;
    noise_IBSs=filter_par.noise_IBSs;



    olculer=[obs_GPS;obs_GLO;obs_GAL;obs_BDS3];
    l=[lGPS;lGLO;lGAL;lBDS3];
    A1=[AGPS(:,(1:8)); AGLO(:,(1:8));AGAL(:,(1:8));ABDS3(:,(1:8))];
    A2=[AGPS(:,(9:end)) ; zeros(size(AGLO,1),size(AGPS,2)-8) ;zeros(size(AGAL,1),size(AGPS,2)-8) ;zeros(size(ABDS3,1),size(AGPS,2)-8)];
    A3=[zeros(size(AGPS,1),size(AGLO,2)-8);AGLO(:,(9:end)) ;zeros(size(AGAL,1),size(AGLO,2)-8) ;zeros(size(ABDS3,1),size(AGLO,2)-8)];
    A4=[zeros(size(AGPS,1),size(AGAL,2)-8) ;zeros(size(AGLO,1),size(AGAL,2)-8) ;AGAL(:,(9:end)) ;zeros(size(ABDS3,1),size(AGAL,2)-8)];
    A5=[zeros(size(AGPS,1),size(ABDS3,2)-8) ;zeros(size(AGLO,1),size(ABDS3,2)-8) ;zeros(size(AGAL,1),size(ABDS3,2)-8) ;ABDS3(:,(9:end))];


    A=[A1 A2 A3 A4 A5];


    C10=[CGPS zeros(size(CGPS,1),size(CGLO,2))  zeros(size(CGPS,1),size(CGAL,2)) zeros(size(CGPS,1),size(CBDS3,2))];
    C20=[zeros(size(CGLO,1),size(CGPS,2)) CGLO zeros(size(CGLO,1),size(CGAL,2)) zeros(size(CGLO,1),size(CBDS3,2))];
    C30=[zeros(size(CGAL,1),size(CGPS,2))  zeros(size(CGAL,1),size(CGLO,2)) CGAL zeros(size(CGAL,1),size(CBDS3,2))];
    C40=[zeros(size(CBDS3,1),size(CGPS,2))  zeros(size(CBDS3,1),size(CGLO,2)) zeros(size(CBDS3,1),size(CGAL,2)) CBDS3];
    C=[C10;C20;C30;C40];


    satGPS=obs_GPS(1:(size(obs_GPS,1)/2),2);
    satGLO=obs_GLO(1:(size(obs_GLO,1)/2),2);
    satGAL=obs_GAL(1:(size(obs_GAL,1)/2),2);
    satBDS3=obs_BDS3(1:(size(obs_BDS3,1)/2),2);

    if s==1
        for p=1:size(olculer,1)/2
            if p<9 && p==4
                C01(p,p)=int_GPS_rec.^2;
            elseif  p<9 && p==5
                C01(p,p)=int_zenit_wet.^2;
            elseif  p<9 && p==6
                C01(p,p)=int_IBSs.^2;
            elseif  p<9 && p==7
                C01(p,p)=int_IBSs.^2;
            elseif  p<9 && p==8
                C01(p,p)=int_IBSs.^2;
            elseif  p<9
                C01(p,p)=int_coord.^2;
            end
            C02(p,p)=int_Amb.^2;
        end

        C03=zeros(8,size(olculer,1)/2);
        C04=zeros(size(olculer,1)/2,8);

    else
        C01=CXX(1:8,1:8);
        sayac=1; sayac1=1;
        olculerkontrol =[obs_GPS(1:size(obs_GPS,1)/2,2);((obs_GLO(1:size(obs_GLO,1)/2,2))+40) ;...
            ((obs_GAL(1:size(obs_GAL,1)/2,2))+100);((obs_BDS3(1:size(obs_BDS3,1)/2,2))+200) ];

        C02=zeros(size(olculerkontrol,1),size(olculerkontrol,1)); %%%%%%%%%%%!!! 22.10.2024


        for p=1:size(olculerkontrol,1)

            arasatir2=find(olculerkontrol(p,1)==xsat.GREC3(:,1));
            if ~isempty(arasatir2)
                C03(1:8,sayac1)=CXX(1:8,8+arasatir2);
                C04(sayac1,1:8)=CXX(8+arasatir2,1:8);
                sayac=sayac+1;

            elseif isempty(arasatir2)
                C03(1:8,sayac1)=0;
                C04(sayac1,1:8)=0;

            end





            for pp=1:size(olculerkontrol,1)
                arasatir3=find(olculerkontrol(pp,1)==xsat.GREC3(:,1));

                if ~isempty(arasatir3)&& ~isempty(arasatir2)
                    C02(p,pp)=xsat.GREC3(arasatir2,2+arasatir3);

                elseif isempty(arasatir3)&& isempty(arasatir2) && p==pp
                    C02(p,pp)=int_Amb.^2;
                elseif isempty(arasatir3)&& ~isempty(arasatir2)
                    C02(p,pp)=0;
                elseif ~isempty(arasatir3)&& isempty(arasatir2)
                    C02(p,pp)=0;
                end
            end
            sayac1=sayac1+1;
        end

    end

    C0=[C01 C03;C04 C02];



    reStartAmb_epoch=-1;
    if s==1
        deltaT=30;
    else
        deltaT=rnxtime(s,1)- rnxtime(s-1,1) ;
        reStartAmb_epoch=find(diff(diff(rnxtime(:,1)))>10)+2;
    end

    noiseMatrix1=[noise_coord.^2/3600*deltaT 0 0 0 0 0 0 0; 0 noise_coord.^2/3600*deltaT 0 0 0 0 0 0; 0 0 noise_coord.^2/3600*deltaT 0 0 0 0 0; ...
        0 0 0 noise_GPS_rec.^2/3600*deltaT  0 0 0 0; 0 0 0 0 noise_zenit_wet.^2/3600*deltaT 0 0 0;0 0 0 0 0 noise_IBSs.^2/3600*deltaT 0 0;0 0 0 0 0 0 noise_IBSs.^2/3600*deltaT 0;0 0 0 0 0 0 0 noise_IBSs.^2/3600*deltaT];


    nTam=size(A,2)-8;
    if s==reStartAmb_epoch;noise_Amb=1; end %%for data gaps
    noiseMatrix2=eye(nTam).*noise_Amb.^2/3600*deltaT;
    noiseMatrix3=zeros(nTam,8);
    noiseMatrix4=zeros(8,nTam);
    noiseMatrix=[noiseMatrix1 noiseMatrix4 ;noiseMatrix3 noiseMatrix2 ];
    transtion=eye(size(A,2));

    Xyeni=[XyeniGPS;XyeniGLO(9:end);XyeniGAL(9:end);XyeniBDS3(9:end)];

    %%%prediction step
    xpredicte=transtion*Xyeni;
    Cpredicte=transtion*C0*transtion'+noiseMatrix;

    combination=6;
    sat_Elev.GPS=satElevationGPS;
    sat_SNR.GPS=G_SNR;
    sat_Azi.GPS=G_azimuth;

    sat_Elev.GLO=satElevationGLO;
    sat_SNR.GLO=R_SNR;
    sat_Azi.GLO=R_azimuth;



    sat_Elev.GAL=satElevationGAL;
    sat_SNR.GAL=E_SNR;
    sat_Azi.GAL=E_azimuth;

    sat_Elev.BDS3=satElevationBDS3;
    sat_SNR.BDS3=C3_SNR;
    sat_Azi.BDS3=C3_azimuth;


    [xfilter,Cfilter,fin_results]=outlierDiagnosis_Sol(combination,xpredicte ,Cpredicte ,l ,A,C,sat_Elev,sat_SNR,sat_Azi);


    X=xfilter;

    CXX=Cfilter;



    XGPS=X(9:size(obs_GPS,1)/2+8);
    XGLO=X(size(obs_GPS,1)/2+9:(size(obs_GPS,1)/2)+(size(obs_GLO,1)/2)+8);
    XGAL=X((size(obs_GPS,1)/2)+(size(obs_GLO,1)/2)+9:(size(obs_GPS,1)/2)+(size(obs_GLO,1)/2)+(size(obs_GAL,1)/2)+8);
    XBDS3=X((size(obs_GPS,1)/2)+(size(obs_GLO,1)/2)+(size(obs_GAL,1)/2)+9:end);





    sats=[satGPS;satGLO+40;satGAL+100;satBDS3+200];
    Xsats=[XGPS;XGLO;XGAL;XBDS3];
    xsat.GREC3=[sats,Xsats,(CXX(9:end,9:end))];
    xsat.G=[satGPS XGPS];
    xsat.R=[satGLO XGLO];
    xsat.E=[satGAL XGAL];
    xsat.C3=[satBDS3 XBDS3];
    X_final=X(1:8,1);
end
end