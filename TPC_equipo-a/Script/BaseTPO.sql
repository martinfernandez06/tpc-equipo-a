USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ECommerceDB')
BEGIN
    ALTER DATABASE ECommerceDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ECommerceDB;
END
GO

CREATE DATABASE ECommerceDB;
GO

USE ECommerceDB;
GO


-- =========================================
-- 2. ESTRUCTURA DE TABLAS (DDL)
-- =========================================

CREATE TABLE CATEGORIAS (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE NOT NULL,
    Descripcion VARCHAR(255) NULL,
    Activa BIT DEFAULT 1
);
GO

-- Tabla Productos --
CREATE TABLE PRODUCTOS (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50) NULL UNIQUE, -- Código autogenerado o manual (Etapa 3)
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    PrecioVenta MONEY NOT NULL CHECK (PrecioVenta > 0),
    Stock INT NOT NULL CHECK (Stock >= 0),
    IdCategoria INT NOT NULL FOREIGN KEY REFERENCES CATEGORIAS(Id),
    ImagenUrl VARCHAR(500) NULL,
    Activo BIT DEFAULT 1
);
GO

-- TABLAS DE FORMAS DE PAGO Y ENTREGA (Pablo 06/11/2026)
CREATE TABLE FORMAS_PAGO (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) UNIQUE NOT NULL,
    Activa BIT DEFAULT 1 NOT NULL
);
GO

CREATE TABLE FORMAS_ENTREGA (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) UNIQUE NOT NULL,
    RequiereDireccion BIT NOT NULL,
    Activa BIT DEFAULT 1 NOT NULL
);
GO

