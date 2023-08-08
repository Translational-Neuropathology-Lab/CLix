## code to prepare `nbM_Flame_NFT` dataset goes here
nbM_Flame_NFT <- readRDS("data-raw/nbM_Flame_NFT.rds") %>%
  mutate(
    H1 = as.numeric(H1),
    H2 = as.numeric(H2),
    C1 = as.numeric(C1),
    C2 = as.numeric(C2),
    C3 = as.numeric(C3)
  )


usethis::use_data(nbM_Flame_NFT, overwrite = TRUE)
