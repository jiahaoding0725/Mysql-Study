**数据库 xxx 语言**

DML 管理

DDL 定义

DQL 查询

DCL 控制

### 1、 Mysql 命令行

```bash
mysql -u root -p  # 连接数据库

update mysql.user set authentication_string=password('123456') where user='root' and Host ='localhost'  # 修改用户密码
flush privileges 	# 刷新权限
```



```bash
show databases;		# 查看所有的数据库
use `school`; 	 # 切换数据库
show tables;	# 查看数据库所有的表
describe tables; # 显示数据模式
exit; # 退出连接

-- # sql单行注释

/*
*/ # sql多行注释
```



```sql
create database westos;  -- 创建数据库
```



### 2 、 操作数据库

**Mysql 关键字不区分大小写**

#### 2.1 操作数据库

```sql
CREATE DATABASE IF NOT EXISTS school	-- 创建数据库

DROP DATABASE IF EXISTS school  -- 删除数据库


```

#### 2.2 数据类型

> 数值

* tinyint  	1字节
* smallint   2字节
* Medium   3字节
* **int         4字节  => Java Integer, int**
* bigint        8字节



* float	 4字节
* double 8字节



* decimal 字符串形式的浮点数

> 字符串

* char 固定大小字符串 0-255
* **varchar 可变长字符串 0-65535 => Java String**
* tinytext 微型文本 2^8^ - 1
* **text 文本串 2^16^-1 保存大文本**

> 时间日期

java.util.Date



* date  YYYY-MM-DD 日期格式
* time HH:mm:ss 时间格式
* **datetime  YYYY-MM-DD HH:mm:ss**
* **timestamp 时间戳， 1970.1.1到现在的毫秒数**
* year 年份表示

> null

* 没有值，未知
* ==不要使用NULL进行运算，结果为NULL==



#### 2.3 字段属性

unsigned

* 无符号的整数
* 声明不能为负数



zerofill：

* 0填充
* 不足的位数，使用0填充 ,   int(3) , 5 -> 005



自增：

* 自动在上一条记录的基础上+1
* 通常用来设计唯一的主键， 必须是整数类型
* 可以自定义初始值和不长



非空：

* 假设设置为not null，如果不给它赋值，就会变报错！
* null，如果不填写值，默认就是null



default：

* 设置默认的值
* sex，默认值为男



#### 2.4 创建表

格式

```sql
CREATE TABLE [IF NOT EXISTS] `表名` (
	`字段名` 类型 [属性] [索引] [注释],
  `字段名` 类型 [属性] [索引] [注释],
  ...
  `字段名` 类型 [属性] [索引] [注释],
) [表类型] [字符集设置] [注释]
```

例子

```sql
CREATE TABLE IF NOT EXISTS `student` (
	`id` INT(4) NOT NULL AUTO_INCREMENT COMMENT 'student id',
	`name` VARCHAR(30) NOT NULL DEFAULT 'anonynmous' COMMENT 'student name',
	`pwd` VARCHAR(20) NOT NULL DEFAULT '123456' COMMENT	'student password',
	`gender` VARCHAR(6) NOT NULL DEFAULT 'female' COMMENT 'student gender',
	`birthday` DATETIME DEFAULT NULL COMMENT 'student birthday',
	`address` VARCHAR(100) DEFAULT NULL COMMENT 'student home address',
	`email` VARCHAR(50) DEFAULT NULL COMMENT 'student email',
	PRIMARY KEY (`id`)
	
) ENGINE = INNODB DEFAULT charset=utf8
```



```sql
SHOW CREATE DATABASE school -- 查看创建数据库的语句
SHOW CREATE TABLE student -- 查看student数据表的定义语言
DESC student -- 显示表的结构
```

#### 2.5 数据表的类型

数据库引擎

INNODB 默认使用

MyISAM 早些年使用



|              | MyISAM | INNODB                   |
| :----------: | ------ | ------------------------ |
|   事务支持   | 不支持 | 支持                     |
|   数据行锁   | 不支持 | 支持 ->效率高            |
|     外键     | 不支持 | 支持                     |
|   全文索引   | 支持   | 不支持，现在支持英文索引 |
| 表空间的大小 | 较小   | 较大，约为MyISAM的2倍    |

​	常规使用操作：

* MyISAM 节约空间，速度较快
* INNODB 安全性高，支持事务处理，支持外键支持多表操作，支持行锁多用户操作



> 在物理空间存在的位置

所有的数据库文件都存在data目录下

本质还是文件的存储

MySQL 引擎在物理文件上的区别

* INNODB 在数据库中只有一个 .frm 文件，以及上级目录下的ibdata1 文件

* MyISAM 对应文件
  * *.frm - 表结构的定义文件
  * *.MYD - 数据文件
  * *.MYI - 索引文件





> 设置数据库表的字符集编码	

```sql
charset=utf8
```

mysql默认字符集编码Latin1 （不支持中文）

my.ini中配置默认的编码

```bash
charaset-set-server=utf8
```



#### 2.6 修改删除数据表

```sql
-- 修改表名
ALTER TABLE student RENAME AS student1

-- 增加字段
ALTER TABLE student1 ADD age INT(11)


-- 修改表的字段（重命名，修改约束）
-- change 用来字段重命名，不能修改字段类型和约束
-- modify 不用来字段重命名，只能修改字段类型和约束
ALTER TABLE student1 MODIFY age VARCHAR(11)
ALTER TABLE student1 CHANGE age age1 INT(1)

-- 删除表的字段
ALTER TABLE student1 DROP age1

-- 删除表
DROP TABLE IF EXISTS student1
```

