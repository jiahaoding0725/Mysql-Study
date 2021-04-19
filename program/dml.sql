-- 查询全部的学生
SELECT * FROM student;

-- 查询指定字段
SELECT studentno, studentname FROM student;

-- 别名 AS
SELECT studentno AS 学号, studentname AS 学生姓名 FROM student;

-- 函数 concat(a, b)
SELECT CONCAT('姓名:',studentname) AS 新名字 FROM student;

-- 查询有哪些同学参加了考试
-- 发现重复数据，去重
SELECT DISTINCT studentno FROM result;

-- 查询系统版本
SELECT VERSION(); -- 函数
SELECT 100*3-1 AS 计算结果; -- 表达式
SELECT @@auto_increment_increment; -- 查询自增的步长 （变量）

-- 学员考试成绩 + 1分查看
SELECT studentno, studentresult + 1 AS '提分后' FROM result;

-- ======== WHERE =======
SELECT studentno, studentresult FROM result;

-- 查询考试成绩在95-100分之间
SELECT studentno, studentresult FROM result
WHERE studentresult>=95 AND studentresult<=100;

-- 模糊查询（区间）
SELECT studentno, studentresult FROM result
WHERE studentresult BETWEEN 95 and 100;

-- 除了1000号学生之外的同学的成绩
SELECT studentno, studentresult FROM result
WHERE studentno != 1000;

SELECT studentno, studentresult FROM result
WHERE NOT studentno = 1000;

-- ======== 模糊查询 =======
-- ======= LIKE ===========
-- 查询姓刘的同学
-- LIKE 结合 %(代表0到任意个字符) _(一个字符)
SELECT studentno, studentname FROM student
WHERE studentname LIKE '刘%';

SELECT studentno, studentname FROM student
WHERE studentname LIKE '刘_';

-- 查询名字中有嘉字的同学
SELECT studentno, studentname FROM student
WHERE studentname LIKE '%嘉%';

-- ======= IN ============
-- 查询1001，1002，1003号学员
SELECT studentno, studentname FROM student
WHERE studentno IN (1001, 1002, 1003);

-- 查询在北京的学生
SELECT studentno, studentname FROM student
WHERE address in ('北京朝阳');

-- ====== NULL NOT NULL ====
-- 查询地址为空的学生 NULL ''
SELECT studentno, studentname FROM student
WHERE address='' OR address IS NULL;

-- 查询有出生日期的同学 不为空
SELECT studentno, studentname FROM student
WHERE borndate IS NOT NULL;



-- ===== 联表查询 JOIN ======
-- 查询参加了考试的同学
SELECT s.studentno, studentname, subjectno, studentresult
FROM student AS s INNER JOIN result AS r
WHERE s.studentno = r.studentno;

SELECT s.studentno, studentname, subjectno, studentresult
FROM student s RIGHT JOIN result r
ON s.studentno = r.studentno;

SELECT s.studentno, studentname, subjectno, studentresult
FROM student s LEFT JOIN result r
ON s.studentno = r.studentno;

-- 查询缺考的同学
SELECT s.studentno, studentname, subjectno, studentresult
FROM student s LEFT JOIN result r
ON s.studentno = r.studentno
WHERE studentresult IS NULL;


SELECT r.studentno, studentname, subjectname, studentresult
FROM student s RIGHT JOIN result r
ON s.studentno = r.studentno
INNER JOIN `subject` su
ON r.subjectno = su.subjectno; 


-- 查询父子信息
SELECT a.categoryname AS '父栏目', b.categoryname AS '子栏目'
FROM category a, category b
WHERE a.categoryid = b.pid;

-- 查询学员所属的年级
SELECT studentno, studentname, gradename
FROM student s INNER JOIN grade g ON s.gradeid = g.gradeid;

-- 查询科目所属的年级
SELECT subjectname, gradename
FROM `subject` s INNER JOIN grade g ON s.gradeid = g.gradeid;

-- 查询了参加数据库结构-1考试的同学信息
SELECT s.studentno, studentname, subjectname, studentresult
FROM student s INNER JOIN result r on s.studentno = r.studentno
INNER JOIN `subject` sub ON r.subjectno = sub.subjectno 
WHERE sub.subjectname='数据库结构-1';




-- ============ 分页 LIMIT和排序 ORDER BY =================
-- 排序： 升序 ASC ， 降序 DESC

-- 根据成绩降序排序
SELECT s.studentno, studentname, subjectname, studentresult
FROM student s INNER JOIN result r on s.studentno = r.studentno
INNER JOIN `subject` sub ON r.subjectno = sub.subjectno 
WHERE sub.subjectname='数据库结构-1'
ORDER BY studentresult DESC;


-- 100万条数据
-- 为什么要分页
-- 缓解数据库压力，给人的体验更好，瀑布流

