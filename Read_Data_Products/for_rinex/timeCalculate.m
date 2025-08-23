function [dtA]= timeCalculate(dtA)
   
% dtA.year=2018;
% dtA.month=11;
% dtA.day=11;
% dtA.hour=10;
% dtA.min=10;
% dtA.sec=10;
dtA=date2GPS(dtA); 
   
   
   %computes day of year
%Written by Milan Horemuz 2005-03-04

% format long g
% dtA.year=2020;
% dtA.month=2;
% dtA.day=8;
% dtA.hour=23;
% dtA.min=55;
% dtA.sec=0;


%y = get(ep,'year');
dtA1.year=dtA.year;
dtA1.month=1;
dtA1.day=1;
dtA1.hour=0;
dtA1.min=0;
dtA1.sec=0;
dtA1=date2GPS(dtA1);
%ep0 = DateTime(ep.year,1,1,0,0,0);
%doy = floor(get(ep,'MJD') - get(ep0,'MJD'))+1;
ep.MJD=dtA.MJD;
ep0.MJD=dtA1.MJD;
ep.DOY = floor(ep.MJD - ep0.MJD) + 1;
dtA.doy = ep.DOY;

end