==所有的创建和删除操作尽量加上判断==

注意点

* ``字段名，使用这个包裹
* sql大小写不敏感





### 3、MYSQL 数据管理

#### 3.1 外键

> 方式一、在创建表的时候，增加约束

```sql
CREATE TABLE `grade` (
	gradeid INT(10) NOT NULL AUTO_INCREMENT COMMENT 'grade id',
	gradename VARCHAR(50) NOT NULL COMMENT 'grade name',
	PRIMARY KEY (gradeid)
) ENGINE=INNODB DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `student` (
	`id` INT(4) NOT NULL AUTO_INCREMENT COMMENT 'student id',
	`name` VARCHAR(30) NOT NULL DEFAULT 'anonynmous' COMMENT 'student name',
	`pwd` VARCHAR(20) NOT NULL DEFAULT '123456' COMMENT	'student password',
	`gender` VARCHAR(6) NOT NULL DEFAULT 'female' COMMENT 'student gender',
	`birthday` DATETIME DEFAULT NULL COMMENT 'student birthday',
	`gradeid` INT(10) NOT NULL COMMENT 'grade id',
	`address` VARCHAR(100) DEFAULT NULL COMMENT 'student home address',
	`email` VARCHAR(50) DEFAULT NULL COMMENT 'student email',
	PRIMARY KEY (`id`),
	KEY `FK_gradeid` (`gradeid`),
	CONSTRAINT `FK_gradeid` FOREIGN KEY	(`gradeid`) REFERENCES `grade`(`gradeid`)
) ENGINE=INNODB DEFAULT CHARSET=utf8
```

删除有外键关系的表的时候，必须要先删除引用别人的表，再删除被引用的表

> 方式二、创建表后，添加外键约束

```sql
CREATE TABLE IF NOT EXISTS `student` (
	`id` INT(4) NOT NULL AUTO_INCREMENT COMMENT 'student id',
	`name` VARCHAR(30) NOT NULL DEFAULT 'anonynmous' COMMENT 'student name',
	`pwd` VARCHAR(20) NOT NULL DEFAULT '123456' COMMENT	'student password',
	`gender` VARCHAR(6) NOT NULL DEFAULT 'female' COMMENT 'student gender',
	`birthday` DATETIME DEFAULT NULL COMMENT 'student birthday',
	`gradeid` INT(10) NOT NULL COMMENT 'grade id',
	`address` VARCHAR(100) DEFAULT NULL COMMENT 'student home address',
	`email` VARCHAR(50) DEFAULT NULL COMMENT 'student email',
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

-- ALTER TABLE 表名 ADD CONSTRAINT 约束名 FOREIGN KEY(列名) REFERENCES 表名（列名）
ALTER TABLE `student` ADD CONSTRAINT `FK_gradeid` FOREIGN KEY(`gradeid`) REFERENCES `grade`(gradeid)
```

以上的操作都是物理外键，数据库级别的外键，不建议使用。 避免数据库过多造成困扰



==最佳实现==

数据库就是单纯的表，只用来存数据，只有行（数据）和列（字段）

想使用外键，用程序去实现

#### 3.2 DML语言

数据库意义：数据存储、数据管理

DML：数据操作语言

* insert
* update
* delete

###### 3.2.1 添加

> insert

```sql
-- 插入语句
-- INSERT INTO 表民([字段,]) VALUES([值,])
-- 如果不写表的字段，就会一一匹配
INSERT INTO `grade`(gradename) VALUES ('大四'); 

-- 插入多个值
INSERT INTO `grade`(gradename) VALUES ('大一'),('大二');
```

###### 3.2.2 修改

> update/alter

```sql
-- 修改语句
-- UPDATE 表名 SET 列名=值[,列名=值] [where]
-- 修改学员名字
UPDATE `student` SET `name`='name1' where id = 1

-- 不指定条件，会改动所有表
UPDATE `student` SET `name`='name2'

-- 修改多个字段
UPDATE `student` SET `name`='name1', `email`='email@email.com' where id = 1
```

条件：where子句

| 操作符              | 含义   |
| ------------------- | ------ |
| =                   | 等于   |
| <>或!=              |        |
| <                   |        |
| >                   |        |
| P<=                 |        |
| >=                  |        |
| between `a` and `b` | [a, b] |
| and                 |        |
| or                  |        |



###### 3.2.3 删除

> delete 命令

```sql
-- DELETE FROM 表名 WHERE

-- 删除数据
DELETE FROM `student` WHERE id = 1;

```



> truncate 命令

作用：完全清空一个数据库，表的结构和索引约束不会变。

```sql
-- 清空 student 表
DELETE FROM `student`
TRUNCATE `student`
```



> Truncate 和delete区别

相同点：都能删除数据，都不会删除表结构

不同：

* truncate 重新设置 自增列 计数器会归零
* truncate 不会影响事务





```sql
CREATE TABLE `test` (
	id INT(4) NOT NULL AUTO_INCREMENT,
	coll VARCHAR(20) NOT NULL,
	PRIMARY KEY(id)
) ENGINE=INNODB DEFAULT CHARSET=utf8


INSERT INTO test(coll) VALUES('1'),('2'),('3')

DELETE FROM test -- 不会影响自增

TRUNCATE TABLE test -- 自增会归零
```

delete删除的问题，重启数据库，现象

