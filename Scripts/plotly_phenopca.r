#--------- get geninds
suppressWarnings(
  suppressMessages(
    source("scripts/sort_genes_by_pheno.r")))


#--------- Plotly

library(plotly)

clust3d <- \(x, k, eig) {
  
  fig <- plot_ly() %>% config(displayModeBar = FALSE)
  
  fig <- add_markers(fig,
                     x = ~ x$RS1,
                     y = ~ x$RS2,
                     z = ~ x$RS3,
                     color = x$soiltype,
                     colors = c('#BF382A', '#0C4B8E'),
                     marker = list(size = 5.5),
                     showlegend = F)
  
  for (ik in 1:k) {
    for (nb in 1:sum(x$clust == ik)) {
      
      fig <- add_trace(fig,
                       x = c(x[x$med_id == 1 & x$clust == ik,][[1]], x$RS1[x$clust == ik & x$med_id == 0][nb]),
                       y = c(x[x$med_id == 1 & x$clust == ik,][[2]], x$RS2[x$clust == ik & x$med_id == 0][nb]),
                       z = c(x[x$med_id == 1 & x$clust == ik,][[3]], x$RS3[x$clust == ik & x$med_id == 0][nb]),
                       type = 'scatter3d',
                       mode = 'lines',
                       line = list(width = 3, color = 'grey'),
                       showlegend = F)
    }
    
  }
  
  
  fig <- layout(fig,
                scene = list(xaxis = list(title = paste0('PC1 (', round(eig[1], 2), '%)')),
                             yaxis = list(title = paste0('PC2 (', round(eig[2], 2), '%)')),
                             zaxis = list(title = paste0('PC3 (', round(eig[3], 2), '%)'))
                             )
                )
  
  return(fig)
}


rp <- clust3d(root.co[[1]], k = sum(root.co[[1]]$med_id), eig = root.co[[2]])
lp <- clust3d(leaf.co[[1]], k = sum(leaf.co[[1]]$med_id), eig = leaf.co[[2]])
fp <- clust3d(flower.co[[1]], k = sum(flower.co[[1]]$med_id), eig = flower.co[[2]])
gp <- clust3d(germ.co[[1]], k = sum(germ.co[[1]]$med_id), eig = germ.co[[2]]/10)


