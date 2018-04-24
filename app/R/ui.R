#' Define UI for application that draws plots
#' 
#' @importFrom shiny shinyUI column h3 fluidPage fluidRow sidebarLayout 
#'  mainPanel sidebarPanel titlePanel plotOutput textInput uiOutput tabPanel tabsetPanel
#' @name infrastructure
NULL

ui <- shinyUI(fluidPage(
  # Application title
  titlePanel(messages$tr("title")),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("filter_panel")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(
          messages$tr("tab.zscore.display_name"),
          h3(messages$tr("tab.zscore.title")),
          helpText(
            messages$tr("tab.zscore.header.help1"),
            messages$tr("tab.zscore.header.help2")
          ),
          fluidRow(
            column(
              8,
              actionButton("show_save_modal", "Save Radarchart as .png", icon = icon("image")),
              hr(),
              plotOutput("render_zscore")
            ),
            column(
              4,
              wellPanel(
                selectInput(
                  "zscore_metrics_set",
                  label = messages$tr("tab.zscore.right.help"),
                  selected = 1,
                  choices = list(
                    Issues = "bugs,code_smells,vulnerabilities",
                    Violations = "violations,blocker_violations,critical_violations,major_violations,minor_violations,info_violations",
                    Complexity = "complexity,function_complexity,class_complexity",
                    Custom = ""
                  )
                ),
                hr(),
                uiOutput("select_zscore_metrics"),
                uiOutput("zscore_invalid_description")
              )
            )
          )
        ),
        tabPanel(
          messages$tr("tab.metrics.display_name"),
          fluidRow(
            wellPanel(
              h3(messages$tr("tab.metrics.select_metrics")),
              helpText(messages$tr("tab.metrics.select_metrics.help1")),
              uiOutput("make_metrics_select_box"),
              uiOutput("stats_invalid_description")
            ),
            hr(),
            h3(messages$tr("tab.metrics.main.title")),
            dataTableOutput("target_statistics")
          ),
          fluidRow(
            column(
              6,
              plotOutput("dist_plot")
            ),
            column(
              6,
              plotOutput("pdf_plot")
            )
          ),
          fluidRow(
            column(
              6,
              h3(messages$tr("tab.metrics.main.target_project.title")),
              dataTableOutput("select_metrics_table_target")
            ),
            column(
              6,
              h3(messages$tr("tab.metrics.main.all_project.title")),
              dataTableOutput("select_metrics_table_all")
            )
          )
        ),
        tabPanel(
          messages$tr("tab.all_metrics.display_name"),
          h3(messages$tr("tab.all_metrics.title")),
          dataTableOutput("all_metrics_table")
        )
      )
    )
  )
))
