function [NMFdry,NMFwet,ZWD,ZHD]=NiellUNB(latitude,dayOfYear,elevation,h)

%pi=(0.31415926535897935601e01);
elevation=elevation*pi/180;
%h=150;
 
 sine=sin(elevation);  
if latitude < 0 
    dayOfYear=dayOfYear+(365.25/2); 
end

%===================================================================================
%hidrostatic component
ABC_avg_dry =[       15           30            45           60          75
               1.2769934e-3  1.2683230e-3 1.2465397e-3 1.2196049e-3 1.2045996e-3   %adry coefficient(average)
               2.9153695e-3  2.9152299e-3 2.9288445e-3 2.9022565e-3 2.9024912e-3   %bdry coefficient(average)
               62.610505e-3  62.837393e-3 63.721774e-3 63.824265e-3 64.258455e-3]; %cdry coefficient(average)
 
ABC_amp_dry =[        15           30            45           60          75
                      0     1.2709626e-5 2.6523662e-5 3.4000452e-5 4.1202191e-5    %adry coefficient(amplitude)
                      0     2.1414979e-5 3.0160779e-5 7.2562722e-5 11.723375e-5    %bdry coefficient(amplitude)
                      0     9.0128400e-5 4.3497037e-5 84.795348e-5 170.37206e-5];  %cdry coefficient(amplitude)
                  
                  
  %height correction
aht=2.53e-5; %a height coefficient  
bht=5.49e-3; %b height coefficient  
cht=1.14e-3; %c height coefficient       
%===================================================================================                

%===================================================================================
%non-hidrostatic(wet) component

ABC_wet =[       15           30            45           60          75
               5.8021897e-4  5.6794847e-4 5.8118019e-4 5.9727542e-4 6.1641693e-4   %awet coefficient
               1.4275268e-3  1.5138625e-3 1.4572752e-3 1.5007428e-3 1.7599082e-3   %bwet coefficient
               4.3472961e-2  4.6729510e-2 4.3908931e-2 4.4626982e-2 5.4736038e-2]; %cwet coefficient
 %===================================================================================
 %===================================================================================                
   
 latitude=abs(latitude);  
 if latitude <=15
     col=1;
     oran=0;
 elseif latitude >=75
     col =5;
     oran=0;
 else 
     col=ceil(latitude/15)-1;
    oran=(latitude-ABC_avg_dry(1,col))/(ABC_avg_dry(1,col+1)-ABC_avg_dry(1,col));
 end
  %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  %Calculate NMF hidrostatic component coefficent
 
  if oran==0
      Aavg_dry=ABC_avg_dry(2,col);
      Bavg_dry=ABC_avg_dry(3,col);
      Cavg_dry=ABC_avg_dry(4,col);
      
      Aamp_dry=ABC_amp_dry(2,col);
      Bamp_dry=ABC_amp_dry(3,col);
      Camp_dry=ABC_amp_dry(4,col) ;
      
  else
      Aavg_dry=ABC_avg_dry(2,col)+oran*(ABC_avg_dry(2,col+1)-ABC_avg_dry(2,col));
      Bavg_dry=ABC_avg_dry(3,col)+oran*(ABC_avg_dry(3,col+1)-ABC_avg_dry(3,col));
      Cavg_dry=ABC_avg_dry(4,col)+oran*(ABC_avg_dry(4,col+1)-ABC_avg_dry(4,col));
      
      Aamp_dry=ABC_amp_dry(2,col)+oran*(ABC_amp_dry(2,col+1)-ABC_amp_dry(2,col));
      Bamp_dry=ABC_amp_dry(3,col)+oran*(ABC_amp_dry(3,col+1)-ABC_amp_dry(3,col));
      Camp_dry=ABC_amp_dry(4,col)+oran*(ABC_amp_dry(4,col+1)-ABC_amp_dry(4,col));
  end

 Adry=Aavg_dry-Aamp_dry*cos(2*pi*((dayOfYear-28)/365.25));
 Bdry=Bavg_dry-Bamp_dry*cos(2*pi*((dayOfYear-28)/365.25));
 Cdry=Cavg_dry-Camp_dry*cos(2*pi*((dayOfYear-28)/365.25));
 %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 alfa_dry=((Adry/((Bdry/(sine+Cdry))+sine))+sine);
 gama_dry=(1+(Adry/(1+(Bdry/(1+Cdry)))));
 dry_component=gama_dry/alfa_dry;
 
 %hight correction 
 alfa_height=((aht/((bht/(sine+cht))+sine))+sine);
 gama_height=(1+(aht/(1+(bht/(1+cht)))));
 height_component1=gama_height/alfa_height;
 height_component=((1/sine)-height_component1)*h/1000;
 NMFdry=height_component+dry_component;
 
 
 
 %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 %Calculate NMF wet component coefficent

 if oran==0
     Awet=ABC_wet(2,col);
     Bwet=ABC_wet(3,col);
     Cwet=ABC_wet(4,col);
 else
     Awet=ABC_wet(2,col)+oran*(ABC_wet(2,col+1)-ABC_wet(2,col));
     Bwet=ABC_wet(3,col)+oran*(ABC_wet(3,col+1)-ABC_wet(3,col));
     Cwet=ABC_wet(4,col)+oran*(ABC_wet(4,col+1)-ABC_wet(4,col));
 end


 alfa_wet=((Awet/((Bwet/(sine+Cwet))+sine))+sine);
 gama_wet=(1+(Awet/(1+(Bwet/(1+Cwet)))));
 NMFwet=gama_wet/alfa_wet;
                  
                  
 
  
 % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
 % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
 %ZHD ve ZWD 
 
 
 
 UNB3_avg=[     15       30       45         60         75
            1013.25   1017.25   1015.75    1011.75    1013.00
            299.65    294.15    283.15     272.15     263.65
            75.0        80.0     76.0      77.5       82.5
            6.30      6.05      5.58       5.39       4.53
            2.77      3.15      2.57       1.81       1.55];
        
        
