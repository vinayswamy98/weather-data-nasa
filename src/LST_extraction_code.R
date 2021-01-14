getwd()
setwd("D:\\Research_paper data\\")
library(sp)
library(rgdal)
library(raster)
library(gdalUtils)
library(maps)
library(mapdata)
library(MODIS)
files <- list.files(path="LST_Data_1",pattern = glob2rx("*25v07*.hdf"),full.names = T)
j<-length(files)
date=extractDate(files,asDate = T)
filename <- paste0("LST_Data_1/", substr(files,23,28),date$inputLayerDates,".tif")
i <-1
while(i<=j){ 
  sds <- get_subdatasets(files[i]);
  gdal_translate(sds[1], dst_dataset = filename[i]); # sds[1] LST
  i<-i+1;
}

files[1]
get_subdatasets("LST_Data_1/MOD11A2.A2006001.h25v07.006.2015273184235.hdf")

ss<-read.csv("karnataka_lat_long.csv", sep=",", header=T,check.names = F)
filename <- list.files(path="D:\\Research_paper data\\LST_tiff_files",pattern = ".tif",full.names = T)
x<-ss$long
y<-ss$lat
data<-data.frame(x,y)
latlon1<-CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
             +towgs84=0,0,0')
coordinates1 = SpatialPoints(data,latlon1)
sinus1 = CRS("+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181
             +b=6371007.181 +units=m +no_defs")
coordinates_sinus1 = spTransform(coordinates1,sinus1)
df_total<-NULL
i=1
for(i in 1:length(filename)){
  my<-raster(filename[i])
  my<-stack(my)
  dd<-extract(my,coordinates_sinus1)
  tempf = which(is.na(dd))
  if(length(tempf) != nrow(dd)){
    df_total<-cbind(df_total,dd)
  }
}
df_total = as.matrix(df_total)
write.csv(df_total,"Ka_LST_New.csv",row.names = T)









