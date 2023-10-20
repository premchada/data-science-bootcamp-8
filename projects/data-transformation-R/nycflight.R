library(nycflights13)
library(glue)
library(tidyverse)

View(flights)

## preview data 

## filter data
flights %>%
  group_by(month) %>%
  summarise(n= n())


## 5 question ask about flights

# [1] Feb 2013, carrier most flights?
flights %>%
  filter(month == 2)%>%
  count(carrier)%>%
  arrange(-n) %>%
  head(5)%>%
  left_join(airlines, by= "carrier")

# [2] Top10 airline has the most departure delayed
flights %>%
  filter(dep_delay>0) %>%
  group_by(carrier) %>%
  summarise(sum_delayed = sum(dep_delay)) %>%
  arrange(desc(sum_delayed)) %>%
  left_join(airlines, by = "carrier") %>%
  head(10)

# [3] Oct 2013, the most destination
flights %>%
  filter(month == 10) %>%
  count(dest) %>%
  arrange(-n) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  select(dest, name, n)


# [4] Oct 2013, สนามบินต้นทางใดไป Chicago "ORD"เยอะสุด
flights %>%
  filter(month == 10, 
         dest == "ORD") %>%
  count(origin) %>%
  arrange(-n) %>%
  left_join(airports, by = c("origin" = "faa")) %>%
  select(origin, name, n)

# [5] Top5 fastest & slowest airliners (speed km/hr) 
fastest_airliners <- flights %>%
  mutate(
    dist_km = distance*1.60934,
    air_hour = air_time/60,
    speed_kmph = dist_km/air_hour
  )%>%
  left_join(planes, by = "tailnum") %>%
  select(manufacturer, model, speed_kmph) %>%
  arrange(-speed_kmph) %>%
  head(5)

# [6] เดือนที่มีเที่ยวบินเยอะที่สุด >> July = 29425 เที่ยวบิน
m_most_flights <- flights %>%
  group_by(month) %>%
  count(month) %>%
  arrange(-n) %>%
  head(1)
# เดือนที่มีเที่ยวบินน้อยที่สุด >> Feb = 24951 เที่ยวบิน
m_least_flight <- flights %>%
  group_by(month) %>%
  count(month) %>%
  arrange(n) %>%
  head(1)



