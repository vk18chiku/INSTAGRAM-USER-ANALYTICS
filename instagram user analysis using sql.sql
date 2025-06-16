-- Q1-> Loyal User Reward: The marketing team wants to reward the most loyal users, i.e., those who have been using the platform for the longest time.
-- Your Task: Identify the five oldest users on Instagram from the provided database.

-- SOLUTION->
SELECT username,created_at 
FROM instagram_user.users 
order by created_at ASC LIMIT 5;

-- QUESTION 2-> Inactive User Engagement: The team wants to encourage inactive users to start posting by sending them promotional emails.
-- Your Task: Identify users who have never posted a single photo on Instagram.

-- SOLUTION->
SELECT id,username from instagram_user.users where id 
not in (SELECT user_id from instagram_user.photos);


-- QUESTION 3-> Contest Winner Declaration: The team has organized a contest where the user with the most likes on a single photo wins.
-- Your Task: Determine the winner of the contest and provide their details to the team

-- SOLUTION->
-- THIS TABLES GIVES ME THE PHOTO ID WITH THE COUNT OF LIKE PHOTOS
select photo_id,COUNT(*) as 'count_of_like_photo' 
from instagram_user.likes
group by photo_id;

-- IT GIVES US THE PHOTO_ID WITH MAXIMUM COUNT OF LIKE PHOTOS

select photo_id from (select photo_id,COUNT(*) 
as 'count_of_like_photo' from instagram_user.likes
group by photo_id) as t where 
count_of_like_photo=(select max(count_of_like_photo) 
from (select photo_id,COUNT(*) as 'count_of_like_photo' from instagram_user.likes
group by photo_id) as r);

-- THIS QUERY GIVES US THE USER ID WITH MAXIMUM COUNT OF PHOTO LIKE

select user_id from instagram_user.photos 
where id=(select photo_id from 
(select photo_id,COUNT(*) as 'count_of_like_photo' from instagram_user.likes
group by photo_id) as t where count_of_like_photo=(select max(count_of_like_photo) 
from (select photo_id,COUNT(*) as 'count_of_like_photo' from instagram_user.likes
group by photo_id) as r));


-- NOW THIS IS THE FINAL QUERY WHICH GIVES US THE NAME OF THE WINNER WITH HIS USER ID

select id,username from instagram_user.users where 
id=(select user_id from instagram_user.photos where id=(select photo_id 
from (select photo_id,COUNT(*) as 'count_of_like_photo' from instagram_user.likes
group by photo_id) as t where count_of_like_photo=(select max(count_of_like_photo) 
from (select photo_id,COUNT(*) as 'count_of_like_photo' from instagram_user.likes
group by photo_id) as r)));

-- QUESTION 4-> A partner brand wants to know the most popular hashtags to use in their posts to reach the most people.
-- Your Task: Identify and suggest the top five most commonly used hashtags on the platform.

-- SOLUTION->
-- TAG ID WITH THEIR COUNTS
SELECT tag_id,count(*) as 'count_of_tags' from instagram_user.photo_tags group by tag_id;

-- 5 TAG ID WITH MAXIMUM COUNTS
select tag_id from  (SELECT tag_id,count(*) as 'count_of_tags' from instagram_user.photo_tags group by tag_id
order by count_of_tags desc limit 5) as t;

-- NAME OF ALL 5 TAG ID (FINAL QUERY)
select id,tag_name from instagram_user.tags WHERE id in 
(select tag_id from  (SELECT tag_id,count(*) as 'count_of_tags' from 
instagram_user.photo_tags group by tag_id order by count_of_tags desc limit 5) as t);

-- QUESTION 5->
-- Ad Campaign Launch: The team wants to know the best day of the week to launch ads.
-- Your Task: Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.

-- CREATE A TABLE WITH DAY_NAME
SELECT created_at,dayname(created_at) as 'day_name' from instagram_user.users;

-- DAY NAME WITH COUNT OF DAYS
select day_name,count(*) as 'count_of_days' from (SELECT created_at,dayname(created_at) 
as 'day_name' from instagram_user.users) as t
group by day_name ;

-- RETURN THE DAY WITH MAXIMUM COUNTS (FINAL QUERY)
select day_name from (select day_name,count(*) as 'count_of_days' 
from (SELECT created_at,dayname(created_at) as 'day_name' from instagram_user.users) as t
group by day_name) as r where count_of_days=(select max(count_of_days) from 
(select day_name,count(*) as 'count_of_days' 
from (SELECT created_at,dayname(created_at) as 'day_name' from instagram_user.users) as t
group by day_name) as p);


-- QUESTION 6 ->
-- Investors want to know if users are still active and posting on Instagram or if they are making fewer posts.
-- Your Task: Calculate the average number of posts per user on Instagram. Also, provide the total number of photos 
-- on Instagram divided by the total number of users.

-- SOLUTION -> 
-- GIVES A TABLE WITH USER_ID AND THEIR COUNT OF POST
SELECT user_id,count(*) as 'count_of_post' from instagram_user.photos group by user_id;

-- GIVES US TOTAL COUNT OF POST
select count(*) as 'total_counts' from (SELECT user_id,count(*) as 'count_of_post' from 
instagram_user.photos group by user_id) as m;

-- RETURN A TABLE WITH USER_ID AND THEIR AVERAGE POST (FINAL QUERY)
select user_id,(count_of_post)/(select count(*) as 'total_counts' 
from (SELECT user_id,count(*) as 'count_of_post' 
from instagram_user.photos group by user_id) as m) * 100 as 'average_post'
from (SELECT user_id,count(*) as 'count_of_post' from 
instagram_user.photos group by user_id) as v;

-- TOTAL NUMBER OF PHOTOS
SELECT count(distinct(id)) as 'total_photos'  from instagram_user.photos;

-- TOTAL USERS
SELECT count(distinct(id)) as 'total_users'  from instagram_user.users; 

-- TOTAL NUMBER OF PHOTOS / TOTAL USERS
select 
(SELECT count(distinct(id)) as 'total_photos'  from instagram_user.photos) /
(SELECT count(distinct(id)) as 'total_users'  from instagram_user.users) as 'photos/users'
from (SELECT count(distinct(id)) as 'total_photos'  from instagram_user.photos) as y;

-- QUESTION 7 -> 
-- Investors want to know if the platform is crowded with fake and dummy accounts.
-- Your Task: Identify users (potential bots) who have liked every single photo on the site,
--  as this is not typically possible for a normal user.

-- SOLUTION ->
-- TOTAL COUNT OF DISTINCT PHOTO ID
SELECT count(DISTINCT(photo_id)) as 'distinct_photo_id' from instagram_user.likes;

-- USER ID WITH TOTAL LIKES COUNT
select user_id,count(*) as 'likes_count' from instagram_user.likes group by user_id;

--  RETURN  TOTAL COUNT OF DISTINCT PHOTO ID = USER ID WITH TOTAL LIKES COUNT
select user_id from (select user_id,count(*) as 'likes_count' from 
instagram_user.likes group by user_id) as t
where likes_count=(SELECT count(DISTINCT(photo_id)) as 
'distinct_photo_id' from instagram_user.likes);

-- RETURN THE NAMES AND ID OF BOTS AND FAKE ACCOUNTS THIS IS THE FINAL QUERY
select id,username from instagram_user.users where
id in (select user_id from (select user_id,count(*) as 
'likes_count' from instagram_user.likes group by user_id) as t
where likes_count=(SELECT count(DISTINCT(photo_id)) as 
'distinct_photo_id' from instagram_user.likes))
















