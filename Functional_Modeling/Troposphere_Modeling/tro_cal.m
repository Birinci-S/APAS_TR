function[ZHD, ZWD, MFH,MFW ]=tro_cal(tro_prmtr,mjd , lat , lon , h_ell , zd)


%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci
current_path=pwd;
s = what('Troposphere_Modeling');
tro_path=s.path;
%cd(tro_path);
indir_VMF1_grid=[tro_path '\VMF1_parameters'];
indir_VMF3_grid=[tro_path '\VMF3_parameters'];
indir_orography=[tro_path '\orography_ell'];


VMF3_grid_file=tro_prmtr.VMF3_grid_file;
VMF1_grid_file=tro_prmtr.VMF1_grid_file;
ZHD=tro_prmtr.ZHD;
ZWD=tro_prmtr.ZWD;
ah=tro_prmtr.ah;
aw=tro_prmtr.aw;
Trop_Model=tro_prmtr.Trop_Model;




if Trop_Model==1

    [ MFH , MFW , ZHD , ZWD , ~ ] = vmf3_grid ( indir_VMF3_grid, indir_orography , VMF3_grid_file , mjd , lat , lon , h_ell , zd , 1 );

elseif Trop_Model==2


    [MFH , MFW , ZHD , ZWD ,~] = vmf1_grid (indir_VMF1_grid,indir_orography,VMF1_grid_file,mjd,lat,lon,h_ell,zd);
elseif Trop_Model==3
    %  [ mfh , mfw ] = vmf3_ht ( ah , aw , mjd , lat , lon , h_ell , zd )
    [ MFH , MFW ] = vmf3_ht ( ah , aw , mjd , lat , lon  ,h_ell, zd );
elseif Trop_Model==4

    [MFH , MFW ] = vmf1_ht (ah,aw,mjd,lat,h_ell,zd);


end

%cd(current_path);
end