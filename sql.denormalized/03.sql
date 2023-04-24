/* SELECT
    lang,
    count(DISTINCT id_tweets) as count
FROM tweet_tags
JOIN tweets USING (id_tweets)
WHERE tag='#coronavirus'
GROUP BY lang
ORDER BY count DESC,lang; */

SELECT data->>'lang' as lang,
       count(DISTINCT data->>'id') as count
FROM tweets_jsonb
WHERE data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]' OR 
      data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'
GROUP BY data->>'lang'
ORDER BY count DESC, data->>'lang';

