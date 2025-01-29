library(shiny)
library(googlesheets4)
library(shinyjqui)


gs4_deauth()
url_data <- read_sheet("https://docs.google.com/spreadsheets/d/14DQFoUMEDOaiDwJbfivyRSpJ2rijGwO-wHohUgCWDIk/edit?usp=sharing")
data <- url_data %>% data.frame()
possible_dates <- unique(data$`Tourny_Date`)

fluidPage(
  
  headerPanel("Fortnite Friday"),
  
  sidebarPanel(
    width=2,
    
    selectInput("select_tourny_date",
                label="Tournament Date",
                choices = possible_dates,
                selected = tail(possible_dates, n=1),
                width="180px"),
    
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