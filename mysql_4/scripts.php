<?php

$sql="
    SELECT *
    FROM product
    WHERE title LIKE :search OR description LIKE :search
    ORDER BY id DESC
";

$sql="
    SELECT group.id, group.title, COUNT(product.id)
    FROM group
        LEFT JOIN product ON (product.id = group.id)
    GROUP BY group.id
";

$sql="
    SELECT product.*, group.*,
    FROM product
        LEFT JOIN group ON (product.id = group.id)
    GROUP BY group.id
";
