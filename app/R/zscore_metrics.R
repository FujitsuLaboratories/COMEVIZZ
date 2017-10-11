#' Class for metrics info of z-score radarchart's axis
ZscoreMetrics <- setRefClass(
  Class <- "zscore_metrics",
  fields = list(
    name = "character",
    func = "function"
  ),
  methods = list(
    #' Constructor
    #' @param n Name of metrics
    #' @param f Function that return metrics value for z-score radarchart
    #'   (E.g.: x$code_smells / x$lines)
    initialize = function(
      n = "undefined",
      f = function(x){
        return(NA)
      }
    ) {
      name <<- n
      func <<- f
    }
  )
)
