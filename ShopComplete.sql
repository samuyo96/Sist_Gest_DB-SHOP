--Creación de la base de datos

CREATE DATABASE Shop;

GO

USE Shop;

--Creación de las tablas

CREATE TABLE Clientes (
	Cl_ID INT PRIMARY KEY IDENTITY(1,1),
	Cl_Name NVARCHAR(45)
);

CREATE TABLE Artículos (
	A_ID INT PRIMARY KEY IDENTITY(1,1),
	A_Name NVARCHAR(45),
	A_Descrip NVARCHAR(150),
	A_Stock INT,
	A_Cost DECIMAL(5,2)
);

CREATE TABLE Pedidos(
	P_ID INT PRIMARY KEY IDENTITY(1,1),
	P_Date DATETIME DEFAULT GETDATE()
);

--Creación de la tabla combinada 

CREATE TABLE PedidosArtículos(
	Cl_ID INT FOREIGN KEY REFERENCES Clientes(Cl_ID),
	Ped_ID INT FOREIGN KEY REFERENCES Pedidos(P_ID),
	A_ID INT FOREIGN KEY REFERENCES Artículos(A_ID),
	Quant INT,
	Tot_Cost DECIMAL,
	PRIMARY KEY (Cl_ID, Ped_ID, A_ID)
);

GO

--Creación de Trigger para calcular columna Tot_Cost de PedidosArtículos

CREATE TRIGGER CalculateTot_Cost 
ON PedidosArtículos
AFTER INSERT
AS 
BEGIN
    -- Actualizar Tot_Cost en la tabla PedidosArtículos para las filas insertadas

    UPDATE PedidosArtículos
    SET Tot_Cost = a.A_Cost * i.Quant
    FROM PedidosArtículos pa
    INNER JOIN inserted i 
        ON pa.Ped_ID = i.Ped_ID AND pa.Cl_ID = i.Cl_ID AND pa.A_ID = i.A_ID
    INNER JOIN Artículos a 
        ON i.A_ID = a.A_ID;

    -- Reducir el stock en la tabla Artículos basado en las filas insertadas

    UPDATE Artículos
    SET A_Stock = A_Stock - i.Quant
    FROM Artículos a
    INNER JOIN inserted i ON a.A_ID = i.A_ID
    WHERE a.A_Stock >= i.Quant;

    -- Manejar casos donde el stock es insuficiente

    UPDATE PedidosArtículos
    SET Quant = a.A_Stock,
        Tot_Cost = a.A_Cost * a.A_Stock
    FROM PedidosArtículos pa
    INNER JOIN inserted i 
        ON pa.Ped_ID = i.Ped_ID AND pa.Cl_ID = i.Cl_ID AND pa.A_ID = i.A_ID
    INNER JOIN Artículos a 
        ON i.A_ID = a.A_ID
    WHERE a.A_Stock < i.Quant;

    -- Establecer el stock a 0 en la tabla Artículos si no hay stock suficiente

    UPDATE Artículos
    SET A_Stock = 0
    FROM Artículos a
    INNER JOIN inserted i ON a.A_ID = i.A_ID
    WHERE a.A_Stock < i.Quant;

END;

GO

--Creación de una función para añadir los IDs en las tablas de forma autónoma.

CREATE PROCEDURE InsertIDInTable 
@Cuant INT, @TableName NVARCHAR(MAX)
AS 
BEGIN
	DECLARE @i INT = 0;
	DECLARE @sql NVARCHAR(MAX);

	WHILE @i < @Cuant
	BEGIN 
		SET @sql = 'INSERT INTO' +QUOTENAME(@TableName) + 'DEFAULT VALUES';
		EXEC sp_executesql @sql;
		SET @i = @i + 1;
	END
	PRINT 'Se han insertado ' + CAST(@Cuant AS NVARCHAR) + ' en ' + @TableName;
END;

GO

--Creación de funciones de adición de datos.

CREATE PROCEDURE UpdateRowInArtículos 
	@ID INT,
	@Name NVARCHAR(45),
	@Descr NVARCHAR(150),
	@Stock INT,
	@Cost DECIMAL(5,2)
AS
BEGIN
	UPDATE Artículos
	SET A_Name = @Name,
		A_Descrip = @Descr,
		A_Stock = @Stock,
		A_Cost = @Cost
	WHERE A_ID = @ID;
END;

GO

CREATE PROCEDURE UpdateRowInClientes
	@ID INT,
	@Name NVARCHAR(45)
AS
BEGIN
	UPDATE Clientes 
	SET Cl_Name = @Name
	WHERE Cl_ID = @ID;
END;

GO

--Inserción de datos en las tablas.

USE Shop;

EXEC InsertIDInTable 10, 'Clientes';
EXEC InsertIDInTable 20, 'Artículos';
EXEC InsertIDInTable 5, 'Pedidos';

EXEC UpdateRowInClientes 1, 'Samuel';
EXEC UpdateRowInClientes 2, 'Isabel';
EXEC UpdateRowInClientes 3, 'Ricardo';
EXEC UpdateRowInClientes 4, 'Charo';
EXEC UpdateRowInClientes 5, 'Helena';
EXEC UpdateRowInClientes 6, 'Carmen';
EXEC UpdateRowInClientes 7, 'Miguel';
EXEC UpdateRowInClientes 8, 'Anaïs';
EXEC UpdateRowInClientes 9, 'Toño';
EXEC UpdateRowInClientes 10, 'Jesús';

