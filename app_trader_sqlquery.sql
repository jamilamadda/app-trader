SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;










CREATE VIEW v_appstoreapps AS
WITH app_store_CTE AS (
    SELECT 'app_store' AS store,
	       name,
	       primary_genre,
		   rating,
	CASE WHEN price = 0.00 THEN 'Free'
	     ELSE 'paid' END AS type,
	CASE WHEN review_count::integer = 0 THEN 'No Reviews'
		     WHEN review_count::integer BETWEEN 1 AND 9999 THEN 'Less Than 10K'
			 WHEN review_count::integer BETWEEN 10000 AND 499000 THEN 'Between 10K and 500K'
			 WHEN review_count::integer BETWEEN 500000 AND 999000 THEN 'Between 500k and 1M'
			 ELSE 'Million Plus' END AS review_count,
	CASE WHEN content_rating ='17+' THEN  'Adults'
		     WHEN content_rating IN ('4+','9+') THEN 'Children'
			 WHEN content_rating ='12+'  THEN 'Teens'
			 ELSE 'Everyone'  END AS content_rating,		 
	12000 AS yearly_marketing_fees,
    CASE WHEN price*10000 < 25000 THEN 25000
	     ELSE ROUND(price*10000)::integer END AS acquisition_cost,
		 (1+rating*2)::integer AS lifespan,
		 ROUND(1000*rating*12)::integer AS annual_ROI
    FROM app_store_apps)
SELECT  'app_store' AS store,
        name,
        primary_genre,
        review_count,
		rating,
		content_rating,
		type,
		acquisition_cost,
		yearly_marketing_fees,
		lifespan,
        acquisition_cost + (yearly_marketing_fees * lifespan) AS lifetime_cost,
		annual_ROI,
	    annual_ROI * lifespan AS lifetime_revenue,
	   (annual_ROI * lifespan) - (acquisition_cost + (yearly_marketing_fees * lifespan) AS total_profit
FROM app_store_CTE
ORDER BY total_profit DESC;






DROP VIEW v_playstoreapps;


CREATE VIEW v_playstoreapps AS
WITH play_store_CTE AS (
    SELECT 'play_store' AS store,
	     name,
        genres,
		COALESCE(type,'Free') AS type,
        CASE WHEN review_count = 0 THEN 'No Reviews'
		     WHEN review_count BETWEEN 1 AND 9999 THEN 'Less Than 10K'
			 WHEN review_count BETWEEN 10000 AND 499000 THEN 'Between 10K and 500K'
			 WHEN review_count BETWEEN 500000 AND 999000 THEN 'Between 500k and 1M'
			 ELSE 'Million Plus' END AS review_count,
		CASE WHEN content_rating IN ('Mature 17+', 'Adults only 18+') THEN  'Adults'
		     WHEN content_rating = 'Everyone 10+' THEN 'Children'
			 WHEN content_rating = 'Teen' THEN 'Teens'
			 ELSE 'Everyone'  END AS content_rating,
	12000 AS yearly_marketing_fees,
    CASE WHEN REPLACE (price,'$','')::numeric*10000 < 25000 THEN 25000
	     ELSE REPLACE (price,'$','')::numeric*10000 END AS acquisition_cost,
		 COALESCE(rating,0) AS rating,
		 (1+(COALESCE(rating,0)*2))::integer AS lifespan,
		 ROUND(1000*(COALESCE(rating,0))*12)::integer AS annual_ROI
    FROM play_store_apps)
SELECT 'play_store' AS store,
        name,
        genres,
        review_count,
		rating,
		content_rating,
		type,
		acquisition_cost,
		yearly_marketing_fees,
		lifespan,
        acquisition_cost + (yearly_marketing_fees * lifespan) AS lifetime_cost,
		annual_ROI,
	    annual_ROI * lifespan AS lifetime_revenue,
	  (annual_ROI * lifespan) - (acquisition_cost + (yearly_marketing_fees * lifespan)) AS total_profit
FROM play_store_CTE
ORDER BY total_profit DESC



DROP VIEW v_union;

CREATE VIEW v_union AS
SELECT * 
FROM v_appstoreapps
UNION
SELECT *
FROM v_playstoreapps;












 



 















SELECT *
FROM v_union
WHERE name IN ('Tinder','Talking Ginger 2','Seven - 7 Minute Workout Training Challenge','myChevrolet','Fandango Movies - Times + Tickets','Paprika Recipe Manager','Premier League - Official App','NHL','NASCAR MOBILE','Whataburger','USAA Mobile','Microsoft Excel','iFunny :)','NBA','SONIC Drive-In','Chick-fil-A','Google Classroom','Trello','Wells Fargo Mobile','AMC','Pocket Yoga','AnatomyMapp','My Talking Pet','BET NOW - Watch Shows','DIRECTV','MTV','ASOS','Google Docs','Philips Hue','Yahoo Weather','Xbox','Citi MobileÂ®','Amex Mobile','Storm Shield','WatchESPN','Fitbit','Uber Driver','Dropbox','Verizon Cloud','ADP Mobile Solutions','Starbucks','Edmodo','NCAA Sports','Amazon Prime Video','Allrecipes Dinner Spinner','Muscle Premium - Human Anatomy','Kinesiology','Bones','My College Bookstore','Microsoft OneNote','Chase Mobile','STARZ','DoorDash - Food Delivery','Wish - Shopping Made Fun','Indeed Job Search','NFL','The EO Bar',
'Best Buy','Microsoft Word','Google Slides','SHOWTIME','Google Sheets','Redbox','U by BB&T','AirWatch Agent','Netflix','NBC Sports','WWE','Regal Cinemas','Microsoft PowerPoint','The CW','TED') AND total_profit > 3.9 AND lifespan = 10  AND rating = 4.5 AND content_rating = 'Everyone'



SELECT name,primary_genre,rating,lifespan,total_profit
FROM v_union
WHERE  name ILIKE 'Plants vs. Zombies' OR name ILIKE '%Glory Zombies Premium' OR name ILIKE '%zombie catchers%' AND total_profit <> 3.00;



SELECT  Distinct name,primary_genre,rating,type,lifespan,total_profit
FROM v_union
WHERE type= 'Free' AND (name ILIKE '% Bible,%'OR name ILIKE 'wikipedia%'  OR name ILIKE 'Period TRacker Clue%Ovulation tracker'  OR  name ILIKE 'Duolingo%more' OR name ILIKE '%whatscall free global phone call%' OR name ILIKE '%DU recorder%')
ORDER BY total_profit DESC, name ASC;




SELECT   name,primary_genre,rating,type,lifespan,total_profit
FROM v_union
WHERE type= 'Free' AND ( name ILIKE '%pinterest%' OR  name ILIKE 'App Lock%' OR name ILIKE '%clash of clans%' OR name ILIKE '%temple run 2%' ) AND total_profit <> 3.00
ORDER BY total_profit DESC, name ASC;

SELECT *
FROM v_union
