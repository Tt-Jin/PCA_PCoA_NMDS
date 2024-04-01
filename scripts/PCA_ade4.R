library(ade4)
library(RColorBrewer)
library(ggplot2)


## Plotting settings ------------------------

groups <- read.table('group_info.txt', header = FALSE, colClasses=c("character","character"))
colnames(groups) <- c("sample", "group")

length  <- length(unique(as.character(groups$sample)))
length1 <- length(unique(as.character(groups$group)))
times1  <- length%/%8
res1    <- length%%8
times2  <- length%/%5
res2    <- length%%5

# dot color and number
mycol = c("#B2182B","#E69F00","#56B4E9","#009E73",
          "#F0E442","#0072B2","#D55E00","#CC79A7",
          "#CC6666","#9999CC","#66CC99","#99999","#ADD1E5")
col1=rep(mycol,times1)
col=c(col1,mycol[1:res1])

# dot shape and number
pich1 <- rep(c(15:18,20,7:14,0:6),times2)
pich  <- c(pich1,15:(15+res2))

# legend column number
if(length1>30){
  n = 2
}else{
  n = 1
}



## PCA analysis using ade4 ------------------------

data <- read.table('input_data.xls', header = TRUE, 
                     row.names = 1, sep = "\t", comment.char = "", check.names = FALSE)
data <- t(data)

pca <- dudi.pca(data[,1:ncol(data)], 
                 center = TRUE, scale = TRUE, scannf = FALSE, 
                 nf=5)

uoas <- pca$li
uoa  <- data.frame(sample = row.names(uoas), uoas) 
write.csv(uoa, file = "results\\PCA_coordinates_ade4.csv", row.names = FALSE)

pc1 <- round((pca$eig/sum(pca$eig))*100,2)[1]
pc2 <- round((pca$eig/sum(pca$eig))*100,2)[2]



## PCA plot using ggplot2 ------------------------

colnames(uoas)[1:2] <- c('dim1', 'dim2')
plotdata = data.frame(rownames(uoas), uoas$dim1, uoas$dim2, groups$group)
colnames(plotdata)=c("sample","dim1","dim2","group")

plot <- ggplot(plotdata, aes(dim1, dim2)) + 
  geom_point(aes(colour = group, shape = group), size = 6) + 
  geom_text(aes(label = sample), size = 4, family = "Arial", hjust = 0.5, vjust = -1)+ # display sample names
  scale_shape_manual(values = pich) + 
  scale_colour_manual(values = col) +
  #labs(title = "PCA Plot") + 
  xlab(paste("PCA axis1 ( ",pc1,"%"," )", sep = "")) + 
  ylab(paste("PCA axis2 ( ",pc2,"%"," )", sep = "")) +
  theme(plot.title = element_text(hjust = 0.5, size = 18, colour = "black", face = "bold")) +
  geom_vline(xintercept = 0, linetype = "dotted") +
  geom_hline(yintercept = 0, linetype = "dotted") +
  theme(panel.background = element_rect(fill = 'white', colour = 'black'), 
        panel.grid = element_blank(), 
        axis.title = element_text(color = 'black', family = "Arial", size = 15),
        axis.text = element_text(colour = 'black', size = 14, margin = unit(0.6, "lines")),
        axis.ticks = element_line(color = 'black'), 
        axis.ticks.length = unit(0.4, "lines"), 
        axis.line = element_line(colour = "black"), 
        legend.title = element_blank(),
        legend.text = element_text(family = "Arial", size = 14),
        legend.key = element_blank()) +
  guides(col = guide_legend(ncol = n), shape = guide_legend(ncol = n))
  #stat_ellipse(aes(x = dim1,y = dim2, color = group), data = plotdata) # group cluster

ggsave("results\\PCA_ade4.pdf", device = cairo_pdf, height = 10, width = 12)

png(filename = "results\\PCA_ade4.png", res = 600, height = 5400, width = 7200, type = "cairo")
print(plot)
dev.off()

