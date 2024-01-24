
<!-- README.md is generated from README.Rmd. Please edit that file -->

# demoadbcplyr

<!-- badges: start -->
<!-- badges: end -->

The goal of demoadbcplyr is to be a proof-of-concept for the hardest
possible use of dbplyr generating SQL to send to an ADBC driver. This
example uses the ADBC FlightSQL driver, which itself wraps a connection
to DuckDB. The proof-of-concept here uses dbplyr with a DBI connection
that is pretending to be Postgres for just long enough to generate
Postgres-flavoured SQL.

## Installation

You can install the development version of demoadbcplyr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("paleolimbot/demoadbcplyr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
# Start the FlightSQL test server with `docker compose up`

library(demoadbcplyr)
library(dplyr, warn.conflicts = FALSE)

Sys.setenv(R_WRAPPER_FLIGHTSQL_TEST_URI = "grpc+tls://localhost:31337")
con <- wrapper_test_con()
tbl(con, "NATION") |> 
  arrange(n_nationkey)
#> # Source:     SQL [?? x 4]
#> # Database:   WrapperConnection
#> # Ordered by: n_nationkey
#>    n_nationkey n_name    n_regionkey n_comment                                  
#>          <int> <chr>           <int> <chr>                                      
#>  1           0 ALGERIA             0 "furiously regular requests. platelets aff…
#>  2           1 ARGENTINA           1 "instructions wake quickly. final deposits…
#>  3           2 BRAZIL              1 "asymptotes use fluffily quickly bold inst…
#>  4           3 CANADA              1 "ss deposits wake across the pending foxes…
#>  5           4 EGYPT               4 "usly ironic, pending foxes. even, special…
#>  6           5 ETHIOPIA            0 "regular requests sleep carefull"          
#>  7           6 FRANCE              3 "oggedly. regular packages solve across"   
#>  8           7 GERMANY             3 "ong the regular requests: blithely silent…
#>  9           8 INDIA               2 "uriously unusual deposits about the slyly…
#> 10           9 INDONESIA           2 "d deposits sleep quickly according to the…
#> # ℹ more rows
```
