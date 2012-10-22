<?php

$sql="
    SELECT *
    FROM product
    WHERE title LIKE :search OR description LIKE :search
    ORDER BY id DESC
";

$sql="
    SELECT category.id, category.title, COUNT(product.id)
    FROM category
        LEFT JOIN product ON (product.id = category.id)
    GROUP BY category.id
";

$sql="
    SELECT product.*, category.*,
    FROM product
        LEFT JOIN category ON (product.id = category.id)
    GROUP BY category.id
";

$sql="
    SELECT product.id, product.title, product.price
    FROM product
    ORDER BY price DESC
    LIMIT 10;
";

$sql="
    SELECT product.id, product.title, product.price
    FROM product
    ORDER BY price ASC
    LIMIT 10;
";

$sql="
    SELECT product.id, product.title, product.price
    FROM product
    ORDER BY created_at ASC
    LIMIT 10;
";

$sql="
    SELECT product.id, product.title
    FROM product
    WHERE group_id is null;
";

$sql="
    UPDATE manufacturer
    SET updated_at="2012.10.21";
";

$sql="
    UPDATE product
    SET updated_at="2012.10.21";
";

$sql="
    CREATE INDEX pro_ind ON product(title, price);
";

$sql="
    ALTER TABLE product DROP INDEX pro_ind;
";

$sql="
    SELECT * 
    FROM product
    WHERE title LIKE '%lt%';
";

$sql="
    SELECT category.*, count(product.id)
    FROM category
        LEFT JOIN product ON (product.group_id=category.id)
    GROUP BY category.id;
";

$sql="
    INSERT INTO category
    SET title="sportdirect", created_at="2012.10.20", updated_at="2012.10.20";
";

$sql="
    SELECT manufacturer.title, product.stock
    FROM manufacturer
        LEFT JOIN product ON (product.manufacturer_id=manufacturer.id)
    GROUP BY manufacturer.id
    ORDER BY stock ASC
    LIMIT 20;
";

$sql="
    SELECT manufacturer.title, count(product.id) as product_count
    FROM manufacturer
        LEFT JOIN product ON (manufacturer.id=product.manufacturer_id)
    GROUP BY manufacturer.title
    ORDER BY product_count DESC
    LIMIT 20;
";