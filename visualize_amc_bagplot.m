function visualize_amc_bagplot(x,y,t,N,M,map_range)
% -------------------------------------------------------------------------
% Aim: 
% Visualize bagplots at specific timestamps
% -------------------------------------------------------------------------
% Input: 
% x,y: fish locations (lon, lat) with dimensions: (#individuals, time) 
% t: timestamps to visualize bagplots
% N,M: dimension of SOM grid
% map_range: range of model domain in [lon_min lon_max lat_min lat_max]
% -------------------------------------------------------------------------
% Output: 
% Plot of bagplots (bag and fence)
% -------------------------------------------------------------------------
% Example of use:
% load import_fish_tracks;
% visualize_amc_bagplot(fish_lon,fish_lat,10,3,2,[22 27 39 41.2])
% visualize_amc_bagplot(fish_lon,fish_lat,[1 10 20 100],3,2,[22 27 39 41.2])
% -------------------------------------------------------------------------
% References:
% Rousseeuw, P.J., Ruts, I., Tukey, J.W., 1999. The Bagplot: 
% A Bivariate Boxplot. Am. Stat. 53(4), 382-387.
% -------------------------------------------------------------------------
% Written by:
% Dimitrios Kleftogiannis
% Applied Mathematics and Computer Science Division - KAUST
% April 2019
% dimitrios.kleftogiannis@kaust.edu.sa
% -------------------------------------------------------------------------
j = 1;
number_of_clusters = N * M;
for itime = 1:length(t)  
   day_index = t(itime);
   string = sprintf('Time: %d\n', day_index); 
   disp(string) 
   day = [x(:,day_index) y(:,day_index)];
   net = selforgmap([N M]);
   [net,tr] = train(net,day');
   y1 = net(day');
   classes = vec2ind(y1);    
   
   figure(itime);
   for k = 1:number_of_clusters
      temp_class = (find(classes == k));
      class = day(temp_class,:);
      % Plot bagplot
      if (length(class)>10)
         bagplot(class, 'datafence',0,'colorbag',[0 0.7 1], 'colorfence', ...
         [0 0.51  1], 'databag', 0, 'plots', 1);
         hold on
      end
   end 
   % plot_map  
   hold on
   land = shaperead('landareas', 'UseGeoCoords', true);
   geoshow(gca, land, 'FaceColor', [0.5 0.5 0.5]);
   box on
   axis([map_range(1) map_range(2) map_range(3) map_range(4)]) 
   str=sprintf('Time - %d', day_index); 
   title(str)
end