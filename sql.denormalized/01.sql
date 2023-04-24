/* SELECT count(distinct id_tweets)
FROM tweet_tags
WHERE tag='#coronavirus'; */

SELECT count(DISTINCT data->>'id')
FROM tweets_jsonb
WHERE data->'entities'->'hashtags'  @> '[{"text": "coronavirus"}]' OR
      data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]';
