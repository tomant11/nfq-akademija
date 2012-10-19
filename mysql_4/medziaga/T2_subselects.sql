#
# Subselectai
#


#
# Subselect panaudojimas kai yra nuoroda � atitinkama reik�m�
#

Table t1:   Table t2:
+----+----+  +----+----+
| i1 | c1 |  | i2 | c2 |
+----+----+  +----+----+
| 1  | a  |  | 2  | c  |
| 2  | b  |  | 3  | b  |
| 3  | c  |  | 4  | a  |
+----+----+  +----+----+

SELECT i1 FROM t1 WHERE i1 = (SELECT i2 FROM t2 WHERE i2 > 3 );


#
# Subselect panaudojimas kai yra nuoroda � atitinkam� reik�mi� aib�
#


SELECT i1 FROM t1 WHERE i1 IN (SELECT i2 FROM t2);
+----+
| i1 |
+----+
| 2  |
| 3  |
+----+

SELECT i1 FROM t1 WHERE i1 NOT IN (SELECT i2 FROM t2);
+----+
| i1 |
+----+
| 1  |
+----+


#
# Kai norima panaudoti agregavimo funkcij� WHERE dalyje
#

SELECT * FROM president WHERE birth = MIN(birth); - negalima


SELECT *
	FROM president
WHERE birth = (SELECT MIN(birth) FROM president);



#
# Subselectu keitimas � Joinus
#

#
# Kai yra nuoroda � atitinkama reik�m�
#

SELECT * from score
WHERE student_id IN (SELECT student_id FROM student WHERE sex = 'F');

SELECT score.*
	FROM score, student
WHERE score.student_id = student.student_id AND student.sex = 'F';

# Kaip dar galima b�t� perra�yti antr� u�klaus�?



#
# Kai norima i�rintki nesamas / nepriskiras / nepanaudotas reik�mes
#

SELECT * FROM student
WHERE student_id NOT IN (SELECT student_id FROM absence);


SELECT
	student.*
FROM student
	LEFT JOIN exam ON student.student_id = exam.student_id
WHERE exam.student_id IS NULL;