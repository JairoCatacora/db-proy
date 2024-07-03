-- Triggers

-- Actualizar la promedio de puntuacion de una publicacion
CREATE OR REPLACE FUNCTION actualizar_promedio_puntuacion()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE publicacion
    SET prom_puntuacion = (
		SELECT AVG(calificacion)
        FROM resenha
        WHERE publicacion_id = NEW.publicacion_id
	)
    WHERE publicacion_id = NEW.publicacion_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizacion_promedio
AFTER INSERT ON resenha
FOR EACH ROW
EXECUTE FUNCTION actualizar_promedio_puntuacion();

-- Incrementar el numero de seguidores de un publisher
CREATE OR REPLACE FUNCTION actualizar_n_seguidores()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE publisher
    SET n_seguidores = n_seguidores + 1
    WHERE publisher_id = NEW.publisher_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizacion_seguidores
AFTER INSERT ON sigue
FOR EACH ROW
EXECUTE FUNCTION actualizar_n_seguidores();
