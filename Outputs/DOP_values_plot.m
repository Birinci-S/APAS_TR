function DOP_values_plot(combination,DOP_values,rnxtime)


%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


GDOP=DOP_values(:,1);
PDOP=DOP_values(:,2);
hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;

figure
plot(hours,GDOP,'Color',[204/256,76/256,2/256],'LineWidth',1.5);
hold on
plot(hours,PDOP,'Color',[221/256,52/256,151/256],'LineWidth',1.5);

grid on
legend('GDOP Values', 'PDOP Values')
xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
xlabel(xlabel_title)
ylabel('DOP Values');


if combination==1

    title('DOP Values for G Combination')

elseif combination==2

    title('DOP Values for GR Combination')

elseif combination==3

    title('DOP Values for GE Combination')

elseif combination==4

    title('DOP Values for GRE Combination')

elseif combination==5

    title('DOP Values for GREC2 Combination')

elseif combination==6

    title('DOP Values for GREC3 Combination')

elseif combination==7

    title('DOP Values for GREC2C3 Combination')

elseif combination==8

    title('DOP Values for GREC2C3J Combination')
end



end