EXEC UpdateRowInArtículos 1, 'Lápiz', 'Herramienta de escritura', 999, 1.10;
EXEC UpdateRowInArtículos 2, 'Bolígrafo', 'Herramienta de escritura permanente', 999, 1.30;
EXEC UpdateRowInArtículos 3, 'Papel', 'Herramienta de escritura (paquete)', 100, 5.20;
EXEC UpdateRowInArtículos 4, 'Cartulina', 'Herramienta de escritura de color (paquete)', 100, 7.90;
EXEC UpdateRowInArtículos 5, 'Rotulador rojo', 'Herramienta de escritura permanente roja', 500, 1.80;
EXEC UpdateRowInArtículos 6, 'Rotulador azul', 'Herramienta de escritura permanente azul', 470, 1.80;
EXEC UpdateRowInArtículos 7, 'Rotulador verde', 'Herramienta de escritura permanente verde', 530, 1.80;
EXEC UpdateRowInArtículos 8, 'Subrayador amarillo', 'Herramienta de estudio amarilla', 999, 1.50;
EXEC UpdateRowInArtículos 9, 'Subrayador verde', 'Herramienta de escritudio verde', 999, 1.50;
EXEC UpdateRowInArtículos 10, 'Subrayador rosa', 'Herramienta de escritudio rosa', 999, 1.50;
EXEC UpdateRowInArtículos 11, 'Estuche', 'Almacenaje de herramientas de escritura', 50, 12.30;
EXEC UpdateRowInArtículos 12, 'Mochila', 'Almacenaje de libros', 30, 19.99;
EXEC UpdateRowInArtículos 13, 'Compás', 'Herramienta de dibujo', 60, 10.00;
EXEC UpdateRowInArtículos 14, 'Goma', 'Herramienta de borrado de lápices', 999, 0.80;
EXEC UpdateRowInArtículos 15, 'Tipex', 'Herramienta de borrado de útiles permanentes', 700, 2.00;
EXEC UpdateRowInArtículos 16, 'Libro de matemáticas', 'Libro con ejercicios para aprender matemáticas', 100, 20.10;
EXEC UpdateRowInArtículos 17, 'Libro de lengua', 'Libro con ejercicios para aprender lengua', 100, 20.10;
EXEC UpdateRowInArtículos 18, 'Libro de naturales', 'Libro con ejercicios para aprender naturales', 100, 20.10;
EXEC UpdateRowInArtículos 19, 'Libro de inglés', 'Libro con ejercicios para aprender inglés', 100, 20.10;
EXEC UpdateRowInArtículos 20, 'Libro de informática', 'Libro con ejercicios para aprender informática', 100, 20.10;

INSERT INTO PedidosArtículos (Cl_ID, Ped_ID, A_ID, Quant)
VALUES (1, 1, 3, 8),
	   (1, 1, 2, 15),
	   (2, 2, 16, 1),
	   (2, 2, 1, 10),
	   (3, 3, 6, 5)

GO

--Consultas Básicas.

SELECT * FROM Artículos;
SELECT * FROM Clientes;
SELECT * FROM Pedidos;
SELECT * FROM PedidosArtículos;

--Consulta Artículos comprados ordenados por stock ascendiente.

SELECT a.A_Name AS Nombre_Articulo, 
       SUM(pa.Quant) AS Cantidad_Pedida,
       SUM(pa.Tot_Cost) AS Coste_Total,
       a.A_Stock AS Stock
FROM Artículos a
JOIN PedidosArtículos pa ON a.A_ID = pa.A_ID
GROUP BY a.A_Name, a.A_Stock
ORDER BY Stock ASC;

--Consulta pedidos por cliente y gasto medio.

SELECT c.CL_ID AS ID_Cliente,
	   c.Cl_Name AS Nombre,
       COUNT(pa.Ped_ID) AS Número_Pedidos,
       SUM(pa.Tot_Cost) AS Coste_Total,
       FORMAT(ROUND(AVG(pa.Tot_Cost),2), 'N2') AS Coste_Medio
FROM clientes c
JOIN PedidosArtículos pa ON c.CL_ID = pa.Cl_ID
GROUP BY c.Cl_ID, c.Cl_Name;
 
 --Consulta artículos más vendidos y su coste ordenado descendiente.

SELECT a.A_ID AS ID_Artículo,
	   a.A_Name AS Nombre,
       COUNT(pa.A_ID) AS Número_Pedidos,
       SUM(pa.Quant) AS Unidades,
       SUM(pa.Tot_Cost) AS Coste
FROM artículos a
JOIN PedidosArtículos pa ON a.A_ID = pa.A_ID
GROUP BY a.A_ID, a.A_Name
ORDER BY Coste DESC; 

 --Consulta clientes que nunca han realizado pedidos.

SELECT c.Cl_ID AS ID_Cliente,
	   c.Cl_Name AS Nombre
FROM clientes c
LEFT JOIN PedidosArtículos pa ON c.Cl_ID = pa.Cl_ID
WHERE pa.Cl_ID IS NULL;
