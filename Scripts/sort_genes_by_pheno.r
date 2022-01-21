library(poppr)

arab_anot <- read.delim("Data/353annot.txt", header = FALSE)
arab_anot <- arab_anot[-1,c(1,5)]

root <- arab_anot[grep("root", arab_anot$V5),1]
leaf <- arab_anot[grep("leaf|veg", arab_anot$V5),1]
flower <- arab_anot[grep("flower|pollen", arab_anot$V5),1]
germ <- arab_anot[grep("seed|germ", arab_anot$V5),1]


gene_cat <- \(gns) {
  
  gals <- lapply(list.files(path = "./Data/DNA", pattern = paste0(gns, collapse = "|"), full.names = T), read.genalex) # read in all relevant genalexs
  gals <- lapply(gals, \(x) x[which(!rownames(x@tab) %in% c('A71', 'A72', 'A77'))])
  
  gdfs <- lapply(gals, genind2df) # convert to dataframe
  gdfs <- lapply( gdfs, \(x) cbind(rownames(x), x) ) # bind in rownames so we can merge dfs
  gdfs <- lapply(gdfs, \(y) as.data.frame(y[,apply(y, MARGIN = 2, \(x) !all(duplicated(x)[-1L]))])) # drop any monomorphic loci and pop
  
  cdf <- purrr::reduce(gdfs, merge, all.x = T, by="rownames(x)") # merge dfs
  rownames(cdf) <- cdf[,1]
  cdf <- cbind(rep(1, nrow(cdf)), cdf[,-1])
  colnames(cdf)[1] <- 'pop' # format
  
  cg <- df2genind(cdf, ncode = 1) # return to genind
  cg <- missingno(cg, 'loci', cutoff = 0) # clean up

  return(cg)
  
}

root <- gene_cat(root)
leaf <- gene_cat(leaf)
flower <- gene_cat(flower)
germ <- gene_cat(germ)

#--------- calculate PCA, cluster, extract first 3 components, and format
library(cluster)
library(factoextra)

quickpam <- \(gi) {
  
  hamdist <- poppr::diss.dist(gi) #Distance metric for optimal number of clusters
  nb <- fviz_nbclust(as.matrix(hamdist), FUNcluster = pam, k = nrow(gi$tab)-1) #si vs number of clusters for k-medoids
  kmed <- pam(x = hamdist, k = which.max(nb$data$y), metric = "manhattan", stand = FALSE)  #cluster!
  med_id <- c(1:length(kmed$clustering) %in% kmed$id.med)
  ot <- cbind(kmed$clustering, med_id)
  return(ot)
  
}


pca_co <- \(gi) {
  
  gpca <- ade4::dudi.pca(gi, scannf = FALSE, nf = 3) # generate PCA from genetic data
  co <- gpca$l1 #extract principal components
  co_eig <- gpca$eig[1:3]
  cls <- c(colnames(co), 'soiltype', 'clust', 'med_id') # prepare colnames
  co <- cbind(co, ifelse(rownames(gi@tab) %in% c('A81', 'A82'), "Karst", "Loam"), quickpam(gi)) #assign soiltype by rowname
  colnames(co) <- cls
  return(list(co, co_eig))
  
}

root.co <- pca_co(root)
leaf.co <- pca_co(leaf)
flower.co <- pca_co(flower)
germ.co <- pca_co(germ)


# clean up
rm(gene_cat, arab_anot, pca_co, quickpam)

