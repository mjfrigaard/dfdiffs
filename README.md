
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dfdiffs

<!-- badges: start -->
<!-- badges: end -->

The goal of `dfdiffs` is to is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

You can access a development version of the application
[here.](https://mjfrigaard.shinyapps.io/compareDataApp/)

## Installation

You can install the development version of dfdiffs from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mjfrigaard/dfdiffs")
```

## Packages

Dependencies

``` r
library(dfdiffs)
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

<div id="ncpouckods" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ncpouckods .gt_table {
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

#ncpouckods .gt_heading {
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

#ncpouckods .gt_title {
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

#ncpouckods .gt_subtitle {
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

#ncpouckods .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ncpouckods .gt_col_headings {
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

#ncpouckods .gt_col_heading {
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

#ncpouckods .gt_column_spanner_outer {
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

#ncpouckods .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ncpouckods .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ncpouckods .gt_column_spanner {
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

#ncpouckods .gt_group_heading {
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
}

#ncpouckods .gt_empty_group_heading {
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

#ncpouckods .gt_from_md > :first-child {
  margin-top: 0;
}

#ncpouckods .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ncpouckods .gt_row {
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

#ncpouckods .gt_stub {
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

#ncpouckods .gt_stub_row_group {
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

#ncpouckods .gt_row_group_first td {
  border-top-width: 2px;
}

#ncpouckods .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ncpouckods .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ncpouckods .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ncpouckods .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ncpouckods .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ncpouckods .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ncpouckods .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ncpouckods .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ncpouckods .gt_footnotes {
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

#ncpouckods .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ncpouckods .gt_sourcenotes {
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

#ncpouckods .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ncpouckods .gt_left {
  text-align: left;
}

#ncpouckods .gt_center {
  text-align: center;
}

#ncpouckods .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ncpouckods .gt_font_normal {
  font-weight: normal;
}

#ncpouckods .gt_font_bold {
  font-weight: bold;
}

#ncpouckods .gt_font_italic {
  font-style: italic;
}

#ncpouckods .gt_super {
  font-size: 65%;
}

#ncpouckods .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#ncpouckods .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ncpouckods .gt_indent_1 {
  text-indent: 5px;
}

#ncpouckods .gt_indent_2 {
  text-indent: 10px;
}

#ncpouckods .gt_indent_3 {
  text-indent: 15px;
}

#ncpouckods .gt_indent_4 {
  text-indent: 20px;
}

#ncpouckods .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2022-01-28</td>
<td class="gt_row gt_right">2022-03-20</td>
<td class="gt_row gt_right">2022-03-30</td>
<td class="gt_row gt_left">The birch canoe slid on the smooth planks.</td>
<td class="gt_row gt_left">food</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-03-15</td>
<td class="gt_row gt_right">2022-03-29</td>
<td class="gt_row gt_left">Glue the sheet to the dark blue background.</td>
<td class="gt_row gt_left">most</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_right">2022-01-26</td>
<td class="gt_row gt_right">2022-03-19</td>
<td class="gt_row gt_right">2022-03-25</td>
<td class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td class="gt_row gt_left">park</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">2022-01-29</td>
<td class="gt_row gt_right">2022-03-18</td>
<td class="gt_row gt_right">2022-03-27</td>
<td class="gt_row gt_left">These days a chicken leg is a rare dish.</td>
<td class="gt_row gt_left">between</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_right">2022-01-30</td>
<td class="gt_row gt_right">2022-03-16</td>
<td class="gt_row gt_right">2022-03-26</td>
<td class="gt_row gt_left">Rice is often served in round bowls.</td>
<td class="gt_row gt_left">regard</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">6</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-03-17</td>
<td class="gt_row gt_right">2022-03-31</td>
<td class="gt_row gt_left">The juice of lemons makes fine punch.</td>
<td class="gt_row gt_left">law</td></tr>
  </tbody>
  
  
</table>
</div>

### Timepoint 2 data (new)

This is a ‘new’ dataset representing T2.

``` r
T2Data |> gt::gt()
```

<div id="lmixnpaikv" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#lmixnpaikv .gt_table {
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

#lmixnpaikv .gt_heading {
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

#lmixnpaikv .gt_title {
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

#lmixnpaikv .gt_subtitle {
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

#lmixnpaikv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lmixnpaikv .gt_col_headings {
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

#lmixnpaikv .gt_col_heading {
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

#lmixnpaikv .gt_column_spanner_outer {
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

#lmixnpaikv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#lmixnpaikv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#lmixnpaikv .gt_column_spanner {
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

#lmixnpaikv .gt_group_heading {
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
}

#lmixnpaikv .gt_empty_group_heading {
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

#lmixnpaikv .gt_from_md > :first-child {
  margin-top: 0;
}

#lmixnpaikv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#lmixnpaikv .gt_row {
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

#lmixnpaikv .gt_stub {
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

#lmixnpaikv .gt_stub_row_group {
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

#lmixnpaikv .gt_row_group_first td {
  border-top-width: 2px;
}

#lmixnpaikv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lmixnpaikv .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#lmixnpaikv .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#lmixnpaikv .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lmixnpaikv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lmixnpaikv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#lmixnpaikv .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#lmixnpaikv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lmixnpaikv .gt_footnotes {
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

#lmixnpaikv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#lmixnpaikv .gt_sourcenotes {
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

#lmixnpaikv .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#lmixnpaikv .gt_left {
  text-align: left;
}

#lmixnpaikv .gt_center {
  text-align: center;
}

#lmixnpaikv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#lmixnpaikv .gt_font_normal {
  font-weight: normal;
}

#lmixnpaikv .gt_font_bold {
  font-weight: bold;
}

#lmixnpaikv .gt_font_italic {
  font-style: italic;
}

#lmixnpaikv .gt_super {
  font-size: 65%;
}

#lmixnpaikv .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#lmixnpaikv .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#lmixnpaikv .gt_indent_1 {
  text-indent: 5px;
}

#lmixnpaikv .gt_indent_2 {
  text-indent: 10px;
}

#lmixnpaikv .gt_indent_3 {
  text-indent: 15px;
}

