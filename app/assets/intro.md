***This application compares two SAS datasets and creates the following
tables:***

### Output Tables

#### Comparison Summary

An overall summary of the datasets compared

#### New records

Data that are in `DATA X` that are not in `DATA Y`

#### Modified records

`Changes detected per variable` = counts of changes (`Diffs`) per
variable and `Missing`

`Changes detected` = row-by-row changes, ordered according to the `by`
(join) column

#### Deleted Records

Data that are in `DATA Y` that aren’t in `DATA Y`

#### Variables

`Observations not shared`: observations (rows) in `DATA X` that are not
shared in `DATA Y`

`Variables not shared`: variables (columns) in `DATA X` that are not
shared in `DATA Y`

`Other variables not compared`: variables (columns) not compared due to
differences in class (format)
