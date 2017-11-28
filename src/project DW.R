library(jsonlite)
rm(list = ls())
# set default information
city <- "Milwaukee,US"
timezone <- -6

# function utilities
nullQ <- function (x) {
  ifelse(is.null(x), 0, x)
}

# API for 5 days forcast
weather <-
  fromJSON(
    paste(
      "http://api.openweathermap.org/data/2.5/forecast?q=",
      city,
      "&appid=42e84301e9b39293899f1359c02ba514",
      sep = ""
    ),
    flatten = TRUE
  )

test <- weather$list

time <- c()
for (i in 1:dim(test)[[1]]) {
  time <-
    append(time, as.POSIXct(test$dt[[i]], origin = "1970-01-01", tz = "UTC"))
}
temperature <- test$main.temp - 273.15
temperature_min <- test$main.temp_min - 273.15
temperature_max <- test$main.temp_max - 273.15
pressure <- test$main.pressure
sea_level <- test$main.sea_level
ground_level <- test$main.grnd_level
humidity <- test$main.humidity
temp_kf <- test$main.temp_kf
clouds <- test$clouds.all
wind_speed <- test$wind.speed
wind_degree <- test$wind.deg

cond <- c()

for (i in 1:dim(test)[[1]]) {
  cond <- append(cond, test$weather[[i]]$main)
}

condition <- c()
for (i in 1:dim(test)[[1]]) {
  condition <- append(condition, test$weather[[i]]$description)
}

time_zone <- c()
for (i in 1:dim(test)[[1]]) {
  time_zone <-
    append(time_zone, timezone)
}

weatherData <-
  data.frame(
    time,
    time_zone,
    temperature,
    temperature_min,
    temperature_max,
    pressure,
    sea_level,
    ground_level,
    humidity,
    temp_kf,
    clouds,
    wind_speed,
    wind_degree,
    cond,
    condition
  )

# API for weather now
weather <-
  fromJSON(
    paste(
      "http://api.openweathermap.org/data/2.5/weather?q=",
      city,
      "&appid=b9fac368f396b03c9b54d47986e40256&cnt=16",
      sep = ""
    ),
    flatten = TRUE
  )

time <- as.POSIXct(weather$dt, origin = "1970-01-01", tz = "UTC")
time_zone <- timezone
longitude <- nullQ(weather$coord$lon)
latitude <- nullQ(weather$coord$lat)
cond <- nullQ(weather$weather$main)
condition <- nullQ(weather$weather$description)
pressure <- nullQ(weather$main$pressure)
humidity <- nullQ(weather$main$humidity)
temperature <- nullQ(weather$main$temp - 273.15)
temperature_min <- nullQ(weather$main$temp_min - 273.15)
temperature_max <- nullQ(weather$main$temp_max - 273.15)
visibility <- nullQ(weather$visibility)
wind_speed <- nullQ(weather$wind$speed)
wind_degree <- nullQ(weather$wind$deg)

weatherNow <-
  data.frame(
    time,
    time_zone,
    longitude,
    latitude,
    cond,
    condition,
    pressure,
    humidity,
    temperature,
    temperature_min,
    temperature_max,
    visibility,
    wind_speed,
    wind_degree
  )
