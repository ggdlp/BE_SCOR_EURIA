---
title: "Documentation"
output: html_document:
  width: 100
runtime: shiny
---



To learn more, see [Interactive Documents](http://rmarkdown.rstudio.com/authoring_shiny.html).

# Introduction :

# PCLM :
To visualize the demo file, [Click here](https://docs.google.com/spreadsheets/d/e/2PACX-1vR9T1H-xoJOxKAWsHMLYrDq-kzGqq56barXMbxLMxyJ7W94LRBi3sxXOjuaxPWmpGQV7-9oOGNhua07/pub?output=csv).

The PCLM method is based on the composite link model, which extends standard generalized linear models. It implements the idea that the observed counts, interpreted as realizations from Poisson distributions, are indirect observations of a finer (ungrouped) but latent sequence. This latent sequence represents the distribution of expected means on a fine resolution and has to be estimated from the aggregated data. Estimates are obtained by maximizing a penalized likelihood. This maximization is performed efficiently by a version of the iteratively reweighted least-squares algorithm. Optimal values of the smoothing parameter are chosen by minimizing Bayesian or Akaike's Information Criterion
### Inputs datasets :

The input dataset is supposed to have at least 2 columns, the first one is to be the abscissa, i.e. the bins under which values are count, and the second one is to be the counts. And eventually a last column for offset datas


### Inputs parameters :
The differents parameters that you can use when fitting the model are : 
- Length of the last age interval : Option to choose for defining the length of the last age interval
- Confidence level:	Level of significance for computing confidence intervals
- Outstep : Useful for the temporality ,it us used to define the increase in the output's abscissa. Typically, if outstep is equal to 1 it corresponds to a year, 0.5 for a semester...
- Metric : Selection criterion of the model. Possible values are "AIC" and "BIC".
- Degree of splines : Degree of the splines needed to create equally-spaced B-splines basis over an abscissa of data.
- Knot Ratio : Number of internal intervals used for defining 1 knot in B-spline basis construction.

### Output structure : 
We can visualize directly the datatable of fitted values in shiny and even a plot of it.
Also, we have different options for exportation (csv, pdf, excel,...) and a possible dowload of graph.




# PCLM 2D  :

To download the grouped data demo file, [Click here](https://docs.google.com/spreadsheets/d/e/2PACX-1vTU71_plU-WfkfY9mrXnf2DJyvaPrwqk4y7rUEZyzcUCOJFRdp1oq18fvxnot18CrvPHAfgI8bVlpEp/pub?output=csv)

To download the offset data demo file, [Click here](https://docs.google.com/spreadsheets/d/e/2PACX-1vRyTgkdT7vWxxCjSnnqr8OuxSU6y8WsC0Z9jgmBGgBJuPPQhF9mNfNvaaObXno-ZYmDOEeN62toqmeL/pub?output=csv)

It fits two-dimensional penalized composite link model (PCLM-2D), e.g. simultaneous ungrouping of age-at-death distributions grouped in age classes for adjacent years. The PCLM can be extended to a two-dimensional regression problem. This is particularly suitable for mortality analysis when mortality surfaces are to be estimated to capture both age-specific trajectories of coarsely grouped distributions and time trends 
### Inputs datasets :
Two inputs but the second is optionnal

One Grouped Data : data.frame with counts to be ungrouped.

One offset Data : Optional offset term to calculate smooth mortality rates. A data frame of the same dimension as the grouped data

### Inputs parameters :

The same as Pclm

### Output structure :

We can visualize directly the datatable of fitted values in shiny and even a plot of it.
Also, we have different options for exportation (csv, pdf, excel,...) and a possible dowload of graph.

### Observations :
 Very slow for big datas.


# Spline :

### Inputs datasets :

The input dataset is supposed to have 2 columns, the first one is to be the abscissa, i.e. the bins under which values are count, and the second one is to be the counts. 

### Inputs parameters : 
The differents parameters that you can use when fitting the model are : 
- Lowest age & Highest age : Used to define the range of the output you want 
- outstep : used to define the increase in the output's abscissa. Typically, if outstep is equal to $1$, and lowest age is equal to $0$ and highest age is equal to $10$, then the output abscissa will be all integers from $0$ to $10$. If outstep is set to $0.5$, then the output abscissa will be : $0$ , $0.5$, $1$, $1.5$ ... $9.5$, $10$.
- the method used in spline : at this point we have no recommendation on that parameter. 
- a parameter to delay the input : We have noticed that spline is often early to predict ups or downs in the variation, compared to the real data. When this parameter is set to yes, the input abscissa given to spline is a correction of the one in the file. the correction is an augmentation of half the bin length. The objective is to consider that the original data grouping has been done around the middle-value of the bin, instead of the first-value of the bin (a slight improvment of the code may be useful regarding that...).

### Output structure :

The export works the same way as other methods, the first column "X" is the abscissa (ages), while the second one, "Y", represent the counts for each age

### Observations :

Spline seems to be a quite efficient method when using mortality data, particularly regarding the smoothness assumption of the underlying distribution. The two main data-issues that can occur are : 
- Negative values in the output : makes little sense when data is about counts. Nevertheless, if the inputs are sufficiently representative of the output range asked, this problem should not occur, or at least with very-close to 0 negative values. 
- Spline will have as some difficulties to see sudden peaks in the data (for example, the peak of mortality at age 0 when using mortality data). The estimated value will often be under the real one.

# Loess :

### Inputs datasets :

The input dataset is supposed to have 2 columns, the first one is to be the abscissa, i.e. the predictor, and the second one is the values to predict. ##\# Inputs parameters : The differents parameters that you can use when fitting the model are : - span : the parameter α which controls the degree of smoothing. From $0.1$ to $1$ - degree : the degree of the polynomials to be used, normally $1$ or $2$.

### Advantages :

The greatest advantage of local regression over many other methods is that it does not require a global function to be defined to fit a model to the sample data set. It only requires specifying the value of the smoothing parameter and the degree of the local polynomial. The local regression method is also very flexible in its application and relatively simple to implement. Moreover, since it is based on least squares regressions, local regression also benefits from most of the tools associated with these regression methods, notably the theory of calculating prediction and calibration uncertainties.

### Inconvenients :

Because it makes less efficient use of data than other least squares regression methods, local regression generally requires larger data sets to generate good models. Among other disadvantages, local regression does not allow the construction of a regression function that can be easily represented in the form of a mathematical formula. This makes it more difficult to pass on the results to others, who then need the complete dataset and the tool that performed the local regression calculations. In addition, like other least squares regression methods, local regression is subject to the effects of outliers in the dataset. Finally, local regression is relatively computationally intensive, which can be a problem for very large datasets.

# Autres fonctionalités :

### Download plots :

You can download presented plots by clicking the button on bottom left corner :)
