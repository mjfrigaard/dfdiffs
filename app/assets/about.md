### In SAS, the `PROC COMPARE` syntax is as follows:

    libname proclib 'SAS-library';
    options pageno=1 linesize=80 pagesize=40;
    proc compare base=[DATA X] compare=[DATA Y];
    id [id column];
    title 'Comparing Observations that Have Matching [id column]s';
    run;

### This application uses the `arsenal::comparedf()` function to compare two SAS datasets. The syntax is below:

    library(arsenal)
    comparedf(x = [Data X], y = [Data Y], by = [id column], control = NULL, ...)
