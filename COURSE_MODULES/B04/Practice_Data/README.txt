B04 PRACTICE CASE - URBAN MOBILITY ANALYTICS

Use the raw files to design an analytical platform.
Important grain differences:
- rides: one row per ride
- payments: one row per payment
- ride_events: one row per event
- monthly targets: one row per month-city
- driver_profile_changes: one row per change event
- driver_tags: one row per driver-tag membership

Do not flatten different grains and then trust totals.
Decide where surrogate keys, SCD logic, layers, lineage and quality controls belong.
