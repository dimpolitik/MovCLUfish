tfm <- function(index,x,y,tstart,tfinish,N,M,map_range){
# -------------------------------------------------------------------------
# Aim: 
# Tracking of fish mobility between moving clusters
# -------------------------------------------------------------------------
# Inputs:
# index: the studied class; index takes values from 1 to 
# number_of_clusters. Should be <= N * M
# x,y: fish locations (lon, lat) with dimensions: (#individuals, time) 
# tstart,tfinish: initial and last timestamp of processing time
# N,M: dimension of SOM grid
# -------------------------------------------------------------------------
# Output: 
# mob: matrix presenting the number of individuals in the index cluster and
# surrounding clusters for each timestamp of processing time
# mob_right: average proportion of individuals moving to suurounding clusters  
# to the right side
# mob_left: average proportion of individuals moving to surrounding clusters 
# to the left side
# -------------------------------------------------------------------------
# Example of use:
# fish= readMat('import_fish_tracks.mat')
# [mob, mob_right, mob_left] = tfm(3,fish$fish_lon,fish$fish_lat,1,20,3,2);
# -------------------------------------------------------------------------
# References:
#
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
   
# error check
if (index > N * M){
    stop('index should be smaller than:', N*M)
}

uright = 0; uleft = 0;
# Individuals at time tstart
init = cbind(x[,tstart], y[,tstart])
out_neig = c() 
out_right = c() 
out_left = c()
# Run SOM algorithm
som.grid <- somgrid(xdim = N, ydim = M, topo = 'hexagonal', toroidal = T)
som.model <- som(data.matrix(init), grid = som.grid)
cidx = som.model$unit.classif

number_of_clusters = max(cidx)

# Here is the cluster tested for its mobility to other clusters
study_class = which(cidx == index)
study_class_plot = init[which(cidx == index),]

# Helpful screen messages
print(paste("Number of clusters:", number_of_clusters)) 

# Find the centroid of studied class
ctrs <- matrix(0, number_of_clusters, 2)
ctrs[index,1] = mean(study_class_plot[,1]);
ctrs[index,2] = mean(study_class_plot[,2]);

# Plot the studied class
x11();
plot(study_class_plot[,1],study_class_plot[,2], main ="Initial plot of studied class", pch =20, xlab="", ylab="")
points(ctrs[index,1],ctrs[index,2], col = "red", pch = 4, cex = 2, bg="red", lwd=2)

# Update clusters
x11()
for (itime in seq(tstart,tfinish)){
   print(paste("Time:", itime))
   fish_timestamp = cbind(x[,itime], y[,itime])
   
   som.grid <- somgrid(xdim = N, ydim = M, topo = 'hexagonal', toroidal = T)
   som.model <- som(data.matrix(fish_timestamp), grid = som.grid)
   cidx = som.model$unit.classif
   num_clusters = max(cidx)

   # Compute distance of cluster centroids
   centroid_dist <- numeric(num_clusters);
   ctrsD <- matrix(0, num_clusters, 2);    
   
   for (j in seq(1,num_clusters)){
      temp = which(cidx == j);
      class = fish_timestamp[temp,]
      #print(dim(class))
      
      ctrsD[j,1] = mean(class[,1])
      ctrsD[j,2] = mean(class[,2])
      
      #ctrsD[j,1][is.nan(ctrsD[j,1])] = 0
      #ctrsD[j,2][is.nan(ctrsD[j,2])] = 0
     
      cat('test2', index, ctrs[index,1], ctrs[index,2], '\n')
      centroid_dist[j] = sqrt((ctrsD[j,1] - ctrs[index,1])^2 + (ctrsD[j,2] - ctrs[index,2])^2);
   }
   #print(centroid_dist)
   mind = min(centroid_dist, na.rm =T);

   for  (j in seq(1,num_clusters)){
      if (mind == centroid_dist[j]){
         xc = ctrsD[j,1]
         yc = ctrsD[j,2]
         locj = j;
      }
   }
   
   #out = locj;
   out = c();
   outR = c();
   outL = c();

   for (j in seq(1,num_clusters)){
      temp = which(cidx == j)
      C = intersect(study_class,temp)
      #print(C)
      temp_plot = fish_timestamp[C,]
      
      temp_plot[is.nan(temp_plot)] = 0
      temp_plot[is.nan(temp_plot)] = 0
      
      ctrs[j,1] = mean(temp_plot[,1])
      ctrs[j,2] = mean(temp_plot[,2])
      if (j == locj){
         xcloc = ctrs[j,1];
         ycloc = ctrs[j,2];
      }
   }
   
   plot(mean(x),mean(y), pch = 4, col = "white", xlab="", ylab="", 
        xlim = c(min(x), max(x)), ylim = c(min(y), max(y)))
   for (j in seq(1,num_clusters)){
      jright = 0;
      jleft = 0;
      temp = which(cidx == j);
      C = intersect(study_class,temp);
      temp_plot = fish_timestamp[C,];
      
      if (length(C)>0){
        points(temp_plot[,1],temp_plot[,2], pch =20)
      }
    if (j != locj){
      ctrs[j,1][is.nan(ctrs[j,1])] = 0
      if (ctrs[j,1] > xcloc){
         jright = j;
      }
      if (ctrs[j,1] < xcloc & ctrs[j,1] > 0){
         jleft = j;
      }
   }
   #out <- c(out, size(C,2));
   outR <- c(outR, jright);
   outL <- c(outL, jleft);
   if (j == num_clusters){
      if (num_clusters == 1){
         out_neig <- c(out_neig, out, 0, 0, 0, 0, 0, 0, 0, 0, 0)
         out_right <- c(out_right, outR, 0, 0, 0, 0, 0, 0, 0, 0, 0)
         out_left <- c(out_left, outL, 0, 0, 0, 0, 0, 0, 0, 0, 0)
      }else if (num_clusters == 2){
          out_neig <- c(out_neig, out, 0, 0, 0, 0, 0, 0, 0, 0)
          out_right <- c(out_right, outR, 0, 0, 0, 0, 0, 0, 0, 0)
          out_left <- c(out_left, outL, 0, 0, 0, 0, 0, 0, 0, 0)
      }else if (num_clusters == 3){
          out_neig <- c(out_neig, out, 0, 0, 0, 0, 0, 0, 0)
          out_right <- c(out_right,outR, 0, 0, 0, 0, 0, 0, 0)
          out_left <- c(out_left, outL, 0, 0, 0, 0, 0, 0, 0)
      }else if (num_clusters == 4){
          out_neig <- c(out_neig, out, 0, 0, 0, 0, 0, 0)
          out_right <- c(out_right, outR, 0, 0, 0, 0, 0, 0)
          out_left <- c(out_left, outL, 0, 0, 0, 0, 0, 0)
      }else if (num_clusters == 5){
          out_neig <- c(out_neig, out, 0, 0, 0, 0, 0)
          out_right <- c(out_right, outR, 0, 0, 0, 0, 0)
          out_left <- c(out_left, outL, 0, 0, 0, 0, 0)
      }else if (num_clusters == 6){
          out_neig <- c(out_neig, out, 0, 0, 0, 0)
          out_right <- c(out_right, outR, 0, 0, 0, 0)
          out_left <- c(out_left, outL, 0, 0, 0, 0)
      }else if (num_clusters == 7){
          out_neig <- c(out_neig, out, 0, 0, 0)
          out_right <- c(out_right, outR, 0, 0, 0)
          out_left <- c(out_left, outL, 0, 0, 0)
      }else if (num_clusters == 8){
          out_neig <-  c(out_neig, out, 0, 0)
          out_right <- c(out_right, outR, 0, 0)
          out_left <- c(out_left, outL, 0, 0)
      }else if (num_clusters == 9){
          out_neig <- c(out_neig, out, 0)
          out_right <- c(out_right, outR, 0)
          out_left <- c(out_left, outL, 0)
      }else if (num_clusters == 10){
          out_neig <- c(out_neig, out)
          out_right <- c(out_right, outR)
          out_left <- c(out_left, outL)
      }else{
          display('Warning: You have more than 10 clusters')
      }
   }
 }
  
}
k = which(out_neig[1,]>0 & out_right[1,]==0);
mleft = which(out_neig[2,]>0 & out_left[2,]>0);
mright = which(out_neig[2,]>0 & out_right[2,]>0);

if (length(mleft)>0){
uleft = numeric(length(mleft))
   for (i in seq(1,length(mleft))){
      for (j in seq(1, (tfinish-tstart+1))){
         uleft[i] = uleft[i] + 1 - (out_neig[j,k] - out_neig[j,mleft[i]]) / out_neig[j,k]
   }
}
uleft = uleft / (tfinish-tstart+1)
}

if (length(mright)>0){
uright = numeric(length(mright))
   for (i in seq(1, length(mright))){
      for (j in seq(1, (tfinish-tstart+1))){
         uright(i) = uright(i) + 1 - (out_neig(j,k)- out_neig(j,mright(i))) / out_neig(j,k)
}
   }
uright = uright / (tfinish-tstart+1)
}

mob = out_neig; mobr = uright; mobl = uleft;

}