

# AUTHOR: TCHOUM
# LAST MODIFICATION : 25/11/2021
# Description : This script deals with Test, import and buiding model with pclm function


# -------------------------------------------------------- SCRIPT  -----------------------------------------------------------------------

# Global feature : SCOR PICTURE
img_link <- "https://www.semaine-emploi-handicap.com/sites/default/files/images/standard/scor.png"


# 2) Test_data:------
#Test & Import data . Returns error with explanations if wrong format

Test_data <- function(path) {
  data <- read.csv(file = path, sep = ";")
  tmp_names <- colnames(data)
  names <- c("X", "Y")
  length(which(names %in% colnames(tmp_names)))
  if (!all(names %in% tmp_names)) {
    stop(paste("column", names[which(!names %in% tmp_names)], "is missing"))
  }
  
  tmp_X =pull(data,X)
  tmp_Y =pull(data,Y)
  
  condition <- is.numeric(tmp_X) || is.integer(tmp_X)|| is.numeric(tmp_Y) ||is.integer(tmp_Y)
  
  if(!any(condition)){
    stop("There is an issue with your data, verify if there is no character ;")
  }
  if (!any(ncol(data) %in% c(2, 3))) {
    stop("There is an issue with your data, verify if your separator is ;")
  }
  
  
  return(data)
}



Test_data2D <- function(path) {
  data <- read.csv2(path)
  
  colnames(data)[-1] <- sapply(colnames(data)[-1],function(x){unlist(strsplit(x,'X'))[2]})
  if ((ncol(data) == 1)) {
    stop("There is an issue with your data, verify if your separator is ;")
  }
  
  return(data)
}



################TEST SPLINE############



Test_data3 <- function(path) {
  data <- read.csv(file = path, sep = ";")
  tmp_names <- colnames(data)
  names <- c("X", "Y")
  length(which(names %in% colnames(tmp_names)))
  if (!all(names %in% tmp_names)) {
    stop(paste("column", names[which(!names %in% tmp_names)], "is missing"))
  }
  
  tmp_X =pull(data,X)
  tmp_Y =pull(data,Y)
  
  condition <- is.numeric(tmp_X) || is.integer(tmp_X)|| is.numeric(tmp_Y) ||is.integer(tmp_Y)
  
  if(!any(condition)){
    stop("There is an issue with your data, verify if there is no character ;")
  }
  if (!any(ncol(data) %in% c(2, 3))) {
    stop("There is an issue with your data, verify if your separator is ;")
  }
  
  
  return(data)
}


################# loess


Test_data4<- function(path) {
  data <- read.csv2(file = path, sep = ";")
  tmp_names <- colnames(data)
  names <- c("X", "Y")
  length(which(names %in% colnames(tmp_names)))
  if (!all(names %in% tmp_names)) {
    stop(paste("column", names[which(!names %in% tmp_names)], "is missing"))
  }
  
  tmp_X =pull(data,X)
  tmp_Y =pull(data,Y)
  
  condition <- is.numeric(tmp_X) || is.integer(tmp_X)|| is.numeric(tmp_Y) ||is.integer(tmp_Y)
  
  if(!any(condition)){
    stop("There is an issue with your data, verify if there is no character ;")
  }
  if (!any(ncol(data) %in% c(2, 3))) {
    stop("There is an issue with your data, verify if your separator is ;")
  }
  
  
  return(data)
}


# 3) Model_pclm 
# BUILDING MODEL PCLM WITH TWO OUTPUT : DATA (containing age interval and deaths)  & PLOT

Model_pclm <- function(data, nlast, ci.level, out.step,kr,deg,opt.method, offset = FALSE) {
  if ((offset) && (!"Offset" %in% colnames(data))) {
    stop("You activate Offset, but it's missing in your data")
  }
  if (offset) {
    offset <- pull(data, all_of(Offset))
  }
  if (!any(offset)) {
    offset <- NULL
  }
  print(offset)
  # A optimiser : L'offset'
  
  names <- c("X", "Y", "Offset")
  model <- ungroup::pclm(
    x = data %>%
      pull(X),
    y = data %>% pull(Y),
    nlast = nlast,
    ci.level = ci.level, out.step = out.step, offset = offset, control = list(opt.method=opt.method,kr=kr,deg=deg)
    
  )
  
  summary_pclm<-summary(model)
  
  graph <- plot(model, xlab = "Age")
  # return(summary(tmp))
  
  age_min <- attr(fitted(model), "names") %>%
    sapply(function(x) {
      gsub("[[)]", "", x) %>%
        strsplit(",") %>%
        unlist() %>%
        as.numeric() %>%
        min()
    })
  
  data <- data.frame(group = attr(fitted(model), "names"), value = round(fitted(model), 1))#, age_min = age_min)
  
  res <- list(model = model, data = data)
  return(res)
}


