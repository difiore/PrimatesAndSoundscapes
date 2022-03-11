#Automated Detection Algorithm - Template Matching using Monitor's Spectrogram Cross Correlation
#Authors: Silvy van Kuijk & Sun O'Brien


#Link to MonitoR guide: https://cran.r-project.org/web/packages/monitoR/vignettes/monitoR_QuickStart.pdf
#Link to MonitoR full package description: https://cran.r-project.org/web/packages/monitoR/monitoR.pdf

#Link to folder with audio files to create a template: https://utexas.box.com/s/94z5usiudavxiyvumtko2bvzkjdo63h6
#Link to folder with audio files to test a template on: https://utexas.box.com/s/l07hjh5cycqyps3dfrwvkyz9auxo6c7k


#-----------

#If you need to install packages, use this: (You'll need to install a lot in the initial stages, most likely)
install.packages("monitoR")
install.packages("tuneR")
#Other potentially useful/interesting acoustic packages are 'WarbleR', seewave' and 'dynaSpec'.

#Before you're able to run the code that's in a certain package, you need to call the package into R's memory:
library(monitoR)
library(tuneR)

#Some first steps to take:
#1. Try and load some of the .wav files from the last link mentioned above into memory (maybe even see if you can create a spectrogram?)
#2. Follow the guide to see if you can create a basic detection template with the Spectrogram Cross Correlation method.
#3. Test your template on an audio file that is known to have titi monkey duets. 