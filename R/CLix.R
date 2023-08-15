#' Corticolimbic Index (CLix) Package
#'
#' The goal of CLix is to personalize the Alzheimer's disease (AD) subtype algorithm by expressing it as a 
#' continuous numeric corticolimbic index (CLix). It was derived using tangle count distributions
#' from AD cases within the Florida Autopsy Multi-Ethnic series (FLAME-AD) to investigate clinical and demographic correlates.
#' 
#' The original algorithm was built upon a smaller cohort of AD cases (n=889) from a [previous study](https://doi.org/10.1016/S1474-4422(11)70156-9). 
#' The algorithm was then improved and tested with the FLAME-AD<sup>1,2</sup> (Florida Autopsied Multi-Ethnic - Alzheimer's Disease) 
#' cohort (n=1361). \cr 
#' \cr
#' FLAME-AD was
#' derived from the State of Florida brain bank housed at the Mayo Clinic Florida. Donors
#' are derived through community engagement and participating Memory Disorder Clinics
#' in the State of Florida’s Alzheimer’s Disease Initiative who may register for autopsy
#' regardless of sex, race, or ethnicity. 
#'
#'\cr
#'1. [Liesinger et. Al. Acta Neuropathologica 2018](https://link.springer.com/article/10.1007/s00401-018-1908-x)
#'\cr
#'2. [Santos et. al. Alzheimer’s & Dementia 2019](https://alz-journals.onlinelibrary.wiley.com/doi/epdf/10.1016/j.jalz.2018.12.013)
#'\cr 
#' 
#' 
#' \cr Developed by the [Translational Neuropathology Lab](https://www.mayo.edu/research/labs/translational-neuropathology/overview) led by Dr. Melissa E. Murray at Mayo Clinic Florida
#'
#'
#' @docType package
#' @name CLix
#' @importFrom dplyr mutate
NULL
## quiets concerns of R CMD check re: the .'s that appear in pipelines
utils::globalVariables(c("nbM_Flame_NFT",
                         "H1",
                         "H2",
                         "C1",
                         "C2",
                         "C3",
                         "H3",
                         "C4",
                         "quantile",
                         "median"))
