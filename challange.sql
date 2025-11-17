-- Task One: Top 5 Customers by Total Spend
WITH line_totals AS (
    -- 1) item-level totals
    SELECT
        oi.order_id,
        oi.quantity * oi.unit_price AS line_total
    FROM order_items AS oi
),
order_totals AS (
    -- 2) roll up to order-level totals
    SELECT
        lt.order_id,
        SUM(lt.line_total) AS order_total
    FROM line_totals AS lt
    GROUP BY lt.order_id
),
customer_totals AS (
    -- 3) roll up to customer-level totals
    SELECT
        o.customer_id,
        SUM(ot.order_total) AS total_spend
    FROM orders AS o
    JOIN order_totals AS ot
        ON o.id = ot.order_id          
    GROUP BY o.customer_id
)
SELECT
    c.first_name || ' ' || c.last_name AS customer_full_name,
    ct.total_spend
FROM customer_totals AS ct
JOIN customers AS c
    ON ct.customer_id = c.id           
ORDER BY
    ct.total_spend DESC
LIMIT 5;




--- Task 2: 

WITH line_totals AS (
    -- 1) item-level line totals
    SELECT
        oi.product_id,
        oi.quantity * oi.unit_price AS line_total
    FROM order_items AS oi
)
SELECT
    p.category,                          
    SUM(lt.line_total) AS revenue
FROM line_totals AS lt
JOIN products AS p
    ON lt.product_id = p.id              
GROUP BY
    p.category
ORDER BY
    revenue DESC;



-- Task Three — Employees Earning Above Their Department Average
WITH dept_avg AS (
    SELECT
        department_id,
        AVG(salary) AS dept_avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT
    e.first_name,
    e.last_name,
    d.name AS department_name,          
    e.salary AS employee_salary,
    da.dept_avg_salary AS department_average
FROM employees AS e
JOIN dept_avg AS da
    ON e.department_id = da.department_id
JOIN departments AS d
    ON e.department_id = d.id           
    e.salary > da.dept_avg_salary
ORDER BY
    d.name,                             
    e.salary DESC;





 