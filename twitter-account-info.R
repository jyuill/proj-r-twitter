
library(twitteR)
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)

### get auth keys from twitter_keys.R file (not available on git)
### run command and answer question provided before other code
setup_twitter_oauth(my_key, my_secret, my_access_token, my_access_secret)

#### GET CURRENT ACCOUNT INFO - FOLLOWERS ETC
### PROCESS WITH LOOP FOR EASY HANDLING OF MULTIPLE ACCOUNTS

## Set list of accounts
## ultimately should have these in a spreadsheet and pull in from there
tusers <- c("EAAccess",
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
tusers.EA <- read.csv("TW-users-EA.csv",header=TRUE)
tusers.EA$created <- as.Date(tusers.EA$created)
tusers.EA$date <- as.Date(tusers.EA$date)
for (i in 1:ntusers){
  tuser <- as.data.frame(getUser(tusers[i]))
  tuser$date <- today()
  tusers.EA <- rbind(tusers.EA,tuser)
}

### CALCULATE CHANGE FROM ONE DATE TO NEXT
## 1. remove extraneous cols and group by screenName and date
tusers.follow <- tusers.EA %>%
  select(followersCount,name,date) %>%
  arrange(name,date)
## 2. calculate 
tusers.follow <- tusers.follow %>%
  group_by(name) %>%
  mutate(chg=followersCount-lag(followersCount)) %>%
  mutate(chgpc=chg/lag(followersCount))


### SAVE IN CSV
## basic csv
write.csv(tusers.EA,"TW-users-EA.csv",row.names = FALSE)
write.csv(tusers.follow,"TW-users-follow.csv",row.names=FALSE)
# backup - add current date to file name for reference
# get current date in string format
dt <- as.character(today())
fname <- paste(c("TW-users-EA",dt,".csv"),collapse="_")
# remove _ before .csv to clean up
fname <- gsub("_.csv",".csv",fname)
# save file to current working directory with current date
write.csv(tusers.EA,fname,row.names=FALSE)
# Now you can read data into another file for analysis!


### basic bar chart showing totals across all dates - only relevant for single date
tusers.latest <- tusers.EA %>%
  filter(date==max(date))
ggplot(tusers.latest,aes(x=name,y=followersCount))+geom_bar(stat="identity")+theme_classic()
## flip coordinates to be more readable
ggplot(tusers.latest,aes(x=name,y=followersCount))+geom_bar(stat="identity")+
  theme_bw()+
  coord_flip()+
  scale_y_continuous(labels=comma)

### bar chart showing follower numbers side-by-side by date, for each account
ggplot(tusers.EA,aes(x=name,y=followersCount,fill=as.factor(date)))+geom_bar(stat="identity",
                                                                        position=position_dodge())+
  theme_bw()+
  coord_flip()+
  scale_y_continuous(labels=comma)

### line chart comparing followers by date for each account
ggplot(tusers.EA,aes(x=date,y=followersCount,col=name))+geom_line()+
  theme_minimal()+
  scale_y_continuous(labels=comma)+
  scale_x_date(date_labels="%b-%e") # coudl add %y for 2-digit yr or %Y for 4-digit yr

### chart showing daily change in followers
ggplot(tusers.follow,aes(x=name,y=chg,fill=as.factor(date)))+geom_bar(stat="identity",
                                                                             position=position_dodge())+
  theme_bw()+
  coord_flip()+
  scale_y_continuous(labels=comma)

ggplot(tusers.follow,aes(x=name,y=chgpc,fill=as.factor(date)))+geom_bar(stat="identity",
                                                                      position=position_dodge())+
  theme_bw()+
  coord_flip()+
  scale_y_continuous(labels=percent)


