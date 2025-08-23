
function [freqL1, freqL2, lambdaL1, lambdaL2 ]= GLONASS_freq(satNum)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

lightSpeed=299792458;
f10=1602;
deltaf1 = 9/16;
f20=1246 ;
deltaf2 = 7/16;
%f5=115*10.23;


sats = [   1 ;-4 ; 5 ; 6 ;1 ;-4 ;5 ;6 ;-2 ;-7 ;0 ;-1 ;-2 ;-7 ;0 ;-1 ;4 ;-3 ;3 ;2 ;4 ;-3 ;3 ;2; 0 ;-6 ];

freqL1 = f10+ sats(satNum,1)*deltaf1;
freqL2 = f20+ sats(satNum,1)*deltaf2;
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

lambdaL1=lightSpeed/freqL1/1e6; 
lambdaL2=lightSpeed/freqL2/1e6; 


end
