#************************************************* UI SCRIPT ***************************************************************

#LOADING ALL SCRIPT IN GLOBAL ENVIRONNEMENT --------------
{
  source(file = "Packages/Packages.R", local = TRUE, encoding = "UTF8")
  source(file = "Functions/functions.R", local = TRUE, encoding = "UTF8")
}


# USER INTERFACE SCRIPT -------------------------------------
{
  
  ui_tool <- navbarPage(
    
    ######################## #
    #### DESCRIPTION ####### #
    ######################## #
    
    tabPanel("Description", dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(disable = T, theme = theme_blue_gradient),
      dashboardBody(
        uiOutput('app_docu')
        
        
        
      )
    )),
    
    
    
    ################# #
    #### PCLM ####### #
    ################# #
    
    tabPanel("Modelisation PCLM", dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(disable = T, theme = theme_blue_gradient),
      dashboardBody(
        h3("1) Input"),
        useShinydashboardPlus(),
        fluidRow(column(3, selectInput(
          "demo_dt", "Choose a Demo Data ?" , choices = c(
            "No",
            "Yes"))),
          column(3,conditionalPanel("input.demo_dt== 'No' ",
                                    fileInput(inputId = "first_page.data", label = "Upload Your data")))),
        
        
        # column(3,actionBttn(inputId = 'Load_data',label='Load & test data',style = 'fill',size = 'sm',color = "danger"))),
        h3("2) Parameters"),
        
        fluidRow( 
          column(2, sliderInput(inputId = "first_page.nlast", label =h6("Length of the last age interval"), min = 10, max = 30, value = 20)),
          column(2, sliderInput(inputId = "first_page.ci.level", label = h6("Confidence level"), min = 60, max = 98, value = 90)),
          column(3, sliderInput(inputId = "first_page.out_step", label = h6("Outstep"), min = 0, max = 1, value = 1, step = 0.25)),
          column(3, materialSwitch(inputId = "first_page.offset", label = "Activate Offset (estimate smooth death rates)", value = FALSE, status = "success"))
        ),
        h3("3) Optimisation of smoothing Parameters"),
        br(),
        fluidRow(
          column(3, awesomeRadio(
            inputId = "metric", label = "Choose your metric",
            choices = c("BIC", "AIC")
          )),
          column(3, sliderInput(inputId = "deg", label = "Degree of splines", min = 1, max = 10, value = 3)),
          column(3, sliderInput(inputId = "kr", label = "Knot Ratio", min = 1, max = 10, value = 2))
        ),
        br(),
        box(
          solidHeader = FALSE,
          title = "Status summary",
          background = NULL,
          width = 12,
          status = "danger",
          collapsible = T,
       withSpinner(   DT::dataTableOutput("table"),type=5),
          br(),
          
         withSpinner( plotOutput("plot"), type=5),
          screenshotButton(label = "Download plot",id= "",filename = "Screenshot")
        ),
        #actionBttn(inputId = "screenshot.plot", label="Capture plot", style = 'fill',size = 'sm',color = "primary")),
        br(),
        
      )
    )),
    
    tabPanel("Modelisation PCLM 2D", dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(disable = T, theme = theme_blue_gradient),
      dashboardBody(
        h3("1) Input"),
        useShinydashboardPlus(),
        # fluidRow(column(1, selectInput(
        #   "demo2_dt", "Choose a Demo Data ?", choices = c(
        #     "No",
        #     "Yes"))),
        #   column(2,conditionalPanel("input.demo2_dt== 'No' ",
        #                            fileInput(inputId = "second_page.dataDx", label = "Upload your grouped data")))),
        # 
        # fluidRow(column(2,fileInput(inputId = "second_page.dataEx", label = "Upload your offset data")),
        # 
        #         column(2, materialSwitch(inputId = "second_page.offset", label = "Activate Offset (estimate smooth death rates)", value = FALSE, status = "success"))
        # ),

        fluidRow(column(3, selectInput(
          "demo2_dt", "Choose a Demo Data ?", choices = c(
            "No",
            "Yes"))),
          column(3,conditionalPanel("input.demo2_dt== 'No' ",
                                    fileInput(inputId = "second_page.dataDx", label = "Upload your grouped data"))),
          column(3,conditionalPanel("input.demo2_dt== 'No' ",
                                      fileInput(inputId = "second_page.dataEx", label = "Upload your Offset"))),
          column(3, materialSwitch(inputId = "second_page.offset", label = "Activate Offset (estimate smooth death rates)", value = FALSE, status = "success"))
        ),
        h3("2) Parameters"),
        fluidRow(
          column(2, sliderInput(inputId = "second_page.nlast", label = "Last age interval", min = 10, max = 30, value = 20)),
          column(2, sliderInput(inputId = "second_page.ci.level", label = "Confidence level ", min = 60, max = 98, value = 90)),
          column(3, sliderInput(inputId = "second_page.out_step", label = "Outstep (year,semester,...) ", min = 0, max = 1, value = 1, step = 0.25)),
          
          column(2, numericInput(inputId = "second_page.min", label = "min year", min = 1000,value=1980, max = 2200)),
          column(2, numericInput(inputId = "second_page.max", label = "max year", min = 1000,value=1988, max = 2200))
        ),
        
        
        h3("3) Optimisation of smoothing Parameters"),
        
        fluidRow(
          column(3, awesomeRadio(
            inputId = "metric1", label = "Choose your metric",
            choices = c("AIC", "BIC")
          )),
          column(3, sliderInput(inputId = "deg1", label = "Degree of splines", min = 1, max = 10, value = 3)),
          column(3, sliderInput(inputId = "kr1", label = "Knot Ratio", min = 1, max = 10, value = 3))
        ),
        box(
          solidHeader = FALSE,
          title = "Status summary (Small values for smoothing rates) ",
          background = NULL,
          width = 8,
          status = "danger",
          collapsible = T,
          withSpinner(DT::dataTableOutput("table1"),type=8),
          br(),
          
          fluidRow(column(12,
                          column(6,withSpinner(plotOutput("plot1"),type=8))   ,
                          column(6,withSpinner(plotOutput('plot1o'),type=8))
          ))
          ,
          screenshotButton(label = "Download the plot",id= "",filename = "Screenshot")
        )
        
      )
    )),
    
    ################### #
    #### SPLINE ####### #
    ################### #
    
    tabPanel("Spline Modelisation", dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(disable = T, theme = theme_blue_gradient),
      dashboardBody(
        h3(strong("1) Input")),
        useShinydashboardPlus(),
        fluidRow(column(3, selectInput(
          "demo3_dt", "Choose a Demo Data ?" , choices = c(
            "No",
            "Yes"))),
          column(3,conditionalPanel("input.demo3_dt== 'No' ",
                                    fileInput(inputId = "third_page.data", label = "Upload Your data")))),
        
      strong("2) Parameters"),
        fluidRow(
          column(2, numericInput(inputId = "third_page.age_min", label=h6("Lowest age : "), value = 1, step = 1, min = 0, width = 75),
                 numericInput(inputId = "third_page.age_max", label=h6("Highest age : "), value = 110, step = 1, min = 0, width = 75)),
          column(3, sliderInput(inputId = "third_page.out_step", label = h6("Interval size of the output?"), min = 0, max = 5, value = 1, step = 0.1)),
          column(3, awesomeRadio(inputId = "delay_spline", label = h6("Delay the inputs?"), choices = c("no", "yes"))),
                 #awesomeRadio(inputId = "correct_spline", label = h6("Correct the output?"), choices = c("no", "yes"))),
          column(3, awesomeRadio(inputId = "spline_method", label = h6("Choose your method"), choices = c("fmm", "natural", "periodic"))),
          column(2, uiOutput("ui.control_display.3"))
        ),
        br(),
        br(),
        
        box(
          solidHeader = FALSE, title = "Spline summary", background = NULL, width = 12, status = "danger", collapsible = T, 
          withSpinner(DT::dataTableOutput("table_spline"),type=5),
          br(),
          br(),
          
          withSpinner(plotOutput("plot_spline"),type=5)
          screenshotButton(label = "Capture plot",id= "screen_spline",filename = "Screenshot")
        ),
      )
    )),
    
    
    ################## #
    #### LOESS ####### #
    ################## #
    
    tabPanel("Loess Modelisation", dashboardPage(
      dashboardHeader(disable = T),
      dashboardSidebar(disable = T, theme = theme_blue_gradient),
      dashboardBody(
        h3(strong("1) Input")),
        useShinyalert(),
        useShinydashboardPlus(),
        fluidRow(column(3, fileInput(inputId = "fourth_page.data", label = h6("Load Your data")))),
        h3(strong("2) Parameters")),
        
        fluidRow(
          column(3, numericInput(inputId = "fourth_page.degree",label = h6("Choose the degree of the polynomial to fit"), value = 2, min = 1)),
          column(3, numericInput(inputId = "fourth_page.span", label=h6("Parameter which control the degree of smoothing"), value = 0.4, min = 0.01, max = 1)),
          column(2, uiOutput("ui.control_display.4"))
        ),
        br(),
        br(),
        
        box(
          solidHeader = FALSE, title = "Loess summary", background = NULL, width = 12, status = "danger", collapsible = T, tableOutput("table_loess"),
          br(),
          br(),
          fluidRow(
            column(3,actionBttn( inputId = "download.data.4", label = "Download your data", style = "fill", size = "sm", color = "danger")),
            column(3,offset = 1, textInput(inputId = "file_export_name.4",label= "Filename to export", placeholder = "Fitted data" )
            )
          ),
          plotOutput("plot_loess"),
          screenshotButton(label = "Capture plot",id= "screen_loess",filename = "Screenshot")
        ),
      )
    )),
    
    
    title = img(src = img_link, style = "float:right; padding-right:45px", width = 100)
  )
}
