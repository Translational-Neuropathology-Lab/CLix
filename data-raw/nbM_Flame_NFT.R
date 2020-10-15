## code to prepare `nbM_Flame_NFT` dataset goes here
nbM_Flame_NFT <- readRDS("data/nbM_Flame_NFT.rds")

usethis::use_data(nbM_Flame_NFT, overwrite = TRUE)
