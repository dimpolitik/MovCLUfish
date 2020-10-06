visualize_amc <- function(x,y,t,N,M){
# -------------------------------------------------------------------------
# Aim: 
# Visualize bagplots of moving clusters at specific timestamps
# -------------------------------------------------------------------------
# Input: 
# x,y: fish locations (lon, lat) with dimensions: (#individuals, time) 
# t: timestamps to visualize bagplots
# N,M: dimension of SOM grid
# map_range (optional): range of model domain in [lon_min lon_max lat_min lat_max]
# -------------------------------------------------------------------------
# Output: 
# Plot of bagplots (bag and fence)
# -------------------------------------------------------------------------
# Example of use:
# fish = readMat('import_fish_tracks.mat')
# visualize_amc(fish$ish_lon,fish$fish_lat,1,3,2]) # one timestamp
# visualize_amc(fish$fish_lon,fish$fish_lat,c(1, 10, 20),3,2) # multiple timestamps
# -------------------------------------------------------------------------
# References:
# Rousseeuw, P.J., Ruts, I., Tukey, J.W., 1999. The Bagplot: 
# A Bivariate Boxplot. Am. Stat. 53(4), 382-387.
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

number_of_clusters = N * M

for (itime in seq(1, length(t))){ 
   print(paste("Time:", itime))
   
   day <- cbind(x[,t[itime]], y[,t[itime]])
   som.grid <- somgrid(xdim = N, ydim = M, topo = 'hexagonal', toroidal = T)
   som.model <- som(data.matrix(day), grid = som.grid)
   classes = som.model$unit.classif 
   
   x11()
   plot(day[,1], day[,2], col="white", xlab="", ylab="")
   
   for (k in seq(1,number_of_clusters)){
      temp_class = which(classes == k)
      class = day[temp_class,]
      # Plot bagplot
      if (length(class)>10){
         bag = bagplot(class, show.whiskers = FALSE, show.looppoints = FALSE, show.loophull = FALSE, add = TRUE)
         title(main = paste("time=", t[itime]))
        }
   } 
}}