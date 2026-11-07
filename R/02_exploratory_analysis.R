# Online Retail Analysis: Exploratory Analysis

library(tidyverse)
library(lubridate)
library(scales)

retail_clean <- readRDS("data/retail_clean.rds")

# Country revenue
country_revenue <- retail_clean |>
  group_by(Country) |>
  summarise(
    Transactions = n_distinct(Invoice),
    Units_Sold = sum(Quantity),
    Revenue = sum(TotalPrice),
    .groups = "drop"
  ) |>
  arrange(desc(Revenue)) |>
  slice_head(n = 10)

country_plot <- ggplot(country_revenue, aes(x = Revenue, y = reorder(Country, Revenue))) +
  geom_col(fill = "#356A93") +
  scale_x_continuous(labels = label_dollar()) +
  labs(title = "Top 10 Countries by Revenue", x = "Total Revenue", y = "Country") +
  theme_minimal(base_size = 12)

# International markets excluding the dominant UK market
international_revenue <- retail_clean |>
  filter(Country != "United Kingdom") |>
  group_by(Country) |>
  summarise(
    Transactions = n_distinct(Invoice),
    Units_Sold = sum(Quantity),
    Revenue = sum(TotalPrice),
    .groups = "drop"
  ) |>
  arrange(desc(Revenue)) |>
  slice_head(n = 10)

international_plot <- ggplot(
  international_revenue,
  aes(x = Revenue, y = reorder(Country, Revenue))
) +
  geom_col(fill = "#2878B5") +
  scale_x_continuous(labels = label_dollar()) +
  labs(
    title = "Top 10 International Markets by Revenue",
    subtitle = "United Kingdom excluded",
    x = "Total Revenue",
    y = "Country"
  ) +
  theme_minimal(base_size = 12)

# Product performance
nonproduct_items <- c(
  "Manual", "POSTAGE", "DOTCOM POSTAGE", "CARRIAGE",
  "AMAZON FEE", "Bank Charges", "ADJUST BAD DEBT"
)

product_performance <- retail_clean |>
  filter(
    !is.na(Description),
    Description != "",
    !Description %in% nonproduct_items
  ) |>
  group_by(StockCode, Description) |>
  summarise(
    Units_Sold = sum(Quantity),
    Revenue = sum(TotalPrice),
    Transactions = n_distinct(Invoice),
    .groups = "drop"
  )

top_products <- product_performance |>
  arrange(desc(Units_Sold)) |>
  slice_head(n = 10)

units_plot <- ggplot(top_products, aes(x = Units_Sold, y = reorder(Description, Units_Sold))) +
  geom_col(fill = "#73A95B") +
  scale_x_continuous(labels = label_comma()) +
  labs(title = "Top 10 Products by Units Sold", x = "Units Sold", y = "Product") +
  theme_minimal(base_size = 12)

top_revenue_products <- product_performance |>
  arrange(desc(Revenue)) |>
  slice_head(n = 10)

product_revenue_plot <- ggplot(
  top_revenue_products,
  aes(x = Revenue, y = reorder(Description, Revenue))
) +
  geom_col(fill = "#C46E4E") +
  scale_x_continuous(labels = label_dollar()) +
  labs(title = "Top 10 Products by Revenue", x = "Total Revenue", y = "Product") +
  theme_minimal(base_size = 12)

# Monthly performance
monthly_revenue <- retail_clean |>
  mutate(Month = floor_date(InvoiceDate, unit = "month")) |>
  group_by(Month) |>
  summarise(
    Revenue = sum(TotalPrice),
    Transactions = n_distinct(Invoice),
    Units_Sold = sum(Quantity),
    .groups = "drop"
  ) |>
  arrange(Month)

# Exclude incomplete beginning and ending months.
monthly_performance <- monthly_revenue |>
  filter(Month > min(Month), Month < max(Month)) |>
  mutate(Average_Order_Value = Revenue / Transactions)

monthly_revenue_plot <- ggplot(monthly_performance, aes(Month, Revenue)) +
  geom_line(color = "#356A93", linewidth = 1.2) +
  geom_point(color = "#C46E4E", size = 2.5) +
  scale_x_datetime(date_breaks = "3 months", date_labels = "%b %Y") +
  scale_y_continuous(labels = label_dollar()) +
  labs(
    title = "Monthly Online Retail Revenue",
    subtitle = "Incomplete beginning and ending months excluded",
    x = "Month",
    y = "Total Revenue"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

aov_plot <- ggplot(monthly_performance, aes(Month, Average_Order_Value)) +
  geom_line(color = "#6C5AA7", linewidth = 1.2) +
  geom_point(color = "#6C5AA7", size = 2.5) +
  scale_x_datetime(date_breaks = "3 months", date_labels = "%b %Y") +
  scale_y_continuous(labels = label_dollar()) +
  labs(
    title = "Monthly Average Order Value",
    subtitle = "Average revenue generated per transaction",
    x = "Month",
    y = "Average Order Value"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

transaction_volume_plot <- ggplot(monthly_performance, aes(Month, Transactions)) +
  geom_line(color = "#00A6A6", linewidth = 1.2) +
  geom_point(color = "#00A6A6", size = 2.5) +
  scale_x_datetime(date_breaks = "3 months", date_labels = "%b %Y") +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Monthly Transaction Volume",
    subtitle = "Number of unique customer orders per month",
    x = "Month",
    y = "Number of Transactions"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

revenue_transaction_correlation <- cor(
  monthly_performance$Transactions,
  monthly_performance$Revenue
)
print(revenue_transaction_correlation)

