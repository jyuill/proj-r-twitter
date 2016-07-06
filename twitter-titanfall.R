### Collecting Twitter data using twitteR
### https://cran.r-project.org/web/packages/twitteR/twitteR.pdf

### make sure all packages are available and load them
library(twitteR)
library(dplyr)
library(ggplot2)
library(ggvis)
library(lubridate)
library(qdapRegex) ## for extracting link urls from text
library(RCurl) ## to expand shortened urls

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
## most accurate classification
## better than relying on the classification in the dataset (replytoSN or replytoSID)
## regex tests for '@' or '.@' at beginning of tweet
## also tests for no '@' (which is -1)
## tweet number is more accurate than running userTimeLine with includeRts = FALSE and excludeReplies=TRUE
for (i in 1:nrow(tf)){
  if(tf[i,"isRetweet"]==TRUE) {
    tf[i,"type"] <- "retweet"
  } else if (regexpr("@",tf[i,"text"])<0) {
    tf[i,"type"] <- "tweet"
  } else if (regexpr("@",tf[i,"text"])<3){
    tf[i,"type"] <- "reply"
  } else {
    tf[i,"type"] <- "tweet"
  }
}

table(tf$type) ## check breakdown of type
tf$type <- as.factor(tf$type) ## convert to factor
## create counter field, set as 1
tf$tcount <- 1

## group by date and plot number of tweets
tf_date <- tf %>%
  group_by(tdate) %>%
  summarize(tweets=sum(tcount))

ggplot(tf_date,aes(x=tdate,y=tweets))+geom_bar(stat="identity")
ggplot(tf_date,aes(x=tdate,y=tweets))+geom_line()
tf_date %>% ggvis(~tdate,~tweets) %>% layer_lines()

## aggregate tweet count by month
tf_yrmth <- tf %>%
  group_by(yrmth) %>%
  summarize(tweets=sum(tcount))
ggplot(tf_yrmth,aes(x=yrmth,y=tweets))+geom_bar(stat="identity")
tf_yrmth %>% ggvis(x=~yrmth,y=~tweets) %>% layer_bars() 

## group by date, type and plot type by date
tf_type <- tf %>%
  group_by(yrmth,type) %>%
  summarise(tweets=sum(tcount))

ggplot(tf_type,aes(x=yrmth,y=tweets,fill=type))+geom_bar(stat="identity")
## display breakdown by %
ggplot(tf_type,aes(x=yrmth,y=tweets,fill=type))+geom_bar(stat="identity",position="fill")
tf_type %>% ggvis(x=~yrmth,y=~tweets,fill=~type) %>% layer_bars()

#### 
## exclude replies and retweets - close but may pick up some '.@xxx' replies
timelinetweet_user<- userTimeline("titanfallgame",n=3200,includeRts = FALSE,excludeReplies = TRUE)
timelinetweet_user.df <- twListToDF(timelinetweet_user)
str(timelinetweet_user.df)
summary(timelinetweet_user.df)

## most accurate is to use original query with 'type' categorization from above
tftweet <- tf %>% filter(type=="tweet") 
tftreply <- tf %>% filter(type=="reply")
tfretweet <- tf %>% filter(type=="retweet")

## see which ones most retweeted / favourited
ggplot(tftweet,aes(x=favoriteCount))+geom_histogram(binwidth=100)
ggplot(tftweet,aes(x=retweetCount))+geom_histogram(binwidth=50)
ggplot(tftweet,aes(x=retweetCount,y=favoriteCount))+geom_point()
tftweet %>% ggvis(x=~retweetCount,y=~favoriteCount) %>% layer_points()

write.csv(tftweet,"tftweet.csv",row.names = FALSE)

## most retweeted - can't do retweet % because don't know impressions :(
tftweet %>% 


## identify tweets that have links in them
tftweet$haslink <- FALSE
for (i in 1:nrow(tftweet)){
  if (regexpr("http",tftweet[i,"text"])>0) {
    tftweet[i,"haslink"] <- TRUE
  } else {
    tftweet[i,"haslink"] <- FALSE
  }
}

## extract links from tweets and put link urls in another field
tftweet$link <- ""
for (i in 1:nrow(tftweet)){
  if (regexpr("http",tftweet[i,"text"])>0) {
    tftweet[i,"link"] <- as.character(ex_twitter_url(tftweet[i,"text"]))
  } else {
    tftweet[i,"link"] <- ""
  }
}

## now need to decode short URLs...can't get it to work
decode_short_url(tftweet[2,"link"])
decode_short_url("https://t.co/HuygAbTSJW")
decode_short_url("http://tinyurl.com/adcd")
decode_short_url("bit.ly/29uaypk")

## possibly classify them by topic?
