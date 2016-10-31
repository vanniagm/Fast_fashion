# README


 1st draft on analytics for the popular fast-fashion retail stores: Zara, H&M, Topshop, Forever21 from social media. 
 
 This repo contains 
 
- Two exploratory graphs with the purpose of illustrating targeting social-media influencers.
 


## Obtaining the dataset

The dataset was obtained from Twitter (using the 'twitteR' package in R) searching for the hashtags: 
\#zara, #hm, #topshop and #forever21 in english since '2016/06/01', for a limit set by the API (i.e. n=1700).

```
consumer_key <- ""
consumer_secret <- ""
access_token <- ""
access_secret <- ""
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

getdata<-function(hashtag){
twitterdata<-searchTwitter(hashtag,n=1.7e3,lang="en",since='2016-10-21 08:15:15 UTC') #size depending on API limit
file_dir<-paste("/.../data/twitter_",hashtag,".RDS",sep="")
saveRDS(twitterdata, file_dir)
}
getdata("#zara");getdata("#topshop");getdata("#hm");getdata("#forever21")
```
