B03 PRACTICE DATA - PARCEL DELIVERY OPERATIONS

Modeling traps:
- shipments is one row per shipment.
- shipment_events is one row per event: do NOT join it directly and then sum shipment revenue.
- monthly_targets is one row per month-destination_region: do NOT multiply target values through shipment rows.
- customer_tags is one row per customer-tag and can require a bridge/many-to-many design.
- shipments has three business date roles: booking, pickup, delivery.

Use control_totals.json for raw reconciliation.
