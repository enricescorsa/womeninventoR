# Patent data comes from a series of data tables that are available for bulk download from USPTO's Patentsview page here: https://patentsview.org/download/data-download-tables
# See the bulk downloading process followed by Paul Oldham @poldham here: https://github.com/poldham/patentsview2021/blob/master/patentsview_bulk.Rmd

#first we load the packages we need to read our data.

library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(data.table)
here::here()

# We will use data table to read this big patent dataset (7.6 million patents) and will use the fread function
patent <- as.data.frame(data.table::fread("data-raw/patent.tsv")) #this data frame contains patents with main data fields (id, publication date, title, abstract and kind codes)

#and we will read all the other associated data frames
load("data-raw/women_patents.rda") # this data frame contains patent ids and inventor ids of all patents granted to women inventors
load("data-raw/women_ipc.rda") # this data frame contains patent classifications associated to each patent, split by section, class, subclass, group and subgroup
load("data-raw/women_inventors.rda") # this data frame has inventor ids and inventor first and last names
patent_assignee <- as.data.frame(data.table::fread("data-raw/patent_assignee.tsv")) #this data frame contains assignee ids
assignee <- as.data.frame(data.table::fread("data-raw/assignee.tsv")) #this data frame contains name of assignee id and organisation name of assignee id


#then to get women inventors we want to join the patent dataset together with the women_patents dataset by id
patent$id <-as.character(patent$id)
women_inventor_patents <- patent %>% inner_join(women_patents, by =c("id" = "patent_id"))

#We have joined our women patents data to the overall patent dataset and obtained a patent dataset of women inventors containing nearly 1 Million patents.

# now we want to extract the year from the full digits date that we have and add it into a new column. We use the 'substr' function together with 'mutate', to create a new column (patentsyear) that keeps only from the first to the fourth digit.
women_inventor_patents<- women_inventor_patents %>% mutate (patentsyear = substr(women_inventor_patents$`date`, 1, 4), )

# As the data is very large, we will only take data from the last 5 years
women_inventor_patents_5y <- women_inventor_patents %>% filter(between (patentsyear, 2016, 2020))

#Next, we want to get the rest of the associated data for these patents; first, the associated International Patent classification Codes.
#We will get them from the women_ipc data frame. We need to joint our 'women_inventors_patents_5years' file with the 'women_ipc' data.

#We join the two datasets together using the 'inner_join' function and the equivalent patent id columns of each table.
women_inventor_patents_5y_with_ipc <- women_inventor_patents_5y %>% inner_join(women_ipc, by =c("id" = "patent_id"))

#We want to keep only ipc_maingroup (thus we get rid of all the other ipc related columns)
women_inventor_patents_5y_with_ipc <- women_inventor_patents_5y_with_ipc %>% select (-c(classification_level, ipc_subclass, section, ipc_class, subclass, main_group, subgroup, symbol_position, classification_value, classification_status, classification_data_source, action_date, ipc_version_indicator))

# to lighten up a bit the data set we filter out withdrawn patents
women_inventor_patents_5y_with_ipc  <- women_inventor_patents_5y_with_ipc  %>% filter(withdrawn == "0")


#Also to get the names of women inventors. We join our dataset with the women_inventors dataset by using the 'inner_joint' function and the equivalent patent id columns of each table.
women_inventor_patents_5y_with_ipc_invnames  <- women_inventor_patents_5y_with_ipc  %>% inner_join(women_inventors, by =c("inventor_id" = "id"))
#we have now colums "name_first" and "name_last" in our dataset

#Next, to get the names of patent assignees we have to use first the patent_assignee data frame to get the assignee id and then the assignee data frame to get the name of the assignee.
women_inventor_patents_5y_with_ipc_invnames_assign <- women_inventor_patents_5y_with_ipc_invnames  %>% inner_join(patent_assignee, by =c("id" = "patent_id"))
women_inventor_patents_5y_with_ipc_invnames_orgname <- women_inventor_patents_5y_with_ipc_invnames_assign  %>% inner_join(assignee, by =c("assignee_id" = "id"))

#finally, we only want to keep the most useful patent data fields (columns)
women_inventor_patents_5y_clean <- women_inventor_patents_5y_with_ipc_invnames_orgname %>% select(id, country, date, abstract, title, kind, ipc_maingroup, name_first.x, name_last.x, organization, patentsyear)


#but now we have many rows that are the same patent... we want to merge them and have a unique row per patent having a column with concatenated items separated by a semicolon.
women_inventor_patents_5y_merged <- women_inventor_patents_5y_clean %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(ipc_maingroup= paste(ipc_maingroup, collapse = ";"), country, date, abstract, title, kind, ipc_maingroup, name_first.x, name_last.x, organization, patentsyear)

#we finally remove all duplicated rows using the distinct function
women_inventor_patents_5y_distinct <- dplyr::distinct(women_inventor_patents_5y_merged)
#we unite inventors first and last name
women_inventor_patents_5y_mergedinvname <- unite(women_inventor_patents_5y_distinct, "inventor_name", c(name_first.x,name_last.x), sep = " ", remove = TRUE, na.rm = FALSE)

#finally we merge them to have unique patent ids with concatenated inventor names
women_inventor_patents_5y_unique <- women_inventor_patents_5y_mergedinvname %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(inventors= paste(inventor_name, collapse = ";"), country, date, abstract, title, kind, ipc_maingroup, organization, patentsyear)

#and we merge assignees with concatenated organization names
women_inventor_patents_5y_concassignees <- women_inventor_patents_5y_unique %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(country, date, title, abstract, ipc_maingroup, assignees = paste(organization, collapse = ";"), inventors, kind, patentsyear)


#Also we want to keep only granted patents, thus we get rid of plant varieties patents (kind codes P2 and P3) and we also remove reissued patents (kind codes E1 and E2)
women_inventor_patents_5y_noplantsnoreissued <- women_inventor_patents_5y_concassignees %>% subset(kind != "P3" & kind !="P2" & kind !="E2" & kind !="E1")

#we make sure again not to have duplicated rows
womeninventorpatents <- dplyr::distinct(women_inventor_patents_5y_noplantsnoreissued)

#we could save our data as rds with saveRDS
#saveRDS(womeninventorpatents, file = "data/women_inventor_patents_5y_final.rds", compress = "xz")

usethis::use_data(womeninventorpatents, overwrite = TRUE)

