function y = amc(x,y,tstart,tfinish,N,M)
% -------------------------------------------------------------------------
% Function:
% Aggregation of Moving Clusters (AMC)
% Aim: 
% Compute the the surface bag area of moving clusters
% -------------------------------------------------------------------------
% Input: 
% x,y: fish locations (lon, lat), dimensions: (time, #individuals) 
% tstart,tfinish: initial and last timestamp
% N,M: dimension of SOM grid
% -------------------------------------------------------------------------
% Output: 
% Surface of bagplots over a time period
% -------------------------------------------------------------------------
% Example of use:
% load import_fish_tracks;
% bag_area = amc(fish_lon,fish_lat,1,30,3,2)
% plot(bag_area, '.-', 'MarkerSize', 24); 
% xlabel('Time'); ylabel('Surface of bag area')
% -------------------------------------------------------------------------
% References:
% Rousseeuw, P.J., Ruts, I., Tukey, J.W., 1999. The Bagplot: 
% A Bivariate Boxplot. Am. Stat. 53(4), 382-387.
% -------------------------------------------------------------------------
% Written by:
% Dimitris Politikos
% Hellenic Center for Marine Research (HCMR)
% April 2019
% dimpolit@hcmr.gr
% -------------------------------------------------------------------------
number_of_clusters = N * M;
pa = @polyarea;
bag_area = zeros(tfinish-tstart,1);

for itime = tstart:tfinish 
   string = sprintf('Time: %d\n', itime);
   disp(string)
   day = [x(:,itime) y(:,itime)];
   net=selforgmap([N M]);
   [net,tr] = train(net,day');
   y1 = net(day');
   classes = vec2ind(y1);
   totarea = 0; 
   for k = 1:number_of_clusters
      temp_class = (find(classes == k));
      class = day(temp_class,:);
      if (length(class)>10)
         bag = bagplot(class, 'datafence',0,'colorbag',[0 0.7 1], 'colorfence', ... 
         [0 0.51  1], 'databag', 0, 'plots', 0);
         k = find(bag.datatype==2);
         area = pa(class(k(:),1),class(k(:),2));
         if (area > 0)
            totarea = totarea + area;
         end
      end
   end
    bag_area(itime) = totarea;
end
y = bag_area;