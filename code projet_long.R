#Reading the database
data <- readRDS("C:/Users/hp/Desktop/data.Rds")
#Description of the data
summary(data)
str(data)

library(Hmisc)
describe(data)

#to determinate the levels of Sex and population
unique(data$Sex)
unique(data$pop)
unique(data$clonotypes)

#group distribution
table_sex<-table(data$Sex)
prop.table(table_sex)

barplot(table_sex, main="Répartition des groupes", 
        xlab="Les groupes",
        ylab = "Effectif",
        col="red")

#population distribution
barplot(table(data$pop), main = "Bar plot des populations",
        xlab="Les population",
        ylab="Effectif",
        col="red")

#Distribution based on the groups
barplot(table(data$pop,data$Sex), beside = TRUE, legend = levels(data$pop), 
        main ="Barplot de la répartition par groupe",
        xlab="Les groupes",
        ylab="Effectif")

#Distribution based on the clonotypes
barplot(table(data$clonotypes,data$Sex), beside = TRUE,legend = levels(data$clonotypes), 
        main ="Barplot de la répartition par groupe",
        xlab="Les groupes",
        ylab="Effectif")


boxplot(freq ~ pop*chain, data = data, 
        main = "Boxplot d'une variable quanti par modalités croisées",  ylab = "Var quanti")


#Extracted important data
data2 <- data[, c("freq","pop","Sex")]

#Regrouped data based on the Sex factor
library(dplyr)
B6_YgM <- data2 %>% filter(data2$Sex == 'B6_YgM') %>% select("pop", "freq" , "Sex")
B6_Yg <- bind_rows(B6_YgM,data2 %>% filter(data2$Sex == 'B6_YgF') %>% select("pop", "freq" , "Sex") )

NOD_YgM <- data2 %>% filter(data2$Sex == 'NOD_YgM') %>% select("pop", "freq","Sex")
NOD_Yg <- bind_rows(NOD_YgM,data2 %>% filter(data2$Sex == 'NOD_YgF') %>% select("pop", "freq","Sex") )

#Renyi index for both groups
library(vegan)
library(dplyr)
renyi.grouped <- tapply(data$freq, data$pop, renyi, scales=c(0, 1, 2, 8, Inf))
toplot <- bind_rows(renyi.grouped)
rownames(toplot) <- c("amTregs","CD8","nTregs","Teff")

#Renyi index for the B6_Yg
renyi.grpB6_Yg <- tapply(B6_Yg$freq, B6_Yg$pop, renyi, scales=c(0, 1, 2, 8, Inf))
toplotB6_Yg <- bind_rows(renyi.grpB6_Yg)
rownames(toplotB6_Yg) <- c("amTregs","CD8","nTregs","Teff")

#Renyi index for the NOD_Yg
renyi.grpNOD_Yg <- tapply(NOD_Yg$freq, NOD_Yg$pop, renyi, scales=c(0, 1, 2, 8, Inf))
toplotNOD_Yg <- bind_rows(renyi.grpNOD_Yg)
rownames(toplotNOD_Yg) <- c("amTregs","CD8","nTregs","Teff")

#function used to plot
#for NOD
plotgg0 <- ggplot(data=toplotNOD_Yg, aes(x=Scales, y=Diversity, group=Grouping)) + 
  scale_x_discrete() +
  scale_y_continuous(sec.axis = dup_axis(name=NULL)) +
  geom_line(aes(colour=Grouping), linewidth=2) +
  geom_point(aes(colour=Grouping, shape=Grouping), alpha=0.8, size=5) +
  labs(x=expression(alpha), y="Diversity", colour="amTregs","CD8","nTregs","Teff", shape="amTregs","CD8","nTregs","Teff")

plotgg0

#for B6
plotgg0 <- ggplot(data=toplotB6_Yg, aes(x=Scales, y=Diversity, group=Grouping)) + 
  scale_x_discrete() +
  scale_y_continuous(sec.axis = dup_axis(name=NULL)) +
  geom_line(aes(colour=Grouping), linewidth=2) +
  geom_point(aes(colour=Grouping, shape=Grouping), alpha=0.8, size=5) +
  labs(x=expression(alpha), y="Diversity", colour="amTregs","CD8","nTregs","Teff", shape="amTregs","CD8","nTregs","Teff")

plotgg0

rarefied_data <- rarefy(B6_Yg$freq)

#Cumulative percentage
#B6
B6_Yg$cumulative_percentage= 100*cumsum(B6_Yg$cloneCount)/sum(B6_Yg$clonoCount)

#NOD
NOD_Yg$cumulative_percentage= 100*cumsum(NOD_Yg$freq)/sum(NOD_Yg$freq)

#cumulative percentage for B6 and for each population
Teff <- sum(B6_Yg[which(B6_Yg$pop=='Teff'), 2])
CD8 <- sum(B6_Yg[which(B6_Yg$pop=='CD8'), 2])
amTregs <- sum(B6_Yg[which(B6_Yg$pop=='amTregs'), 2])
nTregs <- sum(B6_Yg[which(B6_Yg$pop=='nTregs'), 2])

popu <- c("amTregs","CD8","nTregs","Teff")
Val <- c("1000","800","800","1200")
tableauB6 <- data.frame(x = popu, y = Val)





                    