#lmixnpaikv .gt_indent_4 {
  text-indent: 20px;
}

#lmixnpaikv .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_right">2022-01-30</td>
<td class="gt_row gt_right">2022-03-16</td>
<td class="gt_row gt_right">2022-03-26</td>
<td class="gt_row gt_left">Rice is often served in round bowls.</td>
<td class="gt_row gt_left">regard</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">6</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-03-17</td>
<td class="gt_row gt_right">2022-03-31</td>
<td class="gt_row gt_left">The juice of lemons makes fine punch.</td>
<td class="gt_row gt_left">law</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_right">2022-04-04</td>
<td class="gt_row gt_right">2022-04-13</td>
<td class="gt_row gt_right">2022-04-22</td>
<td class="gt_row gt_left">Four hours of steady work faced us.</td>
<td class="gt_row gt_left">associate</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">2022-01-29</td>
<td class="gt_row gt_right">2022-03-18</td>
<td class="gt_row gt_right">2022-03-27</td>
<td class="gt_row gt_left">These days a chicken leg is a rare dish.</td>
<td class="gt_row gt_left">between</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_right">2022-01-26</td>
<td class="gt_row gt_right">2022-03-19</td>
<td class="gt_row gt_right">2022-03-25</td>
<td class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td class="gt_row gt_left">park</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">2022-04-02</td>
<td class="gt_row gt_right">2022-04-14</td>
<td class="gt_row gt_right">2022-04-20</td>
<td class="gt_row gt_left">The hogs were fed chopped corn and garbage.</td>
<td class="gt_row gt_left">encourage</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2022-01-28</td>
<td class="gt_row gt_right">2022-03-20</td>
<td class="gt_row gt_right">2022-03-30</td>
<td class="gt_row gt_left">The birch canoe slid on the smooth planks.</td>
<td class="gt_row gt_left">food</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-03-15</td>
<td class="gt_row gt_right">2022-03-29</td>
<td class="gt_row gt_left">Glue the sheet to the dark blue background.</td>
<td class="gt_row gt_left">most</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2022-04-04</td>
<td class="gt_row gt_right">2022-04-15</td>
<td class="gt_row gt_right">2022-04-21</td>
<td class="gt_row gt_left">The box was thrown beside the parked truck.</td>
<td class="gt_row gt_left">pension</td></tr>
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

<div id="alzwjnawwh" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#alzwjnawwh .gt_table {
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

#alzwjnawwh .gt_heading {
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

#alzwjnawwh .gt_title {
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

#alzwjnawwh .gt_subtitle {
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

#alzwjnawwh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#alzwjnawwh .gt_col_headings {
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

#alzwjnawwh .gt_col_heading {
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

#alzwjnawwh .gt_column_spanner_outer {
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

#alzwjnawwh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#alzwjnawwh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#alzwjnawwh .gt_column_spanner {
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

#alzwjnawwh .gt_group_heading {
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
}

#alzwjnawwh .gt_empty_group_heading {
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

#alzwjnawwh .gt_from_md > :first-child {
  margin-top: 0;
}

#alzwjnawwh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#alzwjnawwh .gt_row {
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

#alzwjnawwh .gt_stub {
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

#alzwjnawwh .gt_stub_row_group {
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

#alzwjnawwh .gt_row_group_first td {
  border-top-width: 2px;
}

#alzwjnawwh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#alzwjnawwh .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#alzwjnawwh .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#alzwjnawwh .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#alzwjnawwh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#alzwjnawwh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#alzwjnawwh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#alzwjnawwh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#alzwjnawwh .gt_footnotes {
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

#alzwjnawwh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#alzwjnawwh .gt_sourcenotes {
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

#alzwjnawwh .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#alzwjnawwh .gt_left {
  text-align: left;
}

#alzwjnawwh .gt_center {
  text-align: center;
}

#alzwjnawwh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#alzwjnawwh .gt_font_normal {
  font-weight: normal;
}

#alzwjnawwh .gt_font_bold {
  font-weight: bold;
}

#alzwjnawwh .gt_font_italic {
  font-style: italic;
}

#alzwjnawwh .gt_super {
  font-size: 65%;
}

#alzwjnawwh .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#alzwjnawwh .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#alzwjnawwh .gt_indent_1 {
  text-indent: 5px;
}

#alzwjnawwh .gt_indent_2 {
  text-indent: 10px;
}

#alzwjnawwh .gt_indent_3 {
  text-indent: 15px;
}

#alzwjnawwh .gt_indent_4 {
  text-indent: 20px;
}

#alzwjnawwh .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_right">2022-04-04</td>
<td class="gt_row gt_right">2022-04-13</td>
<td class="gt_row gt_right">2022-04-22</td>
<td class="gt_row gt_left">Four hours of steady work faced us.</td>
<td class="gt_row gt_left">associate</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">2022-04-02</td>
<td class="gt_row gt_right">2022-04-14</td>
<td class="gt_row gt_right">2022-04-20</td>
<td class="gt_row gt_left">The hogs were fed chopped corn and garbage.</td>
<td class="gt_row gt_left">encourage</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2022-04-04</td>
<td class="gt_row gt_right">2022-04-15</td>
<td class="gt_row gt_right">2022-04-21</td>
<td class="gt_row gt_left">The box was thrown beside the parked truck.</td>
<td class="gt_row gt_left">pension</td></tr>
  </tbody>
  
  
</table>
</div>

We can check this against the `NewData` dataset (which should match the
output from `create_new_data()`)

``` r
NewData |> gt::gt()
```

<div id="gdfwfxaexy" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#gdfwfxaexy .gt_table {
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

#gdfwfxaexy .gt_heading {
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

#gdfwfxaexy .gt_title {
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

#gdfwfxaexy .gt_subtitle {
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

#gdfwfxaexy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gdfwfxaexy .gt_col_headings {
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

#gdfwfxaexy .gt_col_heading {
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

#gdfwfxaexy .gt_column_spanner_outer {
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

#gdfwfxaexy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#gdfwfxaexy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#gdfwfxaexy .gt_column_spanner {
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

#gdfwfxaexy .gt_group_heading {
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
}

