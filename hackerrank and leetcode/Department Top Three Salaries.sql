with emp_details as (
    select name, 
        salary,
        departmentId,
        dense_rank() over(partition by departmentId order by salary desc) as rnk
    from Employee
)
select d.name as Department,
    e.name as Employee,
    e.salary as Salary
from emp_details e
inner join Department d
on e.departmentId = d.id
where e.rnk <= 3;