-- Guillermo
-- tablas y sp de usuarios, perfiles y direcciones
CREATE TABLE PERFILES (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE USUARIOS (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Clave VARCHAR(50) NOT NULL,
    Telefono VARCHAR(30) NULL,
    IdPerfil INT NOT NULL FOREIGN KEY REFERENCES PERFILES(Id),
    Activo BIT DEFAULT 1 NOT NULL,
    FechaAlta DATETIME DEFAULT GETDATE() NOT NULL,
    UltimoAcceso DATETIME NULL
);
GO

CREATE TABLE DIRECCIONES (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL FOREIGN KEY REFERENCES USUARIOS(Id) ON DELETE CASCADE,
    Calle VARCHAR(100) NOT NULL,
    Numero VARCHAR(20) NOT NULL,
    Provincia VARCHAR(100) NOT NULL,
    Localidad VARCHAR(100) NOT NULL,
    CodigoPostal VARCHAR(20) NOT NULL,
    Observaciones VARCHAR(255) NULL,
    Activa BIT DEFAULT 1 NOT NULL,
    Principal BIT DEFAULT 0 NOT NULL
);
GO

-- ETAPA 3 -- MARTIN - 12/11/26
-- tabla ESTADOS_PEDIDO
CREATE TABLE ESTADOS_PEDIDO(
    Id INT IDENTITY(1,1),
    Descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ESTADOS_PEDIDO_ID PRIMARY KEY(Id),
    CONSTRAINT UQ_ESTADOS_PEDIDO_DESCRIPCION UNIQUE(Descripcion)
);
GO

-- tabla PEDIDOS
CREATE TABLE PEDIDOS(
    Id INT IDENTITY(1,1),
    IdUsuario INT NOT NULL,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_PEDIDOS_FECHACREACION DEFAULT GETDATE(),
    IdFormaEntrega INT NOT NULL,
    IdDireccion INT NULL,
    IdFormaPago INT NOT NULL,
    IdEstado INT NOT NULL CONSTRAINT DF_PEDIDOS_IDESTADO DEFAULT 1,
    Total MONEY NOT NULL,
    CodigoSeguimiento VARCHAR(255) NULL,
    EmpresaEnvio VARCHAR(50) NULL,
    ComprobanteUrl VARCHAR(500) NULL,
    EstadoComprobante VARCHAR(20) NULL,

    CONSTRAINT PK_PEDIDOS_ID PRIMARY KEY(Id),
    CONSTRAINT FK_PEDIDOS_IDUSUARIO FOREIGN KEY(IdUsuario) REFERENCES USUARIOS(Id),
    CONSTRAINT FK_PEDIDOS_IDDIRECCION FOREIGN KEY(IdDireccion) REFERENCES DIRECCIONES(Id),
    CONSTRAINT FK_PEDIDOS_IDFORMAENTREGA FOREIGN KEY(IdFormaEntrega) REFERENCES FORMAS_ENTREGA(Id),
    CONSTRAINT FK_PEDIDOS_IDFORMAPAGO FOREIGN KEY(IdFormaPago) REFERENCES FORMAS_PAGO(Id),
    CONSTRAINT FK_PEDIDOS_IDESTADO FOREIGN KEY(IdEstado) REFERENCES ESTADOS_PEDIDO(Id),
    CONSTRAINT CHK_PEDIDOS_ESTADOCOMPROBANTE CHECK(EstadoComprobante IN('Pendiente','Aceptado','Rechazado')),
    CONSTRAINT CHK_PEDIDOS_TOTAL CHECK(Total > 0)
);
GO

-- tabla ITEMS_PEDIDO
CREATE TABLE ITEMS_PEDIDO(
    IdPedido INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario MONEY NOT NULL,
    CONSTRAINT PK_ITEMS_PEDIDO PRIMARY KEY(IdPedido, IdProducto),
    CONSTRAINT FK_ITEMS_PEDIDO_IDPEDIDO FOREIGN KEY(IdPedido) REFERENCES PEDIDOS(Id),
    CONSTRAINT FK_ITEMS_PEDIDO_IDPRODUCTO FOREIGN KEY(IdProducto) REFERENCES PRODUCTOS(Id),
    CONSTRAINT CHK_ITEMS_PEDIDO_CANTIDAD CHECK(Cantidad > 0),
    CONSTRAINT CHK_ITEMS_PEDIDO_PRECIOUNITARIO CHECK(PrecioUnitario > 0)
);
GO

-- tabla HISTORIAL_ESTADOS
CREATE TABLE HISTORIAL_ESTADOS(
    Id INT IDENTITY(1,1),
    IdPedido INT NOT NULL,
    IdEstado INT NOT NULL,
    IdUsuario INT NOT NULL,
    Fecha DATETIME NOT NULL CONSTRAINT DF_HISTORIAL_ESTADOS_FECHA DEFAULT GETDATE(),
    CONSTRAINT PK_HISTORIAL_ESTADOS_ID PRIMARY KEY(Id),
    CONSTRAINT FK_HISTORIAL_ESTADOS_IDPEDIDO FOREIGN KEY(IdPedido) REFERENCES PEDIDOS(Id),
    CONSTRAINT FK_HISTORIAL_ESTADOS_IDUSUARIO FOREIGN KEY(IdUsuario) REFERENCES USUARIOS(Id),
    CONSTRAINT FK_HISTORIAL_ESTADOS_IDESTADO FOREIGN KEY(IdEstado) REFERENCES ESTADOS_PEDIDO(Id)
);
GO

-- tabla OBSERVACIONES_PEDIDO
CREATE TABLE OBSERVACIONES_PEDIDO(
    Id INT IDENTITY(1,1),
    IdPedido INT NOT NULL,
    IdUsuario INT NOT NULL,
    Fecha DATETIME NOT NULL CONSTRAINT DF_OBSERVACIONES_PEDIDO_FECHA DEFAULT GETDATE(),
    Observacion VARCHAR(500) NOT NULL,
    CONSTRAINT PK_OBSERVACIONES_PEDIDO_ID PRIMARY KEY(Id),
    CONSTRAINT FK_OBSERVACIONES_PEDIDO_IDPEDIDO FOREIGN KEY(IdPedido) REFERENCES PEDIDOS(Id),
    CONSTRAINT FK_OBSERVACIONES_PEDIDO_IDUSUARIO FOREIGN KEY(IdUsuario) REFERENCES USUARIOS(Id)
);
GO


-- =========================================
-- 3. DATOS PARAMÉTRICOS (CONFIGURACIÓN)
-- =========================================

INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Electrónica', 'Dispositivos y accesorios tecnológicos', 1);
INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Ropa y Calzado', 'Indumentaria para todas las estaciones', 1);
INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Hogar y Muebles', 'Artículos para el confort del hogar', 1);
INSERT INTO CATEGORIAS (Nombre, Descripcion, Activa) VALUES ('Deportes', 'Equipamiento y ropa deportiva', 1);
GO

INSERT INTO FORMAS_PAGO (Descripcion) VALUES ('Efectivo');
INSERT INTO FORMAS_PAGO (Descripcion) VALUES ('Transferencia');
INSERT INTO FORMAS_PAGO (Descripcion) VALUES ('Mercado Pago');
GO

INSERT INTO FORMAS_ENTREGA (Descripcion, RequiereDireccion) VALUES ('Retiro en el local', 0);
INSERT INTO FORMAS_ENTREGA (Descripcion, RequiereDireccion) VALUES ('Envío a domicilio', 1);
GO

INSERT INTO PERFILES (Descripcion) VALUES ('Administrador');
INSERT INTO PERFILES (Descripcion) VALUES ('Cliente');
INSERT INTO PERFILES (Descripcion) VALUES ('Vendedor');
GO

-- estados fijos, el orden importa porque los sp usan estos id
INSERT INTO ESTADOS_PEDIDO(Descripcion) VALUES ('Pendiente de pago'),('Pagado'),('En preparación'),('Enviado'),('Entregado'),('Cancelado');
GO

-- 4. PROCEDIMIENTOS ALMACENADOS
-- Martin -> 31/10/26 1530
CREATE PROCEDURE spAltaCategoria @Nombre VARCHAR(100), @Descripcion VARCHAR(255) AS BEGIN INSERT INTO CATEGORIAS (Nombre,Descripcion,Activa) VALUES (@Nombre,@Descripcion,1) END
GO
-- Martin -> 31/10/26 1700
CREATE PROCEDURE spBuscarCategoriaPorId @id INT AS BEGIN SELECT Id, Nombre, Descripcion, Activa FROM CATEGORIAS WHERE Id = @id END
GO
-- Martin -> 31/10/26 1755
CREATE PROCEDURE spModificarCategoria @Id INT, @Nombre VARCHAR(100), @Descripcion VARCHAR(255) AS BEGIN UPDATE CATEGORIAS SET Nombre = @Nombre, Descripcion = @Descripcion WHERE Id = @Id END
GO
-- Martin --> 1/11/26 2200
CREATE PROCEDURE spCambiarEstadoCategoria @Id INT, @Activa BIT AS BEGIN UPDATE CATEGORIAS SET Activa = @Activa WHERE Id = @Id END
GO


-- -----------------------------------------
-- MÓDULO PRODUCTOS
-- -----------------------------------------
-- 1. Listar todos los productos con su categoría
CREATE PROCEDURE spListarProductos
AS
BEGIN
    SELECT P.Id, P.Codigo, P.Nombre, P.Descripcion, P.PrecioVenta, P.Stock, P.IdCategoria, C.Nombre AS CategoriaNombre, P.ImagenUrl, P.Activo
    FROM PRODUCTOS P
    INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id;
END;
GO

-- 2. Alta de un nuevo producto (Autogeneración de código con SCOPE_IDENTITY)
CREATE PROCEDURE spAltaProducto
    @Nombre VARCHAR(100), @Descripcion VARCHAR(255), @PrecioVenta MONEY, @Stock INT, @IdCategoria INT, @ImagenUrl VARCHAR(500), @Activo BIT, @CodigoPropio VARCHAR(50) = NULL
AS
BEGIN
    DECLARE @NuevoId INT;
    DECLARE @CodigoFinal VARCHAR(50);
    DECLARE @PrefijoCategoria VARCHAR(3);

    INSERT INTO PRODUCTOS (Nombre, Descripcion, PrecioVenta, Stock, IdCategoria, ImagenUrl, Activo, Codigo)
    VALUES (@Nombre, @Descripcion, @PrecioVenta, @Stock, @IdCategoria, @ImagenUrl, @Activo, @CodigoPropio);

    SET @NuevoId = SCOPE_IDENTITY();

    IF @CodigoPropio IS NULL OR LTRIM(RTRIM(@CodigoPropio)) = ''
    BEGIN
        SELECT @PrefijoCategoria = UPPER(LEFT(Nombre, 3)) FROM CATEGORIAS WHERE Id = @IdCategoria;
        SET @CodigoFinal = @PrefijoCategoria + '-' + RIGHT('0000' + CAST(@NuevoId AS VARCHAR(10)), 4);
        UPDATE PRODUCTOS SET Codigo = @CodigoFinal WHERE Id = @NuevoId;
    END
END;
GO

-- 3. Modificar un producto existente
CREATE PROCEDURE spModificarProducto
    @Id INT, @Nombre VARCHAR(100), @Descripcion VARCHAR(255), @PrecioVenta MONEY, @Stock INT, @IdCategoria INT, @ImagenUrl VARCHAR(500)
AS BEGIN
    UPDATE PRODUCTOS SET Nombre = @Nombre, Descripcion = @Descripcion, PrecioVenta = @PrecioVenta, Stock = @Stock, IdCategoria = @IdCategoria, ImagenUrl = @ImagenUrl WHERE Id = @Id;
END;
GO

-- 4. Baja lógica (cambiar estado activo/inactivo)
CREATE PROCEDURE spBajaLogicaProducto @Id INT AS BEGIN UPDATE PRODUCTOS SET Activo = CASE WHEN Activo = 1 THEN 0 ELSE 1 END WHERE Id = @Id; END;
GO


-- -----------------------------------------
-- MÓDULO USUARIOS Y DIRECCIONES
-- -----------------------------------------
-- 1. Alta usuario (Registro)
CREATE PROCEDURE spAltaUsuario
    @Nombre VARCHAR(50), @Apellido VARCHAR(50), @Email VARCHAR(100), @Clave VARCHAR(50), @Telefono VARCHAR(30), @IdPerfil INT
AS BEGIN
    INSERT INTO USUARIOS (Nombre, Apellido, Email, Clave, Telefono, IdPerfil, Activo, FechaAlta) VALUES (@Nombre, @Apellido, @Email, @Clave, @Telefono, @IdPerfil, 1, GETDATE());
END;
GO

-- 2. Buscar / Validar usuario por Email y Clave (Login)
CREATE PROCEDURE spBuscarUsuarioPorEmailYClave @Email VARCHAR(100), @Clave VARCHAR(50)
AS BEGIN
    SELECT U.Id, U.Nombre, U.Apellido, U.Email, U.Clave, U.Telefono, U.IdPerfil, P.Descripcion AS PerfilDescripcion, U.Activo, U.FechaAlta, U.UltimoAcceso
    FROM USUARIOS U INNER JOIN PERFILES P ON U.IdPerfil = P.Id WHERE U.Email = @Email AND U.Clave = @Clave AND U.Activo = 1;
END;
GO

-- 3. Modificar datos de un usuario existente
CREATE PROCEDURE spModificarUsuario @Id INT, @Nombre VARCHAR(50), @Apellido VARCHAR(50), @Email VARCHAR(100), @Telefono VARCHAR(30), @IdPerfil INT
AS BEGIN UPDATE USUARIOS SET Nombre = @Nombre, Apellido = @Apellido, Email = @Email, Telefono = @Telefono, IdPerfil = @IdPerfil WHERE Id = @Id; END;
GO

-- 4. Activar o Desactivar usuario (Baja lógica)
CREATE PROCEDURE spCambiarEstadoUsuario @Id INT, @Activo BIT AS BEGIN UPDATE USUARIOS SET Activo = @Activo WHERE Id = @Id; END;
GO

-- 1. Alta de dirección
CREATE PROCEDURE spAltaDireccion
    @IdUsuario INT, @Calle VARCHAR(100), @Numero VARCHAR(20), @Provincia VARCHAR(100), @Localidad VARCHAR(100), @CodigoPostal VARCHAR(20), @Observaciones VARCHAR(255), @Principal BIT
AS BEGIN
    IF @Principal = 1 BEGIN UPDATE DIRECCIONES SET Principal = 0 WHERE IdUsuario = @IdUsuario; END
    INSERT INTO DIRECCIONES (IdUsuario, Calle, Numero, Provincia, Localidad, CodigoPostal, Observaciones, Activa, Principal)
    VALUES (@IdUsuario, @Calle, @Numero, @Provincia, @Localidad, @CodigoPostal, @Observaciones, 1, @Principal);
END;
GO

-- 2. Modificar dirección existente
CREATE PROCEDURE spModificarDireccion @Id INT, @Calle VARCHAR(100), @Numero VARCHAR(20), @Provincia VARCHAR(100), @Localidad VARCHAR(100), @CodigoPostal VARCHAR(20), @Observaciones VARCHAR(255)
AS BEGIN UPDATE DIRECCIONES SET Calle = @Calle, Numero = @Numero, Provincia = @Provincia, Localidad = @Localidad, CodigoPostal = @CodigoPostal, Observaciones = @Observaciones WHERE Id = @Id; END;
GO

-- 3. Listar direcciones
CREATE PROCEDURE spListarDireccionesPorUsuario @IdUsuario INT
AS BEGIN SELECT Id, IdUsuario, Calle, Numero, Provincia, Localidad, CodigoPostal, Observaciones, Activa, Principal FROM DIRECCIONES WHERE IdUsuario = @IdUsuario AND Activa = 1; END;
GO

-- 4. Marcar dirección principal
CREATE PROCEDURE spMarcarDireccionPrincipal @Id INT, @IdUsuario INT
AS BEGIN
    UPDATE DIRECCIONES SET Principal = 0 WHERE IdUsuario = @IdUsuario;
    UPDATE DIRECCIONES SET Principal = 1 WHERE Id = @Id AND IdUsuario = @IdUsuario;
END;
GO

-- 5. Desactivar o activar dirección (Baja lógica)
CREATE PROCEDURE spCambiarEstadoDireccion @Id INT, @Activa BIT AS BEGIN UPDATE DIRECCIONES SET Activa = @Activa, Principal = CASE WHEN @Activa = 0 THEN 0 ELSE Principal END WHERE Id = @Id; END;
GO


-- -----------------------------------------
-- MÓDULO PEDIDOS (Etapa 3)
-- -----------------------------------------
-- Martin - 12/11/26
CREATE PROCEDURE spAltaPedido
    @IdUsuario INT, @IdFormaEntrega INT, @IdDireccion INT, @IdFormaPago INT, @Total MONEY
AS BEGIN
    INSERT INTO PEDIDOS (IdUsuario, IdFormaEntrega, IdDireccion, IdFormaPago, Total) VALUES (@IdUsuario, @IdFormaEntrega, @IdDireccion, @IdFormaPago, @Total)
    DECLARE @IdPedido INT = SCOPE_IDENTITY()
    INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario) VALUES (@IdPedido, 1, @IdUsuario)
    SELECT @IdPedido
