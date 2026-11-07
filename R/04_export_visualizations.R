# Online Retail Analysis: Export Portfolio Visualizations

# Run scripts 01 through 03 before this file.

dir.create("outputs", showWarnings = FALSE)

ggsave("outputs/top_countries_revenue.png", country_plot, width = 9, height = 6, dpi = 300)
ggsave("outputs/international_markets.png", international_plot, width = 9, height = 6, dpi = 300)
ggsave("outputs/top_products_units.png", units_plot, width = 10, height = 6, dpi = 300)
ggsave("outputs/top_products_revenue.png", product_revenue_plot, width = 10, height = 6, dpi = 300)
ggsave("outputs/monthly_revenue.png", monthly_revenue_plot, width = 10, height = 6, dpi = 300)
ggsave("outputs/average_order_value.png", aov_plot, width = 10, height = 6, dpi = 300)
ggsave("outputs/transaction_volume.png", transaction_volume_plot, width = 10, height = 6, dpi = 300)
ggsave("outputs/elbow_method.png", elbow_plot, width = 8, height = 5, dpi = 300)
ggsave("outputs/customer_clusters.png", cluster_plot, width = 9, height = 6, dpi = 300)

message("Portfolio charts saved in the outputs folder.")

