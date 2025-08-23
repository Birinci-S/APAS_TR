

function horizontal_Errors(east_PPP,north_PPP)


%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


figure
viscircles([0,0],0.10,'LineWidth',1.2,'Color',[65/256,191/256,73/256]);
hold on
plot(east_PPP,north_PPP,'diamond','LineWidth',0.90,'Color',[63/256,1/256,129/256])
ha = gca;
ha.XAxisLocation = 'origin';
ha.YAxisLocation = 'origin';
ylim([-.15 .15])
xlim([-.15 .15])
grid on
xlabel('East Errors (m)')
ylabel('North Errors (m)')
title('Horizantal Errors');

end