* innoDB 自增列会从1开始（存在内存中的，断电即失）
* MyISAM 继续从上一个自增量开始（存在文件中的，不会丢失）



### 4、DQL查询数据

#### 4.1 、DQL

（Data Query Language：数据查询语言）

* 所有的查询操作都用它 select
* 简单的查询，复杂的查询它都能做
* ==数据库中最核心的语言，最重要的语言==

数据

```sql
create database if not exists `school`;
-- 创建一个school数据库
use `school`;-- 创建学生表
drop table if exists `student`;
create table `student`(
	`studentno` int(4) not null comment '学号',
    `loginpwd` varchar(20) default null,
    `studentname` varchar(20) default null comment '学生姓名',
    `sex` tinyint(1) default null comment '性别，0或1',
    `gradeid` int(11) default null comment '年级编号',
    `phone` varchar(50) not null comment '联系电话，允许为空',
    `address` varchar(255) not null comment '地址，允许为空',
    `borndate` datetime default null comment '出生时间',
    `email` varchar (50) not null comment '邮箱账号允许为空',
    `identitycard` varchar(18) default null comment '身份证号',
    primary key (`studentno`),
    unique key `identitycard`(`identitycard`),
    key `email` (`email`)
)engine=myisam default charset=utf8;

-- 创建年级表
drop table if exists `grade`;
create table `grade`(
	`gradeid` int(11) not null auto_increment comment '年级编号',
  `gradename` varchar(50) not null comment '年级名称',
    primary key (`gradeid`)
) engine=innodb auto_increment = 6 default charset = utf8;

-- 创建科目表
drop table if exists `subject`;
create table `subject`(
	`subjectno`int(11) not null auto_increment comment '课程编号',
    `subjectname` varchar(50) default null comment '课程名称',
    `classhour` int(4) default null comment '学时',
    `gradeid` int(4) default null comment '年级编号',
    primary key (`subjectno`)
)engine = innodb auto_increment = 19 default charset = utf8;

-- 创建成绩表
drop table if exists `result`;
create table `result`(
	`studentno` int(4) not null comment '学号',
    `subjectno` int(4) not null comment '课程编号',
    `examdate` datetime not null comment '考试日期',
    `studentresult` int (4) not null comment '考试成绩',
    key `subjectno` (`subjectno`)
)engine = innodb default charset = utf8;


-- 插入学生数据 其余自行添加 这里只添加了2行
insert into `student` (`studentno`,`loginpwd`,`studentname`,`sex`,`gradeid`,`phone`,`address`,`borndate`,`email`,`identitycard`)
values
(1000,'123456','张伟',0,2,'13800001234','北京朝阳','1980-1-1','text123@qq.com','123456198001011234'),
(1001,'123456','赵强',1,3,'13800002222','广东深圳','1990-1-1','text111@qq.com','123456199001011233');

-- 插入成绩数据  这里仅插入了一组，其余自行添加
insert into `result`(`studentno`,`subjectno`,`examdate`,`studentresult`)
values
(1000,1,'2013-11-11 16:00:00',85),
(1000,2,'2013-11-12 16:00:00',70),
(1000,3,'2013-11-11 09:00:00',68),
(1000,4,'2013-11-13 16:00:00',98),
(1000,5,'2013-11-14 16:00:00',58);

-- 插入年级数据
insert into `grade` (`gradeid`,`gradename`) values(1,'大一'),(2,'大二'),(3,'大三'),(4,'大四'),(5,'预科班');

-- 插入科目数据
insert into `subject`(`subjectno`,`subjectname`,`classhour`,`gradeid`)values
(1,'高等数学-1',110,1),
(2,'高等数学-2',110,2),
(3,'高等数学-3',100,3),
(4,'高等数学-4',130,4),
(5,'C语言-1',110,1),
(6,'C语言-2',110,2),
(7,'C语言-3',100,3),
(8,'C语言-4',130,4),
(9,'Java程序设计-1',110,1),
(10,'Java程序设计-2',110,2),
(11,'Java程序设计-3',100,3),
(12,'Java程序设计-4',130,4),
(13,'数据库结构-1',110,1),
(14,'数据库结构-2',110,2),
(15,'数据库结构-3',100,3),
(16,'数据库结构-4',130,4),
(17,'C#基础',130,1);




CREATE TABLE `school`.`category`( `categoryid` INT(3) NOT NULL COMMENT 'id', `pid` INT(3) NOT NULL COMMENT '父id 没有父则为1', `categoryname` VARCHAR(10) NOT NULL COMMENT '种类名字', PRIMARY KEY (`categoryid`) ) ENGINE=INNODB CHARSET=utf8 COLLATE=utf8_general_ci; 

INSERT INTO `school`.`category` (`categoryid`, `pid`, `categoryname`) VALUES ('2', '1', '信息技术');
insert into `school`.`CATEGOrY` (`categoryid`, `pid`, `categoryname`) values ('3', '1', '软件开发');
insert into `school`.`category` (`categoryid`, `PId`, `categoryname`) values ('5', '1', '美术设计');
insert iNTO `School`.`category` (`categoryid`, `pid`, `categorynamE`) VAlUES ('4', '3', '数据库'); 
insert into `school`.`category` (`CATEgoryid`, `pid`, `categoryname`) values ('8', '2', '办公信息');
insert into `school`.`category` (`categoryid`, `pid`, `CAtegoryname`) values ('6', '3', 'web开发'); 
inserT INTO `SCHool`.`category` (`categoryid`, `pid`, `categoryname`) valueS ('7', '5', 'ps技术');
```



