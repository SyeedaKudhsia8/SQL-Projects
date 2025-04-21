-- 1. Average occupancy percentage across all properties

SELECT AVG(occupancy_percent) AS avg_occupancy FROM property_details;

-- 2. Asset manager with the highest average occupancy

SELECT am.name, AVG(pd.occupancy_percent) AS avg_occupancy
       FROM asset_managers am
       JOIN property_details pd ON am.manager_id = pd.manager_id
       GROUP BY am.name
       ORDER BY avg_occupancy DESC
       LIMIT 1;

-- 3. Total gross value managed by each asset manager

SELECT am.name, SUM(pd.gross_value) AS total_gross_value
       FROM asset_managers am
       JOIN property_details pd ON am.manager_id = pd.manager_id
       GROUP BY am.name;

-- 4. Properties with occupancy below 85%

SELECT * FROM property_details WHERE occupancy_percent < 85;

-- 5. Distribution of occupancy percentage by property type

SELECT pt.property_type, AVG(pd.occupancy_percent) AS avg_occupancy
       FROM property_types pt
       JOIN property_details pd ON pt.type_id = pd.type_id
       GROUP BY pt.property_type;

-- 6. Properties with occupancy above comparable

SELECT * FROM property_details
       WHERE occupancy_percent > comparable_percent;

-- 7. Average vacant square footage by property type

SELECT pt.property_type, AVG(pd.vacant_sqft) AS avg_vacant_sqft
       FROM property_types pt
       JOIN property_details pd ON pt.type_id = pd.type_id
       GROUP BY pt.property_type;

-- 8. Top 5 properties by gross value

SELECT property_name, gross_value
       FROM property_details
       ORDER BY gross_value DESC
       LIMIT 5;

-- 9. Compare occupancy % and comparable %

SELECT property_name, occupancy_percent, comparable_percent,
              (occupancy_percent - comparable_percent) AS diff
       FROM property_details;

-- 10. Properties with occupancy % below comparable % by more than 10%

SELECT property_name, occupancy_percent, comparable_percent
       FROM property_details
       WHERE (comparable_percent - occupancy_percent) > 10;