#Fast-fashion retailers data available for basic twitter API

# Getting data (from Twitter)
library('twitteR')
consumer_key <- "XXXXXX"
consumer_secret <- "XXXXXXX"
access_token <- "XXXXXXXX"
access_secret <- "XXXXXXXX"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


getdata<-function(hashtag){
twitterdata<-searchTwitter(hashtag,n=1.7e3,lang="en",since='2016-10-21 08:15:15 UTC') #size depending on API limit
file_dir<-paste("/home/vanniagm/drop/Dropbox/DataScience/Incubator/data/twitter_",hashtag,".RDS",sep="")
saveRDS(twitterdata, file_dir)
}

getdata("#zara");getdata("#topshop");getdata("#hm");getdata("#forever21")

readdata<-function(retail){
        file_dir<-paste("/home/vanniagm/drop/Dropbox/DataScience/Incubator/data/twitter_#",retail,".RDS",sep="")
        twitterdata<-readRDS(file_dir)
        twListToDF(twitterdata)
}

retails<-lapply(list("zara","hm","topshop","forever21"),readdata)



#Retweets vs originals

# how many retweets each fast-fashion retail has just as an example, 
#cannot compare total counts with Forever21 because API would limit the request
sapply(retails,function(df){sum(df$retweetCount)})

# Network analysis
org_tweets<-lapply(retails,function(df){df[df$isRetweet==FALSE,]})
rts<-lapply(retails,function(df){df[df$isRetweet==TRUE,]})
rts <- lapply(rts,function(x){mutate(x, author = substr(text, 5, regexpr(':', text) - 1))})

library('igraph')
library('network') 
library('sna')
library('ldplyr')
df<-list()
for(i in 1:4){
df[[i]]<-as.data.frame(cbind(node = rts[[i]]$author, edge = rts[[i]]$screenName))
df[[i]]<-count(df[[i]],node,edge)
}


zaranet<-network(df[[1]],matrix.type = 'edgelist', directed = F, 
                 ignore.eval = FALSE, names.eval = 'num')
hmnet<-network(df[[2]],matrix.type = 'edgelist', directed = F, 
                 ignore.eval = FALSE, names.eval = 'num')
topshopnet<-network(df[[3]],matrix.type = 'edgelist', directed = F, 
                 ignore.eval = FALSE, names.eval = 'num')
forevernet<-network(df[[4]],matrix.type = 'edgelist', directed = F, 
                 ignore.eval = FALSE, names.eval = 'num')


par(mfrow=c(2,2))

plot(zaranet,edge.lwd = 'num', vertex.col="blue",
     edge.col = "gray60", main = 'Zara retweet network')
plot(hmnet,edge.lwd = 'num', vertex.col="blue",
      edge.col = "gray60", main = 'H&M retweet network')
plot(topshopnet,edge.lwd = 'num', vertex.col="blue",
       edge.col = "gray60", main = 'Topshop retweet network')
plot(forevernet,edge.lwd = 'num', vertex.col="blue",
       edge.col = "gray60", main = 'Forever21 retweet network')


# Although instagram has limited access with basic App accounts, 
# many fashion-related tweets are instagram tweets


par(mfrow=c(1,1),mar = c(2, 3, 3, 1))
for(i in 1:4){
retails[[i]]$statusSource1 <- substr(retails[[i]]$statusSource, 
                        17, 27)
}

par(mfrow=c(2,2),oma=c(0,0,2,0),mar=c(2,2,2,2))

retailstable<-as.data.frame(sort(table(retails[[1]]$statusSource1)))
retailstable<-retailstable[retailstable$Freq>5,]

dotchart(retailstable[,2],labels=retailstable[,1],main="Zara tweets")

retailstable<-as.data.frame(sort(table(retails[[2]]$statusSource1)))
retailstable<-retailstable[retailstable$Freq>5,]

dotchart(retailstable[,2],labels=retailstable[,1],main="H&M tweets")

retailstable<-as.data.frame(sort(table(retails[[3]]$statusSource1)))
retailstable<-retailstable[retailstable$Freq>5,]

dotchart(retailstable[,2],labels=retailstable[,1],main="Topshop tweets")

retailstable<-as.data.frame(sort(table(retails[[4]]$statusSource1)))
retailstable<-retailstable[retailstable$Freq>5,]

dotchart(retailstable[,2],labels=retailstable[,1],main="Forever21 tweets")

mtext("Frequent social media sources", outer = TRUE, cex = 1.)
