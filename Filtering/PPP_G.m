function[X,CXX,xsat,fin_results]=PPP_G(CXX,xsat,XyeniGPS,GPS_matrix,filter_par,rnxtime,s)


%%% This function is a component of APAS-TR. 10.02.2024, S. Birinci


AGPS=GPS_matrix.A;   CGPS=GPS_matrix.C;  lGPS=GPS_matrix.l; obs_GPS=GPS_matrix.obs;
satElevationGPS=GPS_matrix.Elev;
G_SNR=GPS_matrix.SNR; azimuth=GPS_matrix.azi;


int_coord=filter_par.int_coord; int_GPS_rec=filter_par.int_GPS_rec;
int_zenit_wet=filter_par.int_zenit_wet; int_Amb=filter_par.int_Amb;

noise_coord=filter_par.noise_coord;  noise_GPS_rec=filter_par.noise_GPS_rec;
noise_zenit_wet=filter_par.noise_zenit_wet;  noise_Amb=filter_par.noise_Amb;



l=lGPS;
A=AGPS;

C=CGPS;
satGPS=obs_GPS(1:(size(obs_GPS,1)/2),2);



if s==1

    C001=[int_coord.^2, int_coord.^2,int_coord.^2, int_GPS_rec.^2, int_zenit_wet.^2];
    C01=diag(C001);
    for p=1:size(obs_GPS,1)/2
        % if p<6 && p==4
        %     C01(p,p)=int_GPS_rec.^2;
        % elseif  p<6 && p==5
        %     C01(p,p)=int_zenit_wet.^2;
        % elseif  p<6
        %     C01(p,p)=int_coord.^2;
        % end
        C02(p,p)=int_Amb.^2;
    end


    C03=zeros(5,size(obs_GPS,1)/2);
    C04=zeros(size(obs_GPS,1)/2,5);

else

    C01=CXX(1:5,1:5);
    sayac=1; sayac1=1;



    C02=zeros(size(obs_GPS,1)/2,size(obs_GPS,1)/2); %%%%%%%%%%%!!! 22.10.2024

    for p=1:size(obs_GPS,1)/2

        arasatir2=find(obs_GPS(p,2)==xsat.G(:,1)); %%%TTTTT
        if ~isempty(arasatir2)

            C03(1:5,sayac1)=CXX(1:5,5+arasatir2);
            C04(sayac1,1:5)=CXX(5+arasatir2,1:5);
            sayac=sayac+1;


        elseif isempty(arasatir2)

            C03(1:5,sayac1)=0;
            C04(sayac1,1:5)=0;
        end

        for pp=1:size(obs_GPS,1)/2
            arasatir3=find(obs_GPS(pp,2)==xsat.G(:,1));

            if ~isempty(arasatir3)&& ~isempty(arasatir2)
                C02(p,pp)=xsat.G(arasatir2,2+arasatir3);

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

noiseMatrix1=[noise_coord.^2/3600*deltaT 0 0 0 0; 0 noise_coord.^2/3600*deltaT 0 0 0 ; 0 0 noise_coord.^2/3600*deltaT  0  0 ; ...
    0 0 0 noise_GPS_rec.^2/3600*deltaT 0 ; 0 0 0 0 noise_zenit_wet.^2/3600*deltaT];


nTam=size(A,2)-5;
if s==reStartAmb_epoch;noise_Amb=0.1; end %%for epoch gaps
noiseMatrix2=eye(nTam).*noise_Amb.^2/3600*deltaT;
noiseMatrix3=zeros(nTam,5);
noiseMatrix4=zeros(5,nTam);
noiseMatrix=[noiseMatrix1 noiseMatrix4 ;noiseMatrix3 noiseMatrix2 ];
transtion=eye(size(A,2));


%%%prediction step

Xyeni=XyeniGPS;
xpredicte=transtion*Xyeni;
Cpredicte=transtion*C0*transtion'+noiseMatrix;




combination=1;
sat_Elev.GPS=satElevationGPS;
sat_SNR.GPS=G_SNR;
sat_Azi.GPS=azimuth;

[xfilter,Cfilter,fin_results]=outlierDiagnosis_Sol(combination,xpredicte ,Cpredicte ,l ,A,C,sat_Elev,sat_SNR,sat_Azi);



X=xfilter;

CXX=Cfilter;



xsat.G=[satGPS,X(6:end,1),(CXX(6:end,6:end))];

end