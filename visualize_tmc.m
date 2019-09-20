% -- Application of tmc function 
% load fish tracks data
load import_fish_tracks; % fish_lon & fish_lat
% Time
t_init = 1; t_end = 100;
% SOM grid
N = 3; M = 2;
% map range
map_range = [22.4 27 39.7 41.1];

% Call tmc function
[centroids, sil] = tmc(fish_lon,fish_lat,t_init,t_end,N,M,map_range);

% Plot tmc results
% 1 - Plot of map and centroids
figure(1)
% Map
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(gca, land, 'FaceColor', [0.5 0.5 0.5]);
box on
axis([map_range(1) map_range(2) map_range(3) map_range(4)]) 
title('Centroids - SOM', 'FontSize',14)
hold on

% Centroids and their medians
cols = {[0.7 0.7 0.7];
         [0.5 0.5 0];
         [0 0.5 0.5];};
linespec = {'c';'r';'g';'m';'y';'b';'k';cols{1};cols{2};cols{3}};

for k=1:number_of_centroids
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
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(gca, land, 'FaceColor', [0.5 0.5 0.5]);
box on
axis([map_range(1) map_range(2) map_range(3) map_range(4)]) 
hold on
for k = 1:number_of_centroids
   t0 = 1; 
   t1 = round(length(centroids{k}{1})/3);
   t2 = round(2*length(centroids{k}{1})/3);
   t3 = length(centroids{k}{1});
   if (t1>0)
       plot(mean(centroids{k}{1}(t0:t1)), mean(centroids{k}{2}(t0:t1)), '.', ...
       'MarkerSize', 12, 'Color', linespec{k});
       hold on
       plot(mean(centroids{k}{1}(t1:t2)), mean(centroids{k}{2}(t1:t2)), '.', ...
       'MarkerSize', 18, 'Color', linespec{k});
       hold on
       plot(mean(centroids{k}{1}(t2:t3)), mean(centroids{k}{2}(t2:t3)), '.', ...
       'MarkerSize', 24, 'Color', linespec{k});
       hold on
   end
end
x0 = 40; y0 = 40; width = 550; height = 300;
set(gcf,'units','points','position',[x0,y0,width,height]);

% 3 - Silouette cofficients
figure(3)
boxplot(sil, 'Labels', [num2str(N) 'x' num2str(M)])
title('Silouette coefficient')
xlabel('Grid')
ylabel('Values')
set(gca, 'FontSize', 14)