#gdfwfxaexy .gt_empty_group_heading {
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

#gdfwfxaexy .gt_from_md > :first-child {
  margin-top: 0;
}

#gdfwfxaexy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#gdfwfxaexy .gt_row {
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

#gdfwfxaexy .gt_stub {
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

#gdfwfxaexy .gt_stub_row_group {
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

#gdfwfxaexy .gt_row_group_first td {
  border-top-width: 2px;
}

#gdfwfxaexy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#gdfwfxaexy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#gdfwfxaexy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#gdfwfxaexy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gdfwfxaexy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#gdfwfxaexy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#gdfwfxaexy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#gdfwfxaexy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gdfwfxaexy .gt_footnotes {
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

#gdfwfxaexy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#gdfwfxaexy .gt_sourcenotes {
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

#gdfwfxaexy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#gdfwfxaexy .gt_left {
  text-align: left;
}

#gdfwfxaexy .gt_center {
  text-align: center;
}

#gdfwfxaexy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#gdfwfxaexy .gt_font_normal {
  font-weight: normal;
}

#gdfwfxaexy .gt_font_bold {
  font-weight: bold;
}

#gdfwfxaexy .gt_font_italic {
  font-style: italic;
}

#gdfwfxaexy .gt_super {
  font-size: 65%;
}

#gdfwfxaexy .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#gdfwfxaexy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#gdfwfxaexy .gt_indent_1 {
  text-indent: 5px;
}

#gdfwfxaexy .gt_indent_2 {
  text-indent: 10px;
}

#gdfwfxaexy .gt_indent_3 {
  text-indent: 15px;
}

#gdfwfxaexy .gt_indent_4 {
  text-indent: 20px;
}

#gdfwfxaexy .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_right">2022-04-04</td>
<td class="gt_row gt_right">2022-04-13</td>
<td class="gt_row gt_right">2022-04-22</td>
<td class="gt_row gt_left">Four hours of steady work faced us.</td>
<td class="gt_row gt_left">associate</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_right">2022-04-02</td>
<td class="gt_row gt_right">2022-04-14</td>
<td class="gt_row gt_right">2022-04-20</td>
<td class="gt_row gt_left">The hogs were fed chopped corn and garbage.</td>
<td class="gt_row gt_left">encourage</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2022-04-04</td>
<td class="gt_row gt_right">2022-04-15</td>
<td class="gt_row gt_right">2022-04-21</td>
<td class="gt_row gt_left">The box was thrown beside the parked truck.</td>
<td class="gt_row gt_left">pension</td></tr>
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

<div id="fgctmbbwbl" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#fgctmbbwbl .gt_table {
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

#fgctmbbwbl .gt_heading {
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

#fgctmbbwbl .gt_title {
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

#fgctmbbwbl .gt_subtitle {
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

#fgctmbbwbl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fgctmbbwbl .gt_col_headings {
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

#fgctmbbwbl .gt_col_heading {
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

#fgctmbbwbl .gt_column_spanner_outer {
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

#fgctmbbwbl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#fgctmbbwbl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#fgctmbbwbl .gt_column_spanner {
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

#fgctmbbwbl .gt_group_heading {
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
}

#fgctmbbwbl .gt_empty_group_heading {
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

#fgctmbbwbl .gt_from_md > :first-child {
  margin-top: 0;
}

#fgctmbbwbl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#fgctmbbwbl .gt_row {
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

#fgctmbbwbl .gt_stub {
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

#fgctmbbwbl .gt_stub_row_group {
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

#fgctmbbwbl .gt_row_group_first td {
  border-top-width: 2px;
}

#fgctmbbwbl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fgctmbbwbl .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#fgctmbbwbl .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#fgctmbbwbl .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fgctmbbwbl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fgctmbbwbl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#fgctmbbwbl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#fgctmbbwbl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fgctmbbwbl .gt_footnotes {
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

#fgctmbbwbl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#fgctmbbwbl .gt_sourcenotes {
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

#fgctmbbwbl .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#fgctmbbwbl .gt_left {
  text-align: left;
}

#fgctmbbwbl .gt_center {
  text-align: center;
}

#fgctmbbwbl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#fgctmbbwbl .gt_font_normal {
  font-weight: normal;
}

#fgctmbbwbl .gt_font_bold {
  font-weight: bold;
}

#fgctmbbwbl .gt_font_italic {
  font-style: italic;
}

#fgctmbbwbl .gt_super {
  font-size: 65%;
}

#fgctmbbwbl .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#fgctmbbwbl .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#fgctmbbwbl .gt_indent_1 {
  text-indent: 5px;
}

#fgctmbbwbl .gt_indent_2 {
  text-indent: 10px;
}

#fgctmbbwbl .gt_indent_3 {
  text-indent: 15px;
}

#fgctmbbwbl .gt_indent_4 {
  text-indent: 20px;
}

#fgctmbbwbl .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-28</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-02-26</td>
<td class="gt_row gt_left">The copper bowl shone in the sun's rays.</td>
<td class="gt_row gt_left">interest</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2021-12-28</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-02-26</td>
<td class="gt_row gt_left">Mark the spot with a sign painted red.</td>
<td class="gt_row gt_left">state</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-26</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-02-24</td>
<td class="gt_row gt_left">Take a chance and win a china doll.</td>
<td class="gt_row gt_left">sure</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2021-12-26</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-02-24</td>
<td class="gt_row gt_left">A cramp is no small danger on a swim.</td>
<td class="gt_row gt_left">white</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-30</td>
<td class="gt_row gt_right">2022-01-29</td>
<td class="gt_row gt_right">2022-02-28</td>
<td class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td class="gt_row gt_left">grant</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-27</td>
<td class="gt_row gt_right">2022-01-26</td>
<td class="gt_row gt_right">2022-02-25</td>
<td class="gt_row gt_left">The sky that morning was clear and bright blue.</td>
<td class="gt_row gt_left">tape</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_right">2021-12-28</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-02-26</td>
<td class="gt_row gt_left">Wake and rise, and step into the green outdoors.</td>
<td class="gt_row gt_left">situate</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_right">2021-12-26</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-02-24</td>
<td class="gt_row gt_left">A blue crane is a tall wading bird.</td>
<td class="gt_row gt_left">shut</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2021-12-27</td>
<td class="gt_row gt_right">2022-01-26</td>
<td class="gt_row gt_right">2022-02-25</td>
<td class="gt_row gt_left">Say it slow!y but make it ring clear.</td>
<td class="gt_row gt_left">document</td></tr>
  </tbody>
  
  
