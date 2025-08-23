function [X_final,CXX,xsat,fin_results]=PPP_GRE(XyeniGPS,XyeniGLO,XyeniGAL,CXX,xsat,GPS_matrix,GLO_matrix,GAL_matrix,filter_par,rnxtime,s)

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



if isempty(obs_GLO) || isempty(obs_GAL)

    if length(xsat.GRE)>1


        xsat.G=xsat.GRE(1:(size(xsat.G,1)),1:2+(size(xsat.G,1)));
        XyeniGPS(6:7,:)=[]; %for GLO and GAL ISB
        AGPS(:,6:7)=[]; GPS_matrix.A=AGPS ; %for GLO and GAL ISB
        CXX(6:7,:)=[];   CXX(:,6:7)=[]; %for GLO and GAL ISB

    elseif  length(xsat.GRE)==1

        XyeniGPS(6:7,:)=[];
        AGPS(:,6:7)=[]; GPS_matrix.A=AGPS ;

    end

    [X,CXX,xsat,fin_results]=PPP_G(CXX,xsat,XyeniGPS,GPS_matrix,filter_par,rnxtime,s);
    fin_results.order_num(3:6,1)=[0;0;0;0]; %for GLO and GAL code and phase

    satGPS=obs_GPS(1:(size(obs_GPS,1)/2),2);
    xsat.G=[satGPS,X(6:end,1),(CXX(6:end,6:end))];
    xsat.R=0; xsat.E=0; xsat.GRE=0;

    X_final=X(1:5,1);
    X_final(6:7,1)=0;



