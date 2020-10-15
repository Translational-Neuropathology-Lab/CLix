
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CLix

<!-- badges: start -->

<!-- badges: end -->

The goal of CLix is to house a variety of functions that help in
Alzheimer’s Research in one convenient place for analysis.

## Installation

You can install the released version of CLix from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("CLix")
```

## Example

This is a basic example which shows you how to solve score a dataset
using the developed CLix algorithm:

First load the data to be scored.

``` r
library(CLix)
library(tidyverse)
#> ── Attaching packages ───────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.1     ✓ dplyr   1.0.0
#> ✓ tidyr   1.0.3     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> ── Conflicts ──────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

dat <- readRDS("data/example_data.rds") %>% 
  select(
    NPID, 
    AD.subtype, 
    CA1.NFT, 
    Subiculum.NFT, 
    Temporal.NFT, 
    Parietal.NFT, 
    Frontal.NFT
  ) %>% 
  rename(
    H1 = CA1.NFT, 
    H2 = Subiculum.NFT, 
    C1 = Temporal.NFT, 
    C2 = Parietal.NFT, 
    C3 = Frontal.NFT
  ) %>% 
  mutate(
    AD.subtype = factor(AD.subtype, levels = c("HpSp", "Typical", "Limbic"))
  )
```

Second use the CLix algorithm to score the new data against the nbM
Flame Cohort (as the reference).

``` r
res <- HpSp.scoring(dat = dat) %>% 
  select(NPID, HpSp.score.subtype, HpSp.score) %>% 
  mutate(
    HpSp.score.subtype = factor(HpSp.score.subtype, levels = c("HpSp", "Typical", "Limbic"))
  )
#> Have 0 of 1361 rows with all data missing in Reference data. These are DELETED. 
#> Have 5 of 1361 rows with partial missing data. These are USED. 
#> 25th %ile of R =  1.08548850574713 
#> median of R =  2.1 
#> 75th %ile of R =  3.75 
#> median of H1 =  12 
#> median of H2 =  20 
#> median of H3 =  16.5 
#> median of C1 =  10 
#> median of C2 =  7 
#> median of C3 =  5 
#> median of C4 =  8
rescored_dat <- res %>% 
  inner_join(dat, by = "NPID")
```

Third compare the original AD subtype to the newly assigned AD subtype

``` r
arsenal::tableby(
  HpSp.score.subtype ~ AD.subtype, 
  data = rescored_dat, 
  total = F
) %>% 
  summary()
```

|                | HpSp (N=35) | Typical (N=198) | Limbic (N=29) |  p value |
| :------------- | :---------: | :-------------: | :-----------: | -------: |
| **AD.subtype** |             |                 |               | \< 0.001 |
| HpSp           | 31 (88.6%)  |    1 (0.5%)     |   0 (0.0%)    |          |
| Typical        |  4 (11.4%)  |   193 (97.5%)   |   5 (17.2%)   |          |
| Limbic         |  0 (0.0%)   |    4 (2.0%)     |  24 (82.8%)   |          |
