# MovCLUfish
A tool for visualising fish movement patterns from individual-based models using data mining. It's based on the paper:	
Politikos, D.V., Kleftogiannis, D., Tsiaras, K. Rose, K. MovCLUFish: A data mining tool for discovering novel fish movement patterns from individual-based models (under review).

## Short description

Spatially-explicit individual-based models (IBMs) are useful tools for simulating the movement of thousands ofnumerous fish individuals within a dynamic and heterogeneous environment. Processing the IBM outputs is complex because fish are continuously adjusting their behavior in response to changing environmental conditions. We present a new analysis tool called MovCLUfish that uses data mining to identify patterns from the trajectories of the individuals. MovCLUfish is configured to identify features of fish behavior related to occupation (area of fish presence), dynamics of aggregation (how fish individuals are distributed within the area of presence), and mobility (how fish move between subregions). MovCLUfish receives as input the fish locations (longitude, latitude) at fixed times during a specific time period and performs spatial clustering on consecutive timestamps, considering them as moving objects. Fish locations are grouped into clusters whose features (centroid, shape, size, density) are used to provide further information about the spatial distribution of the individuals. The clusters are analyzed using three built-in pattern mining methods: Tracking Moving Centroids (TMC), Aggregating Moving Clusters (AMC), and Tracking Fish Mobility (TFM). TMC detects shifts in the distribution of fish over time, AMC visualizes the way fish aggregations change geographically over time, and TFM provides quantitative information on the patterns of exchange and connectivity of fish individuals among regions within the domain. 

The repository includes:

* Source code in Matlab for implementing MovCLUFish
* Source code in R for implementing MovCLUFish

![Farmers Market Finder Demo](Fish_tracks_movement.gif)

## Functions

### Tracking Moving Centroids (TMC)

- tmc.m: compute the cenroids clusters of fish tracks using SOM.

% Inputs:
  
% Outputs: 
% 1. centroids: centroids of clusters
% 2. sil: silouette coefficients 
% -------------------------------------------------------------------------
% Example of use:
% [centroids, sil] = tmc(x,y,1,20,3,2,[22 26.5 39 41.2]);
% See also visualize_tcm.m example for ploting the centroids

* **visualize_tmc.m**: plot the centroid clusters generated from tmc.m and their shift.

### Aggregating Moving Clusters (AMC)

* **amc.m**: compute the surface baf area of moving clusters with SOM.

* **visualize_amc_bagplot.m**: visualize bagplots of moving clusters at specific timestamps.

### Tracking Fish Mobility (TFM). 

* **tfm.m**: tracking of fish mobility between moving clusters







