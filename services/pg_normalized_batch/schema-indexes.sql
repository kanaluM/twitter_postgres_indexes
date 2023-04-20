BEGIN;

ALTER TABLE tweet_tags SET (parallel_workers = 30);
ALTER TABLE tweets SET (parallel_workers = 30);
SET max_parallel_maintenance_workers TO 4;
SET maintenance_work_mem TO '8 GB';


-- Problem 1
/*
 * SELECT count(distinct id_tweets)
 * FROM tweet_tags
 * WHERE tag='#coronavirus'; 
 */
CREATE INDEX ON tweet_tags(tag, id_tweets);



-- Problem 2
/* SELECT
    tag,
    count(*) as count
FROM (
    SELECT DISTINCT
        id_tweets,
        t2.tag
    FROM tweet_tags t1
    JOIN tweet_tags t2 USING (id_tweets)
    WHERE t1.tag='#coronavirus'
      AND t2.tag LIKE '#%'
) t
GROUP BY (1)
ORDER BY count DESC,tag
LIMIT 1000;
*/
-- Don't think you need anything because this 
-- query also just uses the same columns as above
-- count(*) cannot be in an index


-- Problem 3
/* SELECT
    lang,
    count(DISTINCT id_tweets) as count
FROM tweet_tags
JOIN tweets USING (id_tweets)
WHERE tag='#coronavirus'
GROUP BY lang
ORDER BY count DESC,lang;
*/
CREATE INDEX ON tweets(lang, id_tweets);


-- Problem 4
/* 
 SELECT
    count(*)
FROM tweets
WHERE to_tsvector('english',text)@@to_tsquery('english','coronavirus')
  AND lang='en';
*/
CREATE INDEX ON tweets USING rum(
to_tsvector(‘english’, text)
RUM_TSVECTO(_) ADDON_OPS,
lang)
WITH (ATTACH=‘lang’, TO=’tp_ts_vector(‘’english’’, text)’)’;

CREATE INDEX ON tweets USING gin(to_tsvector(‘english’, text), lang);

--Problem 5
/* 
SELECT
    tag,
    count(*) AS count
FROM (
    SELECT DISTINCT
        id_tweets,
        tag
    FROM tweets
    JOIN tweet_tags USING (id_tweets)
    WHERE to_tsvector('english',text)@@to_tsquery('english','coronavirus')
      AND lang='en'
) t
GROUP BY tag
ORDER BY count DESC,tag
LIMIT 1000;
*/

COMMIT;
