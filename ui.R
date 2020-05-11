library(shinydashboard)
library(shiny)
library(googleVis)
library(DT)
library(dplyr)
library(markdown)

dashboardPage(
  dashboardHeader(title='Startup Investments'),
  dashboardSidebar(
    sidebarUserPanel('Crunchbase',
                     image='https://ya-webdesign.com/transparent250_/vector-stockcom-science-8.png'),
    sidebarMenu(
      menuItem("Purpose", tabName = "readme", icon=icon("mortar-board")),
      menuItem('Funding by Geography', tabName='map', icon=icon('map')),
      menuItem('Funding by Vintage', tabName='vintage', icon=icon('chart-bar')),
      menuItem('Funding by Industry', tabName='industry', icon=icon('industry')),
      menuItem('Exit Analysis', tabName='exit', icon=icon('calendar')),
      # menuItem('Zoom in', tabName='recession', icon=icon('play')),
      menuItem('Data by state', tabName='by_state', icon=icon('database')),
      menuItem('Data by year', tabName='by_year', icon=icon('database')),
      menuItem('Data by industry', tabName='by_industry', icon=icon('database'))
    ),
    selectizeInput('selected','Select an Input:', choices=choice)
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "readme",
        fluidPage(
          includeMarkdown("README.md")
        )
      ),
      tabItem(tabName="map",
              # fluidRow(infoBoxOutput("maxBox"),
              #          infoBoxOutput("minBox"),
              #          infoBoxOutput("avgBox")),
              fluidRow(box(htmlOutput("hist_state"), height = 300),
                       box(htmlOutput("map"), height = 600))
      ),
      tabItem(tabName="vintage",
              titlePanel("2007-2009 statistics"),
              fluidRow(infoBoxOutput("recession1"),
                       infoBoxOutput("recession2"),
                       infoBoxOutput("recession3")),
              fluidRow(
                box(htmlOutput("hist_year"))
              )
      ),
      tabItem(tabName="industry",
              fluidRow(
                box(htmlOutput("pie_industry")),
                box(htmlOutput("pie_industry_recession"))
              )
      ),
      tabItem(tabName="exit",
              fluidRow(
                box(htmlOutput("hist_ipo")),
                box(htmlOutput("hist_acq"))
              ),
      ),
      tabItem(tabName="recession",
              fluidRow(
                box(htmlOutput("hist_recesion"))
              )
      ),
      tabItem(tabName='by_state',
              fluidRow(box(DT::dataTableOutput('table'), width=12))
      ),
      tabItem(tabName='by_year',
              fluidRow(box(DT::dataTableOutput('table_year'), width=12))
      ),
      tabItem(tabName='by_industry',
              fluidRow(box(DT::dataTableOutput('table_industry'), width=12))
      )
    )
  )
)