# 3) Model_pclm  2d
# BUILDING MODEL PCLM WITH TWO OUTPUT : DATA (containing age interval and deaths)  & PLOT
Model_pclm2D <- function(Dx,Ex, nlast, ci.level,activate_offset,min,max,kr,deg,opt.method,out.step){
  # ungroup.data[1]
  # A optimiser : L'offset'
  
  
  x <- c(0, 1, seq(5, 85, by = 5))
  n      <- c(diff(x), nlast) 
  group  <- rep(x, n)
  Dx1 <- Dx[1:length(group),]
  y      <- aggregate(Dx1, by = list(group), FUN = "sum")
  y      <- aggregate(Dx1, by = list(group), FUN = "sum")[, which(colnames(Dx1)==min):which(colnames(Dx1)==max)]
  
  if (activate_offset ==T ) {
    
    Ex1 <- Ex[1:length(group),]
    offset <- aggregate(Ex1, by = list(group), FUN = "sum")[, which(colnames(Ex1)==min):which(colnames(Ex1)==max)]
    
    model <- ungroup::pclm2D(
      x = x,
      y = y,
      ci.level=ci.level,
      nlast = nlast,
      offset = offset,
      out.step=out.step,
      control=list(kr=kr,deg=deg,opt.method=opt.method)
    )
  }
  else {
    model <- ungroup::pclm2D(
      x = x,
      y = y,
      ci.level=ci.level,
      control=list(kr=kr,deg=deg,opt.method=opt.method),
      nlast = nlast,
      out.step=out.step
    )
  }  
  
  
  
  return(model)
}



Model_pclm2D_data<- function(Dx,Ex, nlast, ci.level,activate_offset,min,max,kr,deg,opt.method,out.step){
  x <- c(0, 1, seq(5, 85, by = 5))
  n      <- c(diff(x), nlast) 
  group  <- rep(x, n)
  Dx1 <- Dx[1:length(group),]
  y      <- aggregate(Dx1, by = list(group), FUN = "sum")
  y      <- aggregate(Dx1, by = list(group), FUN = "sum")[, which(colnames(Dx1)==min):which(colnames(Dx1)==max)]
  
  
  if (activate_offset ==T ) {
    
    Ex1 <- Ex[1:length(group),]
    offset <- aggregate(Ex1, by = list(group), FUN = "sum")[, which(colnames(Ex1)==min):which(colnames(Ex1)==max)]
    
    
    model <- ungroup::pclm2D(
      x = x,
      y = y,
      ci.level=ci.level,
      nlast = nlast,     
      control=list(kr=kr,deg=deg,opt.method=opt.method),
      offset = offset,
      out.step=out.step
    )
  }
  else {
    model <- ungroup::pclm2D(
      x = x,
      y = y,
      nlast = nlast,
      ci.level=ci.level,
      control=list(kr=kr,deg=deg,opt.method=opt.method),
      out.step=out.step
    )
  }  
  age_min2d <- attr(fitted(model), "dimnames")[[1]] %>%
    sapply(function(x) {
      gsub("[[)]", "", x) %>%
        strsplit(",") %>%
        unlist() %>%
        as.numeric() %>%
        min()}
    )

  data <- data.frame(group = attr(fitted(model), "dimnames")[[1]], value = round(fitted(model), 1))
  data=data[,-1]
  colnames(data)=min:max
  #, age_min2d = age_min2d)
  res <- list(model = model, data = data)
  return(res)
}



Model_spline <- function(data, age.min, age.max, out.step, method = "fmm", delay_input = FALSE) {
  
  
  # correction factor for spline
  interval_size = NULL
  nlast = age.max - data$X[nrow(data)] +1
  sizes = c(diff(data$X), nlast)
  for(i in 1:length(sizes)){
    interval_size = c(interval_size, rep(sizes[i], sizes[i]))
  }
  
  model <- spline( x = data$X + as.numeric(0.5 * sizes * delay_input), 
                     y = data$Y, 
                     xout = seq(from = age.min, to = age.max, by = out.step),
                     method = method)
  
  correction_factor <- interval_size
  if (length(correction_factor) == length(model$y)){
    model$y = model$y / correction_factor
  }
  else {
    print("No output correction added, length issue")
  }
  
  
  ungrouped = as.data.frame(model)
  data = as.data.frame(data)
  
  
  graph <- ggplot2::ggplot() + 
    ggplot2::geom_point(data = ungrouped, aes(x, y, color = "ungrouped", size = 1.5))+
    ggplot2::geom_point(data = data, aes(X, Y, color = "grouped", size = 1.5))+
    ggplot2::theme_light()
  graph
  
  res <- list(model = ungrouped, graph = graph)
  return(res)
}

Model_loess<-function(data,degree,span){
  loess_1 <- loess(data$Y~data$X,data=data,span=span,degree=degree)
  smooth <- predict(loess_1)
  loess_fin <- cbind(data$X,smooth)
  return(loess_fin)
}



# --------------------------------------------------- END SCRIPT -----------------------------------------------------------------
#


# ------------------------------------------------------ TEST ------------------------------------------------------------------

# Model_pclm(data, out.step = 1, ci.level = 95, offset = F)
# Model_pclm(data, out.step = 1, ci.level = 95, offset = T)
