rm(list=ls())
#Loading the rvest package
library('rvest')
library('purrr')
library('dplyr')
#Specifying the url for desired website to be scraped
baseurl <- 'https://www.glassdoor.com/Reviews/Boehringer-Ingelheim-Reviews-E10416'
url1<-paste(baseurl,".htm",sep="")
df<-data.frame()
temp_df<-data.frame()
url1 %>% 
  read_html() %>% 
  html_nodes("strong") %>% 
  html_text() -> Total_Reviews
maxresults <- as.integer(ceiling(as.integer(Total_Reviews)/10))
#Using CSS selectors to scrape the Employee header section

for(i in 1:maxresults) {
  print(i)
  if (i==1){
    url<-paste(baseurl,".htm",sep="")
  }
  else if (i>1){
    url<-paste(baseurl,"_P",i,".htm",sep="")
  }

  AuthorLocation<-url %>% 
    read_html() %>% 
    html_nodes(".authorInfo") %>% 
    html_text()
  Pros<-url %>% 
    read_html() %>% 
    html_nodes(".mb-0+ .v2__EIReviewDetailsV2__fullWidth .v2__EIReviewDetailsV2__lineHeightLarge") %>% 
    html_text()
  Cons<-url %>% 
    read_html() %>% 
    html_nodes(".v2__EIReviewDetailsV2__fullWidth+ .v2__EIReviewDetailsV2__fullWidth .v2__EIReviewDetailsV2__lineHeightLarge") %>% 
    html_text()
  ReviewDate<-url %>% 
    read_html() %>% 
    html_nodes(".date") %>% 
    html_text()
  ReviewMainText<-url %>% 
    read_html() %>% 
    html_nodes(".mainText") %>% 
    html_text()
  ReviewTitle<-url %>% 
    read_html()%>% 
    html_nodes(".strong.mb-xsm") %>% 
    html_text()
  OverallRating<-url %>%
  read_html()%>% 
  html_nodes(".v2__EIReviewsRatingsStylesV2__small") %>%
  html_text()
  
  

  temp_df<-data.frame(AuthorLocation=AuthorLocation,Pros=Pros,Cons=Cons,ReviewDate=ReviewDate,ReviewMainText=ReviewMainText,ReviewTitle=ReviewTitle,OverallRating=OverallRating)
  df <- bind_rows(df, temp_df)
  Sys.sleep(sample(seq(1, 5, by=0.01), 1))
  
  write.csv(df,"C:\\Users\\phani\\Desktop\\MyData.csv", row.names = FALSE)
  
}

