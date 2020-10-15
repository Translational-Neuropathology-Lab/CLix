## code to prepare `nbM_Flame_NFT` dataset goes here
nbM_dat <- readxl::read_xlsx("/projects/bsi/fl/studies/s208110.Murray.AD/rawdata/CLix/HpSp_nbM_NFT.xlsx", na = c("NA"))
nbM <- nbM_dat[,c(1,7,2,3,5,6,4)]
nbM$AD.subtype <-factor(nbM$AD.subtype, levels = c("HpSp", "Typical", "Limbic"))
names(nbM)[3:7]<-c('H1','H2','C1','C2','C3')
nbM <- nbM %>% mutate(
  NPID= as.character(row_number()),
  C3 = as.numeric(C3)
)

saveRDS(nbM, "data/nbM_Flame_NFT.rds")
nbM_Flame_NFT <- readRDS("data/nbM_Flame_NFT.rds")

usethis::use_data(nbM_Flame_NFT, overwrite = TRUE)
