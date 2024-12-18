CREATE OR REPLACE VIEW vw_most_comments AS
SELECT n.title AS "title", COUNT(nc.news_id) AS "comments_number"
FROM news n INNER JOIN news_comment nc ON n.news_id=nc.news_id
GROUP BY n.title
ORDER BY "comments_number" DESC;
/
CREATE OR REPLACE VIEW vw_newsletter AS
SELECT r.email
FROM reg_user r
WHERE r.email_subscription=1;
/
CREATE OR REPLACE VIEW vw_races_in_countries AS
SELECT t.country, r.title, m.motorsport_name, r.race_date_start, r.race_date_end
FROM race r INNER JOIN track t ON r.track_id=t.track_id
            INNER JOIN motorsport m ON r.motorsport_id=m.motorsport_id
ORDER BY t.country DESC;
/
CREATE OR REPLACE VIEW vw_errors AS
SELECT *
FROM database_log dl
WHERE dl.log_type='E'
