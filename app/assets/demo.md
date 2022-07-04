### A quick demo:

    df_x <- tibble::tribble(
               ~id,  ~a, ~b,  ~c,
         "person1", "a",  1, "f",
         "person2", "b",  3, "e",
         "person3", "c",  4, "d")
    df_y <- tibble::tribble(
               ~id,  ~a, ~b,    ~d,
         "person3", "c",  1, "rn1",
         "person2", "b",  3, "rn2",
         "person1", "a",  4, "rn3")

    df_compare_object <- summary(comparedf(x = df_x, y = df_y, by = "id"))

    # we've rewritten this for easier printing: 
    proc_extract_table(comparedf_list = df_compare_object, 
                       table = "diffs.table", by_col = "id")

    ## # A tibble: 2 × 5
    ##   id      `Column X` `Column Y` `X Value` `Y Value`
    ##   <chr>   <chr>      <chr>      <chr>     <chr>    
    ## 1 person1 b          b          1         4        
    ## 2 person3 b          b          4         1
