function [The_sun_pos, The_moon_pos]= sun_moon_pos(MJD)


AU=149597870700; %astronomical unit (metres)


d=MJD-51543.0; %0:0:0.00 UT on December 31, 1999 

%The Sun's position calculating
w = 282.9404 + 4.70935e-5  * d; %longitude of perihelion
w = mod(w,360);
a = 1.000000;%(mean distance, a.u.)
e = 0.016709 - 1.151e-9 * d; %(eccentricity)
M = 356.0470 + 0.9856002585 * d;  %(mean anomaly)
M = mod(M,360);


oblecl = 23.4393 - 3.563E-7 * d; 
L = w + M; %Sun's mean longitude, L
L=mod(L,360);
E = M + (180/pi) * e * sind(M) * (1 + e * cosd(M)); % eccentric anomaly

%Sun's rectangular coordinates in the plane of the ecliptic
x = cosd(E) - e;
y = sind(E) * sqrt(1 - e*e);

%Convert to distance and true anomaly:
r = sqrt(x*x + y*y);
v = atan2d( y, x );

%compute the longitude of the Sun:
lon = v + w; lon=mod(lon,360);

%  Sun's ecliptic rectangular coordinates, rotate these to equatorial coordinates
x = r * cosd(lon);
y = r * sind(lon);
z = 0.0;
% use oblecl, and rotate these coordinates
xequat = x;
yequat = y * cosd(oblecl) - z * sind(oblecl);
zequat = y * sind(oblecl) + z * cosd(oblecl);

JD=MJD+ 2400000.5; %from  modified Julian Day  to Julian Day
GAST=JD2GAST(JD); % Greenwich Apparent Sidereal Time calculate
X_sun = (xequat*cosd(GAST)+sind(GAST)*yequat)*149597870700;
Y_sun = (yequat*cosd(GAST)-sind(GAST)*xequat)*149597870700;
Z_sun= (zequat)*149597870700;
The_sun_pos=[X_sun;Y_sun;Z_sun]; %meters
%end of  The Sun Positioning



% Moon Positioning 
%The orbital elements of the Moon
N_moon = 125.1228 - 0.0529538083 * d ; N_moon=mod(N_moon,360);
i_moon =   5.1454;
w_moon = 318.0634 + 0.1643573223  * d; w_moon=mod(w_moon,360);
a_moon =  60.2666; %mean distance
e_moon = 0.054900; %(Eccentricity)
M_moon = 115.3654 + 13.0649929509 * d;  M_moon=mod(M_moon ,360); %(Mean anomaly)


%E, the eccentric anomaly.
E0_moon = M_moon + (180/pi) * e_moon * sind(M_moon) * (1 + e_moon * cosd(M)); E0_moon=mod(E0_moon,360);
%iteration 
for i=1:6
    E1(i,1) = E0_moon - (E0_moon - (180/pi) * e_moon * sind(E0_moon) - M_moon) / (1 - e_moon * cosd(E0_moon));
    E_moon=E1(i,1);
end

% compute rectangular (x,y) coordinates in the plane of the lunar orbit
x_moon = a_moon * (cosd(E_moon) - e_moon);
y_moon = a_moon * sqrt(1 - e_moon*e_moon) * sind(E_moon);

%convert this to distance and true anonaly
r_moon = sqrt( x_moon*x_moon + y_moon*y_moon ); %Earth radii
deltax=x_moon;          
deltay=y_moon;
if deltax>0 && deltay>0
    v_moon=(atan(deltay/deltax)*180/pi);
elseif deltax<0 && deltay>0
    v_moon=(atan(deltay/deltax)*180/pi)+180;
elseif deltax<0&& deltay<0
    v_moon=(atan(deltay/deltax)*180/pi)+180;
elseif deltax>0 && deltay<0
    v_moon=(atan(deltay/deltax)*180/pi)+360;
end


