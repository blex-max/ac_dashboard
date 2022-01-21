library(poppr)

##A81 and 82 are found on Karst... That presumably requires different roots? Perhaps we can look for genes annotated with root diversity to get an idea of whether there's structure there.
dropa77 <-
  c("A71",
    "A72",
    "A73",
    "A74",
    "A75",
    "A76",
    "A78",
    "A79",
    "A80",
    "A81",
    "A82",
    "A83")

rootgenes <-
  read.genalex("rootannotatedgenes.csv") ##c("4942", "6404", "6909", "6979", "5894")
rootgenes <- rootgenes[dropa77, ]
rootgenes <-
  missingno(rootgenes, "loci", cutoff = 0) ##drop loci with missing data
rootgenes <-
  informloci(rootgenes, cutoff = (1 / length(rootgenes$pop))) ##drop monomorphic loci

library(factoextra)
root.pca <- dudi.pca(rootgenes, scannf = FALSE, nf = 5)
fviz_eig(root.pca)

loc.xa77 <-
  c(
    "Loam",
    "Loam",
    "Loam",
    "Loam",
    "Loam",
    "Loam",
    "Loam",
    "Loam",
    "Loam",
    "Karst",
    "Karst",
    "Loam"
  )
locations.xa77 <- as.factor(loc.xa77)

fviz_pca_ind(
  root.pca,
  col.ind = locations.xa77,
  # color by groups
  axes = c(1, 2),
  palette = c("#4000F0", "#00CC00"),
  legend.title = "Soil Type",
  show.legend.text = FALSE,
  repel = TRUE,
  mean.point = FALSE,
  title = "PCA - Variation in Root Related Genes by Substrate Type",
  pointsize = 5,
  labelsize = 6,
  ggtheme = theme(
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 14)
  )
)

##No evidence of location diversity in genes annotated as having root related function. Implies no structure to population I think. Also the case when I check with uniqueness.

library(plotly)
rootco <- root.pca$l1
rootco <- cbind(rootco, c(rep("L",9), "K", "K", "L"))
colnames(rootco) <- c(colnames(rootco)[-6], "soiltype")
fig <- plot_ly(rootco, 
               x = ~RS1, 
               y = ~RS2,
               z = ~RS3,
               color = ~rootco$soiltype, 
               colors = c('#636EFA','#EF553B')) %>%
  add_markers(size = 12)

fig <- fig %>%
  layout(
    scene = list(bgcolor = "#e5ecf6")
  )

fig

