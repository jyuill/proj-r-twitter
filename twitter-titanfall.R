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

#### USER-SPECIFIC tweets using user name
### Timeline of user to max n=3200 - enables excluding retweets and replies
### use maxID or sinceID to filter based on dates
timeline_user<- userTimeline("titanfallgame",n=3200,includeRts = TRUE,excludeReplies = FALSE)
timeline_user.df <- twListToDF(timeline_user)

str(timeline_user.df)
summary(timeline_user.df)

#### ANALYZING TITANFALL
tf <- timeline_user.df
str(tf)
### do some clean-up
## add field with created date as date rather than POSIXct
tf$tdate <- as.Date(tf$created)
## create month and year cols for aggregating by year, mth
tf$month <- format(tf$tdate,'%m')
tf$year <- format(tf$tdate,'%Y')
tf$yrmth <- format(tf$tdate,'%y-%m')

## classify tweets by type: tweet, retweet, reply
tf$type <- "tweet"
for (i in 1:nrow(tf)){
  if(tf[i,"isRetweet"]==TRUE) {
    tf[i,"type"] <- "retweet"
  } else if (!is.na(tf[i,"replyToSN"])){
             tf[i,"type"] <- "reply"
  }  else {
  tf[i,"type"] <- "tweet"
  }
}
table(tf$type) ## check breakdown of type
tf$type <- as.factor(tf$type) ## convert to factor
## create counter field, set as 1
tf$tcount <- 1
## create month and year cols for aggregating by year, mth
tf$year <- format(tdate,'%Y')

## group by date and plot number of tweets
tf_date <- tf %>%
  group_by(tdate) %>%
  summarize(tweets=sum(tcount))

ggplot(tf_date,aes(x=tdate,y=tweets))+geom_bar(stat="identity")
ggplot(tf_date,aes(x=tdate,y=tweets))+geom_line()

## aggregate tweet count by month
tf_yrmth <- tf %>%
  group_by(yrmth) %>%
  summarize(tweets=sum(tcount))
ggplot(tf_yrmth,aes(x=yrmth,y=tweets))+geom_bar(stat="identity")

## group by date, type and plot type by date
tf_type <- tf %>%
  group_by(yrmth,type) %>%
  summarise(tweets=sum(tcount))

ggplot(tf_type,aes(x=yrmth,y=tweets,fill=type))+geom_bar(stat="identity")
## display breakdown by %
ggplot(tf_type,aes(x=yrmth,y=tweets,fill=type))+geom_bar(stat="identity",position="fill")

#### NEXT:
## exclude replies and retweets
## see which ones most retweeted / favourited
## possibly classify them by topic?