xeclip_moon = r_moon * ( cosd(N_moon) * cosd(v_moon+w_moon) - sind(N_moon) * sind(v_moon+w_moon) * cosd(i_moon) );
yeclip_moon = r_moon * ( sind(N_moon) * cosd(v_moon+w_moon) + cosd(N_moon) * sind(v_moon+w_moon) * cosd(i_moon) );
zeclip_moon = r_moon * sind(v_moon+w_moon) * sind(i_moon);

deltax=xeclip_moon;          
deltay=yeclip_moon;
if deltax>0 && deltay>0
    lon_moon_0=(atan(deltay/deltax)*180/pi);
elseif deltax<0 && deltay>0
    lon_moon_0=(atan(deltay/deltax)*180/pi)+180;
elseif deltax<0&& deltay<0
    lon_moon_0=(atan(deltay/deltax)*180/pi)+180;
elseif deltax>0 && deltay<0
    lon_moon_0=(atan(deltay/deltax)*180/pi)+360;
end

lat_moon_0  =  atan2d( zeclip_moon, sqrt( xeclip_moon*xeclip_moon + yeclip_moon*yeclip_moon ) );
r_moon_0  =  sqrt( xeclip_moon*xeclip_moon + yeclip_moon*yeclip_moon + zeclip_moon*zeclip_moon );



%Moon's mean longitude:        
Lm  =  N_moon + w_moon + M_moon; Lm=mod(Lm,360);
%Moon's mean elongation:       
D   =  Lm - L ;
%Moon's argument of latitude:  
F   =  Lm - N_moon;



%Perturbations in longitude (degrees):
lon1=-1.274 * sind(M_moon - 2*D) ;   %(Evection)
lon2= +0.658 * sind(2*D)  ;    %(Variation)
lon3=-0.186 * sind(M) ;         %(Yearly equation)
lon4=  -0.059 * sind(2*M_moon - 2*D);
lon5=   -0.057 * sind(M_moon - 2*D + M);
lon6=   +0.053 * sind(M_moon + 2*D);
lon7=   +0.046 * sind(2*D - M);
lon8=   +0.041 * sind(M_moon - M);
lon9=   -0.035 * sind(D)   ;         %(Parallactic equation)
lon10=   -0.031 * sind(M_moon + M);
lon11=  -0.015 * sind(2*F - 2*D);
lon12=  +0.011 * sind(M_moon - 4*D);
vlon=lon1+lon2+lon3+lon4+lon5+lon6+lon7+lon8+lon9+lon10+lon11+lon12;

%Perturbations in latitude (degrees):
lat1=    -0.173 * sind(F - 2*D);
lat2=    -0.055 * sind(M_moon - F - 2*D);
lat3=   -0.046 * sind(M_moon + F - 2*D);
lat4=    +0.033 * sind(F + 2*D);
 lat5=   +0.017 * sind(2*M_moon + F);
 vlat=lat1+lat2+lat3+lat4+lat5;
 %Perturbations in lunar distance (Earth radii):
dis1=    -0.58 * cosd(M_moon - 2*D);
dis2=   -0.46 * cosd(2*D);
vdis=dis1+dis2;

lon_moon=lon_moon_0+vlon;
lat_moon=lat_moon_0+vlat;
r_moon=(r_moon_0+vdis)*6378160;



xeclip_moon = r_moon * cosd(lon_moon) * cosd(lat_moon);
yeclip_moon = r_moon * sind(lon_moon) * cosd(lat_moon);
zeclip_moon = r_moon * sind(lat_moon);

xequat_moon =  xeclip_moon ;                                                  
yequat_moon = yeclip_moon * cosd(oblecl) - zeclip_moon  * sind(oblecl);
zequat_moon = yeclip_moon * sind(oblecl) + zeclip_moon * cosd(oblecl);

% JD=dtA.MJD+ 2400000.5; %from  modified Julian Day  to Julian Day
% GAST=JD2GAST(JD); % Greenwich Apparent Sidereal Time calculate
X_moon = (xequat_moon*cosd(GAST)+sind(GAST)*yequat_moon);
Y_moon = (yequat_moon*cosd(GAST)-sind(GAST)*xequat_moon)	;
Z_moon = (zequat_moon);
The_moon_pos=[X_moon;Y_moon;Z_moon]; %meters

end