END
GO

CREATE PROCEDURE spAltaItemPedido
    @IdPedido INT, @IdProducto INT, @Cantidad INT, @PrecioUnitario MONEY
AS BEGIN
    UPDATE PRODUCTOS SET Stock = Stock - @Cantidad WHERE Id = @IdProducto AND Stock >= @Cantidad;
    IF @@ROWCOUNT = 0 THROW 50001, 'No hay stock suficiente para este producto', 1;
    INSERT INTO ITEMS_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario) VALUES (@IdPedido, @IdProducto, @Cantidad, @PrecioUnitario);
END
GO

-- Martin - 13/11/26
CREATE PROCEDURE spListarPedidos
    @IdEstado INT = NULL, @FechaDesde DATE = NULL, @FechaHasta DATE = NULL, @Cliente VARCHAR(100) = NULL
AS BEGIN
    SELECT P.Id, P.FechaCreacion, P.IdUsuario, U.Nombre AS NombreCliente, U.Apellido AS ApellidoCliente, FE.Descripcion AS FormaEntrega, FP.Descripcion AS FormaPago, E.Descripcion AS Estado, P.Total, P.CodigoSeguimiento, P.EstadoComprobante
    FROM PEDIDOS P
    INNER JOIN USUARIOS U ON P.IdUsuario = U.Id INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    WHERE (@IdEstado IS NULL OR P.IdEstado = @IdEstado) AND (@FechaDesde IS NULL OR P.FechaCreacion >= @FechaDesde) AND (@FechaHasta IS NULL OR P.FechaCreacion < DATEADD(DAY, 1, @FechaHasta)) AND (@Cliente IS NULL OR U.Nombre + ' ' + U.Apellido LIKE '%' + @Cliente + '%' OR U.Email LIKE '%' + @Cliente + '%')
    ORDER BY P.FechaCreacion DESC
