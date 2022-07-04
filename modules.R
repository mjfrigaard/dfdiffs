# packages ----
library(shiny)
library(bs4Dash)
library(tidyverse)
library(reactable)

# load uploadDataDemo ------------------------------------------------------
# source("R/uploadDataDemo.R")
# uploadDataDemo()

# load selectDataDemo -----------------------------------------------------
source("dev/selectDataDemo/uploadDataUI.R")
source("dev/selectDataDemo/uploadDataServer.R")
source("dev/selectDataDemo/selectDataUI.R")
source("dev/selectDataDemo/selectDataServer.R")
source("dev/selectDataDemo/selectDataDemo.R")
selectDataDemo()


# load compareDataDemo ----------------------------------------------------
# source("dev/compareDataDemo/compareDataDemo.R")
# compareDataDemo()


