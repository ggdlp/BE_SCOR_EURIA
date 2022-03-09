{
  source(file='server.R',local=TRUE,encoding = 'UTF8')
  source(file='ui.R',local=TRUE,encoding = 'UTF8')
  
  shinyApp(ui=ui_tool,server)
}

