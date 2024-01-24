
#' Wrapper SQL Translation
#'
#' @return
#'   - `simulate_wrapper()` returns an object of class "WrapperConnection"
#'     that can be used to test SQL generation
#' @export
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#'
#' lf <- dbplyr::lazy_frame(a = TRUE, b = 1, c = 2, d = "z", con = simulate_wrapper())
#' lf %>% summarise(x = sd(b, na.rm = TRUE))
#' lf %>% summarise(y = cor(b, c), z = cov(b, c))
#'
simulate_wrapper <- function() {
  dbplyr::simulate_dbi("WrapperConnection")
}

#' @importFrom dbplyr sql_translation
#' @export
sql_translation.WrapperConnection <- function(con) {
  base <- dbplyr::sql_translation(dbplyr::simulate_postgres())
  dbplyr::sql_variant(
    scalar = dbplyr::sql_translator(.parent = base$scalar),
    aggregate = dbplyr::sql_translator(.parent = base$aggregate),
    window = dbplyr::sql_translator(.parent = base$window)
  )
}

#' @importFrom dbplyr dbplyr_edition
#' @export
dbplyr_edition.WrapperConnection <- function(con) 2L

# S4 methods registered in zzz.R
#' @importFrom DBI dbQuoteIdentifier
dbQuoteIdentifier_WrapperConnection <- function(conn, x, ...) {
  if (inherits(x, "SQL")) {
    return(x)
  }

  out <- gsub('"', '""', enc2utf8(x))
  DBI::SQL(paste0('"', out, '"'), names = names(x))
}