#### 4.2、 指定查询字段

```sql
-- 查询全部的学生
SELECT * FROM student;

-- 查询指定字段
SELECT studentno, studentname FROM student;

-- 别名 AS
SELECT studentno AS 学号, studentname AS 学生姓名 FROM student;

-- 函数 concat(a, b)
SELECT CONCAT('姓名:',studentname) AS 新名字 FROM student;
```



> 去重 distinct

作用：去成SELECT查询出来的结果中重复的数据，重复的数据只显示一条

```sql
-- 查询有哪些同学参加了考试
-- 发现重复数据，去重
SELECT DISTINCT studentno FROM result;
```

> 数据库的列 (表达式)

```sql
SELECT VERSION(); -- 查询系统版本(函数)
SELECT 100*3-1 AS 计算结果; -- (表达式)
SELECT @@auto_increment_increment; -- 查询自增的步长 （变量）

-- 学员考试成绩 + 1分查看
SELECT studentno, studentresult + 1 AS '提分后' FROM result;
```

==数据库中的表达式：文本值，列，Null，函数，计算表达式，系统变量==

SELECT `表达式` FROM `表名`



#### 4.3 、where条件子句

作用：检索数据中符合条件的值

> 逻辑运算符

* and &&
* or ||
* not !

==尽量书用英文字母==

```sql
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
```



> 模糊查询：比较运算符

* ... IS NULL
* ... IS NOT NULL
* ... BETWEEN ... AND ...
* ... **LIKE** ...

* ... **IN** (... , ...)

```sql
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
```



#### 4.4 、联表查询

 ![img](/Users/johnny/git学习/MySQL.assets/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2h1YW5nX18y,size_16,color_FFFFFF,t_70.png)

```sql
-- ===== 联表查询 JOIN ======
-- JOIN ON 连接查询
-- WHERE 等值查询
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
```

> INNER JOIN

如果表中至少有一个匹配，就返回行

> LEFT JOIN

即使右表中没有匹配，会从左表中返回所有的值

> RIGHT JOIN

即使z左表中没有匹配，会从右表中返回所有的值





> 自连接

```sql
-- 查询父子信息
SELECT a.categoryname AS '父栏目', b.categoryname AS '子栏目'
FROM category a, category b
WHERE a.categoryid = b.pid;
```







#### 4.5 、分页和排序

> 排序

```sql
-- 根据成绩降序排序
SELECT s.studentno, studentname, subjectname, studentresult
FROM student s INNER JOIN result r on s.studentno = r.studentno
INNER JOIN `subject` sub ON r.subjectno = sub.subjectno 
WHERE sub.subjectname='数据库结构-1'
ORDER BY studentresult DESC;
```





> 分页

```sql
-- 每页只显示5条数据
-- LIMIT 起始行(从0开始)，偏移量
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
```







#### 4.6 、子查询

本质：==在where子句用嵌套查询==

```sql
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
```



#### 4.7 、分组和过滤

```sql
-- 查询不同课程的平均分，最高分，最低分
SELECT subjectname, AVG(studentresult), MAX(studentresult), MIN(studentresult)
FROM result r INNER JOIN `subject` s on r.subjectno = s.subjectno
GROUP BY r.subjectno
HAVING AVG(studentresult) > 80;
```





### 5、MySQL函数

#### 5.1、常用函数

```sql
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
```



#### 5.2、 聚合函数

COUNT()

* SUM()
* AVG()
* MAX()
* MIN()

```sql
-- ========= 聚合函数 =========
-- 都能够统计表中的数据

SELECT COUNT(studentname) FROM student; -- 会忽略所有的null值
SELECT COUNT(*) FROM student; -- 不会忽略所有的null值
SELECT COUNT(1) FROM result; -- 不会忽略所有的null值

SELECT SUM(studentresult) as `sum` FROM result;
SELECT AVG(studentresult) as `avg` FROM result;
SELECT MAX(studentresult) as `min` FROM result;
SELECT MIN(studentresult) as `max` FROM result;

```





#### 5.3 、 数据库界别的MD5加密

主要增强算法复杂度和不可逆性

MD5 破解网站的原理，背后有一个字典

```sql
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
```



### 6、事务

#### 6.1 、什么是事务

==要么都成功，要么都失败==

1. SQL 执行 A给B转账 A(1000)  -> 200 B(200)
2. SQL 执行 B收到A的钱 A(800) B(400)

将一组SQL放在一个批次中去执行

> 事务原则：ACID 原子性 一致性 隔离性 持久性

参考博客链接：https://www.jianshu.com/p/fc8a654f2205

**原子性**

要么都成功，要么都失败

**一致性**

事务前后的数据完整性保证一致

**持久性** -- 事务提交

事务一旦提交则不可逆，被持久化到数据库中！

**隔离性**

事务的隔离性是多个用户并发访问数据库时，数据库为每一个用户开启的事务，不能被其他事务的操作数据所干涉，事务时间要相互隔离。



> 隔离导致的一些问题

**脏读：**

一个事务读取了另外一个事务未提交的数据。

**不可重复读：**

在一个事务内读取表中的某一行数据，多次读取结果不同。

**虚度（幻读）:**

一个事务内读取到了别的事务插入的数据，导致前后读取不一致。



> 执行事务

