#' Class calculating metrics
GitMiner <- setRefClass(
  Class = "gitminer",

  fields = list(
    rawdata = "data.frame",
    population_data = "data.frame",
    target_data = "data.frame"
  ),

  methods = list(
    # Constructor
    #' @param datasource File path for datasources(csv formatted)
    initialize = function(datasource, input) {
      tryCatch(
        rawdata <<- if (length(input$repository_filter) == 0) {
          read.csv(datasource)
        } else {
          subset(read.csv(datasource), grepl(input$repository_filter, url))
        },
        error = function(e){
          print(e)
          rawdata <<- data.frame()
        },
        population_data <<- rawdata,
        target_data <<- rawdata
      )
    },
    # Processing metrics data for filtering, normalizing by lines and boxcox
    # transforming.
    # Only when `is_calc_density` is true, metrics data is devided by lines.
    # Only when `is_calc_boxcox` is true, metrics data is transformed by boxcox
    #' @param base string for filtering populations
    #' @param group string for filtering projects
    #' @param is_calc_density if true, calculate density of `field` metrics
    #' @param is_calc_boxcox if true, calculate BoxCox Transform for metrics
    #' @param ... metrics fields list
    cleansing = function(base, group, is_calc_density, is_calc_boxcox, ...) {
      all <- filter_latest_raw_data(base, "")
      # transforming metrics data
      for (field in c(...)) {
        if (is_calc_density && is_non_numeric_metrics_name(field)) {
          all[field] <- calculate_density(all, field)
        }
        if (is_calc_boxcox && is_non_numeric_metrics_name(field)) {
          all <- calculate_boxcox(all, field)
        }
      }
      # filtering data
      population_data <<- all
      if (is.null(group)) {
        target_data <<- population_data
      } else {
        target_data <<- subset(population_data, grepl(group, url))
      }
    },
    #' Get density value that of given field name devided by lines
    #' @param data metrics data
    #' @param field metrics item name
    #' @return metrics density
    calculate_density = function(rawdata, field) {
      return(unlist(rawdata[field] / rawdata["lines"]))
    },
    # Return BoxCox transformed metrics data.
    # Strictly positive value is only transformed.
    #' @importFrom car powerTransform
    #' @importFrom car bcPower
    #' @return BoxCox transformed metrics values
    calculate_boxcox = function(d, field) {
      positives <- subset(d, d[field] > 0)
      negatives <- subset(d, d[field] <= 0)
      invalids <- subset(d, is.na(d[field]))
      # BoxCox transform needs 3 data point
      if (nrow(positives[field]) >= 3) {
        p1 <- powerTransform(positives[field])
        positives[field] <- bcPower(unlist(positives[field]), p1$roundlam)
      }
      return(rbind(positives, negatives, invalids))
    },
    # Return metrics values specified `field` from populations.
    #' @param field metrics kind
    #' @return metrics values of `field`
    get_data_from_populations = function(field) {
      if (is.null(field) || !any(colnames(rawdata) == field)){
        return(list())
      }
      return(unlist(population_data[field]))
    },
    # Return metrics values specified `field` from targets.
    #' @param field metrics kind
    #' @return metrics values of `field`
    get_data_from_target = function(field) {
      if (is.null(field) || !any(colnames(rawdata) == field)){
        return(list())
      }
      return(unlist(target_data[field]))
    },
    # Return latest metrics data that filtered url by `group`.
    #' @importFrom dplyr group_by
    #' @importFrom dplyr %>%
    #' @importFrom dplyr arrange
    #' @importFrom dplyr filter
    #' @param group string for filtering projects
    #' @return Latest metrics data filtered by `group`
    filter_latest_raw_data = function(base, group) {
      return(filter_by_url(c(base, group)) %>%
        dplyr::group_by(url) %>%
        arrange(time) %>%
        filter(row_number() == n()))
    },
    #' Get metrics data that filtered url by `group`
    #' @param group string for filtering projects
    #' @return Filtered metrics data
    filter_by_url = function(queries) {
      result <- rawdata
      for (i in 1:length(queries)) {
        result <- subset(result, grepl(queries[i], url))
      }
      return(result)
    },
    #' Return numeric metrics item name
    #' @return List of names of numeric metrics item
    get_numric_metrics_names = function() {
      numericdata <- rawdata[sapply(rawdata, is.numeric)]
      return(colnames(numericdata))
    },
    #' Return non-numeric metrics item name
    #' @return List of names of non-numeric metrics item
    get_non_numeric_metrics_names = function() {
      nonnumericdata <- rawdata[sapply(rawdata, function(e){
        !is.numeric(e)
      })]
      return(colnames(nonnumericdata))
    },
    is_non_numeric_metrics_name = function(name) {
      return(!(name %in% get_non_numeric_metrics_names()))
    }
  )
)
