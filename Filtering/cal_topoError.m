function[north2,east2,up2,total_error]=cal_topoError(X,recPosition5,Enlem1,Boylam1)


%%% This function is a component of APAS-TR. 11.02.2024, S. Birinci


deltaX2=X(1:3,1)-recPosition5;
Rtopo2=[-sind(Enlem1)*cosd(Boylam1) -sind(Enlem1)*sind(Boylam1)  cosd(Enlem1);
    -sind(Boylam1) cosd(Boylam1) 0 ;
    cosd(Enlem1)*cosd(Boylam1) cosd(Enlem1)*sind(Boylam1) sind(Enlem1)]; 

toposentrik2=Rtopo2*deltaX2; 



north2=toposentrik2(1,1);
east2=toposentrik2(2,1);
up2=toposentrik2(3,1);
total_error=sqrt(north2^2+east2^2+up2^2);
end