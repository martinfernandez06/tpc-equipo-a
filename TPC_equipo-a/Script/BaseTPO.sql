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
    Activa BIT DEFAULT 1 NOT NULL
);
GO

-- Tabla Productos --
CREATE TABLE PRODUCTOS (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo VARCHAR(50) NULL,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    PrecioVenta MONEY NOT NULL CHECK (PrecioVenta > 0),
    Stock INT NOT NULL CHECK (Stock >= 0),
    IdCategoria INT NOT NULL FOREIGN KEY REFERENCES CATEGORIAS(Id),
    ImagenUrl VARCHAR(500) NULL,
    Activo BIT DEFAULT 1 NOT NULL
);
GO

-- Índice que hace que el Código sea único, pero ignora cuando es NULL
CREATE UNIQUE NONCLUSTERED INDEX UQ_Productos_Codigo ON PRODUCTOS(Codigo) WHERE Codigo IS NOT NULL;
GO

-- TABLAS DE FORMAS DE PAGO Y ENTREGA (Pablo 06/11/2026)
CREATE TABLE FORMAS_PAGO (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) UNIQUE NOT NULL,
    Activa BIT DEFAULT 1 NOT NULL,
    RequiereComprobante BIT DEFAULT 0 NOT NULL
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
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Clave VARCHAR(100) NOT NULL,
    Telefono VARCHAR(30) NULL,
    IdPerfil INT NOT NULL FOREIGN KEY REFERENCES PERFILES(Id),
    Activo BIT DEFAULT 1 NOT NULL,
    -- NUEVO: el usuario debe confirmar su correo.
    EmailConfirmado BIT NOT NULL CONSTRAINT DF_USUARIOS_EmailConfirmado DEFAULT (0),
    FechaAlta DATETIME DEFAULT CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Argentina Standard Time' AS DATETIME) NOT NULL,
    UltimoAcceso DATETIME NULL
);
GO

-- NUEVO: TOKENS DE USUARIO
-- Se utiliza para confirmación de correo y recuperación de contraseña.
CREATE TABLE TOKENS_USUARIO (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL,
    TokenHash CHAR(64) NOT NULL,
    Tipo VARCHAR(20) NOT NULL,
    FechaCreacion DATETIME2 NOT NULL
        CONSTRAINT DF_TOKENS_USUARIO_FechaCreacion DEFAULT (SYSDATETIME()),
    FechaExpiracion DATETIME2 NOT NULL,
    Usado BIT NOT NULL
        CONSTRAINT DF_TOKENS_USUARIO_Usado DEFAULT (0),

    CONSTRAINT FK_TOKENS_USUARIO_USUARIOS
        FOREIGN KEY (IdUsuario) REFERENCES USUARIOS(Id)
        ON DELETE CASCADE,

    CONSTRAINT UQ_TOKENS_USUARIO_TokenHash UNIQUE (TokenHash),

    CONSTRAINT CK_TOKENS_USUARIO_Tipo
        CHECK (Tipo IN ('CONFIRMACION', 'RECUPERACION'))
);
GO

CREATE INDEX IX_TOKENS_USUARIO_Usuario_Tipo
ON TOKENS_USUARIO (IdUsuario, Tipo, Usado);
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
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_PEDIDOS_FECHACREACION DEFAULT CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Argentina Standard Time' AS DATETIME),
    IdFormaEntrega INT NOT NULL,
    IdDireccion INT NULL,
    IdFormaPago INT NOT NULL,
    IdEstado INT NOT NULL CONSTRAINT DF_PEDIDOS_IDESTADO DEFAULT 1,
    Total MONEY NOT NULL,
    CodigoSeguimiento VARCHAR(255) NULL,
    EmpresaEnvio VARCHAR(50) NULL,
    ComprobanteUrl VARCHAR(500) NULL,
    EstadoComprobante VARCHAR(20) NULL,
    -- lo escribe el admin o el cliente al cancelar, el cliente lo ve en mis compras y va en el mail
    MotivoCancelacion VARCHAR(400) NULL,
    -- lo escribe el admin al rechazar el comprobante, el cliente lo ve en mis compras y se borra cuando sube otro
    MotivoRechazoComprobante VARCHAR(400) NULL,

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
    Fecha DATETIME NOT NULL CONSTRAINT DF_HISTORIAL_ESTADOS_FECHA DEFAULT CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Argentina Standard Time' AS DATETIME),
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
    Fecha DATETIME NOT NULL CONSTRAINT DF_OBSERVACIONES_PEDIDO_FECHA DEFAULT CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Argentina Standard Time' AS DATETIME),
    Observacion VARCHAR(500) NOT NULL,
    CONSTRAINT PK_OBSERVACIONES_PEDIDO_ID PRIMARY KEY(Id),
    CONSTRAINT FK_OBSERVACIONES_PEDIDO_IDPEDIDO FOREIGN KEY(IdPedido) REFERENCES PEDIDOS(Id),
    CONSTRAINT FK_OBSERVACIONES_PEDIDO_IDUSUARIO FOREIGN KEY(IdUsuario) REFERENCES USUARIOS(Id)
);
GO

