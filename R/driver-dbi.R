# This is a minimal implementation that exists to ensure that dbplyr/glue
# functions that call DBI S4 methods dispatch to the right place. In the
# future this should use the generic ADBC DBI wrapper; however, that does
# not exist yet.

#' Wrapper DBI implementation
#'
#' @return
#'   - `wrapper()` returns a DBIDriver subclass
#'
#' @export
#' @importFrom methods new setClass setMethod callNextMethod initialize
#'
#' @examplesIf has_wrapper_test_flightsql()
#' con <- DBI::dbConnect(
#'   wrapper(),
#'   wrapper_test_flightsql_uri(),
#'   username = wrapper_test_flightsql_username(),
#'   password = wrapper_test_flightsql_password(),
#'   database_options = c(
#'     "adbc.flight.sql.client_option.tls_skip_verify" = "true"
#'   )
#' )
#'
#' DBI::dbDisconnect(con)
wrapper <- function() {
  new("WrapperDriver")
}

#' Wrapper S4 DBIDriver internals
#'
#' @slot parent_driver An instance of [adbcwrapper()]
#' @importFrom DBI dbConnect dbDisconnect dbGetQuery dbBegin dbCommit
#' @importFrom DBI dbWriteTable dbRollback dbSendQuery dbClearResult dbFetch
#' @importFrom DBI dbHasCompleted dbGetRowsAffected
WrapperDriver <- setClass("WrapperDriver",
  contains = "DBIDriver",
  slots = list(parent_driver = "ANY")
)

initialize_WrapperDriver <- function(.Object) {
  .Object <- callNextMethod()
  .Object@parent_driver <- adbcwrapper()
  .Object
}

setMethod("initialize", "WrapperDriver", initialize_WrapperDriver)

#' Wrapper S4 DBIConnection
#'
#' @slot parent_database An ADBC database pointer
#' @slot parent_connection An ADBC connection pointer
setClass("WrapperConnection",
  contains = "DBIConnection",
  slots = list(
    parent_database = "ANY",
    parent_connection = "ANY"
  )
)

#' Wrapper S4 DBIResult
#'
#' @slot reader A nanoarrow_array_stream
setClass("WrapperResult",
  contains = "DBIResult",
  slots = list(
    reader = "ANY"
  )
)

initialize_WrapperConnection <- function(.Object, parent_database,
                                         parent_connection) {
  .Object@parent_database <- parent_database
  .Object@parent_connection <- parent_connection
  .Object
}

dbConnect_WrapperDriver <- function(drv, uri, ..., username = NULL,
                                    password = NULL, database_options = NULL) {
  database_options <- as.list(database_options)
  database_options$uri <- uri
  database_options$username <- username
  database_options$password <- password
  db <- do.call(
    adbcdrivermanager::adbc_database_init,
    c(list(drv@parent_driver), database_options)
  )

  con <- adbcdrivermanager::adbc_connection_init(db)

  new("WrapperConnection", db, con)
}

dbDisconnect_WrapperConnection <- function(conn) {
  adbcdrivermanager::with_adbc(conn@parent_database, {
    adbcdrivermanager::with_adbc(conn@parent_connection, {
      invisible(NULL)
    })
  })
}

dbSendQuery_WrapperConnection <- function(conn, statement, ...) {
  reader <- adbcdrivermanager::read_adbc(
    conn@parent_connection,
    unclass(statement)
  )

  new("WrapperResult", reader)
}

dbGetQuery_WrapperConnection <- function(conn, statement, ...) {
  reader <- adbcdrivermanager::read_adbc(
    conn@parent_connection,
    unclass(statement)
  )

  adbcdrivermanager::with_adbc(reader, {
    as.data.frame(reader)
  })
}

dbWriteTable_WrapperConnection <- function(conn, name, value, ...) {
  inline <- dbplyr::sql_render(dbplyr::copy_inline(conn, value))

  create <- paste0(
    "CREATE TABLE ",
    DBI::dbQuoteIdentifier(conn, name),
    " AS ", inline
  )

  adbcdrivermanager::execute_adbc(conn@parent_connection, create)

  invisible(NULL)
}

dbBegin_WrapperConnection <- function(conn, ...) {
  stop("Transactions are not supported for Wrapper")
  invisible(NULL)
}

dbRollback_WrapperConnection <- function(conn, ...) {
  stop("Transactions are not supported for Wrapper")
  invisible(NULL)
}

dbCommit_WrapperConnection <- function(conn, ...) {
  stop("Transactions are not supported for Wrapper")
  invisible(NULL)
}

initialize_WrapperResult <- function(.Object, reader) {
  .Object@reader <- reader
  .Object
}

dbClearResult_WrapperResult <- function(res, ...) {
  res@reader$release()
}

dbFetch_WrapperResult <- function(res, n = -1, ...) {
  if (n != -1) {
    stop("n != -1 not supported")
  }

  as.data.frame(res@reader)
}

dbHasCompleted_WrapperResult <- function(res, ...) {
  !adbcdrivermanager::adbc_xptr_is_valid(res@reader)
}

dbGetRowsAffected_WrapperResult <- function(res, ...) {
  0
}
