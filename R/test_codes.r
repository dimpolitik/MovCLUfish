library(R.matlab)

fi= readMat('import_fish_tracks.mat')

fi1= readMat('fish_dataset.mat')

out = tmc(fi$fish.lon, fi$fish.lat, 1, 10, 3,2)

visualize_tmc(fi$fish.lon, fi$fish.lat, out$centroids, out$silhouette, 3, 2)

bag_area = amc(fi$fish.lon, fi$fish.lat,1,100,3,2)

visualize_amc(fi$fish.lon, fi$fish.lat,1,3,2)

visualize_amc(fi$fish.lon, fi$fish.lat, c(1,10), 3, 2)

tfm(3,fi$fish.lon, fi$fish.lat, 1, 10, 3, 2)
