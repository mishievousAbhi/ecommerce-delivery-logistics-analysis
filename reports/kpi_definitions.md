# KPI Definitions — E-commerce Delivery & Logistics Performance Analysis

## 1. Purpose
This document defines the business meaning, formulas, denominators, assumptions, and validation rules for the project's logistics performance indicators.

All analytical implementations in Python, SQL, and Power BI should follow these definitions.

**Status:** These are the proposed canonical KPI definitions. Existing result files remain preliminary until reconciled and validated.

## 2. Shared Calculation Rules

### Order-Level Grain
Order-level KPIs must count distinct `order_id` values. Check order-ID uniqueness before calculating metrics.

### Timestamp Handling
- Parse timestamps consistently.
- Preserve missing and invalid timestamps as missing.
- Exclude records that do not satisfy a KPI's eligibility rules.
- Document the number of excluded records.
- Do not replace missing timestamps with zero or arbitrary dates.

### Delivery Eligibility
For delivery-timing metrics, an eligible order must have:
- A `delivered` order status.
- A valid actual delivery timestamp.
- A valid estimated delivery timestamp.

For delivery duration, a valid purchase timestamp is also required.

### Delivery Classification
- **On-time or early:** Actual delivery timestamp is less than or equal to the estimated delivery timestamp.
- **Late:** Actual delivery timestamp is later than the estimated delivery timestamp.

### Joins and Duplicates
Aggregate one-to-many tables, such as order items and reviews, to the required level before joining when necessary. Verify that joins do not multiply order-level records.

### Rounding
Retain full precision during calculations. Round results only for presentation, normally to two decimal places.

### Segment Comparisons
Report eligible order counts alongside rates. Flag small samples and avoid treating small groups as equally reliable as large groups.

## 3. KPI Definitions

### KPI 1: Total Orders
- **Objective:** Measure the number of distinct orders in the reporting population.
- **Formula:**
  $$\text{Total Orders} = \text{COUNT}(\text{DISTINCT } \text{order\_id})$$
- **Unit:** Orders.
- **Rules:**
  - Specify the reporting period and any status filters.
  - Compare source row counts with distinct order counts.
  - Investigate duplicate order IDs before publication.

### KPI 2: Delivered Orders
- **Objective:** Count orders recorded with a delivered status.
- **Formula:**
  $$\text{Delivered Orders} = \text{COUNT}(\text{DISTINCT } \text{order\_id} \text{ WHERE } \text{order\_status} = \text{'delivered'})$$
- **Unit:** Orders.
- **Rules:**
  - Normalize status values only through a documented rule.
  - Distinguish delivered-status orders from orders eligible for delivery-timing analysis.
  - Report missing timestamp counts separately.

### KPI 3: On-Time Delivery Rate
- **Objective:** Measure the percentage of eligible delivered orders delivered on or before the estimated delivery timestamp.
- **Formula:**
  $$\text{On-Time Delivery Rate (\%)} = \frac{\text{On-Time or Early Orders}}{\text{Eligible Delivered Orders}} \times 100$$
- **Numerator:** Eligible delivered orders where actual delivery is less than or equal to estimated delivery.
- **Denominator:** Delivered orders with valid actual and estimated delivery timestamps.
- **Unit:** Percentage.
- **Interpretation:** A higher rate indicates a larger share of eligible orders met the estimated delivery date.
- **Existing reference:** 88,644 / 96,470 = approximately 91.89%.
- **Validation:** Recalculate from the current source data before treating this figure as final.

### KPI 4: Late Delivery Rate
- **Objective:** Measure the percentage of eligible delivered orders delivered after the estimated delivery timestamp.
- **Formula:**
  $$\text{Late Delivery Rate (\%)} = \frac{\text{Late Orders}}{\text{Eligible Delivered Orders}} \times 100$$
- **Numerator:** Eligible delivered orders where actual delivery is later than estimated delivery.
- **Denominator:** The same eligible population used for the on-time delivery rate.
- **Unit:** Percentage.
- **Validation rules:**
  - On-time/early count plus late count must equal eligible delivered count.
  - On-time rate plus late rate should equal 100%, subject to rounding.