</table>
</div>

### An incomplete dataset

This is a dataset with rows removed from `CompleteData`.

``` r
IncompleteData |> gt::gt()
```

<div id="qevldojotb" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#qevldojotb .gt_table {
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

#qevldojotb .gt_heading {
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

#qevldojotb .gt_title {
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

#qevldojotb .gt_subtitle {
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

#qevldojotb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qevldojotb .gt_col_headings {
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

#qevldojotb .gt_col_heading {
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

#qevldojotb .gt_column_spanner_outer {
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

#qevldojotb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qevldojotb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qevldojotb .gt_column_spanner {
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

#qevldojotb .gt_group_heading {
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
}

#qevldojotb .gt_empty_group_heading {
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

#qevldojotb .gt_from_md > :first-child {
  margin-top: 0;
}

#qevldojotb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qevldojotb .gt_row {
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

#qevldojotb .gt_stub {
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

#qevldojotb .gt_stub_row_group {
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

#qevldojotb .gt_row_group_first td {
  border-top-width: 2px;
}

#qevldojotb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qevldojotb .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#qevldojotb .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#qevldojotb .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qevldojotb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qevldojotb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qevldojotb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qevldojotb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qevldojotb .gt_footnotes {
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

#qevldojotb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qevldojotb .gt_sourcenotes {
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

#qevldojotb .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qevldojotb .gt_left {
  text-align: left;
}

#qevldojotb .gt_center {
  text-align: center;
}

#qevldojotb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qevldojotb .gt_font_normal {
  font-weight: normal;
}

#qevldojotb .gt_font_bold {
  font-weight: bold;
}

#qevldojotb .gt_font_italic {
  font-style: italic;
}

#qevldojotb .gt_super {
  font-size: 65%;
}

#qevldojotb .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#qevldojotb .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#qevldojotb .gt_indent_1 {
  text-indent: 5px;
}

#qevldojotb .gt_indent_2 {
  text-indent: 10px;
}

#qevldojotb .gt_indent_3 {
  text-indent: 15px;
}

#qevldojotb .gt_indent_4 {
  text-indent: 20px;
}

#qevldojotb .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-28</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-02-26</td>
<td class="gt_row gt_left">The copper bowl shone in the sun's rays.</td>
<td class="gt_row gt_left">interest</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-26</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-02-24</td>
<td class="gt_row gt_left">Take a chance and win a china doll.</td>
<td class="gt_row gt_left">sure</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2021-12-26</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-02-24</td>
<td class="gt_row gt_left">A cramp is no small danger on a swim.</td>
<td class="gt_row gt_left">white</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_right">2021-12-28</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-02-26</td>
<td class="gt_row gt_left">Wake and rise, and step into the green outdoors.</td>
<td class="gt_row gt_left">situate</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2021-12-27</td>
<td class="gt_row gt_right">2022-01-26</td>
<td class="gt_row gt_right">2022-02-25</td>
<td class="gt_row gt_left">Say it slow!y but make it ring clear.</td>
<td class="gt_row gt_left">document</td></tr>
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

<div id="nloaemgifi" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#nloaemgifi .gt_table {
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

#nloaemgifi .gt_heading {
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

#nloaemgifi .gt_title {
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

#nloaemgifi .gt_subtitle {
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

#nloaemgifi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nloaemgifi .gt_col_headings {
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

#nloaemgifi .gt_col_heading {
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

#nloaemgifi .gt_column_spanner_outer {
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

#nloaemgifi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nloaemgifi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nloaemgifi .gt_column_spanner {
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

#nloaemgifi .gt_group_heading {
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
}

#nloaemgifi .gt_empty_group_heading {
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

#nloaemgifi .gt_from_md > :first-child {
  margin-top: 0;
}

#nloaemgifi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nloaemgifi .gt_row {
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

#nloaemgifi .gt_stub {
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

#nloaemgifi .gt_stub_row_group {
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

#nloaemgifi .gt_row_group_first td {
  border-top-width: 2px;
}

#nloaemgifi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nloaemgifi .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nloaemgifi .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nloaemgifi .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nloaemgifi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nloaemgifi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nloaemgifi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nloaemgifi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nloaemgifi .gt_footnotes {
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

#nloaemgifi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nloaemgifi .gt_sourcenotes {
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

#nloaemgifi .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nloaemgifi .gt_left {
  text-align: left;
}

#nloaemgifi .gt_center {
  text-align: center;
}

#nloaemgifi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nloaemgifi .gt_font_normal {
  font-weight: normal;
}

#nloaemgifi .gt_font_bold {
  font-weight: bold;
}

#nloaemgifi .gt_font_italic {
  font-style: italic;
}

#nloaemgifi .gt_super {
  font-size: 65%;
}

#nloaemgifi .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#nloaemgifi .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nloaemgifi .gt_indent_1 {
  text-indent: 5px;
}

#nloaemgifi .gt_indent_2 {
  text-indent: 10px;
}

#nloaemgifi .gt_indent_3 {
  text-indent: 15px;
}

#nloaemgifi .gt_indent_4 {
  text-indent: 20px;
}

#nloaemgifi .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2021-12-28</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-02-26</td>
<td class="gt_row gt_left">Mark the spot with a sign painted red.</td>
<td class="gt_row gt_left">state</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-30</td>
<td class="gt_row gt_right">2022-01-29</td>
<td class="gt_row gt_right">2022-02-28</td>
<td class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td class="gt_row gt_left">grant</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-27</td>
<td class="gt_row gt_right">2022-01-26</td>
<td class="gt_row gt_right">2022-02-25</td>
<td class="gt_row gt_left">The sky that morning was clear and bright blue.</td>
<td class="gt_row gt_left">tape</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_right">2021-12-26</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-02-24</td>
<td class="gt_row gt_left">A blue crane is a tall wading bird.</td>
<td class="gt_row gt_left">shut</td></tr>
  </tbody>
  
  
