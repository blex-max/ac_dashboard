#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#--------- get plots
suppressWarnings(
    suppressMessages(
        source("Scripts/plotly_phenopca.r")))

# SHINY
library(shiny)
library(shinythemes)

# Define UI ----
ui <- fluidPage(theme = shinytheme('flatly'),
                
                navbarPage(collapsible = T,
                           p('Conservation Genomics: ', em('Aegiphila Caymanensis')),
                           
                           tabPanel('Background',
                                    
                                    uiOutput('slide_display', 
                                             align = 'center'
                                             ),
                                    column(4,
                                           HTML('&emsp;'),
                                           wellPanel(
                                               sliderInput('slide_choice',
                                                           label = 'Slide',
                                                           min = 1,
                                                           max = 5,
                                                           value = 1,
                                                           step = 1,
                                                           round = T,
                                                           ticks = F,
                                                           width = '300px'
                                                           ),
                                            align = 'center'),
                                           HTML('&emsp;'),
                                        offset = 4)
                                    
                           ),
                           
                           tabPanel('Local Adaptation',
                                    titlePanel(h1("Local Adaptation in an Edge-of-Extinction Species ")),
                                    
                                    br(),
                                    
                                    sidebarLayout(
                                        sidebarPanel(
                                            helpText(em(h4('Searching for evolution in real-time'))),
                                            p('The following PCAs detail a search for local adaptation in the Critically Endangered plant species ',
                                              em('Aegiphila caymanensis'),
                                              '. Each PCA shows genetic variation, decomposed into principle axes, allowing us to visualise a wealth of genetic polymorphism in an interpretable 3D space.',
                                              br(),
                                              br(),
                                              'Each marker represents one of the 10 remaining individuals of the species, and the colours indicate the two geographically distinct populations. The ',
                                              strong(span("red", style = "color:red")),
                                              ' population is found on exposed rocky cliff faces, whereas the ',
                                              strong(span("blue", style = "color:blue")),
                                              ' population is found wet farmland soil.',
                                              br(),
                                              br(),
                                              'Lines drawn between individuals indicate k-medoids clustering; the clustering informs us as to whether genetic divergence within the species matches geographic separation. Grouping genes by function allows us to target our search using prior information about the plant\'s lifestyle. Differences in soil type are most likely to lead to unique specialisations in roots and recruitment; by performing clustering seperately on each group, and filtering out all other genes, we minimise the chance of signal being masked by background variation. In this case, clustering does not separate the populations, indicating local adaptation is unlikely.'
                                            )
                                        ),
                                        
                                        mainPanel(
                                            tabsetPanel(
                                                tabPanel(h4("Examine"),
                                                         column(3,
                                                                br(),
                                                                br(),
                                                                br(),
                                                                br(),
                                                                br(),
                                                                br(),
                                                                br(),
                                                                wellPanel(
                                                                    helpText('Use dropdown to switch displayed PCA'),
                                                                    selectInput("gene_group", 
                                                                                label = 'Gene Function Group',
                                                                                choices = c("Root", "Leaf", "Reproduction", 'Recruitment'),
                                                                                selected = 1)),
                                                                align = 'center'
                                                         ),
                                                         
                                                         column(8,
                                                                plotlyOutput('plot_choice', height = '650px'
                                                                )
                                                         )
                                                ),
                                                
                                                tabPanel(h4("Compare"),
                                                         fluidRow(
                                                             
                                                             column(6,
                                                                    plotlyOutput('root_plot', height = '300px'),
                                                                    em(h5(textOutput('r_title'))),
                                                                    align = 'center'
                                                             ),
                                                             
                                                             column(6,
                                                                    plotlyOutput('leaf_plot', height = '300px'),
                                                                    em(h5(textOutput('l_title'))),
                                                                    align = 'center'
                                                             )
                                                         ),
                                                         
                                                         fluidRow(
                                                             
                                                             column(6,
                                                                    plotlyOutput('flower_plot', height = '300px'),
                                                                    em(h5(textOutput('f_title'))),
                                                                    align = 'center'
                                                             ),
                                                             
                                                             column(6,
                                                                    plotlyOutput('recruit_plot', height = '300px'),
                                                                    em(h5(textOutput('g_title'))),
                                                                    align = 'center'
                                                             )
                                                         )
                                                )
                                            )
                                        ),
                                        
                                        position = 'right'
                                        
                                    )
                           ),
                           tabPanel('Breeding Pair Selection')
                )
)
