tmc <- function(x,y,tstart,tfinish,N,M){
# -------------------------------------------------------------------------
# Function:
# Tracking Moving Centroids (TMC)
# Aim: 
# Centroid clustering of fish tracks with SOM 
# -------------------------------------------------------------------------
# Input: 
# 1. x,y: fish locations (lon, lat) with dimensions: (#individuals, time) 
# 2. tstart,tfinish: initial and last timestamp of processing time
# 3. N,M: dimension of SOM grid
# -------------------------------------------------------------------------
# Outputs: 
# 1. centroids: centroids of clusters
# 2. sil: silouette coefficients 
# -------------------------------------------------------------------------
# Example of use:
# fish= readMat('import_fish_tracks.mat')
# fish_out = tmc(fish$fish.lon, fish$fish.lat, 1, 50, 3,2)
# See also visualize_tmc.r example for ploting the centroids and silhouette
# -------------------------------------------------------------------------
# References:
# [1] Rousseeuw P.J, 1987. "Silhouettes: a Graphical Aid to the Interpretation 
# and Validation of Cluster Analysis". Computational and Applied Mathematics 20, 53-65.
# [2] Politikos, D.V., Kleftogiannis, D., Tsiaras, K., Rose K. 2020. MovCLUFish: A data mining 
# tool for discovering novel fish movement patterns from individual-based models.
# -------------------------------------------------------------------------
# Written by:
# Dimitrios Politikos
# Helelnic Centre for Marine Research - HCMR
# October 2020
# dimpolit@hcmr.gr
# -------------------------------------------------------------------------
# Libraries
library(kohonen)
library(cluster)
  
number_of_clusters = N * M;
j = 1;

# Calculate Silhouette coeffificient on consecutive timestamps
time_duration = tfinish - tstart + 1
sil_time = numeric(time_duration);

# Store cluster centroids
all_ctrs = matrix(0,number_of_clusters*time_duration, 2)  

# Discover clusters on consecutive timestamps
for (itime in seq(tstart,tfinish)){
  print(paste("Time:", itime))
  
  day <- cbind(x[,itime], y[,itime])
  som.grid <- somgrid(xdim = N, ydim = M, topo = 'hexagonal', toroidal = T)
  som.model <- som(data.matrix(day), grid = som.grid)
  classes = som.model$unit.classif
  
  # compute silouhette coefficient  
  sil_day <- silhouette(classes, dist(data.matrix(day)))
  SILAV = mean(sil_day[,3]);
  sil_time[itime] = SILAV;
  
  # retrieve the cluster centroids and store them in a separate matrix
  class_centers = matrix(0, number_of_clusters, 2);    
  
  for (k in seq(1,number_of_clusters)){
      temp_class = which(classes == k)
      temp = day[temp_class,]
      class_centers[k,1] = median(temp[,1])
      class_centers[k,2] = median(temp[,2])
      # Produced centroids
      all_ctrs[j+k-1,1] = class_centers[k,1]
      all_ctrs[j+k-1,2] = class_centers[k,2]
  }
  j = j+ N*M;
  } # end of for loop
  
  ######  Perform centroids clustering ##########
  # Remove centroids with NaNs
  all_ctrs_non_zero <- all_ctrs[which(rowSums(all_ctrs) > 0),]
  
  # Apply SOM on centroids
  som.grid <- somgrid(xdim = N, ydim = M, topo = 'hexagonal', toroidal = T)
  som.model <- som(data.matrix(all_ctrs_non_zero), grid = som.grid)
  cidxC = som.model$unit.classif
  
  # Compute the centroids of each cluster
  ctrsC <- c() 
  
  for (k in seq(1,number_of_clusters)){
    temp_class = which(cidxC == k);
    temp = all_ctrs_non_zero[temp_class,]
    
    for (s in seq(1,nrow(temp))){
       ctrsC <- rbind(ctrsC, c(k, temp[s,1], temp[s,2]))
    }
  }
  
  sil = sil_time;
  return(list("centroids" = ctrsC, "silhouette" = sil))

}      
