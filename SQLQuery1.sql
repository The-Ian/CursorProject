Create Proc TerritoryCursorProc As
DECLARE @territory_id int, @territory_name nvarchar(50),  
    @message varchar(80), @product nvarchar(50), @year nvarchar(20);  

PRINT '-------- Yearly Orders Report --------';  

DECLARE territory_cursor CURSOR FOR   
SELECT Distinct SP.TerritoryID , [Name]  
FROM Sales.SalesPerson SP 
Inner join Sales.SalesTerritory S
on SP.TerritoryID = S.TerritoryID

OPEN territory_cursor  

FETCH NEXT FROM territory_cursor   
INTO @territory_id, @territory_name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT @message = 'Orders For | ' +   
        @territory_name  

    PRINT @message  

    -- Declare an inner cursor based     
    -- on vendor_id from the outer cursor.  

    DECLARE product_cursor CURSOR FOR   
    SELECT Distinct SalesOrderNumber, year(OrderDate)
    FROM Sales.SalesPerson pv 
	Inner Join Sales.SalesOrderHeader v
	on pv.BusinessEntityID = v.SalesPersonID 
    WHERE Year(OrderDate) = @year  -- Variable value from the outer cursor 
	


    OPEN product_cursor  
    FETCH NEXT FROM product_cursor INTO @product ,@year

    IF @@FETCH_STATUS <> 0   
        PRINT '         <<None>>'       

    WHILE @@FETCH_STATUS = 0  
    BEGIN  

        SELECT @message = '         ' + @product + '  |  ' + @year;
        PRINT @message  
        FETCH NEXT FROM product_cursor INTO @product, @year
        END  

    CLOSE product_cursor  
    DEALLOCATE product_cursor  
        -- Get the next vendor.  
    FETCH NEXT FROM territory_cursor   
    INTO @territory_id, @territory_name  
END   
CLOSE territory_cursor;  
DEALLOCATE territory_cursor;

Go
Create Proc SalesProc As

Declare @Year Int

Select [Name], SalesOrderNumber, Year(OrderDate) [Year]
From Sales.SalesOrderHeader SOH
Inner join Sales.SalesPerson SP
On  SOH.SalesPersonID = SP.BusinessEntityID
Inner Join Sales.SalesTerritory ST
On St.TerritoryID = SP.TerritoryID
Where Year(OrderDate) = @Year
Order by [Name], [Year];

