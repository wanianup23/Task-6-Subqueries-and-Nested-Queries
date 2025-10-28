----single row subquery
---inner query returns single row result--
select first_name,last_name,salary from employees where
salary > (select avg(salary) from employees);

--find employee who earns max salary--
select first_name,last_name,salary from employees 
where salary=(select max(salary) from employees);

---Find employees hired after the earliest hired employee.
select first_name,last_name,hire_date from employees 
where hire_date>(select min(hire_date) from employees);

select min(hire_date) from employees;

--Find employees who earn more than the salary of employee ID 101.
select employee_id,first_name,last_name,salary from employees
where salary>(select salary from employees where employee_id=101);

select employee_id,first_name,last_name,salary from employees
where salary>(select salary from employees where employee_id=&x1);--we can put any employee_id

-----Multiple Row Subquery-----
---inner query Returns more than one row.
---Uses operators like IN, ANY, ALL.

SELECT * FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE location_id = 1700);

commit;

--- Find employees who earn more than all employees in department 50
select first_name,salary from employees
where salary > ALL (select salary from employees where department_id=50);

---Find employees who earn more than any employee in department 30
SELECT employee_id, first_name, salary,department_id
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = 30);


---correlated subquery-----
---Example 1: Find employees who earn more than the average salary of their department
select first_name,salary from employees
where salary >all(
select trunc(avg(salary)) from employees
group by department_id);---this fails 

SELECT e1.employee_id, e1.first_name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

---Example 2: Find employees who are the highest paid in their department

select first_name,salary from employees e1
where salary =(select max(salary) from employees
where department_id=e1.department_id);

commit;

---inline subquery----
--Scenario 1: Find employees who earn more than their department’s average salary

SELECT e.employee_id, e.first_name, e.department_id, e.salary, d.avg_salary
FROM employees e
JOIN (
    SELECT department_id,  trunc (AVG(salary)) AS avg_salary
    FROM employees
    GROUP BY department_id
) d
ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;

--Scenario 2: Find departments with more than 5 employees
SELECT e.employee_id, e.first_name, e.department_id, d.emp_count
FROM employees e
JOIN (
    SELECT department_id, COUNT(*) AS emp_count
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) > 5
) d
ON e.department_id = d.department_id;
