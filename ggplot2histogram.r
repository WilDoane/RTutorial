library(tidyverse)
housing <- read_csv("dataSets/landdata-states.csv")

## Parsed with column specification:
## cols(
##   State = col_character(),
##   region = col_character(),
##   Date = col_double(),
##   Home.Value = col_integer(),
##   Structure.Cost = col_integer(),
##   Land.Value = col_integer(),
##   Land.Share..Pct. = col_double(),
##   Home.Price.Index = col_double(),
##   Land.Price.Index = col_double(),
##   Year = col_integer(),
##   Qrtr = col_integer()
## )

head(housing[1:5])

## # A tibble: 6 x 5
##   State region  Date Home.Value Structure.Cost
##   <chr> <chr>  <dbl>      <int>          <int>
## 1 AK    West   2010.     224952         160599
## 2 AK    West   2010.     225511         160252
## 3 AK    West   2010.     225820         163791
## 4 AK    West   2010      224994         161787
## 5 AK    West   2008      234590         155400
## 6 AK    West   2008.     233714         157458

ggplot(filter(housing, State %in% c("MA", "TX")),
       aes(x=Date,
           y=Home.Value,
           color=State))+
  geom_point()
