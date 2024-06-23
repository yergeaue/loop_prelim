###Load raw data, manipulate, normalize and save as intermediate files for other scripts

#mapping file
map <- read.table(file = here("data", "raw", "mapping_file.tsv"), row.names = 1, header = T, sep = "\t", comment.char = "") #6 obs in 2 var

#gene abundance table 
gene <- read.table(file = here("data", "raw", "merged_gene_abundance.tsv"), header = T, row.names = 1, sep = "\t") #272,524 obs of 6 var

#Contig abundance table
contig <- read.table(file = here("data", "raw", "merged_contig_abundance.tsv"), header = T, row.names = 1, sep = "\t") #95,725 obs of 6 var

#annotations
annot <- read.table(file = here("data", "raw", "annotations.tsv"), quote = "", comment.char = "", header = T,  sep = "\t") #272524 obs of 38 var

#Normalize abundance tables
gene.norm <-  data.frame(apply(gene, 1, "/", colSums(gene))) # 6 obs. of 272524 variables
contig.norm <-  data.frame(apply(contig, 1, "/", colSums(contig))) #6 obs. of 95,725 variables

#Check sorting
rownames(map) == row.names(gene.norm) #All TRUE
rownames(map) == row.names(contig.norm) #All TRUE

#Save intermediate
saveRDS(map, file = here("data","intermediate","map.RDS"))
saveRDS(gene, file = here("data","intermediate","gene.RDS"))
saveRDS(gene.norm, file = here("data","intermediate","gene.norm.RDS"))
saveRDS(contig, file = here("data","intermediate","contig.RDS"))
saveRDS(contig.norm, file = here("data","intermediate","contig.norm.RDS"))
saveRDS(annot, file = here("data","intermediate","annot.RDS"))
