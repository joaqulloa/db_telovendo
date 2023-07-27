create database telovendo;

use telovendo;

create user 'admintiendatelovendo'@'localhost' identified by '1234';

GRANT ALL PRIVILEGES ON telovendo TO 'admintiendatelovendo'@'localhost';

CREATE TABLE Proveedores (
  id_proveedor INT PRIMARY KEY auto_increment,
  representante_legal VARCHAR(20),
  nombre_corporativo VARCHAR(30),
  telefono1 VARCHAR(20),
  telefono2 VARCHAR(20),
  persona_contacto VARCHAR(20),
  categoria VARCHAR(20),
  correo_facturacion VARCHAR(40)
);

-- Crear la tabla Productos
CREATE TABLE Productos (
  id_producto INT PRIMARY KEY auto_increment,
  nombre VARCHAR(50),
  categoria VARCHAR(30),
  precio varchar(10),
  color VARCHAR(20),
  proveedor varchar(50),
  stock int
);

-- Crear la tabla Clientes
CREATE TABLE Clientes (
  id_cliente INT PRIMARY KEY auto_increment,
  nombre VARCHAR(40),
  apellido VARCHAR(40),
  direccion VARCHAR(100)
);

-- Crear la tabla Proveedor_Producto (relación muchos a muchos)
CREATE TABLE Proveedor_Producto (
  id_proveedor INT,
  id_producto INT,
  FOREIGN KEY (id_proveedor) REFERENCES Proveedores (id_proveedor),
  FOREIGN KEY (id_producto) REFERENCES Productos (id_producto),
  PRIMARY KEY (id_proveedor, id_producto)
);

-- Crear la tabla Cliente_Producto (relación muchos a muchos)
CREATE TABLE Cliente_Producto (
  id_cliente INT,
  id_producto INT,
  FOREIGN KEY (id_cliente) REFERENCES Clientes (id_cliente),
  FOREIGN KEY (id_producto) REFERENCES Productos (id_producto),
  PRIMARY KEY (id_cliente, id_producto)
);

INSERT INTO clientes (nombre, apellido, direccion) 
VALUES 
('Mónica', 'Salgado', 'Calle Los Pinos Aromáticos 655, Santiago'), 
('Domingo', 'González', 'A. Prat #124, La Serena'), 
('Rosa', 'Concha', 'Calle Central #789, Talcahuano'), 
('Margarito', 'López', 'Avenida  Blanco #1852, Ancud'), 
('Pedro', 'Galán', 'Calle 3 Sur #054, Arica');

select * from clientes;

INSERT INTO Proveedores (representante_legal, nombre_corporativo, telefono1, telefono2, persona_contacto, categoria, correo_facturacion) 
VALUES 
('Rodrigo Martínez', 'Amerikan Sound', '+56 521422007',  '+56 521422007', 'Katyuska Moloto', 'Percusión', 'r.martinez@amerikansound.com'), 
('Johnny Rockets', 'Fender', '+56 4514254758',  '+56 4514254760', 'Marina Diamandis', 'Cuerda', 'johnny.rockets@fender.com'),
( 'Mariana Stevenson', 'Royal Piano', '+56 241425498', '+56 241425490', 'Ruth Gonzáles', 'I. Electrónico', 'marstevenson@royalpiano.com'),
('Alejandro Serguis', 'Lolo Guitarras', '+56 65985498', '+56 659625498', 'Julianna Gattas', 'Cuerdas', 'michael@lologuitarras.com'),
( 'Juanita Miranda', 'La ReFlauta', '+56 6598566218',  '+ 56 65933366218', 'Elvis Crespo', 'Viento', 'jmirandar@reflauta.com');

select * from proveedores;

INSERT INTO productos (nombre, categoria, precio, color, proveedor, stock)
VALUES
        ('Saxofón JTS700Q', 'Viento', '189.990', 'dorado', 'La ReFlauta', '5'),
        ('Guitarra FRA95NCET', 'Cuerda', '129.990', 'negro', 'Lolo Guitarras', '15'),
        ('C. Resonancia Blue X6', 'Percusión', '17.990', 'beige', 'Amerikan Sound', '9'),
        ('Launchapad X', 'I. Electrónico', '144.990', 'negro', 'Royal Piano', '10'),
        ('Conga Lp LP826', 'Percusión', '65.990', 'café', 'Amerikan Sound', '4'),
        ('Casio CT-X700', 'I. Electrónico', '279.990', 'negro', 'Royal Piano', '3'),
        ('Guitarra Raimundo 105M', 'Cuerda', '579.990', 'cedro', 'Lolo Guitarras', '2'),
        ('Trombón Bsare 6420L', 'Viento', '239.990', 'dorado', 'La ReFlauta', '3'),
        ('Guitarra Ibánez GA3', 'Cuerda', '169.990', 'blanco', 'Fender', '7'),
        ('Pandero Baldassare', 'Percusión', '12.990', 'rojo', 'Amerikan Sound', '23');

select * from productos;  
      
-- CONSULTAS SQL

-- Cuál es la categoría de productos que más se repite.

SELECT categoria, COUNT(*) AS cantidad
FROM productos
GROUP BY categoria
ORDER BY cantidad DESC
LIMIT 1;

-- Cuáles son los productos con mayor stock

SELECT *
FROM productos
ORDER BY stock DESC
LIMIT 5;

-- Qué color de producto es más común en nuestra tienda.

SELECT color, COUNT(*) AS cantidad
FROM productos
GROUP BY color
ORDER BY cantidad DESC
LIMIT 1;

-- Cual o cuales son los proveedores con menor stock de productos.

SELECT p.id_proveedor, p.nombre_corporativo, SUM(pr.stock) AS total_stock
FROM proveedores p
JOIN productos pr ON p.nombre_corporativo = pr.proveedor
GROUP BY p.id_proveedor, p.nombre_corporativo
ORDER BY total_stock ASC
LIMIT 3;

-- Cambien la categoría de productos más popular por ‘Electrónica y computación’.
UPDATE productos
SET categoria = 'Electrónica y computación'
WHERE categoria = (
    SELECT categoria
    FROM (
        SELECT categoria, COUNT(*) AS cantidad
        FROM productos
        GROUP BY categoria
        ORDER BY cantidad DESC
        LIMIT 1
    ) AS subquery
);