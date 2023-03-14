library(tidyverse)

# not using for loops -----------------------------------------------------

nums <- 1:10

total <- 0

for (i in 1:length(nums)) {
  total <- total + nums[i]
}

# This is the vectorised function that does the same thing

total <- sum(nums)

# This can make things simpler, especially in dataframes

pop <- tibble(weight = rnorm(100, 80, 10),
       height = rnorm(100, 1.60, 0.1))

pop$bmi <- vector("double", 100)

for (i in 1:nrow(pop)) {
  pop$bmi[i] <- pop$weight[i]/pop$height[i]^2
}

hist(pop$bmi)
# Now try running the same thing, but remove the for loop (and '[i]' elements)
# to pass whole vectors at the same time

# using functionals to iterate complex functions over a vector or list

switch_case <- function(string) {
  gsub("([a-z])|([A-Z])", "\\U\\1\\L\\2", perl = TRUE, string)
}

switch_case("This is a Sentence")

strings <- c("Hello everyone!", "I like learning r", "Twice forty is eiGhty")

# The base R functionals

lapply(strings, switch_case)
# returns list

vapply(strings, switch_case, FUN.VALUE = "a", USE.NAMES = FALSE)
# returns chr vector

# Or the purrr::map* functionals:

map_chr(strings, switch_case)
# Returns chr vector

# a trickier example ------------------------------------------------------

# From a stackoverflow question - what if calculation of a value depends on the
# previously calculated value? Can this be solved without for loops?

df <- tibble(row = 1:100000, 
             A = c(1, rep(NA, 99999)))

# Very slow

t1 <- Sys.time()
for (i in 2:nrow(df)) {
  df$A[i] <- 0.1234* df$A[i-1] 
}
cat("That took ", Sys.time() - t1, "seconds")

# But here, we can use a bit of maths to make an equation to calculate each row
# without waiting for the last row to complete. This again allows vectorisation
# where the faster part of R can go ahead and do all calcs

# better...

t1 <- Sys.time()
df <- df |>
  mutate(A = max(A, na.rm = TRUE) * 0.1234^ (row - 1))
cat("That took ", Sys.time() - t1, "seconds")

cumsum(df$A)