else



    int_coord=filter_par.int_coord; int_GPS_rec=filter_par.int_GPS_rec;
    int_zenit_wet=filter_par.int_zenit_wet; int_Amb=filter_par.int_Amb;
    int_IBSs=filter_par.int_IBSs;

    noise_coord=filter_par.noise_coord;  noise_GPS_rec=filter_par.noise_GPS_rec;
    noise_zenit_wet=filter_par.noise_zenit_wet;  noise_Amb=filter_par.noise_Amb;
    noise_IBSs=filter_par.noise_IBSs;



    olculer=[obs_GPS;obs_GLO;obs_GAL];
    l=[lGPS;lGLO;lGAL];
    A1=[AGPS(:,(1:7)); AGLO(:,(1:7));AGAL(:,(1:7))];
    A2=[AGPS(:,(8:end)) ; zeros(size(AGLO,1),size(AGPS,2)-7) ;zeros(size(AGAL,1),size(AGPS,2)-7)];
    A3=[zeros(size(AGPS,1),size(AGLO,2)-7);AGLO(:,(8:end)) ;zeros(size(AGAL,1),size(AGLO,2)-7)];
    A4=[zeros(size(AGPS,1),size(AGAL,2)-7) ;zeros(size(AGLO,1),size(AGAL,2)-7) ;AGAL(:,(8:end))];


    A=[A1 A2 A3 A4];




    C10=[CGPS zeros(size(CGPS,1),size(CGLO,2))  zeros(size(CGPS,1),size(CGAL,2))];
    C20=[zeros(size(CGLO,1),size(CGPS,2)) CGLO zeros(size(CGLO,1),size(CGAL,2))];
    C30=[zeros(size(CGAL,1),size(CGPS,2))  zeros(size(CGAL,1),size(CGLO,2)) CGAL];

    C=[C10;C20;C30];


    satGPS=obs_GPS(1:(size(obs_GPS,1)/2),2);
    satGLO=obs_GLO(1:(size(obs_GLO,1)/2),2);
    satGAL=obs_GAL(1:(size(obs_GAL,1)/2),2);


    if s==1
        for p=1:size(olculer,1)/2
            if p<8 && p==4
                C01(p,p)=int_GPS_rec.^2;
            elseif  p<8 && p==5
                C01(p,p)=int_zenit_wet.^2;
            elseif  p<8 && p==6
                C01(p,p)=int_IBSs.^2;
            elseif  p<8 && p==7
                C01(p,p)=int_IBSs.^2;
            elseif  p<8
                C01(p,p)=int_coord.^2;
            end
            C02(p,p)=int_Amb.^2;
        end

        C03=zeros(7,size(olculer,1)/2);
        C04=zeros(size(olculer,1)/2,7);

    else
        C01=CXX(1:7,1:7);
        sayac=1; sayac1=1;
        olculerkontrol =[obs_GPS(1:size(obs_GPS,1)/2,2);((obs_GLO(1:size(obs_GLO,1)/2,2))+40) ;...
            ((obs_GAL(1:size(obs_GAL,1)/2,2))+100) ];

        C02=zeros(size(olculerkontrol,1),size(olculerkontrol,1)); %%%%%%%%%%%!!! 22.10.2024


        for p=1:size(olculerkontrol,1)

            arasatir2=find(olculerkontrol(p,1)==xsat.GRE(:,1));
            if ~isempty(arasatir2)
                C03(1:7,sayac1)=CXX(1:7,7+arasatir2);
                C04(sayac1,1:7)=CXX(7+arasatir2,1:7);
                sayac=sayac+1;

            elseif isempty(arasatir2)
                C03(1:7,sayac1)=0;
                C04(sayac1,1:7)=0;

            end



            for pp=1:size(olculerkontrol,1)
                arasatir3=find(olculerkontrol(pp,1)==xsat.GRE(:,1));

                if ~isempty(arasatir3)&& ~isempty(arasatir2)
                    C02(p,pp)=xsat.GRE(arasatir2,2+arasatir3);

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

    noiseMatrix1=[noise_coord.^2/3600*deltaT 0 0 0 0 0 0; 0 noise_coord.^2/3600*deltaT 0 0 0 0 0; 0 0 noise_coord.^2/3600*deltaT 0 0 0 0 ; ...
        0 0 0 noise_GPS_rec.^2/3600*deltaT 0 0 0 ; 0 0 0 0 noise_zenit_wet.^2/3600*deltaT 0 0;0 0 0 0 0 noise_IBSs.^2/3600*deltaT 0 ;0 0 0 0 0 0 noise_IBSs.^2/3600*deltaT];


    nTam=size(A,2)-7;
    if s==reStartAmb_epoch;noise_Amb=1; end %%%%for data gaps
    noiseMatrix2=eye(nTam).*noise_Amb.^2/3600*deltaT;
    noiseMatrix3=zeros(nTam,7);
    noiseMatrix4=zeros(7,nTam);
    noiseMatrix=[noiseMatrix1 noiseMatrix4 ;noiseMatrix3 noiseMatrix2 ];
    transtion=eye(size(A,2));

    Xyeni=[XyeniGPS;XyeniGLO(8:end);XyeniGAL(8:end)];
    xpredicte=transtion*Xyeni;
    Cpredicte=transtion*C0*transtion'+noiseMatrix;


    combination=4;
    sat_Elev.GPS=satElevationGPS;
    sat_SNR.GPS=G_SNR;
    sat_Azi.GPS=G_azimuth;

    sat_Elev.GLO=satElevationGLO;
    sat_SNR.GLO=R_SNR;
    sat_Azi.GLO=R_azimuth;


    sat_Elev.GAL=satElevationGAL;
    sat_SNR.GAL=E_SNR;
    sat_Azi.GAL=E_azimuth;


    [xfilter,Cfilter,fin_results]=outlierDiagnosis_Sol(combination,xpredicte ,Cpredicte ,l ,A,C,sat_Elev,sat_SNR,sat_Azi);





    X=xfilter;

    CXX=Cfilter;


    XGPS=X(8:size(obs_GPS,1)/2+7);
    XGLO=X(size(obs_GPS,1)/2+8:(size(obs_GPS,1)/2)+(size(obs_GLO,1)/2)+7);
    XGAL=X((size(obs_GPS,1)/2)+(size(obs_GLO,1)/2)+8:end);

    sats=[satGPS;satGLO+40;satGAL+100];
    Xsats=[XGPS;XGLO;XGAL];
    xsat.GRE=[sats,Xsats,(CXX(8:end,8:end))];
    xsat.G=[satGPS XGPS];
    xsat.R=[satGLO XGLO];
    xsat.E=[satGAL XGAL];
    X_final=X(1:7,1);

end
end

