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
    @ImagenUrl VARCHAR(500)
AS 
BEGIN 
    UPDATE PRODUCTOS 
    SET Nombre = @Nombre, 
        Descripcion = @Descripcion, 
        PrecioVenta = @PrecioVenta, 
        Stock = @Stock, 
        IdCategoria = @IdCategoria, 
        ImagenUrl = @ImagenUrl
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

-- =======================================================
-- TABLAS DE FORMAS DE PAGO Y ENTREGA (Pablo 06/11/2026)
-- =======================================================

-- Tabla FORMAS_PAGO
CREATE TABLE FORMAS_PAGO (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) UNIQUE NOT NULL,
    Activa BIT DEFAULT 1 NOT NULL
);
GO

-- Tabla FORMAS_ENTREGA
CREATE TABLE FORMAS_ENTREGA (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) UNIQUE NOT NULL,
    RequiereDireccion BIT NOT NULL,
    Activa BIT DEFAULT 1 NOT NULL
);
GO

-- DATOS DE PRUEBA
INSERT INTO FORMAS_PAGO (Descripcion) VALUES ('Efectivo');
INSERT INTO FORMAS_PAGO (Descripcion) VALUES ('Transferencia');
INSERT INTO FORMAS_PAGO (Descripcion) VALUES ('Mercado Pago');
GO

INSERT INTO FORMAS_ENTREGA (Descripcion, RequiereDireccion) VALUES ('Retiro en el local', 0);
INSERT INTO FORMAS_ENTREGA (Descripcion, RequiereDireccion) VALUES ('Envío a domicilio', 1);
GO

-- ETAPA 3 -- MARTIN - 12/11/26
-- TABLA ESTADO_PEDIDOS

CREATE TABLE ESTADOS_PEDIDO(
  Id INT IDENTITY(1,1),
  Descripcion VARCHAR(50) NOT NULL,

  CONSTRAINT PK_ESTADOS_PEDIDO_ID PRIMARY KEY(Id),
  CONSTRAINT UQ_ESTADOS_PEDIDO_DESCRIPCION UNIQUE(Descripcion)
);
GO
-- INSERTARE DATOS DE PRUEBA 
INSERT INTO ESTADOS_PEDIDO(Descripcion) 
VALUES 
('Pendiente de pago'),
('Pagado'),
('En preparación'),
('Enviado'),
('Entregado'),
('Cancelado');
GO

SELECT * FROM ESTADOS_PEDIDO;
GO

-- TABLA PEDIDOS

CREATE TABLE PEDIDOS(
    Id INT IDENTITY(1,1),
    IdUsuario INT NOT NULL,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_PEDIDOS_FECHACREACION DEFAULT GETDATE(),
    IdFormaEntrega INT NOT NULL,
    IdDireccion INT NULL,
    IdFormaPago INT NOT NULL,
    IdEstado INT NOT NULL CONSTRAINT DF_PEDIDOS_IDESTADO DEFAULT 1,
    Total MONEY NOT NULL,
    CodigoSeguimiento VARCHAR(50) NULL,
    ComprobanteUrl VARCHAR(500) NULL,
    EstadoComprobante VARCHAR(20) NULL,

    CONSTRAINT PK_PEDIDOS_ID PRIMARY KEY(Id),
    CONSTRAINT FK_PEDIDOS_IDFORMAENTREGA FOREIGN KEY(IdFormaEntrega) REFERENCES FORMAS_ENTREGA(Id),
    CONSTRAINT FK_PEDIDOS_IDFORMAPAGO FOREIGN KEY(IdFormaPago) REFERENCES FORMAS_PAGO(Id),
    CONSTRAINT FK_PEDIDOS_IDESTADO FOREIGN KEY(IdEstado) REFERENCES ESTADOS_PEDIDO(Id),
    CONSTRAINT CHK_PEDIDOS_ESTADOCOMPROBANTE CHECK(EstadoComprobante IN('Pendiente','Aceptado','Rechazado')),
    CONSTRAINT CHK_PEDIDOS_TOTAL CHECK(TOTAL > 0)
);
GO
-- TABLA ITEMS_PEDIDO
CREATE TABLE ITEMS_PEDIDO(
    IdPedido INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario MONEY NOT NULL,
    -- pk compuesta, un producto aparece una sola vez por pedido, si compra mas se suma en cantidad
    CONSTRAINT PK_ITEMS_PEDIDO PRIMARY KEY(IdPedido, IdProducto),
    CONSTRAINT FK_ITEMS_PEDIDO_IDPEDIDO FOREIGN KEY(IdPedido) REFERENCES PEDIDOS(Id),
    CONSTRAINT FK_ITEMS_PEDIDO_IDPRODUCTO FOREIGN KEY(IdProducto) REFERENCES PRODUCTOS(Id),
    CONSTRAINT CHK_ITEMS_PEDIDO_CANTIDAD CHECK(Cantidad > 0),
    CONSTRAINT CHK_ITEMS_PEDIDO_PRECIOUNITARIO CHECK(PrecioUnitario > 0)
);
GO
-- TABLA HISTORIAL_ESTADOS
CREATE TABLE HISTORIAL_ESTADOS(
    Id INT IDENTITY(1,1),
    IdPedido INT NOT NULL,
    IdEstado INT NOT NULL,
    IdUsuario INT NOT NULL,
    Fecha DATETIME NOT NULL CONSTRAINT DF_HISTORIAL_ESTADOS_FECHA DEFAULT GETDATE(),

    CONSTRAINT PK_HISTORIAL_ESTADOS_ID PRIMARY KEY(Id),
    CONSTRAINT FK_HISTORIAL_ESTADOS_IDPEDIDO FOREIGN KEY(IdPedido) REFERENCES PEDIDOS(Id),
    CONSTRAINT FK_HISTORIAL_ESTADOS_IDESTADO FOREIGN KEY(IdEstado) REFERENCES ESTADOS_PEDIDO(Id)
);
GO

