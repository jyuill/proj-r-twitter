
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
tusers <- c("EAAccess",
            "HardlineFanPage",
            "Titanfallgame",
            "EA",
            "EASPORTSFIFA",
            "Battlefield",
            "EAMaddenNFL",
            "EAStarWars",
            "EASPORTSNHL",
            "Mirrorsedge",
            "CallofDuty",
            "officialpes"
            )

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

### SAVE IN CSV
## basic csv
write.csv(tusers.EA,"TW-users-EA.csv",row.names = FALSE)
# backup - add current date to file name for reference
# get current date in string format
dt <- as.character(today())
fname <- paste(c("TW-users-EA",dt,".csv"),collapse="_")
# remove _ before .csv to clean up
fname <- gsub("_.csv",".csv",fname)
# save file to current working directory with current date
write.csv(tusers.EA,fname,row.names=FALSE)
# Now you can read data into another file for analysis!

ggplot(tusers.EA,aes(x=tname,y=followersCount))+geom_bar(stat="identity")+theme_classic()
ggplot(tusers.EA,aes(x=tname,y=followersCount))+geom_bar(stat="identity")+
  theme_bw()+
  coord_flip()


