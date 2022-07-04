## code to prepare `MLBGreatsMod` dataset goes here
library(tibble)
MLBGreatsMod <- tibble::tribble(
       ~playerID, ~birthYear,       ~nameGiven,       ~debut,   ~finalGame,  ~birthCity, ~birthState,
     "aaronha01",      1934L,    "Henry Louis", "1954-04-13", "1976-10-03",    "Denver",        "CO", # changed birthCity/birthState
     "boggswa01",      1958L,   "Wade Anthony", "1982-04-10", "2001-02-13",     "Omaha",        "NE", # changed finalGame
     "bondsba01",      1964L,    "Barry Lamar", "1986-05-30", "2007-09-26", "Riverside",        "CA",
      "cobbty01",      1886L,  "Tyrus Raymond", "1905-08-30", "1928-09-11",   "Narrows",        "GA", # changed birthYear
     "griffke02",      1969L, "George Kenneth", "1990-08-20", "2010-05-31",    "Donora",        "PA", # changed debut
      "ruthba01",      1895L,  "George Herman", "1914-07-11", "1935-05-30",  "New York",        "NY" # changed birthCity/birthState
     )
usethis::use_data(MLBGreatsMod, overwrite = TRUE)
