library(tidyverse)
library(quanteda)
library(lexicon)
library(tidytext)
library(data.table)

#Set seed for reproducibility
set.seed(2)


#Read files
en_US.news.txt <- file("./en_US.news.txt.gz", open = "r")
en_US.news <- readLines(en_US.news.txt, encoding="UTF-8", skipNul=T)

en_US.blogs.txt <- file("./en_US.blogs.txt.gz", open = "r")
en_US.blogs <- readLines(en_US.blogs.txt, encoding="UTF-8", skipNul=T)

en_US.twitter.txt <- file("./en_US.twitter.txt.gz", open = "r")
en_US.twitter <- readLines(en_US.twitter.txt, encoding="UTF-8", skipNul=T)

close.connection(en_US.news.txt, en_US.blogs.txt, en_US.twitter.txt)
rm(en_US.news.txt, en_US.blogs.txt, en_US.twitter.txt)


#sampling
n <- 0.1
en_US.news.sample <- sample(en_US.news, length(en_US.news) * n)
en_US.blogs.sample <- sample(en_US.blogs, length(en_US.blogs) * n)
en_US.twitter.sample <- sample(en_US.twitter, length(en_US.twitter) * n)

rm(n, en_US.news, en_US.blogs, en_US.twitter)


#Combine all samples and covert to corpus object
vector <- tolower(corpus(c(en_US.news.sample, en_US.blogs.sample, en_US.twitter.sample)))


#vector <- c(en_US.news.sample, en_US.blogs.sample, en_US.twitter.sample)
rm(en_US.news.sample, en_US.blogs.sample, en_US.twitter.sample)


#Tokenise the vector
tokenised.vector <- tokens(
        vector,
        remove_punct = T,
        remove_symbols = T,
        remove_numbers = T,
        remove_url = T,
        remove_separators = T,
        split_hyphens = T,
        include_docvars = T,
        padding =T,
        verbose = quanteda_options("verbose"),
)

rm(vector)


#Build ngram
bigram <- tokens_ngrams(tokenised.vector, n = 2) %>% unlist() %>% data.table()
bigram <- separate(bigram, col = ., into = c("word1", "word2"), sep = "_") %>% 
        count(word1,word2,sort = T)

trigram <- tokens_ngrams(tokenised.vector, n = 3) %>% unlist() %>% data.table()
trigram <- separate(trigram, col = ., into = c("word1", "word2", "word3"), sep = "_") %>% 
        count(word1, word2, word3, sort = T)

rm(tokenised.vector)

#Export to csv
write.csv(bigram, file = gzfile("bigram.csv.gz"), row.names = FALSE)
write.csv(trigram,file = gzfile("trigram.csv.gz"), row.names = FALSE)
