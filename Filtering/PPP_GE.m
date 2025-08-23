function [X_final,CXX,xsat,fin_results]=PPP_GE(XyeniGPS,XyeniGAL,CXX,xsat,GPS_matrix,GAL_matrix,filter_par,rnxtime,s)

%%% This function is a component of APAS-TR. 10.02.2024, S. Birinci


AGPS=GPS_matrix.A;   CGPS=GPS_matrix.C;  lGPS=GPS_matrix.l; obs_GPS=GPS_matrix.obs;
satElevationGPS=GPS_matrix.Elev;
G_SNR=GPS_matrix.SNR; G_azimuth=GPS_matrix.azi;

AGAL=GAL_matrix.A;   CGAL=GAL_matrix.C;  lGAL=GAL_matrix.l; obs_GAL=GAL_matrix.obs;
satElevationGAL=GAL_matrix.Elev;
E_SNR=GAL_matrix.SNR;   E_azimuth=GAL_matrix.azi;


if isempty(obs_GAL)
    if length(xsat.GE)>1


        xsat.G=xsat.GE(1:(size(xsat.G,1)),1:2+(size(xsat.G,1)));
        XyeniGPS(6:6,:)=[]; %for GAL ISB
        AGPS(:,6:6)=[]; GPS_matrix.A=AGPS ; %for GAL ISB
        CXX(6:6,:)=[];   CXX(:,6:6)=[]; %for GAL ISB

    elseif  length(xsat.GE)==1

        XyeniGPS(6:6,:)=[];
        AGPS(:,6:6)=[]; GPS_matrix.A=AGPS ;

    end

    [X,CXX,xsat,fin_results]=PPP_G(CXX,xsat,XyeniGPS,GPS_matrix,filter_par,rnxtime,s);
    fin_results.order_num(3:4,1)=[0;0]; %for GAL code and phase

    satGPS=obs_GPS(1:(size(obs_GPS,1)/2),2);
    xsat.G=[satGPS,X(6:end,1),(CXX(6:end,6:end))];
    xsat.E=0; xsat.GE=0;

    X_final=X(1:5,1);
    X_final(6:6,1)=0;



else

    int_coord=filter_par.int_coord; int_GPS_rec=filter_par.int_GPS_rec;
    int_zenit_wet=filter_par.int_zenit_wet; int_Amb=filter_par.int_Amb;
    int_IBSs=filter_par.int_IBSs;

    noise_coord=filter_par.noise_coord;  noise_GPS_rec=filter_par.noise_GPS_rec;
    noise_zenit_wet=filter_par.noise_zenit_wet;  noise_Amb=filter_par.noise_Amb;
    noise_IBSs=filter_par.noise_IBSs;


    olculer=[obs_GPS;obs_GAL];
    l=[lGPS;lGAL];
    A1=[AGPS(:,(1:6)); AGAL(:,(1:6))];
    A2=[AGPS(:,(7:end)) ; zeros(size(AGAL,1),size(AGPS,2)-6)];
    A3=[zeros(size(AGPS,1),size(AGAL,2)-6);AGAL(:,(7:end))];
    A=[A1 A2 A3];




    C10=[CGPS zeros(size(CGPS,1),size(CGAL,2))];
    C20=[zeros(size(CGAL,1),size(CGPS,2)) CGAL];
    C=[C10;C20];


    satGPS=obs_GPS(1:(size(obs_GPS,1)/2),2);
    satGAL=obs_GAL(1:(size(obs_GAL,1)/2),2);


    if s==1
        for p=1:size(olculer,1)/2
            if p<7 && p==4
                C01(p,p)=int_GPS_rec.^2;
            elseif  p<7 && p==5
                C01(p,p)=int_zenit_wet.^2;
            elseif  p<7 && p==6
                C01(p,p)=int_IBSs.^2;
            elseif  p<7
                C01(p,p)=int_coord.^2;
            end
            C02(p,p)=int_Amb.^2;
        end

        C03=zeros(6,size(olculer,1)/2);
        C04=zeros(size(olculer,1)/2,6);

    else
        C01=CXX(1:6,1:6);
        sayac=1; sayac1=1;
        olculerkontrol =[obs_GPS(1:size(obs_GPS,1)/2,2);((obs_GAL(1:size(obs_GAL,1)/2,2))+40)];

        C02=zeros(size(olculerkontrol,1),size(olculerkontrol,1)); %%%%%%%%%%%!!! 22.10.2024


        for p=1:size(olculerkontrol,1)

            arasatir2=find(olculerkontrol(p,1)==xsat.GE(:,1));
            if ~isempty(arasatir2)
                C03(1:6,sayac1)=CXX(1:6,6+arasatir2);
                C04(sayac1,1:6)=CXX(6+arasatir2,1:6);
                sayac=sayac+1;

            elseif isempty(arasatir2)
                C03(1:6,sayac1)=0;
                C04(sayac1,1:6)=0;

            end





            for pp=1:size(olculerkontrol,1)
                arasatir3=find(olculerkontrol(pp,1)==xsat.GE(:,1));

                if ~isempty(arasatir3)&& ~isempty(arasatir2)
                    C02(p,pp)=xsat.GE(arasatir2,2+arasatir3);

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
    noiseMatrix1=[noise_coord.^2/3600*deltaT 0 0 0 0 0; 0 noise_coord.^2/3600*deltaT 0 0 0 0; 0 0 noise_coord.^2/3600*deltaT 0  0 0 ;...
        0 0 0 noise_GPS_rec.^2/3600*deltaT 0 0  ; 0 0 0 0 noise_zenit_wet.^2/3600*deltaT 0 ;0 0 0 0 0 noise_IBSs.^2/3600*deltaT];


    nTam=size(A,2)-6;
    if s==reStartAmb_epoch;noise_Amb=0.1; end %% for epoch gaps
    noiseMatrix2=eye(nTam).*noise_Amb.^2/3600*deltaT;

    noiseMatrix3=zeros(nTam,6);
    noiseMatrix4=zeros(6,nTam);
    noiseMatrix=[noiseMatrix1 noiseMatrix4 ;noiseMatrix3 noiseMatrix2 ];
    transtion=eye(size(A,2));

    Xyeni=[XyeniGPS;XyeniGAL(7:end)];


    %prediction step
    xpredicte=transtion*Xyeni;
    Cpredicte=transtion*C0*transtion'+noiseMatrix;



    combination=3;
    sat_Elev.GPS=satElevationGPS;
    sat_SNR.GPS=G_SNR;
    sat_Azi.GPS=G_azimuth;

    sat_Elev.GAL=satElevationGAL;
    sat_SNR.GAL=E_SNR;
    sat_Azi.GAL=E_azimuth;


    [xfilter,Cfilter,fin_results]=outlierDiagnosis_Sol(combination,xpredicte ,Cpredicte ,l ,A,C,sat_Elev,sat_SNR,sat_Azi);


    X=xfilter;

    CXX=Cfilter;


    XGPS=X(7:size(satGPS,1)+6);

    XGAL=X(size(satGPS,1)+7:end);
    sats=[satGPS;satGAL+40];
    Xsats=[XGPS;XGAL];
    xsat.GE=[sats,Xsats,(CXX(7:end,7:end))];
    xsat.G=[satGPS XGPS];
    xsat.E=[satGAL XGAL];

    X_final=X(1:6,1);

end

end

