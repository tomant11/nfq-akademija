<?php

$sql="
    SELECT *
    FROM Prekes
    WHERE pavadinimas LIKE :search OR aprasymas LIKE :search
    ORDER BY prekeId DESC
";

$sql="
    SELECT g.grupeId, g.pavadinimas, COUNT(p.prekeId)
    FROM Grupes g
        LEFT JOIN Prekes p ON (p.grupeId = g.grupeId)
    GROUP BY g.grupeID
";

$sql="
    SELECT p.*, g.*,
    FROM Prekes g
        LEFT JOIN Grupes p ON (p.grupeId = g.grupeId)
    GROUP BY g.grupeID
";
