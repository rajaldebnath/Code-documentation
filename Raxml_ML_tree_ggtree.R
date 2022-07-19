### Generating phylogentic tree using RAxml and plotting in R using ggtree package


library(ggtree)
library(ggtreeExtra)
library(ggimage)
library(TDbook)
library(gplots)
library(tidyverse)
library(reshape2)
library(lattice)
library(grid)
library(gridExtra)
library(colorspace)
library(dendextend)
library(ape)
library(RColorBrewer)


#Obtain all the RdRp sequences (protein.fasta) and align using mafft-einsi method using web server or locally
#Download the clustal (*.aln) format alignment and convert it into phylip format (*.phy) "http://phylogeny.lirmm.fr/phylo_cgi/data_converter.cgi"

#Run RAxml program on the phylip format alignment to generate the tree
#raxmlHPC -s AaRDRP_protein_RdRp_scan.phy -n AaRDRP_protein_RdRp_scan.PROTGAMMAAUTO -m PROTGAMMAAUTO -p 12345 -T 6
#raxmlHPC-PTHREADS -s AaRDRP_protein_RdRp_scan.phy -n AaRDRP_protein_RdRp_scan.PROTGAMMAAUTO_bootstrap.r1 -N 100 -m PROTGAMMALGF -p 12345 -T 6 ##100 resulting tree and one best tree
#raxmlHPC-PTHREADS -s AaRDRP_protein_RdRp_scan.phy -n AaRDRP_protein_RdRp_scan.PROTGAMMAAUTO_bootstrap.r2 -N 100 -m PROTGAMMALGF -p 12345 -T 6 ##100 resulting tree and one best tree

#cat RAxML_result.AaRDRP_protein_RdRp_scan.PROTGAMMAAUTO_bootstrap.r* > allBootstraps

#raxmlHPC-PTHREADS -f b -z allBootstraps -t RAxML_bestTree.AaRDRP_protein_RdRp_scan.PROTGAMMAAUTO -m PROTGAMMALGF -n AaRDRP_protein_RdRp_scan.PROTGAMMALGF_bootstrap.txt

## The tree RAxML_bipartitions.AaRDRP_protein_RdRp_scan.PROTGAMMALGF_bootstrap.txt can be opened in itol webserver.


tree <- read.tree("RAxML_bipartitions.AaRDRP_protein_RdRp_scan.PROTGAMMALGF_bootstrap.txt")
tree$tip.label <- c("Erinnyis ello", "Choristoneura occidentalis", "Choristoneura occidentalis 1", "Lutzomyia sp", "Spissistilus festinus", "Acinopterus angulatus", "Thyrinteina arnobia", "Heliothis armigera", "Lymantria dispar", "Bombyx mori", "Biston robustus", "Orgyia pseudotsugata", "Thaumetopoea pityocampa", "Antheraea assamensis", "Antheraea mylitta", "Dendrolimus punctatus")

#Save all the png images in a moth directory created within the extdata directory of TDbook package
imgdir <- system.file("extdata/moths", package = "TDbook")
imgdir # "/Library/Frameworks/R.framework/Versions/4.1/Resources/library/TDbook/extdata/moths"
  
raxml_rdrp <- ggtree(tree, size = 1, colour = "black", alpha = 0.6) +
  geom_treescale(linesize = 3) +
  geom_tiplab(aes(image=paste0(imgdir, '/', label, ".png")),
              geom = "image", offset = 1.8, align = 2, size = 0.08) +
  geom_tiplab(geom='label', offset=1.10, hjust=.5, fontface = 3, colour = "darkred", size = 2.5) +
  #geom_tiplab(fontface = 2, align = FALSE, linesize = 0.8) +
  geom_tippoint(color="#008080", alpha=0.25, size=5) +
  geom_nodelab(aes(label=label), node = "internal", nudge_x = -0.2, nudge_y = 0.2, size = 3) +
  ggtitle("Raxml maxlikelihood \nRdRp Polymerase domain-Chain A") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  xlim(NA, 7)

raxml_rdrp
