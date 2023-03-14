slow_process <- function(a, b, c) {
  Sys.sleep(1)
  return(a + b + c)
}


a <- sample(1:1000000, 20)
b <- sample(1:1000000, 20)
c <- sample(1:1000000, 20)

library(doParallel)

cl <- parallel::makePSOCKcluster(5)

registerDoSEQ() # First let's try it sequentially

t1 <- Sys.time()
sum_ups <- foreach(a, b, c, .combine = c) %dopar% {slow_process(a, b, c)}
cat("That took ", Sys.time() - t1, "seconds")

registerDoParallel(cl) # Now let's try the same thing in parallel

t1 <- Sys.time()
sum_ups <- foreach(a, b, c, .combine = c) %dopar% {slow_process(a, b, c)}
cat("That took ", Sys.time() - t1, "seconds")


# Note - this is a silly example, as the function is actually vectorised!
slow_process(a, b, c)

