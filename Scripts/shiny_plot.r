#--------- get plots
suppressWarnings(
  suppressMessages(
    source("scripts/plotly_phenopca.r")))

# SHINY
library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel(h1("PCAs of Genes by Function", align = 'center')),
  
  sidebarLayout(
    sidebarPanel(
      p('Select function group'),
      radioButtons("radio", h3("PCA"),
                   choices = list("root" = 1, "leaf" = 2,
                                  "flower" = 3),selected = 1),
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Root", 
                 plotlyOutput('root_plot', height = '650px')), 
        tabPanel("Leaf", 
                 plotlyOutput('leaf_plot', height = '650px')), 
        tabPanel("Reproductive",
                 plotlyOutput('repro_plot', height = '650px')),
        tabPanel('Recruitment',
                 plotlyOutput('recruit_plot', height = '650px'))
      )
      
      ),
    position = 'right'
  )
)

# Define server logic ----
server <- function(input, output) {
  
  output$root_plot <- renderPlotly(rp)
  output$leaf_plot <- renderPlotly(lp)
  output$repro_plot <- renderPlotly(fp)
  output$recruit_plot <- renderPlotly(gp)
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
