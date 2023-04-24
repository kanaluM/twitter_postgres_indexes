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
LIMIT 1000; */

SELECT '#' || nohashtag as tag,
       count(DISTINCT id)
FROM (
    SELECT data->>'id' AS id,
        jsonb_array_elements(
            COALESCE(data->'entities'->'hashtags','[]') ||
            COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]')
        )->>'text' AS nohashtag
    FROM tweets_jsonb
    WHERE data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]' OR
          data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'
    ) t
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
