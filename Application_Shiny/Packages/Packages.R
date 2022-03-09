# AUTHOR: TCHOUM
# LAST MODIFICATION : 25/11/2021
# Description : This script deals with installing and loading packages

# -------------------------------------------------------- SCRIPT  -----------------------------------------------------------------------

Checking_packages <- function(list_of_packages) {
  if (!any(is.list(list_of_packages) || is.vector(list_of_packages))) {
    stop("Review your inputs")
  }
  sapply(list_of_packages, function(x) {
    if (x %in% attr(installed.packages(), "dimnames")[[1]]) {
      library(x, character.only = T)
      print(paste0(x, "'s installation", "  done."))
    } else {
      paste("intalling", x, "....")
      install.packages(x, quiet = T)
      library(x, character.only = T)
    }
  })

  return("Packages installation done.....")
}
options(warn = -1) # For hiding warnings

# DEBUG
Checking_packages(c("ungroup","DT","dplyr","ggplot2","shiny", "shinyWidgets","shinycssloaders", 
                    "shinydashboard", "shinydashboardPlus", "dashboardthemes", 
                    "shinyalert", "shinyscreenshot", "knitr"))
#
