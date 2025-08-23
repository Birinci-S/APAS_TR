function uyusumsuz= MADbasedOutlierDet(l_final,sigma)


%%% This function is a component of APAS-TR. 11.02.2024, S. Birinci

%l_final=sort(l_final)
med=median(l_final);
kontrol=abs(l_final-med);

% if median(kontrol)==0
%     MAD=1.2533*sum(kontrol)/size(l_final,1);
% else
%     MAD=1.4826*median(kontrol);
% end

MAD=sigma*1.4826*median(kontrol);
uyusumsuz=find(kontrol>MAD);
end