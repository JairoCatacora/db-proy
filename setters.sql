-- SETTERS
SET enable_mergejoin to OFF;
SET enable_hashjoin to OFF;
SET enable_bitmapscan to OFF;
SET enable_sort to OFF;

-- Q1
VACUUM FULL adquiere;
VACUUM FULL publicacion;
VACUUM FULL producto;
VACUUM FULL tiene;
VACUUM FULL juego;

-- Q2
VACUUM FULL adquiere;
VACUUM FULL compra;
VACUUM FULL publicacion;
VACUUM FULL producto;

-- Q3
VACUUM FULL biblioteca;
VACUUM FULL tiene;
VACUUM FULL cliente;

-- RESETS
RESET enable_mergejoin;
RESET enable_hashjoin;
RESET enable_bitmapscan;
RESET enable_sort;
