# Data Science Capstone Project - Next word prediction

# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

library(shiny)

# Define UI for application
shinyUI(fluidPage(

    # Application title
    titlePanel("Data Science Capstone Project - Next word prediction"),
    h4('Ronald'),
    h5('7 March 2021'),
    
    # Sidebar with a words input
    sidebarLayout(
        sidebarPanel(
            textInput("txt", label = "Enter text here", value = "how are you", width = NULL, placeholder = NULL),
            h5('(Sample input: \'how are you\')'),
        ),

        # Show entered words and predicted results
        mainPanel(
            h3('Word Prediction Result'),
            h5('The main objective of application is to predict the next word likely to come next (English words only).'),
            h5('Please allow sometime for the system to load the first time.'),
            h4('You had entered'),
            verbatimTextOutput("inputText"),
            h4('Next three predicted words'),
            verbatimTextOutput("suggestions")
        )
    )
))