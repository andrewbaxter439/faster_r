library(tidyverse)

file.info("data/big_data.csv")$size/1024^2


# Base R is really slow!
t1 <- Sys.time()
my_data <- read.csv("data/big_data.csv")
cat("That took ", Sys.time() - t1, "minutes!")



library(data.table)

# A faster method with data.table
t1 <- Sys.time()
my_data <- fread("data/big_data.csv")
cat("That took ", Sys.time() - t1, "seconds")



# working with data.table syntax ------------------------------------------


my_data[, 1:3]

# Example - summing columns 1-3 by group
my_data[, lapply(.SD[,1:3], sum), by = group]



# or cheating! ------------------------------------------------------------

library(tidyverse)
library(dtplyr)

# I am more used to the tidyverse syntax. This converts tidyverse to data.table
# syntax for me!
my_data |> 
  lazy_dt() |> 
  group_by(group) |> 
  summarise(across(1:3, sum))

my_data[, .(a = sum(a), b = sum(b), c = sum(c)), keyby = .(group)]


# writing/reading even faster! --------------------------------------------


library(fst)

write_fst(my_data, "big_data.fst")

file.info("big_data.fst")$size/1024^2

t1 <- Sys.time()
my_data <- read_fst("big_data.fst", as.data.table = TRUE)
cat("That took ", Sys.time() - t1, "seconds!!")




# Read in selected columns
my_first_columns <- read_fst("big_data.fst", columns = c("a", "b", "c"),
                             as.data.table = TRUE)

my_first_columns


# Read in only first 100,000 rows
first_tenth <- read_fst("big_data.fst", from = 1, to = 100000,
                        as.data.table = TRUE)

first_tenth[,1:3]
