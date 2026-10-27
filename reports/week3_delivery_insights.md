# Week 3: Deeper Analysis & Operational Opportunity Assessment

## 1. Project Overview

**Project:** E-commerce Delivery & Logistics Performance Analysis

**Objective:** Analyze weekday-wise cancellations, delivery delays, processing time, transit time, and data quality to identify operational improvement opportunities.

## 2. Weekday-wise Cancellation Analysis

| Order Day | Total Orders | Cancelled Orders | Cancellation Rate |
|---|---:|---:|---:|
| Sunday | 11,960 | 68 | 0.57% |
| Monday | 16,196 | 115 | 0.71% |
| Tuesday | 15,963 | 112 | 0.70% |
| Wednesday | 15,552 | 96 | 0.62% |
| Thursday | 14,761 | 100 | 0.68% |
| Friday | 14,122 | 72 | 0.51% |
| Saturday | 10,887 | 62 | 0.57% |

**Finding:** Monday recorded the highest cancellation rate (0.71%), while Friday recorded the lowest (0.51%).

## 3. Weekday-wise Delivery Performance

| Order Day | Delivered Orders | Average Delay (Days) | Late Delivery Rate |
|---|---:|---:|---:|
| Sunday | 11,632 | -12.39 | 7.49% |
| Monday | 15,701 | -11.30 | 9.05% |
| Tuesday | 15,502 | -11.69 | 8.49% |
| Wednesday | 15,074 | -11.90 | 7.80% |
| Thursday | 14,322 | -12.00 | 7.57% |
| Friday | 13,684 | -11.67 | 8.45% |
| Saturday | 10,555 | -12.50 | 7.60% |

**Finding:** Monday had the highest late-delivery rate (9.05%), while Sunday had the lowest (7.49%). Negative average delay indicates that actual delivery was earlier than the estimated date on average.

## 4. Processing Time vs Transit Time

| Metric | Average Duration |
|---|---:|
| Purchase to carrier handover | 3.21 days |
| Carrier handover to customer delivery | 9.31 days |
| Eligible orders | 96,281 |

**Finding:** The carrier-to-customer stage took longer on average than the purchase-to-carrier stage. Further investigation of transit performance is recommended. This comparison does not establish the cause of delays.

## 5. Data Quality Validation

| Validation Metric | Result |
|---|---:|
| Total orders | 99,441 |
| Delivered orders | 96,478 |
| Cancelled orders | 625 |
| Missing purchase dates | 0 |
| Delivered orders without actual delivery date | 8 |
| Delivered orders without estimated delivery date | 0 |

**Finding:** Eight delivered orders have no actual delivery date and should be excluded from calculations requiring that timestamp, with the exclusion documented.

## 6. Prioritized Operational Issues

1. **Late delivery:** Investigate why Monday orders have a higher late-delivery rate.
2. **Transit duration:** Review available shipment and delivery-stage data to understand the longer carrier-to-customer duration.
3. **Cancellations:** Investigate the elevated Monday cancellation rate.
4. **Data quality:** Review the eight delivered records missing actual delivery dates.

## 7. Operational Recommendations

- Compare delivery outcomes across available regions, product categories, and other supported dimensions.
- Investigate shipment-level records before attributing delays to a carrier or region.
- Monitor weekday cancellation and late-delivery rates over time.
- Document missing timestamps and exclusions in the analytical workflow.
- Validate segment-level results against overall order totals before making decisions.

## 8. Limitations

- Weekday comparisons show associations and do not prove causation.
- Findings are limited to the fields available in the dataset.
- Processing and transit durations were calculated only for records with valid, sequential timestamps.
- Operational causes require further investigation before corrective actions can be confirmed.

## 9. Week 3 Deliverables

- SQL scripts for weekday cancellation and delivery analysis.
- Processing-versus-transit duration analysis.
- Overall data-quality validation.
- Prioritized operational issues and draft recommendations.

## 10. Next Steps

Proceed to Week 4: build the Power BI dashboard, validate dashboard totals against the analytical results, and prepare the final operational report and presentation.
