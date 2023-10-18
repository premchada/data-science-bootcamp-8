library(tidyverse)
library(caret)
library(readxl)
library(ggplot2)
library(httr)
library(dplyr)

# Simple ML pipeline
# 0. prep data / clean data
## Load data

GET("https://query.data.world/s/ayv2p57ku25qjwlkwbj7p5tl2ekrcj?dws=00000", 
    write_disk(tf2016 <- tempfile(fileext = ".xlsx")))
df2016 <- read_excel(tf2016)
df_house_price2016 <- df2016

GET("https://query.data.world/s/dilsmvmb4wjfyxtq52tcyrtnc4ozwm?dws=00000", 
    write_disk(tf2017 <- tempfile(fileext = ".xlsx")))
df2017 <- read_excel(tf2017)
df_house_price2017 <- df2017

house_price_df <- bind_rows(df_house_price2016, df_house_price2017)

## check NA
house_price_df %>%
  complete.cases() %>%
  mean()

## Visualization house price
price_plot1 <- ggplot(house_price_df, aes(Price))+
  geom_density() +
  theme_minimal() +
  labs(
    title = "House Price India Distribution",
    x = "Price",
    y = "Count",
    caption = "Source: Dataset House Price India from data.world"
  )
# select parameter
house_df <- house_price_df %>%
  select(price = Price,
         distance_airport = `Distance from the airport`,
         n_bedroom = `number of bedrooms`,
         n_floor = `number of floors`,
         near_schools = `Number of schools nearby`,
         living_area = `living area`)

price_plot2 <- ggplot(house_df, aes(log(price)))+
  geom_density() +
  theme_minimal() +
  labs(
    title = "House Price India Distribution",
    x = "Price",
    y = "Count",
    caption = "Source: Dataset House Price India from data.world"
  )
price_plot2

# 1. split data
split_df <- function(house_df){
  set.seed(22)
  n <- nrow(house_df)
  train_id <- sample(1:n, size = 0.8*n)
  train_df <- house_df[train_id, ]
  test_df <- house_df[-train_id, ]
  return( list(training = train_df,
               testing = test_df))
}
## prep data
prep_data <- split_data(house_df)
train_df <- prep_data[[1]]
test_df <- prep_data[[2]]

## normal distribution by log_price 
train_log <- train_df
train_log$price <- train_df$price %>%
  log()
test_log <- test_df
test_log$price <- test_df$price %>%
  log()

# 2. train model
set.seed(42)
model <- train(price ~ . ,
                  data=train_log,
                  #ML algorithm
                  method = "lm")

# 3. score model aka. prediction
p <- predict(model, newdata = test_log)

# 4. evaluate model
# mean absolute error
(mae <- mean(abs(p - test_log$price)))

# root mean square error
(rmse <- sqrt(mean((p - test_log$price)**2)))

## final model
model$finalModel %>%
  summary()

 ## Variable important
varImp(model)

