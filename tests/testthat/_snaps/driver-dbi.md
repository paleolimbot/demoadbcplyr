# DBI wrapper implements enough methods for print() and collect()

    Code
      print(dplyr::arrange(dplyr::tbl(con, "NATION"), n_nationkey))
    Output
      # Source:     SQL [?? x 4]
      # Database:   WrapperConnection
      # Ordered by: n_nationkey
         n_nationkey n_name    n_regionkey n_comment                                  
               <int> <chr>           <int> <chr>                                      
       1           0 ALGERIA             0 "furiously regular requests. platelets aff~
       2           1 ARGENTINA           1 "instructions wake quickly. final deposits~
       3           2 BRAZIL              1 "asymptotes use fluffily quickly bold inst~
       4           3 CANADA              1 "ss deposits wake across the pending foxes~
       5           4 EGYPT               4 "usly ironic, pending foxes. even, special~
       6           5 ETHIOPIA            0 "regular requests sleep carefull"          
       7           6 FRANCE              3 "oggedly. regular packages solve across"   
       8           7 GERMANY             3 "ong the regular requests: blithely silent~
       9           8 INDIA               2 "uriously unusual deposits about the slyly~
      10           9 INDONESIA           2 "d deposits sleep quickly according to the~
      # i more rows