CREATE TABLE RECORDARME_USUARIO (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL,
    TokenHash CHAR(64) NOT NULL UNIQUE,
    FechaCreacion DATETIME2 NOT NULL
        CONSTRAINT DF_RECORDARME_FechaCreacion DEFAULT (SYSDATETIME()),
    FechaExpiracion DATETIME2 NOT NULL,
    Revocado BIT NOT NULL
        CONSTRAINT DF_RECORDARME_Revocado DEFAULT (0),

    CONSTRAINT FK_RECORDARME_USUARIO
        FOREIGN KEY (IdUsuario) REFERENCES USUARIOS(Id)
        ON DELETE CASCADE
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
INSERT INTO FORMAS_PAGO (Descripcion, RequiereComprobante) VALUES ('Transferencia', 1);
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

-- 2. Alta de un nuevo producto (Autogeneración de código con SCOPE_IDENTITY, Validacion,etc.)
CREATE PROCEDURE spAltaProducto
    @Nombre VARCHAR(100), @Descripcion VARCHAR(255), @PrecioVenta MONEY, @Stock INT, @IdCategoria INT, @ImagenUrl VARCHAR(500), @Activo BIT, @CodigoPropio VARCHAR(50) = NULL
AS
BEGIN
    DECLARE @NuevoId INT;
    DECLARE @CodigoFinal VARCHAR(50);
    DECLARE @PrefijoCategoria VARCHAR(3);

    -- VALIDACIÓN: Si el dueño tipeó un código, revisamos que no exista
    IF @CodigoPropio IS NOT NULL AND LTRIM(RTRIM(@CodigoPropio)) <> ''
    BEGIN
        IF EXISTS(SELECT 1 FROM PRODUCTOS WHERE Codigo = @CodigoPropio)
            THROW 50012, 'El código de producto ingresado ya existe.', 1;
    END

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
    @Id INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(255),
    @PrecioVenta MONEY,
    @Stock INT,
    @IdCategoria INT,
    @ImagenUrl VARCHAR(500),
    @CodigoPropio VARCHAR(50) = NULL
AS
BEGIN
    DECLARE @CodigoFinal VARCHAR(50);
    DECLARE @PrefijoCategoria VARCHAR(3);

    SET @CodigoPropio = NULLIF(LTRIM(RTRIM(@CodigoPropio)), '');

    IF @CodigoPropio IS NOT NULL
    BEGIN
        -- Valida que el código no pertenezca a OTRO producto
        IF EXISTS (SELECT 1 FROM PRODUCTOS WHERE Codigo = @CodigoPropio AND Id <> @Id)
            THROW 50012, 'El código de producto ingresado ya existe.', 1;

        SET @CodigoFinal = @CodigoPropio;
    END
    ELSE
    BEGIN
        -- Si lo dejó vacío, auto-genera con el prefijo de la categoría y el Id actual
        SELECT @PrefijoCategoria = UPPER(LEFT(Nombre, 3)) FROM CATEGORIAS WHERE Id = @IdCategoria;
        SET @CodigoFinal = @PrefijoCategoria + '-' + RIGHT('0000' + CAST(@Id AS VARCHAR(10)), 4);

        IF EXISTS (SELECT 1 FROM PRODUCTOS WHERE Codigo = @CodigoFinal AND Id <> @Id)
            THROW 50012, 'El código autogenerado ya existe en otro producto.', 1;
    END

    UPDATE PRODUCTOS
    SET Codigo = @CodigoFinal,
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        PrecioVenta = @PrecioVenta,
        Stock = @Stock,
        IdCategoria = @IdCategoria,
        ImagenUrl = @ImagenUrl
    WHERE Id = @Id;
END;
GO


-- -----------------------------------------
-- MÓDULO USUARIOS Y DIRECCIONES
-- -----------------------------------------
-- 1. Alta usuario (Registro)
-- EmailConfirmado se establece a 0
CREATE PROCEDURE spAltaUsuario
    @Nombre VARCHAR(50), @Apellido VARCHAR(50), @Email VARCHAR(100), @Clave VARCHAR(50), @Telefono VARCHAR(30), @IdPerfil INT
AS BEGIN
    SET NOCOUNT ON;
    INSERT INTO USUARIOS (Nombre, Apellido, Email, Clave, Telefono, IdPerfil, Activo, FechaAlta)
    OUTPUT INSERTED.Id
    VALUES (@Nombre, @Apellido, @Email, @Clave, @Telefono, @IdPerfil, 1, CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Argentina Standard Time' AS DATETIME));
END;
GO

-- 2. Buscar / Validar usuario por Email y Clave (Login)
-- Devuelve EmailConfirmado para que Login.aspx.cs pueda verifique
CREATE PROCEDURE spBuscarUsuarioPorEmailYClave @Email VARCHAR(100), @Clave VARCHAR(50)
AS BEGIN
    SET NOCOUNT ON;
    SELECT U.Id, U.Nombre, U.Apellido, U.Email, U.Clave, U.Telefono, U.IdPerfil, P.Descripcion AS PerfilDescripcion, U.Activo, U.EmailConfirmado, U.FechaAlta, U.UltimoAcceso
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

-- 5. guarda cuando entro el usuario por ultima vez, lo llama el login
CREATE PROCEDURE spActualizarUltimoAcceso @Id INT AS BEGIN UPDATE USUARIOS SET UltimoAcceso = CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Argentina Standard Time' AS DATETIME) WHERE Id = @Id; END;
GO

-- guardar token de confirmacion/recuperacion
-- anula tokens anteriores para ese usuario.
CREATE PROCEDURE spGuardarTokenUsuario
    @IdUsuario INT,
    @TokenHash CHAR(64),
    @Tipo VARCHAR(20),
    @FechaExpiracion DATETIME2
AS
BEGIN
    SET NOCOUNT ON;

    IF @Tipo NOT IN ('CONFIRMACION', 'RECUPERACION')
        THROW 50010, 'Tipo de token no válido.', 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE TOKENS_USUARIO
        SET Usado = 1
        WHERE IdUsuario = @IdUsuario
          AND Tipo = @Tipo
          AND Usado = 0;

        INSERT INTO TOKENS_USUARIO
            (IdUsuario, TokenHash, Tipo, FechaExpiracion)
        VALUES
            (@IdUsuario, @TokenHash, @Tipo, @FechaExpiracion);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

-- confirmar correo con token
-- Confirmado = 1 si el token es valido
CREATE PROCEDURE spConfirmarEmail
    @TokenHash CHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdUsuario INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @IdUsuario = IdUsuario
        FROM TOKENS_USUARIO WITH (UPDLOCK, ROWLOCK)
        WHERE TokenHash = @TokenHash
          AND Tipo = 'CONFIRMACION'
          AND Usado = 0
          AND FechaExpiracion > SYSDATETIME();

        IF @IdUsuario IS NULL
        BEGIN
            ROLLBACK TRANSACTION;

            SELECT
                CAST(0 AS BIT) AS Confirmado,
                CAST(NULL AS INT) AS IdUsuario;

            RETURN;
        END;

        UPDATE USUARIOS
        SET EmailConfirmado = 1
        WHERE Id = @IdUsuario;

        UPDATE TOKENS_USUARIO
        SET Usado = 1
        WHERE TokenHash = @TokenHash;

        COMMIT TRANSACTION;

        SELECT
            CAST(1 AS BIT) AS Confirmado,
            @IdUsuario AS IdUsuario;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

-- Validar token de recuperación de contraseña
CREATE PROCEDURE spValidarTokenRecuperacion
    @TokenHash CHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        T.IdUsuario,
        U.Email,
        U.Nombre
    FROM TOKENS_USUARIO T
    INNER JOIN USUARIOS U ON T.IdUsuario = U.Id
    WHERE T.TokenHash = @TokenHash
      AND T.Tipo = 'RECUPERACION'
      AND T.Usado = 0
      AND T.FechaExpiracion > SYSDATETIME()
      AND U.Activo = 1;
END;
GO

-- Restablecer contraseña y consumir el token
CREATE PROCEDURE spRestablecerPassword
    @TokenHash CHAR(64),
    @NuevaClave VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdUsuario INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @IdUsuario = IdUsuario
        FROM TOKENS_USUARIO WITH (UPDLOCK, ROWLOCK)
        WHERE TokenHash = @TokenHash
          AND Tipo = 'RECUPERACION'
          AND Usado = 0
          AND FechaExpiracion > SYSDATETIME();

        IF @IdUsuario IS NULL
        BEGIN
            ROLLBACK TRANSACTION;

            SELECT CAST(0 AS BIT) AS Restablecido;
            RETURN;
        END;

        UPDATE USUARIOS
        SET Clave = @NuevaClave
        WHERE Id = @IdUsuario;

        UPDATE TOKENS_USUARIO
        SET Usado = 1
        WHERE TokenHash = @TokenHash;

        COMMIT TRANSACTION;

        SELECT CAST(1 AS BIT) AS Restablecido;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;

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


-- Guardar un nuevo token persistente
CREATE PROCEDURE spGuardarTokenRecordarme
    @IdUsuario INT,
    @TokenHash CHAR(64),
    @FechaExpiracion DATETIME2
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO RECORDARME_USUARIO
        (IdUsuario, TokenHash, FechaExpiracion)
    VALUES
        (@IdUsuario, @TokenHash, @FechaExpiracion);
END;
GO

-- Buscar usuario mediante un token persistente
CREATE PROCEDURE spBuscarUsuarioPorTokenRecordarme
    @TokenHash CHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        U.Id,
        U.Nombre,
        U.Apellido,
        U.Email,
        U.Telefono,
        U.IdPerfil,
        P.Descripcion AS PerfilDescripcion,
        U.Activo,
        U.EmailConfirmado,
        U.FechaAlta,
        U.UltimoAcceso
    FROM RECORDARME_USUARIO R
    INNER JOIN USUARIOS U ON R.IdUsuario = U.Id
    INNER JOIN PERFILES P ON U.IdPerfil = P.Id
    WHERE R.TokenHash = @TokenHash
      AND R.Revocado = 0
      AND R.FechaExpiracion > SYSDATETIME()
      AND U.Activo = 1
      AND U.EmailConfirmado = 1;
END;
GO

-- Revocar un token persistente
CREATE PROCEDURE spRevocarTokenRecordarme
    @TokenHash CHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE RECORDARME_USUARIO
    SET Revocado = 1
    WHERE TokenHash = @TokenHash
      AND Revocado = 0;
END;
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

-- si un producto del pedido no tenia stock, deshace lo que se alcanzo a guardar como si el pedido nunca se hubiera hecho
CREATE PROCEDURE spAnularPedidoIncompleto @IdPedido INT
AS BEGIN
    -- solo un pedido recien creado, asi nunca borra uno que ya avanzo
    IF NOT EXISTS (SELECT 1 FROM PEDIDOS WHERE Id = @IdPedido AND IdEstado = 1)
        RETURN;

    BEGIN TRY
        BEGIN TRANSACTION
        -- devuelvo al stock lo que ya se habia descontado
        UPDATE PR SET PR.Stock = PR.Stock + I.Cantidad FROM PRODUCTOS PR INNER JOIN ITEMS_PEDIDO I ON PR.Id = I.IdProducto WHERE I.IdPedido = @IdPedido
        -- borro primero lo que depende del pedido y al final el pedido, si no las foreign key no dejan
        DELETE FROM ITEMS_PEDIDO WHERE IdPedido = @IdPedido
        DELETE FROM HISTORIAL_ESTADOS WHERE IdPedido = @IdPedido
        DELETE FROM PEDIDOS WHERE Id = @IdPedido

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
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
    SELECT P.Id, P.FechaCreacion, P.IdUsuario, U.Nombre AS NombreCliente, U.Apellido AS ApellidoCliente, U.Email, U.Telefono, P.IdFormaEntrega, FE.Descripcion AS FormaEntrega, P.IdDireccion, D.Calle, D.Numero, D.Localidad, D.Provincia, D.CodigoPostal, P.IdFormaPago, FP.Descripcion AS FormaPago, P.IdEstado, E.Descripcion AS Estado, P.Total, P.EmpresaEnvio, P.CodigoSeguimiento, P.ComprobanteUrl, P.EstadoComprobante, FP.RequiereComprobante, P.MotivoCancelacion
    FROM PEDIDOS P
    INNER JOIN USUARIOS U ON P.IdUsuario = U.Id LEFT JOIN DIRECCIONES D ON P.IdDireccion = D.Id INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    WHERE P.Id = @Id
END
GO

CREATE PROCEDURE spListarPedidosPorCliente @IdUsuario INT, @FechaDesde DATE = NULL, @FechaHasta DATE = NULL
AS BEGIN
    SELECT P.Id, P.FechaCreacion, FE.Descripcion AS FormaEntrega, P.IdFormaPago, FP.Descripcion AS FormaPago, FP.RequiereComprobante, P.IdEstado, E.Descripcion AS Estado, P.Total, P.EmpresaEnvio, P.CodigoSeguimiento, P.ComprobanteUrl, P.EstadoComprobante, P.MotivoRechazoComprobante, P.MotivoCancelacion,
        CAST(CASE WHEN EXISTS (SELECT 1 FROM HISTORIAL_ESTADOS H WHERE H.IdPedido = P.Id AND H.IdEstado = 2) THEN 1 ELSE 0 END AS BIT) AS EstuvoPagado,
        P.IdDireccion, D.Calle, D.Numero, D.Localidad, D.Provincia, D.CodigoPostal
    FROM PEDIDOS P INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id INNER JOIN ESTADOS_PEDIDO E ON P.IdEstado = E.Id
    LEFT JOIN DIRECCIONES D ON P.IdDireccion = D.Id
    -- las fechas son opcionales igual que en spListarPedidos, el hasta suma un dia para que entre todo ese dia
    WHERE P.IdUsuario = @IdUsuario
    AND (@FechaDesde IS NULL OR P.FechaCreacion >= @FechaDesde)
    AND (@FechaHasta IS NULL OR P.FechaCreacion < DATEADD(DAY, 1, @FechaHasta))
    ORDER BY P.FechaCreacion DESC
END
GO

CREATE PROCEDURE spListarItemsPorPedido @IdPedido INT
AS BEGIN
    SELECT I.IdProducto, PR.Nombre, PR.ImagenUrl, I.Cantidad, I.PrecioUnitario, I.Cantidad * I.PrecioUnitario AS Subtotal
    FROM ITEMS_PEDIDO I INNER JOIN PRODUCTOS PR ON I.IdProducto = PR.Id WHERE I.IdPedido = @IdPedido
END
GO

-- cambia el estado de un pedido y lo anota en el historial con quien lo cambio
CREATE PROCEDURE spCambiarEstadoPedido
@IdPedido INT,
@IdEstado INT,
@IdUsuario INT,
@EmpresaEnvio VARCHAR(50) = NULL,
@CodigoSeguimiento VARCHAR(255) = NULL
AS BEGIN
    DECLARE @EstadoActual INT;
    DECLARE @RequiereDireccion BIT;
    DECLARE @RequiereComprobante BIT;

    -- traigo el estado actual, si la forma de entrega es con envio y si la forma de pago pide comprobante
    SELECT @EstadoActual = P.IdEstado, @RequiereDireccion = FE.RequiereDireccion, @RequiereComprobante = FP.RequiereComprobante
    FROM PEDIDOS P
    INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id
    INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id
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

    -- las transferencias solo pasan a pagado aceptando el comprobante en la bandeja
    IF @IdEstado = 2 AND @RequiereComprobante = 1
        THROW 50013, 'Este pedido se paga con transferencia, pasa a pagado aceptando el comprobante', 1;

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

-- cancela un pedido si todavia no salio, devuelve las unidades al stock y guarda el motivo que ve el cliente
CREATE PROCEDURE spCancelarPedido @IdPedido INT, @IdUsuario INT, @Motivo VARCHAR(400)
AS BEGIN
    IF NOT EXISTS (SELECT 1 FROM PEDIDOS WHERE Id = @IdPedido)
        THROW 50011, 'El pedido no existe', 1;

    -- si ya esta enviado, entregado o cancelado no se puede cancelar
    IF EXISTS (SELECT 1 FROM PEDIDOS WHERE Id = @IdPedido AND IdEstado IN (4, 5, 6))
        THROW 50002, 'El pedido no se puede cancelar en el estado que esta', 1;


    -- si el cliente mando un comprobante primero hay que revisarlo, asi se sabe si hay plata para devolver
    IF EXISTS (SELECT 1 FROM PEDIDOS WHERE Id = @IdPedido AND EstadoComprobante = 'Pendiente')
        THROW 50026, 'Primero revisa el comprobante en la bandeja, aceptalo o rechazalo antes de cancelar', 1;

    -- el motivo es obligatorio porque el cliente lo ve en mis compras y le llega por mail
    IF @Motivo IS NULL OR LTRIM(RTRIM(@Motivo)) = ''
        THROW 50017, 'Hay que escribir el motivo de la cancelacion', 1;

    BEGIN TRY
        BEGIN TRANSACTION
        -- devuelvo al stock lo que compro de cada producto
        UPDATE PR SET PR.Stock = PR.Stock + I.Cantidad FROM PRODUCTOS PR INNER JOIN ITEMS_PEDIDO I ON PR.Id = I.IdProducto WHERE I.IdPedido = @IdPedido
        UPDATE PEDIDOS SET IdEstado = 6, MotivoCancelacion = LTRIM(RTRIM(@Motivo)) WHERE Id = @IdPedido
        INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario) VALUES (@IdPedido, 6, @IdUsuario)
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; THROW;
    END CATCH
END
GO

-- el cliente cancela desde mis compras, solo si no pago nada y no mando comprobante, si no lo cancela la tienda
CREATE PROCEDURE spCancelarPedidoCliente @IdPedido INT, @IdUsuario INT, @Motivo VARCHAR(400)
AS BEGIN
    DECLARE @EstadoActual INT;
    DECLARE @EstadoComprobante VARCHAR(20);

    -- busco el pedido de ese cliente, asi nadie cancela uno ajeno cambiando el numero en la pagina
    SELECT @EstadoActual = IdEstado, @EstadoComprobante = EstadoComprobante FROM PEDIDOS WHERE Id = @IdPedido AND IdUsuario = @IdUsuario;
    IF @EstadoActual IS NULL
        THROW 50018, 'El pedido no existe o no es tuyo', 1;
    -- si ya pago o esta en camino hay plata o un paquete de por medio, eso lo maneja la tienda
    IF @EstadoActual <> 1
        THROW 50019, 'Este pedido ya no se puede cancelar desde mis compras, comunicate con la tienda', 1;
    -- si mando el comprobante puede que ya haya transferido, la devolucion la maneja la tienda
    IF @EstadoComprobante = 'Pendiente'
        THROW 50020, 'Ya mandaste el comprobante, para cancelar comunicate con la tienda', 1;
    IF @Motivo IS NULL OR LTRIM(RTRIM(@Motivo)) = ''
        THROW 50021, 'Hay que elegir el motivo de la cancelacion', 1;

    BEGIN TRY
        BEGIN TRANSACTION
        UPDATE PR SET PR.Stock = PR.Stock + I.Cantidad FROM PRODUCTOS PR INNER JOIN ITEMS_PEDIDO I ON PR.Id = I.IdProducto WHERE I.IdPedido = @IdPedido
        UPDATE PEDIDOS SET IdEstado = 6, MotivoCancelacion = LTRIM(RTRIM(@Motivo)) WHERE Id = @IdPedido
        -- en el historial queda el cliente como el que lo cancelo
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

-- Martin -- 18/11/26
-- reportes del admin, solo cuentan los pedidos cobrados (de pagado a entregado), pendientes y cancelados no
CREATE PROCEDURE spReporteTotalVendido
@FechaDesde DATE = NULL,
@FechaHasta DATE = NULL
AS BEGIN
    SELECT COUNT(*) AS CantidadPedidos, ISNULL(SUM(Total), 0) AS TotalVendido, ISNULL(AVG(Total), 0) AS TicketPromedio
    FROM PEDIDOS
    WHERE IdEstado BETWEEN 2 AND 5
    AND (@FechaDesde IS NULL OR FechaCreacion >= @FechaDesde)
    AND (@FechaHasta IS NULL OR FechaCreacion < DATEADD(DAY, 1, @FechaHasta))
END
GO

-- el left join con las fechas en el on hace que aparezcan todos los estados, aunque tengan 0 pedidos
CREATE PROCEDURE spReportePedidosPorEstado
@FechaDesde DATE = NULL,
@FechaHasta DATE = NULL
AS BEGIN
    SELECT E.Id, E.Descripcion AS Estado, COUNT(P.Id) AS Cantidad
    FROM ESTADOS_PEDIDO E
    LEFT JOIN PEDIDOS P ON P.IdEstado = E.Id
        AND (@FechaDesde IS NULL OR P.FechaCreacion >= @FechaDesde)
        AND (@FechaHasta IS NULL OR P.FechaCreacion < DATEADD(DAY, 1, @FechaHasta))
    GROUP BY E.Id, E.Descripcion
    ORDER BY E.Id
END
GO

-- los 10 que mas unidades vendieron, el total usa el precio que se pago en cada pedido
CREATE PROCEDURE spReporteProductosMasVendidos
@FechaDesde DATE = NULL,
@FechaHasta DATE = NULL
AS BEGIN
    SELECT TOP 10 PR.Id, PR.Codigo, PR.Nombre, SUM(I.Cantidad) AS Unidades, SUM(I.Cantidad * I.PrecioUnitario) AS TotalVendido
    FROM ITEMS_PEDIDO I
    INNER JOIN PEDIDOS P ON I.IdPedido = P.Id
    INNER JOIN PRODUCTOS PR ON I.IdProducto = PR.Id
    WHERE P.IdEstado BETWEEN 2 AND 5
    AND (@FechaDesde IS NULL OR P.FechaCreacion >= @FechaDesde)
    AND (@FechaHasta IS NULL OR P.FechaCreacion < DATEADD(DAY, 1, @FechaHasta))
    GROUP BY PR.Id, PR.Codigo, PR.Nombre
    ORDER BY Unidades DESC
END
GO

-- bandeja de comprobantes, solo los pendientes de pedidos que siguen sin pagar, el mas viejo primero
CREATE PROCEDURE spListarComprobantesPendientes
AS BEGIN
    SELECT P.Id, P.FechaCreacion, U.Nombre AS NombreCliente, U.Apellido AS ApellidoCliente, U.Email, FP.Descripcion AS FormaPago, P.Total, P.ComprobanteUrl
    FROM PEDIDOS P
    INNER JOIN USUARIOS U ON P.IdUsuario = U.Id
    INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id
    WHERE P.EstadoComprobante = 'Pendiente' AND P.IdEstado = 1
    ORDER BY P.FechaCreacion ASC
END
GO

-- el numerito del menu, cuenta con el mismo filtro que la bandeja
CREATE PROCEDURE spContarComprobantesPendientes
AS BEGIN
    SELECT COUNT(*) AS Cantidad FROM PEDIDOS WHERE EstadoComprobante = 'Pendiente' AND IdEstado = 1
END
GO

-- acepta el comprobante y el pedido pasa solo a pagado, todo junto o nada
CREATE PROCEDURE spAceptarComprobante @IdPedido INT, @IdUsuario INT
AS BEGIN
    DECLARE @EstadoActual INT;
    DECLARE @EstadoComprobante VARCHAR(20);

    SELECT @EstadoActual = IdEstado, @EstadoComprobante = EstadoComprobante FROM PEDIDOS WHERE Id = @IdPedido;

    IF @EstadoActual IS NULL
        THROW 50011, 'El pedido no existe', 1;

    -- si otro admin ya lo reviso o el cliente todavia no subio nada
    IF @EstadoComprobante IS NULL OR @EstadoComprobante <> 'Pendiente'
        THROW 50014, 'El comprobante ya fue revisado o no hay comprobante para revisar', 1;

    -- si mientras tanto lo cancelaron ya no se puede pagar
    IF @EstadoActual <> 1
        THROW 50015, 'El pedido ya no esta pendiente de pago', 1;

    BEGIN TRY
        BEGIN TRANSACTION

        UPDATE PEDIDOS SET EstadoComprobante = 'Aceptado', IdEstado = 2 WHERE Id = @IdPedido

        INSERT INTO HISTORIAL_ESTADOS (IdPedido, IdEstado, IdUsuario)
        VALUES (@IdPedido, 2, @IdUsuario)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- rechaza el comprobante, el pedido sigue pendiente de pago y el motivo lo ve el cliente y queda como observacion
CREATE PROCEDURE spRechazarComprobante @IdPedido INT, @IdUsuario INT, @Motivo VARCHAR(400)
AS BEGIN
    DECLARE @EstadoActual INT;
    DECLARE @EstadoComprobante VARCHAR(20);

    SELECT @EstadoActual = IdEstado, @EstadoComprobante = EstadoComprobante FROM PEDIDOS WHERE Id = @IdPedido;

    IF @EstadoActual IS NULL
        THROW 50011, 'El pedido no existe', 1;

    IF @EstadoComprobante IS NULL OR @EstadoComprobante <> 'Pendiente'
        THROW 50014, 'El comprobante ya fue revisado o no hay comprobante para revisar', 1;

    IF @EstadoActual <> 1
        THROW 50015, 'El pedido ya no esta pendiente de pago', 1;

    -- el motivo es obligatorio porque se le manda al cliente por mail
    IF @Motivo IS NULL OR LTRIM(RTRIM(@Motivo)) = ''
        THROW 50016, 'Hay que escribir el motivo del rechazo', 1;

    BEGIN TRY
        BEGIN TRANSACTION

        -- el motivo va en la columna para que lo vea el cliente y tambien queda como observacion para el historial del admin
        UPDATE PEDIDOS SET EstadoComprobante = 'Rechazado', MotivoRechazoComprobante = LTRIM(RTRIM(@Motivo)) WHERE Id = @IdPedido

        INSERT INTO OBSERVACIONES_PEDIDO (IdPedido, IdUsuario, Observacion)
        VALUES (@IdPedido, @IdUsuario, 'Comprobante rechazado. ' + LTRIM(RTRIM(@Motivo)))

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- el cliente sube el comprobante de la transferencia desde mis compras si se lo rechazaron puede subir otro
CREATE PROCEDURE spSubirComprobante @IdPedido INT, @IdUsuario INT, @ComprobanteUrl VARCHAR(500)
AS BEGIN
    DECLARE @EstadoActual INT;
    DECLARE @EstadoComprobante VARCHAR(20);
    DECLARE @RequiereComprobante BIT;

    -- busco el pedido de ese cliente asi nadie le sube un comprobante a un pedido ajeno
    SELECT @EstadoActual = P.IdEstado, @EstadoComprobante = P.EstadoComprobante, @RequiereComprobante = FP.RequiereComprobante
    FROM PEDIDOS P INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id
    WHERE P.Id = @IdPedido AND P.IdUsuario = @IdUsuario;

    IF @EstadoActual IS NULL
        THROW 50018, 'El pedido no existe o no es tuyo', 1;
    IF @EstadoActual <> 1
        THROW 50022, 'Este pedido ya no esta pendiente de pago, no hace falta subir el comprobante', 1;
    IF @RequiereComprobante = 0
        THROW 50023, 'Este pedido no se paga con transferencia, no lleva comprobante', 1;
    -- si ya mando uno tiene que esperar a que la tienda lo revise si se lo rechazaron si puede subir otro
    IF @EstadoComprobante = 'Pendiente'
        THROW 50024, 'Ya mandaste un comprobante y la tienda lo esta revisando', 1;
    IF @ComprobanteUrl IS NULL OR LTRIM(RTRIM(@ComprobanteUrl)) = ''
        THROW 50025, 'No llego el archivo del comprobante', 1;
    -- queda pendiente para la bandeja del admin y se borra el motivo del rechazo anterior
    UPDATE PEDIDOS SET ComprobanteUrl = @ComprobanteUrl, EstadoComprobante = 'Pendiente', MotivoRechazoComprobante = NULL WHERE Id = @IdPedido
END
GO
