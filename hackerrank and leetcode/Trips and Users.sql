SELECT 
    request_at AS Day,
    ROUND(
        SUM(CASE WHEN STATUS != 'completed' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS "Cancellation Rate"
FROM 
    trips t
JOIN 
    users u1 
    ON t.client_id = u1.users_id 
    AND u1.banned = 'No'
JOIN 
    users u2 
    ON t.driver_id = u2.users_id 
    AND u2.banned = 'No'
WHERE 
    TO_DATE(request_at, 'YYYY-MM-DD') BETWEEN TO_DATE('2013-10-01', 'YYYY-MM-DD') 
    AND TO_DATE('2013-10-03', 'YYYY-MM-DD')
GROUP BY 
    request_at;
