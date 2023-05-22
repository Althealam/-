 /*建立功能*/
  /*1.创建视图显示所有逾期未归还的借阅信息
  /*包括借阅人姓名，借阅人类别，书名，借出日期，应归还日期，逾期时长*/
  DROP VIEW IF EXISTS overdue_borrows;
  CREATE VIEW overdue_borrows 
     AS 
     SELECT Borrowers.name AS '借阅人姓名',Borrowers.type AS '借阅人类别',
     Books.BookName AS '书名',Borrowing.Borrow_date AS '借阅日期',
	 Borrowing.Return_date AS '应归还日期',
	 DATEDIFF(NOW(),Borrowing.Return_date) AS '逾期时长'
	 FROM Borrowing,Books,Borrowers
     WHERE NOW()>Return_date
	 AND Borrowing.BookID=Books.BookID
     AND Borrowing.id=Borrowers.id;
     
  SELECT * FROM overdue_borrows;
  
  
  /*2.创建存储过程，每借出一本图书，向借阅信息表中加入一条记录并且修改Books表格*/
  /*成功，但是出现一个问题：如果一个人已经借过了一本书则不能再借*/
  DROP PROCEDURE IF EXISTS borrowbooks;
  DELIMITER $$ 
  CREATE PROCEDURE borrowbooks(id VARCHAR(5),BookID VARCHAR(4))
  BEGIN
      UPDATE Books SET Is_borrowed=1 WHERE Books.BookID=BookID;
	  UPDATE Borrowers SET borrowed_num=borrowed_num+1 WHERE id=Borrowers.id;
      
      IF EXISTS (SELECT id FROM Borrowers WHERE Borrowers.id=id)
        AND EXISTS (SELECT BookID FROM Books WHERE Books.BookID=BookID)
	  THEN
        INSERT INTO borrowing(id,BookID,Borrow_date,Return_date,Actual_return_date)
        VALUES(id,BookID,NOW(),DATE_ADD(NOW(),INTERVAL 1 MONTH),NULL);
      ELSE
         SELECT 'can not insert data due to foreign key constraint failure';
	  END IF;
  END $$
  DELIMITER ;

  
  /*3.创建存储过程，每归还一本图书，修改借阅信息表中相应的记录*/
  DROP PROCEDURE IF EXISTS returnbooks;
  DELIMITER $$
  CREATE PROCEDURE returnbooks(borrower_id VARCHAR(5),Books_ID VARCHAR(4))
  BEGIN 
      UPDATE Borrowing SET Actual_return_date=NOW() WHERE BookID=Books_ID AND id=borrower_id;
	  UPDATE Books SET Is_borrowed=0 WHERE BookID=Books_ID;
	  UPDATE Borrowers SET borrowed_num=borrowed_num-1 WHERE id=borrower_id;
  END $$
  DELIMITER ;
  
  
  /*4.创建存储函数，根据图书编号查借阅人姓名，并调用该函数查询‘张三’已借未还的图书情况*/
  /*(1)创建存储函数*/
  DROP FUNCTION IF EXISTS findBorrower;
  DELIMITER $$
  CREATE FUNCTION findBorrower(BookID VARCHAR(4))
  RETURNS VARCHAR(50)
  BEGIN 
     DECLARE borrower_name VARCHAR(50);
     DECLARE borrower_id VARCHAR(5);
     SELECT ID INTO borrower_id FROM Borrowing 
     WHERE BookID=Borrowing.BookID AND Borrowing.Actual_return_date IS NULL;
     SELECT name INTO borrower_name FROM Borrowers
     WHERE borrower_id=Borrowers.id;
     RETURN borrower_name;
  END $$
  DELIMITER ;
  /*(2)调用函数，查询张三已借未还的情况*/
  SELECT BookID,Borrow_date,Return_date
  FROM Borrowing
  WHERE findBorrower(BookID)='张三' AND Actual_return_date IS NULL;
  

  /*5.创建存储函数，计算某借阅人还能借阅的图书数目，学生限额5本，教师限额10本*/
  /*考虑到可能会出现同名同姓的情况，因此使用学号作为参考*/
  DROP FUNCTION IF EXISTS get_books_amount;
  SET global log_bin_trust_function_creators=TRUE;
  DELIMITER $$
  CREATE FUNCTION get_books_amount(borrower_id VARCHAR(5))
  RETURNS VARCHAR(2)
  BEGIN
     DECLARE books_amount INT;
     DECLARE borrower_type VARCHAR(2);
     DECLARE borrow_num INT;
     SET borrower_type=(SELECT type FROM Borrowers WHERE borrower_id=Borrowers.id);
     SET borrow_num=(SELECT borrowed_num FROM Borrowers WHERE borrower_id=Borrowers.id);
     CASE 
     WHEN borrower_type='教师' THEN 
     SET books_amount=10-borrow_num;
     WHEN borrower_type='学生' THEN 
     SET books_amount=5-borrow_num;
     END CASE;
     RETURN books_amount;
   END $$
   DELIMITER ;
   
   
   /*6.创建存储函数，查询某本图书逾期未还的时长
   并调用该函数显示所有逾期未归还图书的书名，借阅人和逾期时长并按逾期时长排序*/
   /*为了避免出现同名的书，我们使用书的编号作为查询依据*/
   /*(1)查询某本图书逾期未还的时长*/
   DROP FUNCTION IF EXISTS get_overdue_duration;
   DELIMITER $$
   CREATE FUNCTION get_overdue_duration(BookID VARCHAR(4))
   RETURNS INT
   BEGIN
      DECLARE days INT;
      SELECT DATEDIFF(NOW(),Borrowing.Return_Date) INTO days FROM Borrowing
      WHERE Borrowing.BookID=BookID AND Borrowing.Actual_return_date IS NULL
      AND NOW()>Borrowing.Return_Date;
      RETURN days;
   END $$
   DELIMITER ;
   /*(2)查询所有逾期未归还图书的书名，借阅人和逾期时间，并且按照逾期时长排序*/
   SELECT Books.BookName,Borrowers.name,DATEDIFF(NOW(),Borrowing.Return_Date)
   AS overdue_duration FROM Borrowing,Books,Borrowers
   WHERE Books.BookID=Borrowing.BookID AND Borrowers.id=Borrowing.id
   AND Borrowing.Actual_return_date IS NULL
   AND DATEDIFF(NOW(),Borrowing.Return_date)>0
   ORDER BY overdue_duration DESC;
      
      
   /*7.创建存储函数，查询某借阅人有几本逾期未还图书
   并调用该函数显示有逾期未归还图书的借阅人和未归还图书数目*/
   /*(1)创建存储函数*/
   DROP FUNCTION IF EXISTS overdue_books_count;
   DELIMITER $$
   CREATE FUNCTION overdue_books_count(Borrower_id VARCHAR(5))
   RETURNS INT
   BEGIN
     DECLARE count INT;
     SELECT COUNT(*) INTO count FROM Borrowing 
     WHERE Borrowing.id=Borrower_id
     AND Actual_return_date IS NULL
     AND DATEDIFF(NOW(),Return_date)>0;
     RETURN count;
	END $$
    DELIMITER ;
    /*(2)查询有逾期未归还书籍的借阅人以及未归还图书数目*/
    SELECT Borrowers.name AS Borrower_name ,overdue_books_count(Borrowers.id) AS overdue_books_count
    FROM Borrowers WHERE overdue_books_count(Borrowers.id)>0 ORDER BY overdue_books_count DESC;

    
    /*8.创建存储函数，利用游标计算计算某借阅人逾期未还图书应缴纳的罚款
    逾期30日内罚款1元，逾期90日内罚款3元，逾期超过90日罚款5元
    调用该函数显示所有应缴纳罚款的借阅人的姓名，逾期罚款和电话*/
    /*(1)构造存储函数*/
    DROP FUNCTION IF EXISTS calculate_find;
    DELIMITER $$
    CREATE FUNCTION calculate_fine(Borrower_id VARCHAR(5))
    RETURNS DECIMAL(10,2)
    BEGIN
      DECLARE fine DECIMAL(10,2);
      DECLARE due_date DATE;
      DECLARE days_late INT;
      
      SELECT MAX(Return_Date) INTO due_date FROM Borrowing WHERE Borrowing.id=Borrower_id
      AND Actual_Return_date IS NULL;
      
      SELECT DATEDIFF(NOW(),due_date) INTO days_late;
      
      IF days_late<=30 THEN 
         SET fine=days_late*1.00;
	  ELSEIF days_late<=90 THEN
         SET fine=30.00+(days_late-30)*3.00;
	  ELSE
         SET fine=270.00+(days_late-90)*5.00;
	  END IF;
      
      RETURN fine;
	END $$
      DELIMITER ;
	/*(2)调用函数并且显示所有应缴纳罚款的借阅人的姓名、逾期罚款和电话*/
    SELECT Borrowers.name,calculate_fine(Borrowers.id) AS overdue_fine,Borrowers.tel
    FROM Borrowers
    WHERE calculate_fine(Borrowers.id)>0
    ORDER BY calculate_fine(Borrowers.id) DESC;
	
    
    /*9.创建两个触发器，分别在借出或归还图书时，修改借阅人表中的已借数目字段*/
    /*(1)触发器一号：在借书时触发*/
    DROP TRIGGER IF EXISTS loan_book_trigger;
    DELIMITER $$
    CREATE TRIGGER loan_book_trigger AFTER INSERT ON Borrowing
    FOR EACH ROW
    BEGIN
       UPDATE Borrowers SET borrowed_num=borrowed_num+1
       WHERE id=NEW.id;
    END $$
    DELIMITER ;
    
    /*(2)触发器二号：在还书时触发*/
    DROP TRIGGER IF EXISTS return_book_trigger;
    DELIMITER $$
    CREATE TRIGGER return_book_trigger AFTER UPDATE ON Borrowing
    FOR EACH ROW
    BEGIN
      IF OLD.Actual_Return_date IS NULL AND NEW.Actual_Return_date IS NOT NULL
      THEN UPDATE Borrowers
      SET Borrowed_num=Borrowed_num-1
      WHERE id=OLD.id;
      END IF;
	END $$
    DELIMITER ;
    
    
    /*10.创建触发器，当借阅者已借阅的书籍数目达到限额时，禁止借入新的书籍*/
    DROP TRIGGER IF EXISTS check_borrow_limit_trigger;
    DELIMITER $$
    CREATE TRIGGER check_borrow_limit_trigger
    BEFORE INSERT ON Borrowing
    FOR EACH ROW
    BEGIN 
      DECLARE borrowed_count INT;
      SELECT borrowed_num INTO borrowed_count FROM Borrowers WHERE id=NEW.id;
	  CASE
	  WHEN Borrowers.type='教师' THEN
      IF borrowed_count>=10 THEN
        SELECT 'Borrow limit reached';
	  END IF;
      WHEN Borrowers.type='学生' THEN
      IF borrowed_count>=5 THEN
        SELECT 'Borrow limit reached';
	 END IF;
     END CASE;
	END $$
	DELIMITER ;
    
