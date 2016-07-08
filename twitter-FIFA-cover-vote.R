### Collecting Twitter data using twitteR
### https://cran.r-project.org/web/packages/twitteR/twitteR.pdf

### make sure all packages are available and load them
library(twitteR)
library(dplyr)
library(ggplot2)
library(lubridate)

options(scipen=999) # to avoid scientific notation on ID numbers

### get auth keys from twitter_keys.R file (not available on git)
### run command and answer question provided before other code
setup_twitter_oauth(my_key, my_secret, my_access_token, my_access_secret)

## search for FIFA COVER VOTE tweets
allpast <- read.csv("results_all.csv",header=TRUE)
allpast$created <- as.POSIXct(allpast$created)

## set date range >>> only goes back 8 days from current date
## date not used after start, in favour of 'sinceID'
## dates will over-ride 'sinceID' so need to change query
tdate <- as.character(today())
tdatestart <- "2016-07-05"
start <- tdatestart ## if using sinceID, set since=NULL
end <- tdate ## if using sinceID, set until=NULL

numresults <- 20 #not sure what the upper limit is

search <- "#FIFA17HAZARD"
results <- searchTwitter(search, n=numresults, lang=NULL, since=start, until=end,
                         locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
                         resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results_hazard.df <- twListToDF(results)
results_hazard.df$topic <- "Hazard"

################# testing sinceID >>>> weird results compared to date
## get current max id for player
sid <- allpast %>% filter(topic=="Hazard") %>% summarize(mid=max(id))
## set since and until to NULL
## set sinceID=sid
resultst <- searchTwitter(search, n=4, lang=NULL, since=NULL, until=NULL,
                         locale=NULL, geocode=NULL, sinceID=sid, maxID=NULL,
                         resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results_t5.df <- twListToDF(resultst)
#############################

search <- "#FIFA17JAMES"
results <- searchTwitter(search, n=numresults, lang=NULL, since=start, until=end,
                               locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
                               resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results_james.df <- twListToDF(results)
results_james.df$topic <- "James"
results_all.df <- rbind(results_hazard.df,results_james.df)

search <- "#FIFA17MARTIAL"
results <- searchTwitter(search, n=numresults, lang=NULL, since=start, until=end,
                         locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
                         resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results_martial.df <- twListToDF(results)
results_martial.df$topic <- "Martial"
results_all.df <- rbind(results_all.df,results_martial.df)

search <- "#FIFA17REUS"
results <- searchTwitter(search, n=numresults, lang=NULL, since=start, until=end,
                         locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
                         resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results_reus.df <- twListToDF(results)
results_reus.df$topic <- "Reus"
results_all.df <- rbind(results_all.df,results_reus.df)

search <- "#FIFA17COVER"
results <- searchTwitter(search, n=numresults, lang=NULL, since=start, until=end,
                         locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
                         resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results_cover.df <- twListToDF(results)
results_cover.df$topic <- "Cover"
results_all.df <- rbind(results_all.df,results_cover.df)

write.csv(results_all.df,"results_all.csv",row.names = FALSE)
