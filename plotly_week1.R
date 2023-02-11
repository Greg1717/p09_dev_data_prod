library(plotly)

# scatter plot =================================================================
plot_ly(mtcars, x = mtcars$wt,  y = mtcars$mpg, mode = "markers", type = "scatter")
plot_ly(mtcars, x = mtcars$wt,  y = mtcars$mpg, mode = "markers", type = "scatter", color = as.factor(mtcars$cyl))
plot_ly(mtcars, x = mtcars$wt,  y = mtcars$mpg, mode = "markers", color = mtcars$disp)
plot_ly(mtcars, x = mtcars$wt,  y = mtcars$mpg, mode = "markers", color = as.factor(mtcars$cyl), size = mtcars$hp)

# 3d scatter plot ==============================================================
temp <- rnorm(100, mean = 30, sd = 5)
pressue <- rnorm(100)
dtime <- 1:100
plot_ly(x = temp, y = pressue, z = dtime, type = "scatter3d", mode = "markers", color = temp)

# Line Graphs =================================================================
data("airmiles")
airmiles
time(airmiles)
plot_ly(x = time(airmiles), y = airmiles, mode = "lines")

# Multi Line Graph ============================================================
library(tidyr)
library(dplyr)
data("EuStockMarkets")
head(EuStockMarkets)
str(EuStockMarkets)
time(EuStockMarkets)
stocks <- as.data.frame(EuStockMarkets) %>%
    gather(index, price) %>%
    mutate(time = rep(time(EuStockMarkets), 4))
stocks
head(stocks)
plot_ly(stocks, x = stocks$time, y = stocks$price, color = stocks$index, type = "scatter", mode = "lines")

# histogram ===================================================================
precip
plot_ly(x = precip, type = "histogram")
head(iris)
plot_ly(data = iris, y = iris$Petal.Length, color = iris$Species, type = "box")

# heatmap =====================================================================
terrain1 <- matrix(rnorm(100*100), nrow = 100, ncol = 100)
plot_ly(z = terrain1, type = "heatmap")

terrain2 <- matrix(sort(rnorm(100*100)), nrow = 100, ncol = 100)
plot_ly(z = terrain2, type = "surface")

# choropleth maps =============================================================
# create dataframe
state_pop <- data.frame(State = state.abb, Pop = as.vector(state.x77[,1]))
head(state_pop)
# create hover text
state_pop$hover <- with(state_pop, paste(State, '<br>', "Population:", Pop))
state_pop$hover
# make state borders red
borders <- list(color = toRGB("red"))
# Set up some mapping options
map_options <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showlakes = TRUE,
    lakecolor = toRGB("white")
)
plot_ly(data = state_pop, z = state_pop$Pop, text = state_pop$hover, locations = state_pop$State,
        type = "choropleth", locationmode = 'USA-states',
        color = state_pop$Pop, colors = 'Blues', marker = list(line = borders)) %>%
    layout(title = "US population in 1975", geo = map_options)

# ggplot ========
set.seed(100)
d <- diamonds[sample(nrow(diamonds), 1000),]

p <- ggplot(data = d, aes(x = carat, y = price)) +
    geom_point(aes(text = paste("Clarity:", clarity)), size = 4) +
    geom_smooth(aes(colour = cut, fill = cut)) + facet_wrap( ~ cut)
p
(gg <- ggplotly(p))
gg
plotly_POST(gg)

# Plotly - Chart Studio Account ===============================================
## Create a free account ======================================================
#     A Chart Studio account is required to publish R charts to the web using Chart Studio. It's free to get started, and you control the privacy of your charts.
## Store Credentials ==========================================================
## 2 - Store your Chart Studio authentication credentials as environment variables in your R session
# Your Chart Studio authentication credentials consist of your Chart Studio username and your Chart Studio API key, which can be found in your online settings.
# Use the Sys.setenv() function to set these credentials as environment variables in your R session.

Sys.setenv("plotly_username"="gergely")
Sys.setenv("plotly_api_key"="mgS3BCPvB1tddNKVHEgQ")

api_create(gg)


## .Rprofile ==================================================================
# Save these commands in your .Rprofile file if you want them to be run every time you start a new R session.
## api_create =================================================================
# 3 - Use the api_create() function to publish R charts to Chart Studio:
#     Use the filename attribute to set the title of the file that will be generated in your Chart Studio account.

library(plotly)
p <- plot_ly(midwest, x = ~percollege, color = ~state, type = "box")
api_create(p, filename = "r-docs-midwest-boxplots")

## optional - Suppress auto open behavior: ====================================
#     When following the instructions above, executing api_create(p) will auto open the created Chart Studio URL in the browser. To suppress this behavior, set the browser option to false in your R session.
options(browser = 'false')
api_create(p, filename = "r-docs-midwest-boxplots")
