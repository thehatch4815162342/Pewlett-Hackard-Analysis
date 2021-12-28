select em.emp_no, first_name, last_name, title, from_date, to_date
into retirement_titles 
from employees em
join titles tt on tt.emp_no = em.emp_no
where birth_date BETWEEN '1952-01-01' AND '1955-12-31'
order by em.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
where to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

select count(title),title
into retiring_titles
from unique_titles
group by title
order by count(title) desc;

select distinct on (em.emp_no) em.emp_no, first_name, last_name, birth_date, de.from_date, de.to_date, title
into mentorship_eligibility
from employees em
join dept_emp de on de.emp_no = em.emp_no
join titles tt on tt.emp_no = em.emp_no
where de.to_date = '9999-01-01' and (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
order by em.emp_no;

