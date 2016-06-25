
library(twitteR)
library(dplyr)
library(ggplot2)
library(lubridate)


my_key <- "4zE5czharQ0nwy4tMul7PgHrZ"
my_secret <- "WFpOedJ0CazUxBDEu8xiOF1iP1SrdZIrO2dWVszIMjqX4HKDEG"
my_access_token <- "15076093-vx86U7FD2mPtuyFq5sCmEsMr1BkeXI3yTFjZN7JTZ"
my_access_secret <- "a98gbYTlOW8jpH9zOPkmTHT3BMe60B9kqTO09cX7vh8RA"

setup_twitter_oauth(my_key, my_secret, my_access_token, my_access_secret)

searchTwitter("battlefield hardline", n=25, lang=NULL, since=NULL, until=NULL,
              locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
              resultType=NULL, retryOnRateLimit=120)

results <- searchTwitter("titanfall", n=25, lang=NULL, since="2016-06-12", until="2016-06-18",
              locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
              resultType=NULL, retryOnRateLimit=120)

results.df <- twListToDF(results)
