#
# Lenteliø apjungimas su UNION
#

t1
+------+-------+
| i    | c     |
+------+-------+
|  1   | red   |
|  2   | blue  |
|  3   | green |
+------+-------+

t2
+------+------+
| i    | c    |
+------+------+
|  -1  | tan  |
|  1   | red  |
+------+------+

t3
+------------+------+
| d          | i    |
+------------+------+
| 1904-01-01 | 100  |
| 2004-01-01 | 200  |
| 2004-01-01 | 200  |
+------------+------+


#
# UNION prijungia lenteles viena po kitos
#


SELECT i FROM t1 UNION SELECT i FROM t2 UNION SELECT i FROM t3;

+------+
| i    |
+------+
|  1   |
|  2   |
|  3   |
|  -1  |
| 100  |
| 200  |
+------+


#
# Stulpeliø skaièius turi sutapti, vardai ir tipai gali nesutapti
#


SELECT i, c FROM t1 UNION SELECT i, d FROM t3;

+------+------------+
| i    | c          |
+------+------------+
|  1   | red        |
|  2   | blue       |
|  3   | green      |
| 100  | 1904-01-01 |
| 200  | 2004-01-01 |
+------+------------+

 SELECT i, c FROM t1 UNION SELECT d, i FROM t3;

+------+-------+
| i    | c     |
+------+-------+
|  1   | red   |
|  2   | blue  |
|  3   | green |
| 1904 | 100   |
| 2004 | 200   |
+------+-------+

#
# UNION eliminuoja dublius, kad to iðvengti naudojama UNION ALL
#

SELECT * FROM t1 UNION SELECT * FROM t2 UNION SELECT * FROM t3;

+------+-------+
| i    | c     |
+------+-------+
|  1   | red   |
|  2   | blue  |
|  3   | green |
|  -1  | tan   |
| 1904 | 100   |
| 2004 | 200   |
+------+-------+

SELECT * FROM t1 UNION ALL SELECT * FROM t2 UNION SELECT * FROM t3;

+------+-------+
| i    | c     |
+------+-------+
|  1   | red   |
|  2   | blue  |
|  3   | green |
|  -1  | tan   |
|  1   | red   |
| 1904 | 100   |
| 2004 | 200   |
| 2004 | 200   |
+------+-------+

#
# Pavyzdþiai
#

	SELECT i, c FROM t1
UNION
	SELECT i, d FROM t3
ORDER BY c;

+------+------------+
| i    | c          |
+------+------------+
| 100  | 1904-01-01 |
| 200  | 2004-01-01 |
|  2   | blue       |
|  3   | green      |
|  1   | red        |
+------+------------+


	(SELECT i, c FROM t1 ORDER BY i DESC)
UNION
	(SELECT i, c FROM t2 ORDER BY i);
+------+-------+
| i    | c     |
+------+-------+
|  3   | green |
|  2   | blue  |
|  1   | red   |
|  -1  | tan   |
+------+-------+


	SELECT * FROM t1
UNION
	SELECT * FROM t2
UNION
	SELECT * FROM t3
LIMIT 1;

+------+------+
| i    | c    |
+------+------+
|  1   | red  |
+------+------+

	(SELECT * FROM t1 LIMIT 1)
UNION
	(SELECT * FROM t2 LIMIT 1)
UNION
	(SELECT * FROM t3 LIMIT 1);

+------+------+
| i    | c    |
+------+------+
|  1   | red  |
|  -1  | tan  |
| 1904 | 100  |
+------+------+