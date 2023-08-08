## code to prepare `example_data` dataset goes here
example_data <- readRDS("data-raw/example_data.rds")

usethis::use_data(example_data, overwrite = TRUE)
