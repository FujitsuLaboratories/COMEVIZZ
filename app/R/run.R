library(shiny)

#' start COMEVIZZ
#' @importFrom shiny runApp shinyApp
#' @export
run <- function() {
  shiny::runApp(
    shiny::shinyApp(ui, server),
    host = "0.0.0.0", port = 3838
  )
}
