### Collecting Twitter data using twitteR
### https://cran.r-project.org/web/packages/twitteR/twitteR.pdf

### make sure all packages are available and load them
library(twitteR)
library(dplyr)
library(ggplot2)
library(lubridate)

### get auth keys from twitter_keys.R file (not available on git)
### run command and answer question provided before other code
setup_twitter_oauth(my_key, my_secret, my_access_token, my_access_secret)

## set date range >>> only goes back 8 days from current date
tdate <- as.character(today())
tdate9 <- as.character(today()-18)
start=tdate9
end=tdate

#### GENERAL searching for tweets by search term
## search for tweets
## use '+' to separate query terms ("fifa 17+snoop dog")
results <- searchTwitter("titanfall", n=25, lang=NULL, since=start, until=end,
              locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
              resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results.df <- twListToDF(results)

#### USER-SPECIFIC tweets using user name
#### two methods return the same fields
#### difference:
##### 1. only goes back 8 days, but can select specific date range (useful for adding data over time)
##### 2. goes back as far to max 3200 tweets, but can't select dates. Can use maxID, sinceID to filter.
### 1. search for tweets from specific user - enables date filters
tweets_user <- searchTwitter('from:titanfallgame',n=500, since=start,until=end,resultType='recent')
tweets_user.df <- twListToDF(tweets_user)

### 2. timeline of user - enables excluding retweets and replies
timeline_user <- userTimeline("titanfallgame",n=3200,includeRts = TRUE,excludeReplies = FALSE)
timeline_user.df <- twListToDF(timeline_user)

### comparing 1 & 2 above - same results with the queries as they are
str(tweets_user.df)
str(timeline_user.df)
summary(tweets_user.df)
summary(timeline_user.df)

## get top n most favorited tweets from user
results.fav <- favorites('titanfallgame', n = 20, max_id = NULL, since_id = NULL)
results.fav.df <- twListToDF(results.fav)

#### USER-SPECIFIC Account Stats & Info
## get a user object with basic account data - followers etc
tuser <- getUser('titanfallgame')
## twListToDF(tuser) doesn't work but can convert into data frame
tuser_tf.df <- as.data.frame(tuser)
tuser_tf.df$date <- today()

