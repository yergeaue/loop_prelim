###Ordination - visualization

##PCOA on Bray-Curtis
#Load data
map <- readRDS(file = here("data","intermediate","map.RDS"))
gene.norm <- readRDS(file = here("data","intermediate","gene.norm.RDS"))
contig.norm <- readRDS(file = here("data","intermediate","contig.norm.RDS"))

#Check sorting
rownames(map) == row.names(gene.norm) #All TRUE
rownames(map) == row.names(contig.norm) #All TRUE

#Calculate bray
gene.bray <- vegdist(gene.norm, method = "bray")
contig.bray <- vegdist(contig.norm, method = "bray")

#PCoA
gene.pcoa <- cmdscale(gene.bray, k=5, eig = TRUE)
contig.pcoa <- cmdscale(contig.bray, k=5, eig = TRUE)

#Merge for plotting
gene.pcoa.map <- data.frame(map, gene.pcoa$points[,1:2])
contig.pcoa.map <- data.frame(map, contig.pcoa$points[,1:2])

#Plot
gene.plot <- ggplot(data = gene.pcoa.map, aes(x=X1, y=X2, color=Heat, shape = Origin))+
            geom_point()
gene.plot

contig.plot <- ggplot(data = contig.pcoa.map, aes(x=X1, y=X2, color=Heat, shape = Origin))+
  geom_point()
contig.plot
