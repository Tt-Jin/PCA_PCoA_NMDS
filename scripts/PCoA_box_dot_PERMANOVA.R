library(vegan)
library(ggplot2)
library(patchwork)


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

## PCoA analysis with vegan ------------------------
data <- read.table('input_data.xls', header = TRUE, 
                   row.names = 1, sep = "\t", comment.char = "", check.names = FALSE)
data <- t(data)

distance <- vegdist(data, method = 'bray') #calculate distance
write.csv(as.matrix(distance), 'results\\samples_distance.csv', quote = F)

pcoa <- cmdscale(distance, k = 5, eig = TRUE)
points <- data.frame(scores(pcoa))
point  <- data.frame(sample = row.names(points), points) 
write.csv(point, file = "results\\PCoA_coordinates.csv", row.names = FALSE)

pc1 <- round((pcoa$eig/sum(pcoa$eig))*100,2)[1]
pc2 <- round((pcoa$eig/sum(pcoa$eig))*100,2)[2]


## PCoA plot using ggplot2 ------------------------
colnames(points)[1:2] <- c('dim1', 'dim2')
plotdata = data.frame(rownames(points), points$dim1, points$dim2, groups$group)
colnames(plotdata)=c("sample","dim1","dim2","group")


## p value ------------------------
adonis_result_dis <- adonis2(distance ~ group, data = groups, permutations = 999)

R2 = adonis_result_dis$R2[1]
pvalue = adonis_result_dis$`Pr(>F)`[1]

adonis <- paste("PERMANOVA:\nR2 = ", round(R2,4), "\nP-value = ", pvalue)


## PCoA plot + boxplot using ggplot2 ------------------------
plot <- ggplot(plotdata, aes(dim1, dim2)) + 
  geom_point(aes(colour = group, shape = group), size = 6) + 
  #geom_text(aes(label = sample), size = 4, family = "Arial", hjust = 0.5, vjust = -1)+ # display sample names
  scale_shape_manual(values = pich) + 
  scale_colour_manual(values = col) +
  #labs(title = "PCoA Plot") + 
  xlab(paste("PCoA axis1 ( ",pc1,"%"," )", sep = "")) + 
  ylab(paste("PCoA axis2 ( ",pc2,"%"," )", sep = "")) +
  theme(plot.title = element_text(hjust = 0.5, size = 18, colour = "black", face = "bold")) +
  geom_vline(xintercept = 0, linetype = "dotted") +
  geom_hline(yintercept = 0, linetype = "dotted") +
  theme(panel.background = element_rect(fill = 'white', colour = 'black'), 
        panel.grid = element_blank(), 
        axis.title = element_text(color = 'black', family = "Arial", size = 20),
        axis.text = element_text(colour = 'black', size = 16, margin = unit(0.6, "lines")),
        axis.ticks = element_line(color = 'black'), 
        axis.ticks.length = unit(0.4, "lines"), 
        legend.title = element_blank(),
        legend.text = element_text(family = "Arial", size = 14),
        legend.key = element_blank(),
        legend.position = c(0.9, 0.1),
        legend.background = element_rect(colour = "black")) +
  guides(col = guide_legend(ncol = n), shape = guide_legend(ncol = n)) + 
  stat_ellipse(aes(x = dim1,y = dim2, color = group), data = plotdata) # group cluster

box1 <- ggplot(plotdata, 
                   aes(x = groups$group, y = dim1, fill = groups$group)) +
  geom_boxplot(show.legend = FALSE) + 
  stat_boxplot(geom = "errorbar", width = 0.1, size = 0.5) +
  geom_jitter(show.legend = FALSE) + 
  scale_fill_manual(values = col) +
  coord_flip() + 
  theme_bw() +
  theme(panel.grid=element_blank(), 
        axis.title = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.ticks = element_line(color='black'),
        axis.text.x = element_blank(),
        axis.text.y = element_text(colour = 'black', size = 16))

box2 <- ggplot(plotdata,
                   aes(x = groups$group, y = dim2, fill = groups$group)) + 
  geom_boxplot(show.legend = FALSE) +
  stat_boxplot(geom = "errorbar", width = 0.1, size = 0.5) +
  geom_jitter(show.legend = FALSE) + 
  scale_fill_manual(values = col) +
  theme_bw() +
  theme(panel.grid=element_blank(), 
        axis.title = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.ticks = element_line(color='black'),
        axis.text.x = element_text(colour ='black', size = 16, angle = 45,
                                   vjust = 1, hjust = 1), 
        axis.text.y=element_blank())

box3 <- ggplot(plotdata, aes(dim1, dim2)) +
  geom_text(aes(x = -0.5,y = 0.6,
                label = adonis), 
            size = 4) +
  theme_bw() +
  xlab("") + ylab("") +
  theme(panel.grid=element_blank(), 
        axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank())

p <- box1 + box3 + plot + box2 +
  plot_layout(heights = c(1,4), widths = c(4,1), ncol = 2, nrow = 2)

cairo_pdf(filename = "results\\PCoA_box_dot_combine.pdf", height = 8, width = 8)
p
dev.off()

png(filename = "results\\PCoA_box_dot_combine.png",res = 600, height = 5400, width = 5400, type = "cairo")
p
dev.off()


