-- Mostrar los productos que tiene un publisher
CREATE OR REPLACE VIEW productos_por_publisher AS (
	SELECT 
	    pu.publisher_id,
	    pr.producto_id,
	    pr.nombre AS producto_nombre
	FROM 
	    publisher pu
	JOIN 
	    publica p ON pu.publisher_id = p.publisher_id
	JOIN 
	    publicacion pub ON p.publicacion_id = pub.publicacion_id
	JOIN 
	    producto pr ON pub.producto_id = pr.producto_id
);

SELECT producto_id, producto_nombre FROM productos_por_publisher WHERE publisher_id = 'PBS0000000004383';
