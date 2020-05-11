library(shinydashboard)
library(shiny)
library(googleVis)
library(DT)
library(dplyr)
library(ggplot2)

function(input, output){
  output$map <- renderGvis({
    gvisGeoChart(objects.by_country, locationvar="state_code", colorvar="total_funding", input$selected,
                 options=list(region="US", displayMode="regions", resolution="provinces",title="Total Funding mapped by State (USD mln)", titleTextStyle="{color:'blue',fontName:'Courier',fontSize:30}", 
                              width="auto", height="auto", bar="{groupWidth:'80%', groupHeight:'100%'}"))
  })

  output$hist_state <- renderGvis({
    gvisBarChart(objects.by_country, xvar="state_code",
                 yvar="total_funding",
                 options=list(title="Total Funding by State (USD mln)", titleTextStyle="{color:'darkblue',fontSize:35}", bar="{groupWidth:'100%', groupHeight:'100%'}", width="1000", height="800"))
  })  

  output$hist_year <- renderGvis({
    gvisBarChart(objects.by_year, xvar="year_found",
                 yvar="total_funding",
                 options=list(title="Total Funding by Vintage (USD mln)", titleTextStyle="{color:'darkblue',fontSize:35}", bar="{groupWidth:'80%', groupHeight:'100%'}", width="1000", height="800"))
  }) 

                   
  output$recession1 <- renderInfoBox({
    infoBox(objects.recession$year_found[1], objects.recession$total_funding[1], icon = icon("hand-o-up"))
  })

  output$recession2 <- renderInfoBox({
    infoBox(objects.recession$year_found[2], objects.recession$total_funding[2], icon = icon("hand-o-up"))
  })

  output$recession3 <- renderInfoBox({
    infoBox(objects.recession$year_found[3], objects.recession$total_funding[3], icon = icon("hand-o-up"))
  })
   
  output$hist_acq <- renderGvis({
    gvisBarChart(acquisitions.by_year, xvar="year_acquired",
                 yvar="total_acquisition",
                 options=list(title="Valuations by Acquisition Year (USD mln)", titleTextStyle="{color:'darkblue',fontSize:30}", bar="{groupWidth:'80%', groupHeight:'100%'}", width="1000", height="800"))
  })

  output$hist_ipo <- renderGvis({
    gvisBarChart(ipos.by_year, xvar="year_ipo",
                 yvar="total_valuation",
                 options=list(title="Valuations by IPO Year (USD mln)", titleTextStyle="{color:'darkblue',fontSize:35}", bar="{groupWidth:'80%', groupHeight:'100%'}", width="1000", height="800"))
  })

  output$hist_recession <- renderGvis({
    gvisBarChart(acquisitions_recession.by_industry, xvar="category_code",
                 yvar="price_amount",
                 options=list(title="Acquisitions/IPO by Industry 2007-2009 (USD mln)", titleTextStyle="{color:'darkblue',fontSize:35}", bar="{groupWidth:'80%', groupHeight:'100%'}", width="1000", height="800"))
  })
  
  output$pie_industry <- renderGvis({
    gvisPieChart(objects.by_industry, labelvar="category_code",
                 numvar="total_funding",
                 options=list(title="Top 15 Industry by Funding 1999-2013 (USD mln)", titleTextStyle="{color:'darkblue',fontSize:35}", width="800", height="800"))
  })
  
  output$pie_industry_recession <- renderGvis({
    gvisPieChart(objects.recession, labelvar="category_code",
                 numvar="total_funding",
                 options=list(title="Top 15 Industry by Funding 2007-2009 (USD mln)", titleTextStyle="{color:'darkblue',fontSize:35}", width="800", height="800"))
  })
  
  # output$scatter <- renderGvis({
  #   gvisBarChart(ipos.by_year, xvar="year_ipo",
  #                yvar="total_valuation",
  #                options=list(title="Valuations by IPO Year (USD mln)", titleTextStyle="{color:'darkblue',fontSize:35}", bar="{groupWidth:'80%', groupHeight:'100%'}", width="1000", height="800"))
  # })

  output$table <- DT::renderDataTable({
    datatable(objects.by_country, rownames=FALSE) %>%
      formatStyle(input$selected, background="skyblue", fontWeight='bold')
  })
  output$table_year <- DT::renderDataTable({
    datatable(objects.by_year, rownames=FALSE) %>%
      formatStyle(input$selected, background="skyblue", fontWeight='bold')
  })

  output$table_industry <- DT::renderDataTable({
    datatable(objects.by_industry, rownames=FALSE) %>%
      formatStyle(input$selected, background="skyblue", fontWeight='bold')
  })
}



