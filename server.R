library("dplyr")
library("plotly")
library("tidyverse")

df <- read.csv("~/Desktop/info201/a4-climate-change-LinyiXia01/owid-co2-data.csv",
                 stringsAsFactors = FALSE)

co2_df <- df %>% 
  select(country, year, co2)

energy_df <- df %>%
  select(country, year, coal_co2, cement_co2, flaring_co2, oil_co2, oil_co2, gas_co2)

df_long <- energy_df %>%
  pivot_longer(cols = c(coal_co2, cement_co2, flaring_co2, oil_co2, oil_co2, gas_co2), 
               names_to = "co2_source", values_to = "emissions")

high_income <- co2_df %>%
  filter(country == "High-income countries") %>%
  arrange(-co2)

low_income <- co2_df %>%
  filter(country == "Low-income countries") %>%
  arrange(-co2)

server <- function(input, output) {
  
  output$max_high_co2_year <- renderText({
    max_high_co2_year <- high_income %>%
      filter(co2 == max(co2)) %>%
      pull(year)
    
    return(max_high_co2_year)
  })
  
  output$max_high_co2 <- renderText({
    max_high_co2 <- high_income %>%
      filter(co2 == max(co2)) %>%
      pull(co2)
    
    return(max_high_co2)
  })
  
  output$min_high_co2_year <- renderText({
    min_high_co2_year <- high_income %>%
      filter(co2 == min(co2, na.rm = T)) %>%
      pull(year)
    
    return(min_high_co2_year)
  })
  
  output$max_low_co2_year <- renderText({
    max_low_co2_year <- low_income %>%
      filter(co2 == max(co2)) %>%
      pull(year)
    
    return(max_low_co2_year)
  }) 
  
  output$max_low_co2 <- renderText({
    max_low_co2 <- low_income %>%
      filter(co2 == max(co2)) %>%
      pull(co2)
    
    return(max_low_co2)
  }) 
  
  output$co2_plot <- renderPlotly({
    #filter the dataset to user selected countries
    validate(
      need(input$input_country, "Select a Country")
    )
    data <- co2_df %>% 
      filter(country %in% input$input_country) %>%
      filter(year >= input$slider1[1] & year <= input$slider1[2])
    
    #plot the line chart 
    co2_chart <- ggplot(data) +
      geom_line(aes(x = year,
                    y = co2,
                    color = country),
                size = 1.2) +
      scale_x_log10() +
      labs(x = "Year",
           y = "CO₂ Emissions (millions tones)",
           color = "Country",
           title = paste0("CO₂ Emissions of Selected Countries Between ", input$slider1[1], " And ", input$slider1[2])
      )
    
    return(co2_chart)  
  })
  
  output$energy_plot <- renderPlotly({
    validate(
      need(input$input_region, "Select a Country")
    )
    data2 <- df_long %>%
      filter(country %in% input$input_region) %>%
      filter(year == input$slider2)
    
    #plot the bar chart
    energy_chart <- ggplot(data2) +
      geom_col(mapping = aes(
        x = co2_source,
        y = emissions,
        fill = co2_source)
      ) +
      labs(x = "C02 Source",
           y = "Total Emissions(MT)",
           fill = "C02 Source",
           title = paste0(input$input_region, "'s CO2 Emissions in ", input$slider2)
      )
    return(energy_chart)
  })
  
}

