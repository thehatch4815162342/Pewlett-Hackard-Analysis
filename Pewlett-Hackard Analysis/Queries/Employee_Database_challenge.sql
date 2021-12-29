-- Create retirement_titles table
select em.emp_no, first_name, last_name, title, from_date, to_date
into retirement_titles 
from employees em
join titles tt on tt.emp_no = em.emp_no
where birth_date BETWEEN '1952-01-01' AND '1955-12-31'
order by em.emp_no;

-- Create unique_titles table
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
where to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

-- Create retiring_titles table
select count(title),title
into retiring_titles
from unique_titles
group by title
order by count(title) desc;

-- Create mentorship_eligibility table
select distinct on (em.emp_no) em.emp_no, first_name, last_name, birth_date, de.from_date, de.to_date, title
into mentorship_eligibility
from employees em
join dept_emp de on de.emp_no = em.emp_no
join titles tt on tt.emp_no = em.emp_no
where de.to_date = '9999-01-01' and (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
order by em.emp_no;

-- Find the number of eligible employees for the mentorship program
select count(emp_no) as "Number of Employees"
from mentorship_eligibility;

-- Find the number of eligible employees for the mentorship program per title
select count(emp_no) as "Number of Employees",title as "Title"
from mentorship_eligibility
group by title 
order by count(emp_no) desc;

-- Create retirement_dept table
-- Find the amount of employees retiring per department
select count(ut.emp_no) as "Number of Employees", dept_name
into retirement_dept
from departments dp
join dept_emp de on de.dept_no = dp.dept_no
join unique_titles ut on ut.emp_no = de.emp_no
group by dept_name
order by count(ut.emp_no) desc;

-- Create retirement_salaries tables
-- Find the amount of the reitiring employees per salary group
select count(upperclass.emp_no) as "Retiring Employees over 100k", count(middleclass.emp_no) as "Retiring Employees between 50-100k", count(lowerclass.emp_no) as "Retiring Employees under 50k"
into retirement_salaries
from unique_titles ut
left join (select emp_no from salaries where salary > 100000) upperclass on upperclass.emp_no = ut.emp_no
left join (select emp_no from salaries where salary BETWEEN 50000 AND 99999) middleclass on middleclass.emp_no = ut.emp_no
left join (select emp_no from salaries where salary < 49999) lowerclass on lowerclass.emp_no = ut.emp_no;
