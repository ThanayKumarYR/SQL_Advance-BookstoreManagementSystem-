create database BookstoreManagementSystem;

use BookstoreManagementSystem;

CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(100),
    Author NVARCHAR(100),
    Price DECIMAL(10, 2),
    Quantity INT,
    SalesCount INT DEFAULT 0
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100),
    Email NVARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    CustomerID INT,
    OrderDate DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    BookID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Inventory (
    BookID INT PRIMARY KEY,
    StockLevel INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
GO


CREATE PROCEDURE GetAllBooks
AS
BEGIN
    SELECT * FROM Books;
END;

GO
CREATE PROCEDURE GetDatabase
AS
BEGIN
    SELECT * FROM Books;
	SELECT * FROM Customers;
	SELECT * FROM Orders;
	SELECT * FROM OrderDetails;
	SELECT * FROM Inventory;
END;

GO
CREATE TRIGGER UpdateInventoryOnOrder
ON OrderDetails
AFTER INSERT
AS
BEGIN
    DECLARE @BookID INT, @Quantity INT;

    SELECT @BookID = BookID, @Quantity = Quantity FROM inserted;

    UPDATE Inventory
    SET StockLevel = StockLevel - @Quantity
    WHERE BookID = @BookID;
END;

GO
CREATE TRIGGER UpdateInventoryOnOrder
ON OrderDetails
AFTER INSERT
AS
BEGIN
    DECLARE @BookID INT, @Quantity INT;

    -- Declare a cursor to iterate over the inserted rows
    DECLARE cursor_order CURSOR FOR
    SELECT BookID, Quantity FROM inserted;

    -- Open the cursor
    OPEN cursor_order;

    -- Fetch the first row from the cursor
    FETCH NEXT FROM cursor_order INTO @BookID, @Quantity;

    -- Iterate over each inserted row and update the Inventory table
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Inventory
        SET StockLevel = StockLevel - @Quantity
        WHERE BookID = @BookID;

        -- Fetch the next row from the cursor
        FETCH NEXT FROM cursor_order INTO @BookID, @Quantity;
    END

    -- Close and deallocate the cursor
    CLOSE cursor_order;
    DEALLOCATE cursor_order;
END; 
GO

CREATE VIEW CustomerOrders AS
SELECT Orders.OrderID, CONVERT(date, Orders.OrderDate) AS OrderDate, Books.Title, OrderDetails.Quantity
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Books ON Books.BookID = OrderDetails.BookID;
GO

CREATE INDEX IX_Title ON Books (Title);

-- Insert sample data into Books table
INSERT INTO Books (Title, Author, Price, Quantity, SalesCount) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 20.00, 50, 10),
('To Kill a Mockingbird', 'Harper Lee', 25.00, 30, 15),
('1984', 'George Orwell', 15.00, 60, 20),
('Pride and Prejudice', 'Jane Austen', 22.00, 40, 25),
('The Catcher in the Rye', 'J.D. Salinger', 18.00, 55, 30),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 27.00, 25, 35),
('The Lord of the Rings', 'J.R.R. Tolkien', 30.00, 45, 40),
('The Da Vinci Code', 'Dan Brown', 17.00, 35, 45),
('The Hunger Games', 'Suzanne Collins', 19.00, 50, 50),
('The Girl with the Dragon Tattoo', 'Stieg Larsson', 23.00, 20, 55);

-- Insert sample data into Customers table
INSERT INTO Customers (Name, Email) VALUES
('John Johnson', 'john@example.com'),
('Mary Williams', 'mary@example.com'),
('James Brown', 'james@example.com'),
('Patricia Jones', 'patricia@example.com'),
('Robert Garcia', 'robert@example.com'),
('Linda Martinez', 'linda@example.com'),
('William Jackson', 'william@example.com'),
('Elizabeth Taylor', 'elizabeth@example.com'),
('Michael Harris', 'michael@example.com'),
('Jennifer Moore', 'jennifer@example.com');

-- Insert sample data into Orders table
INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-04-01'),
(2, '2024-04-02'),
(3, '2024-04-03'),
(4, '2024-04-04'),
(5, '2024-04-05'),
(6, '2024-04-06'),
(7, '2024-04-07'),
(8, '2024-04-08'),
(9, '2024-04-09'),
(10, '2024-04-10');

-- Insert sample data into Inventory table
INSERT INTO Inventory (BookID, StockLevel) VALUES
(1, 48),
(2, 29),
(3, 57),
(4, 38),
(5, 54),
(6, 23),
(7, 42),
(8, 34),
(9, 48),
(10, 19);

-- Insert sample data into OrderDetails table
INSERT INTO OrderDetails (OrderID, BookID, Quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3),
(4, 4, 2),
(5, 5, 1),
(6, 6, 2),
(7, 7, 3),
(8, 8, 1),
(9, 9, 2),
(10, 10, 1);

drop view CustomerOrders;

drop trigger UpdateInventoryOnOrder;

delete OrderDetails;

exec GetDatabase;

exec GetAllBooks;

select * from CustomerOrders;







