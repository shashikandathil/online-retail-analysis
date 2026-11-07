# Online Retail Customer and Sales Analysis in R

## Project overview

This project analyzes more than one million online retail transaction records to identify sales trends, leading products and markets, and meaningful customer segments. The analysis was completed in R using data cleaning, exploratory analysis, RFM modeling, k-means clustering, and business-focused visualizations.

## Business questions

- Which countries generate the most revenue?
- Which products lead in unit sales and revenue?
- How do revenue, transaction volume, and average order value change over time?
- Can customers be grouped according to purchasing behavior?
- What actions could the retailer take based on the findings?

## Dataset

The project uses the **Online Retail II UCI** dataset, available from [Kaggle](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci). It contains transaction-level records with invoice number, product, quantity, date, price, customer identifier, and country.

The original dataset is not included in this repository because of its size. Download the CSV file and place it inside the `data/` folder.

## Tools and packages

- R and RStudio
- `tidyverse`
- `lubridate`
- `scales`
- `cluster`
- `factoextra`

## Workflow

1. Imported and inspected 1,067,371 transaction records.
2. Removed missing customer identifiers, cancellations, invalid quantities, and nonpositive prices.
3. Created transaction revenue as `Quantity * Price`.
4. Compared revenue across countries and products.
5. evaluated monthly revenue, transaction volume, and average order value.
6. Built customer-level Recency, Frequency, and Monetary measures.
7. Standardized the RFM variables and applied k-means clustering.
8. Converted the results into business findings and recommendations.

## Selected findings

- Revenue rises sharply during the September–November holiday-shopping period.
- The United Kingdom dominates overall revenue, so international markets were also analyzed separately.
- EIRE and the Netherlands are the strongest international markets in the dataset.
- Products with the highest unit sales are not always the products producing the most revenue.
- Average order value and transaction volume contribute differently to monthly revenue changes.
- RFM segmentation provides a practical basis for targeted retention and marketing strategies.

## Repository structure

```text
online-retail-portfolio/
├── README.md
├── online-retail-analysis.Rproj
├── R/
│   ├── 01_data_cleaning.R
│   ├── 02_exploratory_analysis.R
│   ├── 03_rfm_segmentation.R
│   └── 04_export_visualizations.R
├── data/
│   └── README.md
├── outputs/
└── report/
```

## How to run the project

1. Download or clone this repository.
2. Open `online-retail-analysis.Rproj` in RStudio.
3. Download the dataset and place the CSV file in `data/`.
4. If necessary, update `dataset_file` in `R/01_data_cleaning.R` to match the CSV filename.
5. Run the scripts in numerical order.

## Business recommendations

- Prepare inventory and campaigns before the September–November seasonal increase.
- Evaluate the United Kingdom and international markets separately to prevent the largest market from masking other opportunities.
- Use both revenue and unit volume when making product decisions.
- Target high-value and loyal customer segments with retention programs.
- Develop reactivation campaigns for customers with high recency values.

## Résumé description

Analyzed more than one million online retail transactions in R, performed data cleaning and customer RFM segmentation, and developed market, product, and time-series visualizations that produced actionable business recommendations.

