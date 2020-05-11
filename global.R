library(shinydashboard)
library(shiny)
library(googleVis)
library(DT)
library(dplyr)
library(ggplot2)
library(markdown)

# handling data from objects.csv
objects.df <- read.csv("./startup-investments/objects.csv")
rownames(objects.df) <- NULL

# cleaning data from objects.csv
objects.df.clean <- objects.df %>% filter(!is.na(country_code)) %>%
  filter(!is.na(state_code)) %>%
  filter(!is.na(founded_at)) %>%
  filter(!is.na(category_code)) %>%
  filter(category_code!='') %>%
  filter(funding_total_usd != 0) %>%
  mutate(funding_total_usd = round(funding_total_usd/1000000, digits=0)) %>% 
  mutate(year_found = substring(founded_at, 1, 4)) %>%
  filter(year_found >= 1990) %>% 
  filter(country_code == 'USA') %>% 
  select(state_code, funding_total_usd, year_found, category_code, country_code) 

objects.by_country <- objects.df.clean %>%
  group_by(state_code) %>% 
  summarize(total_funding=sum(funding_total_usd))

choice <- colnames(objects.by_country)[-1]

objects.by_year <- objects.df.clean %>%
  group_by(year_found) %>%
  summarize(total_funding=sum(funding_total_usd))

objects.by_industry <- objects.df.clean %>%
  group_by(category_code) %>%
  summarize(total_funding=sum(funding_total_usd)) %>% 
  top_n(15, total_funding)

objects.by_industry_year <- objects.df.clean %>%
  filter(year_found >= 2007 & year_found <= 2009) %>% 
  group_by(category_code) %>%
  summarize(total_funding=sum(funding_total_usd)) %>% 
  top_n(15, total_funding)

objects.recession <- objects.df.clean %>% 
  filter(year_found >= 2007 & year_found <= 2009) %>% 
  select(category_code, country_code, funding_total_usd, year_found) %>% 
  group_by(category_code, year_found) %>% 
  summarize(total_funding=sum(funding_total_usd)) 

# handling data from acquisitions.csv
acquisitions.df <- read.csv("./startup-investments/acquisitions.csv")
rownames(acquisitions.df) <- NULL

# cleaning data from acquisitions.csv
acquisitions.df.clean <- acquisitions.df %>%
  filter(!is.na(acquired_at)) %>%
  filter(price_amount != 0) %>%
  filter(price_currency_code == 'USD') %>%
  mutate(acquisition_price = round(price_amount/1000000, digits=0)) %>% 
  mutate(year_acquired = substring(acquired_at, 1, 4)) %>%
  filter(year_acquired >= 1990) 

acquisitions.by_year <- acquisitions.df.clean %>%
  group_by(year_acquired) %>%
  summarize(total_acquisition=sum(acquisition_price))

# handling data from acquisitions_recession.csv
# acquisitions_recession.df <- read.csv("./startup-investments/acquisitions_recession.csv")
# rownames(acquisitions_recession.df) <- NULL
# 
# # cleaning data from acquisitions_recession.csv
# acquisitions_recession.df.clean <- acquisitions_recession.df %>%
#   mutate(year_acquired = substring(acquired_at, 1, 4)) %>%
#   mutate(year_found = substring(founded_at, 1, 4)) %>%
#   mutate(price_amount = as.numeric(price_amount))
# 
# acquisitions_recession.by_industry <- acquisitions_recession.df.clean %>%
#   select(price_amount, category_code, year_acquired) %>%
#   filter(year_found >= 2007 & year_found <= 2009) %>% 
#   group_by(category_code, year_found) %>%
#   summarize(total_acquisition=sum(acquisition_price))
#   top_n(15, average)

# handling data from ipos.csv
ipos.df <- read.csv("./startup-investments/ipos.csv")
rownames(ipos.df) <- NULL

# cleaning data from ipos.csv
ipos.df.clean <- ipos.df %>%
  filter(!is.na(public_at)) %>%
  filter(valuation_amount != 0) %>%
  filter(raised_currency_code == 'USD') %>%
  mutate(valuation_amount = round(valuation_amount/1000000, digits=0)) %>% 
  mutate(year_ipo = substring(public_at, 1, 4)) %>%
  filter(year_ipo >= 1990)

ipos.by_year <- ipos.df.clean %>%
  group_by(year_ipo) %>%
  summarize(total_valuation=sum(valuation_amount))
