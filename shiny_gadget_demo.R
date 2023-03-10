# https://shiny.rstudio.com/articles/gadgets.html
library(shiny)
library(miniUI)
library(ggplot2)

ggbrush <- function(data, xvar, yvar) {
    ui <- miniPage(
        gadgetTitleBar("Drag to select points"),
        miniContentPanel(
            # The brush="brush" argument means we can listen for
            # brush events on the plot using input$brush.
            plotOutput("plot", height = "100%", brush = "brush")
        )
    )
    server <- function(input, output, session) {
        # Render the plot
        output$plot <- renderPlot({
            # Plot the data with x/y vars indicated by the caller.
            ggplot(data, aes_string(xvar, yvar)) + geom_point()
        })
        # Handle the Done button being pressed.
        observeEvent(input$done, {
            # Return the brushed points. See ?shiny::brushedPoints.
            stopApp(brushedPoints(data, input$brush))
        })
    }
    runGadget(ui, server)
    # runGadget(ui, server, viewer = paneViewer(minHeight = 500))
    # runGadget(ui, server, viewer = dialogViewer("ggbrush"))
    # runGadget(ui, server, viewer = browserViewer())
}

ggbrush(mtcars, "hp", "mpg")
