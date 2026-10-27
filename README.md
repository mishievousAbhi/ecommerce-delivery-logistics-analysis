# E-commerce Delivery & Logistics Performance Analysis

## Project Overview
This project analyzes e-commerce delivery and logistics performance using the public Olist Brazilian E-Commerce dataset. It focuses on delivery reliability, order cancellations, delivery duration, shipping costs, regional performance, and customer review scores.

The objective is to identify measurable operational service gaps and provide data-driven recommendations for improving logistics performance and customer satisfaction.

The analysis distinguishes observed relationships from proven causes and uses only the variables available in the dataset.

## Project Objectives
- Measure on-time delivery rates, cancellation rates, delivery duration, and delivery delays.
- Identify delivery performance patterns across customer states, weekdays, and product categories where the required fields are available.
- Examine the relationship between delivery outcomes and customer review scores.
- Analyze freight costs and order-level logistics expenses.
- Validate KPI calculations across Python, SQL, and Power BI.
- Develop an interactive dashboard and evidence-based operational recommendations.

## Dataset and Source
- **Dataset:** Olist Brazilian E-Commerce Public Dataset
- **Source:** Kaggle — Brazilian E-Commerce Public Dataset by Olist.

The dataset contains interconnected records covering orders, customers, products, order items, and customer reviews.

### Source Files
The current repository snapshot includes the following six CSV files:

| File | Purpose |
| --- | --- |
| `olist_orders_dataset.csv` | Order status and order-related timestamps |
| `olist_customers_dataset.csv` | Customer identifiers and geographic information |
| `olist_order_items_dataset.csv` | Products, prices, and freight values associated with orders |
| `olist_order_reviews_dataset.csv` | Customer review scores and review records |
| `olist_products_dataset.csv` | Product information and categories |
| `product_category_name_translation.csv` | Product category translations |

**Data handling:** Original datasets are stored in `data/raw/` and should remain unchanged. Intermediate transformations belong in `data/interim/`, and analysis-ready outputs belong in `data/processed/`.

The source dataset contains additional files that are not included in the current repository snapshot. Analysis must use only available files unless additional datasets are obtained and documented.

Check the original dataset's licensing and usage terms before redistributing source data.

## Technology Stack
| Technology | Purpose |
| --- | --- |
| Python | Data analysis and KPI calculations |
| Pandas | Data manipulation and aggregation |
| NumPy | Numerical operations |
| Matplotlib | Data visualization |
| Seaborn | Statistical visualization |
| Jupyter Notebook | Exploratory data analysis |
| SQL | Data validation and KPI aggregation |
| Power BI | Interactive dashboard |
| Git and GitHub | Version control and collaboration |

The repository's SQL scripts use MySQL-specific syntax. A compatible MySQL environment is required unless the queries are adapted and tested for another database.

## Project Methodology

### 1. Data Inspection
- Examine dataset structure, columns, data types, and record counts.
- Identify missing values and duplicate identifiers.
- Inspect order statuses and timestamp fields.
- Review relationships between orders, customers, products, and reviews.

### 2. Data Quality and Preparation
- Parse date-time columns consistently.
- Validate timestamp sequences and delivery eligibility.
- Inspect join cardinality before combining datasets.
- Aggregate one-to-many tables where necessary to prevent duplicated order counts.
- Document exclusions and preserve original data.

### 3. KPI Engineering
- Calculate the project's core performance indicators using documented definitions and denominators.
- These include:
  - Total orders.
  - Delivered orders.
  - On-time delivery rate.
  - Late delivery rate.
  - Cancellation rate.
  - Average delivery duration.
  - Average signed delivery variance.
  - Average lateness among late orders.
  - Customer review scores by delivery outcome.
  - Regional delivery performance.
  - Freight cost measures.
- Refer to [reports/kpi_definitions.md](reports/kpi_definitions.md) for formulas, assumptions, and validation rules.

### 4. Exploratory Analysis
- Analyze available data to identify patterns in:
  - Delivery performance.
  - Order volume over time.
  - Regional delivery outcomes.
  - Product category performance.
  - Freight costs.
  - Customer review scores.
- Comparisons should include sample counts and must not be interpreted as causal relationships without supporting evidence.

### 5. KPI Validation
- Compare Python and SQL calculations.
- Verify KPI numerators and denominators.
- Investigate discrepancies in record counts and calculations.
- Validate dashboard measures against the analytical results.
- Document unresolved inconsistencies.

### 6. Dashboard and Reporting
- Use Power BI to communicate logistics performance through KPI cards, trend charts, regional comparisons, delay analysis, and customer experience metrics where supported by the data.

