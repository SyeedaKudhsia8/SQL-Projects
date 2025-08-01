-- Hotel Reservation Analysis with SQL 

USE hotel_database;

-- 1. What is the total number of reservations in the dataset? 
SELECT 
      COUNT(*) AS TOTAL_RESERVATIONS
FROM  
      hotel_reservation; 
      
      
-- 2. Which meal plan is the most popular among guests? 
SELECT 
      type_of_meal_plan AS 'popular meal plan',
      COUNT(*) AS COUNT
FROM  
	  hotel_reservation
WHERE 
      type_of_meal_plan <> 'Not Selected'
GROUP BY 
      type_of_meal_plan
ORDER BY
      COUNT DESC
LIMIT 1;


-- 3. What is the average price per room for reservations involving children?  
SELECT 
      ROUND(AVG(avg_price_per_room),2) AS 'average_price/room with children'
FROM 
      hotel_reservation
WHERE 
     no_of_children > 0;


-- 4. How many reservations were made for the year 2017 ? 
SELECT 
    COUNT(*) AS total_reservations_2017
FROM 
    hotel_reservation
WHERE 
    YEAR(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 2017;
    

-- 5. What is the most commonly booked room type?  
SELECT 
      room_type_reserved AS 'most common room type',
      COUNT(*) AS count 
FROM 
     hotel_reservation
GROUP BY 
	 room_type_reserved
ORDER BY 
     count DESC
LIMIT 1;


-- 6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?  

SELECT 
      COUNT(*) AS 'reservation on weekends'
FROM
     hotel_reservation
WHERE 
     no_of_weekend_nights > 0;


-- 7. What is the highest and lowest lead time for reservations?  
SELECT 
	 MAX(lead_time) AS 'highest lead time',
     MIN(lead_time) AS 'lowest lead time'
FROM 
     hotel_reservation ;


-- 8. What is the most common market segment type for reservations? 
SELECT
      market_segment_type AS 'most common market type',
      COUNT(*) AS count 
FROM 
	  hotel_reservation
GROUP BY 
      market_segment_type
ORDER BY  
	  count  DESC
LIMIT 1;


-- 9. How many reservations have a booking status of "Confirmed"? 

SELECT 
	 COUNT(*) AS 'NO. OF BOOKING STATUS CONFIRMED'
FROM 
     hotel_reservation
WHERE 
     booking_status = 'Not_Canceled';
     

-- 10. What is the total number of adults and children across all reservations?  

SELECT 
      SUM(no_of_adults) AS 'total no. of adults',
      SUM(no_of_children) AS 'total no. of children',
      SUM(no_of_adults) + SUM(no_of_children) AS 'TOTAL'
FROM 
     hotel_reservation;
     

-- 11. What is the average number of weekend nights for reservations involving children?  

SELECT
      AVG(no_of_weekend_nights) AS 'average no of reservation at weekend nights'
FROM 
    hotel_reservation
WHERE 
	no_of_weekend_nights > 0 AND no_of_children > 0;
    

-- 12. How many reservations were made in each month of the year? 
SELECT
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 1 THEN 1 ELSE 0 END) AS January,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 2 THEN 1 ELSE 0 END) AS February,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 3 THEN 1 ELSE 0 END) AS March,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 4 THEN 1 ELSE 0 END) AS April,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 5 THEN 1 ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 6 THEN 1 ELSE 0 END) AS June,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 7 THEN 1 ELSE 0 END) AS July,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 8 THEN 1 ELSE 0 END) AS August,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 9 THEN 1 ELSE 0 END) AS September,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 10 THEN 1 ELSE 0 END) AS October,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 11 THEN 1 ELSE 0 END) AS November,
    SUM(CASE WHEN MONTH(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 12 THEN 1 ELSE 0 END) AS December
FROM 
    hotel_reservation;
    
-- 13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?
SELECT
    room_type_reserved AS room_type,
    AVG(
        CASE WHEN no_of_weekend_nights > 0 THEN no_of_weekend_nights ELSE 0 END
        + CASE WHEN no_of_week_nights > 0 THEN no_of_week_nights ELSE 0 END
    ) AS avg_nights_total
FROM hotel_reservation
WHERE room_type_reserved IN ('Room_Type 1', 'Room_Type 2', 'Room_Type 4', 'Room_Type 5', 'Room_Type 6', 'Room_Type 7')
GROUP BY room_type_reserved
ORDER BY room_type_reserved;


-- 14. For reservations involving children, what is the most common room type, and what is the average price for that room type?  
SELECT 
      room_type_reserved AS 'common room type with child',
      COUNT(*) AS count,
      AVG(avg_price_per_room) AS average_price_per_room
FROM 
    hotel_reservation
WHERE 
    no_of_children > 0
GROUP BY
    room_type_reserved
ORDER BY 
    count DESC
LIMIT 1;


-- 15. Find the market segment type that generates the highest average price per room.  
SELECT 
    market_segment_type,
    AVG(avg_price_per_room) AS average_price_per_room
FROM 
    hotel_reservation
GROUP BY 
    market_segment_type
ORDER BY 
    average_price_per_room DESC
LIMIT 1;












