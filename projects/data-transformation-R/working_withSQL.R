library(RSQLite)
library(tidyverse)

# [1] connect DB 
con <- dbConnect(SQLite(), "chinook.db")

# [2] list tables
dbListTables(con)

# [3] list fields
dbListFields(con, "customers")

# [4] query data
df1 <- dbGetQuery(con, "select * from customers")

us_customer <- dbGetQuery(con, "select * from customers where country = 'USA' ")

df1 <- df1 %>%
  mutate(Company = replace_na(Company, "woohoo!"))
View(df1)

# [5] write table (add in con>> chinook.db)
shipping <- data.frame(id=1:3,
                       shipping_class = c("regular", "premium", "super premium"))

dbWriteTable(con, "shipping", shipping)

dbGetQuery(con, "select * from shipping")

# [6] drop table?
dbRemoveTable(con, "shipping")

# [7] disconnect
dbDisconnect(con)

##----------------------------------------------------------------
## connect to SQL server (postgresql)

library(RPostgreSQL)
library(tidyverse)

con <- dbConnect(PostgreSQL(),
                 host = "arjuna.db.elephantsql.com",
                 port = 5432,
                 user = "rxmxolrb",
                 password = "Fhd-vXWa5FVdhpt7a2dBd-Mup_BkqiaC",
                 dbname = "rxmxolrb")

dbListTables(con)

pizza_menu <- data.frame(
  id= 1:3,
  name = c("hawaiian", 
           "hotdog", 
           "cheese"),
  price = c(399, 269, 329))

customer_pizza <- data.frame(
  cus_id = 1:5,
  cus_name = c("Pee", "Am", "Gift", "John", "Bosu")
)

order <- data.frame(
  order_id = 1:3,
  quantity = c(1,2,2)
)

dbWriteTable(con, "pizza_menu", pizza_menu)
dbWriteTable(con, "customer_pizza", customer_pizza)
dbWriteTable(con, "order", order)

## get data
dbGetQuery(con, "select * from pizza_menu")

## create another table
customers <- data.frame(id=1:2,
                        name = c("PP", "Prem"))
dbWriteTable(con, "customers", customers)
dbGetQuery(con, "select * from customers")

#dbRemoveTable(con, "customers")

dbListTables(con)
 ## [7] disconnect/ close connect
dbDisconnect(con)


