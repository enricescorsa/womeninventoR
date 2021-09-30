#' Women inventor patents dataset obtained from USPTO's Patentview
#'
#' Data set of patented (granted) inventions by women inventors from 2016 to 2020 in the US. Variables included (columns in the data set) correspond to main patent data fields.
#'
#' @format A tibble with 384852 rows and the following 10 variables:
#' \describe{
#'   \item{id}{id}
#'   \item{country}{country of publication (US)}
#'   \item{date}{date of publication}
#'   \item{title}{Patent Title}
#'   \item{abstract}{Patent Abstract}
#'   \item{ipc_maingroup}{International Patent Classication Codes (for more info see \url{https://www.uspto.gov/web/patents/classification/})}
#'   \item{assignees}{Name of assignee organization}
#'   \item{inventors}{Names of women inventors}
#'   \item{kind}{kind codes (for more info see \url{https://www.uspto.gov/patents/search/authority-files/uspto-kind-codes})}
#'   \item{patentsyear}{year of publication}
#' }
#' @source \url{https://patentsview.org/download/data-download-tables}
#' @seealso \url{https://github.com/poldham/patentsview2021/blob/master/patentsview_bulk.Rmd}
"womeninventorpatents"
