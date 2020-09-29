# MovCLUfish
A tool for visualising fish movement patterns from individual-based models using data mining. It's based on [1].

## Short description

Spatially-explicit individual-based models (IBMs) are useful tools for simulating the movement of thousands ofnumerous fish individuals within a dynamic and heterogeneous environment. Processing the IBM outputs is complex because fish are continuously adjusting their behavior in response to changing environmental conditions. We present a new analysis tool called MovCLUfish that uses data mining to identify patterns from the trajectories of the individuals. 

MovCLUfish is configured to identify features of fish behavior related to occupation (area of fish presence), dynamics of aggregation (how fish individuals are distributed within the area of presence), and mobility (how fish move between subregions). MovCLUfish receives as input the fish locations (longitude, latitude) at fixed times during a specific time period and performs spatial clustering on consecutive timestamps, considering them as moving objects. Fish locations are grouped into clusters whose features (centroid, shape, size, density) are used to provide further information about the spatial distribution of the individuals. 

The clusters are analyzed using three built-in pattern mining methods:

* *Tracking Moving Centroids (TMC):*  TMC aims to detects shifts in the distribution of fish over time.

* *Aggregating Moving Clusters (AMC):* AMC visualizes the way fish aggregations change geographically over time, 

* *Tracking Fish Mobility (TFM):* TFM provides quantitative information on the patterns of exchange and connectivity of fish individuals among regions within the domain. 

The repository includes:

* Source code in Matlab for implementing MovCLUFish
* Source code in R for implementing MovCLUFish

## Sample dataset

The sample dataset comes from a spatially explicit fish IBM model configured for anchovy in the North Aegean Sea [2].
The animated graph trackes the daily locations of 8500 adult anchovy individuals for one year. 
Initially, anchovy individuals were uniformly distributed in the coastal regions of the study area.  

![Farmers Market Finder Demo](Fish_tracks_movement.gif)

## Matlab version of MovCLUfish

To run the Matlab version of MovCLUfish, please make *Matlab* folder in the present repository as the working directory.

* **Tracking Moving Centroids (TMC)**

TMC method is run through the *tmc.m* and *visualise_tmc.m* files. 
Please explore the source files for understanding the main inputs and outputs of the functions built in.   

% Example of use:\
load import_fish_tracks\
[centroids, sil] = tmc(fish_lon,fish_lat,1,20,3,2,[22 26.5 39 41.2])\
visualise_tmc(centroids, sil,2,3,[22 26.5 39 41.2]); % including map<br/>
visualise_tmc(centroids, sil,2,3); % without a map

* **Aggregating Moving Clusters (AMC)**

AMC method is run through the *amc.m* and *visualise_amc.m* files. 
Please explore the source files for understanding the main inputs and outputs of the functions built in.   

% Example of use:\
load import_fish_tracks\
bag_area = amc(fish_lon,fish_lat,1,10,3,2)<br/>
visualize_amc(fish_lon,fish_lat,10,3,2,[22 27 39 41.2]) % including map<br/>
visualize_amc(fish_lon,fish_lat,10,3,2) % without a map <br/>

* **Tracking Fish Mobility (TFM)** 

TFM method is run through the *tfm.m* file. 
Please explore the source file for understanding the main inputs and outputs of the functions built in.  

load import_fish_tracks<br/>
[mob, mob_right, mob_left] = tfm(3,fish_lon,fish_lat,1,20,3,2,[22 27 39 41.2]);

## R version of MovCLUfish

## References

[1] Politikos, D.V., Kleftogiannis, D., Tsiaras, K. Rose, K. MovCLUFish: A data mining tool for discovering novel fish movement patterns from individual-based models (under review).

[2] Politikos, D. V., S. Somarakis, K. Tsiaras, M. Giannoulaki, G. Petihakis, A. Machias, and G. 
Triantafyllou. 2015. Simulating anchovy's full life cycle in the eastern Mediterranean: a  coupled hydrobiogeochemical-IBM model. Progr. Oceanogr. 138: 399-416 doi:10.1016/j.pocean.2014.09.002






