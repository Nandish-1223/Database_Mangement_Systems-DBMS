select Distinct id,type from(
select T.id,
case
when T.p_id is null then 'Root'
when T1.p_id is null then 'Leaf'
ELSE 'Inner'
end as type
from Tree T left outer join Tree T1
on T.id=T1.p_id
)
