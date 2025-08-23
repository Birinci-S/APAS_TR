function  deltarel=rel_Effect(rsat,vsat)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

c=299792458 ;%m/s
deltarel=-2*((dot(rsat,vsat))/c^2);

end