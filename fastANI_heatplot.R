### fastANI plot with 150 Enterobacter genera complete genomes
library(ggplot2)
library(here)
library(gplots)

sample_names <-read.table(here("data/processed/fastANI/fastANI_output.txt.matrix"), skip = 1)
distances <- scan(here("data/processed/fastANI/fastANI_output.txt.matrix"),
                  quiet = TRUE,
                  sep = "\t",
                  what = character())

n_samples <- as.numeric(distances[1])
distances <- distances[-1]

distance_matrix <- matrix(0, nrow = n_samples, ncol = n_samples)
samples <- rep("", n_samples)

samples[1] <- distances[1]
distances <- distances[-1]

for(i in 2:n_samples){
  samples[i] <- distances[1]
  distances <- distances[-1]
  
  distance_matrix[i, 1:(i-1)] <- as.numeric(distances[1:(i-1)])
  distance_matrix[1:(i-1), i] <- distance_matrix[i, 1:(i-1)]
  distances <- distances[-(1:(i-1))]
}
distance_matrix[distance_matrix == 0] <- 100

rownames(distance_matrix) <- sample_names$V1
colnames(distance_matrix) <- sample_names$V1

row_distance = dist(distance_matrix, method = "manhattan")
row_cluster = hclust(row_distance, method = "ward.D")
col_distance = dist(t(distance_matrix), method = "manhattan")
col_cluster = hclust(col_distance, method = "ward.D")

pdf(file = "fastANI.pdf",
    width = 7,        # 5 x 300 pixels
    height = 7,
    paper = "a4",
    pointsize = 8) # smaller font size

png("fastANI.png",
    width = 5*1000,        # 5 x 300 pixels
    height = 5*1000,
    res = 1000,            # 300 pixels per inch
    pointsize = 8)

svg(filename = "fastANI.svg",
    width = 9, height = 9, pointsize = 8)

heatmap.2(distance_matrix,
          #  cellnote = mat_data,  # same data set for cell labels
          main = "fastANI", # heat map title
          # notecol = "black",      # change font color of cell labels to black#
          density.info = "none",  # turns off density plot inside color legend
          trace = "none",         # turns off trace lines inside the heat map
          col = bluered,
          margins=c(8,8),
          cexCol=0.5/log10(ncol(distance_matrix)),
          cexRow=0.5/log10(nrow(distance_matrix)),
          Rowv = as.dendrogram(row_cluster), # apply default clustering method
          Colv = as.dendrogram(col_cluster),
          key.par = list(mar=c(6,1,6,1))) # apply default clustering method

dev.off()