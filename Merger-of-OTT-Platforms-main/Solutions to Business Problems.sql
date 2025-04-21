-- Strategic Questions

-- 1. Total Users & Growth Trends (Jan–Nov 2024)

SELECT 
  platform,
  TO_CHAR(join_date, 'YYYY-MM') AS month,
  COUNT(*) AS new_users
FROM users
WHERE join_date BETWEEN '2024-01-01' AND '2024-11-30'
GROUP BY platform, TO_CHAR(join_date, 'YYYY-MM')
ORDER BY platform, month;


-- 2. Content Library Comparison (By Language & Type)

SELECT 
  platform,
  language,
  content_type,
  COUNT(*) AS total_content
FROM content_library
GROUP BY platform, language, content_type
ORDER BY platform, total_content DESC;


-- 3. User Demographics (Age, City Tier, Subscription Plan)

SELECT 
  platform,
  age_group,
  city_tier,
  subscription_plan,
  COUNT(*) AS user_count
FROM users
GROUP BY platform, age_group, city_tier, subscription_plan
ORDER BY platform, user_count DESC;


-- 4. Active vs Inactive Users by Age & Plan

SELECT 
  platform,
  subscription_plan,
  age_group,
  activity_status,
  COUNT(*) AS users
FROM users
GROUP BY platform, subscription_plan, age_group, activity_status
ORDER BY platform, users DESC;


-- 5. Average Watch Time by Platform, City Tier & Device Type

SELECT 
  platform,
  city_tier,
  device_type,
  ROUND(AVG(watch_time_minutes), 2) AS avg_watch_time
FROM user_watch_sessions
WHERE watch_date BETWEEN '2024-01-01' AND '2024-11-30'
GROUP BY platform, city_tier, device_type
ORDER BY platform, avg_watch_time DESC;


-- 6. Inactivity Correlation with Watch Time

SELECT 
  u.user_id,
  u.platform,
  u.activity_status,
  COUNT(s.session_id) AS sessions,
  COALESCE(SUM(s.watch_time_minutes), 0) AS total_watch_time
FROM users u
LEFT JOIN user_watch_sessions s ON u.user_id = s.user_id
GROUP BY u.user_id, u.platform, u.activity_status
ORDER BY total_watch_time;


-- 7. Downgrade Trends

SELECT 
  platform,
  old_plan,
  new_plan,
  COUNT(*) AS downgrade_count
FROM plan_changes
WHERE change_type = 'downgrade'
GROUP BY platform, old_plan, new_plan
ORDER BY downgrade_count DESC;


-- 8. Upgrade Patterns

SELECT 
  platform,
  old_plan,
  new_plan,
  COUNT(*) AS upgrade_count
FROM plan_changes
WHERE change_type = 'upgrade'
GROUP BY platform, old_plan, new_plan
ORDER BY upgrade_count DESC;


-- 9. Paid User Distribution by City Tier

SELECT 
  platform,
  city_tier,
  subscription_plan,
  COUNT(*) AS user_count
FROM users
WHERE subscription_plan IN ('Basic', 'Premium', 'VIP')
GROUP BY platform, city_tier, subscription_plan
ORDER BY platform, city_tier, user_count DESC;


-- 10. Revenue Analysis (Jan–Nov 2024)

WITH revenue_data AS (
  SELECT 
    pc.platform,
    pc.user_id,
    pc.new_plan,
    pc.change_date,
    DATE_PART('month', AGE('2024-11-30', pc.change_date)) + 1 AS active_months,
    CASE 
      WHEN pc.new_plan = 'Basic' THEN 69
      WHEN pc.new_plan = 'VIP' THEN 159
      WHEN pc.new_plan = 'Premium' AND pc.platform = 'LioCinema' THEN 129
      WHEN pc.new_plan = 'Premium' AND pc.platform = 'Jotstar' THEN 359
      ELSE 0
    END AS monthly_price
  FROM plan_changes pc
  WHERE pc.change_date BETWEEN '2024-01-01' AND '2024-11-30'
)
SELECT 
  platform,
  new_plan,
  SUM(active_months * monthly_price) AS total_revenue
FROM revenue_data
GROUP BY platform, new_plan
ORDER BY total_revenue DESC;


-- Insightful Enquiries

-- 1. Identify Inactive User Segments for Engagement Campaigns
SELECT 
  platform,
  age_group,
  subscription_plan,
  city_tier,
  COUNT(*) AS inactive_users
FROM users
WHERE activity_status = 'Inactive'
GROUP BY platform, age_group, subscription_plan, city_tier
ORDER BY inactive_users DESC;

-- 🔍 Insight:
-- Focus reactivation strategies on inactive users in Tier 2/3 cities with Free/Basic plans,
-- especially among 25-34 and 35-44 age groups.

------------------------------------------------------------

-- 2. Identify Most Engaged User Profiles for Brand Campaigns
SELECT 
  u.platform,
  u.age_group,
  u.city_tier,
  u.subscription_plan,
  ROUND(AVG(s.watch_time_minutes), 2) AS avg_watch_time
FROM users u
JOIN user_watch_sessions s ON u.user_id = s.user_id
GROUP BY u.platform, u.age_group, u.city_tier, u.subscription_plan
ORDER BY avg_watch_time DESC
LIMIT 10;

-- 🔍 Insight:
-- Most loyal users are from Tier 1 cities on Premium/VIP plans aged 25–34.
-- These should be your primary targets for brand ambassador and retention campaigns.

------------------------------------------------------------

-- 3. Subscription Pricing Strategy & Revenue Contribution
WITH plan_value AS (
  SELECT 
    subscription_plan,
    COUNT(*) AS user_count,
    CASE 
      WHEN subscription_plan = 'Free' THEN 0
      WHEN subscription_plan = 'Basic' THEN 100
      WHEN subscription_plan = 'VIP' THEN 200
      WHEN subscription_plan = 'Premium' THEN 300
      ELSE 0
    END AS price
  FROM users
  GROUP BY subscription_plan
)
SELECT 
  subscription_plan,
  user_count,
  price,
  user_count * price AS estimated_monthly_revenue
FROM plan_value
ORDER BY estimated_monthly_revenue DESC;

-- 🔍 Insight:
-- Premium and VIP plans contribute the majority of the revenue.
-- Consider bundling Basic plan upgrades and running limited-time Premium trials.

------------------------------------------------------------

-- 4. Identify Telecom Partnership Hotspots by City Tier
SELECT 
  platform,
  city_tier,
  COUNT(*) AS users
FROM users
GROUP BY platform, city_tier
ORDER BY users DESC;

-- 🔍 Insight:
-- Tier 2 and Tier 3 cities have untapped potential for expansion.
-- Target these for telecom-based subscription bundles.

------------------------------------------------------------

-- 5. Personalization Model Training: Most Watched Genres
SELECT 
  platform,
  content_category,
  COUNT(*) AS views
FROM user_watch_sessions s
JOIN content_library c ON s.content_id = c.content_id
GROUP BY platform, content_category
ORDER BY views DESC;

-- 🔍 Insight:
-- Train recommendation engines to prioritize top genres like Action, Romance, and Drama.
-- Tailor content promotion emails and banners based on past genre interactions.

------------------------------------------------------------

-- 6. Top Genres by City Tier to Choose Brand Ambassador
SELECT 
  u.city_tier,
  c.genre,
  COUNT(*) AS views
FROM user_watch_sessions s
JOIN users u ON s.user_id = u.user_id
JOIN content_library c ON s.content_id = c.content_id
GROUP BY u.city_tier, c.genre
ORDER BY city_tier, views DESC;