END
GO

CREATE PROCEDURE spBuscarPedidoPorId @Id INT
AS BEGIN
    SELECT P.Id, P.FechaCreacion, P.IdUsuario, U.Nombre AS NombreCliente, U.Apellido AS ApellidoCliente, U.Email, U.Telefono, P.IdFormaEntrega, FE.Descripcion AS FormaEntrega, P.IdDireccion, D.Calle, D.Numero, D.Localidad, D.Provincia, D.CodigoPostal, P.IdFormaPago, FP.Descripcion AS FormaPago, P.IdEstado, E.Descripcion AS Estado, P.Total, P.EmpresaEnvio, P.CodigoSeguimiento, P.ComprobanteUrl, P.EstadoComprobante
    FROM PEDIDOS P
    INNER JOIN USUARIOS U ON P.IdUsuario = U.Id LEFT JOIN DIRECCIONES D ON P.IdDireccion = D.Id INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    WHERE P.Id = @Id
END
GO

CREATE PROCEDURE spListarPedidosPorCliente @IdUsuario INT
AS BEGIN
    SELECT P.Id, P.FechaCreacion, FE.Descripcion AS FormaEntrega, FP.Descripcion AS FormaPago, E.Descripcion AS Estado, P.Total, P.EmpresaEnvio, P.CodigoSeguimiento, P.EstadoComprobante
    FROM PEDIDOS P INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    WHERE P.IdUsuario = @IdUsuario ORDER BY P.FechaCreacion DESC
