INSERT INTO DIM_DATES ( DATE,DAY,MONTH, YEAR, QUARTER)
WITH date_range AS (
  SELECT
    DATEADD(day, ROW_NUMBER() OVER (ORDER BY seq4()) - 1, '2010-01-01') AS date
  FROM
    TABLE(GENERATOR(rowcount => 6000)) -- 6000 days inserted
),
date_components AS (
  SELECT
    date,
    EXTRACT(day FROM date) AS day,
    EXTRACT(month FROM date) AS month,
    EXTRACT(year FROM date) AS year,
    EXTRACT(quarter FROM date) AS quarter
  FROM
    date_range
)
SELECT  date,day,month, year, quarter FROM  date_components