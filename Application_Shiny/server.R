server <- function(input, output, session) {
  
  # 
  Data <- reactive({
    req(!is.null(input$first_page.data$datapath))
    
    tmp <- tryCatch(Test_data(path = input$first_page.data$datapath), error = function(e) {
      shinyalert(title = " ", text = geterrmessage(), type = "error")
    })
    
    req(any(class(tmp) %in% c("data.frame", "tbl")))
    
    shinyalert(title = " ", text = "GOOD JOB", type = "success")
    return(tmp)
  })
  a=read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vR9T1H-xoJOxKAWsHMLYrDq-kzGqq56barXMbxLMxyJ7W94LRBi3sxXOjuaxPWmpGQV7-9oOGNhua07/pub?output=csv",sep=";")
  b=read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTU71_plU-WfkfY9mrXnf2DJyvaPrwqk4y7rUEZyzcUCOJFRdp1oq18fvxnot18CrvPHAfgI8bVlpEp/pub?output=csv",sep=";")
  colnames(b)=c(colnames(b)[1], as.numeric(gsub("X","",  colnames(b)[-1])))
  
  c=read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRyTgkdT7vWxxCjSnnqr8OuxSU6y8WsC0Z9jgmBGgBJuPPQhF9mNfNvaaObXno-ZYmDOEeN62toqmeL/pub?output=csv" ,sep=";")
  colnames(c)=c(colnames(c)[1], as.numeric(gsub("X","",  colnames(c)[-1])))
  
  
  
  #Displaying table in the box --------
  observeEvent(input$demo_dt,{
    if  (input$demo_dt=="No"){
      output$table <- DT::renderDataTable({
        
        
        Model_pclm(Data(),nlast=input$first_page.nlast,
                   ci.level = input$first_page.ci.level,
                   out.step = input$first_page.out_step,
                   opt.method=input$metric,
                   kr =  input$kr,
                   deg = input$deg,
                   offset = input$first_page.offset)$data[-1] %>%
          # filter(between(age_min, input$control.display[1], input$control.display[2])) %>%
          # select(value) %>%
          # t() %>%
          as.data.frame()%>%
          
          datatable(.,extensions = c('Buttons', 'Scroller'), 
                    options = list(
                      dom = 'Bfrtip',
                      
                      deferRender = TRUE,
                      scrollY = 400,
                      scroller = TRUE,
                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      # exportOptions = list(header = ""),
                      # buttons = list(
                      #   list(extend = 'copy', title = "My custom title"), 
                      #   list(extend = 'csv', title = "My custom title"),
                      #   list(extend = 'excel', title = "My custom title"), 
                      #   list(extend = 'pdf', title = "My custom title"), 
                      #   list(extend = 'print', title = "My custom title") 
                      # )
                    ))
        }) }
    else{ output$table <- DT::renderDataTable({
      
      
      Model_pclm(a,nlast=input$first_page.nlast,
                 ci.level = input$first_page.ci.level,
                 out.step = input$first_page.out_step,
                 opt.method=input$metric,
                 kr =  input$kr,
                 deg = input$deg,
                 offset = input$first_page.offset)$data[-1] %>%
        # filter(between(age_min, input$control.display[1], input$control.display[2])) %>%
        # select(value) %>%
        # t() %>%
        as.data.frame()%>%
        
        datatable(.,extensions = c('Buttons', 'Scroller'), 
                  options = list(
                    dom = 'Bfrtip',
                    
                    deferRender = TRUE,
                    scrollY = 400,
                    scroller = TRUE,
                    buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                    # exportOptions = list(header = ""),
                    # buttons = list(
                    #   list(extend = 'copy', title = "My custom title"), 
                    #   list(extend = 'csv', title = "My custom title"),
                    #   list(extend = 'excel', title = "My custom title"), 
                    #   list(extend = 'pdf', title = "My custom title"), 
                    #   list(extend = 'print', title = "My custom title") 
                    # )
                  ))
      })
    
    }
    
    
  })
  
  ######################################################
  observeEvent(input$demo2_dt,{
    if  (input$demo2_dt=="No"){
  output$table1 <- DT::renderDataTable({
    
    Model_pclm2D_data(DataDx(),DataEx(),min=input$second_page.min,
                      max=input$second_page.max,
                      nlast=input$second_page.nlast,
                      ci.level=input$second_page.ci.level,
                      opt.method=input$metric1,
                      kr =  input$kr1,
                      deg = input$deg1,
                      activate_offset = input$second_page.offset,
                      out.step=input$second_page.out_step)$data %>%
      # filter(between(age_min, input$control.display[1], input$control.display[2])) %>%
      # select(value) %>%
      # t() %>%
      as.data.frame()%>%
      datatable(.,extensions = c('Buttons', 'Scroller'), 
                options = list(
                  dom = 'Bfrtip',
                  
                  deferRender = TRUE,
                  scrollY = 400,
                  scroller = TRUE,
                  buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                  # exportOptions = list(header = ""),
                  # buttons = list(
                  #   list(extend = 'copy', title = "My custom title"), 
                  #   list(extend = 'csv', title = "My custom title"),
                  #   list(extend = 'excel', title = "My custom title"), 
                  #   list(extend = 'pdf', title = "My custom title"), 
                  #   list(extend = 'print', title = "My custom title") 
                  # )
                ))
  })
    } 
    else{
      output$table1 <- DT::renderDataTable({
        
        Model_pclm2D_data(b,c,min=input$second_page.min,
                          max=input$second_page.max,
                          nlast=input$second_page.nlast,
                          ci.level=input$second_page.ci.level,
                          opt.method=input$metric1,
                          kr =  input$kr1,
                          deg = input$deg1,
                          activate_offset = input$second_page.offset,
                          out.step=input$second_page.out_step)$data %>%
          # filter(between(age_min, input$control.display[1], input$control.display[2])) %>%
          # select(value) %>%
          # t() %>%
          as.data.frame()%>%
          datatable(.,extensions = c('Buttons', 'Scroller'), 
                    options = list(
                      dom = 'Bfrtip',
                      
                      deferRender = TRUE,
                      scrollY = 400,
                      scroller = TRUE,
                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      # exportOptions = list(header = ""),
                      # buttons = list(
                      #   list(extend = 'copy', title = "My custom title"), 
                      #   list(extend = 'csv', title = "My custom title"),
                      #   list(extend = 'excel', title = "My custom title"), 
                      #   list(extend = 'pdf', title = "My custom title"), 
                      #   list(extend = 'print', title = "My custom title") 
                      # )
                    ))
      })
      
    }
    
    
    })
  
  
  
  
  #DISPLAYING THE PLOT
  observeEvent(input$demo_dt,{
    if  (input$demo_dt=="No"){
      output$plot <- renderPlot({
        req(!is.null(input$first_page.data$datapath))
        req(class(Data()) %in% c("data.frame", "tbl"))
        
        tmp <- tryCatch(Model_pclm(Data(),
                                   nlast=input$first_page.nlast,
                                   ci.level = input$first_page.ci.level,
                                   out.step = input$first_page.out_step,
                                   opt.method=input$metric,
                                   kr =  input$kr,
                                   deg = input$deg,
                                   offset = input$first_page.offset
        ), error = function(e) {
          shinyalert(title = "ERROR ", text = geterrmessage(), type = "error")
        })
        
        plot(Model_pclm(Data(),
                        nlast=input$first_page.nlast,
                        ci.level = input$first_page.ci.level,
                        out.step = input$first_page.out_step,
                        opt.method=input$metric,
                        kr =  input$kr,
                        deg = input$deg,
                        offset = input$first_page.offset
        )$model)
      })
    }
    else {output$plot <- renderPlot({
      
      
      plot(Model_pclm(a,
                      nlast=input$first_page.nlast,
                      ci.level = input$first_page.ci.level,
                      out.step = input$first_page.out_step,
                      opt.method=input$metric,
                      kr =  input$kr,
                      deg = input$deg,
                      offset = input$first_page.offset
      )$model)
    })
    
    
    }
    
  })
  
  ##############
  
  
  
  # DATA TESTED & IMPORTED 
  DataDx <- reactive({
    req(!is.null(input$second_page.dataDx$datapath))
    
    tmp1 <- tryCatch(Test_data2D(path = input$second_page.dataDx$datapath), error = function(e) {
      shinyalert(title = " ", text = geterrmessage(), type = "error")
    })
    
    req(any(class(tmp1) %in% c("data.frame", "tbl")))
    
    shinyalert(title = " ", text = "GOOD JOB", type = "success")
    print(head(tmp1,2))
    return(tmp1)
  })
  
  DataEx <- reactive({
    req(!is.null(input$second_page.dataEx$datapath))
    
    tmp2 <- tryCatch(Test_data2D(path = input$second_page.dataEx$datapath), error = function(e) {
      shinyalert(title = " ", text = geterrmessage(), type = "error")
    })
    
    req(any(class(tmp2) %in% c("data.frame", "tbl")))
    
    shinyalert(title = " ", text = "GOOD JOB", type = "success")
    print(head(tmp2,2))
    return(tmp2)
  })
  

  #DISPLAYING THE PLOT
  observeEvent(input$demo2_dt,{
    if  (input$demo2_dt=="No"){
  output$plot1 <- renderPlot({
    req(!is.null(input$second_page.dataDx$datapath))
    req(class(DataDx()) %in% c("data.frame", "tbl"))
    
    tmp1 <- tryCatch(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                                  max=input$second_page.max,
                                  nlast=input$second_page.nlast,
                                  ci.level=input$second_page.ci.level,
                                  opt.method=input$metric1,
                                  kr =  input$kr1,
                                  deg = input$deg1,
                                  activate_offset = input$second_page.offset,
                                  out.step=input$second_page.out_step
                                  
    ), error = function(e) {
      shinyalert(title = "ERROR ", text = geterrmessage(), type = "error")
    })
    
    plot(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                      max=input$second_page.max,
                      ci.level=input$second_page.ci.level,
                      nlast=input$second_page.nlast,
                      opt.method=input$metric1,
                      kr =  input$kr1,
                      deg = input$deg1,
                      
                      activate_offset = input$second_page.offset,out.step=input$second_page.out_step),type="fitted", main =" Fitted Values")
    
  })
  output$plot1o <- renderPlot({
    req(!is.null(input$second_page.dataDx$datapath))
    req(class(DataDx()) %in% c("data.frame", "tbl"))
    
    tmp1 <- tryCatch(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                                  max=input$second_page.max,
                                  ci.level=input$second_page.ci.level,
                                  nlast=input$second_page.nlast,
                                  opt.method=input$metric1,
                                  kr =  input$kr1,
                                  deg = input$deg1,
                                  activate_offset = input$second_page.offset,
                                  out.step=input$second_page.out_step
                                  
    ), error = function(e) {
      shinyalert(title = "ERROR WITH OFFSET", text = geterrmessage(), type = "error")
    })
    
    plot(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                      max=input$second_page.max,
                      ci.level=input$second_page.ci.level,
                      
                      nlast=input$second_page.nlast,
                      opt.method=input$metric1,
                      kr =  input$kr1,
                      deg = input$deg1,
                      
                      activate_offset = input$second_page.offset,out.step=input$second_page.out_step),type = "observed", main="Observed Values")
    
  })
  
    }
    else  {
      output$plot1 <- renderPlot({

        plot(Model_pclm2D(b,c,min=input$second_page.min,
                          max=input$second_page.max,
                          ci.level=input$second_page.ci.level,
                          nlast=input$second_page.nlast,
                          opt.method=input$metric1,
                          kr =  input$kr1,
                          deg = input$deg1,
                          
                          activate_offset = input$second_page.offset,out.step=input$second_page.out_step),type="fitted", main =" Fitted Values")
        
      })
      output$plot1o <- renderPlot({

        
        plot(Model_pclm2D(b,c,min=input$second_page.min,
                          max=input$second_page.max,
                          ci.level=input$second_page.ci.level,
                          
                          nlast=input$second_page.nlast,
                          opt.method=input$metric1,
                          kr =  input$kr1,
                          deg = input$deg1,
                          
                          activate_offset = input$second_page.offset,out.step=input$second_page.out_step),type = "observed", main="Observed Values")
        
      })
      
      
      
    }
    
    
    })
  
  
  
  
  #######################################################################################
  #######################################################################################
  ######## DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION DOCUMENTATION ########
  #######################################################################################
  #######################################################################################
  

  output$app_docu <- renderUI({
    HTML(markdown::markdownToHTML(knit('doc.rmd', quiet = TRUE)))
  })

  ######################################################################################
  ######################################################################################
  #### SPLINE SPLINE SPLINE SPLINE SPLINE SPLINE SPLINE SPLINE SPLINE SPLINE SPLINE ####
  ######################################################################################
  ######################################################################################
  
  
  # DATA TESTED & IMPORTED 
  Data_for_spline <- reactive({
    req(!is.null(input$third_page.data$datapath))
    
    tmp <- tryCatch(Test_data(path = input$third_page.data$datapath), error = function(e) {
      shinyalert(title = " ", text = geterrmessage(), type = "error")
    })
    
    req(any(class(tmp) %in% c("data.frame", "tbl")))
    
    shinyalert(title = " ", text = "GOOD JOB", type = "success")
    
    colnames(tmp) = c("X", "Y")
    
    return(tmp)
  })
  observeEvent(input$demo3_dt,{
    if  (input$demo3_dt=="No"){
      output$table_spline <- DT::renderDataTable({
        
        
        req(!is.null(input$third_page.data$datapath))
        req(class(Data_for_spline()) %in% c("data.frame", "tbl"))
        
        tmp <- tryCatch(Model_spline(Data_for_spline(),
                                     input$third_page.age_min,
                                     input$third_page.age_max,
                                     input$third_page.out_step,
                                     input$spline_method,
                                     input$delay_spline=="yes"),
                        error = function(e) { shinyalert(title = "ERROR", text = geterrmessage(), type = "error")  })
        
        
        Model_spline(Data_for_spline(),
                          input$third_page.age_min,
                          input$third_page.age_max,
                          input$third_page.out_step,
                          input$spline_method, 
                          input$delay_spline=="yes")$model [-1]%>%
          # filter(between(age_min, input$control.display[1], input$control.display[2])) %>%
          # select(value) %>%
          # t() %>%
          as.data.frame()%>%
          
          datatable(.,extensions = c('Buttons', 'Scroller'), 
                    options = list(
                      dom = 'Bfrtip',
                      
                      deferRender = TRUE,
                      scrollY = 400,
                      scroller = TRUE,
                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      # exportOptions = list(header = ""),
                      # buttons = list(
                      #   list(extend = 'copy', title = "My custom title"), 
                      #   list(extend = 'csv', title = "My custom title"),
                      #   list(extend = 'excel', title = "My custom title"), 
                      #   list(extend = 'pdf', title = "My custom title"), 
                      #   list(extend = 'print', title = "My custom title") 
                      # )
                    ))}) }
    else{ output$table_spline <- DT::renderDataTable({
      
      
     
      
      
      
      Model_spline(a,
                        input$third_page.age_min,
                        input$third_page.age_max,
                        input$third_page.out_step,
                        input$spline_method, 
                        input$delay_spline=="yes")$model[-1] %>%
        # filter(between(age_min, input$control.display[1], input$control.display[2])) %>%
        # select(value) %>%
        # t() %>%
        as.data.frame()%>%
        
        datatable(.,extensions = c('Buttons', 'Scroller'), 
                  options = list(
                    dom = 'Bfrtip',
                  
                    deferRender = TRUE,
                    scrollY = 400,
                    scroller = TRUE,
                    buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                  # exportOptions = list(header = ""),
                                 # buttons = list(
                                 #   list(extend = 'copy', title = "My custom title"), 
                                 #   list(extend = 'csv', title = "My custom title"),
                                 #   list(extend = 'excel', title = "My custom title"), 
                                 #   list(extend = 'pdf', title = "My custom title"), 
                                 #   list(extend = 'print', title = "My custom title") 
                                 # )
                                 ))})
    
    }
    
    
  })
  
 
  
  # DISPLAYING THE PLOT
  observeEvent (input$demo3_dt,
               {
    if  (input$demo3_dt=="No"){
      
  output$plot_spline <- renderPlot({
    req(!is.null(input$third_page.data$datapath))
    req(class(Data_for_spline()) %in% c("data.frame", "tbl"))

    tmp <- tryCatch(Model_spline(Data_for_spline(),
                                 input$third_page.age_min,
                                 input$third_page.age_max,
                                 input$third_page.out_step,
                                 input$spline_method,
                                 input$delay_spline=="yes"),
                    error = function(e) { shinyalert(title = "ERROR", text = geterrmessage(), type = "error")  })

    
    plot(Model_spline(Data_for_spline(),
                      input$third_page.age_min,
                      input$third_page.age_max,
                      input$third_page.out_step,
                      input$spline_method, 
                      input$delay_spline=="yes")$graph)
    
  })
    }
      else {
        output$plot_spline <- renderPlot({
        plot(Model_spline(a,input$third_page.age_min,
                                         input$third_page.age_max,
                                         input$third_page.out_step,
                                         input$spline_method, 
                                         input$delay_spline=="yes")$graph)
                   
                    })
      } 
      })


 
  
  ######################################################################################
  ######################################################################################
  ### LOESS LOESS LOESS LOESS LOESS LOESS LOESS LOESS LOESS LOESS LOESS LOESS LOESS  ###
  ######################################################################################
  ######################################################################################
  
  
  # DATA TESTED & IMPORTED 
  Data_for_loess <- reactive({
    req(!is.null(input$fourth_page.data$datapath))
    
    tmp <- tryCatch(Test_data(path = input$fourth_page.data$datapath), error = function(e) {
      shinyalert(title = " ", text = geterrmessage(), type = "error")
    })
    
    req(any(class(tmp) %in% c("data.frame", "tbl")))
    
    shinyalert(title = " ", text = "GOOD JOB", type = "success")
    
    colnames(tmp) = c("X", "Y")
    
    return(tmp)
  })
  
  
  # DISPLAYING THE PLOT
  output$plot_loess <- renderPlot({
    req(!is.null(input$fourth_page.data$datapath))
    req(class(Data_for_loess()) %in% c("data.frame", "tbl"))
    
    tmp <- tryCatch(Model_loess(Data_for_loess(),
                                input$fourth_page.degree,
                                input$fourth_page.span),
                    error = function(e) { shinyalert(title = "ERROR", text = geterrmessage(), type = "error")  })
    
    
    plot(Data_for_loess(),type="l")
    lines(Model_loess(Data_for_loess(),input$fourth_page.degree,input$fourth_page.span),type="l",col="red")
  })
  
  # DATA EXPORTED TO FOLDER *EXPORT*
  Data_exported_loess <- reactive({
    Model_loess(Data_for_loess(),
                input$fourth_page.degree,
                input$fourth_page.span)
  })
  
  #EXPORTATION WHEN CLICKING ON BUTTON
  observeEvent(input$download.data.4, ({
    write.csv(Data_exported_loess(), 
              file = file.path("EXPORT", 
                               paste0(input$file_export_name.4,".csv")), 
              sep = "\t",
              row.names = FALSE)
    shinyalert(title= "WELLDONE", type= "success", text = "Your data can be found in the folder: EXPORT")
  }))
  
  output$app_docu <- renderUI({
    HTML(markdown::markdownToHTML(knit('doc.rmd', quiet = TRUE)))
  })
  
  # DATA TESTED & IMPORTED 
  DataDx <- reactive({
    req(!is.null(input$second_page.dataDx$datapath))
    
    tmp1 <- tryCatch(Test_data2D(path = input$second_page.dataDx$datapath), error = function(e) {
      shinyalert(title = " ", text = geterrmessage(), type = "error")
    })
    
    req(any(class(tmp1) %in% c("data.frame", "tbl")))
    
    shinyalert(title = " ", text = "GOOD JOB", type = "success")
    print(head(tmp1,2))
    return(tmp1)
  })
  
  DataEx <- reactive({
    req(!is.null(input$second_page.dataEx$datapath))
    
    tmp1 <- tryCatch(Test_data2D(path = input$second_page.dataEx$datapath), error = function(e) {
      shinyalert(title = " ", text = geterrmessage(), type = "error")
    })
    
    req(any(class(tmp1) %in% c("data.frame", "tbl")))
    
    shinyalert(title = " ", text = "GOOD JOB", type = "success")
    print(head(tmp1,2))
    return(tmp1)
  })
  
  #Displaying table in the box 
  
  #DISPLAYING THE PLOT
  output$plot1 <- renderPlot({
    req(!is.null(input$second_page.dataDx$datapath))
    req(class(DataDx()) %in% c("data.frame", "tbl"))
    
    tmp1 <- tryCatch(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                                  max=input$second_page.max,
                                  nlast=input$second_page.nlast,
                                  activate_offset = input$second_page.offset,
                                  out.step=input$second_page.out_step
                                  
    ), error = function(e) {
      shinyalert(title = "ERROR WITH OFFSET", text = geterrmessage(), type = "error")
    })
    
    plot(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                      max=input$second_page.max,
                      
                      nlast=input$second_page.nlast,
                      
                      activate_offset = input$second_page.offset,out.step=input$second_page.out_step),type="fitted", main =" Fitted Values")
    
  })
  output$plot1o <- renderPlot({
    req(!is.null(input$second_page.dataDx$datapath))
    req(class(DataDx()) %in% c("data.frame", "tbl"))
    
    tmp1 <- tryCatch(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                                  max=input$second_page.max,
                                  nlast=input$second_page.nlast,
                                  activate_offset = input$second_page.offset,
                                  out.step=input$second_page.out_step
                                  
    ), error = function(e) {
      shinyalert(title = "ERROR WITH OFFSET", text = geterrmessage(), type = "error")
    })
    
    plot(Model_pclm2D(DataDx(),DataEx(),min=input$second_page.min,
                      max=input$second_page.max,
                      
                      nlast=input$second_page.nlast,
                      
                      activate_offset = input$second_page.offset,out.step=input$second_page.out_step),type = "observed", main="Observed Values")
    
  })
  
  
  
}
