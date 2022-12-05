
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dfdiffs

<!-- badges: start -->
<!-- badges: end -->

The goal of `dfdiffs` is to is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

The `dfdiffs` package and application wouldn’t be possible without the
previous work from the authors of the
[`arsenal`](https://mayoverse.github.io/arsenal/reference/arsenal.html)
and [`diffdf`](https://gowerc.github.io/diffdf/) packages.

You can access a development version of the application
[here.](https://mjfrigaard.shinyapps.io/compareDataApp/)

## Installation

You can install the development version of dfdiffs from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mjfrigaard/dfdiffs")
```

``` r
library(dfdiffs)
```

## Packages

Dependencies

``` r
library(dplyr)
library(stringr)
library(forcats)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(vroom)
library(haven)
library(readxl)
library(janitor) 
library(arsenal) 
library(diffdf)  
library(gt)
library(labelled)
library(gtsummary)
```

## Package functions

We have functions for answering each of the questions posed above. Each
function has a pair of datasets to demonstrate how they work (which
we’ll cover below).

## *What rows are here now that weren’t here before?*

To check new data, we’re going to use `T1Data` and `T2Data`.

``` r
T1Data <- dfdiffs::T1Data
T2Data <- dfdiffs::T2Data
NewData <- dfdiffs::NewData
```

### Timepoint 1 data (original)

These data represent data taken at T1.

``` r
T1Data |> gt::gt()
```

<div id="sjyxtbzucl" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#sjyxtbzucl .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#sjyxtbzucl .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#sjyxtbzucl .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#sjyxtbzucl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#sjyxtbzucl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#sjyxtbzucl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#sjyxtbzucl .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#sjyxtbzucl .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#sjyxtbzucl .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#sjyxtbzucl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#sjyxtbzucl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#sjyxtbzucl .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#sjyxtbzucl .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#sjyxtbzucl .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#sjyxtbzucl .gt_from_md > :first-child {
  margin-top: 0;
}

#sjyxtbzucl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#sjyxtbzucl .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#sjyxtbzucl .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#sjyxtbzucl .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#sjyxtbzucl .gt_row_group_first td {
  border-top-width: 2px;
}

#sjyxtbzucl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#sjyxtbzucl .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#sjyxtbzucl .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#sjyxtbzucl .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#sjyxtbzucl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#sjyxtbzucl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#sjyxtbzucl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#sjyxtbzucl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#sjyxtbzucl .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#sjyxtbzucl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#sjyxtbzucl .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#sjyxtbzucl .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#sjyxtbzucl .gt_left {
  text-align: left;
}

#sjyxtbzucl .gt_center {
  text-align: center;
}

#sjyxtbzucl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#sjyxtbzucl .gt_font_normal {
  font-weight: normal;
}

#sjyxtbzucl .gt_font_bold {
  font-weight: bold;
}

#sjyxtbzucl .gt_font_italic {
  font-style: italic;
}

#sjyxtbzucl .gt_super {
  font-size: 65%;
}

#sjyxtbzucl .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#sjyxtbzucl .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#sjyxtbzucl .gt_indent_1 {
  text-indent: 5px;
}

#sjyxtbzucl .gt_indent_2 {
  text-indent: 10px;
}

#sjyxtbzucl .gt_indent_3 {
  text-indent: 15px;
}

#sjyxtbzucl .gt_indent_4 {
  text-indent: 20px;
}

#sjyxtbzucl .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2022-01-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-20</td>
<td headers="end_date" class="gt_row gt_right">2022-03-30</td>
<td headers="text_var" class="gt_row gt_left">The birch canoe slid on the smooth planks.</td>
<td headers="factor_var" class="gt_row gt_left">food</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2022-01-25</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-15</td>
<td headers="end_date" class="gt_row gt_right">2022-03-29</td>
<td headers="text_var" class="gt_row gt_left">Glue the sheet to the dark blue background.</td>
<td headers="factor_var" class="gt_row gt_left">most</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="start_date" class="gt_row gt_right">2022-01-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-19</td>
<td headers="end_date" class="gt_row gt_right">2022-03-25</td>
<td headers="text_var" class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td headers="factor_var" class="gt_row gt_left">park</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">4</td>
<td headers="start_date" class="gt_row gt_right">2022-01-29</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-18</td>
<td headers="end_date" class="gt_row gt_right">2022-03-27</td>
<td headers="text_var" class="gt_row gt_left">These days a chicken leg is a rare dish.</td>
<td headers="factor_var" class="gt_row gt_left">between</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">5</td>
<td headers="start_date" class="gt_row gt_right">2022-01-30</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-16</td>
<td headers="end_date" class="gt_row gt_right">2022-03-26</td>
<td headers="text_var" class="gt_row gt_left">Rice is often served in round bowls.</td>
<td headers="factor_var" class="gt_row gt_left">regard</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">6</td>
<td headers="start_date" class="gt_row gt_right">2022-01-27</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-17</td>
<td headers="end_date" class="gt_row gt_right">2022-03-31</td>
<td headers="text_var" class="gt_row gt_left">The juice of lemons makes fine punch.</td>
<td headers="factor_var" class="gt_row gt_left">law</td></tr>
  </tbody>
  
  
</table>
</div>

### Timepoint 2 data (new)

This is a ‘new’ dataset representing T2.

``` r
T2Data |> gt::gt()
```

<div id="juhpvvlpvu" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#juhpvvlpvu .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#juhpvvlpvu .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#juhpvvlpvu .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#juhpvvlpvu .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#juhpvvlpvu .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#juhpvvlpvu .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#juhpvvlpvu .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#juhpvvlpvu .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#juhpvvlpvu .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#juhpvvlpvu .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#juhpvvlpvu .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#juhpvvlpvu .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#juhpvvlpvu .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#juhpvvlpvu .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#juhpvvlpvu .gt_from_md > :first-child {
  margin-top: 0;
}

#juhpvvlpvu .gt_from_md > :last-child {
  margin-bottom: 0;
}

#juhpvvlpvu .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#juhpvvlpvu .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#juhpvvlpvu .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#juhpvvlpvu .gt_row_group_first td {
  border-top-width: 2px;
}

#juhpvvlpvu .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#juhpvvlpvu .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#juhpvvlpvu .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#juhpvvlpvu .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#juhpvvlpvu .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#juhpvvlpvu .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#juhpvvlpvu .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#juhpvvlpvu .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#juhpvvlpvu .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#juhpvvlpvu .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#juhpvvlpvu .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#juhpvvlpvu .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#juhpvvlpvu .gt_left {
  text-align: left;
}

#juhpvvlpvu .gt_center {
  text-align: center;
}

#juhpvvlpvu .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#juhpvvlpvu .gt_font_normal {
  font-weight: normal;
}

#juhpvvlpvu .gt_font_bold {
  font-weight: bold;
}

#juhpvvlpvu .gt_font_italic {
  font-style: italic;
}

#juhpvvlpvu .gt_super {
  font-size: 65%;
}

#juhpvvlpvu .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#juhpvvlpvu .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#juhpvvlpvu .gt_indent_1 {
  text-indent: 5px;
}

#juhpvvlpvu .gt_indent_2 {
  text-indent: 10px;
}

#juhpvvlpvu .gt_indent_3 {
  text-indent: 15px;
}

#juhpvvlpvu .gt_indent_4 {
  text-indent: 20px;
}

#juhpvvlpvu .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">5</td>
<td headers="start_date" class="gt_row gt_right">2022-01-30</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-16</td>
<td headers="end_date" class="gt_row gt_right">2022-03-26</td>
<td headers="text_var" class="gt_row gt_left">Rice is often served in round bowls.</td>
<td headers="factor_var" class="gt_row gt_left">regard</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">6</td>
<td headers="start_date" class="gt_row gt_right">2022-01-27</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-17</td>
<td headers="end_date" class="gt_row gt_right">2022-03-31</td>
<td headers="text_var" class="gt_row gt_left">The juice of lemons makes fine punch.</td>
<td headers="factor_var" class="gt_row gt_left">law</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">5</td>
<td headers="start_date" class="gt_row gt_right">2022-04-04</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-13</td>
<td headers="end_date" class="gt_row gt_right">2022-04-22</td>
<td headers="text_var" class="gt_row gt_left">Four hours of steady work faced us.</td>
<td headers="factor_var" class="gt_row gt_left">associate</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">4</td>
<td headers="start_date" class="gt_row gt_right">2022-01-29</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-18</td>
<td headers="end_date" class="gt_row gt_right">2022-03-27</td>
<td headers="text_var" class="gt_row gt_left">These days a chicken leg is a rare dish.</td>
<td headers="factor_var" class="gt_row gt_left">between</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="start_date" class="gt_row gt_right">2022-01-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-19</td>
<td headers="end_date" class="gt_row gt_right">2022-03-25</td>
<td headers="text_var" class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td headers="factor_var" class="gt_row gt_left">park</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">4</td>
<td headers="start_date" class="gt_row gt_right">2022-04-02</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-14</td>
<td headers="end_date" class="gt_row gt_right">2022-04-20</td>
<td headers="text_var" class="gt_row gt_left">The hogs were fed chopped corn and garbage.</td>
<td headers="factor_var" class="gt_row gt_left">encourage</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2022-01-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-20</td>
<td headers="end_date" class="gt_row gt_right">2022-03-30</td>
<td headers="text_var" class="gt_row gt_left">The birch canoe slid on the smooth planks.</td>
<td headers="factor_var" class="gt_row gt_left">food</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2022-01-25</td>
<td headers="mid_date" class="gt_row gt_right">2022-03-15</td>
<td headers="end_date" class="gt_row gt_right">2022-03-29</td>
<td headers="text_var" class="gt_row gt_left">Glue the sheet to the dark blue background.</td>
<td headers="factor_var" class="gt_row gt_left">most</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2022-04-04</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-15</td>
<td headers="end_date" class="gt_row gt_right">2022-04-21</td>
<td headers="text_var" class="gt_row gt_left">The box was thrown beside the parked truck.</td>
<td headers="factor_var" class="gt_row gt_left">pension</td></tr>
  </tbody>
  
  
</table>
</div>

### `create_new_data()`

The `create_new_data()` function shows us the ‘new data’ (i.e. what is
here now that wasn’t here before?)

``` r
create_new_data(
  compare = T2Data, 
  base = T1Data) |> 
  gt::gt()
```

<div id="ivavvpbasx" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ivavvpbasx .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ivavvpbasx .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ivavvpbasx .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ivavvpbasx .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ivavvpbasx .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ivavvpbasx .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ivavvpbasx .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ivavvpbasx .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ivavvpbasx .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ivavvpbasx .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ivavvpbasx .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ivavvpbasx .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ivavvpbasx .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ivavvpbasx .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ivavvpbasx .gt_from_md > :first-child {
  margin-top: 0;
}

#ivavvpbasx .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ivavvpbasx .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ivavvpbasx .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ivavvpbasx .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ivavvpbasx .gt_row_group_first td {
  border-top-width: 2px;
}

#ivavvpbasx .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ivavvpbasx .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ivavvpbasx .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ivavvpbasx .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ivavvpbasx .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ivavvpbasx .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ivavvpbasx .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ivavvpbasx .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ivavvpbasx .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ivavvpbasx .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ivavvpbasx .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ivavvpbasx .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ivavvpbasx .gt_left {
  text-align: left;
}

#ivavvpbasx .gt_center {
  text-align: center;
}

#ivavvpbasx .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ivavvpbasx .gt_font_normal {
  font-weight: normal;
}

#ivavvpbasx .gt_font_bold {
  font-weight: bold;
}

#ivavvpbasx .gt_font_italic {
  font-style: italic;
}

#ivavvpbasx .gt_super {
  font-size: 65%;
}

#ivavvpbasx .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#ivavvpbasx .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ivavvpbasx .gt_indent_1 {
  text-indent: 5px;
}

#ivavvpbasx .gt_indent_2 {
  text-indent: 10px;
}

#ivavvpbasx .gt_indent_3 {
  text-indent: 15px;
}

#ivavvpbasx .gt_indent_4 {
  text-indent: 20px;
}

#ivavvpbasx .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">5</td>
<td headers="start_date" class="gt_row gt_right">2022-04-04</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-13</td>
<td headers="end_date" class="gt_row gt_right">2022-04-22</td>
<td headers="text_var" class="gt_row gt_left">Four hours of steady work faced us.</td>
<td headers="factor_var" class="gt_row gt_left">associate</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">4</td>
<td headers="start_date" class="gt_row gt_right">2022-04-02</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-14</td>
<td headers="end_date" class="gt_row gt_right">2022-04-20</td>
<td headers="text_var" class="gt_row gt_left">The hogs were fed chopped corn and garbage.</td>
<td headers="factor_var" class="gt_row gt_left">encourage</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2022-04-04</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-15</td>
<td headers="end_date" class="gt_row gt_right">2022-04-21</td>
<td headers="text_var" class="gt_row gt_left">The box was thrown beside the parked truck.</td>
<td headers="factor_var" class="gt_row gt_left">pension</td></tr>
  </tbody>
  
  
</table>
</div>

We can check this against the `NewData` dataset (which should match the
output from `create_new_data()`)

``` r
NewData |> gt::gt()
```

<div id="ufxxgvglfo" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ufxxgvglfo .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ufxxgvglfo .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ufxxgvglfo .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ufxxgvglfo .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ufxxgvglfo .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ufxxgvglfo .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ufxxgvglfo .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ufxxgvglfo .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ufxxgvglfo .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ufxxgvglfo .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ufxxgvglfo .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ufxxgvglfo .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ufxxgvglfo .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ufxxgvglfo .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ufxxgvglfo .gt_from_md > :first-child {
  margin-top: 0;
}

#ufxxgvglfo .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ufxxgvglfo .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ufxxgvglfo .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ufxxgvglfo .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ufxxgvglfo .gt_row_group_first td {
  border-top-width: 2px;
}

#ufxxgvglfo .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ufxxgvglfo .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ufxxgvglfo .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ufxxgvglfo .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ufxxgvglfo .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ufxxgvglfo .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ufxxgvglfo .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ufxxgvglfo .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ufxxgvglfo .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ufxxgvglfo .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ufxxgvglfo .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ufxxgvglfo .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ufxxgvglfo .gt_left {
  text-align: left;
}

#ufxxgvglfo .gt_center {
  text-align: center;
}

#ufxxgvglfo .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ufxxgvglfo .gt_font_normal {
  font-weight: normal;
}

#ufxxgvglfo .gt_font_bold {
  font-weight: bold;
}

#ufxxgvglfo .gt_font_italic {
  font-style: italic;
}

#ufxxgvglfo .gt_super {
  font-size: 65%;
}

#ufxxgvglfo .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#ufxxgvglfo .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ufxxgvglfo .gt_indent_1 {
  text-indent: 5px;
}

#ufxxgvglfo .gt_indent_2 {
  text-indent: 10px;
}

#ufxxgvglfo .gt_indent_3 {
  text-indent: 15px;
}

#ufxxgvglfo .gt_indent_4 {
  text-indent: 20px;
}

#ufxxgvglfo .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">5</td>
<td headers="start_date" class="gt_row gt_right">2022-04-04</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-13</td>
<td headers="end_date" class="gt_row gt_right">2022-04-22</td>
<td headers="text_var" class="gt_row gt_left">Four hours of steady work faced us.</td>
<td headers="factor_var" class="gt_row gt_left">associate</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">4</td>
<td headers="start_date" class="gt_row gt_right">2022-04-02</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-14</td>
<td headers="end_date" class="gt_row gt_right">2022-04-20</td>
<td headers="text_var" class="gt_row gt_left">The hogs were fed chopped corn and garbage.</td>
<td headers="factor_var" class="gt_row gt_left">encourage</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2022-04-04</td>
<td headers="mid_date" class="gt_row gt_right">2022-04-15</td>
<td headers="end_date" class="gt_row gt_right">2022-04-21</td>
<td headers="text_var" class="gt_row gt_left">The box was thrown beside the parked truck.</td>
<td headers="factor_var" class="gt_row gt_left">pension</td></tr>
  </tbody>
  
  
</table>
</div>

## *What rows were here before that aren’t here now?*

To test for the deleted data, we use the `CompleteData`,
`IncompleteData`, and check these with `DeletedData`.

``` r
CompleteData <- dfdiffs::CompleteData
IncompleteData <- dfdiffs::IncompleteData
DeletedData <- dfdiffs::DeletedData
```

### A complete dataset

`CompleteData` represents a ‘complete’ set of data.

``` r
CompleteData |> gt::gt()
```

<div id="hmgtsdlhgg" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#hmgtsdlhgg .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#hmgtsdlhgg .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hmgtsdlhgg .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#hmgtsdlhgg .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hmgtsdlhgg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hmgtsdlhgg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hmgtsdlhgg .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hmgtsdlhgg .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hmgtsdlhgg .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hmgtsdlhgg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hmgtsdlhgg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hmgtsdlhgg .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hmgtsdlhgg .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#hmgtsdlhgg .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#hmgtsdlhgg .gt_from_md > :first-child {
  margin-top: 0;
}

#hmgtsdlhgg .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hmgtsdlhgg .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hmgtsdlhgg .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#hmgtsdlhgg .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#hmgtsdlhgg .gt_row_group_first td {
  border-top-width: 2px;
}

#hmgtsdlhgg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hmgtsdlhgg .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#hmgtsdlhgg .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#hmgtsdlhgg .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hmgtsdlhgg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hmgtsdlhgg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hmgtsdlhgg .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#hmgtsdlhgg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hmgtsdlhgg .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hmgtsdlhgg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hmgtsdlhgg .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hmgtsdlhgg .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hmgtsdlhgg .gt_left {
  text-align: left;
}

#hmgtsdlhgg .gt_center {
  text-align: center;
}

#hmgtsdlhgg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hmgtsdlhgg .gt_font_normal {
  font-weight: normal;
}

#hmgtsdlhgg .gt_font_bold {
  font-weight: bold;
}

#hmgtsdlhgg .gt_font_italic {
  font-style: italic;
}

#hmgtsdlhgg .gt_super {
  font-size: 65%;
}

#hmgtsdlhgg .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#hmgtsdlhgg .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#hmgtsdlhgg .gt_indent_1 {
  text-indent: 5px;
}

#hmgtsdlhgg .gt_indent_2 {
  text-indent: 10px;
}

#hmgtsdlhgg .gt_indent_3 {
  text-indent: 15px;
}

#hmgtsdlhgg .gt_indent_4 {
  text-indent: 20px;
}

#hmgtsdlhgg .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-27</td>
<td headers="end_date" class="gt_row gt_right">2022-02-26</td>
<td headers="text_var" class="gt_row gt_left">The copper bowl shone in the sun's rays.</td>
<td headers="factor_var" class="gt_row gt_left">interest</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2021-12-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-27</td>
<td headers="end_date" class="gt_row gt_right">2022-02-26</td>
<td headers="text_var" class="gt_row gt_left">Mark the spot with a sign painted red.</td>
<td headers="factor_var" class="gt_row gt_left">state</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-25</td>
<td headers="end_date" class="gt_row gt_right">2022-02-24</td>
<td headers="text_var" class="gt_row gt_left">Take a chance and win a china doll.</td>
<td headers="factor_var" class="gt_row gt_left">sure</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2021-12-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-25</td>
<td headers="end_date" class="gt_row gt_right">2022-02-24</td>
<td headers="text_var" class="gt_row gt_left">A cramp is no small danger on a swim.</td>
<td headers="factor_var" class="gt_row gt_left">white</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-30</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-29</td>
<td headers="end_date" class="gt_row gt_right">2022-02-28</td>
<td headers="text_var" class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td headers="factor_var" class="gt_row gt_left">grant</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-27</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-26</td>
<td headers="end_date" class="gt_row gt_right">2022-02-25</td>
<td headers="text_var" class="gt_row gt_left">The sky that morning was clear and bright blue.</td>
<td headers="factor_var" class="gt_row gt_left">tape</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="start_date" class="gt_row gt_right">2021-12-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-27</td>
<td headers="end_date" class="gt_row gt_right">2022-02-26</td>
<td headers="text_var" class="gt_row gt_left">Wake and rise, and step into the green outdoors.</td>
<td headers="factor_var" class="gt_row gt_left">situate</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="start_date" class="gt_row gt_right">2021-12-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-25</td>
<td headers="end_date" class="gt_row gt_right">2022-02-24</td>
<td headers="text_var" class="gt_row gt_left">A blue crane is a tall wading bird.</td>
<td headers="factor_var" class="gt_row gt_left">shut</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2021-12-27</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-26</td>
<td headers="end_date" class="gt_row gt_right">2022-02-25</td>
<td headers="text_var" class="gt_row gt_left">Say it slow!y but make it ring clear.</td>
<td headers="factor_var" class="gt_row gt_left">document</td></tr>
  </tbody>
  
  
</table>
</div>

### An incomplete dataset

This is a dataset with rows removed from `CompleteData`.

``` r
IncompleteData |> gt::gt()
```

<div id="nmghsoiyzi" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#nmghsoiyzi .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#nmghsoiyzi .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nmghsoiyzi .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#nmghsoiyzi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nmghsoiyzi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nmghsoiyzi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nmghsoiyzi .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nmghsoiyzi .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#nmghsoiyzi .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#nmghsoiyzi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nmghsoiyzi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nmghsoiyzi .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#nmghsoiyzi .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#nmghsoiyzi .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#nmghsoiyzi .gt_from_md > :first-child {
  margin-top: 0;
}

#nmghsoiyzi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nmghsoiyzi .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#nmghsoiyzi .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#nmghsoiyzi .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#nmghsoiyzi .gt_row_group_first td {
  border-top-width: 2px;
}

#nmghsoiyzi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmghsoiyzi .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nmghsoiyzi .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nmghsoiyzi .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nmghsoiyzi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmghsoiyzi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nmghsoiyzi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nmghsoiyzi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nmghsoiyzi .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nmghsoiyzi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmghsoiyzi .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nmghsoiyzi .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmghsoiyzi .gt_left {
  text-align: left;
}

#nmghsoiyzi .gt_center {
  text-align: center;
}

#nmghsoiyzi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nmghsoiyzi .gt_font_normal {
  font-weight: normal;
}

#nmghsoiyzi .gt_font_bold {
  font-weight: bold;
}

#nmghsoiyzi .gt_font_italic {
  font-style: italic;
}

#nmghsoiyzi .gt_super {
  font-size: 65%;
}

#nmghsoiyzi .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#nmghsoiyzi .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nmghsoiyzi .gt_indent_1 {
  text-indent: 5px;
}

#nmghsoiyzi .gt_indent_2 {
  text-indent: 10px;
}

#nmghsoiyzi .gt_indent_3 {
  text-indent: 15px;
}

#nmghsoiyzi .gt_indent_4 {
  text-indent: 20px;
}

#nmghsoiyzi .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-27</td>
<td headers="end_date" class="gt_row gt_right">2022-02-26</td>
<td headers="text_var" class="gt_row gt_left">The copper bowl shone in the sun's rays.</td>
<td headers="factor_var" class="gt_row gt_left">interest</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-25</td>
<td headers="end_date" class="gt_row gt_right">2022-02-24</td>
<td headers="text_var" class="gt_row gt_left">Take a chance and win a china doll.</td>
<td headers="factor_var" class="gt_row gt_left">sure</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2021-12-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-25</td>
<td headers="end_date" class="gt_row gt_right">2022-02-24</td>
<td headers="text_var" class="gt_row gt_left">A cramp is no small danger on a swim.</td>
<td headers="factor_var" class="gt_row gt_left">white</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="start_date" class="gt_row gt_right">2021-12-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-27</td>
<td headers="end_date" class="gt_row gt_right">2022-02-26</td>
<td headers="text_var" class="gt_row gt_left">Wake and rise, and step into the green outdoors.</td>
<td headers="factor_var" class="gt_row gt_left">situate</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2021-12-27</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-26</td>
<td headers="end_date" class="gt_row gt_right">2022-02-25</td>
<td headers="text_var" class="gt_row gt_left">Say it slow!y but make it ring clear.</td>
<td headers="factor_var" class="gt_row gt_left">document</td></tr>
  </tbody>
  
  
</table>
</div>

### `create_deleted_data()`

When we run the `create_deleted_data()`, we check for the deleted rows
between `IncompleteData` and `CompleteData`.

``` r
create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData) |> 
  gt::gt()
```

<div id="cijivkiixy" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#cijivkiixy .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#cijivkiixy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#cijivkiixy .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#cijivkiixy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#cijivkiixy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#cijivkiixy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cijivkiixy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#cijivkiixy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#cijivkiixy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#cijivkiixy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#cijivkiixy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#cijivkiixy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#cijivkiixy .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#cijivkiixy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#cijivkiixy .gt_from_md > :first-child {
  margin-top: 0;
}

#cijivkiixy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#cijivkiixy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#cijivkiixy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#cijivkiixy .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#cijivkiixy .gt_row_group_first td {
  border-top-width: 2px;
}

#cijivkiixy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cijivkiixy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#cijivkiixy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#cijivkiixy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cijivkiixy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cijivkiixy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#cijivkiixy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#cijivkiixy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cijivkiixy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#cijivkiixy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cijivkiixy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#cijivkiixy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cijivkiixy .gt_left {
  text-align: left;
}

#cijivkiixy .gt_center {
  text-align: center;
}

#cijivkiixy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#cijivkiixy .gt_font_normal {
  font-weight: normal;
}

#cijivkiixy .gt_font_bold {
  font-weight: bold;
}

#cijivkiixy .gt_font_italic {
  font-style: italic;
}

#cijivkiixy .gt_super {
  font-size: 65%;
}

#cijivkiixy .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#cijivkiixy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#cijivkiixy .gt_indent_1 {
  text-indent: 5px;
}

#cijivkiixy .gt_indent_2 {
  text-indent: 10px;
}

#cijivkiixy .gt_indent_3 {
  text-indent: 15px;
}

#cijivkiixy .gt_indent_4 {
  text-indent: 20px;
}

#cijivkiixy .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2021-12-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-27</td>
<td headers="end_date" class="gt_row gt_right">2022-02-26</td>
<td headers="text_var" class="gt_row gt_left">Mark the spot with a sign painted red.</td>
<td headers="factor_var" class="gt_row gt_left">state</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-30</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-29</td>
<td headers="end_date" class="gt_row gt_right">2022-02-28</td>
<td headers="text_var" class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td headers="factor_var" class="gt_row gt_left">grant</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-27</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-26</td>
<td headers="end_date" class="gt_row gt_right">2022-02-25</td>
<td headers="text_var" class="gt_row gt_left">The sky that morning was clear and bright blue.</td>
<td headers="factor_var" class="gt_row gt_left">tape</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="start_date" class="gt_row gt_right">2021-12-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-25</td>
<td headers="end_date" class="gt_row gt_right">2022-02-24</td>
<td headers="text_var" class="gt_row gt_left">A blue crane is a tall wading bird.</td>
<td headers="factor_var" class="gt_row gt_left">shut</td></tr>
  </tbody>
  
  
</table>
</div>

### The deleted data

This is identical to the data stored in `DeletedData`

``` r
DeletedData |> gt::gt()
```

<div id="saqbrwfzbz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#saqbrwfzbz .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#saqbrwfzbz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#saqbrwfzbz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#saqbrwfzbz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#saqbrwfzbz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#saqbrwfzbz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#saqbrwfzbz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#saqbrwfzbz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#saqbrwfzbz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#saqbrwfzbz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#saqbrwfzbz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#saqbrwfzbz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#saqbrwfzbz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#saqbrwfzbz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#saqbrwfzbz .gt_from_md > :first-child {
  margin-top: 0;
}

#saqbrwfzbz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#saqbrwfzbz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#saqbrwfzbz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#saqbrwfzbz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#saqbrwfzbz .gt_row_group_first td {
  border-top-width: 2px;
}

#saqbrwfzbz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#saqbrwfzbz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#saqbrwfzbz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#saqbrwfzbz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#saqbrwfzbz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#saqbrwfzbz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#saqbrwfzbz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#saqbrwfzbz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#saqbrwfzbz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#saqbrwfzbz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#saqbrwfzbz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#saqbrwfzbz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#saqbrwfzbz .gt_left {
  text-align: left;
}

#saqbrwfzbz .gt_center {
  text-align: center;
}

#saqbrwfzbz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#saqbrwfzbz .gt_font_normal {
  font-weight: normal;
}

#saqbrwfzbz .gt_font_bold {
  font-weight: bold;
}

#saqbrwfzbz .gt_font_italic {
  font-style: italic;
}

#saqbrwfzbz .gt_super {
  font-size: 65%;
}

#saqbrwfzbz .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#saqbrwfzbz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#saqbrwfzbz .gt_indent_1 {
  text-indent: 5px;
}

#saqbrwfzbz .gt_indent_2 {
  text-indent: 10px;
}

#saqbrwfzbz .gt_indent_3 {
  text-indent: 15px;
}

#saqbrwfzbz .gt_indent_4 {
  text-indent: 20px;
}

#saqbrwfzbz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="start_date">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mid_date">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="end_date">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_var">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="factor_var">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="start_date" class="gt_row gt_right">2021-12-28</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-27</td>
<td headers="end_date" class="gt_row gt_right">2022-02-26</td>
<td headers="text_var" class="gt_row gt_left">Mark the spot with a sign painted red.</td>
<td headers="factor_var" class="gt_row gt_left">state</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="start_date" class="gt_row gt_right">2021-12-26</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-25</td>
<td headers="end_date" class="gt_row gt_right">2022-02-24</td>
<td headers="text_var" class="gt_row gt_left">A blue crane is a tall wading bird.</td>
<td headers="factor_var" class="gt_row gt_left">shut</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-30</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-29</td>
<td headers="end_date" class="gt_row gt_right">2022-02-28</td>
<td headers="text_var" class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td headers="factor_var" class="gt_row gt_left">grant</td></tr>
    <tr><td headers="subject" class="gt_row gt_left">D</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="start_date" class="gt_row gt_right">2021-12-27</td>
<td headers="mid_date" class="gt_row gt_right">2022-01-26</td>
<td headers="end_date" class="gt_row gt_right">2022-02-25</td>
<td headers="text_var" class="gt_row gt_left">The sky that morning was clear and bright blue.</td>
<td headers="factor_var" class="gt_row gt_left">tape</td></tr>
  </tbody>
  
  
</table>
</div>

## *What values have been changed?*

To answer this question, we have two options: `create_changed_data()`
and `create_modified_data()`.

- `create_changed_data()` relies on the `diffdf()` function from the
  [`diffdf`
  package](https://gowerc.github.io/diffdf/reference/diffdf.html)
  package.

- `create_modified_data()` relies on the `comparedf()` function from the
  [`arsenal`
  package](https://mayoverse.github.io/arsenal/reference/comparedf.html)
  package.

To check for changes between two datasets, we use the `InitialData` and
`ChangedData`.

``` r
InitialData <- dfdiffs::InitialData
ChangedData <- dfdiffs::ChangedData
```

### Initial data

``` r
InitialData |> gt::gt()
```

<div id="qigptcmwsr" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#qigptcmwsr .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#qigptcmwsr .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qigptcmwsr .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#qigptcmwsr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qigptcmwsr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qigptcmwsr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qigptcmwsr .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qigptcmwsr .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#qigptcmwsr .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#qigptcmwsr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qigptcmwsr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qigptcmwsr .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#qigptcmwsr .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#qigptcmwsr .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#qigptcmwsr .gt_from_md > :first-child {
  margin-top: 0;
}

#qigptcmwsr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qigptcmwsr .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#qigptcmwsr .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#qigptcmwsr .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#qigptcmwsr .gt_row_group_first td {
  border-top-width: 2px;
}

#qigptcmwsr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qigptcmwsr .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#qigptcmwsr .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#qigptcmwsr .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qigptcmwsr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qigptcmwsr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qigptcmwsr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qigptcmwsr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qigptcmwsr .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qigptcmwsr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qigptcmwsr .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qigptcmwsr .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qigptcmwsr .gt_left {
  text-align: left;
}

#qigptcmwsr .gt_center {
  text-align: center;
}

#qigptcmwsr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qigptcmwsr .gt_font_normal {
  font-weight: normal;
}

#qigptcmwsr .gt_font_bold {
  font-weight: bold;
}

#qigptcmwsr .gt_font_italic {
  font-style: italic;
}

#qigptcmwsr .gt_super {
  font-size: 65%;
}

#qigptcmwsr .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#qigptcmwsr .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#qigptcmwsr .gt_indent_1 {
  text-indent: 5px;
}

#qigptcmwsr .gt_indent_2 {
  text-indent: 10px;
}

#qigptcmwsr .gt_indent_3 {
  text-indent: 15px;
}

#qigptcmwsr .gt_indent_4 {
  text-indent: 20px;
}

#qigptcmwsr .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject_id">subject_id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_value_a">text_value_a</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_value_b">text_value_b</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="created_date">created_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="updated_date">updated_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="entered_date">entered_date</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject_id" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="text_value_a" class="gt_row gt_left">Issue unresolved</td>
<td headers="text_value_b" class="gt_row gt_left">Fatigue</td>
<td headers="created_date" class="gt_row gt_right">2021-07-29</td>
<td headers="updated_date" class="gt_row gt_right">2021-09-29</td>
<td headers="entered_date" class="gt_row gt_right">2021-09-29</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="text_value_a" class="gt_row gt_left">Issue unresolved</td>
<td headers="text_value_b" class="gt_row gt_left">Fatigue</td>
<td headers="created_date" class="gt_row gt_right">2021-07-29</td>
<td headers="updated_date" class="gt_row gt_right">2021-10-03</td>
<td headers="entered_date" class="gt_row gt_right">2021-10-29</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Fever</td>
<td headers="created_date" class="gt_row gt_right">2021-07-16</td>
<td headers="updated_date" class="gt_row gt_right">2021-09-02</td>
<td headers="entered_date" class="gt_row gt_right">2021-08-18</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">4</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Joint pain</td>
<td headers="created_date" class="gt_row gt_right">2021-08-24</td>
<td headers="updated_date" class="gt_row gt_right">2021-10-03</td>
<td headers="entered_date" class="gt_row gt_right">2021-10-03</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">5</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Joint pain</td>
<td headers="created_date" class="gt_row gt_right">2021-08-24</td>
<td headers="updated_date" class="gt_row gt_right">2021-09-20</td>
<td headers="entered_date" class="gt_row gt_right">2021-10-20</td></tr>
  </tbody>
  
  
</table>
</div>

### Changed data

``` r
ChangedData |> gt::gt()
```

<div id="kmczeftlpm" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#kmczeftlpm .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#kmczeftlpm .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kmczeftlpm .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#kmczeftlpm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#kmczeftlpm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#kmczeftlpm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kmczeftlpm .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kmczeftlpm .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#kmczeftlpm .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#kmczeftlpm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#kmczeftlpm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#kmczeftlpm .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#kmczeftlpm .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#kmczeftlpm .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#kmczeftlpm .gt_from_md > :first-child {
  margin-top: 0;
}

#kmczeftlpm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kmczeftlpm .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#kmczeftlpm .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#kmczeftlpm .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#kmczeftlpm .gt_row_group_first td {
  border-top-width: 2px;
}

#kmczeftlpm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kmczeftlpm .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#kmczeftlpm .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#kmczeftlpm .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kmczeftlpm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kmczeftlpm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kmczeftlpm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#kmczeftlpm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kmczeftlpm .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kmczeftlpm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kmczeftlpm .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kmczeftlpm .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kmczeftlpm .gt_left {
  text-align: left;
}

#kmczeftlpm .gt_center {
  text-align: center;
}

#kmczeftlpm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kmczeftlpm .gt_font_normal {
  font-weight: normal;
}

#kmczeftlpm .gt_font_bold {
  font-weight: bold;
}

#kmczeftlpm .gt_font_italic {
  font-style: italic;
}

#kmczeftlpm .gt_super {
  font-size: 65%;
}

#kmczeftlpm .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#kmczeftlpm .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#kmczeftlpm .gt_indent_1 {
  text-indent: 5px;
}

#kmczeftlpm .gt_indent_2 {
  text-indent: 10px;
}

#kmczeftlpm .gt_indent_3 {
  text-indent: 15px;
}

#kmczeftlpm .gt_indent_4 {
  text-indent: 20px;
}

#kmczeftlpm .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="subject_id">subject_id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="record">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_value_a">text_value_a</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="text_value_b">text_value_b</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="created_date">created_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="updated_date">updated_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="entered_date">entered_date</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="subject_id" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">1</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Fatigue</td>
<td headers="created_date" class="gt_row gt_right">2021-07-29</td>
<td headers="updated_date" class="gt_row gt_right">2021-10-03</td>
<td headers="entered_date" class="gt_row gt_right">2021-11-30</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">A</td>
<td headers="record" class="gt_row gt_right">2</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Fatigue</td>
<td headers="created_date" class="gt_row gt_right">2021-07-29</td>
<td headers="updated_date" class="gt_row gt_right">2021-11-27</td>
<td headers="entered_date" class="gt_row gt_right">2021-11-30</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">B</td>
<td headers="record" class="gt_row gt_right">3</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Fever</td>
<td headers="created_date" class="gt_row gt_right">2021-07-16</td>
<td headers="updated_date" class="gt_row gt_right">2021-10-20</td>
<td headers="entered_date" class="gt_row gt_right">2021-11-21</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">4</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Joint pain, stiffness and swelling</td>
<td headers="created_date" class="gt_row gt_right">2021-08-24</td>
<td headers="updated_date" class="gt_row gt_right">2021-10-13</td>
<td headers="entered_date" class="gt_row gt_right">2021-11-11</td></tr>
    <tr><td headers="subject_id" class="gt_row gt_left">C</td>
<td headers="record" class="gt_row gt_right">5</td>
<td headers="text_value_a" class="gt_row gt_left">Issue resolved</td>
<td headers="text_value_b" class="gt_row gt_left">Joint pain</td>
<td headers="created_date" class="gt_row gt_right">2021-08-24</td>
<td headers="updated_date" class="gt_row gt_right">2021-10-14</td>
<td headers="entered_date" class="gt_row gt_right">2021-11-16</td></tr>
  </tbody>
  
  
</table>
</div>

### `create_changed_data()`

`create_changed_data()` creates a list of tables.

``` r
changed <- create_changed_data(
  compare = ChangedData,
  base = InitialData)
names(changed)
#> [1] "num_diffs" "var_diffs"
```

#### Counts of changes (`num_diffs`)

The counts of changes by variable are stored in `num_diffs`.

``` r
changed$num_diffs |> gt::gt()
```

<div id="xbuffytjeu" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#xbuffytjeu .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#xbuffytjeu .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xbuffytjeu .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#xbuffytjeu .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xbuffytjeu .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xbuffytjeu .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbuffytjeu .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xbuffytjeu .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#xbuffytjeu .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#xbuffytjeu .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xbuffytjeu .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xbuffytjeu .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#xbuffytjeu .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#xbuffytjeu .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#xbuffytjeu .gt_from_md > :first-child {
  margin-top: 0;
}

#xbuffytjeu .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xbuffytjeu .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#xbuffytjeu .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#xbuffytjeu .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#xbuffytjeu .gt_row_group_first td {
  border-top-width: 2px;
}

#xbuffytjeu .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbuffytjeu .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#xbuffytjeu .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#xbuffytjeu .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbuffytjeu .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbuffytjeu .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xbuffytjeu .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xbuffytjeu .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbuffytjeu .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xbuffytjeu .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbuffytjeu .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xbuffytjeu .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbuffytjeu .gt_left {
  text-align: left;
}

#xbuffytjeu .gt_center {
  text-align: center;
}

#xbuffytjeu .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xbuffytjeu .gt_font_normal {
  font-weight: normal;
}

#xbuffytjeu .gt_font_bold {
  font-weight: bold;
}

#xbuffytjeu .gt_font_italic {
  font-style: italic;
}

#xbuffytjeu .gt_super {
  font-size: 65%;
}

#xbuffytjeu .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#xbuffytjeu .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#xbuffytjeu .gt_indent_1 {
  text-indent: 5px;
}

#xbuffytjeu .gt_indent_2 {
  text-indent: 10px;
}

#xbuffytjeu .gt_indent_3 {
  text-indent: 15px;
}

#xbuffytjeu .gt_indent_4 {
  text-indent: 20px;
}

#xbuffytjeu .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="variable">variable</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="no_of_differences">no_of_differences</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="variable" class="gt_row gt_left">text_value_a</td>
<td headers="no_of_differences" class="gt_row gt_right">2</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">text_value_b</td>
<td headers="no_of_differences" class="gt_row gt_right">1</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">updated_date</td>
<td headers="no_of_differences" class="gt_row gt_right">5</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">entered_date</td>
<td headers="no_of_differences" class="gt_row gt_right">5</td></tr>
  </tbody>
  
  
</table>
</div>

#### Changes by row (`var_diffs`)

The changes by row are stored in `var_diffs`.

``` r
changed$var_diffs |> gt::gt()
```

<div id="otqtuvqzek" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#otqtuvqzek .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#otqtuvqzek .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#otqtuvqzek .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#otqtuvqzek .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#otqtuvqzek .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#otqtuvqzek .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#otqtuvqzek .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#otqtuvqzek .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#otqtuvqzek .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#otqtuvqzek .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#otqtuvqzek .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#otqtuvqzek .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#otqtuvqzek .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#otqtuvqzek .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#otqtuvqzek .gt_from_md > :first-child {
  margin-top: 0;
}

#otqtuvqzek .gt_from_md > :last-child {
  margin-bottom: 0;
}

#otqtuvqzek .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#otqtuvqzek .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#otqtuvqzek .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#otqtuvqzek .gt_row_group_first td {
  border-top-width: 2px;
}

#otqtuvqzek .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#otqtuvqzek .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#otqtuvqzek .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#otqtuvqzek .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#otqtuvqzek .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#otqtuvqzek .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#otqtuvqzek .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#otqtuvqzek .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#otqtuvqzek .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#otqtuvqzek .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#otqtuvqzek .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#otqtuvqzek .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#otqtuvqzek .gt_left {
  text-align: left;
}

#otqtuvqzek .gt_center {
  text-align: center;
}

#otqtuvqzek .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#otqtuvqzek .gt_font_normal {
  font-weight: normal;
}

#otqtuvqzek .gt_font_bold {
  font-weight: bold;
}

#otqtuvqzek .gt_font_italic {
  font-style: italic;
}

#otqtuvqzek .gt_super {
  font-size: 65%;
}

#otqtuvqzek .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#otqtuvqzek .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#otqtuvqzek .gt_indent_1 {
  text-indent: 5px;
}

#otqtuvqzek .gt_indent_2 {
  text-indent: 10px;
}

#otqtuvqzek .gt_indent_3 {
  text-indent: 15px;
}

#otqtuvqzek .gt_indent_4 {
  text-indent: 20px;
}

#otqtuvqzek .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="variable">variable</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="rownumber">rownumber</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="base">base</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="compare">compare</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="variable" class="gt_row gt_left">text_value_a</td>
<td headers="rownumber" class="gt_row gt_right">1</td>
<td headers="base" class="gt_row gt_left">Issue unresolved</td>
<td headers="compare" class="gt_row gt_left">Issue resolved</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">text_value_a</td>
<td headers="rownumber" class="gt_row gt_right">2</td>
<td headers="base" class="gt_row gt_left">Issue unresolved</td>
<td headers="compare" class="gt_row gt_left">Issue resolved</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">text_value_b</td>
<td headers="rownumber" class="gt_row gt_right">4</td>
<td headers="base" class="gt_row gt_left">Joint pain</td>
<td headers="compare" class="gt_row gt_left">Joint pain, stiffness and swelling</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">updated_date</td>
<td headers="rownumber" class="gt_row gt_right">1</td>
<td headers="base" class="gt_row gt_left">2021-09-29</td>
<td headers="compare" class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">updated_date</td>
<td headers="rownumber" class="gt_row gt_right">2</td>
<td headers="base" class="gt_row gt_left">2021-10-03</td>
<td headers="compare" class="gt_row gt_left">2021-11-27</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">updated_date</td>
<td headers="rownumber" class="gt_row gt_right">3</td>
<td headers="base" class="gt_row gt_left">2021-09-02</td>
<td headers="compare" class="gt_row gt_left">2021-10-20</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">updated_date</td>
<td headers="rownumber" class="gt_row gt_right">4</td>
<td headers="base" class="gt_row gt_left">2021-10-03</td>
<td headers="compare" class="gt_row gt_left">2021-10-13</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">updated_date</td>
<td headers="rownumber" class="gt_row gt_right">5</td>
<td headers="base" class="gt_row gt_left">2021-09-20</td>
<td headers="compare" class="gt_row gt_left">2021-10-14</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">entered_date</td>
<td headers="rownumber" class="gt_row gt_right">1</td>
<td headers="base" class="gt_row gt_left">2021-09-29</td>
<td headers="compare" class="gt_row gt_left">2021-11-30</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">entered_date</td>
<td headers="rownumber" class="gt_row gt_right">2</td>
<td headers="base" class="gt_row gt_left">2021-10-29</td>
<td headers="compare" class="gt_row gt_left">2021-11-30</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">entered_date</td>
<td headers="rownumber" class="gt_row gt_right">3</td>
<td headers="base" class="gt_row gt_left">2021-08-18</td>
<td headers="compare" class="gt_row gt_left">2021-11-21</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">entered_date</td>
<td headers="rownumber" class="gt_row gt_right">4</td>
<td headers="base" class="gt_row gt_left">2021-10-03</td>
<td headers="compare" class="gt_row gt_left">2021-11-11</td></tr>
    <tr><td headers="variable" class="gt_row gt_left">entered_date</td>
<td headers="rownumber" class="gt_row gt_right">5</td>
<td headers="base" class="gt_row gt_left">2021-10-20</td>
<td headers="compare" class="gt_row gt_left">2021-11-16</td></tr>
  </tbody>
  
  
</table>
</div>

### `create_modified_data()`

The `create_modified_data()` function also creates a list of tables.

``` r
modified <- create_modified_data(
  compare = ChangedData,
  base = InitialData)
names(modified)
#> [1] "diffs"       "diffs_byvar"
```

#### Counts of changes (`diffs_byvar`)

The counts of changes by variable are stored in `diffs_byvar`.

``` r
modified$diffs_byvar |> gt::gt()
```

<div id="xbvtqcjath" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#xbvtqcjath .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#xbvtqcjath .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xbvtqcjath .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#xbvtqcjath .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xbvtqcjath .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xbvtqcjath .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbvtqcjath .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#xbvtqcjath .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#xbvtqcjath .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#xbvtqcjath .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xbvtqcjath .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xbvtqcjath .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#xbvtqcjath .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#xbvtqcjath .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#xbvtqcjath .gt_from_md > :first-child {
  margin-top: 0;
}

#xbvtqcjath .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xbvtqcjath .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#xbvtqcjath .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#xbvtqcjath .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#xbvtqcjath .gt_row_group_first td {
  border-top-width: 2px;
}

#xbvtqcjath .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbvtqcjath .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#xbvtqcjath .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#xbvtqcjath .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbvtqcjath .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbvtqcjath .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xbvtqcjath .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xbvtqcjath .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbvtqcjath .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xbvtqcjath .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbvtqcjath .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#xbvtqcjath .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbvtqcjath .gt_left {
  text-align: left;
}

#xbvtqcjath .gt_center {
  text-align: center;
}

#xbvtqcjath .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xbvtqcjath .gt_font_normal {
  font-weight: normal;
}

#xbvtqcjath .gt_font_bold {
  font-weight: bold;
}

#xbvtqcjath .gt_font_italic {
  font-style: italic;
}

#xbvtqcjath .gt_super {
  font-size: 65%;
}

#xbvtqcjath .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#xbvtqcjath .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#xbvtqcjath .gt_indent_1 {
  text-indent: 5px;
}

#xbvtqcjath .gt_indent_2 {
  text-indent: 10px;
}

#xbvtqcjath .gt_indent_3 {
  text-indent: 15px;
}

#xbvtqcjath .gt_indent_4 {
  text-indent: 20px;
}

#xbvtqcjath .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Variable name">Variable name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Modified Values">Modified Values</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Missing Values">Missing Values</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Variable name" class="gt_row gt_left">subject_id</td>
<td headers="Modified Values" class="gt_row gt_right">0</td>
<td headers="Missing Values" class="gt_row gt_right">0</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">record</td>
<td headers="Modified Values" class="gt_row gt_right">0</td>
<td headers="Missing Values" class="gt_row gt_right">0</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">text_value_a</td>
<td headers="Modified Values" class="gt_row gt_right">2</td>
<td headers="Missing Values" class="gt_row gt_right">0</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">text_value_b</td>
<td headers="Modified Values" class="gt_row gt_right">1</td>
<td headers="Missing Values" class="gt_row gt_right">0</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">created_date</td>
<td headers="Modified Values" class="gt_row gt_right">0</td>
<td headers="Missing Values" class="gt_row gt_right">0</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">updated_date</td>
<td headers="Modified Values" class="gt_row gt_right">5</td>
<td headers="Missing Values" class="gt_row gt_right">0</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">entered_date</td>
<td headers="Modified Values" class="gt_row gt_right">5</td>
<td headers="Missing Values" class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>

#### Changes by row

The changes by row are stored in `diffs`.

``` r
modified$diffs |> gt::gt()
```

<div id="heqwuyqajy" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#heqwuyqajy .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#heqwuyqajy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#heqwuyqajy .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#heqwuyqajy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#heqwuyqajy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#heqwuyqajy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#heqwuyqajy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#heqwuyqajy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#heqwuyqajy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#heqwuyqajy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#heqwuyqajy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#heqwuyqajy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#heqwuyqajy .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#heqwuyqajy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#heqwuyqajy .gt_from_md > :first-child {
  margin-top: 0;
}

#heqwuyqajy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#heqwuyqajy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#heqwuyqajy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#heqwuyqajy .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#heqwuyqajy .gt_row_group_first td {
  border-top-width: 2px;
}

#heqwuyqajy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#heqwuyqajy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#heqwuyqajy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#heqwuyqajy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#heqwuyqajy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#heqwuyqajy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#heqwuyqajy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#heqwuyqajy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#heqwuyqajy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#heqwuyqajy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#heqwuyqajy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#heqwuyqajy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#heqwuyqajy .gt_left {
  text-align: left;
}

#heqwuyqajy .gt_center {
  text-align: center;
}

#heqwuyqajy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#heqwuyqajy .gt_font_normal {
  font-weight: normal;
}

#heqwuyqajy .gt_font_bold {
  font-weight: bold;
}

#heqwuyqajy .gt_font_italic {
  font-style: italic;
}

#heqwuyqajy .gt_super {
  font-size: 65%;
}

#heqwuyqajy .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#heqwuyqajy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#heqwuyqajy .gt_indent_1 {
  text-indent: 5px;
}

#heqwuyqajy .gt_indent_2 {
  text-indent: 10px;
}

#heqwuyqajy .gt_indent_3 {
  text-indent: 15px;
}

#heqwuyqajy .gt_indent_4 {
  text-indent: 20px;
}

#heqwuyqajy .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Variable name">Variable name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Current Value">Current Value</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Previous Value">Previous Value</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Variable name" class="gt_row gt_left">text_value_a</td>
<td headers="Current Value" class="gt_row gt_left">Issue resolved</td>
<td headers="Previous Value" class="gt_row gt_left">Issue unresolved</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">text_value_a</td>
<td headers="Current Value" class="gt_row gt_left">Issue resolved</td>
<td headers="Previous Value" class="gt_row gt_left">Issue unresolved</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">text_value_b</td>
<td headers="Current Value" class="gt_row gt_left">Joint pain, stiffness and swelling</td>
<td headers="Previous Value" class="gt_row gt_left">Joint pain</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">updated_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-10-03</td>
<td headers="Previous Value" class="gt_row gt_left">2021-09-29</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">updated_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-11-27</td>
<td headers="Previous Value" class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">updated_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-10-20</td>
<td headers="Previous Value" class="gt_row gt_left">2021-09-02</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">updated_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-10-13</td>
<td headers="Previous Value" class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">updated_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-10-14</td>
<td headers="Previous Value" class="gt_row gt_left">2021-09-20</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">entered_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-11-30</td>
<td headers="Previous Value" class="gt_row gt_left">2021-09-29</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">entered_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-11-30</td>
<td headers="Previous Value" class="gt_row gt_left">2021-10-29</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">entered_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-11-21</td>
<td headers="Previous Value" class="gt_row gt_left">2021-08-18</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">entered_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-11-11</td>
<td headers="Previous Value" class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td headers="Variable name" class="gt_row gt_left">entered_date</td>
<td headers="Current Value" class="gt_row gt_left">2021-11-16</td>
<td headers="Previous Value" class="gt_row gt_left">2021-10-20</td></tr>
  </tbody>
  
  
</table>
</div>
