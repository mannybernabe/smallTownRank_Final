remove(list=ls())

setwd("~/Documents/GTD/Best Small Towns/smallTownRank_Final")

#read in data
load(file="DATA/smallTown_finalData")

library(rCharts)
library(googleVis)

scatterPlot <- nPlot(distance ~ overallScore, group = 'newCluster', data = smallTown.df, type = 'scatterChart')

scatterPlot$chart(tooltipContent = "#! function(key, x, y, e){
  return '<b>Suburb</b>: ' + e.point.city
} !#")

scatterPlot$chart(sizeRange = c(30,30))

scatterPlot$yAxis(axisLabel = "Miles from Downtown Chicago")
scatterPlot$xAxis(axisLabel = "Overall Score")

scatterPlot$chart(yDomain=c(8,60))
scatterPlot$chart(xDomain=c(37,57))

scatterPlot$chart(color = c("blue", "green", "orange", "red"))

scatterPlot

save(scatterPlot,file="PLOTS/scatterPlot")




smallTownB.df<-smallTown.df[,1:8]
names(smallTownB.df)


colnames(smallTownB.df)<-c("Suburb", "Overall Rank", "Overall Score", 
  "Distance from Chicago (Miles)","Affordability Rank", 
  "Economic Rank","Ed. and Health Rank", "Quality of Life Rank")


townTable <- gvisTable(smallTownB.df,
                      options=list(page='enable'))
# plot(townTable)

save(townTable,file="PLOTS/tablePlot")

