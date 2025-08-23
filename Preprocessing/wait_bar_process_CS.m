function [fh,ph, th]=wait_bar_process_CS(system)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci




if system==1
    nameCS='Cycle Slip Detection and Repair for GPS Satellites';
elseif system==2
    nameCS='Cycle Slip Detection and Repair for GLONASS Satellites ';
elseif system==3
    nameCS='Cycle Slip Detection and Repair for Galileo Satellites '  ;
elseif system==4
    nameCS='Cycle Slip Detection and Repair for BDS Satellites ';
elseif system==5
    nameCS='Cycle Slip Detection and Repair for QZSS Satellites ';

end
% Set up the progress bar axis
fh = waitbar(0,nameCS,'Name','');


ax = axes(fh,'Position',[.1 .4 .8 .05],'box','on','xtick',[],'ytick',[],...
    'color',[0.50 0.95 0.75],'xlim',[0,1],'ylim',[0,1]); %gray94
%title(ax,'Progress')
% Create empty patch that will be updated
ph = patch(ax,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); %greenyellow
% Create the percent-complete text that will be updated
th = text(ax,0.98,8,'0%','VerticalAlignment','bottom','HorizontalAlignment','right');

end

