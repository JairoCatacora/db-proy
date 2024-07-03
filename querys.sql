-- Querys

-- Juegos mas vendidos a mitades de anho y categorias especificas
SELECT p.producto_id, pr.nombre AS nombre_producto, COUNT(*) AS cantidad_ventas
FROM adquiere a
JOIN publicacion pub ON a.publicacion_id = pub.publicacion_id
JOIN producto p ON pub.producto_id = p.producto_id
JOIN tiene t ON p.producto_id = t.producto_id
JOIN juego j ON p.producto_id = j.juego_id
JOIN producto pr ON j.juego_id = pr.producto_id
WHERE pub.fecha_lanzamiento BETWEEN '2023-06-15' AND '2023-12-31'
AND t.nom_categoria IN ('RPG', 'Deporte', 'Aventura') 
GROUP BY p.producto_id, pr.nombre
ORDER BY cantidad_ventas DESC
LIMIT 5;

-- Regiones con mayor cantidad de ventas en cierta temporada y filtrados por paises
SELECT a.tienda_region AS region, COUNT(*) AS cantidad_ventas, SUM(pub.precio) AS total_ventas
FROM adquiere a
JOIN compra c ON a.compra_id = c.compra_id
JOIN publicacion pub ON a.publicacion_id = pub.publicacion_id
JOIN producto p ON pub.producto_id = p.producto_id
WHERE c.fecha_compra BETWEEN '2023-09-01' AND '2023-12-31'
AND c.pais IN ('Mexico', 'EEUU', 'Espanha')
GROUP BY a.tienda_region
ORDER BY total_ventas DESC
LIMIT 10;

-- Categorias mas jugadas actualmente
SELECT t.nom_categoria AS categoria, COUNT(DISTINCT b.cliente_id) AS total_jugadores
FROM biblioteca b
JOIN tiene t ON b.producto_id = t.producto_id
JOIN cliente c ON b.cliente_id = c.cliente_id
WHERE b.f_act_reciente BETWEEN '2024-03-01' AND '2024-06-30'
GROUP BY t.nom_categoria
ORDER BY total_jugadores DESC
LIMIT 3;
