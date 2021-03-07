# Data Science Capstone Project - Next word prediction

# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.

library(tidyverse)
library(quanteda)
library(lexicon)
library(tidytext)
library(data.table)

library(shiny)



#Load data
bigram <- data.table(read_csv("https://github.com/ronaldyeo/Data-Science-Capstone-Project/raw/master/trigram.csv.gz"))

trigram <- data.table(read_csv("https://github.com/ronaldyeo/Data-Science-Capstone-Project/raw/master/trigram.csv.gz"))


# Define server logic
shinyServer(function(input, output) {
    
    output$inputText <- renderText({ input$txt }, quoted = FALSE)
    
    observeEvent(input$txt, {
        enter.words <- tolower(input$txt)
        
        #Tokenise enter words
        tokenised.enter.words <- tokens(
            enter.words,
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
        
        
        enter.words <- tokens_ngrams(tokenised.enter.words, n = 1) %>% unlist()
        no.enter.words <- length(enter.words)
        
        w1 <- enter.words [no.enter.words - 1]
        w2 <- enter.words [no.enter.words - 0]
        
        
        bigram.predict <- bigram [bigram$word1 == w2,]
        
        bigram.predict.t3 <- bigram.predict$word2 [1:3]
        
        
        trigram.predict <- trigram [trigram$word1 == w1 & trigram$word2 == w2,]
        
        trigram.predict.t3 <- trigram.predict$word3 [1:3]
        
        combine.predict.t3 <- c(trigram.predict.t3 [!is.na(trigram.predict.t3)], bigram.predict.t3 [!is.na(bigram.predict.t3)])[1:3]
        
        output$suggestions  <- renderPrint({
        cat(combine.predict.t3, sep = "  |  ")

        })
    })
    
    })