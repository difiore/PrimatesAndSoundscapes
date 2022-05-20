#Automated Detection Algorithm - Template Matching using Monitor's Spectrogram Cross Correlation
#Authors: Silvy van Kuijk & Sun O'Brien


#-----------

#To install packages, use this:

install = FALSE

if(install) {
  install.packages("monitoR")
  install.packages("tuneR")
  install.packages("foreach")
}

#Call the package into R's memory:
library(monitoR)
library(tuneR)
library(foreach)


#List all files in dorectory
fileList <- list.files(path = "AutomatedDetection_CreatingTemplates", full.names = TRUE)

#Read in .wav file and create templates
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

#Create template bin
ctemps_adjusted_amp <- combineBinTemplates(template1b, template2b1, template2b2, template3b, template4b1, template4b2, template5b, template8b1, template8b2, template6b, template7b, templateManual)


# Then, run template against all files in specified folder, from 5:45 am to 8:00 am.
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
