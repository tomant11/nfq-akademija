#
# Lenteli� apjungimas
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
# Klausimas: kiek �ra�� gausim jei sujungsim 3 lenteles, kuriose 100, 200, 300 �ra��?
#


#
# Atitinkam� prijungimas (Equi-join)
#

# I�renka tik tuos ira�us, kurie turi atitikmenis sujungiamose lentel�se


SELECT t1.*, t2.* FROM t1, t2 WHERE t1.i1 = t2.i2;

+----+----+----+----+
| i1 | c1 | i2 | c2 |
+----+----+----+----+
| 2  | b  | 2  | c  |
| 3  | c  | 3  | b  |
+----+----+----+----+

#
# JOIN and CROSS JOIN prijungimo tipai yra ekvivalent�s ',' (kablelio) sujungimo operacijai.
#

SELECT t1.*, t2.* FROM t1, t2 WHERE t1.i1 = t2.i2;
SELECT t1.*, t2.* FROM t1 JOIN t2 WHERE t1.i1 = t2.i2;
SELECT t1.*, t2.* FROM t1 CROSS JOIN t2 WHERE t1.i1 = t2.i2;


#
# LEFT JOIN ir RIGHT JOIN
#

#
# 1. I�renka �rasus, kurie turi atitikmenis abiejose lentel�se, bei �ra�us i� lentel�s kuri� atitikmen� nerado kitoje lenteleje.
# 2. LEFT JOIN atveju i�renka �ra�us i� kair�s lenteles, kuri� nerado de�in�je.
# 3. RIGHT JOIN yra analogi�kas LEFT JOIN tik lenteli� rol�s yra sukeistos.
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
# USING sintaks�
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