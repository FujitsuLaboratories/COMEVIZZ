#' Start comevizz script
NULL

devtools::install_local('/usr/local/src', force=TRUE)
library(comevizz)
comevizz::run()