</table>
</div>

### The deleted data

This is identical to the data stored in `DeletedData`

``` r
DeletedData |> gt::gt()
```

<div id="cwerpgjxcw" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#cwerpgjxcw .gt_table {
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

#cwerpgjxcw .gt_heading {
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

#cwerpgjxcw .gt_title {
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

#cwerpgjxcw .gt_subtitle {
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

#cwerpgjxcw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cwerpgjxcw .gt_col_headings {
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

#cwerpgjxcw .gt_col_heading {
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

#cwerpgjxcw .gt_column_spanner_outer {
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

#cwerpgjxcw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#cwerpgjxcw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#cwerpgjxcw .gt_column_spanner {
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

#cwerpgjxcw .gt_group_heading {
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
}

#cwerpgjxcw .gt_empty_group_heading {
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

#cwerpgjxcw .gt_from_md > :first-child {
  margin-top: 0;
}

#cwerpgjxcw .gt_from_md > :last-child {
  margin-bottom: 0;
}

#cwerpgjxcw .gt_row {
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

#cwerpgjxcw .gt_stub {
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

#cwerpgjxcw .gt_stub_row_group {
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

#cwerpgjxcw .gt_row_group_first td {
  border-top-width: 2px;
}

#cwerpgjxcw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cwerpgjxcw .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#cwerpgjxcw .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#cwerpgjxcw .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cwerpgjxcw .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cwerpgjxcw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#cwerpgjxcw .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#cwerpgjxcw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cwerpgjxcw .gt_footnotes {
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

#cwerpgjxcw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cwerpgjxcw .gt_sourcenotes {
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

#cwerpgjxcw .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cwerpgjxcw .gt_left {
  text-align: left;
}

#cwerpgjxcw .gt_center {
  text-align: center;
}

#cwerpgjxcw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#cwerpgjxcw .gt_font_normal {
  font-weight: normal;
}

#cwerpgjxcw .gt_font_bold {
  font-weight: bold;
}

#cwerpgjxcw .gt_font_italic {
  font-style: italic;
}

#cwerpgjxcw .gt_super {
  font-size: 65%;
}

#cwerpgjxcw .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#cwerpgjxcw .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#cwerpgjxcw .gt_indent_1 {
  text-indent: 5px;
}

#cwerpgjxcw .gt_indent_2 {
  text-indent: 10px;
}

#cwerpgjxcw .gt_indent_3 {
  text-indent: 15px;
}

#cwerpgjxcw .gt_indent_4 {
  text-indent: 20px;
}

#cwerpgjxcw .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">start_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">mid_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">end_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_var</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">factor_var</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">2021-12-28</td>
<td class="gt_row gt_right">2022-01-27</td>
<td class="gt_row gt_right">2022-02-26</td>
<td class="gt_row gt_left">Mark the spot with a sign painted red.</td>
<td class="gt_row gt_left">state</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_right">2021-12-26</td>
<td class="gt_row gt_right">2022-01-25</td>
<td class="gt_row gt_right">2022-02-24</td>
<td class="gt_row gt_left">A blue crane is a tall wading bird.</td>
<td class="gt_row gt_left">shut</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-30</td>
<td class="gt_row gt_right">2022-01-29</td>
<td class="gt_row gt_right">2022-02-28</td>
<td class="gt_row gt_left">It's easy to tell the depth of a well.</td>
<td class="gt_row gt_left">grant</td></tr>
    <tr><td class="gt_row gt_left">D</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">2021-12-27</td>
<td class="gt_row gt_right">2022-01-26</td>
<td class="gt_row gt_right">2022-02-25</td>
<td class="gt_row gt_left">The sky that morning was clear and bright blue.</td>
<td class="gt_row gt_left">tape</td></tr>
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

<div id="bfvjumlyse" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#bfvjumlyse .gt_table {
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

#bfvjumlyse .gt_heading {
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

#bfvjumlyse .gt_title {
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

#bfvjumlyse .gt_subtitle {
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

#bfvjumlyse .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bfvjumlyse .gt_col_headings {
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

#bfvjumlyse .gt_col_heading {
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

#bfvjumlyse .gt_column_spanner_outer {
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

#bfvjumlyse .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bfvjumlyse .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bfvjumlyse .gt_column_spanner {
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

#bfvjumlyse .gt_group_heading {
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
}

#bfvjumlyse .gt_empty_group_heading {
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

#bfvjumlyse .gt_from_md > :first-child {
  margin-top: 0;
}

#bfvjumlyse .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bfvjumlyse .gt_row {
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

#bfvjumlyse .gt_stub {
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

#bfvjumlyse .gt_stub_row_group {
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

#bfvjumlyse .gt_row_group_first td {
  border-top-width: 2px;
}

#bfvjumlyse .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bfvjumlyse .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#bfvjumlyse .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#bfvjumlyse .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bfvjumlyse .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bfvjumlyse .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bfvjumlyse .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bfvjumlyse .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bfvjumlyse .gt_footnotes {
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

#bfvjumlyse .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bfvjumlyse .gt_sourcenotes {
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

#bfvjumlyse .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#bfvjumlyse .gt_left {
  text-align: left;
}

#bfvjumlyse .gt_center {
  text-align: center;
}

#bfvjumlyse .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bfvjumlyse .gt_font_normal {
  font-weight: normal;
}

#bfvjumlyse .gt_font_bold {
  font-weight: bold;
}

#bfvjumlyse .gt_font_italic {
  font-style: italic;
}

#bfvjumlyse .gt_super {
  font-size: 65%;
}

#bfvjumlyse .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#bfvjumlyse .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#bfvjumlyse .gt_indent_1 {
  text-indent: 5px;
}

#bfvjumlyse .gt_indent_2 {
  text-indent: 10px;
}

#bfvjumlyse .gt_indent_3 {
  text-indent: 15px;
}

