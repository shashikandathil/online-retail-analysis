# Online Retail Analysis: Data Import and Cleaning

required_packages <- c("tidyverse", "lubridate", "scales")
new_packages <- required_packages[!required_packages %in% installed.packages()[, "Package"]]
if (length(new_packages) > 0) install.packages(new_packages)

library(tidyverse)
library(lubridate)
library(scales)

# Change this only if the downloaded CSV has a different filename.
dataset_file <- "data/online_retail_II.csv"

online_retail <- readr::read_csv(
  dataset_file,
  show_col_types = FALSE
)

glimpse(online_retail)
dim(online_retail)
summary(online_retail)

# Standardize column names used throughout the project.
names(online_retail) <- names(online_retail) |>
  stringr::str_replace_all(" ", "_")

# Clean transaction data and create transaction revenue.
retail_clean <- online_retail |>
  mutate(
    InvoiceDate = lubridate::parse_date_time(
      InvoiceDate,
      orders = c("mdy HM", "mdy HMS", "dmy HM", "dmy HMS")
    )
  ) |>
  filter(
    !is.na(Customer_ID),
    !stringr::str_starts(Invoice, "C"),
    Quantity > 0,
    Price > 0,
    !is.na(InvoiceDate)
  ) |>
  mutate(TotalPrice = Quantity * Price)

cat("Original dimensions:", dim(online_retail), "\n")
cat("Clean dimensions:", dim(retail_clean), "\n")
summary(retail_clean)

saveRDS(retail_clean, "data/retail_clean.rds")

