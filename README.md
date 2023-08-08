
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Corticolimbic Index (CLix)

<!-- badges: start -->
<!-- badges: end -->

The goal of CLix is to personalize the Alzheimer’s disease (AD) subtype
algorithm by expressing it as a continuous numeric corticolimbic index
(CLix).

## Example

This is a basic example which shows you how to generate a score for a
dataset using the developed CLix algorithm:

First load the data to be scored.

``` r
dat <- example_data %>% 
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

Second use the CLix algorithm to score the new data against the FLAME-AD
Cohort (as the reference dataset).

``` r
res <- CLix.scoring(dat = dat) %>% 
  select(NPID, CLix.score.subtype, CLix.score) %>% 
  mutate(
    CLix.score.subtype = factor(CLix.score.subtype, levels = c("HpSp", "Typical", "Limbic"))
  )
#> Have 0 of 1361 rows with all data missing in Reference data. These are DELETED. 
#> Have 4 of 1361 rows with partial missing data. These are USED. 
#> 25th %ile of R =  1.08620689655172 
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

Third, compare the original AD subtype to the newly assigned AD subtype.

``` r
arsenal::tableby(
  CLix.score.subtype ~ AD.subtype, 
  data = rescored_dat, 
  total = F
) %>% 
  summary()
```

|                | HpSp (N=35) | Typical (N=198) | Limbic (N=29) |  p value |
|:---------------|:-----------:|:---------------:|:-------------:|---------:|
| **AD.subtype** |             |                 |               | \< 0.001 |
|    HpSp        | 31 (88.6%)  |    1 (0.5%)     |   0 (0.0%)    |          |
|    Typical     |  4 (11.4%)  |   193 (97.5%)   |   5 (17.2%)   |          |
|    Limbic      |  0 (0.0%)   |    4 (2.0%)     |  24 (82.8%)   |          |
