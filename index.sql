--Query 1:
CREATE INDEX index _flanzamiento ON publicacion USING btree(fecha_lanzamiento);
CREATE INDEX index_ncategoria ON tiene USING btree(nom_categoria ) ;

--Query 2:
CREATE INDEX index_anholanz ON publicacion USING hash(fecha_lanzamiento);
CREATE INDEX index_precio ON publicacion USING hash(precio);
CREATE INDEX index_fcompra ON compra USING btree(fecha_compra);
CREATE INDEX index_pais ON compra USING hash(pais);

--Query 3:
CREATE INDEX index_fareciente ON biblioteca USING btree( f_act_reciente );
