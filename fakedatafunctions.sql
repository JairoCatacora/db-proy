-- Fake Data Functions

CREATE SEQUENCE cliente_seq START 1;

CREATE OR REPLACE FUNCTION generar_clientes(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        INSERT INTO cliente (cliente_id, fecha_registro, username, password)
        VALUES (
            'CLI' || LPAD(nextval('cliente_seq')::TEXT, 13, '0'),
            NOW() - (RANDOM() * 365)::INT * INTERVAL '1 day',
            'user' || i,
            'pass' || i
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_compras(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        INSERT INTO compra (compra_id, cliente_id, fecha_compra, pais)
        VALUES (
            'COM' || LPAD(i::TEXT, 13, '0'),
            (SELECT cliente_id FROM cliente ORDER BY RANDOM() LIMIT 1),
            NOW() - (RANDOM() * 365)::INT * INTERVAL '1 day',
            'Pais' || (RANDOM() * 100)::INT
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_tiendas(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        INSERT INTO tienda (region)
        VALUES (
            'Region' || LPAD(i::TEXT, 3, '0')
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_publishers(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        INSERT INTO publisher (publisher_id, nombre, n_seguidores, website)
        VALUES (
            'PBS' || LPAD(i::TEXT, 13, '0'),
            'Publisher' || i,
            (RANDOM() * 1000)::INT,
            'http://www.publisher' || i || '.com'
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_productos(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        INSERT INTO producto (producto_id, nombre, e_necesario)
        VALUES (
            'PRD' || LPAD(i::TEXT, 13, '0'),
            'Producto' || i,
            (RANDOM() * 10 + 1)::FLOAT
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_publicaciones(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        INSERT INTO publicacion (publicacion_id, producto_id, descripcion, precio, fecha_lanzamiento, prom_puntuacion, porc_oferta)
        VALUES (
            'PBC' || LPAD(i::TEXT, 13, '0'),
            (SELECT producto_id FROM producto ORDER BY RANDOM() LIMIT 1),
            'Descripción de la publicación ' || i,
            (RANDOM() * 100)::SMALLINT + 1,
            NOW() - (RANDOM() * 365)::INT * INTERVAL '1 day',
            (RANDOM() * 5)::FLOAT,
            (RANDOM() * 100)::SMALLINT
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_categorias() RETURNS VOID AS $$
BEGIN
    INSERT INTO categoria (nombre) VALUES
    ('Accion'),
    ('Aventura'),
    ('Deporte'),
    ('Simulacion'),
	('Rol'), 
	('Carreras'), 
	('Indie'), 
	('Puzles'), 
	('Terror'), 
	('Lucha'), 
	('Shooter'), 
	('Arcade'), 
	('MMORPG'), 
	('Mundo abierto'), 
	('Battle Royale'),
	('Survival'), 
	('Visual Novels'), 
	('RPG'), 
	('Un Jugador'),
    ('Estrategia');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_juegos(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    p_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
        LOOP
            SELECT producto_id INTO p_id
            FROM producto
            ORDER BY RANDOM()
            LIMIT 1;
            
            EXIT WHEN NOT EXISTS (SELECT 1 FROM juego WHERE juego_id = p_id);
        END LOOP;
        
        INSERT INTO juego (juego_id)
        VALUES (p_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_dlcs(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    p_id VARCHAR(16);
    j_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
        LOOP
            SELECT producto_id INTO p_id
            FROM producto
            ORDER BY RANDOM()
            LIMIT 1;
            
            SELECT juego_id INTO j_id
            FROM juego
            ORDER BY RANDOM()
            LIMIT 1;
            
            EXIT WHEN NOT EXISTS (SELECT 1 FROM dlc WHERE dlc_id = p_id);
        END LOOP;
        
        INSERT INTO dlc (dlc_id, juego_id)
        VALUES (p_id, j_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_bibliotecas(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    cliente_id VARCHAR(16);
    producto_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
        LOOP
            SELECT c.cliente_id, p.producto_id
            INTO cliente_id, producto_id
            FROM cliente c, producto p
            WHERE NOT EXISTS (
                SELECT 1
                FROM biblioteca b
                WHERE b.cliente_id = c.cliente_id
                AND b.producto_id = p.producto_id
            )
            ORDER BY RANDOM()
            LIMIT 1;

            EXIT WHEN cliente_id IS NOT NULL AND producto_id IS NOT NULL;

        END LOOP;

        INSERT INTO biblioteca (cliente_id, producto_id, f_act_reciente, logros, h_jugadas)
        VALUES (
            cliente_id,
            producto_id,
            NOW() - (RANDOM() * 365)::INT * INTERVAL '1 day',
            (RANDOM() * 100)::SMALLINT,
            (RANDOM() * 1000)::FLOAT
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_resenhas(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    cliente_id VARCHAR(16);
    publicacion_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
        LOOP
            SELECT c.cliente_id, p.publicacion_id
            INTO cliente_id, publicacion_id
            FROM cliente c, publicacion p
            WHERE NOT EXISTS (
                SELECT 1
                FROM resenha r
                WHERE r.cliente_id = c.cliente_id
                AND r.publicacion_id = p.publicacion_id
            )
            ORDER BY RANDOM()
            LIMIT 1;

            EXIT WHEN cliente_id IS NOT NULL AND publicacion_id IS NOT NULL;

        END LOOP;

        INSERT INTO resenha (cliente_id, publicacion_id, calificacion, contenido)
        VALUES (
            cliente_id,
            publicacion_id,
            (RANDOM() * 5)::SMALLINT,
            'Contenido de la reseña ' || i
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generar_publica(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    publ_id VARCHAR(16);
    tienda_region VARCHAR(20);
    pub_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
    	LOOP    
        SELECT publisher_id
        INTO publ_id
        FROM publisher
        ORDER BY RANDOM()
        LIMIT 1;
        
        SELECT region
        INTO tienda_region
        FROM tienda
        ORDER BY RANDOM()
        LIMIT 1;
        
        SELECT publicacion_id
        INTO pub_id
        FROM publicacion
        ORDER BY RANDOM()
        LIMIT 1;
        
        EXIT WHEN publ_id IS NOT NULL AND tienda_region IS NOT NULL AND pub_id IS NOT NULL;
        END LOOP;
        INSERT INTO publica (publisher_id, tienda_region, publicacion_id)
            VALUES (publ_id, tienda_region, pub_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generar_adquiere(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    v_compra_id VARCHAR(16);
    v_tienda_region VARCHAR(20);
    v_publicacion_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
        SELECT compra_id
        INTO v_compra_id
        FROM compra
        ORDER BY RANDOM()
        LIMIT 1;

        SELECT region
        INTO v_tienda_region
        FROM tienda
        ORDER BY RANDOM()
        LIMIT 1;

        SELECT publicacion_id
        INTO v_publicacion_id
        FROM publicacion
        ORDER BY RANDOM()
        LIMIT 1;

        IF v_compra_id IS NOT NULL AND v_tienda_region IS NOT NULL AND v_publicacion_id IS NOT NULL THEN
            INSERT INTO adquiere (compra_id, tienda_region, publicacion_id)
            VALUES (v_compra_id, v_tienda_region, v_publicacion_id);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generar_tiene(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    v_categoria_nombre VARCHAR(50);
    v_producto_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
        SELECT c.nombre, p.producto_id
        INTO v_categoria_nombre, v_producto_id
        FROM categoria c
        CROSS JOIN LATERAL (
            SELECT producto_id FROM producto ORDER BY RANDOM() LIMIT 1
        ) p
        WHERE NOT EXISTS (
            SELECT 1
            FROM tiene t
            WHERE t.nom_categoria = c.nombre
            AND t.producto_id = p.producto_id
        )
        LIMIT 1;

        IF v_categoria_nombre IS NOT NULL AND v_producto_id IS NOT NULL THEN
            INSERT INTO tiene (nom_categoria, producto_id)
            VALUES (v_categoria_nombre, v_producto_id);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generar_sigue(n INT) RETURNS VOID AS $$
DECLARE
    i INT;
    v_cliente_id VARCHAR(16);
    v_publisher_id VARCHAR(16);
BEGIN
    FOR i IN 1..n LOOP
        SELECT c.cliente_id, p.publisher_id
        INTO v_cliente_id, v_publisher_id
        FROM cliente c
        CROSS JOIN LATERAL (
            SELECT publisher_id FROM publisher ORDER BY RANDOM() LIMIT 1
        ) p
        WHERE NOT EXISTS (
            SELECT 1
            FROM sigue s
            WHERE s.cliente_id = c.cliente_id
            AND s.publisher_id = p.publisher_id
        )
        LIMIT 1;

        IF v_cliente_id IS NOT NULL AND v_publisher_id IS NOT NULL THEN
            INSERT INTO sigue (cliente_id, publisher_id)
            VALUES (v_cliente_id, v_publisher_id);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


SELECT generar_clientes(300);
SELECT generar_compras(1000);
SELECT generar_tiendas(75);
SELECT generar_publishers(100);
SELECT generar_productos(350);
SELECT generar_publicaciones(1000);
SELECT generar_categorias();
SELECT generar_juegos(250);
SELECT generar_dlcs(100);
SELECT generar_bibliotecas(1000);
SELECT generar_resenhas(500);
SELECT generar_publica(750);
SELECT generar_adquiere(1000);
SELECT generar_tiene(1000);
SELECT generar_sigue(750);