#bfvjumlyse .gt_indent_4 {
  text-indent: 20px;
}

#bfvjumlyse .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject_id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_value_a</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_value_b</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">created_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">updated_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">entered_date</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_left">Issue unresolved</td>
<td class="gt_row gt_left">Fatigue</td>
<td class="gt_row gt_right">2021-07-29</td>
<td class="gt_row gt_right">2021-09-29</td>
<td class="gt_row gt_right">2021-09-29</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_left">Issue unresolved</td>
<td class="gt_row gt_left">Fatigue</td>
<td class="gt_row gt_right">2021-07-29</td>
<td class="gt_row gt_right">2021-10-03</td>
<td class="gt_row gt_right">2021-10-29</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Fever</td>
<td class="gt_row gt_right">2021-07-16</td>
<td class="gt_row gt_right">2021-09-02</td>
<td class="gt_row gt_right">2021-08-18</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Joint pain</td>
<td class="gt_row gt_right">2021-08-24</td>
<td class="gt_row gt_right">2021-10-03</td>
<td class="gt_row gt_right">2021-10-03</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Joint pain</td>
<td class="gt_row gt_right">2021-08-24</td>
<td class="gt_row gt_right">2021-09-20</td>
<td class="gt_row gt_right">2021-10-20</td></tr>
  </tbody>
  
  
</table>
</div>

### Changed data

``` r
ChangedData |> gt::gt()
```

<div id="djzjkwknes" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#djzjkwknes .gt_table {
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

#djzjkwknes .gt_heading {
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

#djzjkwknes .gt_title {
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

#djzjkwknes .gt_subtitle {
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

#djzjkwknes .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#djzjkwknes .gt_col_headings {
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

#djzjkwknes .gt_col_heading {
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

#djzjkwknes .gt_column_spanner_outer {
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

#djzjkwknes .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#djzjkwknes .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#djzjkwknes .gt_column_spanner {
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

#djzjkwknes .gt_group_heading {
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
}

#djzjkwknes .gt_empty_group_heading {
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

#djzjkwknes .gt_from_md > :first-child {
  margin-top: 0;
}

#djzjkwknes .gt_from_md > :last-child {
  margin-bottom: 0;
}

#djzjkwknes .gt_row {
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

#djzjkwknes .gt_stub {
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

#djzjkwknes .gt_stub_row_group {
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

#djzjkwknes .gt_row_group_first td {
  border-top-width: 2px;
}

#djzjkwknes .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#djzjkwknes .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#djzjkwknes .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#djzjkwknes .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#djzjkwknes .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#djzjkwknes .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#djzjkwknes .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#djzjkwknes .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#djzjkwknes .gt_footnotes {
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

#djzjkwknes .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#djzjkwknes .gt_sourcenotes {
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

#djzjkwknes .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#djzjkwknes .gt_left {
  text-align: left;
}

#djzjkwknes .gt_center {
  text-align: center;
}

#djzjkwknes .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#djzjkwknes .gt_font_normal {
  font-weight: normal;
}

#djzjkwknes .gt_font_bold {
  font-weight: bold;
}

#djzjkwknes .gt_font_italic {
  font-style: italic;
}

#djzjkwknes .gt_super {
  font-size: 65%;
}

#djzjkwknes .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#djzjkwknes .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#djzjkwknes .gt_indent_1 {
  text-indent: 5px;
}

#djzjkwknes .gt_indent_2 {
  text-indent: 10px;
}

#djzjkwknes .gt_indent_3 {
  text-indent: 15px;
}

#djzjkwknes .gt_indent_4 {
  text-indent: 20px;
}

#djzjkwknes .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">subject_id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">record</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_value_a</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">text_value_b</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">created_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">updated_date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">entered_date</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Fatigue</td>
<td class="gt_row gt_right">2021-07-29</td>
<td class="gt_row gt_right">2021-10-03</td>
<td class="gt_row gt_right">2021-11-30</td></tr>
    <tr><td class="gt_row gt_left">A</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Fatigue</td>
<td class="gt_row gt_right">2021-07-29</td>
<td class="gt_row gt_right">2021-11-27</td>
<td class="gt_row gt_right">2021-11-30</td></tr>
    <tr><td class="gt_row gt_left">B</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Fever</td>
<td class="gt_row gt_right">2021-07-16</td>
<td class="gt_row gt_right">2021-10-20</td>
<td class="gt_row gt_right">2021-11-21</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Joint pain, stiffness and swelling</td>
<td class="gt_row gt_right">2021-08-24</td>
<td class="gt_row gt_right">2021-10-13</td>
<td class="gt_row gt_right">2021-11-11</td></tr>
    <tr><td class="gt_row gt_left">C</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Joint pain</td>
<td class="gt_row gt_right">2021-08-24</td>
<td class="gt_row gt_right">2021-10-14</td>
<td class="gt_row gt_right">2021-11-16</td></tr>
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

<div id="nzqnupqabx" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#nzqnupqabx .gt_table {
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

#nzqnupqabx .gt_heading {
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

#nzqnupqabx .gt_title {
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

#nzqnupqabx .gt_subtitle {
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

#nzqnupqabx .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nzqnupqabx .gt_col_headings {
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

#nzqnupqabx .gt_col_heading {
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

#nzqnupqabx .gt_column_spanner_outer {
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

#nzqnupqabx .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nzqnupqabx .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nzqnupqabx .gt_column_spanner {
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

#nzqnupqabx .gt_group_heading {
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
}

#nzqnupqabx .gt_empty_group_heading {
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

#nzqnupqabx .gt_from_md > :first-child {
  margin-top: 0;
}

#nzqnupqabx .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nzqnupqabx .gt_row {
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

#nzqnupqabx .gt_stub {
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

#nzqnupqabx .gt_stub_row_group {
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

#nzqnupqabx .gt_row_group_first td {
  border-top-width: 2px;
}

#nzqnupqabx .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nzqnupqabx .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nzqnupqabx .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nzqnupqabx .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nzqnupqabx .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nzqnupqabx .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nzqnupqabx .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nzqnupqabx .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nzqnupqabx .gt_footnotes {
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