- **Existing reference:** 7,826 / 96,470 = approximately 8.11%.

### KPI 5: Cancellation Rate
- **Objective:** Measure the proportion of placed orders recorded as cancelled.
- **Formula:**
  $$\text{Cancellation Rate (\%)} = \frac{\text{Cancelled Orders}}{\text{Total Eligible Orders}} \times 100$$
- **Default denominator:** All distinct placed orders in the selected reporting population, including cancelled orders.
- **Numerator:** Distinct orders whose normalized status corresponds to a cancelled order.
- **Unit:** Percentage.
- **Assumptions and rules:**
  - Inspect the actual status values before implementing the filter.
  - Check spelling variations such as `canceled` and `cancelled`.
  - Document the reporting population and treatment of missing statuses.
  - Use the same numerator and denominator in Python and SQL.
- **Existing reference:** 625 / 99,441 = approximately 0.63%.
  *This value requires validation against the source data.*

### KPI 6: Average Delivery Duration
- **Objective:** Measure the average elapsed time from order purchase to actual customer delivery.
- **Formula:**
  $$\text{Average Delivery Duration} = \text{Mean}(\text{actual\_delivery\_timestamp} - \text{order\_purchase\_timestamp})$$
- **Unit:** Days.
- **Eligible population:**
  - Delivered orders.
  - Valid purchase timestamps.
  - Valid actual delivery timestamps.
  - Actual delivery timestamps not earlier than purchase timestamps.
- **Rules:**
  - Use actual customer delivery as the end timestamp.
  - Do not substitute estimated delivery timestamps.
  - Report the eligible count and excluded records.
- **Existing reference:** 12.56 days.
  *Recalculate under the agreed eligibility rules before final publication.*

### KPI 7: Average Signed Delivery Variance
- **Objective:** Measure the average difference between actual and estimated delivery timestamps across eligible delivered orders.
- **Formula:**
  $$\text{Average Signed Variance} = \text{Mean}(\text{actual\_delivery\_timestamp} - \text{estimated\_delivery\_timestamp})$$
- **Unit:** Days.
- **Interpretation:**
  - **Negative:** Orders were delivered earlier than estimated.
  - **Zero:** Delivery occurred at the estimated time.
  - **Positive:** Orders were delivered later than estimated.
- **Important:** This metric includes both early and late deliveries. It is not equivalent to average lateness among late orders.
- **Existing reference:** One existing comparison report records -11.18 days. Reconcile this value against the source population and implementation before publication.

### KPI 8: Average Lateness Among Late Orders
- **Objective:** Measure the average delay for late deliveries only.
- **Formula:**
  $$\text{Average Lateness} = \text{Mean}(\text{actual\_delivery\_timestamp} - \text{estimated\_delivery\_timestamp})$$
  *(Calculate the mean only for eligible delivered orders where actual delivery is later than estimated delivery.)*
- **Unit:** Days.
- **Rules:**
  - Exclude on-time and early deliveries.
  - Report the number of late orders used.
  - Ensure the result is positive for valid observations.
  - Label the metric explicitly as average lateness among late orders.
  - A value of 9.55 days appeared in an earlier README, but it has not been verified by the supplied KPI comparison report.

### KPI 9: Order-to-Carrier-Handoff Duration
- **Objective:** Measure the elapsed time between purchase and the recorded carrier handoff.
- **Formula:**
  $$\text{Handoff Duration} = \text{carrier\_handoff\_timestamp} - \text{order\_purchase\_timestamp}$$
- **Required fields:**
  - `order_purchase_timestamp`
  - `order_delivered_carrier_date`
- **Unit:** Days.
- **Rules:**
  - Exclude invalid or negative intervals.
  - Report missing timestamps.
  - Document the eligible population.
- **Limitation:** This interval is not automatically equivalent to warehouse processing time. It may include approval, seller preparation, packaging, and other operational stages.

