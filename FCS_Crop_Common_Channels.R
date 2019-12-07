### Finds common channels in selected FCS files and writes new "_crop" files.



#########################################################
### Installing and loading required packages
#########################################################

if (!require("svDialogs")) {
  install.packages("svDialogs", dependencies = TRUE)
  library(svDialogs)
}

if (!require("tcltk2")) {
  install.packages("tcltk2", dependencies = TRUE)
  library(tcltk2)
}

if (!require("flowCore")) {
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
    BiocManager::install("flowCore")
    library(flowCore)
}

if (!require("tidyverse")) {
  install.packages("tidyverse", dependencies = TRUE)
  library(tidyverse)
}

#########################################################
### CODE STARTS HERE
#########################################################

# Clear environment
rm(list = ls(all = TRUE))


# library(svDialogs)# Moved to top
# Get user input for file
testfile<-dlg_open()
# Convert to string value
testfile <- capture.output(testfile)[7]

if ((testfile)=="character(0)"){
  stop("File input cancelled")
}else{
  
  #Remove invalid characters from file input location
  testfile <- gsub("[\"]","",testfile)
  testfile<-substring (testfile,5)
  
  #Set file and directory
  filename <- basename (testfile)
  dir <- dirname (testfile)
  
  # Set working directory accoding to file chosen
  setwd(dir)
  
  # List FCS (and fcs!) files in this location
  filesToOpenList <- unique(c(list.files(dir,pattern = ".FCS"),list.files(dir,pattern = ".fcs")))
  
  # Ask which files to open
  filesToOpen <- tk_select.list(filesToOpenList, multiple=TRUE,title="Select files to use.") 
  
 
  # Load all into separate files
  fcs_raw <- NULL
  for (i in filesToOpen){
    fcs_raw <- flowCore::exprs(flowCore::read.FCS(i, transformation = FALSE, truncate_max_range = FALSE))  
    assign(i, fcs_raw)
    rm(fcs_raw)
  }
  
  
  # Get markers for all files
  Channels <- NULL
  for (i in filesToOpen){
    Channels <- colnames(get(i))
    assign(paste("Channels_",i, sep=""), Channels)
    rm(Channels)
  }
  
  Channels_List <- NULL
  for (i in filesToOpen){
    Channels_List[[length(Channels_List)+1]] <- get(paste("Channels_", i,sep=""))
    #Channels_List <- c(Channels_List, Temp)
  }

  # Find common channels
  Common_Channels <- Reduce(intersect, Channels_List)
  
  
  # Read the files into separate flowsets (because they may have different channels, we may not be able to load into one)
  for (i in 1:length(filesToOpen)){
    fcs_raw <- read.flowSet(filesToOpen[i], transformation = FALSE, truncate_max_range = FALSE)
    assign(paste("fcs_raw",i,sep="_"), fcs_raw)
  }
    
  for (i in 1:length(filesToOpen)){
    # Crop down to only the common markers
    fcs_raw <- get(paste("fcs_raw",i,sep="_"))[,Common_Channels]
    assign(paste("fcs_raw",i,sep="_"), fcs_raw)
  }
  
  for (i in 1:length(filesToOpen)){
    write.flowSet(get(paste("fcs_raw",i,sep="_")),getwd(),gsub(".fcs$|.FCS$", "_crop", filesToOpen[i]))
    #write.flowSet(get(paste("fcs_raw",i,sep="_")),getwd(),paste(filesToOpen[i],"_crop.fcs",sep=""))
  }
  

} # End of file cancel loop
  
