library(rvest)
library(ggmap)
library(stringr)
library(dplyr)

remove(list=ls())
setwd("~/Documents/GTD/Best Small Towns/smallTownRank_Final")

#scrap data from web
smallTown.url<- read_html("https://wallethub.com/edu/best-worst-small-cities-to-live-in/16581/")

smallTown.df<-smallTown.url %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table()

#clean initial data set
smallTown.df<-smallTown.df[,2:7]
state<-str_sub(smallTown.df[,1], -2, -1)
smallTown.df<-cbind(smallTown.df,state)

smallTown.df<-smallTown.df%>%
  filter(state=="IL")


distCalc.fun<-function(address){
  #function returns distance from Chicago for given address
  rush.name <- "Chicago, IL"  
  miles<-suppressMessages(mapdist(address, rush.name, mode = 'driving')$miles)
  return(round(miles,2))
}


distance<-distCalc.fun(smallTown.df[,1])

smallTown.df<-cbind(smallTown.df,distance)

#subset to towns within 60 driving miles of downtown Chicago
smallTown.df<-smallTown.df%>%
  filter(distance<=60)

city<-str_sub(smallTown.df[,1], 0, -5)


overallScore<-smallTown.df[,2]
overallRank<-rank(-smallTown.df[,2])
affordRank<-rank(smallTown.df[,3])
econRank<-rank(smallTown.df[,4])
eduAndHealthRank<-rank(smallTown.df[,5])
qualLifeRank<-rank(smallTown.df[,6])
distance<-smallTown.df[,"distance"]


smallTown.df<-cbind.data.frame(city,overallRank,overallScore,
                  distance,affordRank,
                  econRank,eduAndHealthRank,
                  qualLifeRank)






# klusterGroup<-kmeans(smallTown.df[,3:4],4)
# set.seed(100)
# klusterGroup<-kmeans(apply(smallTown.df[,3:4], 2, scale),3)
# klusterGroup<-klusterGroup$cluster
#Kmeans clustering didnt work out so well, so I opted for simpler approach



newCluster<-paste(
ifelse(smallTown.df[,3]>=mean(smallTown.df[,3]),"Above Avg. Score,","Below Avg. Score,"),
ifelse(smallTown.df[,4]>=mean(smallTown.df[,4]),"Far","Near"))


smallTown.df<-cbind.data.frame(smallTown.df, newCluster)



rm(list=setdiff(ls(), "smallTown.df"))

save(smallTown.df,file="DATA/smallTown_finalData")


