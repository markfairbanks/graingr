
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/logo.jpg" align="right" />

# graingr

<!-- badges: start -->

<!-- badges: end -->

Helper functions for Chicagoans.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mtfairbanks/graingr")
```

## Fiscper functions

  - The `fiscper_*()` family of functions allows for extracting date
    information from a fiscper column.
  - `fiscper_workdays()` allows you to add the number of sales days in a
    given fiscper.
  - `make_fiscper()` allows you to create a fiscper column from year and
    month columns.

<!-- end list -->

``` r
library(pacman)
p_load(tidyverse, graingr)

finance_df <- read_csv(example_csv, col_types = cols())

# Extract info from fiscper
finance_df <- finance_df %>%
  mutate(year = fiscper_year(fiscper),
         month = fiscper_month(fiscper),
         quarter = fiscper_quarter(fiscper),
         semester = fiscper_semester(fiscper),
         work_days = fiscper_workdays(fiscper),
         date = fiscper_date(fiscper))

head(finance_df)
#> # A tibble: 6 x 9
#>   fiscper revenue  cost  year month quarter semester work_days date      
#>     <dbl>   <dbl> <dbl> <dbl> <dbl>   <int>    <int>     <dbl> <date>    
#> 1 2013001    1128   555  2013     1       1        1        22 2013-01-01
#> 2 2013002    1008   525  2013     2       1        1        20 2013-02-01
#> 3 2013003    1199   504  2013     3       1        1        21 2013-03-01
#> 4 2013004    1027   584  2013     4       2        1        22 2013-04-01
#> 5 2013005    1024   546  2013     5       2        1        22 2013-05-01
#> 6 2013006    1028   552  2013     6       2        1        20 2013-06-01
```

``` r
# Create fiscper from year & month columns
finance_df %>%
  select(year, month, revenue, cost) %>%
  mutate(fiscper_example = make_fiscper(year, month)) %>%
  head()
#> # A tibble: 6 x 5
#>    year month revenue  cost fiscper_example
#>   <dbl> <dbl>   <dbl> <dbl>           <dbl>
#> 1  2013     1    1128   555         2013001
#> 2  2013     2    1008   525         2013002
#> 3  2013     3    1199   504         2013003
#> 4  2013     4    1027   584         2013004
#> 5  2013     5    1024   546         2013005
#> 6  2013     6    1028   552         2013006
```

## Querying Temp Tables

Querying temp tables in R is a two step process:

1)  “Send” temp tables to SQL
2)  Query from the temp tables

The `send_temp()` function will help with the first step.

Note that `COLLECT STATS` cannot be used when sending temp tables from
R. (If you don’t know what this means, do not worry. It simply means
this issue doesn’t apply to you.)

Also note that semi-colons must only be placed after `ON COMMIT PRESERVE
ROWS`. See the below example as a reference for how to format your temp
tables.

``` r
library(pacman)
p_load(tidyverse, graingr, odbc)

# Establish connection to teradata
td_con <- odbc::dbConnect(odbc::odbc(), "driver_name")

# Temp query
temp_query <- "CREATE VOLATILE MULTISET TABLE origination_df AS (
  SELECT top 100 *
  FROM DLFIN_FA.monthly_sales_t
  )
WITH DATA PRIMARY INDEX(level_1, level_2, level_3, fiscper) ON  COMMIT  PRESERVE ROWS;

---- Fulfillment data
CREATE VOLATILE MULTISET TABLE fulfillment_df AS (
  SELECT top 100 *
  FROM DLFIN_FA.monthly_sales_t
  )
WITH DATA PRIMARY INDEX(level_1, level_2, level_3, fiscper) ON  COMMIT  PRESERVE ROWS;"

# Send the temp queries
send_temp(td_con, temp_query)

# Run final query
final_query <- "select top 100 * from origination_df"
sales_df <- odbc::dbGetQuery(td_con, final_query) %>% as_tibble()
```

## Class Accuracy

Find accuracy measures for classification models:

``` r
library(pacman)
p_load(tidyverse, graingr)

fake_df <- tibble(actuals = c(0,1,1,1,0,1),
                  rf_pred = c(1,1,1,1,0,0))
                  
fake_df %>%
  class_accuracy(truth = actuals, pred = rf_pred)
#> # A tibble: 1 x 5
#>   model   true_positive false_positive precision accuracy
#>   <chr>           <dbl>          <dbl>     <dbl>    <dbl>
#> 1 rf_pred          0.75            0.5      0.75    0.667
```
