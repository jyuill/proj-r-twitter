
library(twitteR)
library(dplyr)
library(ggplot2)
library(lubridate)

### get auth keys from twitter_keys.R file (not available on git)
### run command and answer question provided before other code
setup_twitter_oauth(my_key, my_secret, my_access_token, my_access_secret)

#### GET CURRENT ACCOUNT INFO - FOLLOWERS ETC
### PROCESS WITH LOOP FOR EASY HANDLING OF MULTIPLE ACCOUNTS
## Set list of accounts

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

write.csv(tusers.EA,"tw-users-EA.csv")