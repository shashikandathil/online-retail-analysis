# Online Retail Analysis: RFM Customer Segmentation

library(tidyverse)
library(lubridate)
library(cluster)
library(factoextra)

retail_clean <- readRDS("data/retail_clean.rds")
reference_date <- max(retail_clean$InvoiceDate) + days(1)

rfm_data <- retail_clean |>
  group_by(Customer_ID) |>
  summarise(
    Recency = as.numeric(difftime(reference_date, max(InvoiceDate), units = "days")),
    Frequency = n_distinct(Invoice),
    Monetary = sum(TotalPrice),
    .groups = "drop"
  )

rfm_scaled <- scale(rfm_data |> select(Recency, Frequency, Monetary))

set.seed(123)
wss <- map_dbl(1:10, function(k) {
  kmeans(rfm_scaled, centers = k, nstart = 25)$tot.withinss
})

elbow_data <- tibble(Clusters = 1:10, WSS = wss)
elbow_plot <- ggplot(elbow_data, aes(Clusters, WSS)) +
  geom_line(color = "#356A93", linewidth = 1.1) +
  geom_point(color = "#C46E4E", size = 2.5) +
  scale_x_continuous(breaks = 1:10) +
  labs(title = "Elbow Method for Selecting k", x = "Number of Clusters", y = "Within-Cluster Sum of Squares") +
  theme_minimal(base_size = 12)

# Adjust centers if the elbow plot supports a different value.
selected_k <- 4
set.seed(123)
rfm_model <- kmeans(rfm_scaled, centers = selected_k, nstart = 25)
rfm_data$Cluster <- factor(rfm_model$cluster)

cluster_profiles <- rfm_data |>
  group_by(Cluster) |>
  summarise(
    Customers = n(),
    Average_Recency = mean(Recency),
    Average_Frequency = mean(Frequency),
    Average_Monetary = mean(Monetary),
    Total_Revenue = sum(Monetary),
    .groups = "drop"
  )

print(cluster_profiles)

pca_model <- prcomp(rfm_scaled)
pca_scores <- as_tibble(pca_model$x[, 1:2]) |>
  mutate(Cluster = rfm_data$Cluster)

cluster_plot <- ggplot(pca_scores, aes(PC1, PC2, color = Cluster)) +
  geom_point(alpha = 0.55, size = 1.5) +
  labs(
    title = "Customer Segments Based on RFM Behavior",
    subtitle = "Two-dimensional PCA view of k-means clusters",
    x = "Principal Component 1",
    y = "Principal Component 2"
  ) +
  theme_minimal(base_size = 12)

write_csv(rfm_data, "outputs/customer_rfm_segments.csv")
write_csv(cluster_profiles, "outputs/customer_cluster_profiles.csv")

