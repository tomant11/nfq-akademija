#
# Lenteliø apjungimas
#

   table1       table2
+----+----+  +----+----+
| i1 | c1 |  | i2 | c2 |
+----+----+  +----+----+
| 1  | a  |  | 2  | c  |
| 2  | b  |  | 3  | b  |
| 3  | c  |  | 4  | a  |
+----+----+  +----+----+

#
# Pilnas Apjungimas (Full Join or Cross Join)
#

SELECT t1.*, t2.* FROM t1, t2;

+----+----+----+----+
| i1 | c1 | i2 | c2 |
+----+----+----+----+
| 1  | a  | 2  | c  |
| 2  | b  | 2  | c  |
| 3  | c  | 2  | c  |
| 1  | a  | 3  | b  |
| 2  | b  | 3  | b  |
| 3  | c  | 3  | b  |
| 1  | a  | 4  | a  |
| 2  | b  | 4  | a  |
| 3  | c  | 4  | a  |
+----+----+----+----+

#
# Klausimas: kiek áraðø gausim jei sujungsim 3 lenteles, kuriose 100, 200, 300 áraðø?
#


#
# Atitinkamø prijungimas (Equi-join)
#

# Iðrenka tik tuos iraðus, kurie turi atitikmenis sujungiamose lentelëse


SELECT t1.*, t2.* FROM t1, t2 WHERE t1.i1 = t2.i2;

+----+----+----+----+
| i1 | c1 | i2 | c2 |
+----+----+----+----+
| 2  | b  | 2  | c  |
| 3  | c  | 3  | b  |
+----+----+----+----+

#
# JOIN and CROSS JOIN prijungimo tipai yra ekvivalentûs ',' (kablelio) sujungimo operacijai.
#

SELECT t1.*, t2.* FROM t1, t2 WHERE t1.i1 = t2.i2;
SELECT t1.*, t2.* FROM t1 JOIN t2 WHERE t1.i1 = t2.i2;
SELECT t1.*, t2.* FROM t1 CROSS JOIN t2 WHERE t1.i1 = t2.i2;


#
# LEFT JOIN ir RIGHT JOIN
#

#
# 1. Iðrenka árasus, kurie turi atitikmenis abiejose lentelëse, bei áraðus ið lentelës kuriø atitikmenø nerado kitoje lenteleje.
# 2. LEFT JOIN atveju iðrenka áraðus ið kairës lenteles, kuriø nerado deðinëje.
# 3. RIGHT JOIN yra analogiðkas LEFT JOIN tik lenteliø rolës yra sukeistos.
#


SELECT t1.*, t2.* FROM t1 LEFT JOIN t2 ON t1.i1 = t2.i2;

+----+----+------+------+
| i1 | c1 | i2   | c2   |
+----+----+------+------+
| 1  | a  | NULL | NULL |
| 2  | b  |  2   | c    |
| 3  | c  |  3   | b    |
+----+----+------+------+


SELECT t1.*, t2.* FROM t1 RIGHT JOIN t2 ON t1.i1 = t2.i2;

+------+------+------+------+
| i1   | c1   | i2   | c2   |
+------+------+------+------+
| 2    | b    |  2   | c    |
| 3    | c    |  3   | b    |
| NULL | NULL |  4   | a    |
+------+------+------+------+


#
# USING sintaksë
#

   t1       	t2
+----+----+  +----+----+
| i  | c1 |  | i  | c2 |
+----+----+  +----+----+
| 1  | a  |  | 2  | c  |
| 2  | b  |  | 3  | b  |
| 3  | c  |  | 4  | a  |
+----+----+  +----+----+


SELECT t1.*, t2.* FROM t1 LEFT JOIN t2 USING( i );

+----+----+------+------+
| i  | c1 | i    | c2   |
+----+----+------+------+
| 1  | a  | NULL | NULL |
| 2  | b  |  2   | c    |
| 3  | c  |  3   | b    |
+----+----+------+------+