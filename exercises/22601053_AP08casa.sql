/*
  Lesson 08 - Joining entities and nested queries
  Student:João Victor Franco da Costa   a22601053
  Date:20/10/2026 noite 19:30 - 21:30
*/
USE BikeStores;



-- A1
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name
FROM production.products as p
INNER JOIN production.brands as b
ON p.brand_id = b.brand_id
WHERE p.product_id between 1 and 10
order by p.product_id;

--A2
SELECT 
    candidate.product_id AS candidate_id,
    reference.product_id AS reference_id,
    candidate.list_price AS candidate_price,
    reference.list_price AS reference_price
FROM production.products AS candidate
INNER JOIN production.products AS reference
    ON candidate.list_price > reference.list_price
WHERE candidate.product_id BETWEEN 1 AND 20
  AND reference.product_id BETWEEN 1 AND 3;

--A3

SELECT *
FROM sales.orders;

SELECT 
    c.customer_id,
    COUNT(o.customer_id) as order_count
FROM sales.customers as c
INNER JOIN sales.orders as o
    ON c.customer_id = o.customer_id
    WHERE c.customer_id BETWEEN 1 AND 20
    GROUP BY c.customer_id;

SELECT 
    c.customer_id,
    COUNT(o.order_id) AS order_count
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE c.customer_id BETWEEN 1 AND 20
GROUP BY c.customer_id
ORDER BY c.customer_id;
    

-- A4. Staff reporting lines
--Show each active staff member's ID, name, store name, and manager's name.
--Preserve staff without a manager. Order by store ID and staff ID.

SELECT 
    staff.staff_id,
    CONCAT(staff.first_name,' ',staff.last_name) as name,
    store.store_name,
    staff.manager_id

FROM sales.staffs as staff
LEFT JOIN sales.stores store
    on store.store_id = staff.store_id
WHERE active = 1
ORDER BY store.store_id, staff.staff_id;


SELECT 
    emp.staff_id,
    CONCAT(emp.first_name, ' ', emp.last_name) AS name,
    store.store_name,
    CONCAT(mgr.first_name, ' ', mgr.last_name) AS manager_name
FROM sales.staffs AS emp

LEFT JOIN sales.stores AS store
    ON emp.store_id = store.store_id

LEFT JOIN sales.staffs AS mgr
    ON emp.manager_id = mgr.staff_id

WHERE emp.active = 1
ORDER BY store.store_id, emp.staff_id;
--REFAZER ISTO AQUI. É MUITO COMPLICADO


--A5 Order and product path
--For order 1, show item number, product name, category name, quantity, and line amount after discount. 
--Traverse the order items, products, and categories tables. Keep one result row per order item.

--Expected columns: item_id, product_name, category_name, quantity, line_amount. 
--Use the order item's price and discount, not the current product catalog price.

SELECT *
FROM SALES.order_items;

SELECT *
FROM production.products;

SELECT *
FROM production.categories;

SELECT
    o.item_id,
    p.product_name,
    c.category_name,
    o.quantity,
    (o.list_price * o.quantity) * (1-o.discount) as line_amount
FROM SALES.order_items as o
LEFT JOIN production.products as p
    ON o.product_id = p.product_id
LEFT JOIN production.categories as c
    on p.category_id = c.category_id
where o.order_id=1;

--A6. Brand prices in a derived table
--For each brand with at least five products, show brand name, product count, and average catalog price,ordered by average price descending.
-- Compute the grouped statistics as a named derived result before combining with brands.

--Expected columns: brand_name, product_count, average_price. Every count is at least five.

--MINHA SOLUÇÃO, APARENTEMENTE EU DEVERIA TER FEITO UMA CTE antes para filtrar o numero de linhas que seriam cruzadas no meu join
SELECT
    b.brand_name,
    COUNT(p.product_id) as product_count,
    AVG(p.list_price) as average_price
FROM production.products as p
left JOIN production.brands as b
    on p.brand_id = b.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 4
ORDER BY average_price desc;

-- tentativa ulizando uma CTE

WITH BrandStats as (
    SELECT 
    brand_id,
    COUNT(product_id) as product_count,
    AVG(list_price) as average_price
    FROM production.products
    GROUP BY brand_id
    HAVING COUNT(product_id) >= 5
)
SELECT
    b.brand_name,
    s.product_count,
    s.average_price
    FROM BrandStats as s
    JOIN production.brands as b
        on s.brand_id = b.brand_id
    ORDER BY s.average_price desc;

-- A7 Above-category price

WITH CategoryStats as (
    SELECT
        CATEGORY_ID as categoria,
        COUNT(PRODUCT_ID) AS QUANTIDADE,
        AVG(list_price) as media_de_precos
    FROM production.products
    GROUP BY category_id
)

SELECT 
    p.product_id,
    p.product_name,
    CategoryStats.categoria,
    p.list_price,
    CategoryStats.media_de_precos
    FROM production.products as p
    INNER JOIN CategoryStats
        on p.category_id = CategoryStats.categoria
    WHERE p.list_price > CategoryStats.media_de_precos;


SELECT  
    p1.product_id,
    p1.product_name,
    p1.category_id,
    p1.list_price
    FROM production.products as p1
    WHERE P1.list_price > (
        SELECT
            AVG(p2.list_price)
        FROM production.products as p2
        WHERE p1.category_id=p2.category_id
    )
    ORDER BY p1.category_id, p1.product_id

--A8
--Um INNER JOIN não funcionaria porque ele exige uma correspondência estrita em ambas as tabelas,
-- filtrando e eliminando automaticamente qualquer produto que não tivesse um par na tabela de pedidos.


SELECT 
    p.product_id,
    p.product_name,
    o.product_id

FROM PRODUCTION.products as p
    left JOIN sales.order_items as o
        on p.product_id = o.product_id
    WHERE o.product_id is null;

SELECT
    p.product_id,
    p.product_name
    FROM production.products as p
    WHERE NOT EXISTS (
        SELECT *
        From sales.order_items as o
        where o.product_id = p.product_id
    ) order by p.product_id;
    
