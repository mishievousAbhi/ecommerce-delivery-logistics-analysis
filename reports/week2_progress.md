# Week 2 Progress Log

- **Project:** E-commerce Delivery & Logistics Performance Analysis
- **Role:** GitHub Management and Documentation
- **Reporting Period:** Week 2 — October 2026
- **Status:** Week 2 work session completed for today

## 1. Week 2 Objectives
The primary objectives were to:
- Establish consistent definitions for logistics performance indicators.
- Document KPI formulas, denominators, and assumptions.
- Review existing analytical outputs for consistency.
- Identify delivery-delay patterns and potential operational service gaps.
- Document dataset provenance and project limitations.
- Maintain clear and reproducible project documentation.

## 2. Project Artifacts Reviewed
| Area | Repository Evidence | Status |
| --- | --- | --- |
| Data inspection | `notebooks/01_data_inspection.ipynb` | Existing artifact; audit requires reconciliation |
| Exploratory analysis | `notebooks/02_eda.ipynb` | Existing analysis; results require reproducibility checks |
| Delivery performance | `notebooks/02_delivery_performance_analysis.ipynb` | Existing KPI analysis; validation remains necessary |
| SQL KPI calculations | `sql/delivery_kpis.sql` | Existing implementation; reconcile with Python |
| KPI comparison | `reports/sql_python_kpi_comparison.csv` | Existing comparison; discrepancies remain |
| Data quality | `reports/data_quality_summary.csv` and `reports/column_quality_details.csv` | Existing reports; dataset inventory needs verification |
| Dashboard | `reports/E-commerce_Logistics_Dashboard.pbix` | Existing dashboard; KPI validation required |
| Project documentation | `README.md` | Updated to document objectives, methodology, data source, and limitations |
| KPI documentation | `reports/kpi_definitions.md` | Created to define formulas and calculation rules |

## 3. Preliminary Analytical Reference Values
The following values appear in existing project artifacts. They are reference values and should not be considered final validated results until reconciled.

| Metric | Existing Reference |
| --- | --- |
| Total orders | 99,441 |
| Delivered-status orders | 96,478 |
| Eligible delivered records | 96,470 |
| On-time or early delivery rate | 91.89% |
| Late delivery rate | 8.11% |
| Average delivery duration | 12.56 days |
| Cancellation rate | Approximately 0.63% |
| On-time/early average review score | 4.29 |
| Late-delivery average review score | 2.57 |

## 4. Issues Identified
- **Dataset Inventory:** The current repository snapshot contains six CSV files in `data/raw/`, while some existing audit reports refer to nine source files.
  - *Action:* Re-run the data-quality audit against the files actually present.
- **Average Delivery Delay:** Existing artifacts report an average signed delivery variance of -11.18 days. An earlier README also reported 9.55 days for late deliveries. These statistics represent different metrics and must be calculated separately.
  - *Action:* Recalculate the signed average variance and the average lateness among late orders.
- **Cancellation Rate:** The existing Python and SQL comparison does not fully validate the cancellation calculation.
  - *Action:* Verify the source status values, numerator, denominator, and reporting population.
- **Customer Reviews:** Review counts differ across notebook outputs.
  - *Action:* Establish one order-level review aggregation rule and reconcile the number of matched orders.
- **Carrier Analysis:** The current orders table does not contain a carrier identifier.
  - *Action:* Avoid carrier-specific rankings until a reliable carrier field becomes available.
- **SQL Compatibility:** The supplied SQL scripts use MySQL-specific syntax.
  - *Action:* Execute them in a compatible environment or adapt and test them before using another database.
- **Data Audit Script:** The audit script references `Data/raw`, whereas the repository uses `data/raw`.
  - *Action:* Correct the path inconsistency and verify the script runs from the documented project root.

## 5. Documentation Deliverables
- [x] Review the existing README and repository artifacts.
- [x] Document project objectives, dataset provenance, technology stack, and methodology.
- [x] Establish KPI formulas, denominators, assumptions, and calculation rules.
- [x] Record preliminary analytical reference values with appropriate qualifications.
- [x] Document known limitations and outstanding validation issues.
- [x] Prepare the Week 2 progress report.

*Completion note: These checkboxes refer to the documentation work represented by this report. They do not indicate that every underlying analytical result has been independently validated.*

## 6. Next Steps
1. Re-run the data-quality audit using the available source files.
2. Reconcile Python, SQL, and Power BI KPI calculations.
3. Verify cancellation-rate calculations.
4. Recalculate average signed delivery variance and late-only average lateness.
5. Standardize customer review aggregation and reconcile review counts.
6. Correct the data-audit script's path inconsistency.
7. Validate dashboard totals against the canonical KPI definitions.
8. Record actual contributor names, dates, commits, and pull requests in the team tracker.

## 7. Evidence and References
- GitHub repository: [https://github.com/mishievousAbhi/ecommerce-delivery-logistics-analysis](https://github.com/mishievousAbhi/ecommerce-delivery-logistics-analysis)
- KPI definitions: [reports/kpi_definitions.md](reports/kpi_definitions.md)
- Dashboard: [reports/E-commerce_Logistics_Dashboard.pbix](reports/E-commerce_Logistics_Dashboard.pbix)
- KPI comparison: [reports/sql_python_kpi_comparison.csv](reports/sql_python_kpi_comparison.csv)
- Data-quality summary: [reports/data_quality_summary.csv](reports/data_quality_summary.csv)
- Column-level quality details: [reports/column_quality_details.csv](reports/column_quality_details.csv)

## 8. Week 2 Summary
Week 2 documentation establishes a common reference for logistics KPIs and records the current state of the project's analytical artifacts.

The next priority is to reconcile the identified inconsistencies so that the final dashboard and operational recommendations are based on consistent, reproducible calculations.
