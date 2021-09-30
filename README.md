
<!-- README.md is generated from README.Rmd. Please edit that file -->



# womeninventoRs

<!-- badges: start -->
<!-- badges: end -->

The goal of the womeninventoRs package is to share a patent data set of women inventors for its analysis within R. 

Data has been obtained from a a series of data tables that are available for bulk download from USPTO's Patentsview page here: https://patentsview.org/download/data-download-tables

See the initial bulk downloading process followed by Paul Oldham @poldham here: https://github.com/poldham/patentsview2021/blob/master/patentsview_bulk.Rmd

The building of the patent dataset (´women_inventor_patents_final´) from the downloaded files is described in the ´DATASET.R´ file included in the ´data-raw´ folder.

The data set contains granted patents by women inventors in the US within 2017 and 2020.
It contains main patent data fields as columns (textual fields such as Title and Abstract and other useful metadata such as Patent Classification Codes, names of assignee organisations and publication dates)


## Installation

You can install it from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("enricescorsa/womeninventoRs")

```
## Example

The womeninventoRs package allows you to load the ´women_inventor_patents_final´ data set and analyse it.


```r
library(womeninventoRs)

women_inventor_patents_final
#> # A tibble: 316,272 x 10
#> # Groups:   id [316,272]
#>    id       country date       title                abstract                ipc_maingroup                assignees              inventors    kind  patentsyear
#>    <chr>    <chr>   <date>     <chr>                <chr>                   <chr>                        <chr>                  <chr>        <chr> <chr>      
#>  1 10000001 US      2018-06-19 Injection molding m~ The injection molding ~ B29C/45;G05B/19;B29C/45;G05~ LS MTRON LTD.          Sun-Woo Lee  B2    2018       
#>  2 10000002 US      2018-06-19 Method for manufact~ The present invention ~ B32B/7;B29C/47;B32B/27;B32B~ KOLON INDUSTRIES, INC. Yun Jo Kim   B2    2018       
#>  3 10000010 US      2018-06-19 3-D electrostatic p~ 3-D printing system in~ B29C/64;B29C/64;B29C/64;B29~ XEROX CORPORATION      Lynn Saxton  B2    2018       
#>  4 10000018 US      2018-06-19 Pull tab design for~ A stretch release adhe~ B29C/65;B29C/65;C9J/7;G06F/~ Apple Inc.             Liane Fang   B2    2018       
#>  5 10000019 US      2018-06-19 Installation assemb~ An installation assemb~ B29C/65;B32B/37;B29C/73;B29~ The Boeing Company;Th~ Mary H. Var~ B2    2018       
#>  6 10000024 US      2018-06-19 Apparatus and metho~ An apparatus for contr~ G06F/19;B29C/67;B33Y/50;G05~ SAMSUNG SDS CO., LTD.  In-Hyok CHA  B2    2018       
#>  7 10000033 US      2018-06-19 Washable, waterproo~ Disclosed are embodime~ H01R/4;B31B/21;B65D/30;B65D~ Blueavacado. Co.       Amy George   B2    2018       
#>  8 10000036 US      2018-06-19 High kinetic energy~ Boron nitride nanotube~ B32B/5;F41H/5;D01D/5;C08J/5~ UNITED STATES OF AMER~ Sharon E. L~ B2    2018       
#>  9 10000037 US      2018-06-19 Transparent laminat~ The purpose of the pre~ B32B/7;B32B/7;A42B/3;B32B/3~ DEXERIALS CORPORATION  Emi Yoshida  B2    2018       
#> 10 10000039 US      2018-06-19 Multilayer interlay~ A multilayer interlaye~ B32B/17;B32B/7;B32B/27;B32B~ Solutia Inc.;Solutia ~ Yalda Farho~ B2    2018       
#> # ... with 316,262 more rows
```


