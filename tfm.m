function [mob mobr mobl] = tfm(index,x,y,tstart,tfinish,N,M,map_range)
% -------------------------------------------------------------------------
% Aim: 
% Tracking of fish mobility between moving clusters
% -------------------------------------------------------------------------
% Inputs:
% index: the studied class; index takes values from 1 to 
% number_of_clusters. Should be <= N * M
% x,y: fish locations (lon, lat) with dimensions: (#individuals, time) 
% tstart,tfinish: initial and last timestamp of processing time
% N,M: dimension of SOM grid
% map_range: range of model domain in [lon_min lon_max lat_min lat_max]
% -------------------------------------------------------------------------
% Output: 
% mob: matrix presenting the number of individuals in the index cluster and
% surrounding clusters for each timestamp of processing time
% mobr: average proportion of individuals moving to suurounding clusters  
% to the right side
% mobl: average proportion of individuals moving to surrounding clusters 
% to the left side
% -------------------------------------------------------------------------
% Example of use:
% load import_fish_tracks;
% [mob, mov_right, mov_left] = tfm(3,fish_lon,fish_lat,1,20,3,2,[22 27 39 41.2]);
% -------------------------------------------------------------------------
% References:
% https://www.mathworks.com/help/deeplearning/gs/cluster-data-with-a-self-organizing-map.html
% -------------------------------------------------------------------------
% Written by:
% Dimitrios Kleftogiannis
% Applied Mathematics and Computer Science Division - KAUST
% April 2019
% dimitrios.kleftogiannis@kaust.edu.sa
% -------------------------------------------------------------------------
uright = 0; uleft = 0;
% Individuals at time tstart
init = [x(:,tstart) y(:,tstart)];
out_neig = []; 
out_right = []; 
out_left = [];
% Run SOM algorithm
net = selforgmap([N M]);
[net,tr] = train(net,init');
net_init = net(init');
cidx = vec2ind(net_init);
number_of_clusters = max(cidx);

% Here is the cluster tetsted for its mobility to other clusters
study_class = (find(cidx == index));
study_class_plot = init(find(cidx == index),:);

class_size = size(study_class,2);
% Helpful screen messages
string = sprintf('Number of clusters: %d\n', number_of_clusters); 
disp(string)
string = sprintf('Studied class has %d individuals \n', class_size); 
disp(string)
string = sprintf('Initial plot of studied class'); 
disp(string)

% Find the centroid of studied class
ctrs(index,1) = mean(study_class_plot(:,1));
ctrs(index,2) = mean(study_class_plot(:,2));
%xc = ctrs(index,1);
%yc = ctrs(index,2);

% Plot the studied class
figure(1)
scatter(study_class_plot(:,1),study_class_plot(:,2),'b.')
hold on
plot(ctrs(index,1),ctrs(index,2),'kx','MarkerSize',10,'LineWidth',2)
hold on
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(gca, land, 'FaceColor', [0.5 0.5 0.5]);
box on
axis([map_range(1) map_range(2) map_range(3) map_range(4)]) 
x0 = 20; y0 = 80; width = 550; height = 300;
set(gcf,'units','points','position',[x0,y0,width,height]);
title('Studied class')
color = char('b.','g.','m.','c.','k.','r.','y.','g.');

% Update clusters
figure(2)
for itime = tstart:tfinish
   land = shaperead('landareas', 'UseGeoCoords', true);
   geoshow(gca, land, 'FaceColor', [0.5 0.5 0.5])
   box on
   axis([map_range(1) map_range(2) map_range(3) map_range(4)]) 
   x0 = 80; y0 = 80; width = 550; height = 300;
   set(gcf,'units','points','position',[x0,y0,width,height]);
   set(gca, 'FontSize', 14)
   hold on 
   str=sprintf('Time - %d', itime); 
   title(str)
   fish_timestamp = [x(:,itime) y(:,itime)]; 
   net = selforgmap([N M]);
   [net,tr] = train(net,fish_timestamp');
   net_timestamp = net(fish_timestamp');
   cidx = vec2ind(net_timestamp);
   num_clusters = max(cidx);
   
   % Compute distance of cluster centroids
   centroid_dist = zeros(num_clusters,1);
   for j = 1:num_clusters
      temp = (find(cidx == j));
      class = fish_timestamp(temp,:);
      ctrsD(j,1) = mean(class(:,1));
      ctrsD(j,2) = mean(class(:,2));  
      centroid_dist(j) = sqrt((ctrsD(j,1) - ctrs(index,1))^2 + ...
                        (ctrsD(j,2) - ctrs(index,2))^2);
   end
   mind = min(centroid_dist);
     
   for  j = 1:num_clusters
      if (mind == centroid_dist(j))
         xc = ctrsD(j,1); 
         yc = ctrsD(j,2); 
         locj = j;
      end
   end
   string = sprintf('Time: %d\n',itime); 
   disp(string)   
   %out = locj;
   out = [];
   outR = [];
   outL = [];
     
   for j = 1:num_clusters
      temp = (find(cidx == j));
      C = intersect(study_class,temp);
      temp_plot = fish_timestamp(C,:);
      ctrs(j,1) = mean(temp_plot(:,1));
      ctrs(j,2) = mean(temp_plot(:,2));   
      if (j == locj)
         xcloc = ctrs(j,1);
         ycloc = ctrs(j,2);
      end
   end
   
   for j = 1:num_clusters
      jright = 0;
      jleft = 0;
      temp = (find(cidx == j));
      C = intersect(study_class,temp);
      temp_plot = fish_timestamp(C,:);
      plot(temp_plot(:,1),temp_plot(:,2),'.','Color',color(j,1));
      hold on
   if (j ~= locj)
      if (ctrs(j,1) > xcloc)
         jright = j; 
      end    
      if (ctrs(j,1) < xcloc & ctrs(j,1) > 0)
         jleft = j; 
      end    
   end
   out = [out size(C,2)];
   outR = [outR jright];
   outL = [outL jleft];
   if (j == num_clusters)
      if (num_clusters == 1)
         out_neig = [out_neig; out 0 0 0 0 0 0 0 0 0];
         out_right = [out_right; outR 0 0 0 0 0 0 0 0 0];
         out_left = [out_left; outL 0 0 0 0 0 0 0 0 0];
      elseif (num_clusters == 2)
          out_neig = [out_neig; out 0 0 0 0 0 0 0 0];
          out_right = [out_right; outR 0 0 0 0 0 0 0 0];
          out_left = [out_left; outL 0 0 0 0 0 0 0 0];
      elseif (num_clusters == 3)
          out_neig = [out_neig; out 0 0 0 0 0 0 0];
          out_right = [out_right; outR 0 0 0 0 0 0 0];
          out_left = [out_left; outL 0 0 0 0 0 0 0];
      elseif (num_clusters == 4)
          out_neig = [out_neig; out 0 0 0 0 0 0];
          out_right = [out_right; outR 0 0 0 0 0 0];
          out_left = [out_left; outL 0 0 0 0 0 0];
      elseif (num_clusters == 5)
          out_neig = [out_neig; out 0 0 0 0 0]
          out_right = [out_right; outR 0 0 0 0 0];
          out_left = [out_left; outL 0 0 0 0 0];
      elseif (num_clusters == 6)
          out_neig = [out_neig; out 0 0 0 0];
          out_right = [out_right; outR 0 0 0 0];
          out_left = [out_left; outL 0 0 0 0];
      elseif (num_clusters == 7)
          out_neig = [out_neig; out 0 0 0];
          out_right = [out_right; outR 0 0 0];
          out_left = [out_left; outL 0 0 0];
      elseif (num_clusters == 8)
          out_neig = [out_neig; out 0 0];
          out_right = [out_right; outR 0 0];
          out_left = [out_left; outL 0 0];
      elseif (num_clusters == 9)
          out_neig = [out_neig; out 0];
          out_right = [out_right; outR 0];
          out_left = [out_left; outL 0];
      elseif (num_clusters == 10)
          out_neig = [out_neig; out];
          out_right = [out_right; outR];
          out_left = [out_left; outL];
      else
          display('Warning: You have more than 10 clusters')      
      end
   end 
 end
   pause(0.1)
   clf;
end
k = find(out_neig(1,:)>0 & out_right(1,:)==0);
mleft = find(out_neig(2,:)>0 & out_left(2,:)>0);
mright = find(out_neig(2,:)>0 & out_right(2,:)>0);

if (length(mleft)>0)
uleft = zeros(length(mleft));
   for i=1:length(mleft)
      for j=1:(tfinish-tstart+1)  
         uleft(i) = uleft(i) + 1 - (out_neig(j,k) - out_neig(j,mleft(i))) / out_neig(j,k);
      end
   end
uleft = uleft / (tfinish-tstart+1);   
end

if (length(mright)>0)
uright = zeros(length(mright));
   for i=1:length(mright)
      for j=1:(tfinish-tstart+1)  
         uright(i) = uright(i) + 1 - (out_neig(j,k)- out_neig(j,mright(i))) / out_neig(j,k);
      end
   end
uright = uright / (tfinish-tstart+1);   
end
close all;
mob = out_neig; mobr = uright; mobl = uleft;