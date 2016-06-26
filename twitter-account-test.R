
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
## ultimately should have these in a spreadsheet and pull in from there
tacct <- c("Titanfallgame",
            "EA",
            "EASPORTSFIFA"
            )

ntacct <- length(tacct) ## count number of accounts to determine how many loop cycles

## run loop to collect current data with date stamp for all accounts and bind into
## one data frame
## set up to run automatically to compare change in numbers over time
tusers <- data.frame()
for (i in 1:ntacct){
  tuser <- as.data.frame(getUser(tacct[i]))
  tuser$date <- today()
  tusers <- rbind(tusers,tuser)
}
str(tusers)

## save file for reuse
write.csv(tusers,"tusers-test.csv",row.names = FALSE)
## when read back in, date fields (created, date) become factors
tusers<- read.csv("tusers-test.csv",header=TRUE)
str(tusers)
tusers$created <- as.Date(tusers$created)
tusers$date <- as.Date(tusers$date)
str(tusers)

ggplot(tusers,aes(x=screenName,y=followersCount))+geom_bar(stat="identity")+theme_classic()
ggplot(tusers,aes(x=tname,y=followersCount))+geom_bar(stat="identity")+
  theme_bw()+
  coord_flip()


