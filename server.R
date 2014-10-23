library(shiny)
library(ggplot2)
library(plyr)
library(reshape2)
library(xtable)
source("bcnopendata.R")

shinyServer(
  function(input, output) {
    output$thePlot <- renderPlot({
      ifelse(input$dte=="All",q <- ggplot(veh_to_plot, aes(year,value)) + geom_bar( stat="identity",aes(color=type, fill=type)) +  xlab("Year") + ylab("Vehicles") + theme_bw() + ggtitle("All districts"),q <- ggplot(veh_dte_to_plot[veh_dte_to_plot$dte==input$dte,], aes(year,value)) + geom_bar(stat="identity", aes(color=type, fill=type)) +  xlab("Year") + ylab("Vehicles") + theme_bw() + ggtitle(paste("District ",input$dte)))
      print(q)
    })
    output$barris_list <- renderTable({
      veh_means<-ddply(vehicles, .(dte,barris), numcolwise(mean))
      col_names_veh<-c("District","Neighbourghood","# Total","# Cars","# Bikes","# Mopeds","# Vans","# Trucks", "# Others")
      if(input$display=="percentages"){
         label<-"Pct"
         veh_means<-cbind(veh_means[c(1,2)], prop.table(as.matrix(veh_means[-c(1,2,3)]), margin = 1))
         col_names_veh<-col_names_veh[-3]
      }
      else {label<-"Avg"}
     
      col_names_veh<-gsub("#",label,col_names_veh)
      colnames(veh_means)<-col_names_veh
      ifelse(input$dte=="All",list<-veh_means, list<-veh_means[veh_means$District==input$dte,])
      data.frame(list)
    })
  }
)