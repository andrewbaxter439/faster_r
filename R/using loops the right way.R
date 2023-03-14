library(data.table)

# Here's an even more complex problem. The same stackoverflow question from
# earlier actually needed to update a series of values, with lots of
# dependencies both in the same row and in the previous rows. This is going to
# take a stupidly long time in a for loop (questioner estimated months!)


stands <- data.table(
  A = rep(1:1000, each = 1000),
  B = rep(1:1000, times = 1000),
  C = round(runif(1000000), 2),
  D = round(runif(1000000), 2),
  E = round(runif(1000000), 2)
)

# Adding further columns with only values for the B = 1
extra_vals <- data.table(A = 1:1000, B = 1, 
                     a = 1,
                     b = 1, 
                     c = 1,
                     d = 1,
                     e = 1,
                     a2 = 1,
                     b2 = 1,
                     c2 = 1)
stands <- merge(stands, extra_vals, all.x = TRUE)

lookup <- data.table(a = 0.1, b = 0.2, c = 0.4, d = 0.6, e = 0.1)

# If you run this, don't expect a solution any time soon

t1 <- Sys.time()
for(i in 2:nrow(stands)) {
  stands$a[i] <- (stands$A[i]*123 + stands$b[i-1]) * (1-lookup$a)
  stands$a2[i] <- stands$a[i] * 123
  stands$b[i] <- stands$a[i] + stands$a2[i]
  stands$b[i] <- (stands$B[i]*123 + stands$b[i-1]) * (1-lookup$b)
  stands$b2[i] <- stands$b[i] * 123
  stands$c[i] <- stands$c[i-1] + stands$c2[i-1]
  stands$c2[i] <- stands$c[i] * 123 
  stands$d[i] <- (stands$C[i]*123 + stands$D[i]*123 + stands$c[i-1]) * (1-lookup$d)
  stands$e[i] <- (stands$D[i]*123 + stands$e[i-1]) * (1-lookup$e)
}
Sys.time() - t1

# BUT! Here's one way to use for loops - write them in C++! The `updateDf.cpp`
# file has C++ code doing the exact same for loop as above, but after compiling
# C++ code it runs a lot faster than the R loop!

Rcpp::sourceCpp("updateDf.cpp")


t1 <- Sys.time()
updateDf(stands)
cat("That took ", Sys.time() - t1, "seconds!!!")

# 8 million calculations in a fraction of a second!