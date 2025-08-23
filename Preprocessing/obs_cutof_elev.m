function [L1dataNew, L2dataNew, P1dataNew, P2dataNew,elev]=obs_cutof_elev(clockdata, clocktime, sp3data, sp3time,L1dataNew, L2dataNew, P1dataNew, P2dataNew,rnxzaman,recPosition1,elev_cut,system,satNum)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci




lightSpeed=299792458; %light speed

%%% calculate satellite elevation 
if ~isempty(L1dataNew)
    for p=1:size(L1dataNew,1)

        for r=1:size(L1dataNew{p,1},1)

            travel_time=(P1dataNew{p,1}(r,1)/lightSpeed);
            transmit_time =(rnxzaman(P1dataNew{p,1}(r,2),1)-travel_time);

            switch system
                case 1
                    GPSclock=clockdata.GPS_clkbias;
                    [clck_bias1, clk_answer]=clock_interpolation(GPSclock,clocktime,transmit_time,satNum);
                    transmit_time=transmit_time-clck_bias1;

                    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                   
                    GPSsp3=sp3data.GPS;
                    orbit = orbit_interpolation(GPSsp3,sp3time,transmit_time,satNum);


                case 2
                    GLONASSclock=clockdata.GLONASS_clkbias;
                    [clck_bias1, clk_answer]=clock_interpolation(GLONASSclock,clocktime,transmit_time,satNum);
                    transmit_time=transmit_time-clck_bias1;

                    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    GLONASSsp3=sp3data.GLONASS;
                    orbit = orbit_interpolation(GLONASSsp3,sp3time,transmit_time,satNum);


                case 3

                    GALILEOclock=clockdata.GALILEO_clkbias;
                    [clck_bias1, clk_answer]=clock_interpolation(GALILEOclock,clocktime,transmit_time,satNum);
                    transmit_time=transmit_time-clck_bias1;

                    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                   
                    GALILEOsp3=sp3data.GALILEO;
                    orbit = orbit_interpolation(GALILEOsp3,sp3time,transmit_time,satNum);

                case 4
                    BEIDOUclock=clockdata.BEIDOU_clkbias;
                    [clck_bias1, clk_answer]=clock_interpolation(BEIDOUclock,clocktime,transmit_time,satNum);
                    transmit_time=transmit_time-clck_bias1;

                    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                   
                    BEIDOUsp3=sp3data.BEIDOU;
                    orbit = orbit_interpolation(BEIDOUsp3,sp3time,transmit_time,satNum);

                case 5

                    QZSSclock=clockdata.QZSS_clkbias;
                    [clck_bias1, clk_answer]=clock_interpolation(QZSSclock,clocktime,transmit_time,satNum);
                    transmit_time=transmit_time-clck_bias1;

                    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  
                    QZSSsp3=sp3data.QZSS;
                    orbit = orbit_interpolation(QZSSsp3,sp3time,transmit_time,satNum);




            end

            if clk_answer==0 || orbit.answer==0
                elevation=-85; %for remove the satellite
            else

                [enlem,boylam,~]=xyz2eby(recPosition1);
                [elevation,  ~] = calElev(enlem,boylam,orbit.coordinates,recPosition1);
            end

            elev{p,1}(r,1)=elevation;

        end

        L1dataNew{p,1}(elev{p,1}<elev_cut,:)=[];
        L2dataNew{p,1}(elev{p,1}<elev_cut,:)=[];
        P1dataNew{p,1}(elev{p,1}<elev_cut,:)=[];
        P2dataNew{p,1}(elev{p,1}<elev_cut,:)=[];
        elev{p,1}(elev{p,1}<elev_cut,:)=[];

    end

end
