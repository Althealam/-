/*创建数据库：图书借阅系统*/
/*数据库情况
图书只有一本，被借走后其他人就不能再借*/

DROP DATABASE IF EXISTS Book_borrowing_system;
CREATE DATABASE Book_borrowing_system;

/*创建表格*/
/*1.借阅人*/
USE Book_borrowing_system;
DROP TABLE IF EXISTS Borrowers;
CREATE TABLE Borrowers
(id varchar(5) NOT NULL COMMENT '证件号',
 name varchar(50) COMMENT '姓名' ,
 type varchar(10) NOT NULL COMMENT '类别（教师，学生）',
 borrowed_num int NOT NULL DEFAULT 0 COMMENT '已借数目',
 tel varchar(6) NOT NULL COMMENT '电话',
 CONSTRAINT tel_length CHECK (LENGTH(tel)=6),
 PRIMARY KEY(id))
 /*不可以同时将一个变量设置为主键和外键
 因为一个主键为唯一的并且不能为NULL，而一个外键列必须引用另一个表格中的主键列*/
 COMMENT='借阅人表';
 
 INSERT INTO Borrowers(id,name,type,borrowed_num,tel)
 VALUES
 ('00001','李华','教师','2','198201'),
 ('00002','张三','教师','2','198211'),
 ('00003','李四','教师','0','198222'),
 ('00004','王五','教室','1','198363'),
 ('10001','林一','学生','1','123456'),
 ('10002','游一','学生','0','123455'),
 ('10003','苏二','学生','3','123454');
 
 SELECT * FROM Borrowers;


/*2.图书*/
USE Book_borrowing_system;
DROP TABLE IF EXISTS Books;
CREATE TABLE Books
(BookID varchar(4) NOT NULL COMMENT '图书编号',
 BookName varchar(50) COMMENT '书名',
 BookType varchar(50) COMMENT '类别',
 Is_borrowed tinyint NOT NULL DEFAULT 0 COMMENT '是否借出，0未借出，1已借出',
 PRIMARY KEY(BookID))
 COMMENT='图书';
 
 INSERT INTO Books(BookID,BookName,BookType,Is_borrowed)
 VALUES
 ('0001','The Left Hand of Darkness','参考书',1),
 ('0002','On Earth We re Briefly Gorgeous','杂志',1),
 ('0003','Tender is the Night','寓言书',1),
 ('0004','The Sound and the Fury','字典',0),
 ('0005','By the Light of My Fathers Smile','杂志',1),
 ('0006','The Heart is a Lonely Hunter','童话书',1),
 ('0007','These Lovers Fled Away','寓言书',1),
 ('0008','Where Angels Fear to Tread','学校课本',1),
 ('0009','The Unbearable Lightness of Being','小说',1),
 ('0010','Pilgrimage to the West','小说',0),
 ('0011','Pig and Pink','童话书',0),
 ('0012','The Night','学校课本',0),
 ('0013','Do you like the cat?','寓言书',0);
 
 SELECT * FROM Books;
 
 
 /*3.借阅信息*/
 USE Book_borrowing_system;
 DROP TABLE IF EXISTS Borrowing;
 CREATE TABLE Borrowing
 (id varchar(5) NOT NULL COMMENT '证件号',
  BookID varchar(4) NOT NULL COMMENT '图书编号',
  Borrow_Date date NOT NULL COMMENT '借出日期',
  Return_Date date NOT NULL COMMENT '应归还日期（计算字段）',
  Actual_return_date date COMMENT '实际归还日期',
  FOREIGN KEY (id) REFERENCES Borrowers(id),
  FOREIGN KEY (BookID) REFERENCES Books(BookID))
  COMMENT='借阅信息表';
  
  /*已经借走并且已经归还的书则记为Is_borrowed=0*/
  INSERT INTO Borrowing(id,BookID,Borrow_Date,Return_Date,Actual_return_date)
  VALUES
  ('00001','0009','2023-03-28','2023-03-28',NULL),
  ('00001','0008','2023-03-28','2023-03-28',NULL),
  ('00002','0001','2023-02-10','2023-03-10',NULL),
  ('00002','0005','2023-01-15','2023-02-15',NULL),
  ('10001','0007','2023-04-20','2023-05-20',NULL),
  ('10003','0006','2023-01-18','2023-02-18',NULL),
  ('10003','0002','2023-03-01','2023-04-01',NULL),
  ('10003','0003','2023-03-01','2023-04-01',NULL),
  ('10002','0004','2023-03-01','2023-04-01','2023-03-28'),
  ('10001','0013','2023-04-05','2023-05-05','2023-04-29');
    
  SELECT * FROM Borrowing;
  
  
 
