
function[combiProCont]= Combi_ProductContol(sp3data,combination)


%%% This function is a component of APAS-TR. 11.02.2024, S. Birinci


combiProCont=0;
GPSsp3=sp3data.GPS;
GLONASSsp3=sp3data.GLONASS;
GALILEOsp3=sp3data.GALILEO;
BEIDOUsp3=sp3data.BEIDOU;
QZSSsp3=sp3data.QZSS;

%G Control
if combination==1

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;

    end


    %GR Control
elseif combination==2

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(GLONASSsp3)
        msgbox('No GLONASS products in the sp3 File.')
        combiProCont=1;
    end



    %GE Control
elseif combination==3

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;
    elseif isempty(GALILEOsp3)
        msgbox('No Galileo products in the sp3 File.')
        combiProCont=1;
    end



    %GRE Control
elseif combination==4

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;
    elseif isempty(GLONASSsp3)
        msgbox('No GLONASS products in the sp3 File.')
        combiProCont=1;
    elseif isempty(GALILEOsp3)
        msgbox('No Galileo products in the sp3 File.')
        combiProCont=1;
    end





    %GREC2 Control
elseif combination==5

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(GLONASSsp3)
        msgbox('No GLONASS products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(GALILEOsp3)
        msgbox('No Galileo products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(BEIDOUsp3)
        msgbox('No BDS products in the sp3 File.')
        combiProCont=1;
    end



    %GREC3 Control
elseif combination==6

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(GLONASSsp3)
        msgbox('No GLONASS products in the sp3 File.')
        combiProCont=1;
    elseif isempty(GALILEOsp3)
        msgbox('No Galileo products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(BEIDOUsp3)
        msgbox('No BDS products in the sp3 File.')
        combiProCont=1;
    end



    %GREC2C3 Control
elseif combination==7

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;
    elseif isempty(GLONASSsp3)
        msgbox('No GLONASS products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(GALILEOsp3)
        msgbox('No Galileo products in the sp3 File.')
        combiProCont=1;
    elseif  isempty(BEIDOUsp3)
        msgbox('No BDS products in the sp3 File.')
        combiProCont=1;
    end



    %GREC2C3J Control
elseif combination==8

    if isempty(GPSsp3)
        msgbox('No GPS products in the sp3 File.')
        combiProCont=1;
    elseif combination==8 && isempty(GLONASSsp3)
        msgbox('No GLONASS products in the sp3 File.')
        combiProCont=1;
    elseif combination==8 && isempty(GALILEOsp3)
        msgbox('No Galileo products in the sp3 File.')
        combiProCont=1;
    elseif combination==8 && isempty(BEIDOUsp3)
        msgbox('No BDS products in the sp3 File.')
        combiProCont=1;
    elseif combination==8 && isempty(QZSSsp3)
        msgbox('No QZSS products in the sp3 File.')
        combiProCont=1;
    end



end