-- OBSERVACIONES_PEDIDO
CREATE TABLE OBSERVACIONES_PEDIDO(
    Id INT IDENTITY(1,1),
    IdPedido INT NOT NULL,
    IdUsuario INT NOT NULL,
    Fecha DATETIME NOT NULL CONSTRAINT DF_OBSERVACIONES_PEDIDO_FECHA DEFAULT GETDATE(),
    Observacion VARCHAR(500) NOT NULL,

    CONSTRAINT PK_OBSERVACIONES_PEDIDO_ID PRIMARY KEY(Id),
    CONSTRAINT FK_OBSERVACIONES_PEDIDO_IDPEDIDO FOREIGN KEY(IdPedido) REFERENCES PEDIDOS(Id)
);
GO

-- Martin - 12/11/26
-- guarda el pedido anota el primer estado en el historial y devuelve el id nuevo
CREATE PROCEDURE spAltaPedido
    @IdUsuario INT,
    @IdFormaEntrega INT,
    @IdDireccion INT,
    @IdFormaPago INT,
    @Total MONEY
AS BEGIN
    INSERT INTO PEDIDOS (IdUsuario, IdFormaEntrega, IdDireccion, IdFormaPago, Total)
    VALUES (@IdUsuario, @IdFormaEntrega, @IdDireccion, @IdFormaPago, @Total)

    -- agarro el id que la BD le acaba de dar al pedido
    DECLARE @IdPedido INT = SCOPE_IDENTITY()

    -- todo pedido nace en el estado 1, pendiente de pago
    INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario)
    VALUES (@IdPedido, 1, @IdUsuario)

    SELECT @IdPedido
END
GO

-- guarda un producto del pedido y le descuenta el stock
CREATE PROCEDURE spAltaItemPedido
    @IdPedido INT,
    @IdProducto INT,
    @Cantidad INT,
    @PrecioUnitario MONEY
AS BEGIN
    -- descuento el stock solo si alcanza
    UPDATE PRODUCTOS SET Stock = Stock - @Cantidad
    WHERE Id = @IdProducto AND Stock >= @Cantidad;

    -- si no se actualizo ninguna fila es porque no habia stock suficiente
    IF @@ROWCOUNT = 0
        THROW 50001, 'No hay stock suficiente para este producto', 1;

    INSERT INTO ITEMS_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario)
    VALUES (@IdPedido, @IdProducto, @Cantidad, @PrecioUnitario);
END
GO

-- Martin - 13/11/26
-- lista todos los pedidos para el panel admin, los mas nuevos primero
CREATE PROCEDURE spListarPedidos
AS BEGIN
    SELECT
        P.Id,
        P.FechaCreacion,
        P.IdUsuario,
        FE.Descripcion AS FormaEntrega,
        FP.Descripcion AS FormaPago,
        E.Descripcion AS Estado,
        P.Total,
        P.CodigoSeguimiento,
        P.EstadoComprobante
    FROM PEDIDOS P
    INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id
    INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id
    INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    ORDER BY P.FechaCreacion DESC
END
GO

-- trae un pedido por su id, para ver el detalle
CREATE PROCEDURE spBuscarPedidoPorId
@Id INT
AS BEGIN
    SELECT
        P.Id,
        P.FechaCreacion,
        P.IdUsuario,
        P.IdFormaEntrega,
        FE.Descripcion AS FormaEntrega,
        P.IdDireccion,
        P.IdFormaPago,
        FP.Descripcion AS FormaPago,
        P.IdEstado,
        E.Descripcion AS Estado,
        P.Total,
        P.CodigoSeguimiento,
        P.ComprobanteUrl,
        P.EstadoComprobante
    FROM PEDIDOS P
    INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id
    INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id
    INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    WHERE P.Id = @Id
