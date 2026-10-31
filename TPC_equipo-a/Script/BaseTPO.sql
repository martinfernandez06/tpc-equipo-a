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