#nzqnupqabx .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nzqnupqabx .gt_sourcenotes {
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

#nzqnupqabx .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nzqnupqabx .gt_left {
  text-align: left;
}

#nzqnupqabx .gt_center {
  text-align: center;
}

#nzqnupqabx .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nzqnupqabx .gt_font_normal {
  font-weight: normal;
}

#nzqnupqabx .gt_font_bold {
  font-weight: bold;
}

#nzqnupqabx .gt_font_italic {
  font-style: italic;
}

#nzqnupqabx .gt_super {
  font-size: 65%;
}

#nzqnupqabx .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#nzqnupqabx .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nzqnupqabx .gt_indent_1 {
  text-indent: 5px;
}

#nzqnupqabx .gt_indent_2 {
  text-indent: 10px;
}

#nzqnupqabx .gt_indent_3 {
  text-indent: 15px;
}

#nzqnupqabx .gt_indent_4 {
  text-indent: 20px;
}

#nzqnupqabx .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">variable</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">no_of_differences</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">text_value_a</td>
<td class="gt_row gt_right">2</td></tr>
    <tr><td class="gt_row gt_left">text_value_b</td>
<td class="gt_row gt_right">1</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_right">5</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_right">5</td></tr>
  </tbody>
  
  
</table>
</div>

#### Changes by row (`var_diffs`)

The changes by row are stored in `var_diffs`.

``` r
changed$var_diffs |> gt::gt()
```

<div id="xvobazuwlj" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#xvobazuwlj .gt_table {
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

#xvobazuwlj .gt_heading {
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

#xvobazuwlj .gt_title {
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

#xvobazuwlj .gt_subtitle {
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

#xvobazuwlj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xvobazuwlj .gt_col_headings {
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

#xvobazuwlj .gt_col_heading {
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

#xvobazuwlj .gt_column_spanner_outer {
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

#xvobazuwlj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xvobazuwlj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xvobazuwlj .gt_column_spanner {
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

#xvobazuwlj .gt_group_heading {
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
}

#xvobazuwlj .gt_empty_group_heading {
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

#xvobazuwlj .gt_from_md > :first-child {
  margin-top: 0;
}

#xvobazuwlj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xvobazuwlj .gt_row {
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

#xvobazuwlj .gt_stub {
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

#xvobazuwlj .gt_stub_row_group {
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

#xvobazuwlj .gt_row_group_first td {
  border-top-width: 2px;
}

#xvobazuwlj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xvobazuwlj .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#xvobazuwlj .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#xvobazuwlj .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xvobazuwlj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xvobazuwlj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xvobazuwlj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xvobazuwlj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xvobazuwlj .gt_footnotes {
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

#xvobazuwlj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xvobazuwlj .gt_sourcenotes {
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

#xvobazuwlj .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#xvobazuwlj .gt_left {
  text-align: left;
}

#xvobazuwlj .gt_center {
  text-align: center;
}

#xvobazuwlj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xvobazuwlj .gt_font_normal {
  font-weight: normal;
}

#xvobazuwlj .gt_font_bold {
  font-weight: bold;
}

#xvobazuwlj .gt_font_italic {
  font-style: italic;
}

#xvobazuwlj .gt_super {
  font-size: 65%;
}

#xvobazuwlj .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#xvobazuwlj .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#xvobazuwlj .gt_indent_1 {
  text-indent: 5px;
}

#xvobazuwlj .gt_indent_2 {
  text-indent: 10px;
}

#xvobazuwlj .gt_indent_3 {
  text-indent: 15px;
}

#xvobazuwlj .gt_indent_4 {
  text-indent: 20px;
}

#xvobazuwlj .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">variable</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">rownumber</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">base</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">compare</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">text_value_a</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_left">Issue unresolved</td>
<td class="gt_row gt_left">Issue resolved</td></tr>
    <tr><td class="gt_row gt_left">text_value_a</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_left">Issue unresolved</td>
<td class="gt_row gt_left">Issue resolved</td></tr>
    <tr><td class="gt_row gt_left">text_value_b</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_left">Joint pain</td>
<td class="gt_row gt_left">Joint pain, stiffness and swelling</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_left">2021-09-29</td>
<td class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_left">2021-10-03</td>
<td class="gt_row gt_left">2021-11-27</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_left">2021-09-02</td>
<td class="gt_row gt_left">2021-10-20</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_left">2021-10-03</td>
<td class="gt_row gt_left">2021-10-13</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_left">2021-09-20</td>
<td class="gt_row gt_left">2021-10-14</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_left">2021-09-29</td>
<td class="gt_row gt_left">2021-11-30</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_left">2021-10-29</td>
<td class="gt_row gt_left">2021-11-30</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_right">3</td>
<td class="gt_row gt_left">2021-08-18</td>
<td class="gt_row gt_left">2021-11-21</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_right">4</td>
<td class="gt_row gt_left">2021-10-03</td>
<td class="gt_row gt_left">2021-11-11</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_left">2021-10-20</td>
<td class="gt_row gt_left">2021-11-16</td></tr>
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

<div id="qqgbybyqhx" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#qqgbybyqhx .gt_table {
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

#qqgbybyqhx .gt_heading {
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

#qqgbybyqhx .gt_title {
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

#qqgbybyqhx .gt_subtitle {
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

#qqgbybyqhx .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qqgbybyqhx .gt_col_headings {
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

#qqgbybyqhx .gt_col_heading {
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

#qqgbybyqhx .gt_column_spanner_outer {
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

#qqgbybyqhx .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qqgbybyqhx .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qqgbybyqhx .gt_column_spanner {
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

#qqgbybyqhx .gt_group_heading {
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
}

#qqgbybyqhx .gt_empty_group_heading {
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

#qqgbybyqhx .gt_from_md > :first-child {
  margin-top: 0;
}

#qqgbybyqhx .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qqgbybyqhx .gt_row {
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

#qqgbybyqhx .gt_stub {
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

#qqgbybyqhx .gt_stub_row_group {
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

#qqgbybyqhx .gt_row_group_first td {
  border-top-width: 2px;
}