END
GO

CREATE PROCEDURE spListarItemsPorPedido @IdPedido INT
AS BEGIN
    SELECT I.IdProducto, PR.Nombre, PR.ImagenUrl, I.Cantidad, I.PrecioUnitario, I.Cantidad * I.PrecioUnitario AS Subtotal
    FROM ITEMS_PEDIDO I INNER JOIN PRODUCTOS PR ON I.IdProducto = PR.Id WHERE I.IdPedido = @IdPedido
END
GO

CREATE PROCEDURE spCambiarEstadoPedido
@IdPedido INT,
@IdEstado INT,
@IdUsuario INT,
@EmpresaEnvio VARCHAR(50) = NULL,
@CodigoSeguimiento VARCHAR(255) = NULL
AS BEGIN
    DECLARE @EstadoActual INT;
    DECLARE @RequiereDireccion BIT;

    -- traigo el estado actual y si la forma de entrega es con envio
    SELECT @EstadoActual = P.IdEstado, @RequiereDireccion = FE.RequiereDireccion
    FROM PEDIDOS P
    INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id
    WHERE P.Id = @IdPedido;

    -- si el select no encontro nada el pedido no existe
    IF @EstadoActual IS NULL
        THROW 50011, 'El pedido no existe', 1;

    -- si ya esta entregado o cancelado no se toca mas
    IF @EstadoActual IN (5, 6)
        THROW 50003, 'El pedido ya esta cerrado y no se puede cambiar de estado', 1;

    -- para cancelar se usa spCancelarPedido, aca solo se avanza entre 2 y 5
    IF @IdEstado NOT IN (2, 3, 4, 5)
        THROW 50004, 'Estado no valido para este cambio', 1;

    -- solo se puede avanzar, ni el mismo estado ni para atras
    IF @IdEstado <= @EstadoActual
        THROW 50005, 'El estado nuevo tiene que ser posterior al actual', 1;

    -- sin cobrar no se prepara ni se entrega nada, de pendiente solo se pasa a pagado
    IF @EstadoActual = 1 AND @IdEstado <> 2
        THROW 50010, 'Primero hay que marcar el pedido como pagado', 1;

    -- si retira en el local no hay envio, pasa de en preparacion a entregado
    IF @IdEstado = 4 AND @RequiereDireccion = 0
        THROW 50006, 'El pedido se retira en el local y no pasa por enviado', 1;

    -- para marcarlo como enviado hay que decir con quien se mando, el codigo es opcional
    IF @IdEstado = 4 AND (@EmpresaEnvio IS NULL OR LTRIM(RTRIM(@EmpresaEnvio)) = '')
        THROW 50007, 'Para marcarlo como enviado hay que elegir con quien se envia', 1;

    BEGIN TRY
        BEGIN TRANSACTION

        -- la empresa y el codigo solo se guardan al pasar a enviado, en los otros estados quedan los que tenia
        UPDATE PEDIDOS SET IdEstado = @IdEstado,
            EmpresaEnvio = CASE WHEN @IdEstado = 4 THEN LTRIM(RTRIM(@EmpresaEnvio)) ELSE EmpresaEnvio END,
            CodigoSeguimiento = CASE WHEN @IdEstado = 4 THEN NULLIF(LTRIM(RTRIM(@CodigoSeguimiento)), '') ELSE CodigoSeguimiento END
        WHERE Id = @IdPedido

        INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario)
        VALUES (@IdPedido, @IdEstado, @IdUsuario)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- carga o corrige el codigo de seguimiento cuando el pedido ya esta enviado, por si el correo lo da despues