UNB3_amp=[     15       30       45         60         75
               0.99   -3.75     -2.25      -1.75     -0.50
               0.00    7.00     11.00      15.00     14.50
               0.00    0.00     -1.0       -2.5      2.5
               0.00    0.25     0.32       0.81       0.62
               0.00    0.33     0.46       0.74      0.30];
        
 % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
 % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
 % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  
  if oran==0
      P0_avg=UNB3_avg(2,col);
      T0_avg =UNB3_avg(3,col);
      e0_avg=UNB3_avg(4,col);
      beta_avg=UNB3_avg(5,col);
      lambda_avg=UNB3_avg(6,col);
      
      P0_amp=UNB3_amp(2,col);
      T0_amp =UNB3_amp(3,col);
      e0_amp=UNB3_amp(4,col);
      beta_amp=UNB3_amp(5,col);
      lambda_amp=UNB3_amp(6,col);
      
  else
      
      P0_avg=UNB3_avg(2,col)+oran*(UNB3_avg(2,col+1)-UNB3_avg(2,col));
      T0_avg =UNB3_avg(3,col)+oran*(UNB3_avg(3,col+1)-UNB3_avg(3,col));
      e0_avg=UNB3_avg(4,col)+oran*(UNB3_avg(4,col+1)-UNB3_avg(4,col));
      beta_avg=UNB3_avg(5,col)+oran*(UNB3_avg(5,col+1)-UNB3_avg(5,col));
      lambda_avg=UNB3_avg(6,col)+oran*(UNB3_avg(6,col+1)-UNB3_avg(6,col));
      
      P0_amp=UNB3_amp(2,col)+oran*(UNB3_amp(2,col+1)-UNB3_amp(2,col));
      T0_amp =UNB3_amp(3,col)+oran*(UNB3_amp(3,col+1)-UNB3_amp(3,col));
      e0_amp=UNB3_amp(4,col)+oran*(UNB3_amp(4,col+1)-UNB3_amp(4,col));
      beta_amp=UNB3_amp(5,col)+oran*(UNB3_amp(5,col+1)-UNB3_amp(5,col));
      lambda_amp=UNB3_amp(6,col)+oran*(UNB3_amp(6,col+1)-UNB3_amp(6,col));
                
  end              
                  
     P0=   P0_avg-  P0_amp*cos(2*pi*((dayOfYear-28)/365.25));   
     T0=   T0_avg-  T0_amp*cos(2*pi*((dayOfYear-28)/365.25));
     e0=   e0_avg-  e0_amp*cos(2*pi*((dayOfYear-28)/365.25));
     beta= beta_avg- beta_amp*cos(2*pi*((dayOfYear-28)/365.25));
     beta=beta/1000;
     lambda=lambda_avg-lambda_amp*cos(2*pi*((dayOfYear-28)/365.25));
     
     
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     gm=9.784*(1-0.00266*cosd(2*latitude)-0.00028*h/1000);
     g0=9.80665;
     K1     = 77.604;
     K2     = 64.79;
     K3     = 3.776e5;
     R      = 8314.34;
     MD     = 28.9644;
     MW     = 18.0152;
     RD     = R / MD;
     K2ussu = K2 - K1*(MW/MD);
     ZHD=(1.00e-6*K1*RD/gm)*P0*((1-(beta*h/T0))^(g0/RD/beta));
     Tm=T0*(1-(beta*RD/gm/(lambda+1)));
     ES=0.01*exp(1.2378847e-5*T0^2  -1.9121316e-2*T0 +33.93711047 -6.3431645e3*T0^-1);
     
     fw=1.00062 + 3.14e-6*P0+ 5.6e-7*(T0-273.15)^2;
     
     e0=(e0/100)*ES*fw;
     
     
     ZWD=1.00e-6*(Tm*K2ussu+K3)*RD/(gm*(lambda+1)-beta*RD)*(1-(beta*h/T0))^(((lambda+1)*g0/RD/beta)-1)*e0/T0;
   
    
end
     
     
     
                  
                  
                  