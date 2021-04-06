
#コマンドからrmdファイルを変換
rmarkdown::render(
  "C23.Rmd",
  output_format="word_document"
)

install.packages("flexdashboard")

install.packages("leaflet")
library(leaflet)
leaflet() %>%
  setView(174.764, -36.877, zoom=16) %>%
  addTiles() %>%
  addMarkers(174.764, -36.877, popup="Manungawhau")
  
library(shiny)


textInput("name", "What i your name?")
numericInput("age", "How old are you?", NA, min=0, max=150)
