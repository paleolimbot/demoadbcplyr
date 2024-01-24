
test_that("DBI wrapper can connect and disconnect", {
  skip_if_not(has_wrapper_test_flightsql())

  drv <- wrapper()
  expect_s4_class(drv, "WrapperDriver")
  expect_s3_class(drv@parent_driver, "wrapper_driver_adbc")

  con <- wrapper_test_con()
  expect_s4_class(con, "WrapperConnection")
  expect_s3_class(con@parent_database, "wrapper_database")
  expect_s3_class(con@parent_connection, "wrapper_connection")
  expect_true(adbcdrivermanager::adbc_xptr_is_valid(con@parent_database))
  expect_true(adbcdrivermanager::adbc_xptr_is_valid(con@parent_connection))

  DBI::dbDisconnect(con)
  expect_false(adbcdrivermanager::adbc_xptr_is_valid(con@parent_database))
  expect_false(adbcdrivermanager::adbc_xptr_is_valid(con@parent_connection))
})

test_that("DBI wrapper implements enough methods for print() and collect()", {
  skip_if_not(has_wrapper_test_flightsql())
  con <- wrapper_test_con()

  # Make sure we can print
  expect_snapshot(
    print(dplyr::arrange(dplyr::tbl(con, "NATION"), n_nationkey))
  )

  # Make sure we can collect
  expect_named(
    dplyr::tbl(con, "NATION") %>%
      dplyr::arrange(n_nationkey) %>%
      dplyr::select(n_nationkey, n_name) %>%
      dplyr::collect(),
    c("n_nationkey", "n_name")
  )
})
