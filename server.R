library(shiny)
library(googlesheets)
library(gridExtra)
library(ggplot2)
library(dplyr)


url_data <- gs_url("https://docs.google.com/spreadsheets/d/14DQFoUMEDOaiDwJbfivyRSpJ2rijGwO-wHohUgCWDIk/edit?usp=sharing")
data <- url_data %>% gs_read(ws = "Sheet1") %>% data.frame

# Clean variable names
names(data) <- gsub("_", " ", names(data))

player_data <- reshape2::melt(data[,1:9],
                              variable.name="Player",
                              value.name="No. Kills",
                              id.vars=c("Tourny Date","Team", "Game"))
player_data$Player <- as.character(sapply(as.character(player_data$Player), function(y) paste(unlist(strsplit(y, " "))[[1]][1], collapse = " ")))
player_data <- player_data[complete.cases(player_data),]

team_data <- reshape2::melt(data[,c(1:3,10:12)],
                            variable.name="variable",
                            value.name="No. Kills",
                            id.vars=c("Tourny Date","Team", "Game", "Victory Royale"))
team_data <- team_data[complete.cases(team_data),]

possible_dates <- unique(data$`Tourny Date`)

function(input, output) {
  # Output dates based on whats in the data
  output$select_tourny_date <- renderUI({
    selectInput("select_tourny_date",
                label="Tournament Date",
                choices = possible_dates,
                selected = tail(possible_dates, n=1),
                width="180px")
  })
  
  #add reactive data information
  player_dataset <- reactive({
    unique(subset(player_data,`Tourny Date`==(as.character(input$select_tourny_date))))
  })
  
  team_dataset <- reactive({
    unique(subset(team_data, variable==input$select_team_kills & `Tourny Date`==(as.character(input$select_tourny_date))))
  })
  
  output$killsPlot <- renderPlot({
    
    # build graph with ggplot syntax
    player_plot <- ggplot(data=player_dataset(), aes(x=Game, y=`No. Kills`, color=Team, shape=Player)) +
      geom_point() + 
      labs(title="Player Kills") +
      theme_bw()
    
    team_plot <- ggplot(data=team_dataset(), aes(x=Game, y=`No. Kills`, color=Team, shape=`Victory Royale`)) +
      geom_point() +
      labs(title="Team Kills") +
      theme_bw()
    
    # Add facets
    if(input$team_facet){
      player_plot <- player_plot + facet_grid(~Team)
      team_plot <- team_plot + facet_grid(~Team)
    }
    
    # Return different plots based on user selection
    if(input$plot_choice == "Player"){
      return(player_plot)
    }else if(input$plot_choice == "Team"){
      return(team_plot)
    }else if(input$plot_choice == "Both"){
      return(grid.arrange(player_plot, team_plot, nrow=2))
    }
    
  })
  
  
}



