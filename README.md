# MovCLUfish
A tool for visualising fish movement patterns from individual-based models using data mining. It's based on the paper

•	Politikos, D.V., Kleftogiannis, D., Tsiaras, K. Rose, K. MovCLUFish: A data mining tool for discovering novel fish movement patterns from individual-based models (under review).

The repository includes:

* Source code in Matlab for implementing MovCLUFish
* Source code in R for implementing MovCLUFish

![Farmers Market Finder Demo](demo.gif)

## scripts

* **tmc.m**: compute the cenroids clusters of fish tracks using SOM.

* **visualize_tmc.m**: plot the centroid clusters generated from tmc.m and their shift.

* **amc.m**: compute the surface baf area of moving clusters with SOM.

* **visualize_amc_bagplot.m**: visualize bagplots of moving clusters at specific timestamps.

* **tfm.m**: tracking of fish mobility between moving clusters

