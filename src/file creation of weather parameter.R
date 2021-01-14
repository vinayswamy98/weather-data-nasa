getwd()
setwd("D:\\Research_paper data\\")
library(devtools)
find_rtools()
library(ncdf4)
library(sp)
library(raster)
library(rgdal)
library(data.table)
library(qdapRegex)
library(qdapDictionaries)
library(qdapTools)
library(qdap)
Sys.setenv(java_Home= "C:\\Program Files (x86)\\JavaSoft\\JRE\\1.3.1_03\\bin")
pars=c("PotEvap_tavg", "Psurf_f_inst", "Qair_f_inst", "Rainf_f_tavg", "SoilMoi0_10cm_inst", "Tair_f_inst", "Wind_f_inst")
files_nc=list.files(path="D:\\Research_paper data\\Parameter_Data",pattern=glob2rx("*.nc4"),full.names = T,recursive = T) #specify the directory where the GLDASdataset is downloaded.
k=1
fs="taluk_level_coordinates.csv" # input file containing lat long
ss<-fread(fs[k],header=T,check.names=F,data.table = F)
#names(ss)[6]="long"
#names(ss)[7]="lat"
for (j in 1:length(pars)) {
  for (k in 1:length(fs)) {
    x<-ss$long
    y<-ss$lat
    data<-data.frame(x,y)
    df_total<-data.frame(c(1:(nrow(data)+1)),stringsAsFactors = F)
    for(i in 1:length(files_nc)){
      mydata<- raster(files_nc[i],varname=pars[j])
      raster(files_nc[i])
      crs(mydata) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
      +towgs84=0,0,0"
      ff<-extract(mydata,data)
      ff[which(ff=="-9999")]=""
      if(i==6)
      {
        ff= as.numeric(ff) -273.15
      }
      dd<- substr(basename(files_nc[i]),18,23)
      dd=paste0(substr(dd,1,4),"-",substr(dd,5,6))
      ff<-c(as.character(dd),ff)
      df_total<-cbind(df_total,ff)
    }
    v=as.character.Date(data.frame(df_total[1,]))
    v=substr(v,nchar(v)-6,nchar(v))
    v=gsub("\\.","-",v)
    df_total= setNames(df_total,c(v))
    df_total=df_total[2:nrow(df_total),2:ncol(df_total)]
    final_df=data.frame(stringsAsFactors = F)
    final_df=cbind(ss,df_total)
    filename= paste0(beg2char(basename(fs[k]),"_"),"_",pars[j],".csv",sep="")
    fwrite(final_df,filename,row.names=F,col.names=T,sep=",")
  }
}    
