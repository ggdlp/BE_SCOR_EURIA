# observeEvent(input$Load_data,({
#   req(!is.null(input$first_page.data$datapath))
#
#   # data <- read.csv(file = ,sep=';')
#   #
#   # tmp_names <- colnames(data)
#   # names <- c('Age','Deaths')
#   # length(which(names %in% colnames(tmp_names)))
#   # if(!all(names %in% tmp_names)){
#   #   stop(paste('column', names[which(!names %in% tmp_names)],'is missing'))
#   # }
#   # if(!any(ncol(data) %in% c(2,3))){
#   #   stop('There is an issue with your data, verify if your separator is ;')
#   # }
#   tmp <- tryCatch(Test_data(path=input$first_page.data$datapath),error=function(e){
#     shinyalert(title = " ",text=geterrmessage(), type = "error")
#   })
#
#   removeModal()
#   req(any(class(tmp)%in% c('data.frame','tbl')))
#   shinyalert(title = " ",text='sucess', type = "success")
#
#   rv$data <- Test_data(path=input$first_page.data$datapath)
# }))
