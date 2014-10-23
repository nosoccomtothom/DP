#Abstract
#This is a brief analysis on the evolution of unemployment and foreign residents in the city of Barcelona taking data from BCNOpenData

#Data exploration

#Loading data
##Remove the quotes from names not to mess with records
##Set classes as characters due to the dots for thousands present only in figures above thousands
##Reading the data for vehicles per neighbourhood
col_classes_veh<-c("numeric","character", rep("numeric",7))
veh11<-read.table(url(description="http://opendata.bcn.cat/opendata/ca/descarrega-fitxer?url=http%3a%2f%2fbismartopendata.blob.core.windows.net%2fopendata%2fopendata%2ftipologiatipo2011.csv"), colClasses=col_classes_veh, header=TRUE, sep=";",quote="\"")
veh11$year<-2011
veh10<-read.table(url(description="http://opendata.bcn.cat/opendata/ca/descarrega-fitxer?url=http%3a%2f%2fbismartopendata.blob.core.windows.net%2fopendata%2fopendata%2ftipologiatipo2010.csv"), colClasses=col_classes_veh, header=TRUE, sep=";",quote="\"")
veh10$year<-2010
veh09<-read.table(url(description="http://opendata.bcn.cat/opendata/ca/descarrega-fitxer?url=http%3a%2f%2fbismartopendata.blob.core.windows.net%2fopendata%2fopendata%2ftipologiatipo2009.csv"), colClasses=col_classes_veh, header=TRUE, sep=";",quote="\"")
veh09$year<-2009
#veh09$year<-as.Date("01/01/2009", "%m/%d/%Y")
vehicles<-rbind(veh09,veh10,veh11)
names(vehicles)<-tolower(names(vehicles))
names(vehicles)<-make.names(names(vehicles))
vehicles$dte<-as.factor(vehicles$dte)
vehicles$barris<-as.factor(vehicles$barris)
rm(veh09)
rm(veh10)
rm(veh11)
rm(col_classes_veh)
vehicles<-cbind(vehicles[,c("barris")],as.data.frame(sapply(vehicles[,-c(2)],function(x){gsub(".","",x, fixed=TRUE)}, simplify=FALSE)))
labels<-colnames(vehicles)
labels[1]<-"barris"
colnames(vehicles)<-labels
rm(labels)
vehicles$total<-as.numeric(levels(vehicles$total))[vehicles$total]
vehicles$turismes<-as.numeric(levels(vehicles$turismes))[vehicles$turismes]
vehicles$motos<-as.numeric(levels(vehicles$motos))[vehicles$motos]
vehicles$ciclomotors<-as.numeric(levels(vehicles$ciclomotors))[vehicles$ciclomotors]
vehicles$furgonetes<-as.numeric(levels(vehicles$furgonetes))[vehicles$furgonetes]
vehicles$camions<-as.numeric(levels(vehicles$camions))[vehicles$camions]
vehicles$altresvehicles<-as.numeric(levels(vehicles$altresvehicles))[vehicles$altresvehicles]

##Aggregates
#Removing the totals
veh_sums<-ddply(vehicles[,-c(3)], .(year), numcolwise(sum)) 
#veh_sums<-ddply(vehicles[,c("year","total","turismes","motos","ciclomotors")], .(year), numcolwise(sum)) 

veh_to_plot <- melt(veh_sums,id.vars=c("year"))
# p <- ggplot(veh_to_plot, aes(year,value)) + geom_line(aes(color=variable)) +  xlab("Year") + ylab("Vehicles") + theme_bw()
# p
###
#p <- ggplot(veh_to_plot, aes(year,value)) + geom_bar( stat="identity",aes(color=variable, fill=variable)) +  xlab("Year") + ylab("Vehicles") + theme_bw()
#p
###
veh_dte_sums<-ddply(vehicles[,-c(3)], .(year,dte), numcolwise(sum)) 
veh_dte_to_plot <- melt(veh_dte_sums,id.vars=c("year","dte"))

veh_to_plot$variable<-factor(veh_to_plot$variable,levels=c("turismes","motos","ciclomotors","furgonetes","camions","altresvehicles"),labels=c("cars","bikes","moped","vans","trucks","other"))
veh_dte_to_plot$variable<-factor(veh_dte_to_plot$variable,levels=c("turismes","motos","ciclomotors","furgonetes","camions","altresvehicles"),labels=c("cars","bikes","moped","vans","trucks","other"))

names(veh_to_plot)<-c("year","type","value")
names(veh_dte_to_plot)<-c("year","dte","type","value")
