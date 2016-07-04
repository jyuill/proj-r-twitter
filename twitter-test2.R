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
tdate9 <- as.character(today()-8)
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
#### two methods very similar
### 1. search for tweets from specific user - enables date filters
tweets_user <- searchTwitter('from:titanfallgame',n=50, since=start,until=end,resultType='recent')
tweets_user.df <- twListToDF(tweets_user)

### 2. timeline of user - enables excluding retweets and replies
timeline_user <- userTimeline("titanfallgame",n=20,includeRts = TRUE,excludeReplies = FALSE)
timeline_user.df <- twListToDF(utimeline)

### comparing 1 & 2 above - same results with the queries as they are
str(tweets_user.df)
str(timeline_user.df)


## get top n most favorited tweets from user
results.fav <- favorites('titanfallgame', n = 20, max_id = NULL, since_id = NULL)
results.fav.df <- twListToDF(results.fav)

#### USER-SPECIFIC Account Stats & Info
## get a user object with basic account data - followers etc
tuser <- getUser('titanfallgame')
## twListToDF(tuser) doesn't work but can convert into data frame
tuser_tf.df <- as.data.frame(tuser)
tuser_tf.df$date <- today()
## can get data on multiple users at once but not sure how to convert into usable format
# musers <- lookupUsers(c('EAAccess', 'hardlinefanpage'))
## doesn't work:
# muser.df <- as.data.frame(musers)
## better of to grab separately, as below...

## same as above for yet another account - in order to combine below
tuser_eax.df <- as.data.frame(getUser('EAAccess'))
tuser_eax.df$date <- today()

## bind account info for all 3 above into one data frame
tusers_EA.df <- data.frame()
tusers_EA.df <- rbind(tusers_EA.df,tuser_eax.df)
tusers_EA.df <- rbind(tusers_EA.df,tuser_tf.df)

### OR...AUTOMATE THE PROCESS WITH LOOP FOR EASY HANDLING OF MULTIPLE ACCOUNTS
## get list of accounts
tusers <- c("EAAccess",
            "HardlineFanPage",
            "Titanfallgame")
ntusers <- length(tusers) ## count number of accounts to determine how many loop cycles

## run loop to collect current data with date stamp for all accounts and bind into
## one data frame
## set up to run automatically to compare change in numbers over time
tusers.EA <- data.frame()
for (i in 1:ntusers){
  tuser <- as.data.frame(getUser(tusers[i]))
  tuser$date <- today()
  tusers.EA <- rbind(tusers.EA,tuser)
}
