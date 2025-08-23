

function GPS_clockOffset(output,rnxtime)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


figure
hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;
GPS_rec_Offset=output(:,8);
plot(hours,GPS_rec_Offset,'Color',[65/256,182/256,196/256],'LineWidth',1.5);
grid on
%legend('GPS Receiver Clock Offset (m)')
ylabel('Errors (m)')
xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
xlabel(xlabel_title)
title('GPS Receiver Clock Offset');


end