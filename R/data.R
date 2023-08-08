#' FLAME-AD Cohort
#'
#' 
#' A dataset containing the AD information for the Florida Autopsy Multi-Ethnic series (FLAME-AD) Cohort (n=1361).
#'
#'
#' @format A data frame with 1361 rows and 7 variables:
#' \describe{
#'   \item{NPID}{Factor. Case identifier.}
#'   \item{AD.subtype}{Factor with 3 levels (HpSp, Typical, Limbic) describing the Alzheimer's disease subtype.}
#'   \item{H1}{Numeric. The Neurofibrillary tangle (NFT) counts in the hippocampal subsectors of CA1.}
#'   \item{H2}{Numeric. The Neurofibrillary tangle (NFT) counts in the hippocampal subsectors of Subiculum.}
#'   \item{C1}{Numeric. The Neurofibrillary tangle (NFT) counts in the cortical regions of Temporal.}
#'   \item{C2}{Numeric. The Neurofibrillary tangle (NFT) counts in the cortical regions of Parietal.}
#'   \item{C3}{Numeric. The Neurofibrillary tangle (NFT) counts in the cortical regions of Frontal.}
#' }
"nbM_Flame_NFT"

#' Example data
#'
#' An example data set containing AD information for 262 cases.
#'
#'
#' @format A data frame with 262 rows and 7 variables:
#' \describe{
#'   \item{NPID}{Factor. Case identifier.}
#'   \item{AD.subtype}{Factor with 3 levels (HpSp, Typical, Limbic) describing the Alzheimer's disease subtype.}
#'   \item{CA1.NFT}{Numeric. The Neurofibrillary tangle (NFT) counts in the hippocampal subsectors of CA1.}
#'   \item{Subiculum.NFT}{Numeric. The Neurofibrillary tangle (NFT) counts in the hippocampal subsectors of Subiculum.}
#'   \item{Temporal.NFT}{Numeric. The Neurofibrillary tangle (NFT) counts in the cortical regions of Temporal.}
#'   \item{Parietal.NFT}{Numeric. The Neurofibrillary tangle (NFT) counts in the cortical regions of Parietal.}
#'   \item{Frontal.NFT}{Numeric. The Neurofibrillary tangle (NFT) counts in the cortical regions of Frontal.}
#' }
"example_data"
