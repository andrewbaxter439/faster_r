sapply(letters, \(x) runif(n = 1000000), simplify = FALSE) |> 
  {\(x) append(list(group = sample(LETTERS, 1000000, replace = TRUE)), x)}() |> 
  as.data.frame() |> 
  data.table::fwrite("data/big_data.csv")
