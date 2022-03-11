#Automated Detection Algorithm - Template Matching using Monitor's Spectrogram Cross Correlation
#Authors: Silvy van Kuijk & Sun O'Brien


#Link to MonitoR guide: https://cran.r-project.org/web/packages/monitoR/vignettes/monitoR_QuickStart.pdf
#Link to MonitoR full package description: https://cran.r-project.org/web/packages/monitoR/monitoR.pdf

#Folder with audio files to use for creating a template:

#Folder with audio files to test a template on:


#-----------

#If you need to install packages, use this: (You'll need to install a lot in the initial stages, most likely)
install.packages("monitoR")
install.packages("tuneR")

#Before you're able to run the code that's in a cerrtain package, you need to call the package into R's memory:
library(monitoR)
library(tuneR)

#Some first steps to take:
#1. 