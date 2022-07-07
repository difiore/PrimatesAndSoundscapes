#Automated Detection Algorithm - Template Matching using MonitoR's Binary Point Matching
#Authors: Silvy van Kuijk, Sun O'Brien & Tony Di Fiore


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


#List all files in directory

fileList <- list.files(path = "AutomatedDetection_CreatingTemplates", full.names = TRUE)

# Read in .wav file and create templates... here, files on which templates are based are hard coded to prevent indexing problems...
template1b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_001.wav", frq.lim = c(0.3, 1.6), t.lim = c(25, 35), name = "F1b,025,-25,T", amp.cutoff = (-25))

template2b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_002.wav", frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F2b,000,-25,T", amp.cutoff = (-25))
template2b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_002.wav", frq.lim = c(0.2, 1.8), t.lim = c(87, 97), name = "F2b,087,-25,T", amp.cutoff = (-25))

template3b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_003.wav", frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F3b,000,-25,T", amp.cutoff = (-25))

template4b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_004.wav", frq.lim = c(0.2, 1.4), t.lim = c(0, 10), name = "F4b,000,-25,T", amp.cutoff = (-25))
template4b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_004.wav", frq.lim = c(0.2, 1.8), t.lim = c(30, 40), name = "F4b,030,-25,T", amp.cutoff = (-25))

template5b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_005.wav", frq.lim = c(0.2, 1.4), t.lim = c(65, 75), name = "F5b,065,-25,T", amp.cutoff = (-25))

template6b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_006.wav", frq.lim = c(0.2, 1.0), t.lim = c(15, 25), name = "F6b,015,-25,H", amp.cutoff = (-25))

template7b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_007.wav", frq.lim = c(0.2, 1.4), t.lim = c(17, 27), name = "F7b,017,-25,H", amp.cutoff = (-25))

template8b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_008.wav", frq.lim = c(0.3, 1.5), t.lim = c(25, 35), name = "F8b,025,-25,T", amp.cutoff = (-25))
template8b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_008.wav", frq.lim = c(0.3, 1.5), t.lim = c(36, 46), name = "F8b,036,-25,T", amp.cutoff = (-25))

template0b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/ManualRecording3_REC0083.wav", frq.lim = c(0.2, 1.8), t.lim = c(102, 112), name = "F0b,102,-25,T", amp.cutoff = (-25))

template9b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_009.wav", frq.lim = c(0.5, 1.0), t.lim = c(1, 7), name = "F9b,001,-25,S", amp.cutoff = (-25))

template10b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_010.wav", frq.lim = c(0.5, 1.0), t.lim = c(2, 9), name = "F10b1,002,-25,S", amp.cutoff = (-25))

template11b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_011.wav", frq.lim = c(0.7, 1.2), t.lim = c(10, 22), name = "F11b,010,-25,S", amp.cutoff = (-25))


# Create a combined template bin. DON'T RUN BOTH LINES BELOW. CHOOSE WHICH ONE IS APPROPRIATE!

# All templates
ctemps_adjusted_amp <- combineBinTemplates(template1b, template2b1, template2b2, template3b, template4b1, template4b2, template5b, template6b, template7b, template8b1, template8b2, template0b, template9b, template10b, template11b)

# Only spider templates
ctemps_spiders <- combineBinTemplates(template9b, template10b, template11b)

# Then, run template against all files in specified folder, from 5:45 am to 8:00 am.
# (we manually logged detections for only those times)


fileList <- list.files(path = 'E:/For Sun - Full test dataset/TestData', full.names = TRUE)
for(value in fileList){
  cscores <- binMatch(value, ctemps_adjusted_amp)
  print(cscores)
  # code for showing peaks on plot. will cause loop to not run fully, as plot(cdetects) is interactive.
  cdetects <- findPeaks(cscores)
  plot(cdetects)
  showPeaks(detection.obj = cdetects, which.one = "F1,025,-21,T", point = TRUE, what = "peaks", scorelim = c(5,10))
  print(cscores)
}
showPeaks()

#---

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
