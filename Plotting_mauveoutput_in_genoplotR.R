library(genoPlotR)
library(tidyverse)
setwd("~/Documents/SBRL/Research_Projects/Baculovirus_research/Mauve_alignment/Full_NPV/")

bbone <- read_mauve_backbone("Full_NPV_mauve_genoplotR.backbone")
names <- c("Bmori", "Aper_Liaoning", "Apro_TkhulenIBD", "Apro_Manipur", "Ayama_Nagano", "Scyn_Nagano", "Sric_SonLa", "Sric_Guangxi", "Sric_Mondulkiri")
names(bbone$dna_segs) <- names
for (i in 1:length(bbone$comparisons)){
  cmp <- bbone$comparisons[[i]]
  bbone$comparisons[[i]]$length <- abs(cmp$end1 - cmp$start1) + abs(cmp$end2 - cmp$start2)
}
tree_file <- readLines("Full_NPV_mauve_genoplotR.guide_tree")
for (i in 1:length(names)){
  tree_file <- gsub(paste("seq", i, sep=""), names[i], tree_file)
}
tree <- newick2phylog(tree_file)

pdf(file = "Full_NPV_mauve_genoplotR.pdf",
    width = 5,        # 5 x 300 pixels
    height = 4,
    paper = "a4",
    pointsize = 8)
plot_gene_map(dna_segs=bbone$dna_segs, comparisons=bbone$comparisons,
              global_color_scheme=c("length", "increasing", "red_blue", 0.6),
              override_color_schemes=TRUE)
dev.off()
