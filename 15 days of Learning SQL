WITH date_range AS (
  -- Generate one row for each day of the contest
  SELECT 
    TO_DATE('2016-03-01', 'YYYY-MM-DD') + LEVEL - 1 AS submission_date
  FROM dual
  CONNECT BY LEVEL <= TO_DATE('2016-03-15', 'YYYY-MM-DD') - TO_DATE('2016-03-01', 'YYYY-MM-DD') + 1
),
daily_counts AS (
  -- For each day: count distinct hackers that have at least one submission
  SELECT 
    d.submission_date,
    COUNT(DISTINCT s.hacker_id) AS unique_hackers
  FROM date_range d
  LEFT JOIN Submissions s 
    ON s.submission_date = d.submission_date
  GROUP BY d.submission_date
),
daily_max AS (
  -- For each day: find the maximum number of submissions made by any hacker
  SELECT 
    d.submission_date,
    MAX(cnt) AS max_submissions
  FROM (
    SELECT 
      s.submission_date,
      s.hacker_id,
      COUNT(*) AS cnt
    FROM Submissions s
    GROUP BY s.submission_date, s.hacker_id
  ) s
  GROUP BY d.submission_date
),
hacker_ranked AS (
  -- For each day, rank hackers by submission count (desc) and hacker_id (asc)
  SELECT 
    s.submission_date,
    s.hacker_id,
    COUNT(*) AS submission_count,
    ROW_NUMBER() OVER (
      PARTITION BY s.submission_date 
      ORDER BY COUNT(*) DESC, s.hacker_id ASC
    ) AS rn
  FROM Submissions s
  GROUP BY s.submission_date, s.hacker_id
)
-- Final output: date, unique hackers, winner_id, winner_name
SELECT 
  d.submission_date,
  COALESCE(dc.unique_hackers, 0) AS unique_hackers,
  hr.hacker_id,
  h.name
FROM date_range d
LEFT JOIN daily_counts dc 
  ON dc.submission_date = d.submission_date
LEFT JOIN hacker_ranked hr 
  ON hr.submission_date = d.submission_date 
 AND hr.rn = 1
LEFT JOIN Hackers h 
  ON h.hacker_id = hr.hacker_id
ORDER BY d.submission_date;
