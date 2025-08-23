function  dtA = date2GPS(dtA)

%date2GPS converts datum to GPS time and MJD
%dtA = date2GPS(dtA)
%dtA - object of type DateTime

%Written by Milan Horemuz, last modified 2004-11-01
% clc
% clear;
% format long g
% dtA.year=2020;
% dtA.month=2;
% dtA.day=8;
% dtA.hour=23;
% dtA.min=55;
% dtA.sec=0;

   y = dtA.year; 
   mo = dtA.month;
   if mo <= 2 
      y = y - 1; 
      mo = mo + 12;
  end
   a = 365.25*y;
   b = (mo+1)*30.6001;
   dh = dtA.hour + dtA.min/60 + dtA.sec/3600;  %hours in day
   jd = floor(a) + floor(b) + dtA.day + 1720981.5;  %+ dh/24  
   dtA.MJD = jd-2400000.5 + dh/24; 
   a = (jd - 2444244.5)/7;
   dtA.gweek = floor(a);
   wsec = (a - dtA.gweek)*7.*86400.;         % seconds of the week - not sufficient precision
   dtA.dweek = round(wsec/86400.);
   dtA.wsec = dtA.dweek*86400 + dh*3600;     % seconds of the week -  sufficient precision
