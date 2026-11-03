CREATE DATABASE ECommerceDB;
GO

USE ECommerceDB;
GO

CREATE TABLE CATEGORIAS (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    Activa BIT DEFAULT 1
);
GO

-- Datos de prueba 

INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Electrónica', 'Dispositivos y accesorios tecnológicos', 1);
INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Ropa y Calzado', 'Indumentaria para todas las estaciones', 1);
INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Hogar y Muebles', 'Artículos para el confort del hogar', 1);
INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Deportes', 'Equipamiento y ropa deportiva', 1);
GO

-- Martin -> 31/10/26 1530
CREATE PROCEDURE spAltaCategoria
	@Nombre VARCHAR(100),
	@Descripcion VARCHAR(255)
AS BEGIN 
	INSERT INTO CATEGORIAS (Nombre,Descripcion,Activa)
	VALUES (@Nombre,@Descripcion,1)
END
GO

EXEC spAltaCategoria "Tincho","Prueba tincho"
GO

Select * from CATEGORIAS
GO
-- Martin -> 31/10/26 1700
CREATE PROCEDURE spBuscarCategoriaPorId
    @id INT
AS BEGIN
    SELECT Id, Nombre, Descripcion, Activa
    FROM CATEGORIAS
    WHERE Id = @id
END
GO

EXEC spBuscarCategoriaPorId 1002
GO

-- Martin -> 31/10/26 1755
CREATE PROCEDURE spModificarCategoria
    @Id INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255)
AS BEGIN
    UPDATE CATEGORIAS
    SET Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE Id = @Id
END
GO

-- Martin --> 1/11/26 2200
CREATE PROCEDURE spCambiarEstadoCategoria
    @Id INT,
    @Activa BIT
AS
BEGIN
    UPDATE CATEGORIAS SET Activa = @Activa WHERE Id = @Id
END
GO



-- Tabla Productos --

CREATE TABLE PRODUCTOS (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    PrecioVenta MONEY NOT NULL CHECK (PrecioVenta > 0),
    Stock INT NOT NULL CHECK (Stock >= 0),
    IdCategoria INT NOT NULL FOREIGN KEY REFERENCES CATEGORIAS(Id),
    ImagenUrl VARCHAR(500) NULL,
    Activo BIT DEFAULT 1
);

GO

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS - PRODUCTOS
-- =============================================

-- 1. Listar todos los productos con su categoría (sin filtrar por activo para que funcione el panel de administración)
CREATE PROCEDURE spListarProductos 
AS 
BEGIN 
    SELECT P.Id, P.Nombre, P.Descripcion, P.PrecioVenta, P.Stock, P.IdCategoria, C.Nombre AS CategoriaNombre, P.ImagenUrl, P.Activo 
    FROM PRODUCTOS P 
    INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id; 
END;
GO

-- 2. Alta de un nuevo producto
CREATE PROCEDURE spAltaProducto 
    @Nombre VARCHAR(100), 
    @Descripcion VARCHAR(255), 
    @PrecioVenta MONEY, 
    @Stock INT, 
    @IdCategoria INT, 
    @ImagenUrl VARCHAR(500), 
    @Activo BIT 
AS 
BEGIN 
    INSERT INTO PRODUCTOS (Nombre, Descripcion, PrecioVenta, Stock, IdCategoria, ImagenUrl, Activo) 
    VALUES (@Nombre, @Descripcion, @PrecioVenta, @Stock, @IdCategoria, @ImagenUrl, @Activo); 
END;
GO

-- 3. Modificar un producto existente
CREATE PROCEDURE spModificarProducto 
    @Id INT, 
    @Nombre VARCHAR(100), 
    @Descripcion VARCHAR(255), 
    @PrecioVenta MONEY, 
    @Stock INT, 
    @IdCategoria INT, 
    @ImagenUrl VARCHAR(500), 
    @Activo BIT 
AS 
BEGIN 
    UPDATE PRODUCTOS 
    SET Nombre = @Nombre, 
        Descripcion = @Descripcion, 
        PrecioVenta = @PrecioVenta, 
        Stock = @Stock, 
        IdCategoria = @IdCategoria, 
        ImagenUrl = @ImagenUrl, 
        Activo = @Activo 
    WHERE Id = @Id; 
END;
GO

-- 4. Baja lógica (cambiar estado activo/inactivo)
CREATE PROCEDURE spBajaLogicaProducto 
    @Id INT 
AS 
BEGIN 
    UPDATE PRODUCTOS 
    SET Activo = CASE WHEN Activo = 1 THEN 0 ELSE 1 END 
    WHERE Id = @Id; 
END;
GO