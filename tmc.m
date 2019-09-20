function [centroids, sil] = tmc(x,y,tstart,tfinish,N,M,map_range)
% -------------------------------------------------------------------------
% Function:
% Tracking Moving Centroids (TMC)
% Aim: 
% Centroid clustering of individuals with SOM and visualization of their shift 
% -------------------------------------------------------------------------
% Input: 
% x,y: fish locations (lon, lat) with dimensions: (#individuals, time) 
% tstart,tfinish: initial and last timestamp of processing time
% N,M: dimension of SOM grid
% map_range: range of model domain in [lon_min lon_max lat_min lat_max]
% -------------------------------------------------------------------------
% Outputs: 
% 1. centroids: centroids of clusters
% 2. sil: silouette coefficients 
% -------------------------------------------------------------------------
% Example of use:
% [centroids, sil] = tmc(x,y,1,20,3,2,[22 26.5 39 41.2]);
% See also visualize_tcm.m example for ploting the centroids
% -------------------------------------------------------------------------
% References:
% [1] Rousseeuw P.J, 1987. "Silhouettes: a Graphical Aid to the Interpretation 
% and Validation of Cluster Analysis". Computational and Applied 
% Mathematics 20, 53-65.
% [2] https://www.mathworks.com/help/deeplearning/gs/cluster-data-with-a-self-organizing-map.html
% -------------------------------------------------------------------------
% Written by:
% Dimitrios Kleftogiannis
% Applied Mathematics and Computer Science Division - KAUST
% April 2019
% dimitrios.kleftogiannis@kaust.edu.sa
% -------------------------------------------------------------------------
number_of_clusters = N * M;
j = 1;
string = sprintf('Processing time:  %d - %d', tstart,tfinish); 
disp(string)
% Calculate Silhouette coeffificient on consecutive timestamps
sil_time = zeros(tfinish,1);

% Discover clusters on consecutive timestamps
for itime = tstart:tfinish
   string = sprintf('Time: %d\n',itime); 
   disp(string) 
   day = [x(:,itime) y(:,itime)];
   net = selforgmap([N M]);
   [net,tr]  =  train(net,day');
   y1  =  net(day');
   classes  =  vec2ind(y1);
   SILH = silhouette(day,classes);
   SILAV = mean(grpstats(SILH,classes));
   sil_time(itime) = SILAV;
   
% retrieve the cluster centroids and store them in a seperate matrix
   class_centers = zeros(number_of_clusters,2);    
   for k = 1:number_of_clusters
      temp_class = (find(classes == k));
      temp = day(temp_class,:);
      class_centers(k,1) = median(temp(:,1));
      class_centers(k,2) = median(temp(:,2));
      % Produced centroids
      all_ctrs(j+k-1,:) = class_centers(k,:);
   end
   j = j+6;
end % end of for loop

%%%%%%  Perform centroids clustering %%%%%%%%%%
% Remove centroids with NaNs
all_ctrs(any(isnan(all_ctrs),2),:) = [];

% Apply SOM on centroids
net = selforgmap([N M]); 
[net,tr]  =  train(net,all_ctrs');
y1  =  net(all_ctrs');
cidxC  =  vec2ind(y1);
ctrsC = zeros(number_of_clusters,2);

% Compute the centers of each cluster
clusters = cell(number_of_clusters,1);
for k = 1:number_of_clusters
   temp_class = (find(cidxC == k));
   temp = all_ctrs(temp_class,:);
   clusters{k} = {temp(:,1), temp(:,2)};  
end;

% Outputs
centroids = clusters;
sil = sil_time;

