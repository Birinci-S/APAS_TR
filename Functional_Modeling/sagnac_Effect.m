function [sagnac_Cor]=sagnac_Effect(recPosition,satPosition)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

lightSpeed=299792458;
omega=[0;0;7.2921151467*10^-5];
first_term=(2.*omega)./lightSpeed;
sec_term=cross(recPosition,satPosition)./2;
sagnac_Cor=dot(first_term,sec_term);

end
