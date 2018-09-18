library(devtools)
library(rjson)
library(httr)
library(bit64)
library(base64enc)
library(plyr)
library(httr)
library(doBy)
library(Quandl)
library(twitteR)
library(RCurl)
library(devtools)
library(base64enc)
library(wordcloud)
library(tm)
library(rvest) 
library(stringr)

api_key <- "RUT41tpsoJsqvpnp00YOLG9fg"
api_secret <- "XdTXbfenmkMDhSbAlDp4upZCIMDv7L59e9SWElj79W6VypVGub"
access_token <- "980479435660058626-LXZipwrCJwGV76jq2m1JLtDTYMxkpJJ"
access_token_secret <- "aynQtOnEF0Re1dT4vlie2w9Xptf3Y9wd4RToRI6Gb2TP2"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

Sud_negative = scan('C:\\Users\\HaDoPe\\Desktop\\nw.txt', what='character',comment.char=';')
Sud_positive = scan('C:\\Users\\HaDoPe\\Desktop\\pw.txt', what='character',comment.char=';')
score.sentence <- function(sentence, Sud_positive, Sud_negative) {
  sentence = gsub('[[:punct:]]', '', sentence)
  sentence = gsub('[[:cntrl::]]', '', sentence)
  sentence = gsub('\\d+', '', sentence)
  sentence = tolower(sentence)
  word.list = str_split(sentence, '\\s+')
  words = unlist(word.list)
  positive_matches = match(words, Sud_positive)
  negative_matches = match(words, Sud_negative)
  positive_matches = !is.na(positive_matches)
  negative_matches = !is.na(negative_matches)
  score = sum(positive_matches) - sum(negative_matches)
  return(score)
}
score.sentiment <- function(sentences, Sud_positive, Sud_negative) {
  require(plyr)
  require(stringr)
  scores = laply(sentences, function(sentence, Sud_positive, Sud_negative) {
    tryCatch(score.sentence(sentence, Sud_positive, Sud_negative ), error=function(e) 0)
  }, Sud_positive, Sud_negative)
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}
collect_and_score <- function (handle,Games,GameAbbr,  Sud_positive, Sud_negative) {
  require(plyr)
  require(stringr)
  tweets = searchTwitter(handle, n=500, lang="en", since=NULL, retryOnRateLimit=10)
  text = laply(tweets, function(t) t$getText())
  score = score.sentiment(text, Sud_positive, Sud_negative)
  score$GameAbbr = GameAbbr
  score$Games = Games
  
  return (score)
}
a = collect_and_score("ArenaofValor","Arena of Valor","AOV",Sud_positive, Sud_negative)
b = collect_and_score("@CallofDuty ","Call Of Duty","COD",Sud_positive, Sud_negative)
c = collect_and_score("Clash Royale","Clash Royale","CR",Sud_positive, Sud_negative)
d = collect_and_score("@ESLCS","Counter-Strike: Global Offensive","CSGO",Sud_positive, Sud_negative)
e = collect_and_score("@DOOM","Doom 3","DOOM3",Sud_positive, Sud_negative)
f = collect_and_score("@dota2updates ","DOTA2","DOTA2",Sud_positive, Sud_negative)
g = collect_and_score("@EASPORTSFIFA","FIFA 17","FF",Sud_positive, Sud_negative)
h = collect_and_score("@EsportsGears","Gears of War 4","GOV",Sud_positive, Sud_negative)
i = collect_and_score("@H1Z1","H1Z1","H1z",Sud_positive, Sud_negative)
j = collect_and_score("@halo","HALO5","HALO",Sud_positive, Sud_negative)
k = collect_and_score("@BlizzHeroes ","Heroes of the Storm","HOS",Sud_positive, Sud_negative)
m = collect_and_score("Injustice 2","Injustice 2","IN",Sud_positive, Sud_negative)
n = collect_and_score("@LeagueOfLegends ","League Of Legends","LOL",Sud_positive, Sud_negative)
o = collect_and_score("@EAMaddenNFL","Madden NFL 2017","MAD",Sud_positive, Sud_negative)
p = collect_and_score("@HSesports ","Hearthstone","HS",Sud_positive, Sud_negative)
q = collect_and_score("@PlayOverwatch ","OverWatch","OW",Sud_positive, Sud_negative)
r = collect_and_score("@esportstarcraft","StarCraft II","SC",Sud_positive , Sud_negative)
s = collect_and_score("@FortniteGame","Fortnite","FN",Sud_positive, Sud_negative)
t = collect_and_score("smite","Smite","SM",Sud_positive, Sud_negative)
u = collect_and_score("@rFactor2","rFactor2","RF2",Sud_positive, Sud_negative)
v = collect_and_score("crossfire","Crossfire","CF",Sud_positive, Sud_negative)
w = collect_and_score("starcraft","StarCraft: Brood War","SC",Sud_positive, Sud_negative)
x = collect_and_score("quake","Quake Champions","QC",Sud_positive, Sud_negative)
y = collect_and_score("PUBG","PLAYERUNKNOWN'S BATTLEGROUNDS","PUBG",Sud_positive, Sud_negative)
z = collect_and_score("Paladins","Paladins","PD",Sud_positive, Sud_negative)
aa = collect_and_score("RocketLeague","Rocket League","RL",Sud_positive, Sud_negative)
ab = collect_and_score("vainglory","Vain Glory","VG",Sud_positive, Sud_negative)
ac = collect_and_score("@officialpes","Pro Evolution Soccer 2017","PES",Sud_positive, Sud_negative)
ad = collect_and_score("starcraft2","StarCraft II","SC2",Sud_positive, Sud_negative)
af = collect_and_score("worldoftanks","World of Tanks","WOT",Sud_positive, Sud_negative)
ag = collect_and_score("worldofwarcraft","World of WarCraft","WW2",Sud_positive, Sud_negative)
ai = collect_and_score("@heroesofnewerth","Heroes of Newerth","HONN",Sud_positive,Sud_negative)

all.scores= rbind(a,b,c,d,e,f,g,h,i,j,k,m,n,o,p,q,r,s,t,u,v,w,x,y,z,aa,ab,ac,ad,af,ag)
all.scores$very.pos = as.numeric( all.scores$score >= 2)
all.scores$very.neg = as.numeric( all.scores$score <= -2)
View(all.scores)

#near 0
all.scores$very.pos = as.numeric( all.scores$score >= 1)
all.scores$score = as.numeric( all.scores$score <= -1)

#the pos/neg sentiment scores for different games
twitter.df = ddply(all.scores,c('Games', 'GameAbbr'), summarise, Positive.Sentiments = sum (very.pos), Negative.Sentiments = sum(very.neg))
twitter.df$Total = twitter.df$Positive.Sentiments + twitter.df$Negative.Sentiments


write.csv(twitter.df,"Sentiment.csv")

