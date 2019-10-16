GO 
CREATE NONCLUSTERED INDEX IX_Book_rentalDuration
ON dbo.Book (book_id, rental_duration)
INCLUDE (title)
GO

SELECT rental_duration, Title, book_id FROM dbo.Book 
WHERE rental_duration > 31
ORDER BY title ASC
GO


CREATE NONCLUSTERED INDEX IX_Author_Country
ON dbo.Author (author_id, country_id)
INCLUDE (first_name, last_name)
GO

SELECT author_id, first_name, last_name FROM dbo.Author
Where country_id = 1
GO


CREATE NONCLUSTERED INDEX IX_Customer_Store ON dbo.Customer(customer_id, store_id)
INCLUDE (first_name, last_name, book_issued)
GO

SELECT customer_id, first_name, last_name FROM dbo.Customer
WHERE store_id = 2
GO

SELECT COUNT(customer_id) AS Number_of_customers FROM dbo.customer 
where store_id=2


CREATE NONCLUSTERED INDEX IX_Book_Genre ON dbo.Book(book_id,genre)
INCLUDE (title)
GO

SELECT book_id, title, genre FROM dbo.Book
where genre LIKE '%History' OR genre LIKE 'Philosophy%'

CREATE NONCLUSTERED INDEX IX_Payment_Amount ON dbo.Payment(payment_id, amount)
INCLUDE (rental_id)

SELECT customer_id,amount,payment_date FROM dbo.Payment
