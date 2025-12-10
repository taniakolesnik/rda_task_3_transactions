-- Use our database
USE ShopDB; 

-- Some data should be created outside the transaction (here)

SET @product_id = (
  SELECT ID
  FROM Products
  WHERE Name="AwersomeProduct"
);

SET @customer_id = 1;
SET @count = 1;

-- Start the transaction 
START TRANSACTION; 

INSERT INTO Orders (`CustomerID`, `Date`)
VALUES ( @customer_id, '2023-01-01');

SET @order_id = LAST_INSERT_ID();

SET @current_count = (
  SELECT WarehouseAmount
  FROM Products
  WHERE ID = @product_id
);

INSERT INTO OrderItems (OrderID, ProductID, Count) 
	SELECT @order_id, @product_id, @count 
	WHERE @current_count > @count;

SELECT @current_count, @count, @current_count > @count;

UPDATE Products 
	SET WarehouseAmount = WarehouseAmount - @count
	WHERE ID = @product_id AND WarehouseAmount > @count;

-- And some data should be created inside the transaction 

COMMIT; 