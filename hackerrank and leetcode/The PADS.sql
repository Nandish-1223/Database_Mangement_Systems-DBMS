SELECT 'There are a total of ' || COUNT(Occupation) || ' ' || LOWER(Occupation) || 's.'
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(Occupation) ASC, Occupation ASC;