END
GO

-- lista los pedidos de un cliente para la pantalla mis compras, los mas nuevos primero
CREATE PROCEDURE spListarPedidosPorCliente
@IdUsuario INT
AS BEGIN
    SELECT
        P.Id,
        P.FechaCreacion,
        FE.Descripcion AS FormaEntrega,
        FP.Descripcion AS FormaPago,
        E.Descripcion AS Estado,
        P.Total,
        P.CodigoSeguimiento,
        P.EstadoComprobante
    FROM PEDIDOS P
    INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id
    INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id
    INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    WHERE P.IdUsuario = @IdUsuario
    ORDER BY P.FechaCreacion DESC
END
GO

-- trae los productos de un pedido para el detalle
CREATE PROCEDURE spListarItemsPorPedido
@IdPedido INT
AS BEGIN
    SELECT
        I.IdProducto,
        PR.Nombre,
        I.Cantidad,
        I.PrecioUnitario,
        I.Cantidad * I.PrecioUnitario AS Subtotal
    FROM ITEMS_PEDIDO I
    INNER JOIN PRODUCTOS PR ON I.IdProducto = PR.Id
    WHERE I.IdPedido = @IdPedido
END
GO

-- cambia el estado de un pedido y lo anota en el historial con quien lo cambio
-- el UPDATE cambia el estado actual del pedido y el INSERT deja registrado el cambio en el historial. 
-- La fecha se carga sola por el DEFAULT. Así PEDIDOS siempre tiene el estado de ahora
-- y HISTORIAL_ESTADOS tiene todos los estados por los que pasó.
CREATE PROCEDURE spCambiarEstadoPedido
@IdPedido INT,
@IdEstado INT,
@IdUsuario INT
AS BEGIN
    UPDATE PEDIDOS SET IdEstado = @IdEstado
    WHERE Id = @IdPedido

    INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario)
    VALUES (@IdPedido, @IdEstado, @IdUsuario)
END
GO

-- cancela un pedido si todavia no salio y devuelve las unidades al stock
CREATE PROCEDURE spCancelarPedido
@IdPedido INT,
@IdUsuario INT
AS BEGIN
    -- si ya esta enviado, entregado o cancelado no se puede cancelar
    IF EXISTS (SELECT 1 FROM PEDIDOS WHERE Id = @IdPedido AND IdEstado IN (4, 5, 6))
        THROW 50002, 'El pedido no se puede cancelar en el estado que esta', 1;

    BEGIN TRY
        BEGIN TRANSACTION

        -- devuelvo al stock lo que compro de cada producto
        UPDATE PR SET PR.Stock = PR.Stock + I.Cantidad
        FROM PRODUCTOS PR
        INNER JOIN ITEMS_PEDIDO I ON PR.Id = I.IdProducto
        WHERE I.IdPedido = @IdPedido

        UPDATE PEDIDOS SET IdEstado = 6
        WHERE Id = @IdPedido

        INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario)
        VALUES (@IdPedido, 6, @IdUsuario)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- guarda una observacion de un pedido
CREATE PROCEDURE spAgregarObservacionPedido
@IdPedido INT,
@IdUsuario INT,
@Observacion VARCHAR(500)
AS BEGIN
    INSERT INTO OBSERVACIONES_PEDIDO (IdPedido, IdUsuario, Observacion)
    VALUES (@IdPedido, @IdUsuario, @Observacion)
END
GO

-- lista las observaciones de un pedido, las mas viejas primero
CREATE PROCEDURE spListarObservacionesPorPedido
@IdPedido INT
AS BEGIN
    SELECT Id, IdUsuario, Fecha, Observacion
    FROM OBSERVACIONES_PEDIDO
    WHERE IdPedido = @IdPedido
    ORDER BY Fecha ASC
END
GO

-- lista los estados por los que paso un pedido para el seguimiento, los mas viejos primero
CREATE PROCEDURE spListarHistorialPorPedido
@IdPedido INT
AS BEGIN
    SELECT
        H.Id,
        H.IdEstado,
        E.Descripcion AS Estado,
        H.IdUsuario,
        H.Fecha
    FROM HISTORIAL_ESTADOS H
    INNER JOIN ESTADOS_PEDIDO E ON H.IdEstado = E.Id
    WHERE H.IdPedido = @IdPedido
    ORDER BY H.Fecha ASC
END
GO
