Messages <- setRefClass(
  Class = "Messages",
  fields = list(
    lang = "character",
    translation = "list"
  ),
  methods = list(
    initialize = function() {
      lang <<- "en"
      translation <<- list(
        "title" = list(
          "en" = "COMEVIZZ"
        ),
        "projects.datasources.title" = list(
          "en" = "Datasources"
        ),
        "projects.datasources.metrics_data_file.label" = list(
          "en" = "Metrics Datafile(.csv)"
        ),
        "projects.datasources.calculate_density.label" = list(
          "en" = "Normalized by Lines"
        ),
        "projects.datasources.calculate_boxcox.label" = list(
          "en" = "BoxCox Transform"
        ),
        "projects.datasources.filter.title" = list(
          "en" = "Filtering Projects"
        ),
        "projects.datasources.filter.help" = list(
          "en" = "You can filter projects for selections analyzation targets."
        ),
        "projects.datasources.filter.population.label" = list(
          "en" = "Population"
        ),
        "projects.datasources.filter.target.label" = list(
          "en" = "Target"
        ),
        "projects.datasources.project_info.title" = list(
          "en" = "Projects info"
        ),
        "tab.metrics.display_name" = list(
          "en" = "Metrics Stats"
        ),
        "tab.metrics.select_metrics" = list(
          "en" = "Select metrics item for analyzing"
        ),
        "tab.metrics.select_metrics.help1" = list(
          "en" = "Firstly please select datasource files from left pane."
        ),
        "tab.metrics.select_metrics.label" = list(
          "en" = "Select Metrics"
        ),
        "tab.metrics.calculate_density.label" = list(
          "en" = "Normalized by Lines"
        ),
        "tab.metrics.main.title" = list(
          "en" = "Statistics"
        ),
        "tab.metrics.main.metrics.unselectable_metrics" = list(
          "en" = "You cannot select non-numeric metrics"
        ),
        "tab.metrics.main.metrics.no_data_error" = list(
          "en" = "This Metrics has no data and cannot be displayed."
        ),
        "tab.metrics.main.metrics.not_numeric_error" = list(
          "en" = "This Metrics isn't numeric value, so can't be displayed."
        ),
        "tab.metrics.main.statistics.average.label" = list(
          "en" = "Average"
        ),
        "tab.metrics.main.statistics.median.label" = list(
          "en" = "Median"
        ),
        "tab.metrics.main.statistics.stddev.label" = list(
          "en" = "Standard Deviations"
        ),
        "tab.metrics.main.statistics.row.label1" = list(
          "en" = "Population"
        ),
        "tab.metrics.main.statistics.row.label2" = list(
          "en" = "Target"
        ),
        "tab.metrics.main.target_project.title" = list(
          "en" = "Target Project"
        ),
        "tab.metrics.main.all_project.title" = list(
          "en" = "All Project"
        ),
        "tab.zscore.display_name" = list(
          "en" = "Z-Score"
        ),
        "tab.zscore.title" = list(
          "en" = "Z-Score"
        ),
        "tab.zscore.header.help1" = list(
          "en" = "The number of metrics items must be 3 or more."
        ),
        "tab.zscore.header.help2" = list(
          "en" = "Please select metrics item for displaying z-score radarchart from right hand side."
        ),
        "tab.zscore.right.help" = list(
          "en" = "Select Metrics Sets"
        ),
        "tab.zscore.right.select_metrics.label" = list(
          "en" = "Select Metrics"
        ),
        "tab.all_metrics.display_name" = list(
          "en" = "All Metrics"
        ),
        "tab.all_metrics.title" = list(
          "en" = "All Metrics"
        )
      )
    },
    tr = function(text) {
      sapply(text, function(s) translation[[s]][[lang]], USE.NAMES = FALSE)
    },
    set_lang = function(language = "en") {
      lang <<- language
    }
  )
)
