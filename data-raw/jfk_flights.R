## code to prepare `jfk_flights` dataset goes here
library(tibble)

jfk_flights <- tibble::tribble(
  ~tailnum,    ~manufacturer,            ~model, ~origin, ~dest,            ~time_hour,
  "N299PQ", "BOMBARDIER INC",     "CL-600-2D24",   "JFK", "ORD", "2013-12-10 15:00:00",
  "N361VA",         "AIRBUS",        "A320-214",   "JFK", "LAS", "2013-08-09 09:00:00",
  "N374JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BTV", "2013-12-30 09:00:00",
  "N373JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "PWM", "2013-08-15 22:00:00",
  "N355JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BOS", "2013-08-29 12:00:00",
  "N199UW",         "AIRBUS",        "A321-211",   "JFK", "CLT", "2013-11-01 06:00:00",
  "N368JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BUF", "2013-07-22 21:00:00",
  "N292PQ", "BOMBARDIER INC",     "CL-600-2D24",   "JFK", "PIT", "2013-11-07 19:00:00",
  "N828JB",         "AIRBUS",        "A320-232",   "JFK", "PDX", "2013-10-15 20:00:00",
  "N361VA",         "AIRBUS",        "A320-214",   "JFK", "SFO", "2013-11-19 16:00:00",
  "N358JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BUF", "2013-08-14 22:00:00",
  "N354JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "JAX", "2013-05-06 14:00:00",
  "N374JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "RDU", "2013-08-26 17:00:00",
  "N354JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "SYR", "2013-09-13 09:00:00",
  "N373JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "JAX", "2013-08-20 08:00:00",
  "N368JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "SYR", "2013-06-05 17:00:00",
  "N374JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BOS", "2013-10-28 10:00:00",
  "N354JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BOS", "2013-09-06 10:00:00",
  "N368JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "ROC", "2013-11-02 14:00:00",
  "N354JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BOS", "2013-11-17 16:00:00",
  "N374JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BUF", "2013-09-16 20:00:00",
  "N374JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "SYR", "2013-07-07 22:00:00",
  "N373JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BUF", "2013-06-10 21:00:00",
  "N354JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BOS", "2013-12-24 20:00:00",
  "N374JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BOS", "2013-08-12 10:00:00",
  "N373JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "JAX", "2013-08-15 14:00:00",
  "N828JB",         "AIRBUS",        "A320-232",   "JFK", "SEA", "2013-09-28 09:00:00",
  "N355JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BUF", "2013-08-16 07:00:00",
  "N354JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "BUF", "2013-09-06 06:00:00",
  "N368JB",        "EMBRAER", "ERJ 190-100 IGW",   "JFK", "ACK", "2013-08-09 08:00:00"
  )

usethis::use_data(jfk_flights, overwrite = TRUE)
