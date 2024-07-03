-- Tables
CREATE TABLE cliente (
    cliente_id VARCHAR(16) PRIMARY KEY,
    fecha_registro DATE NOT NULL,
    username VARCHAR(10) NOT NULL,
    password VARCHAR(10) NOT NULL
);

ALTER TABLE cliente ADD CONSTRAINT valid_cli_id CHECK ( cliente_id LIKE 'CLI%');

--Tabla Compra
CREATE TABLE compra (
     compra_id VARCHAR(16) PRIMARY KEY,
     cliente_id VARCHAR(16) REFERENCES cliente(cliente_id),
     fecha_compra DATE NOT NULL,
     pais VARCHAR(20) NOT NULL
);

ALTER TABLE compra ADD CONSTRAINT valid_com_id CHECK ( cliente_id LIKE 'COM%');

--Tabla Tienda
CREATE TABLE tienda (
    region VARCHAR(20) PRIMARY KEY
);

--Tabla Publisher
CREATE TABLE publisher(
    publisher_id VARCHAR(16) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    n_seguidores SMALLINT NOT NULL DEFAULT 0,
    website VARCHAR(50) NOT NULL
);

ALTER TABLE publisher ADD CONSTRAINT valid_cant_seg CHECK ( n_seguidores >= 0 );
ALTER TABLE publisher ADD CONSTRAINT valid_publ_id CHECK (publisher_id LIKE 'PBS%');

--Tabla Producto
CREATE TABLE producto(
    producto_id VARCHAR(16) PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL ,
    e_necesario FLOAT NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT valid_esp_nec CHECK ( e_necesario > 0 );
--ALTER TABLE producto ADD CONSTRAINT valid_prod_id CHECK ( producto_id LIKE 'PRD%' OR producto_id LIKE 'JG%' OR producto_id LIKE 'D%' ); <-

--Tabla Publicacion
CREATE TABLE publicacion(
    publicacion_id VARCHAR(16) PRIMARY KEY,
    producto_id VARCHAR(16) REFERENCES producto(producto_id),
    descripcion VARCHAR(255) NOT NULL ,
    precio SMALLINT NOT NULL ,
    fecha_lanzamiento DATE NOT NULL ,
    prom_puntuacion FLOAT NOT NULL ,
    porc_oferta SMALLINT NOT NULL
);

ALTER TABLE publicacion ADD CONSTRAINT valid_precio CHECK ( precio > 0 );
ALTER TABLE publicacion ADD CONSTRAINT valid_punt CHECK ( prom_puntuacion >= 0 );
ALTER TABLE publicacion ADD CONSTRAINT valid_oferta CHECK ( publicacion.porc_oferta >= 0 );
ALTER TABLE publicacion ADD CONSTRAINT valid_publ_id CHECK ( publicacion_id LIKE 'PBC%');

--Tabla Categoria
CREATE TABLE categoria(
    nombre VARCHAR(15) PRIMARY KEY
);

--Tabla Juego
CREATE TABLE juego(
    juego_id VARCHAR(16) PRIMARY KEY,
    FOREIGN KEY (juego_id) REFERENCES producto(producto_id)
);

--Tabla DLC
CREATE TABLE dlc(
    dlc_id VARCHAR(16) PRIMARY KEY,
    juego_id VARCHAR(16) REFERENCES juego(juego_id),
    FOREIGN KEY (dlc_id) REFERENCES producto(producto_id)
);

--Tabla Biblioteca
CREATE TABLE biblioteca(
    cliente_id VARCHAR(16),
    producto_id VARCHAR(16),
    f_act_reciente DATE NOT NULL,
    logros SMALLINT NOT NULL,
    h_jugadas FLOAT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id),
	PRIMARY KEY (cliente_id,producto_id)
);

ALTER TABLE biblioteca ADD CONSTRAINT valid_logros CHECK ( logros >= 0 );
ALTER TABLE biblioteca ADD CONSTRAINT valid_h_jug CHECK ( h_jugadas >= 0 );


--Tabla Resenha
CREATE TABLE resenha(
    cliente_id VARCHAR(16),
    publicacion_id VARCHAR(16),
    --producto_id VARCHAR(16) PRIMARY KEY,
    calificacion SMALLINT NOT NULL,
    contenido VARCHAR(255) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
    FOREIGN KEY (publicacion_id) REFERENCES publicacion(publicacion_id),
    --FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
	PRIMARY KEY (cliente_id,publicacion_id)
);

ALTER TABLE resenha ADD CONSTRAINT valid_calif CHECK ( calificacion >= 0 );

--Tabla Publica
CREATE TABLE publica(
    publisher_id VARCHAR(16),
    tienda_region VARCHAR(20),
    publicacion_id VARCHAR(16),
    --producto_id VARCHAR(16) PRIMARY KEY,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (tienda_region) REFERENCES tienda(region),
    FOREIGN KEY (publicacion_id) REFERENCES publicacion(publicacion_id),
    --FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
	PRIMARY KEY (publisher_id,tienda_region,publicacion_id)
);

--Tabla Adquiere
CREATE TABLE adquiere(
    compra_id VARCHAR(16),
    tienda_region VARCHAR(20),
    publicacion_id VARCHAR(16),
    --producto_id VARCHAR(16) PRIMARY KEY,
    FOREIGN KEY (compra_id) REFERENCES compra(compra_id),
    FOREIGN KEY (tienda_region) REFERENCES tienda(region),
    FOREIGN KEY (publicacion_id) REFERENCES publicacion(publicacion_id),
    --FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
	PRIMARY KEY (compra_id,tienda_region,publicacion_id)
);

--Tabla Tiene
CREATE TABLE tiene(
    nom_categoria VARCHAR(15),
    producto_id VARCHAR(16),
    FOREIGN KEY (nom_categoria) REFERENCES categoria(nombre),
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id),
	PRIMARY KEY (nom_categoria,producto_id)
);

CREATE TABLE sigue(
	cliente_id VARCHAR(16),
	publisher_id VARCHAR(16),
	FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
	FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
	PRIMARY KEY (cliente_id,publisher_id)
);