### KPI 10: Customer Review Score by Delivery Outcome
- **Objective:** Compare average customer review scores between on-time/early and late deliveries.
- **Formula:**
  Calculate the mean order-level review score separately for each delivery-outcome group.
- **Required fields:**
  - `order_id`
  - `review_score`
  - Actual delivery timestamp.
  - Estimated delivery timestamp.
- **Rules:**
  - Multiple reviews may exist for an order.
  - Establish one consistent order-level review aggregation rule.
  - Report review coverage and the number of matched orders in each group.
  - Document missing review scores and unmatched orders.
- **Existing reference:**
  - On-time/early deliveries: 4.29.
  - Late deliveries: 2.57.
  *These values are preliminary because review counts differ across existing analysis outputs.*
- **Interpretation:** Differences indicate an association between delivery outcome and review score, not proof that delivery timing caused the difference.

### KPI 11: Regional Delivery Performance
- **Objective:** Compare delivery reliability across customer states or other available geographic groups.
- **Formula:**
  $$\text{Regional On-Time Rate (\%)} = \frac{\text{Regional On-Time Orders}}{\text{Regional Eligible Delivered Orders}} \times 100$$
- **Required fields:**
  - Order identifier.
  - Customer-to-order relationship.
  - Customer state or another documented geographic attribute.
  - Required delivery timestamps.
- **Rules:**
  - Validate customer-to-order joins.
  - Display eligible order counts for each region.
  - Use the same delivery eligibility rules across regions.
  - Flag small samples.
- **Limitations:** Customer state does not establish route distance, carrier identity, or the cause of a delay.

### KPI 12: Carrier Performance
- **Objective:** Compare delivery reliability, cancellation rates, and delays by carrier.
- **Potential measures:**
  - On-time delivery rate.
  - Late delivery rate.
  - Average delivery duration.
  - Average lateness.
  - Cancellation rate, where cancellation attribution is available.
- **Required field:** A reliable carrier identifier linked to the relevant order or shipment.
- **Current limitation:** The currently included orders table does not contain a carrier name or identifier.
- Do not publish carrier rankings unless a valid carrier field is obtained and documented.

### KPI 13: Freight Cost Measures
- **Objective:** Measure shipping costs associated with order items.
- **Total Freight Value:**
  $$\text{Total Freight Value} = \sum \text{freight\_value}$$
  *Calculate over the defined order-item population.*
- **Freight as a Percentage of Product Sales:**
  $$\text{Freight-to-Sales Ratio (\%)} = \frac{\sum \text{freight\_value}}{\sum \text{price}} \times 100$$
  *Handle missing values and zero sales explicitly.*
- **Average Freight per Order:**
  First aggregate freight values to one total per order, then calculate the average across eligible orders.
- **Important:** The order-items table can contain multiple records for an order. Item-level and order-level denominators must not be interchanged.

## 4. Cross-Tool Validation Rules
Before marking a KPI as validated:
1. Use the same dataset snapshot and reporting period.
2. Apply identical status filters and eligibility criteria.
3. Confirm source row counts and distinct order counts.
4. Reconcile KPI numerators and denominators separately.
5. Verify joins do not multiply order-level records.
6. Compare unrounded results across Python and SQL.
7. Investigate discrepancies before updating the dashboard.
8. Record the validation date, source version, results, and unresolved differences.
9. Confirm Power BI calculations follow the documented definitions.

## 5. Known Issues Requiring Follow-Up
- Existing artifacts contain different average-delay statistics.
- Cancellation SQL validation remains incomplete.
- Customer review counts differ across notebook outputs.
- Some audit reports reference datasets absent from the current repository snapshot.
- Existing SQL scripts use MySQL-specific syntax.
- The data audit script references `Data/raw`, whereas the repository directory is `data/raw`.

*Resolve these issues before presenting the affected metrics as final validated results.*

## 6. Governance
This document serves as the project's KPI definition reference.

Any change to a KPI formula, denominator, eligibility rule, or aggregation method should be documented and applied consistently across Python, SQL, notebooks, and Power BI.
