library(rgl)
foo <- cbind(runif(20, -1, 1), runif(20, -1, 1), runif(20, -1, 1), c(rep(1,10), rep(2,10)))

plot3d(x = foo[,1], 
       y = foo[,2], 
       z = foo[,3],
       xlab = '',
       ylab = '',
       zlab = '',
       col = ifelse(foo[,4] == 1, '#636EFA', '#EF553B'),
       type = 's',
       size = 2,
       xlim = c(floor(min(foo[,1])), ceiling(max(foo[,1]))),
       ylim = c(floor(min(foo[,2])), ceiling(max(foo[,2]))),
       zlim = c(floor(min(foo[,3])), ceiling(max(foo[,3]))),
       axes = F)

axes3d(fig, edges = c('x-', 'y-', 'z-+'), labels = TRUE, tick = TRUE, nticks = 5, 
       expand = 1.03, floating = F)
title3d(xlab = 'PC1', ylab = 'PC2', level = 5, floating = F)
title3d(zlab = 'PC3', line = 5, level = -20, floating = F)


planes3d(1,0,0,-ceiling(max(foo[,1])), color = "#333777", alpha = 0.6, 
         emission="#333777", specular='black', shininess=5, floating = F) #x
planes3d(0,1,0,-ceiling(max(foo[,2])), color = "#333777", alpha = 0.6, 
         emission="#333777", specular='black', shininess=5, floating = F) #y
planes3d(0,0,1,-floor(min(foo[,3])), color = "#333777", alpha = 0.6, 
         emission="#333777", specular='black', shininess=5, floating = F) #z


widge <- rglwidget()
widge