#qqgbybyqhx .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qqgbybyqhx .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#qqgbybyqhx .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#qqgbybyqhx .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qqgbybyqhx .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qqgbybyqhx .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qqgbybyqhx .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qqgbybyqhx .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qqgbybyqhx .gt_footnotes {
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

#qqgbybyqhx .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qqgbybyqhx .gt_sourcenotes {
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

#qqgbybyqhx .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#qqgbybyqhx .gt_left {
  text-align: left;
}

#qqgbybyqhx .gt_center {
  text-align: center;
}

#qqgbybyqhx .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qqgbybyqhx .gt_font_normal {
  font-weight: normal;
}

#qqgbybyqhx .gt_font_bold {
  font-weight: bold;
}

#qqgbybyqhx .gt_font_italic {
  font-style: italic;
}

#qqgbybyqhx .gt_super {
  font-size: 65%;
}

#qqgbybyqhx .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#qqgbybyqhx .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#qqgbybyqhx .gt_indent_1 {
  text-indent: 5px;
}

#qqgbybyqhx .gt_indent_2 {
  text-indent: 10px;
}

#qqgbybyqhx .gt_indent_3 {
  text-indent: 15px;
}

#qqgbybyqhx .gt_indent_4 {
  text-indent: 20px;
}

#qqgbybyqhx .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">Variable name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">Modified Values</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">Missing Values</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">subject_id</td>
<td class="gt_row gt_right">0</td>
<td class="gt_row gt_right">0</td></tr>
    <tr><td class="gt_row gt_left">record</td>
<td class="gt_row gt_right">0</td>
<td class="gt_row gt_right">0</td></tr>
    <tr><td class="gt_row gt_left">text_value_a</td>
<td class="gt_row gt_right">2</td>
<td class="gt_row gt_right">0</td></tr>
    <tr><td class="gt_row gt_left">text_value_b</td>
<td class="gt_row gt_right">1</td>
<td class="gt_row gt_right">0</td></tr>
    <tr><td class="gt_row gt_left">created_date</td>
<td class="gt_row gt_right">0</td>
<td class="gt_row gt_right">0</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_right">0</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_right">5</td>
<td class="gt_row gt_right">0</td></tr>
  </tbody>
  
  
</table>
</div>

#### Changes by row

The changes by row are stored in `diffs`.

``` r
modified$diffs |> gt::gt()
```

<div id="mbqfttrdwp" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mbqfttrdwp .gt_table {
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

#mbqfttrdwp .gt_heading {
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

#mbqfttrdwp .gt_title {
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

#mbqfttrdwp .gt_subtitle {
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

#mbqfttrdwp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mbqfttrdwp .gt_col_headings {
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

#mbqfttrdwp .gt_col_heading {
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

#mbqfttrdwp .gt_column_spanner_outer {
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

#mbqfttrdwp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#mbqfttrdwp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#mbqfttrdwp .gt_column_spanner {
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

#mbqfttrdwp .gt_group_heading {
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
}

#mbqfttrdwp .gt_empty_group_heading {
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

#mbqfttrdwp .gt_from_md > :first-child {
  margin-top: 0;
}

#mbqfttrdwp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mbqfttrdwp .gt_row {
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

#mbqfttrdwp .gt_stub {
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

#mbqfttrdwp .gt_stub_row_group {
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

#mbqfttrdwp .gt_row_group_first td {
  border-top-width: 2px;
}

#mbqfttrdwp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mbqfttrdwp .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#mbqfttrdwp .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#mbqfttrdwp .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mbqfttrdwp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mbqfttrdwp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mbqfttrdwp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#mbqfttrdwp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mbqfttrdwp .gt_footnotes {
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

#mbqfttrdwp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#mbqfttrdwp .gt_sourcenotes {
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

#mbqfttrdwp .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#mbqfttrdwp .gt_left {
  text-align: left;
}

#mbqfttrdwp .gt_center {
  text-align: center;
}

#mbqfttrdwp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mbqfttrdwp .gt_font_normal {
  font-weight: normal;
}

#mbqfttrdwp .gt_font_bold {
  font-weight: bold;
}

#mbqfttrdwp .gt_font_italic {
  font-style: italic;
}

#mbqfttrdwp .gt_super {
  font-size: 65%;
}

#mbqfttrdwp .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#mbqfttrdwp .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#mbqfttrdwp .gt_indent_1 {
  text-indent: 5px;
}

#mbqfttrdwp .gt_indent_2 {
  text-indent: 10px;
}

#mbqfttrdwp .gt_indent_3 {
  text-indent: 15px;
}

#mbqfttrdwp .gt_indent_4 {
  text-indent: 20px;
}

#mbqfttrdwp .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">Variable name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">Current Value</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col">Previous Value</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">text_value_a</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Issue unresolved</td></tr>
    <tr><td class="gt_row gt_left">text_value_a</td>
<td class="gt_row gt_left">Issue resolved</td>
<td class="gt_row gt_left">Issue unresolved</td></tr>
    <tr><td class="gt_row gt_left">text_value_b</td>
<td class="gt_row gt_left">Joint pain, stiffness and swelling</td>
<td class="gt_row gt_left">Joint pain</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_left">2021-10-03</td>
<td class="gt_row gt_left">2021-09-29</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_left">2021-11-27</td>
<td class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_left">2021-10-20</td>
<td class="gt_row gt_left">2021-09-02</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_left">2021-10-13</td>
<td class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td class="gt_row gt_left">updated_date</td>
<td class="gt_row gt_left">2021-10-14</td>
<td class="gt_row gt_left">2021-09-20</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_left">2021-11-30</td>
<td class="gt_row gt_left">2021-09-29</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_left">2021-11-30</td>
<td class="gt_row gt_left">2021-10-29</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_left">2021-11-21</td>
<td class="gt_row gt_left">2021-08-18</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_left">2021-11-11</td>
<td class="gt_row gt_left">2021-10-03</td></tr>
    <tr><td class="gt_row gt_left">entered_date</td>
<td class="gt_row gt_left">2021-11-16</td>
<td class="gt_row gt_left">2021-10-20</td></tr>
  </tbody>
  
  
</table>
</div>
