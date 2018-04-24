#' Class for calculationg z-score
Zscore <- setRefClass(
  Class = "zscore",
  fields = list(
    all_metrics = "data.frame",
    target_metrics = "data.frame",
    parameters = "list"
  ),
  methods = list(
    #' constructor
    #'
    #' @param all Metrics data of population
    #' @param target Metrics data of target project for calculationg z-socre
    #' @param params Parameters of metrics
    initialize = function(all, target, params) {
      # filtered by is.numeric
      all_metrics <<- all[, sapply(all, is.numeric)]
      target_metrics <<- target[, sapply(target, is.numeric)]
      parameters <<- lapply(
        params,
        function(p){
          ZscoreMetrics(p, function(list){
            return(list[p])
          })
        }
      )
    },
    #' MIN/MAX value for rendering RadarChart
    #' @return data.frame including parameter name as header and
    #'   each value is static c(-2, 2)
    make_min_max = function(){
      minmax <- data.frame(tmp = c(-2, 2))
      for (c in parameters) {
        minmax[c$name] <- c(2, -2)
      }
      return(minmax[setdiff(colnames(minmax), "tmp")])
    },
    plot_radarchart = function() {
      data <- calculate_zscore_plot()
      label <- paste0(colnames(data), " (", round(data[3, ], digits = 2), ")")
      label <- get_metrics_names()
      radarchart(
        data,
        axistype = 4, centerzero = TRUE,
        vlcex = 1.2, vlabels = label,
        plty = 1, pcol = rgb(0.2, 0.5, 0.5, 0.9), pfcol = rgb(0.2, 0.5, 0.5, 0.5),
        cglcol = "black", axislabcol = "black",
        caxislabels = seq(-2, 2, 1)
      )
    },
    #' Calculate z-score displayed as RadarChart
    #' @return z-score
    calculate_zscore_plot = function(){
      return(rbind(make_min_max(), calc_zscore()))
    },
    calc_zscore = function(){
      zscore <- data.frame(tmp = 0)
      for (m in parameters) {
        x <- mean(apply(target_metrics, 1, m$func), na.rm = TRUE)
        ave <- mean(apply(all_metrics, 1, m$func), na.rm = TRUE)
        deviation <- sd(apply(all_metrics, 1, m$func), na.rm = TRUE)

        d <- -1 * (x - ave) / deviation
        zscore[m$name] <- d
      }
      return(zscore[setdiff(colnames(zscore), "tmp")])
    },
    get_metrics_names = function(){
      l <- c()
      for (m in parameters) {
        l <- append(l, m$name)
      }
      return(l)
    }
  )
)
