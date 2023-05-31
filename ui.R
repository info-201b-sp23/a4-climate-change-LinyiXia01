library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
source("server.R")

my_theme <- bs_theme(bg = "white",
            fg = "#297CD7",
            primary = "#FCC780")


ui <- navbarPage(
  theme = my_theme,
  "Climate Change",
  tabPanel("Introduction",
    h2("Intro"),
    p("Due to the impacts of human activities on the environment,
      there has been a significant increase in extreme natural disasters in recent years.
      We only have one Earth on which we rely for survival, it's crucial to pay attention to the issue of climate change.
      And CO2 emission is a substantial contributor to climate change.
      Therefore, this report, using data from Our World In Data, focuses on two variables:
      the annual total CO2 emissions and the annual production-based CO2 emissions from cement, coal, flaring, gas, and oil.
      The aim is to understand how and where CO2 emissions are primarily generated and how this pattern has evolved over time.
      Hope this report can help people have a better comprehension of the factors influencing CO2 emissions and
      thus make effective climate change mitigation strategies."),
    h2("About this report"),
    strong("- Who collected the data? How was the data collected or generated?"),
    p("This data has been collected, aggregated, and documented by Hannah Ritchie,
      Max Roser, Edouard Mathieu, Bobbie Macdonald and Pablo Rosado."),
    strong("- How was the data collected or generated?"),
    p("The dataset is compiled by incorporating data from various sources such as the Statistical Review of World Energy (BP),
      International Energy Data (EIA), and Primary Energy Consumption. Furthermore,
      basic processing has been applied to the codes associated with these datasets."),
    strong("- Why was the data collected?"),
    p("The data was collected to make data and research on the world’s largest problems such as climate change 
      more understandable and accessible."),
    strong("- What are possible limitations or problems with this data"),
    p("One limitation of this dataset is the absence of data for certain years in some less developed countries,
      without providing any specific reasons. For example, the data for CO2 emissions in Chad only spans from 1960 to 2021.
      While for some developed countries and regions such as the US and the EU, the data spans a much longer period of time.
      Without further information, it is unclear whether this gap is due to missing data or some other reasons.
      This omission would impact the analysis of CO2 emission trends over time.
      And it may lead to the marginalization of these less developed countries in terms of climate change issues."),
    h2("Summary"),
    p("The overall CO2 emissions in high income countries show a sharp upward trend over time,
      with the lowest CO2 emissions year being",
      strong("1750"), 
      "and the highest CO2 emissions year being ",
      strong(textOutput("max_high_co2_year", inline = TRUE)),
      "with ",
      strong(textOutput("max_high_co2", inline = TRUE)),
      " millions tons. But fortunately, after 2007, CO2 emissions have declined.
      The overall CO2 emissions in low-income countries are little and show a more moderate trend,
      with the highest emission amount ",
      strong(textOutput("max_low_co2", inline = TRUE)),
      " million tons in ",
      strong(textOutput("max_low_co2_year", inline = TRUE)),
      "."),
    h2("Insights"),
    p("In general, CO2 emissions in countries all over the world are showing an increasing trend over time,
      indicating people's production activities are having a huge impact on the climate. We should take action right now
      to release this negative impact.")
  ),
  tabPanel(
    "Graph",
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "input_country",
          label = h4("Select a Country"),
          choices = df$country,
          selected = "Afghanistan",
          selectize = TRUE,
          multiple = TRUE
        ),
        sliderInput("slider1",
                    label = h4("Select a Year Range"),
                    min = 1750,
                    max = 2021,
                    value = c(1750, 2021))
      ),
      mainPanel(plotlyOutput("co2_plot"),
                p("This line charts depicts the CO2 emissions of selected countries over time.", align = "middle"),
                h4("Purpose", align = "middle"),
                p("I would like to know the trend of the CO2 emissions over time of all the countries and 
                  emission differences between different countries and regions.", align = "middle"),
                h4("Insight", align = "middle"),
                p("From the plot, we can find that almost all the countries have an increasing trend of CO2 emissions.
                  For high-income countries, CO2 emissions consistently showed a surge from 1820 to 2007.
                  Although there has been a decline since 2007(which I think might relate to the signing of the Paris Agreement),
                  the quantity of CO2 emissions remains substantial. For middle and low-income countries,
                  their CO2 emissions are significantly lower compared to high-income countries but still exhibit an overall upward trend.
                  This indicates that human activities have a great impact on the climate and we must take actions.", align ="middle"))
    ),
    
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "input_region",
          label = h4("Select a Country"),
          choices = df$country,
          selected = "Afghanistan",
          selectize = TRUE
        ),
        sliderInput("slider2",
                    label = h4("Select a Year"),
                    min = 1750,
                    max = 2021,
                    value = 1980)
      ),
      mainPanel(plotlyOutput("energy_plot"),
                p("This bar chart depicts emissions of C02 from different energy sources in different countries.", align = "middle"),
                h4("Purpose", align = "middle"),
                p("I would like to know what energy is the largest source of CO2 emissions in different countries over time.", align = "middle"),
                h4("Insight", align = "middle"),
                p("From the plot, we can find that coal, gas and oil are the most prevalent sources of CO2 emissions but
                  their weighting differs from countries and changes over time. For example,
                  in China, coal is alwasys the most largest source of CO2 emissions over time.
                  While in the North America, before 1950s, coal was the main source. And after that,
                  oil has become the most prevalent source of CO2 emissions.", align = "middle") )
    )
    
  )
)


