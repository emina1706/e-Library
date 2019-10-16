CREATE VIEW KNJIGE 
AS 
  SELECT B.title, A.first_name
  From dbo.Book AS B
  INNER JOIN dbo.Author AS A
  ON B.author_id = A.author_id
GO

SELECT *FROM [KNJIGE]

ALTER VIEW KNJIGE
AS 
  SELECT B.title, A.first_name, A.last_name
  FROM dbo.Book AS B
  INNER JOIN dbo.Author AS A
  ON B.author_id = A.author_id
GO

SELECT * FROM KNJIGE


CREATE PROCEDURE spAuthor
  @name nvarchar(50),
  @lastname nvarchar(50) 
AS BEGIN 
    SELECT * FROM dbo.Author WHERE first_name = @name OR [last_name] = @lastname
END;

ALTER PROCEDURE spAuthor
  @name nvarchar(50),
  @lastname nvarchar(50) 
AS 
BEGIN 
    SELECT * FROM dbo.Author WHERE first_name = @name OR [last_name] = @lastname
END;

EXECUTE spAuthor 'Herman', 'Hesse' 
GO


CREATE PROCEDURE spInsertCostumer
  @CustomerID int,
  @Name varchar(45),
  @LastName varchar(45),
  @email varchar(50),
  @adress int,
  @date datetime,
  @storeID int
AS 
BEGIN
 INSERT INTO dbo.Customer(customer_id,first_name,last_name,email,address_id,registration_date,store_id)
 VALUES  (@CustomerID ,@Name,@LastName,@email,@adress,@date,@storeID)
 SELECT * FROM dbo.customer
 WHERE customer_id = @CustomerID AND
 first_name = @Name AND
 last_name = @LastName AND
 email= @email AND
 address_id = @adress AND
 registration_date=@date AND
 store_id=@storeID;
END

EXEC spInsertCostumer 14, 'Emina', 'Kocic', 'emina111@gmail.com', 1, SYSDATETIME, 2;


ALTER PROCEDURE sp_BookInStock
 @Book int,
 @Store int
 AS
BEGIN
 SELECT COUNT(book_id) AS BookINStock, Book.title FROM dbo.Inventory JOIN Book ON Book.book_id=Inventory.book_id
 WHERE book_id = @Book AND store_id = @Store;
END
 
EXEC sp_BookInStock 2,2


ALTER PROCEDURE spCustomersInStore
 @Store int
 AS
BEGIN
   SELECT customer_id,last_name, first_name,registration_date FROM dbo.customer 
   INNER JOIN Store ON Store.store_id=customer.store_id
   WHERE customer.store_id=@Store
   ORDER BY last_name ASC;
END

EXEC spCustomersInStore 2;


ALTER PROCEDURE spBooksFromAuthor
  @Name nvarchar(50),
  @LastName nvarchar(50)
AS 
BEGIN
  SELECT title AS Book FROM dbo.Book 
  INNER JOIN Author ON Author.author_id=Book.author_id 
  WHERE @Name=first_name OR @LastName=last_name
  ORDER BY title ASC;
END

EXEC spBooksFromAuthor 'Aldous', 'Haxley'


ALTER TRIGGER Zabrana
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE, DROP_VIEW
AS
  PRINT 'Brisanje i izmjena tabela nije dozvoljena !'
  ROLLBACK;

DROP VIEW KNJIGE
DROP TRIGGER Zabrana


CREATE TRIGGER trPassword
ON customer
INSTEAD OF INSERT
AS BEGIN
	DECLARE @pass AS nchar(10)
	SELECT @pass = Password FROM inserted
	IF(LEN(@pass)<6 )
		BEGIN
		  RAISERROR('Vaš password ne može imati manje od 6 znakova ! Unesite ponovo :',2,3)
		  RETURN SELECT @pass
		END
	ELSE IF(Len(@pass)>10)
		BEGIN
		  RAISERROR('Vaš password ne može imati više od 6 znakova ! Unesite ponovo :',2,3)
		  RETURN
		END
		BEGIN
			PRINT('Uspješno ste se registrovali !')
		END
END


ALTER TRIGGER tr_IsThereBook
ON Rental
INSTEAD OF INSERT
AS BEGIN
  DECLARE @book AS int
  SELECT @book = book_id FROM Inventory
   IF (@book=@@IDENTITY)
   BEGIN
   PRINT ('Knjiga je dodana u Vašu korpu !')
   END
   ELSE
   BEGIN 
   RAISERROR ('Žao nam je, trenutno nemamo željenu knjigu u svojoj biblioteci.',1,16)
   END
END 


DROP TRIGGER tr_IsThereBook
INSERT INTO Rental VALUES (54,2019-20-09,2,1,null,4)




CREATE TRIGGER tr_NumberOfBooks 
 ON Rental 
 FOR INSERT
AS BEGIN
DECLARE @Book AS int
DECLARE @customer AS int
Select @Book = book_id , @customer=customer_id FROM inserted
     Update customer SET book_issued += 1 where customer.customer_id = @customer	 
END

INSERT INTO Rental VALUES(11, 22-8-2019, 3, 2, 20-09-2019,5);
SELECT * FROM Rental INNER JOIN customer ON Rental.customer_id=customer.customer_id;



CREATE TABLE deleted_payments
(
  payment_id int not null,
  amount decimal(5,2) not null,
  payment_date datetime not null
 )

ALTER TRIGGER tr_InteadOfDelete ON Payment
INSTEAD OF DELETE
AS 
BEGIN 
DECLARE @payment AS int
DECLARE @amount AS decimal
DECLARE @date AS datetime
Select @payment=payment_id, @amount=amount, @date=payment_date FROM deleted
INSERT INTO deleted_payments VALUES( @payment, @amount,@date)
END

DELETE FROM Payment WHERE payment_id=1
SELECT * FROM deleted_payments 

