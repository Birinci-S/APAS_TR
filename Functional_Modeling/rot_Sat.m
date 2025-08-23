function [rSat]=rot_Sat(satpos,deltat)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

omega=7.2921151467*10^-5;%radyan/saniye       
aa=deltat*omega;
R=[cos(aa) sin(aa) 0 ;-sin(aa) cos(aa) 0;0 0 1];
rSat=R*satpos;

end