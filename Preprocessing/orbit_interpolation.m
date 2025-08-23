function orbit=orbit_interpolation(data,zaman,t,satname)


%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci


orbit.answer=1;
[~, sat_posi]=min(abs(t-zaman));


if t-zaman(sat_posi,1)<0
    sat_posi=sat_posi-1;
end



if satname>size(data{2,1},2) %%%23.09.2023 
    orbit.answer=0;

else

    sub_data=cell(1,size(data,2));
    if t>zaman(5,1) && t< zaman(length(zaman)-5,1)
        for s=1:size(data,2)
            for j=1:10 %9.degree Lagrange
                sub_data{1,s}(j,1)=data{2,s}((sat_posi-5+j),satname);
                %if s<4 && 
                if (data{2,s}((sat_posi-5+j),satname) == 0 || data{2,s}((sat_posi-5+j),satname)==999999.999999 || data{2,s}((sat_posi-5+j),satname)==999999999.999)
                    orbit.answer=0;

                end
            end
        end





    elseif t<zaman(5,1)
        sat_posi=5;

        for s=1:size(data,2)
            for j=1:10 %9.degree Lagrange
                sub_data{1,s}(j,1)=data{2,s}((sat_posi-5+j),satname);
                if data{2,s}((sat_posi-5+j),satname) == 0 || data{2,s}((sat_posi-5+j),satname)==999999.999999 || data{2,s}((sat_posi-5+j),satname)==999999999.999
                    orbit.answer=0;
                end
            end
        end


    elseif  t> zaman(length(zaman)-5,1)
        sat_posi=length(zaman)-10;
        for s=1:size(data,2)
            for j=1:10 %9.degree Lagrange
                sub_data{1,s}(j,1)=data{2,s}((sat_posi+j),satname);
                if data{2,s}((sat_posi-5+j),satname) == 0 || data{2,s}((sat_posi-5+j),satname)==999999.999999 || data{2,s}((sat_posi-5+j),satname)==999999999.999
                    orbit.answer=0;
                end
            end
        end
    end




    if   t>zaman(5,1) && t< zaman(length(zaman)-5,1)
        extract_time_pos=zaman((sat_posi-4:sat_posi+5),1);
        L=ones(length(extract_time_pos));
        for i=1:length(extract_time_pos)
            for j=1:length(extract_time_pos)
                if i~=j
                    L(i,:)=L(i,:)*((t-extract_time_pos(j,1))/(extract_time_pos(i,1)-extract_time_pos(j,1)));
                end
            end
        end


    elseif t<zaman(5,1)
        extract_time_pos=zaman((1:10),1);
        L=ones(length(extract_time_pos));
        for i=1:length(extract_time_pos)
            for j=1:length(extract_time_pos)
                if i~=j
                    L(i,:)=L(i,:)*((t-extract_time_pos(j,1))/(extract_time_pos(i,1)-extract_time_pos(j,1)));
                end
            end
        end


    elseif t> zaman(length(zaman)-5,1)
        extract_time_pos=zaman((length(zaman)-9):(length(zaman)),1);
        L=ones(length(extract_time_pos));
        for i=1:length(extract_time_pos)
            for j=1:length(extract_time_pos)
                if i~=j
                    L(i,:)=L(i,:)*((t-extract_time_pos(j,1))/(extract_time_pos(i,1)-extract_time_pos(j,1)));
                end
            end
        end
    end


    %'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    %Coordinates
    %'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    aradeger=zeros(length(extract_time_pos),1);
    coordinates=zeros(length(sub_data),1);


    for y=1:length(sub_data)
        for yyy=1:length(extract_time_pos)
            if isempty(sub_data{1,y}(yyy,1))
                sub_data{1,y}(yyy,1)=0;
            end
            aradeger(yyy,1)=(L(yyy,1)*sub_data{1,y}(yyy,1));
        end
        coordinates(y,1)=sum(aradeger);
    end




end



if orbit.answer==0
    coordinates=[0;0;0;0];
end
orbit.coordinates=coordinates;

end







