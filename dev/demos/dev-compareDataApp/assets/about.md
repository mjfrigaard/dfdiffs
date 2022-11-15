## `compareDataApp()`

The `compareDataApp()` aims to answer three questions (given two
datasets)

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

### New data

***What rows are here now that weren’t here before?***

    create_new_data(compare = , base = , by = )

### Deleted data

***What rows were here before that aren’t here now?***

    create_deleted_data(compare = , base = , by = )

### Change Data

***What values have been changed?***

    create_changed_data(compare = , base = , by = )

### Comparison to SAS `PROC COMPARE`

In SAS, the `PROC COMPARE` syntax is as follows:

    libname proclib 'SAS-library';
    options pageno=1 linesize=80 pagesize=40;
    proc compare base=[DATA X] compare=[DATA Y];
    id [id column];
    title 'Comparing Observations that Have Matching [id column]s';
    run;
