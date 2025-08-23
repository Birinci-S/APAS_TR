function [fh,ph, th]=wait_bar_process(marker_name)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

maintext="PPP Processing  "+string(marker_name+" station");

fh = waitbar(0,'Progress','Name',maintext);


ax = axes(fh,'Position',[.1 .4 .8 .05],'box','on','xtick',[],'ytick',[],...
    'color',[0.50 0.95 0.75],'xlim',[0,1],'ylim',[0,1]); 

ph = patch(ax,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); 

th = text(ax,1.0,1.5,'0%','VerticalAlignment','bottom','HorizontalAlignment','right'); 

end


