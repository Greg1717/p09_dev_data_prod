library(shiny)
library(datasets)

# Data pre-processing ----
# Tweak the "am" variable to have nicer factor labels -- since this
# doesn't rely on any user inputs, we can do this once at startup
# and then use the value throughout the lifetime of the app
mpgData <- mtcars[, c("mpg", "disp")]
faithfulData <- faithful

# Define UI for miles per gallon app ----
ui <- fluidPage(
    # App title ----
    titlePanel("Linear Models"),
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        # Sidebar panel for inputs ----
        sidebarPanel(
            # Input: Selector for variable to plot against mpg ----
            selectInput("sel_dataset", "Dataset:",
                        c("MTCARS" = "mpgData",
                          "FAITHFUL" = "faithfulData")),

            # Input: Checkbox for whether outliers should be included ----
            checkboxInput("regression_line", "Draw Regression Line", TRUE)
        ),
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Formatted text for caption ----
            h3(textOutput("caption")),
            # Output: Plot of the selected dataset ----
            plotOutput("sel_plot")
        )
    )
)

# Define server logic ----
server <- function(input, output) {
    formulaText <- reactive({
        paste("Dataset: ", input$sel_dataset)
    })
    # Return the formula text for printing as a caption ----
    output$caption <- renderText({
        formulaText()
    })
    # renderRegressionLine <- reactive({
    #     input$regression_line
    # })
    # Generate a plot of the requested dataset and only draw regression line if selected
    output$sel_plot <- renderPlot({
        if (input$sel_dataset == "mpgData") {
            plot(mpg ~ disp, data = mpgData)
        } else {
            plot(eruptions ~ waiting, data = faithfulData)
        }
        if (input$regression_line) {
            if (input$sel_dataset == "mpgData") {
                lm1 <- lm(mpg ~ disp, data = mtcars)
                abline(lm1)
            } else {
                lm1 <- lm(eruptions ~ waiting, data = faithfulData)
                abline(lm1)
            }
        }
    })
}

# Create Shiny app ----
shinyApp(ui, server)