```sql
-- ======= 事务 =======
-- mysql 默认开启事务自动提交
SET autocommit = 0; /* 关闭 */
SET autocommit = 1; /* 开启（默认） */

-- 手动处理事务
SET autocommit = 0; /* 关闭 */

-- 事务开启
START TRANSACTION -- 标记一个事务的开始，从这个之后的sql都在同一个事务内

-- 提交： 持久化
COMMIT
-- 回滚
ROLLBACK

-- 事务结束
SET autocommit = 1; /* 开启（默认） */

-- 了解
SAVEPOINT 保存点名 -- 设置一个事务的保存点
ROLLBACK TO SAVEPOINT 保存点名 -- 回滚到保存点
RELEASE SAVEPOINT 保存点名 -- 撤销保存点
```





> 模拟场景

```sql
CREATE DATABASE shop CHARACTER SET utf8 COLLATE utf8_general_ci;
USE shop;

CREATE TABLE account (
	id INT(3) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL,
	money DECIMAL(9, 2) NOT NULL,
	PRIMARY KEY(id)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO account(`name`, money) VALUES
('A', 2000.00),
('B', 10000.00);

-- 模拟转账
SET autocommit = 0; -- 关闭自动提交
START TRANSACTION; -- 开启一个事务

UPDATE account SET money = money - 500 WHERE `name` = 'A';
UPDATE account SET money = money + 500 WHERE `name` = 'B';

COMMIT; -- 提交事务
ROLLBACK; -- 回滚

SET autocommit = 1; -- 恢复默认值
```



### 7、索引

参考博客:http://blog.codinglabs.org/articles/theory-of-mysql-index.html

> MySQL官方对索引的定义为：索引（Index）是帮助MySQL**高效获取数据**的数据结构。提取句子主干，就可以得到索引的本质：索引是数据结构

#### 7.1 、索引的分类

> 在一个表中，主键索引只有一个，唯一索引可以有多个

* 主键索引 (PRIMARY KEY)
  * 唯一的标识，主键不可重复，只能有一个列作为主键
* 唯一索引 (UNIQUE KEY)
  * 避免重复的列出现，唯一索引可以重复，多个列都可以标识为唯一索引
* 常规索引 (KEY/INDEX)
  * 默认的，index 关键字来设置
* 全文索引 (FULLTEXT)
  * 在特定的数据库引擎下才有， MyISAM
  * 快速定位数据



基础语法

```sql
-- 索引的使用
/* 
1. 在创建的表的时候给字段增加索引
2. 创建完毕后，增加索引
*/

-- 显示所有的索引信息 
SHOW INDEX FROM student;

-- 增加一个索引
ALTER TABLE student ADD FULLTEXT INDEX studentname_index(studentname);

-- EXPLAIN 分析SQL执行的状况
EXPLAIN SELECT * FROM student; -- 非全文索引
EXPLAIN SELECT * FROM student WHERE MATCH(studentname) AGAINST('张');
```



#### 7.2 、测试索引

```sql
CREATE TABLE `app_user` (
`id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
`name` VARCHAR(50) DEFAULT'' COMMENT'用户昵称',
`email` VARCHAR(50) NOT NULL COMMENT'用户邮箱',
`phone` VARCHAR(20) DEFAULT'' COMMENT'手机号',
`gender` TINYINT(4) UNSIGNED DEFAULT '0'COMMENT '性别（0：男;1:女）',
`password` VARCHAR(100) NOT NULL COMMENT '密码',
`age` TINYINT(4) DEFAULT'0'  COMMENT '年龄',
`create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
`update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COMMENT = 'app用户表';

-- 插入100万条数据
DELIMITER $$
CREATE FUNCTION generate_data()
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE num INT DEFAULT 1000000;
	DECLARE i INT DEFAULT 0;
	
	WHILE i < num DO
		-- 插入语句
		INSERT INTO app_user(`name`, email, phone, gender, `password`, age) VALUES
		(CONCAT('用户',i), 
		'1023921169@qq.com', 
		CONCAT('18',FLOOR(RAND()* (999999999-100000000))+100000000),
		FLOOR(RAND() * 2),
		UUID(),
		FLOOR(RAND()*100)
		);
		SET i = i + 1;
	END WHILE;
	RETURN i;
END;

SELECT generate_data();
SHOW INDEX FROM app_user;

SELECT * FROM app_user WHERE `name` = '用户9999';

EXPLAIN SELECT * FROM app_user WHERE `name` = '用户9999';

-- id_表名_字段名
-- CREATE INDEX 索引名 ON 表名(字段名);
CREATE INDEX id_app_user_name ON app_user(`name`);
```

索引在小数据量的时候，用处不大，但是在大数据的时候，区别十分明显。



#### 7.3 、索引原则

* 索引不是越多越好
* 不要对经常变动的数据加索引
* 小数据量的表不需要加索引
* 索引一般加在常用来查询的字段上



> 索引的数据结构

Hash类型的索引

Btree：innoDB的默认数据结构





### 8 、权限管理和备份

#### 8.1 、用户管理

![image-20210418165907338](/Users/johnny/git学习/MySQL.assets/image-20210418165907338.png)



> SQL命令

用户表: mysql.User

```sql
-- 创建用户
-- CREATE USER 用户名 IDENTIFIED BY '密码'
CREATE USER dingjiahao IDENTIFIED BY '123456';

-- 修改密码（当前用户密码）
SET PASSWORD = PASSWORD('111111');

-- 修改密码（指定用户密码）
SET PASSWORD FOR dingjiahao = PASSWORD('111111');

