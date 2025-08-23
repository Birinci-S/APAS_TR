function [enlem,boylam,hellp]=xyz2eby(position)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci



X=position(1,1);
Y=position(2,1);
Z=position(3,1);
%GRS80
a=6378137;
b=6356752.3141;
%c=6399593.6259;
eussukare=0.00673949677548;
e = 0.081819191043422;
ekare=e^2;


q=atan((Z*a)/(b*sqrt(X^2+Y^2)))*180/pi;
enlem=atan((Z+eussukare*b*(sind(q))^3)/(sqrt(X^2+Y^2)-ekare*a*(cosd(q))^3))*180/pi;
boylam=(atan2(Y,X))*180/pi;
N=a/(sqrt(1-ekare*(sind(enlem))^2));
hellp=(sqrt(X^2+Y^2))/cosd(enlem)-N;
end