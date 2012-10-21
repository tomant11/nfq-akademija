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
