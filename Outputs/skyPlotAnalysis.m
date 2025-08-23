
function skyPlotAnalysis(combination,GPS_output,GLO_output,GAL_output,BDS2_output,BDS3_output,QZSS_output)


%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


if combination <9



    n_sat = size(GPS_output.azimut,2); % number of satellites
    n_pts = size(GPS_output.azimut,1); % number of points per satellite
    azimuth=GPS_output.azimut;
    elevation=GPS_output.elevation;





    g = categorical(repmat(1:n_sat,n_pts,1));

    prn = repmat({''},n_pts,n_sat);
    % only first row is non-empty
    prn(1,:) = sprintfc('G%d',1:n_sat);


    rem_sat=[]; sayacG=1;
    for i=1:n_sat
        if isempty(find(elevation(:,i)>0, 1))
            rem_sat(sayacG,1)=i;
            sayacG=sayacG+1;
        end
    end

    elevation(:,rem_sat)=[];
    azimuth(:,rem_sat)=[];
    prn(:,rem_sat)=[];
    g(:,rem_sat)=[];

    figure
    Colors= distinguishable_colors(size(elevation,2)) ;
    h=skyplot(azimuth(:), elevation(:),'ColorOrder',Colors, MarkerSize=0.5,LabelFontSize=12,GroupData=g(:));
    legend(prn(1,:)) % don't need the legend if you have labels
    title('Skyplot of GPS Satellites');

end







if combination ==2 || (combination>=4 && combination<=8)



    n_sat = size(GLO_output.azimut,2); % number of satellites
    n_pts = size(GLO_output.azimut,1); % number of points per satellite
    azimuth=GLO_output.azimut;
    elevation=GLO_output.elevation;


    g = categorical(repmat(1:n_sat,n_pts,1));

    prn = repmat({''},n_pts,n_sat);
    % only first row is non-empty
    prn(1,:) = sprintfc('R%d',1:n_sat);


    rem_sat=[]; sayacR=1;
    for i=1:n_sat
        if isempty(find(elevation(:,i)>0, 1))
            rem_sat(sayacR,1)=i;
            sayacR=sayacR+1;
        end
    end

    elevation(:,rem_sat)=[];
    azimuth(:,rem_sat)=[];
    prn(:,rem_sat)=[];
    g(:,rem_sat)=[];

    figure
    Colors= distinguishable_colors(size(elevation,2)) ;
    h=skyplot(azimuth(:), elevation(:),'ColorOrder',Colors, MarkerSize=0.5,LabelFontSize=12,GroupData=g(:));
    legend(prn(1,:)) % don't need the legend if you have labels
    title('Skyplot of GLONASS Satellites');



end









if combination >2
    n_sat = size(GAL_output.azimut,2); % number of satellites
    n_pts = size(GAL_output.azimut,1); % number of points per satellite
    azimuth=GAL_output.azimut;
    elevation=GAL_output.elevation;


    g = categorical(repmat(1:n_sat,n_pts,1));

    prn = repmat({''},n_pts,n_sat);
    % only first row is non-empty
    prn(1,:) = sprintfc('E%d',1:n_sat);


    rem_sat=[]; sayacE=1;
    for i=1:n_sat
        if isempty(find(elevation(:,i)>0, 1))
            rem_sat(sayacE,1)=i;
            sayacE=sayacE+1;
        end
    end

    elevation(:,rem_sat)=[];
    azimuth(:,rem_sat)=[];
    prn(:,rem_sat)=[];
    g(:,rem_sat)=[];

    figure
    Colors= distinguishable_colors(size(elevation,2)) ;
    h=skyplot(azimuth(:), elevation(:),'ColorOrder',Colors, MarkerSize=0.5,LabelFontSize=12,GroupData=g(:));
    legend(prn(1,:)) % don't need the legend if you have labels
    title('Skyplot of Galileo Satellites');

end







if combination==5 || combination==7 || combination==8




    n_sat = size(BDS2_output.azimut,2); % number of satellites
    n_pts = size(BDS2_output.azimut,1); % number of points per satellite
    azimuth=BDS2_output.azimut;
    elevation=BDS2_output.elevation;


    g = categorical(repmat(1:n_sat,n_pts,1));

    prn = repmat({''},n_pts,n_sat);
    % only first row is non-empty
    prn(1,:) = sprintfc('C2-%d',1:n_sat);


    rem_sat=[]; sayacC2=1;
    for i=1:n_sat
        if isempty(find(elevation(:,i)>0, 1))
            rem_sat(sayacC2,1)=i;
            sayacC2=sayacC2+1;
        end
    end

    elevation(:,rem_sat)=[];
    azimuth(:,rem_sat)=[];
    prn(:,rem_sat)=[];
    g(:,rem_sat)=[];

    figure
    Colors= distinguishable_colors(size(elevation,2)) ;
    h=skyplot(azimuth(:), elevation(:),'ColorOrder',Colors, MarkerSize=0.5,LabelFontSize=12,GroupData=g(:));
    legend(prn(1,:)) % don't need the legend if you have labels
    title('Skyplot of BDS-2 Satellites');


end





if combination>5



    n_sat = size(BDS3_output.azimut,2); % number of satellites
    n_pts = size(BDS3_output.azimut,1); % number of points per satellite
    azimuth=BDS3_output.azimut;
    elevation=BDS3_output.elevation;


    g = categorical(repmat(1:n_sat,n_pts,1));

    prn = repmat({''},n_pts,n_sat);
    % only first row is non-empty
    prn(1,:) = sprintfc('C3-%d',1:n_sat);


    rem_sat=[]; sayacC3=1;
    for i=1:n_sat
        if isempty(find(elevation(:,i)>0, 1))
            rem_sat(sayacC3,1)=i;
            sayacC3=sayacC3+1;
        end
    end

    elevation(:,rem_sat)=[];
    azimuth(:,rem_sat)=[];
    prn(:,rem_sat)=[];
    g(:,rem_sat)=[];

    figure
    Colors= distinguishable_colors(size(elevation,2)) ;
    h=skyplot(azimuth(:), elevation(:),'ColorOrder',Colors, MarkerSize=0.5,LabelFontSize=12,GroupData=g(:));
    legend(prn(1,:)) % don't need the legend if you have labels
    title('Skyplot of BDS-3 Satellites');


end





if combination>7
    n_sat = size(QZSS_output.azimut,2); % number of satellites
    n_pts = size(QZSS_output.azimut,1); % number of points per satellite
    azimuth=QZSS_output.azimut;
    elevation=QZSS_output.elevation;


    g = categorical(repmat(1:n_sat,n_pts,1));

    prn = repmat({''},n_pts,n_sat);
    % only first row is non-empty
    prn(1,:) = sprintfc('J-%d',1:n_sat);


    rem_sat=[]; sayacJ=1;
    for i=1:n_sat
        if isempty(find(elevation(:,i)>0, 1))
            rem_sat(sayacJ,1)=i;
            sayacJ=sayacJ+1;
        end
    end

    elevation(:,rem_sat)=[];
    azimuth(:,rem_sat)=[];
    prn(:,rem_sat)=[];
    g(:,rem_sat)=[];

    figure
    Colors= distinguishable_colors(size(elevation,2)) ;
    h=skyplot(azimuth(:), elevation(:),'ColorOrder',Colors, MarkerSize=0.5,LabelFontSize=12,GroupData=g(:));
    legend(prn(1,:)) % don't need the legend if you have labels
    title('Skyplot of QZSS Satellites');


end




end