CREATE PROCEDURE spActualizarSeguimiento
@IdPedido INT,
@EmpresaEnvio VARCHAR(50),
@CodigoSeguimiento VARCHAR(255) = NULL
AS BEGIN
    IF NOT EXISTS (SELECT 1 FROM PEDIDOS WHERE Id = @IdPedido AND IdEstado = 4)
        THROW 50008, 'El seguimiento solo se puede cambiar mientras el pedido esta enviado', 1;

    IF @EmpresaEnvio IS NULL OR LTRIM(RTRIM(@EmpresaEnvio)) = ''
        THROW 50009, 'Hay que elegir con quien se envia', 1;

    UPDATE PEDIDOS SET
        EmpresaEnvio = LTRIM(RTRIM(@EmpresaEnvio)),
        CodigoSeguimiento = NULLIF(LTRIM(RTRIM(@CodigoSeguimiento)), '')
    WHERE Id = @IdPedido
END
GO

CREATE PROCEDURE spCancelarPedido @IdPedido INT, @IdUsuario INT
AS BEGIN
    IF EXISTS (SELECT 1 FROM PEDIDOS WHERE Id = @IdPedido AND IdEstado IN (4, 5, 6)) THROW 50002, 'El pedido no se puede cancelar en el estado que esta', 1;
    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE PR SET PR.Stock = PR.Stock + I.Cantidad FROM PRODUCTOS PR INNER JOIN ITEMS_PEDIDO I ON PR.Id = I.IdProducto WHERE I.IdPedido = @IdPedido
        UPDATE PEDIDOS SET IdEstado = 6 WHERE Id = @IdPedido
        INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario) VALUES (@IdPedido, 6, @IdUsuario)
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END
GO

