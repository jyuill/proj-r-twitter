
library(twitteR)
library(dplyr)
library(ggplot2)
library(lubridate)

### get auth keys from twitter_keys.R file (not available on git)
### run command and answer question provided before other code
setup_twitter_oauth(my_key, my_secret, my_access_token, my_access_secret)

## set date range 
start="2016-06-12"
end="2016-06-18"
## search for tweets
## use '+' to separate query terms ("fifa 17+snoop dog")
results <- searchTwitter("titanfall", n=25, lang=NULL, since=start, until=end,
              locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
              resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results.df <- twListToDF(results)

## get top n most favorited tweets from user
results.fav <- favorites('titanfallgame', n = 20, max_id = NULL, since_id = NULL)
results.fav.df <- twListToDF(results.fav)

## get a user object with basic account data - followers etc
tuser <- getUser('titanfallgame')
## get data on multiple users - not sure how to convert into usable format
musers <- lookupUsers(c('EAAccess', 'hardlinefanpage'))

## convert user object above into data frame
tuser.df <- as.data.frame(tuser)
## doesn't work
muser.df <- as.data.frame(musers)

## enhance data frame with name of twitter user and date data acquired
tuser.EAAccess <- as.data.frame(getUser('EAAccess'))
tuser.EAAccess$tname <- "EAAccess"
tuser.EAAccess$date <- today()

## same as above for different account - in order to combine below
tuser.BFH <- as.data.frame(getUser('hardlinefanpage'))
tuser.BFH$tname <- "HardlineFanPage"
tuser.BFH$date <- today()

## same as above for yet another account - in order to combine below
tuser.TF <- as.data.frame(getUser('titanfallgame'))
tuser.TF$tname <- "Titanfallgame"
tuser.TF$date <- today()

## bind account info for all 3 above into one data frame
tusers.EA <- rbind(tusers.EA,tuser.EAAccess)
tusers.EA <- rbind(tusers.EA,tuser.BFH)
tusers.EA <- rbind(tusers.EA,tuser.TF)


### OR...AUTOMATE THE PROCESS WITH LOOP FOR EASY HANDLING OF MULTIPLE ACCOUNTS
## get list of accounts
tusers <- c("EAAccess",
            "HardlineFanPage",
            "Titanfallgame")
ntusers <- length(tusers) ## count number of accounts to determine how many loop cycles

## run loop to collect current data with date stamp for all accounts and bind into
## one data frame
## set up to run automatically to compare change in numbers over time
for (i in 1:ntusers){
  tuser <- as.data.frame(getUser(tusers[i]))
  tuser$tname <- tusers[i]
  tuser$date <- today()
  tusers.EA <- rbind(tusers.EA,tuser)
}
