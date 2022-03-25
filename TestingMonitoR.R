#Automated Detection Algorithm - Template Matching using Monitor's Spectrogram Cross Correlation
#Authors: Silvy van Kuijk & Sun O'Brien


#Link to MonitoR guide: https://cran.r-project.org/web/packages/monitoR/vignettes/monitoR_QuickStart.pdf
#Link to MonitoR full package description: https://cran.r-project.org/web/packages/monitoR/monitoR.pdf

#Link to folder with audio files to create a template: https://utexas.box.com/s/94z5usiudavxiyvumtko2bvzkjdo63h6
#Link to folder with audio files to test a template on: https://utexas.box.com/s/l07hjh5cycqyps3dfrwvkyz9auxo6c7k


#-----------

#If you need to install packages, use this: (You'll need to install a lot in the initial stages, most likely)

install = FALSE

if(install) {
  install.packages("monitoR")
  install.packages("tuneR")
  install.packages("foreach")
}

#Other potentially useful/interesting acoustic packages are 'WarbleR', seewave' and 'dynaSpec'.

#Before you're able to run the code that's in a certain package, you need to call the package into R's memory:
library(monitoR)
library(tuneR)
library(foreach)

#Some first steps to take:
#1. Try and load some of the .wav files from the last link mentioned above into memory (maybe even see if you can create a spectrogram?)
#2. Follow the guide to see if you can create a basic detection template with the Spectrogram Cross Correlation method.
#3. Test your template on an audio file that is known to have titi monkey duets. 

# data(survey)
# survey
# viewSpec(survey)

# fileList <- list.files(path = "AutomatedDetection_CreatingTemplates", full.names = TRUE)
# 
# waveList <- list()
# templateList <- list()
# 
# for(value in fileList) {
#   sunwave <- readWave(value)
#   append(waveList, sunwave)
#   template <- makeCorTemplate(value, frq.lim = c(0.2, 1.8), t.lim = c(0, 10))
#   template
#   templateList <- c(templateList, template)
#   #(templateList)
# }
# 
# print(templateList)
# print(templateList[])
# 
# 
# ctemps <- combineCorTemplates(templateList[])



fileList <- list.files(path = "AutomatedDetection_CreatingTemplates", full.names = TRUE)

waveList <- list()
templateList <- list()

sunwave <- readWave(fileList[1])
template1 <- makeCorTemplate(fileList[1], frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "t1")

sunwave <- readWave(fileList[2])
template2 <- makeCorTemplate(fileList[2], frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "t2")

sunwave <- readWave(fileList[3])
template3 <- makeCorTemplate(fileList[3], frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "t3")

sunwave <- readWave(fileList[4])
template4 <- makeCorTemplate(fileList[4], frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "t4")

sunwave <- readWave(fileList[5])
template5 <- makeCorTemplate(fileList[5], frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "t5")

print(template5)

ctemps <- combineCorTemplates(template1, template2, template3, template4, template5)


# HARPIA_20130216_060000    -- POSITIVE CASE
# HARPIA_20130220_061500    -- NEGATIVE CASE

# cscores <- corMatch("audio/HARPIA_20130216_060000.wav", ctemps)
# cscores
# 
# cscores <- corMatch("audio/HARPIA_20130220_061500.wav", ctemps)
# cscores

fileList <- list.files(path = "medium_sample", full.names = TRUE)
for(value in fileList) {
  cscores <- corMatch(value, ctemps)
  print(cscores)
}