## Repository Structure
```text
ecommerce-delivery-logistics-analysis/
├── README.md
├── requirements.txt
├── data/
│   ├── raw/
│   ├── interim/
│   └── processed/
├── notebooks/
│   ├── 01_data_inspection.ipynb
│   ├── 02_eda.ipynb
│   └── 02_delivery_performance_analysis.ipynb
├── src/
│   └── data_audit.py
├── sql/
│   ├── schema.sql
│   ├── data_validation.sql
│   └── delivery_kpis.sql
└── reports/
    ├── kpi_definitions.md
    ├── week2_progress.md
    ├── E-commerce_Logistics_Dashboard.pbix
    ├── E-commerce_Logistics_Dashboard.pdf
    └── figures and analysis outputs
```
*This is a logical overview of the repository. Refer to the actual folder contents for the complete file inventory.*

## Preliminary Analytical Results
The existing project artifacts contain the following reference values. These figures are preliminary and must be reconciled against the source data and KPI definitions before final submission.

| Metric | Existing Reference |
| --- | --- |
| Total orders | 99,441 |
| Delivered-status orders | 96,478 |
| Eligible delivered records | 96,470 |
| On-time or early delivery rate | 91.89% |
| Late delivery rate | 8.11% |
| Average delivery duration | 12.56 days |
| Cancellation rate | Approximately 0.63% |
| Average review score for on-time/early deliveries | 4.29 |
| Average review score for late deliveries | 2.57 |

> **Important:** The existing artifacts contain inconsistencies in average-delay calculations, cancellation validation, and customer review counts. These values must not be treated as independently validated final results until the underlying calculations have been reconciled.

## Setup Instructions

### Prerequisites
- Python 3.9 or later.
- Git.
- Jupyter Notebook.
- A compatible MySQL environment for the supplied SQL scripts.
- Power BI Desktop to open and inspect the dashboard.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/mishievousAbhi/ecommerce-delivery-logistics-analysis.git
   cd ecommerce-delivery-logistics-analysis
   ```
2. Create a virtual environment:
   ```bash
   python -m venv .venv
   ```
3. Activate it on Windows PowerShell:
   ```powershell
   .\.venv\Scripts\Activate.ps1
   ```
4. Install the dependencies:
   ```bash
   python -m pip install --upgrade pip
   pip install -r requirements.txt
   ```
5. Launch Jupyter Notebook:
   ```bash
   jupyter notebook
   ```
   Start with `notebooks/01_data_inspection.ipynb`, followed by the relevant exploratory and delivery-performance notebooks.

Verify notebook paths and dependencies before execution. Some existing notebooks may rely on intermediate files generated by earlier steps.

## Dashboard
The repository includes:
- `reports/E-commerce_Logistics_Dashboard.pbix`

Suggested dashboard sections:
- **Executive Overview:** Order volume, delivery reliability, cancellations, and delivery duration.
- **Regional Performance:** Delivery metrics grouped by customer state, with sample counts.
- **Delay Diagnostics:** Delivery patterns by weekday and product category where supported.
- **Customer Experience:** Review score comparisons by delivery outcome.
- **Freight Analysis:** Freight costs and order-level shipping expenses.

Carrier-specific analysis requires a reliable carrier identifier. The currently included orders table does not contain this field.

## Project Limitations
- The current repository snapshot includes six raw CSV files; existing audit reports reference additional datasets that are not present.
- The orders table does not provide a carrier identifier or explicit route distance.
- Purchase-to-carrier-handoff duration is a proxy interval and should not automatically be interpreted as warehouse processing time.
- Multiple review records may exist for an order, requiring a documented aggregation rule.
- Missing timestamps must not be treated as zero-duration or automatically classified as on-time.
- Regional and customer-review differences indicate associations, not proof of causation.
- Historical dataset results may not represent current logistics performance.
- Average signed delivery variance and average lateness among late orders are different metrics and must be reported separately.

## Version Control and Team Contributions
Use Git and GitHub to maintain a clear history of project development.

Examples of meaningful commit messages:
- `docs: update project objectives and methodology`
- `docs: define KPI formulas and assumptions`
- `analysis: validate delivery performance calculations`
- `reports: reconcile Python and SQL KPI results`

Record team contributions using actual commits, pull requests, and task-tracker evidence.

## Four-Week Project Plan
| Week | Focus | Key Deliverables |
| --- | --- | --- |
| Week 1 | Data ingestion and validation | Data-quality audit, cleaned interim data, initial EDA |
| Week 2 | KPI engineering and delay analysis | KPI definitions, validated KPI dataset, segment comparisons |
| Week 3 | Deeper analysis | Prioritized service gaps and operational recommendations |
| Week 4 | Dashboard and reporting | Final dashboard, operational report, and presentation |

## Project Status
The project is progressing through its four-week implementation plan. Week 2 documentation is maintained in [reports/week2_progress.md](reports/week2_progress.md).

Outstanding KPI validation issues should be resolved before the final analytical report and dashboard are submitted.
