CREATE TABLE applestore_description_combined AS 
SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4

-- with the following query I checked the number of unique id's from our table 

SELECT COUNT(DISTINCT id) AS uniqueAppId
FROM AppleStore

SELECT COUNT(DISTINCT id) AS uniqueAppId
FROM applestore_description_combined

-- Finding missing values in our tables keyfields 

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL

SELECT COUNT(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc IS NULL

-- Now we finding the No. of Apps per genre

SELECT prime_genre, COUNT(*) AS Num_of_Apps
FROM AppleStore
GROUP BY prime_genre
ORDER BY Num_of_Apps DESC

-- Lookingfor an overview for the app ratings

SELECT min(user_rating) AS MinUserRating,
	   max(user_rating) AS MaxUserRating,
       avg(user_rating) AS AvgUserRating
FROM AppleStore

-- Count Num of apps that are more than $10 

SELECT id,
	   price,
       track_name
FROM AppleStore
WHERE price > 10
ORDER BY price DESC

-- see if paid apps have more ratings than free apps

SELECT CASE 
			WHEN price > 0 THEN ' Paid'
            ELSE 'free'
          END AS App_type,
          avg(user_rating) AS Avg_rating
FROM AppleStore
GROUP BY App_type

-- Check if apps with more languages have higher ratings

SELECT CASE 
			WHEN lang_num < 10 THEN ' < 10 languages '
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
          END AS language_backet,
          avg(user_rating) AS Avg_rating
FROM AppleStore
GROUP BY language_backet
ORDER BY Avg_rating DESC

-- Now we check Apps with lower ratings

SELECT prime_genre,
	   avg(user_rating) AS Avg_rating
FROM AppleStore
Group By prime_genre
ORDER BY Avg_rating ASC
LIMIT 10

-- Check correlation between app descriptio and user ratings

SELECT CASE 
		WHEN Length(b.app_desc) < 500 THEN 'short'
        WHEN Length(b.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
        ELSE 'long'
     END AS description_length_backet,
     avg(a.user_rating) AS average_rating
FROM 
	AppleStore AS a
JOIN 
	applestore_description_combined AS b
On
	a.id = b.id
GROUP BY description_length_backet
ORDER BY average_rating DESC

-- Top rating apps for each genre 

SELECT prime_genre,
	   track_name,
       user_rating
FROM ( SELECT 
       prime_genre,
	   track_name,
       user_rating,
       RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
       FROM AppleStore
      ) AS a
WHERE a.rank = 1      
      
    
        

          