-- 重命名
RENAME USER dingjiahao TO dingjiahao2;

-- 用户授权
-- ALL PRIVILEGES 除了给别人授权，其他都能够干
GRANT ALL PRIVILEGES ON *.* TO dingjiahao;

-- 查看权限
SHOW GRANTS FOR dingjiahao;
SHOW GRANTS FOR root@localhost;

-- 撤销权限
REVOKE ALL PRIVILEGES ON *.* FROM dingjiahao;

-- 删除用户
DROP USER dingjiahao;
```



#### 8.2 、MySQL备份

* 保证重要的数据不丢失
* 数据转移

MySQL数据库备份的方式

* 直接拷贝物理文件
* 在可视化工具中手动导出
* 使用命令行导出 mysqldump

```shell
# mysqldump -h 主机 -u 用户名 -p 密码 数据库名 表名 > 物理磁盘位置
mysqldump -hlocalhost -uroot -p123456 school student > /Users/admin/Desktop

# mysqldump -h 主机 -u 用户名 -p 密码 数据库名 表1 表2 表3 > 物理磁盘位置
mysqldump -hlocalhost -uroot -p123456 school student grade result > /Users/admin/Desktop

# mysqldump -h 主机 -u 用户名 -p 密码 数据库名 > 物理磁盘位置
mysqldump -hlocalhost -uroot -p123456 school > /Users/admin/Desktop

# 导入文件
# source 文件
source data.sql

mysql -u用户名 -p密码 数据库名 < 文件
```



### 9、规范数据库设计

#### 9.1 、为什么需要设计

**糟糕的数据库设计：**

* 数据冗余，浪费空间
* 数据库插入和删除都会麻烦、异常（屏蔽使用物理外键）
* 程序的性能差

**良好的数据库设计：**

* 节省内存空间
* 保证数据的完整性
* 方便我们开发系统

软件开发中，关于数据库的设计

* 分析需求：分析业务和需要处理的数据库的需求
* 概要设计：设计关系图 ER图



**设计数据库的步骤：（个人博客）**

* 收集信息，分析需求
  * 用户表（用户登陆注销，用户的个人信息，写博客，创建分类）
  * 分类表（文章分类，谁创建的）
  * 文章表（文章的信息）
  * 评论表
  * 友链表（友链信息）
  * 自定义表（系统信息，某个关键的字，或者一些主字段） key : value
* 标识实体（把需求落地到每个字段）
* 标识实体之间的干洗
  * 写博客：user -> blog
  * 创建分类：user -> category
  * 关注：user -> user
  * 友链：links
  * 评论：user-user-blog

#### 9.2 、三大范式

为什么需要数据规范化？

* 信息重复	
* 更新异常
* 插入异常
  * 无法正常显示信息
* 删除异常
  * 丢失有效信息



**第一范式（1NF）**

原子性：保证每一列不可再分



**第二范式（1NF）**

前提：满足第二范式

每张表只描述一件事情

消除局部依赖



**第三范式（3NF）**

前提：满足第一范式、第二范式

第三范式需要确保数据表中的每一列数据都和主键直接相关，而不能间接相关

消除传递依赖





**规范性和性能的问题**

关联查询的表不得超过三张表

* 考虑商业化的需求和目标 (成本，用户体验)
* 在规范性能额问题的时候，需要适当的考虑一下规范性。
* 故意给某些表增加一些冗余的字段。（从多表查询中变为单表查询）
* 故意增加一些计算列（从大数据量降低为小数据量的查询：索引）





### 10、JDBC

#### 10.1 、数据库驱动

通过数据库驱动，操作数据库

#### 10.2 、JDBC

不同的数据库需要不同的数据库驱动

SUN公司为了简化开发人员的（对数据库的统一）操作，提供了一个（java操作数据库的）规范，俗称JDBC

这些规范的实现由具体的厂商去做

对于开发人员来说，我们只需要掌握JDBC接口的操作即可



`java.sql`

`javax.sql`

还需要导入数据库驱动包 mysql-connector-java





#### 10.3 第一个JDBC程序

数据

```sql
CREATE DATABASE jdbcStudy CHARACTER SET utf8 COLLATE utf8_general_ci;

USE jdbcStudy;

CREATE TABLE `users`(
	id INT PRIMARY KEY,
	NAME VARCHAR(40),
	PASSWORD VARCHAR(40),
	email VARCHAR(60),
	birthday DATE
);

INSERT INTO `users`(id,NAME,PASSWORD,email,birthday)
VALUES(1,'zhansan','123456','zs@sina.com','1980-12-04'),
(2,'lisi','123456','lisi@sina.com','1981-12-04'),
(3,'wangwu','123456','wangwu@sina.com','1979-12-04')
```

编写测试数据

```java
// 1. 加载驱动
// DriverManager.registerDriver(new Driver());
Class.forName("com.mysql.cj.jdbc.Driver");

// 2. 用户信息和url
// "协议://主机地址:端口号/数据库名?参数&参数&参数&参数"
// oracle -- 1521
// jdbc:oracl:thin:@localhost:151:sid
String url = "jdbc:mysql://localhost:3306/jdbcstudy?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai";
String username = "root";
String password = "Djh1023921169?";

// 3. 连接成功，数据库对象
Connection connection = DriverManager.getConnection(url, username, password);

/*
connection.rollback();
connection.commit();
connection.setAutoCommit(false);
*/

// 4. 执行SQL的对象
Statement statement = connection.createStatement();