CREATE PROCEDURE spAgregarObservacionPedido @IdPedido INT, @IdUsuario INT, @Observacion VARCHAR(500) AS BEGIN INSERT INTO OBSERVACIONES_PEDIDO (IdPedido, IdUsuario, Observacion) VALUES (@IdPedido, @IdUsuario, @Observacion) END
GO

CREATE PROCEDURE spListarObservacionesPorPedido @IdPedido INT
AS BEGIN SELECT O.Id, O.IdUsuario, U.Nombre AS NombreUsuario, U.Apellido AS ApellidoUsuario, O.Fecha, O.Observacion FROM OBSERVACIONES_PEDIDO O INNER JOIN USUARIOS U ON O.IdUsuario = U.Id WHERE O.IdPedido = @IdPedido ORDER BY O.Fecha ASC END
GO

CREATE PROCEDURE spListarHistorialPorPedido @IdPedido INT
AS BEGIN SELECT H.Id, H.IdEstado, E.Descripcion AS Estado, H.IdUsuario, U.Nombre AS NombreUsuario, U.Apellido AS ApellidoUsuario, H.Fecha FROM HISTORIAL_ESTADOS H INNER JOIN ESTADOS_PEDIDO E ON H.IdEstado = E.Id INNER JOIN USUARIOS U ON H.IdUsuario = U.Id WHERE H.IdPedido = @IdPedido ORDER BY H.Fecha ASC END
GO