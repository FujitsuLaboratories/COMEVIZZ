#' @importFrom shiny shinyServer
server <- shiny::shinyServer(function(input, output, session) {
  miner <- eventReactive(input$datafile, {
    input_file <- input$datafile
    if (is.null(input_file)) {
      return (NULL)
    }
    GitMiner$new(input_file$datapath, input)
  })
  numeric_metrics_names <- reactive({
    miner()$get_numric_metrics_names()
  })
  non_numeric_metrics_names <- reactive({
    miner()$get_non_numeric_metrics_names()
  })
  # Get most recent metrics data of all projects
  #' @importFrom shiny need
  #' @importFrom shiny reactive
  #' @importFrom shiny validate
  #' @return metrics data values specified by input$select_metrics
  all_latest_data <- reactive({
    update_data()
    data <- miner()$get_data_from_populations(input$select_metrics)
    validate(
      need(
        length(data) > 0,
        messages$tr("tab.metrics.main.metrics.no_data_error")
      ),
      need(
        is.numeric(data),
        messages$tr("tab.metrics.main.metrics.not_numeric_error")
      )
    )
    data
  })
  # Get most recent metrics data of projects filtered by `target_filter` text
  #' @importFrom shiny need
  #' @importFrom shiny reactive
  #' @importFrom shiny validate
  #' @return metrics data values filtered by `target_filter` and specified by
  #'   input$select_metrics
  filtered_latest_data <- reactive({
    update_data()
    data <- miner()$get_data_from_target(input$select_metrics)
    validate(
      need(
        length(data) > 0,
        messages$tr("tab.metrics.main.metrics.no_data_error")
      ),
      need(
        is.numeric(data),
        messages$tr("tab.metrics.main.metrics.not_numeric_error")
      )
    )
    data
  })
  # Update metrics data by specified condition.
  update_data <- reactive({
    miner()$cleansing(
      input$repository_filter,
      input$target_filter,
      input$calculate_density,
      input$boxcox, zscore_metrics()
    )
  })

  ##############
  # Left Pane  #
  ##############
  # Render UI panel for inputing analyzed project info
  #' @importFrom shiny tags h3 checkboxInput textInput uiOutput
  output$filter_panel <- renderUI({
    tags$div(
      tags$div(
        h3(messages$tr("projects.datasources.title")),
        fileInput(
          "datafile",
          messages$tr("projects.datasources.metrics_data_file.label"),
          accept = c(
            "text/csv",
            "text/comma-separated-values,text/plain",
            ".csv"
          )
        ),
        checkboxInput(
          "calculate_density",
          label = messages$tr("projects.datasources.calculate_density.label"),
          value = FALSE
        ),
        checkboxInput(
          "boxcox",
          label = messages$tr("projects.datasources.calculate_boxcox.label"),
          value = FALSE
        ),
        h3(messages$tr("projects.datasources.filter.title")),
        helpText(messages$tr("projects.datasources.filter.help")),
        textInput(
          "repository_filter",
          label = messages$tr("projects.datasources.filter.population.label"),
          value = ""
        ),
        textInput(
          "target_filter",
          label = messages$tr("projects.datasources.filter.target.label"),
          value = ""
        )
      ),
      tags$hr(),
      tags$div(
        h3(messages$tr("projects.datasources.project_info.title")),
        uiOutput("target_info_list")
      )
    )
  })

  # Render SelectBox about metrics item
  #' @importFrom shiny renderUI selectInput
  output$make_metrics_select_box <- renderUI({
      selectInput(
        "select_metrics",
        label = messages$tr("tab.metrics.select_metrics.label"),
        choices = c(choose = "", numeric_metrics_names()),
        selected = 1
      )
  })

  # Render infomation of projects filtered by `targetFileter` text
  #' @importFrom shiny tags
  #' @importFrom foreach foreach %do%
  output$target_info_list <- renderUI({
    all_repo <- miner()$filter_latest_raw_data(input$repository_filter, "")
    target_repo <- miner()$filter_latest_raw_data(
      input$repository_filter,
      input$target_filter
    )

    tags$div(
      tags$p(
        paste0(
          "Query: '",
          input$target_filter,
          "' - found ",
          nrow(target_repo),
          " / ",
          nrow(all_repo),
          " repositories."
        )
      ),
      tags$ul(
        foreach(i = 1:nrow(all_repo)) %do%
          target_info(target_repo, all_repo[i, ])
      )
    )
  })

  # Render infomation of a project.
  # The project that don't including `target_filter` text become inactive
  # and grey colorerd.
  #' @importFrom shiny tags
  target_info <- function(target_repo, repo){
    if (repo$url %in% target_repo$url) {
      return(tags$li(
        tags$a(href = repo$url, repo$url),
        " (",
        tags$a(
          href = sub(".git$", paste0("/commit/", repo$commit.id), repo$url),
          tags$small(repo$time)
        ),
        ")"
      ))
    } else {
      return(tags$li(
        style = "color:grey; list-style-type:circles;",
        repo$url,
        paste0(" (", repo$time, ")")
      ))
    }
  }

  ##############
  # Right Pane #
  ##############
  # Plot `Empirical Cumultive Distribution Function` about selected metrics
  #' @importFrom shiny renderPlot
  #' @importFrom graphics legend plot
  #' @importFrom stats ecdf
  output$dist_plot <- renderPlot({
    # Metadata for plot
    cols <- c("orange", "red")
    ltys <- c(2, 1)
    pchs <- c(2, 1)

    # ALL Metrics Data Plot
    plot(
      ecdf(all_latest_data()),
      col = cols[1], lty = ltys[1], pch = pchs[1],
      xlim = c(0, max(all_latest_data(), na.rm = TRUE)),
      xlab = "Metrics Value", ylab = "Percentile",
      main = "Empirical Cumulative Distribution Function"
    )
    # Filtered by text in target_filter filed Metrics Data Plot
    plot(
      ecdf(filtered_latest_data()),
      col = cols[2], lty = ltys[2], pch = pchs[2],
      add = TRUE
    )

    legends <- c("All Projects", "Target Projects")
    legend("bottomright", legend = legends, col = cols, lty = ltys, pch = pchs)
  })

  # Calculate `probability Density Function`.
  # If the length of `data` is equal `1`, return `1` since `sd` can't be calculated correctly.
  #' @param data original data
  calculateProb <- function(data) {
    if(length(data) == 1) {
      return(1)
    }
    mean <- mean(data, na.rm = TRUE)
    sd <- sd(data, na.rm = TRUE)
    prob <-  dnorm(data, mean, sd)
    prob <- replace(prob, which(is.infinite(prob)), 0)
    prob <- replace(prob, which(is.na(prob)), 0)
    return(prob)
  }

  # Render `Probability Density Function` for selected metrics
  #' @importFrom shiny renderPlot
  #' @importFrom graphics boxplot
  output$pdf_plot <- renderPlot({
    # Metrics Statistics
    all <- all_latest_data()
    all <- all[sort.list(all)]
    prob_all <- calculateProb(all)

    target <- filtered_latest_data()
    target <- target[sort.list(target)]
    prob_target <- calculateProb(target)

    xmax_all <- max(all, na.rm = TRUE)
    xmin_all <- min(all, na.rm = TRUE)

    # plot
    cols <- c("orange", "red")
    ltys <- c(2, 1)
    pchs <- c(2, 1)

    default.par <- par(oma = c(0, 0, 0, 2))
    plot(
      col = cols[1], col.lab = cols[1], pch = pchs[1], lty = ltys[1], type = "b",
      all, prob_all,
      xlim = c(xmin_all, xmax_all),
      xlab = "Metrics Value", ylab = "All Probability",
      main = "Probability Density Function"
    )
    par(new = TRUE)
    plot(
      col = cols[2], pch = pchs[2], lty = ltys[2], type = "b",
      target, prob_target,
      xlim = c(xmin_all, xmax_all),
      xlab = "Metrics Value", ylab = "",
      axes = FALSE
    )
    axis(4)
    mtext("Target Probability", col = cols[2], side = 4, line = 3)

    legends <- c("All Projects", "Target Projects")
    legend("topright", legend = legends, col = cols, lty = ltys, pch = pchs)
    par(default.par)
  })

  # Render statistics as datatable
  #' @importFrom shiny renderDataTable
  output$target_statistics <- renderDataTable(
    setNames(
      data.frame(
        # Item label
        c(
          messages$tr("tab.metrics.main.statistics.average.label"),
          messages$tr("tab.metrics.main.statistics.median.label"),
          messages$tr("tab.metrics.main.statistics.stddev.label")
        ),
        # Statistics for Population
        c(
          mean(all_latest_data(), na.rm = TRUE),
          median(all_latest_data(), na.rm = TRUE),
          sd(all_latest_data(), na.rm = TRUE)
        ),
        # Statistics for Target
        c(
          mean(filtered_latest_data(), na.rm = TRUE),
          median(filtered_latest_data(), na.rm = TRUE),
          sd(filtered_latest_data(), na.rm = TRUE)
        )
      ),
      c("",
        messages$tr("tab.metrics.main.statistics.row.label1"),
        messages$tr("tab.metrics.main.statistics.row.label2")
      )
    ),
    list(paging = FALSE, searching = FALSE)
  )

  # Render metrics value for targets as datatable
  #' @importFrom shiny renderDataTable
  output$select_metrics_table_target <- renderDataTable(
    setNames(
      data.frame(
        filtered_latest_data(),
        miner()$get_data_from_target("url"),
        miner()$get_data_from_target("time")
      ),
      c(input$select_metrics, "url", "commit_time")
    ),
    options = list(lengthChange = FALSE)
  )

  # Render metrics value for population as datatable
  #' @importFrom shiny renderDataTable
  output$select_metrics_table_all <- renderDataTable(
    setNames(
      data.frame(
        all_latest_data(),
        miner()$get_data_from_populations("url"),
        miner()$get_data_from_populations("time")
      ),
      c(input$select_metrics, "url", "commit_time")
    ),
    options = list(lengthChange = FALSE)
  )

  # Render CheckBox selecting metrics item for z-score radarchart
  #' @importFrom shiny tags checkboxInput
  #' @importFrom foreach foreach %do%
  output$select_zscore_metrics <- renderUI({
    selectInput(
      "zscore",
      label = messages$tr("tab.zscore.right.select_metrics.label"),
      choices = numeric_metrics_names(),
      multiple = TRUE,
      selected = selected_metrics()
    )
  })
  selected_metrics <- reactive({
    # TODO checking for where this is used
    set <- input$zscore_metrics_set
    unlist(strsplit(set, ","))
  })
  zscore_metrics <- reactive({
    input$zscore
  })

  # Render z-score radarchart
  #' @importFrom shiny renderPlot
  #' @importFrom fmsb radarchart
  #' @importFrom grDevices rgb
  #' @importFrom dplyr as_data_frame
  output$render_zscore <- renderPlot({
    update_data()
    d <- Zscore$new(
      miner()$population_data,
      miner()$target_data,
      zscore_metrics()
    )
    data <- d$calculate_zscore_plot()
    label <- paste0(colnames(data), " (", round(data[3, ], digits = 2), ")")
    label <- d$get_metrics_names()
    radarchart(
      data,
      axistype = 4, centerzero = TRUE,
      vlcex = 1.2, vlabels = label,
      plty = 1, pcol = rgb(0.2, 0.5, 0.5, 0.9), pfcol = rgb(0.2, 0.5, 0.5, 0.5),
      cglcol = "black", axislabcol = "black",
      caxislabels = seq(-2, 2, 1)
    )
  },
  height = 600, width = 600)

  output$stats_invalid_description <- renderUI({
    helpText(
      messages$tr("tab.metrics.main.metrics.unselectable_metrics"),
      "(",
      paste(non_numeric_metrics_names(), collapse = ", "),
      ")"
    )
  })
  output$zscore_invalid_description <- renderUI({
    helpText(
      messages$tr("tab.metrics.main.metrics.unselectable_metrics"),
      "(",
      paste(non_numeric_metrics_names(), collapse = ", "),
      ")"
    )
  })

  output$all_metrics_table <- renderDataTable(
    miner()$rawdata,
    options = list(scrollX = TRUE)
  )
})
