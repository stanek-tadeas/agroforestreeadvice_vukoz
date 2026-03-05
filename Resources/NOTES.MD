Přidat pomocné texty - buď úvodní Introduction nebo možná lépe
    - otazníčky ke každé možnosti

- aktualizovat obě stránky na poslední build:
    + feedback
    + otazníčky
    + Změnit "Informace" - předělat na "úvodní" stránku - jak poprvé použít,
        že nejprve vybrat levou stranu, dát si pozor na vymazávací/tvrdé filtry
        a poté si hrát s jednotlivými nastaveními v pravé straně


# otestovat:

library(shiny)
library(shinyBS)

shinyApp(
  ui = fluidPage(
    br(),
    selectInput("works", 
                label = tags$span(
                  "This works", 
                  tags$i(
                    class = "glyphicon glyphicon-info-sign", 
                    style = "color:#0072B2;",
                    title = "Further information "
                  )),
                choices = c("a","b")),

    selectInput("worksnow", 
      label = tags$span("This works now too", bsButton("thisworks", label = "", icon = icon("info"), style = "info", size = "extra-small")),
      choices = c("a","b")
    ),
    bsPopover(
      id = "thisworks",
      title = "More information",
      content = paste0(
        "Any HTML can be here ",
        a("ShinyBS", href = "https://ebailey78.github.io/shinyBS/index.html", target="_blank")
      ),
      placement = "right",
      trigger = "hover",
      options = list(container = "body")
    )
  ),
  
  server = function(input, output) {

  }
)

# A nebo:

library(shiny)
library(bslib)

css <- '
.tooltip {
  pointer-events: none;
}
.tooltip > .tooltip-inner {
  pointer-events: none;
  background-color: #73AD21;
  color: #FFFFFF;
  border: 1px solid green;
  padding: 10px;
  font-size: 25px;
  font-style: italic;
  text-align: justify;
  margin-left: 0;
  max-width: 1000px;
}
.tooltip > .arrow::before {
  border-right-color: #73AD21;
}
'

js <- "
$(function () {
  $('[data-toggle=tooltip]').tooltip()
})
"

shinyApp(
  server = function(input,output,session){},
  ui = fluidPage(
    theme = bs_theme(version = 4),
    tags$head(
      tags$style(HTML(css)),
      tags$script(HTML(js))
    ),
    br(),
    span(
      "Example",
      span(
        `data-toggle` = "tooltip", `data-placement` = "right",
        title = "A tooltip",
        icon("info-circle")
      )
    )
  )
)
