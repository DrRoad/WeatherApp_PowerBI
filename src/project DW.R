library(jsonlite)
rm(list = ls())
# set default information
city <- "Milwaukee,US"
timezone <- -6

# function utilities
nullQ <- function (x) {
  ifelse(is.null(x) || is.na(x), 0, x)
}

naQ <- function (x) {
  ifelse(is.null(x) || is.na(x), NA, x)
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
wind_degree <- (test$wind.deg + 180) %% 360 - 180

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

rain <- c()
for (i in 1:dim(test)[[1]]) {
  rain <- append(rain, nullQ(test$rain.3h[[i]]))
}

snow <- c()
for (i in 1:dim(test)[[1]]) {
  snow <- append(snow, nullQ(test$snow.3h[[i]]))
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
    condition,
    rain,
    snow
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
longitude <- naQ(weather$coord$lon)
latitude <- naQ(weather$coord$lat)
cond <- naQ(weather$weather$main)
condition <- naQ(weather$weather$description)
pressure <- naQ(weather$main$pressure)
humidity <- naQ(weather$main$humidity)
temperature <- naQ(weather$main$temp - 273.15)
temperature_min <- naQ(weather$main$temp_min - 273.15)
temperature_max <- naQ(weather$main$temp_max - 273.15)
visibility <- naQ(weather$visibility)
wind_speed <- naQ(weather$wind$speed)
wind_degree <- naQ((weather$wind$deg + 180) %% 360 - 180)
country <- weather$sys$country
city <- weather$name
sunrise <-
  as.POSIXct(weather$sys$sunrise, origin = "1970-01-01", tz = "UTC")
sunset <-
  as.POSIXct(weather$sys$sunset, origin = "1970-01-01", tz = "UTC")
cloud <- naQ(weather$clouds$all)

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
    wind_degree,
    city,
    country,
    sunset,
    sunrise,
    cloud
  )
