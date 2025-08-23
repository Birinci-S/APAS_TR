
function [tro_prmtr,grid_control]=trop_Grid_Control(mjd,latitude,longitude,hellp,grid_control,Trop_Model,tro_prmtr)


%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci


prcs_mjd=floor(mjd);

interval=mjd-prcs_mjd;

if interval==0 && grid_control(1,1)==0
    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(1,1)=1;


elseif interval<0.25 && interval > 0 && grid_control(2,1)==0

    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(2,1)=1;

elseif interval==0.25 && grid_control(3,1)==0

    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(3,1)=1;

elseif  interval<0.5 && interval > 0.25  && grid_control(4,1)==0

    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(4,1)=1;

elseif interval==0.5 && grid_control(5,1)==0

    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(5,1)=1;
elseif  interval<0.75 && interval > 0.50 && grid_control(6,1)==0

    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(6,1)=1;

elseif interval==0.75 && grid_control(7,1)==0

    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(7 ,1)=1;
elseif interval > 0.75 && grid_control(8,1)==0

    [tro_prmtr]=trop_Option(Trop_Model,mjd , latitude*pi/180 , longitude*pi/180 , hellp , 40*pi/180);
    grid_control(8,1)=1;

end


end