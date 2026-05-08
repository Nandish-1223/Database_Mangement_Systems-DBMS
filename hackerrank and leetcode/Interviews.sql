SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    SUM(NVL(ss.total_submissions, 0)) AS total_submissions,
    SUM(NVL(ss.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(NVL(vs.total_views, 0)) AS total_views,
    SUM(NVL(vs.total_unique_views, 0)) AS total_unique_views
FROM Contests c
JOIN Colleges col 
    ON c.contest_id = col.contest_id
JOIN Challenges ch 
    ON col.college_id = ch.college_id
LEFT JOIN Submission_Stats ss 
    ON ch.challenge_id = ss.challenge_id
LEFT JOIN View_Stats vs 
    ON ch.challenge_id = vs.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING 
    SUM(NVL(ss.total_submissions, 0)) +
    SUM(NVL(ss.total_accepted_submissions, 0)) +
    SUM(NVL(vs.total_views, 0)) +
    SUM(NVL(vs.total_unique_views, 0)) > 0
ORDER BY c.contest_id;
exit;