/*
statement.executeQuery(); // 查询操作
statement.execute(); // 执行任何SQL
statement.executeUpdate(); // 更新，插入，删除。返回受影响行数
*/

// 5. 执行SQL的对象去执行SQL
String sql = "SELECT * FROM users";
ResultSet resultSet = statement.executeQuery(sql);

/*        
resultSet.getObject();
resultSet.getString();
resultSet.getInt();
resultSet.getFloat();
resultSet.getDouble();
*/

/*
resultSet.beforeFirst(); // 移动到最前面
resultSet.afterLast(); // 移动到最后面
resultSet.next(); // 移动到下一个数据
resultSet.previous(); 移动到前一个数据
resultSet.absolute(100); // 移动到指定行        
*/


while (resultSet.next()) {
  System.out.println("id=" + resultSet.getObject("id"));
  System.out.println("name=" + resultSet.getObject("NAME"));
  System.out.println("pwd=" + resultSet.getObject("PASSWORD"));
  System.out.println("email=" + resultSet.getObject("email"));
  System.out.println("birth=" + resultSet.getObject("birthday"));
}

// 6. 释放连接
resultSet.close();
statement.close();
connection.close();
```





> 代码实现

1. 提取工具类
2. 增加增删改的方法，`executeUpdate`

> 增加

```java
Connection conn = null;
Statement st = null;
ResultSet rs = null;

try {
  conn = JdbcUtils.getConnection();
  st = conn.createStatement();
  String sql = "INSERT INTO users(id, `name`, `password`, email, birthday) " +
    "VALUES(4, 'ding', '123456', '1023921169@qq.com', '2020-01-01')";
  int i = st.executeUpdate(sql);
  if (i > 0) {
    System.out.println("插入成功");
  }
} catch (SQLException throwables) {
  throwables.printStackTrace();
} finally {
  JdbcUtils.release(conn, st, rs);
}
```

> 删除

```java
Connection conn = null;
Statement st = null;
ResultSet rs = null;

try {
  conn = JdbcUtils.getConnection();
  st = conn.createStatement();
  String sql = "DELETE FROM users WHERE id = 4";

  int i = st.executeUpdate(sql);
  if (i > 0) {
    System.out.println("删除成功");
  }
} catch (SQLException throwables) {
  throwables.printStackTrace();
} finally {
  JdbcUtils.release(conn, st, rs);
}
```

> 更新

```java
Connection conn = null;
Statement st = null;
ResultSet rs = null;

try {
  conn = JdbcUtils.getConnection();
  st = conn.createStatement();
  String sql = "UPDATE users SET `name`='dingjiahao', email='dingjiahao@163.com' WHERE id = 1";

  int i = st.executeUpdate(sql);
  if (i > 0) {
    System.out.println("更新成功");
  }
} catch (SQLException throwables) {
  throwables.printStackTrace();
} finally {
  JdbcUtils.release(conn, st, rs);
}
```

> 查询

```java
Connection conn = null;
Statement st = null;
ResultSet rs = null;

try {
  conn = JdbcUtils.getConnection();
  st = conn.createStatement();

  String sql = "SELECT * FROM users WHERE id = 1";

  rs = st.executeQuery(sql);

  while(rs.next()) {
    System.out.println(rs.getString("name"));
  }
} catch (SQLException throwables) {
  throwables.printStackTrace();
} finally {
  JdbcUtils.release(conn, st, rs);
}
```





#### 10.4 、 SQL 注入问题

sql存在漏洞，会被攻击导致数据泄露，==SQL会被拼接or==

```java
public static void main(String[] args) {
  // login("dingjiahao", "123456");
  // SELECT * FROM users WHERE `name`= '' or '1=1'  AND `password` = '' or '1=1';
  login("'or ' 1 = 1", "'or' 1=1");
}

// 登陆业务
public static void login(String username, String password) {
  Connection conn = null;
  Statement st = null;
  ResultSet rs = null;

  try {
    conn = JdbcUtils.getConnection();
    st = conn.createStatement();


    String sql = "SELECT * FROM users WHERE `name`='" + username + "' AND `password`='" + password + "'" ;

    rs = st.executeQuery(sql);

    while(rs.next()) {
      System.out.println(rs.getString("name"));
      System.out.println(rs.getString("password"));
    }
  } catch (SQLException throwables) {
    throwables.printStackTrace();
  } finally {
    JdbcUtils.release(conn, st, rs);
  }
}
```



#### 10.4 PreparedStament对象

PreparedStament 可以防止SQL注入，效率更好

> 增加

```java
package com.ding.lesson03;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

public class TestInsert {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;

        try {
            conn = JdbcUtils.getConnection();

            // 区别
            // 使用问号占位符代替参数
            String sql = "delete from users where id = ?";
            pstm = conn.prepareStatement(sql); // 预编译SQL，先写SQL，然后不执行

            // 手动给参数赋值
            pstm.setInt(1, 4);
            // 执行
            int i = pstm.executeUpdate();
            if (i > 0) {
                System.out.println("删除成功");
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, null);
        }
    }
}

```



> 删除

```java
package com.ding.lesson03;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

public class TestDelete {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;

