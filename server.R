# Define server logic ----
server <- function(input, output) {
  
  output$slide_display <- renderUI({
    tags$img(src = paste0('Slide', input$slide_choice, '.jpg'), height = '576px', width = '1024px')
  })
  
  output$plot_choice <- renderPlotly({
    switch(input$gene_group,
           "Root" = rp,
           "Leaf" = lp,
           "Reproduction" = fp,
           "Recruitment" = gp)
  })
  
  output$root_plot <- renderPlotly(rp)
  output$r_title <- renderText('Root')
  
  output$leaf_plot <- renderPlotly(lp)
  output$l_title <- renderText('Leaf')
  
  output$flower_plot <- renderPlotly(fp)
  output$f_title <- renderText('Reproduction')
  
  output$recruit_plot <- renderPlotly(gp)
  output$g_title <- renderText('Recruitment')
  
}