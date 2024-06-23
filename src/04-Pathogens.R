###Look for common food pathogens: Listeria, E coli, Salmonella

#Load objects
map <- readRDS(file = here("data","intermediate","map.RDS"))
gene.norm.s <- readRDS(file = here("data","intermediate","gene.norm.s.RDS"))
contig.norm <- readRDS(file = here("data","intermediate","contig.norm.RDS"))
annot.s <- readRDS(file = here ("data", "intermediate", "annot.s.RDS"))

#Parse for common food pathogens
patho.abund <- data.frame(
  Listeria = rowSums(gene.norm.s[,annot.s$tax_genus == "Listeria"]),
  Escherichia = rowSums(gene.norm.s[,annot.s$tax_genus == "Escherichia"]),
  Salmonella = rowSums(gene.norm.s[,annot.s$tax_genus == "Salmonella"]),
  #Shigella = rowSums(gene.norm.s[,annot.s$tax_genus == "Shigella"]),
  #Campylobacter = rowSums(gene.norm.s[,annot.s$tax_genus == "Campylobacter"]),
  Clostridium = rowSums(gene.norm.s[,annot.s$tax_genus == "Clostridium"]),
  #Bacillus = rowSums(gene.norm.s[,annot.s$tax_genus == "Bacillus"]),
  BacillusCereus = rowSums(gene.norm.s[,annot.s$tax_specie == "Bacillus cereus"])
)

#Long format for plotting
patho.map <- cbind(map,patho.abund)
patho.map.long <- gather(patho.map,Pathogen,relabund,3:7)

#Plot - stack barchart
patho.plot <- ggplot(patho.map.long, aes(x =Heat, y = 100*relabund, fill = Pathogen)) +
  geom_bar(stat = "summary", fun ="mean", position = "stack") +
  labs(y = "Relative abundance (%)", x="Treatment") +
  facet_grid(Origin~., scales = "free") +
  #scale_y_continuous(limits = c(0,3.5), expand = c(0,0)) +
  scale_x_discrete(labels=c("Heated", "Not heated"))+
  theme_bw()+
  scale_fill_manual(values = c("#264653", "#F4A261", "#E56B6F", "#62929E", "#5B8E7D","#8EA8C3", "#BCB8B1","#30AB65","#FFC857","#BDD9BF","#F9844A"))
  
patho.plot
