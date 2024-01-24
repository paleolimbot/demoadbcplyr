#' Wrapper testing parameters
#'
#' @return
#'   - `wrapper_flightsql_test_uri()` returns a URI to a DuckDB-backed
#'     FlightSQL instance. This URI is read from the
#'     R_WRAPPER_FLIGHTSQL_TEST_URI environment variable.
#'   - `wrapper_has_test_flightsql()` returns TRUE if the
#'     R_WRAPPER_FLIGHTSQL_TEST_URI environment variable is set or FALSE
#'     otherwise.
#'
#' @export
#'
#' @examplesIf has_wrapper_test_flightsql()
#' has_wrapper_test_flightsql()
#' wrapper_test_flightsql_uri()
wrapper_test_flightsql_uri <- function() {
  Sys.getenv("R_WRAPPER_FLIGHTSQL_TEST_URI", "")
}

#' @rdname wrapper_test_flightsql_uri
#' @export
wrapper_test_flightsql_username <- function() {
  opt <- Sys.getenv("R_WRAPPER_FLIGHTSQL_TEST_USERNAME", "flight_username")
  if (identical(opt, "")) NULL else opt
}

#' @rdname wrapper_test_flightsql_uri
#' @export
wrapper_test_flightsql_password <- function() {
  opt <- Sys.getenv("R_WRAPPER_FLIGHTSQL_TEST_PASSWORD", "flight_password")
  if (identical(opt, "")) NULL else opt
}

#' @rdname wrapper_test_flightsql_uri
#' @export
has_wrapper_test_flightsql <- function() {
  test_uri <- wrapper_test_flightsql_uri()
  !identical(test_uri, "")
}

#' @rdname wrapper_test_flightsql_uri
#' @export
wrapper_test_con <- function() {
  DBI::dbConnect(
    wrapper(),
    wrapper_test_flightsql_uri(),
    username = wrapper_test_flightsql_username(),
    password = wrapper_test_flightsql_password(),
    database_options = c(
      "adbc.flight.sql.client_option.tls_skip_verify" = "true"
    )
  )
}