-- 每页只显示5条数据
-- LIMIT
SELECT s.studentno, studentname, subjectname, studentresult
FROM student s INNER JOIN result r on s.studentno = r.studentno
INNER JOIN `subject` sub ON r.subjectno = sub.subjectno 
WHERE sub.subjectname='数据库结构-1'
ORDER BY studentresult DESC
LIMIT 0, 5; 

SELECT s.studentno, studentname, subjectname, studentresult
FROM student s INNER JOIN result r on s.studentno = r.studentno
INNER JOIN `subject` sub ON sub.subjectno = r.subjectno
WHERE subjectname = 'JAVA第一学年' and studentresult >= 80
ORDER BY studentresult
LIMIT 0, 10;


-- ========== 子查询 =========
-- 1.查询数据库结构-1的所有考试结果
-- 方式一：使用连接查询
SELECT studentno, subjectname, studentresult
FROM result r INNER JOIN `subject` sub on r.subjectno = sub.subjectno
WHERE subjectname = '数据库结构-1'
ORDER BY studentresult DESC;

-- 方式二：使用子查询
SELECT studentno, subjectno, studentresult
FROM result
WHERE subjectno = (SELECT subjectno FROM `subject` WHERE subjectname = '数据库结构-1')
ORDER BY studentresult DESC;

-- 分数不小于80分的学生的学号和姓名
SELECT DISTINCT s.studentno, studentname
FROM student s INNER JOIN result r on s.studentno = r.studentno
WHERE studentresult >=80 and subjectno = (
	SELECT subjectno 
	FROM `subject` 
	WHERE subjectname = '高等数学-2'
);



-- ========== 常用函数 =========
-- 数学运算
SELECT ABS(-8);
SELECT CEILING(2.4);
SELECT FLOOR(2.4);
SELECT RAND(); -- 返回(0,1)之间的随机数
SELECT SIGN(-2.4); -- 返回参数的符号 0 -> 0 负数 -> -1 正数 -> 1

-- 字符串
SELECT CHAR_LENGTH('你好'); -- 字符串长度 CHAR_LENGTH(str)
SELECT CONCAT('你','好'); -- 拼接字符串 CONCAT(str1,str2,...)
SELECT INSERT('你好', 2, 2, '世界'); -- INSERT(str,pos,len,newstr)
SELECT UPPER('abc');
SELECT LOWER('ABC');
SELECT INSTR('hello','e'); -- INSTR(str,substr)
SELECT REPLACE('abcde','cd','xz'); -- REPLACE(str,from_str,to_str)
SELECT SUBSTR('acbde', 1, 3); -- SUBSTR(str FROM pos FOR len)
SELECT REVERSE('abc'); -- REVERSE(str)

-- 查询姓周的同学,替换成邹
SELECT REPLACE(studentname,'张','周') FROM student
WHERE studentname LIKE '张%';

-- 时间和日期函数
SELECT CURRENT_DATE(); -- 获取当前日期
SELECT CURDATE();
SELECT NOW(); -- 获取当前时间
SELECT LOCALTIME(); -- 本地时间
SELECT SYSDATE(); -- 系统时间
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT DAY(NOW());
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());

-- 系统
SELECT SYSTEM_USER();
SELECT USER();
SELECT VERSION();


-- ========= 聚合函数 =========
-- 都能够统计表中的数据

SELECT COUNT(studentname) FROM student; -- 会忽略所有的null值
SELECT COUNT(*) FROM student; -- 不会忽略所有的null值
SELECT COUNT(1) FROM result; -- 不会忽略所有的null值

SELECT SUM(studentresult) as `sum` FROM result;
SELECT AVG(studentresult) as `avg` FROM result;
SELECT MAX(studentresult) as `min` FROM result;
SELECT MIN(studentresult) as `max` FROM result;

-- 查询不同课程的平均分，最高分，最低分
SELECT subjectname, AVG(studentresult), MAX(studentresult), MIN(studentresult)
FROM result r INNER JOIN `subject` s on r.subjectno = s.subjectno
GROUP BY r.subjectno
HAVING AVG(studentresult) > 80;


-- ======== 测试MD5加密 ========
CREATE TABLE testmd5(
	id INT(4) NOT NULL,
	`name` VARCHAR(20) NOT NULL,
	pwd VARCHAR(50) NOT NULL,
	PRIMARY KEY(id)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

-- 明文密码
INSERT INTO testmd5 VALUES
(1, 'zhangsan', '123456'),
(2, 'lisi', '123456'),
(3, 'wangwu', '123456');

-- 加密
UPDATE testmd5 SET pwd=MD5(pwd) WHERE id = 1;

INSERT INTO testmd5 VALUES(4, 'xiaoming', MD5('123456'));

-- 如何校验: 将用户传递进来的密码，进行md5加密，然后比对加密后的值
SELECT * FROM testmd5 WHERE `name` = 'xiaoming' AND pwd=MD5('123456'); 