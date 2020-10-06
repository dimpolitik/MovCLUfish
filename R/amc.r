amc <- function(x,y,tstart,tfinish,N,M){
# -------------------------------------------------------------------------
# Function:
# Aggregation of Moving Clusters (AMC)
# Aim: 
# Compute the surface bag area of moving clusters
# -------------------------------------------------------------------------
# Input: 
# x,y: fish locations (lon, lat), dimensions: (time, #individuals) 
# tstart,tfinish: initial and last timestamp
# N,M: dimension of SOM grid
# -------------------------------------------------------------------------
# Output: 
# Surface of bagplots derived from clusters over the time period [tstart, tfinish]
# -------------------------------------------------------------------------
# Example of use:
# fish = readMat('import_fish_tracks.mat')
# bag_area = amc(fish$fish_lon,fish$fish_lat,1,30,3,2)
# plot(bag_area, type = "o", xlab = 'Time', ylab = "Surface of bagplot") 
# -------------------------------------------------------------------------
# References:
# [1] Rousseeuw, P.J., Ruts, I., Tukey, J.W., 1999. The Bagplot: 
# A Bivariate Boxplot. Am. Stat. 53(4), 382-387.
# [2] Politikos, D.V., Kleftogiannis, D., Tsiaras, K., Rose K. 2020. MovCLUFish: A data mining 
# tool for discovering novel fish movement patterns from individual-based models.
# -------------------------------------------------------------------------
# Written by:
# Dimitris Politikos
# Hellenic Center for Marine Research (HCMR)
# October 2020
# dimpolit@hcmr.gr
# -------------------------------------------------------------------------
# Libraries
library(kohonen)
library(cluster)
library(aplpack)   
library(pracma)
   
number_of_clusters = N * M;

time_duration = tfinish - tstart + 1
bag_area = numeric(time_duration);

for (itime in seq(tstart,tfinish)){ 
   print(paste("Time:", itime))
   
   day <- cbind(x[,itime], y[,itime])
   som.grid <- somgrid(xdim = N, ydim = M, topo = 'hexagonal', toroidal = T)
   som.model <- som(data.matrix(day), grid = som.grid)
   classes = som.model$unit.classif
   
   totarea = 0; 
   for (k in seq(1, number_of_clusters)){
      temp_class = which(classes == k)
      class = day[temp_class,]
      
      if (length(class)>10){
         bag = bagplot(class, create.plot=FALSE)
         # compute area of bag points
         area = abs(polyarea(bag$pxy.bag[,1], bag$pxy.bag[,2]))
         if (area > 0){
            totarea = totarea + area
            }
      }
   }
   bag_area[itime] = totarea
}
y
}