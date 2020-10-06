visualize_tmc <- function(x, y, centroids, sil, N, M){
# -------------------------------------------------------------------------
# Function:
# Visualising Tracking Moving Centroids (TMC)
# Aim: 
# Visualise the outputs of TMC function 
# -------------------------------------------------------------------------
# Input: 
# 1. centroids: centroids of clusters produced by "tmc" function
# 2. sil: silouette coefficients produced by "tmc" function
# 3. N,M: size of SOM grid
# 3. map_range (optional): range of model domain in [lon_min lon_max lat_min lat_max]
# -------------------------------------------------------------------------
# Outputs: 
# 1. Plots of centroids
# 2. Boxplots of silhouette coefficients 
# -------------------------------------------------------------------------
# Example of use:
# fish = readMat('import_fish_tracks.mat')
# fish_out = tmc(fish$fish.lon, fish$fish.lat, 1, 100, 3,2)
# visualize_tmc(fi$fish.lon, fi$fish.lat, fish_out$centroids, fish_out$silhouette, 3, 2)
# See also tmc.r for finding the centroids
# The function is called after calling tmc.r function
# -------------------------------------------------------------------------
# References:
# [1] Rousseeuw P.J, 1987. "Silhouettes: a Graphical Aid to the Interpretation 
# and Validation of Cluster Analysis". Computational and Applied Mathematics 20, 53-65.
# [2] Politikos, D.V., Kleftogiannis, D., Tsiaras, K., Rose K. 2020. MovCLUFish: A data mining 
# tool for discovering novel fish movement patterns from individual-based models.
# ------------------------------------------------------------------------
# Plot tmc results
# 1 - Plot of centroids
x11()
cols = c("blue", "red", "green", "yellow", "cyan", "magenta", "pink")  
for (k in seq (1,nrow(centroids))){
  ind = which(centroids[,1]==k)
  if (length(ind>0)){
     if (k==1){
        plot(median(centroids[ind,2]),median(centroids[ind,3]), pch = 4, col = "white", xlab="", ylab="", 
                                                       xlim = c(min(x), max(x)), ylim = c(min(y), max(y)))
        points(centroids[ind,2], centroids[ind,3], col = cols[k], pch = 20, cex = 0.75)
        points(median(centroids[ind,2]),median(centroids[ind,3]), col = "black" , pch = 4, cex = 2, bg = "red", lwd = 2)
     }else{ 
       points(centroids[ind,2],centroids[ind,3], pch = 20, col = cols[k], cex = 0.75)
       points(median(centroids[ind,2]),median(centroids[ind,3]), col = "black", pch = 4, cex = 2, bg= "red", lwd = 2)
    }}
}

# 3 - Plot Silouette cofficients
x11();
boxplot(sil, main = 'Silhouette coefficient')
}