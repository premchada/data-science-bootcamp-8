# My first R program

print("hello world")
print("hello world")

library(dplyr)
mtcars %>%
  select(1:5) %>%
  filter(mpg > 30)
