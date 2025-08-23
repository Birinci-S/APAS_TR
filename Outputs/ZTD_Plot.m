
function ZTD_Plot(ZTD,ref_ZTD,int_ZTD,rnxtime)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


figure
hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;
plot(hours,ZTD,'Color',[2/256,129/256,138/256],'LineWidth',1.5);
grid on
legend('Zenith Tropospheric Delay (m)')
xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
xlabel(xlabel_title)
ylabel('ZTD (m)')
title('Zenith Tropospheric Delay-PPP');




if ~isempty(ref_ZTD) &&  any(~isnan(int_ZTD))
    figure
    hours_ref=(ref_ZTD(1:end-1,1)-ref_ZTD(1,1))*24;
    plot(hours_ref,ref_ZTD(1:end-1,2),'Color',[252/256,78/256,42/256],'LineWidth',1.5)
    hold on
    plot(hours_ref,int_ZTD,'Color',[54/256,144/256,92/256],'LineWidth',1.5)

    legend('Reference Troposphere','PPP Troposphere Results')
    grid on

    ylabel('ZTD (m)')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)
    title('Comparison of PPP ZTD solutions with reference ZTD values');


end

end