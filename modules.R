# packages ----
library(shiny)
library(bs4Dash)
library(tidyverse)
library(reactable)

# load uploadDataDemo ------------------------------------------------------
# source("R/uploadDataDemo.R")
# uploadDataDemo()

# load selectDataDemo -----------------------------------------------------
# source("dev/selectDataDemo/uploadDataUI.R")
# source("dev/selectDataDemo/uploadDataServer.R")
# source("dev/selectDataDemo/selectDataUI.R")
# source("dev/selectDataDemo/selectDataServer.R")
# source("dev/selectDataDemo/selectDataDemo.R")
# selectDataDemo()


# load compareDataDemo ----------------------------------------------------
source("R/uploadDataUI.R")
source("R/uploadDataServer.R")
source("R/selectDataUI.R")
source("R/selectDataServer.R")
source("R/compareDataUI.R")
source("R/compareDataServer.R")
compareDataApp()


