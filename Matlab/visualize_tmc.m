function visualize_tmc(centroids, sil, N, M, map_range)
% -------------------------------------------------------------------------
% Function:
% Visualising Tracking Moving Centroids (TMC)
% Aim: 
% Visualise the outputs of TMC function 
% -------------------------------------------------------------------------
% Input: 
% 1. centroids: centroids of clusters produced by "tmc" function
% 2. sil: silouette coefficients produced by "tmc" function
% 3. N,M: size of SOM grid
% 3. map_range (optional): range of model domain in [lon_min lon_max lat_min lat_max]
% -------------------------------------------------------------------------
% Outputs: 
% 1. Plots of centroids
% 2. Boxplots of silhouette coefficients 
% -------------------------------------------------------------------------
% Example of use:
% load import_fish_tracks;
% [centroids, sil] = tmc(fish_lon,fish_lat,1,20,3,2,[22 26.5 39 41.2]);
% [centroids, sil] = visualise_tmc(centroids, sil,2,3,[22 26.5 39 41.2]); % including map
% [centroids, sil] = visualise_tmc(centroids, sil,2,3); % without a map
% See also tmc.m for finding the centroids ploting the centroids
% The function is called after calling tmc.m function
% -------------------------------------------------------------------------
% References:
% [1] Rousseeuw P.J, 1987. "Silhouettes: a Graphical Aid to the Interpretation 
% and Validation of Cluster Analysis". Computational and Applied Mathematics 20, 53-65.
% [2] Politikos, D.V., Kleftogiannis, D., Tsiaras, K., Rose K. 2020. MovCLUFish: A data mining 
% tool for discovering novel fish movement patterns from individual-based models.

% Plot tmc results
% 1 - Plot of map and centroids
figure(1)
if exist('map_range','var')
% Map
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(gca, land, 'FaceColor', [0.5 0.5 0.5]);
box on
axis([map_range(1) map_range(2) map_range(3) map_range(4)]) 
end
set(gca, 'fontsize', 12)
title('Centroids - SOM', 'FontSize',14)
hold on

% Centroids and their medians
cols = {[0.7 0.7 0.7];
         [0.5 0.5 0];
         [0 0.5 0.5];};
linespec = {'c';'r';'g';'m';'y';'b';'k';cols{1};cols{2};cols{3}};

for k=1:length(centroids)
   plot(centroids{k}{1},centroids{k}{2}, '.','Color',linespec{k});
   hold on
   plot(median(centroids{k}{1}), median(centroids{k}{2}), 'kx', ...
        'MarkerSize',10,'LineWidth',2)
end
x0 = 40; y0 = 40; width = 550; height = 300;
set(gcf,'units','points','position',[x0,y0,width,height]);

%2 - Shift of cluster centroids
figure(2)
% Plot map
if exist('map_range','var')
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(gca, land, 'FaceColor', [0.5 0.5 0.5]);
box on
axis([map_range(1) map_range(2) map_range(3) map_range(4)]) 
end
hold on
for k = 1:length(centroids)
   t0 = 1; 
   t1 = round(length(centroids{k}{1})/3);
   t2 = round(2*length(centroids{k}{1})/3);
   t3 = length(centroids{k}{1});
   if (t1>0)
       plot(mean(centroids{k}{1}(t0:t1)), mean(centroids{k}{2}(t0:t1)), '.', ...
       'MarkerSize', 10, 'Color', linespec{k});
       hold on
       plot(mean(centroids{k}{1}(t1:t2)), mean(centroids{k}{2}(t1:t2)), '.', ...
       'MarkerSize', 16, 'Color', linespec{k});
       hold on
       plot(mean(centroids{k}{1}(t2:t3)), mean(centroids{k}{2}(t2:t3)), '.', ...
       'MarkerSize', 20, 'Color', linespec{k});
       hold on
   end
end

x0 = 40; y0 = 40; width = 550; height = 300;
set(gcf,'units','points','position',[x0,y0,width,height]);
set(gca, 'fontsize', 12)
title('Mean centroids at first, second and third part of their lifetime', 'fontsize',14)

% 3 - Plot Silouette cofficients
figure(3)
boxplot(sil, 'Labels', [num2str(N) 'x' num2str(M)])
title('Silouette coefficient')
xlabel('Grid')
ylabel('Values')
set(gca, 'FontSize', 12)
