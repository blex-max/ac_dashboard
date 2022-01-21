library(rgl)
suppressWarnings(
  suppressMessages(
    source("scripts/sort_genes_by_pheno.r")))

pca3d <- \(x, gfunc) {
  
  fig <- plot3d(x = x$RS1, 
                y = x$RS2, 
                z = x$RS3,
                xlab = '',
                ylab = '',
                zlab = '',
                col = ifelse(x$soiltype %in% 'Karst', '#636EFA', '#EF553B'),
                size = 12,
                xlim = c(floor(min(x$RS1)), ceiling(max(x$RS1))),
                ylim = c(floor(min(x$RS2)), ceiling(max(x$RS2))),
                zlim = c(floor(min(x$RS3)), ceiling(max(x$RS3))),
                axes = F)
  
  axes3d(fig, edges = c('x-', 'y-', 'z-+'), labels = TRUE, tick = TRUE, nticks = 5, 
         expand = 1.03, floating = F)
  title3d(xlab = 'PC1', ylab = 'PC2', level = 5, floating = F)
  title3d(zlab = 'PC3', line = 5, level = -20, floating = F)
  #title3d(main = paste0(gfunc, '-Function Genes'), line = 8, level = -5, scale = 2)

  
  planes3d(1,0,0,-ceiling(max(x$RS1)), color = "#333777", alpha = 0.6, 
           emission="#333777", specular='black', shininess=5, floating = F) #x
  planes3d(0,1,0,-ceiling(max(x$RS2)), color = "#333777", alpha = 0.6, 
           emission="#333777", specular='black', shininess=5, floating = F) #y
  planes3d(0,0,1,-floor(min(x$RS3)), color = "#333777", alpha = 0.6, 
           emission="#333777", specular='black', shininess=5, floating = F) #z
  
}



mfrow3d(2,2)
#rglFonts(helvetica = 'helvetica.ttf')
#par3d(family = 'helvetica')
pca3d(root, 'Root')
bgplot3d(plot(c(0, 1), c(0, 1), xlab = '', ylab = '', bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n', main = 'Root-Function Genes'))
pca3d(leaf, 'Leaf')
bg3d('#Fff0f1')
par(bg = '#Fff0f1')
bgplot3d(plot(c(0, 1), c(0, 1), xlab = '', ylab = '', bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n', main = 'Leaf-Function Genes'))
pca3d(flower, 'Reproductive')
bg3d('#Fff0f1')
bgplot3d(plot(c(0, 1), c(0, 1), xlab = '', ylab = '', bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n', main = 'Reproductive-Function Genes'))
pca3d(germ, 'Recruitment')
bgplot3d(plot(c(0, 1), c(0, 1), xlab = '', ylab = '', bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n', main = 'Recruitment-Function Genes'))


legend3d('topright', legend = c('Loam', 'Karst'), pch = 19, col = c('#636EFA', '#EF553B'))

widge <- rglwidget()
htmlwidgets::saveWidget(widge, 'wt.html')


cube3d(color="black", alpha=0.1) %>% scale3d(4,4,4) %>% wire3d
