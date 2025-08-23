

function NEU_plot(north_PPP,east_PPP,up_PPP,rnxtime)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

figure

hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;
plot(hours,north_PPP,'Color',[29/256,145/256,192/256],'LineWidth',1.5);
hold on
plot(hours,east_PPP,'Color',[254/256,178/256,72/256],'LineWidth',1.5);
plot(hours,up_PPP,'Color',[189/256,0,38/256],'LineWidth',1.5);
ylim([-0.5 0.5])
grid on
legend('North Error (m)','East Error (m)','Up Error (m)')
ylabel('Errors [m]')
xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
xlabel(xlabel_title)
title('North, East, and Up Errors');




end