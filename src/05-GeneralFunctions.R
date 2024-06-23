###General functional profile based on COGs

#Load data
map <- readRDS(file = here("data","intermediate","map.RDS"))
gene.norm.s <- readRDS(file = here("data","intermediate","gene.norm.RDS"))
contig.norm <- readRDS(file = here("data","intermediate","contig.norm.RDS"))
annot.s <- readRDS(file = here ("data", "intermediate", "annot.RDS"))

gene.fun <- data.frame(t(gene.norm.s), Annotation = annot.s$cog_category)
fun.cog.summary <- gene.fun %>%
  group_by(Annotation) %>%
  summarise(across(.cols=everything(), ~ sum(.x, na.rm = TRUE)))
#row.names(fun.cog.summary) <- fun.cog.summary[,1]
#fun.cog.summary <- fun.cog.summary[,-1]
#Convert to relative abundance
fun.cog.summary.rel <- data.frame(t(apply(fun.cog.summary[,2:7], 1, "/", colSums(fun.cog.summary[,2:7]))))
colSums(fun.cog.summary.rel) #Should all be ones
#Add back rownames
fun.cog.summary.rel$COG <- fun.cog.summary$Annotation
#Keep only above 1% on average across all samples
fun.cog.summary.rel.top <- fun.cog.summary.rel[rowMeans(fun.cog.summary.rel[,1:6])>0.01, ] 
#Prepare for ggplot
sum(row.names(map)==colnames(fun.cog.summary.rel.top[,1:6]))#6
others <- data.frame(1-colSums(fun.cog.summary.rel.top[,1:6])) #Add others
colnames(others)<-"Others"
fun.map <- data.frame(map,t(fun.cog.summary.rel.top[,1:6]), others)
colnames(fun.map) <- c("Heat", "Origin", fun.cog.summary.rel.top$COG, "Others")
rowSums(fun.map[,3:14]) #Should be ones
fun.map.long <- gather(fun.map,COG,relabund,3:14) #transform in long format for ggplot

#Plot
stack.cog.1 <- ggplot(fun.map.long, aes(fill = COG, y = 100*relabund, x = Heat)) + 
  geom_bar( stat = "identity", position = "fill") +
  ylab("Relative abundance (%)") + 
  theme_bw() +
  scale_y_continuous( expand = c(0,0)) +
  scale_x_discrete(name = "Treatment", labels = c("Heated", "Not heated")) +
  facet_wrap(~Origin)+
  scale_fill_manual(values = c("#264653", "#F4A261", "#E56B6F", "#62929E", "#5B8E7D","#8EA8C3", "#BCB8B1","#30AB65","#FFC857","#BDD9BF","#F9844A", "pink"))
stack.cog.1

#Omit NULL
fun.map.long.nonull <- fun.map.long[fun.map.long$COG != "NULL",]
stack.cog.2 <- ggplot(fun.map.long.nonull, aes(fill = COG, y = 100*relabund, x = Heat)) + 
  geom_bar( stat = "identity", position = "fill") +
  ylab("Relative abundance (%)") + 
  theme_bw() +
  scale_y_continuous( expand = c(0,0)) +
  scale_x_discrete(name = "Treatment", labels = c("Heated", "Not heated")) +
  facet_wrap(~Origin)+
  scale_fill_manual(values = c("#264653", "#F4A261", "#E56B6F", "#62929E", "#5B8E7D","#8EA8C3", "#BCB8B1","#30AB65","#FFC857","#BDD9BF","#F9844A", "pink"))
stack.cog.2
