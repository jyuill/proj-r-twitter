
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
results <- searchTwitter("fifa 17+snoop dog", n=25, lang=NULL, since=start, until=end,
              locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
              resultType=NULL, retryOnRateLimit=120)
## convert results into data frame
results.df <- twListToDF(results)
