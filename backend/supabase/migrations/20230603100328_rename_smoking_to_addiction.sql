-- change smoking log to be addiction reset log
ALTER TABLE no_smoking_log
  RENAME COLUMN no_smoking_time TO reset_time;
ALTER TABLE no_smoking_log
ADD addiction_type TEXT;
ALTER TABLE no_smoking_log
  RENAME TO addiction_reset_log;
-- rename column with smoking time to addiction time
ALTER TABLE profiles
  RENAME COLUMN no_smoking_time TO no_addiction_time;