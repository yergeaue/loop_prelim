###PGP functions
#Load data
map <- readRDS(file = here("data","intermediate","map.RDS"))
gene.norm.s <- readRDS(file = here("data","intermediate","gene.norm.RDS"))
contig.norm <- readRDS(file = here("data","intermediate","contig.norm.RDS"))
annot.s <- readRDS(file = here ("data", "intermediate", "annot.RDS"))

#Subset for PGP genes
#Parse for common food pathogens
pgp.abund <- data.frame(
  IAA = rowSums(gene.norm.s[,grep("iaa", annot.s$product_name)]),
  ACC = rowSums(gene.norm.s[,grep("acd", annot.s$product_name)]),
  NIF = rowSums(gene.norm.s[,grep("nif", annot.s$product_name)]),
  SID = rowSums(gene.norm.s[,grep("ent", annot.s$product_name)]),
  PHO = rowSums(gene.norm.s[,grep("pho", annot.s$product_name)]),
  EPS = rowSums(gene.norm.s[,grep("eps", annot.s$product_name)]),
  CHI = rowSums(gene.norm.s[,grep("chi", annot.s$product_name)])
  #HCN = rowSums(gene.norm.s[,grep("hcn", annot.s$product_name)])
)

#Long format for plotting
pgp.map <- cbind(map,pgp.abund)
pgp.map.long <- gather(pgp.map,pgpgen,relabund,3:7)

#Plot - stack barchart
pgp.plot <- ggplot(pgp.map.long, aes(x =Heat, y = 100*relabund, fill = pgpgen)) +
  geom_bar(stat = "summary", fun ="mean", position = "stack") +
  labs(y = "Relative abundance (%)", x="Treatment") +
  facet_grid(Origin~., scales = "free") +
  #scale_y_continuous(limits = c(0,3.5), expand = c(0,0)) +
  scale_x_discrete(labels=c("Heated", "Not heated"))+
  theme_bw()+
  scale_fill_manual(values = c("#264653", "#F4A261", "#E56B6F", "#62929E", "#5B8E7D","#8EA8C3", "#BCB8B1","#30AB65","#FFC857","#BDD9BF","#F9844A"))

pgp.plot
