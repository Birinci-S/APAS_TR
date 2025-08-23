function [pco]=Antex_PCO(rec_pco,satElevation,satAzimuth,satNum,system)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

satElevation=90-satElevation;


satir=ceil(satAzimuth/5);
sutun=ceil(satElevation/5);

rec_pco{1,2}(:,1)=[];
rec_pco{2,2}(:,1)=[];



for ss=1:2
    satirval1=rec_pco{ss,2}(satir,sutun)+(satAzimuth-5*(satir-1))*(rec_pco{ss,2}(satir+1,sutun)-rec_pco{ss,2}(satir,sutun))/5;
    satirval2=rec_pco{ss,2}(satir,sutun+1)+(satAzimuth-5*(satir-1))*(rec_pco{ss,2}(satir+1,sutun+1)-rec_pco{ss,2}(satir,sutun+1))/5;



    values(ss,1)=satirval1+(satElevation-5*(sutun-1))/5*(satirval2-satirval1);

end


[pco]=iono_free_obs (values(1,1),values(2,1),satNum,system);
end