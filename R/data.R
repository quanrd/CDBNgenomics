#' Best Linear Unbiased Predictors for 21 phenotypes from the CDBN panel.
#'
#' A dataset containing best linear unbiased predictors (BLUPs) for 21
#'     phenotypes from the Cooperative Dry Bean Nursery (CDBN) diversity panel
#'     of 347 genotypes of Phaseolus vulgaris, 327 of which were phenotyped.
#'     BLUPs were derived for CDBN phenotypes using rrBLUP, and conditioning on
#'     a kinship matrix, the location the phenotype came from, and the location
#'     by year combination that the phenotype came from.
#'     The variables are as follows:
#'
#' \itemize{
#'   \item Taxa. Taxa ID of the Phaseolus vulgaris CDBN panel.
#'   \item Seq_ID The ID of the sequenced line in the CDBN panel.
#'   \item GHmode Mode of the growth habit scored in the CDBN.
#'   \item CDBN_ID ID of the CDBN entry
#'   \item Gene_pool Whether the CDBN entry came from the Mesoamerican or Andean gene pool.
#'   \item Race The race of the CDBN entry: Durango, Jalisco, Mesoamerican, or Nueva Granada.
#'   \item Market_class_ahm Market class of the CDBN entry
#'   \item Det_scr Whether or not the CDBN entry was determinate
#'   \item Earliest_Year_CDBN The earliest year the entry was grown in the CDBN.
#'   \item BM BLUPs for biomass in kg
#'   \item BR BLUPs for whether or not the entry had a blackroot BCMV response
#'   \item CB BLUPs for common bacterial blight damage score
#'   \item CM BLUPs for BCMV (bean common mosaic virus) damage score
#'   \item CT BLUPs for curly top virus presence/absence
#'   \item DF BLUPs for days to flowering
#'   \item DM BLUPs for days to maturity
#'   \item EV BLUPs for early vigor score
#'   \item GH BLUPs for growth habit, on a 1-3 scale
#'   \item HB BLUPs for halo blight damage score
#'   \item HI BLUPs for harvest index (%)
#'   \item LG BLUPs for lodging score
#'   \item PH BLUPs for plant height, in cm
#'   \item RR BLUPs for root rot damage score
#'   \item RU BLUPs for rust damage score
#'   \item SA BLUPs for seed appearance score
#'   \item SF BLUPs for the duration of seed fill, in days.
#'   \item SW BLUPs for seed weight, in mg.
#'   \item SY BLUPs for seed yield, in kg per ha.
#'   \item WM BLUPs for white mold damage score
#'   \item ZN BLUPs for zinc deficiency damage score
#' }
#'
#' @name BLUPs
#' @docType data
#' @author Alice MacQueen \email{alice.macqueen@@utexas.edu}
#' @references \url{data_blah.com}
#' @keywords data
#' @usage data(BLUPs)
#' @format A data frame with 327 rows and 31 variables
NULL