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



# now working on binary template matching instead of cross-correlation
setwd("C:/Users/Silvy/Documents/R/Repos/PrimatesAndSoundscapes")

fileList <- list.files(path = "AutomatedDetection_CreatingTemplates", full.names = TRUE)

sunwave <- readWave(fileList[1])
template1b <- makeBinTemplate(fileList[1], frq.lim = c(0.3, 1.6), t.lim = c(25, 35), name = "F1,025,-25,T", amp.cutoff = (-25))
sunwave <- readWave(fileList[2])
template2b1 <- makeBinTemplate(fileList[2], frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F2,000,-25,T", amp.cutoff = (-25))
template2b2 <- makeBinTemplate(fileList[2], frq.lim = c(0.2, 1.8), t.lim = c(87, 97), name = "F2,087,-25,T", amp.cutoff = (-25)) 

sunwave <- readWave(fileList[3])
template3b <- makeBinTemplate(fileList[3], frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F3,000,-25,T", amp.cutoff = (-25))

sunwave <- readWave(fileList[4])
template4b1 <- makeBinTemplate(fileList[4], frq.lim = c(0.2, 1.4), t.lim = c(0, 10), name = "F4,000,-25,T", amp.cutoff = (-25))
template4b2 <- makeBinTemplate(fileList[4], frq.lim = c(0.2, 1.8), t.lim = c(30, 40), name = "F4,030,-25,T", amp.cutoff = (-25)) 

sunwave <- readWave(fileList[5])
template5b <- makeBinTemplate(fileList[5], frq.lim = c(0.2, 1.4), t.lim = c(65, 75), name = "F5,065,-25,T", amp.cutoff = (-25))

sunwave <- readWave(fileList[6])
template6b <- makeBinTemplate(fileList[6], frq.lim = c(0.2, 1.0), t.lim = c(15, 25), name = "F6,015,-25,H", amp.cutoff = (-25)) 

sunwave <- readWave(fileList[7])
template7b <- makeBinTemplate(fileList[7], frq.lim = c(0.2, 1.4), t.lim = c(17, 27), name = "F7,017,-25,H", amp.cutoff = (-25)) 

sunwave <- readWave(fileList[8])
template8b1 <- makeBinTemplate(fileList[8], frq.lim = c(0.3, 1.5), t.lim = c(25, 35), name = "F8,025,-25,T", amp.cutoff = (-25)) 
template8b2 <- makeBinTemplate(fileList[8], frq.lim = c(0.3, 1.5), t.lim = c(36, 46), name = "F8,036,-25,T", amp.cutoff = (-25)) 

sunwave <- readWave(fileList[9])
templateManual <- makeBinTemplate(fileList[9], frq.lim = c(0.2, 1.8), t.lim = c(102, 112), name = "F9,102,-25,T", amp.cutoff = (-25))

ctemps_adjusted_amp <- combineBinTemplates(template1b, template2b1, template2b2, template3b, template4b1, template4b2, template5b, template8b1, template8b2, template6b, template7b, templateManual)


# runs against all files in the 4,200 folder, from 5:45 am to 8:00 am.
# (we manually logged detections for only those times)


folderList <- list.files(path = "For Sun - Full test dataset/Puma 2015/0, 800", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2015/0, 800", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2015_0,800.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()


folderList <- list.files(path = "For Sun - Full test dataset/Puma 2015/1, 200", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2015/1, 200", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2015_1,200.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2015/-1, 600", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2015/-1, 600", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2015_-1,600.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2015/2, 0", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2015/2, 0", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2015_2,0.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2015/-2, 400", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2015/-2, 400", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2015_-2,400.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()


folderList <- list.files(path = "For Sun - Full test dataset/Puma 2016/0, 800", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2016/0, 800", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2016_0,800.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2016/1, 200", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2016/1, 200", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2016_1,200.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2016/-2, 0", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2016/-2, 0", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2016_-2,0.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2016/6, 400", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2016/6, 400", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2016_6,400.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2017/1, 200", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2017/1, 200", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2017_1,200.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2017/-3, 600", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2017/-3, 600", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2017_-3,600.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2017/4, 0", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2017/4, 0", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2017_4,0.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()


folderList <- list.files(path = "For Sun - Full test dataset/Puma 2017/6, 400", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2017/6, 400", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2017_6,400.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()

folderList <- list.files(path = "For Sun - Full test dataset/Puma 2017/6, 800", full.names = TRUE)
outputList <- list.files(path = "For Sun - Full test dataset/Puma 2017/6, 800", full.names = TRUE)
print(outputList[1])

audioFileList <- list.files(path = outputList[1], full.names = TRUE)
print(audioFileList[1])


folderCounter = 1
maxFilesPerFolder = 10   # we need to stop at 8:15 am exclusive

sink(file = "output_Puma2017_6,800.txt")

for(folder in folderList) {
  fileCounter = 1
  audioFileList <- list.files(path = folderList[folderCounter], full.names = TRUE)
  print(paste("folder", folderCounter))
  while(fileCounter <= maxFilesPerFolder) {
    print(paste("    file", fileCounter))
    scores <- binMatch(audioFileList[fileCounter], ctemps_adjusted_amp, quiet = TRUE)
    print(scores) 
    fileCounter = fileCounter + 1
  }
  folderCounter = folderCounter + 1
}

sink()