
test_that("ADBC driver methods generate the correct subclasses", {
  skip_if_not(has_wrapper_test_flightsql())

  drv <- adbcwrapper()
  expect_s3_class(drv, "wrapper_driver_adbc")

  uri <- wrapper_test_flightsql_uri()
  db <- adbcdrivermanager::adbc_database_init(drv, uri = uri)
  expect_s3_class(db, "wrapper_database")

  con <- adbcdrivermanager::adbc_connection_init(db)
  expect_s3_class(con, "wrapper_connection")

  stmt <- adbcdrivermanager::adbc_statement_init(con)
  expect_s3_class(stmt, "wrapper_statement")
})
