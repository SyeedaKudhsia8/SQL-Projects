-- 1. Products with base price > 500 and Promo Type = 'BOGOF'

SELECT DISTINCT p.product_name, p.category, p.base_price, c.promo_type
FROM fact_events f
JOIN dim_products p ON f.product_code = p.product_code
JOIN dim_campaigns c ON f.campaign_id = c.campaign_id
WHERE p.base_price > 500 AND c.promo_type = 'BOGOF';


-- 2. Number of stores in each city (sorted by count)

SELECT city, COUNT(store_id) AS store_count
FROM dim_stores
GROUP BY city
ORDER BY store_count DESC;


-- 3. Revenue before and after each campaign (in millions)

SELECT 
    c.campaign_name,
    ROUND(SUM(CASE 
        WHEN f.event_date < c.start_date THEN p.base_price
        ELSE 0 
    END) / 1000000, 2) AS revenue_before_promotion_mn,
    
    ROUND(SUM(CASE 
        WHEN f.event_date >= c.start_date AND f.event_date <= c.end_date THEN p.base_price
        ELSE 0 
    END) / 1000000, 2) AS revenue_after_promotion_mn

FROM fact_events f
JOIN dim_products p ON f.product_code = p.product_code
JOIN dim_campaigns c ON f.campaign_id = c.campaign_id
WHERE f.event_type = 'purchase'
GROUP BY c.campaign_name;


-- 4. Incremental Sold Quantity (ISU%) per category for Diwali

WITH sold_data AS (
    SELECT 
        p.category,
        SUM(CASE 
            WHEN f.event_date < c.start_date THEN 1
            ELSE 0 
        END) AS qty_before,
        
        SUM(CASE 
            WHEN f.event_date >= c.start_date AND f.event_date <= c.end_date THEN 1
            ELSE 0 
        END) AS qty_after
    FROM fact_events f
    JOIN dim_products p ON f.product_code = p.product_code
    JOIN dim_campaigns c ON f.campaign_id = c.campaign_id
    WHERE f.event_type = 'purchase'
      AND c.campaign_name = 'Diwali'
    GROUP BY p.category
)

SELECT 
    category,
    ROUND((qty_after - qty_before) * 100.0 / NULLIF(qty_before, 0), 2) AS isu_percent,
    RANK() OVER (ORDER BY (qty_after - qty_before) * 1.0 / NULLIF(qty_before, 0) DESC) AS rank_order
FROM sold_data;


-- 5. Top 5 products by Incremental Revenue Percentage (IR%)

WITH revenue_data AS (
    SELECT 
        p.product_name,
        p.category,
        SUM(CASE 
            WHEN f.event_date < c.start_date THEN p.base_price
            ELSE 0 
        END) AS revenue_before,
        
        SUM(CASE 
            WHEN f.event_date >= c.start_date AND f.event_date <= c.end_date THEN p.base_price
            ELSE 0 
        END) AS revenue_after
    FROM fact_events f
    JOIN dim_products p ON f.product_code = p.product_code
    JOIN dim_campaigns c ON f.campaign_id = c.campaign_id
    WHERE f.event_type = 'purchase'
    GROUP BY p.product_name, p.category
)

SELECT 
    product_name,
    category,
    ROUND((revenue_after - revenue_before) * 100.0 / NULLIF(revenue_before, 0), 2) AS ir_percent
FROM revenue_data
ORDER BY ir_percent DESC
LIMIT 5;

-- 6. Top 10 Stores by Incremental Revenue
SELECT 
    e.store_id,
    s.city,
    SUM((e.quantity_sold_after_promo - e.quantity_sold_before_promo) * e.base_price) AS incremental_revenue
FROM fact_events e
JOIN dim_stores s ON e.store_id = s.store_id
WHERE e.event_type = 'purchase'
GROUP BY e.store_id, s.city
ORDER BY incremental_revenue DESC
LIMIT 10;

-- 7. Bottom 10 Stores by Incremental Sold Units
SELECT 
    e.store_id,
    s.city,
    SUM(e.quantity_sold_after_promo - e.quantity_sold_before_promo) AS incremental_sold_units
FROM fact_events e
JOIN dim_stores s ON e.store_id = s.store_id
WHERE e.event_type = 'purchase'
GROUP BY e.store_id, s.city
ORDER BY incremental_sold_units ASC
LIMIT 10;

-- 8. Store Performance by City
SELECT 
    s.city,
    AVG((e.quantity_sold_after_promo - e.quantity_sold_before_promo) * e.base_price) AS avg_incremental_revenue,
    AVG(e.quantity_sold_after_promo - e.quantity_sold_before_promo) AS avg_incremental_sold_units
FROM fact_events e
JOIN dim_stores s ON e.store_id = s.store_id
WHERE e.event_type = 'purchase'
GROUP BY s.city
ORDER BY avg_incremental_revenue DESC;

-- 9. Top 2 Promotion Types by Incremental Revenue
SELECT 
    e.promo_type,
    SUM((e.quantity_sold_after_promo - e.quantity_sold_before_promo) * e.base_price) AS incremental_revenue
FROM fact_events e
WHERE e.event_type = 'purchase'
GROUP BY e.promo_type
ORDER BY incremental_revenue DESC
LIMIT 2;

-- 10. Bottom 2 Promotion Types by Incremental Sold Units
SELECT 
    e.promo_type,
    SUM(e.quantity_sold_after_promo - e.quantity_sold_before_promo) AS incremental_sold_units
FROM fact_events e
WHERE e.event_type = 'purchase'
GROUP BY e.promo_type
ORDER BY incremental_sold_units ASC
LIMIT 2;

-- 11. Comparison: Discount vs BOGOF vs Cashback
SELECT 
    promo_type,
    SUM((quantity_sold_after_promo - quantity_sold_before_promo) * base_price) AS incremental_revenue,
    SUM(quantity_sold_after_promo - quantity_sold_before_promo) AS incremental_sold_units
FROM fact_events
WHERE event_type = 'purchase'
GROUP BY promo_type;

-- 12. Best Balanced Promotions (IR and ISU)
SELECT 
    promo_type,
    SUM((quantity_sold_after_promo - quantity_sold_before_promo) * base_price) AS incremental_revenue,
    SUM(quantity_sold_after_promo - quantity_sold_before_promo) AS incremental_sold_units,
    ROUND(
        SUM((quantity_sold_after_promo - quantity_sold_before_promo) * base_price) / 
        NULLIF(SUM(quantity_sold_after_promo - quantity_sold_before_promo), 0), 2
    ) AS revenue_per_unit
FROM fact_events
WHERE event_type = 'purchase'
GROUP BY promo_type
ORDER BY revenue_per_unit DESC;

-- 13. Category Lift and Promotion Effect
SELECT 
    p.category,
    e.promo_type,
    SUM(e.quantity_sold_after_promo - e.quantity_sold_before_promo) AS incremental_units,
    ROUND(
        SUM((e.quantity_sold_after_promo - e.quantity_sold_before_promo) * e.base_price), 2
    ) AS incremental_revenue
FROM fact_events e
JOIN dim_products p ON e.product_code = p.product_code
WHERE e.event_type = 'purchase'
GROUP BY p.category, e.promo_type
ORDER BY incremental_units DESC;
