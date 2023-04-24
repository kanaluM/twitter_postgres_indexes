BEGIN;
ALTER TABLE tweets_jsonb SET (parallel_workers = 80);
SET max_parallel_maintenance_workers TO 80;
SET maintenance_work_mem TO '16 GB';
CREATE INDEX hashtags ON tweets_jsonb USING gin((data->'entities'->'hashtags'));
CREATE INDEX extended_hashtags ON tweets_jsonb USING gin((data->'extended_tweet'->'entities'->'hashtags'));
CREATE INDEX lang ON tweets_jsonb USING gin((data->'lang'));
CREATE INDEX coalesce_text ON tweets_jsonb USING gin(to_tsvector('english', COALESCE(data->'extended_tweet'->>'full_text', data->>'text')));
COMMIT;