        try {
            conn = JdbcUtils.getConnection();

            // 区别
            // 使用问号占位符代替参数
            String sql = "INSERT INTO users(id, `name`, `password`, email, birthday) VALUES(?,?,?,?,?)";
            pstm = conn.prepareStatement(sql); // 预编译SQL，先写SQL，然后不执行

            // 手动给参数赋值
            pstm.setInt(1, 4);
            pstm.setString(2, "dingjiahao");
            pstm.setString(3, "123456");
            pstm.setString(4, "dingjiahao@163.com");
            // new Date().getTime() 获得时间戳
            pstm.setDate(5, new java.sql.Date(new Date().getTime()));

            // 执行
            int i = pstm.executeUpdate();
            if (i > 0) {
                System.out.println("插入成功");
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, null);
        }
    }
}

```



> 更新

```java
package com.ding.lesson03;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

public class TestUpdate {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;

        try {
            conn = JdbcUtils.getConnection();

            // 区别
            // 使用问号占位符代替参数
            String sql = "UPDATE users SET `name` = ? WHERE id = ?";
            pstm = conn.prepareStatement(sql); // 预编译SQL，先写SQL，然后不执行

            // 手动给参数赋值
            pstm.setString(1, "lisi");
            pstm.setInt(2, 1);
            // 执行
            int i = pstm.executeUpdate();
            if (i > 0) {
                System.out.println("更新成功");
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, null);
        }
    }
}
```



> 查询

```java
package com.ding.lesson03;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestSelect {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtils.getConnection();

            String sql = "SELECT * FROM users WHERE `name` = ? AND `password` = ?";
            pstm = conn.prepareStatement(sql);

            pstm.setString(1, "lisi");
            pstm.setString(2, "123456");

            rs = pstm.executeQuery();
            while (rs.next()) {
                System.out.println(rs.getString("name"));
                System.out.println(rs.getString("password"));
                System.out.println(rs.getString("email"));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}

```



> 防止SQL注入

```java
package com.ding.lesson03;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.*;

public class SqlInjection {
    public static void main(String[] args) {
        login("lisi", "123456");
        // SELECT * FROM users WHERE `name`= '' or '1=1'  AND `password` = '' or '1=1';
//        login("'or ' 1 = 1", "'or' 1=1");
    }

    // 登陆业务
    public static void login(String username, String password) {
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtils.getConnection();
            // PreparedStatment 防止SQL注入的本质，把传递进来的参数当作字符
            // 假设其中存在转义字符，比如说 ' 会被直接转义
            String sql = "SELECT * FROM users WHERE `name`= ? AND `password`= ? ";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, username);
            pstm.setString(2, password);
            rs = pstm.executeQuery();

            while(rs.next()) {
                System.out.println(rs.getString("name"));
                System.out.println(rs.getString("password"));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, rs);
        }
    }
}
```



#### 10.5 事务

```java
package com.ding.lesson04;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestTransaction {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtils.getConnection();

            // 关闭数据库的自动提交
            conn.setAutoCommit(false);
            
            String sql1 = "UPDATE account set money = money - 100 WHERE name = 'A'";
            pstm = conn.prepareStatement(sql1);
            pstm.executeUpdate();
            
//            int  x = 1/0;
            
            String sql2 = "UPDATE account set money = money + 100 WHERE name = 'B'";
            pstm = conn.prepareStatement(sql2);
            pstm.executeUpdate();
            
            // 业务完毕，提交事务
            conn.commit();
            System.out.println("成功");

        } catch (SQLException throwables) {
            try {
                // 如果失败，默认回滚
                conn.rollback(); // 如果失败，回滚事务（显示定义）
            } catch (SQLException e) {
                e.printStackTrace();
            }
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, rs);
        }
    }
}
```







#### 10.9 、数据库连接池

数据库连接 --  执行完毕 -- 释放

连接 -- 释放 十分浪费系统资源

**池化技术：准备一些预先的资源，过来就连接预先准备好的**



常用连接数

最小连接数: 10

最大连接数: 100 业务最高承载上限

等待超时: 100ms



编写连接池，实现一个接口 DataSource



> 开源数据源实现

DBCP

C3P0

Druid: 阿里巴巴



使用了这些数据库连接池之后，我们在项目开发中就不需要编写连接数据库的代码



> DBCP

```java
package com.ding.lesson05.utils;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.commons.dbcp.BasicDataSourceFactory;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class JdbcUtilsDBCP {

    private static DataSource dataSource =null;
    static {
        try {
            InputStream in = JdbcUtilsDBCP.class.getClassLoader().getResourceAsStream("dbcpconfig.properties");
            Properties properties = new Properties();
            properties.load(in);

            // 创建数据源 工厂模式 --> 创建
            dataSource = BasicDataSourceFactory.createDataSource(properties);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 获取连接
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // 释放连接资源
    public static void release(Connection conn, Statement st, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        if (st != null) {
            try {
                st.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
}
```





> C3P0

```java
package com.ding.lesson05.utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.apache.commons.dbcp.BasicDataSourceFactory;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class JdbcUtilsC3P0 {

    private static ComboPooledDataSource dataSource =null;
    static {
        try {

            // 创建数据源
//             dataSource = new ComboPooledDataSource("MySQL"); 配置文件写法
//            dataSource = new ComboPooledDataSource();
//            dataSource.setDriverClass();
//            dataSource.setUser();
//            dataSource.setPassword();
//            dataSource.setJdbcUrl();
//
//            dataSource.setMaxPoolSize();
//            dataSource.setMinPoolSize();

            dataSource = new ComboPooledDataSource();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 获取连接
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // 释放连接资源
    public static void release(Connection conn, Statement st, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        if (st != null) {
            try {
                st.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }
}
```



> 结论

无论使用什么数据源，本质还是一样的，DataSource接口不会变，方法不会变

