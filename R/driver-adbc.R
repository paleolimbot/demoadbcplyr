#' ADBC wrapper Driver
#'
#' A thin wrapper around the [adbcflightsql::adbcflightsql()] driver that
#' adds a wrapper-specific class to each driver/database/connection/statement
#' instance.
#'
#' @inheritParams adbcflightsql::adbcflightsql
#'
#' @return An [adbcdrivermanager::adbc_driver()]
#' @export
#'
#' @examples
#' adbcwrapper()
#'
adbcwrapper <- function() {
  parent <- adbcflightsql::adbcflightsql()
  class(parent) <- union("wrapper_driver_adbc", class(parent))
  parent
}

#' @rdname adbcwrapper
#' @importFrom adbcdrivermanager adbc_database_init
#' @export
adbc_database_init.wrapper_driver_adbc <- function(driver, ..., uri = NULL) {
  parent <- NextMethod()
  class(parent) <- union("wrapper_database", class(parent))
  parent
}

#' @rdname adbcwrapper
#' @importFrom adbcdrivermanager adbc_connection_init
#' @export
adbc_connection_init.wrapper_database <- function(database, ...,
                                                  adbc.connection.autocommit = NULL) {
  parent <- NextMethod()
  class(parent) <- union("wrapper_connection", class(parent))
  parent
}

#' @rdname adbcwrapper
#' @importFrom adbcdrivermanager adbc_statement_init
#' @export
adbc_statement_init.wrapper_connection <- function(connection, ...,
                                                   adbc.ingest.target_table = NULL,
                                                   adbc.ingest.mode = NULL) {
  parent <- NextMethod()
  class(parent) <- union("wrapper_statement", class(parent))
  parent
}
