

function [tro_prmtr]=trop_Option(Trop_Model,mjd , lat , lon , h_ell , zd)


%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci


VMF3_grid_file=[]; VMF1_grid_file=[]; ZHD=[]; ZWD=[];ah=[];aw=[];p=[];e=[];la=[];
s = what('Troposphere_Modeling');
tro_path=s.path;
indir_VMF1_grid=[tro_path '\VMF1_parameters'];
indir_VMF3_grid=[tro_path '\VMF3_parameters'];
indir_orography=[tro_path '\orography_ell'];


if Trop_Model==1
    [ ~ , ~ , ZHD , ZWD , VMF3_grid_file ] = vmf3_grid ( indir_VMF3_grid, indir_orography , [] , mjd , lat , lon , h_ell , zd , 1 );

elseif Trop_Model==2


    [~,~,ZHD , ZWD,VMF1_grid_file] = vmf1_grid (indir_VMF1_grid,indir_orography,[],mjd,lat,lon,h_ell,zd);


elseif Trop_Model==3
    [gpt3_grid] = gpt3_1_fast_readGrid;
    [p,~,~,Tm,e,ah,aw,la,~,~,~,~,~] = gpt3_1_fast (mjd,lat,lon,h_ell,1,gpt3_grid);

    [ZHD] = saasthyd (p,lat,h_ell);

    [ZWD] = asknewet (e,Tm,la);

elseif Trop_Model==4

    [p,~,~,Tm,e,ah,aw,la,~] = gpt2_1w (mjd,lat,lon,h_ell,1,1);
    [ZHD] = saasthyd (p,lat,h_ell);
    [ZWD] = asknewet (e,Tm,la);

elseif Trop_Model==5

end






tro_prmtr.VMF3_grid_file=VMF3_grid_file;
tro_prmtr.VMF1_grid_file=VMF1_grid_file;
tro_prmtr.ZHD=ZHD;
tro_prmtr.ZWD=ZWD;
tro_prmtr.ah=ah;
tro_prmtr.aw=aw;
tro_prmtr.Trop_Model=Trop_Model;
end