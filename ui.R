library(shiny)
library(ggplot2)
library(shinyjqui)


fluidPage(
  
  headerPanel("Fortnite Friday"),
  
  sidebarPanel(
    width=2,
    uiOutput("select_tourny_date"),
    
    selectInput("plot_choice",
                label = "Plot View",
                choices = c("Player", "Team", "Both"),
                selected = "Player",
                width="180px"),
    
    checkboxInput("team_facet", "Split By Team", value = FALSE, width="180px"),
    
    
    selectInput("select_team_kills",
                label="Type of Team Kills",
                choices = list("Game Kills"="Game Kills", "Total Kills"="Total Kills"),
                selected="Game Kills",
                width="180px"),
    helpText("'Game Kills' shows the kills by a team in the game not including the bonus for victory royales.")
  ),
  
  mainPanel(
    jqui_resizable(plotOutput('killsPlot'))
  )
)