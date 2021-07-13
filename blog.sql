-- 3er desafío, módulo 5 unidad 3, Postgresql
-- probado en Bash, Fedora 34

-- 1. Crear la base de datos 'blog'
-- $ createdb blog (reemplazar por CREATE DATABASE blog, en el entorno psql)
-- $ psql blog (entrar a la base de datos bajo el entorno psql)

-- 2. Crear las tablas indicadas en el modelo de datos:
CREATE TABLE usuarios(
    id SERIAL PRIMARY KEY,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE posts(
    id SERIAL PRIMARY KEY,
    usuario_id SMALLINT NOT NULL REFERENCES usuarios(id),
    titulo VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL
);

CREATE TABLE comentarios(
    id SERIAL PRIMARY KEY,
    usuario_id SMALLINT NOT NULL REFERENCES usuarios(id),
    post_id SMALLINT NOT NULL REFERENCES posts(id),
    texto VARCHAR(100) NOT NULL,
    fecha DATE
);
-- \d+   --para verificar la correcta creacion de las tablas

-- 3. Insertar los registros:
INSERT INTO usuarios(email)
    VALUES
        ('usuario01@hotmail.com'),
        ('usuario02@gmail.com'),
        ('usuario03@gmail.com'),
        ('usuario04@hotmail.com'),
        ('usuario05@yahoo.com'),
        ('usuario06@hotmail.com'),
        ('usuario07@yahoo.com'),
        ('usuario08@yahoo.com'),
        ('usuario09@yahoo.com')
RETURNING *; --para verificar correcta inserción de registros en cada tabla

INSERT INTO posts(usuario_id, titulo, fecha)
    VALUES
        (1, 'Post 1: Esto es malo', '2020-06-29'),
        (5, 'Post 2: Esto es malo', '2020-06-20'),
        (1, 'Post 3: Esto es excelente', '2020-05-30'),
        (9, 'Post 4: Esto es bueno', '2020-05-09'),
        (7, 'Post 5: Esto es bueno', '2020-07-10'),
        (5, 'Post 6: Esto es excelente', '2020-07-18'),
        (8, 'Post 7: Esto es excelente', '2020-07-07'),
        (5, 'Post 8: Esto es excelente', '2020-05-14'),
        (2, 'Post 9: Esto es bueno', '2020-05-08'),
        (6, 'Post 10: Esto es bueno', '2020-06-02'),
        (4, 'Post 11: Esto es bueno', '2020-05-05'),
        (9, 'Post 12: Esto es malo', '2020-07-23'),
        (5, 'Post 13: Esto es excelente', '2020-05-30'),
        (8, 'Post 14: Esto es excelente', '2020-05-01'),
        (7, 'Post 15: Esto es malo', '2020-06-17')
RETURNING *;

INSERT INTO comentarios(usuario_id, post_id, texto, fecha)
    VALUES
        (3, 6, 'Este es el comentario 1', '2020-07-08'),
        (4, 2, 'Este es el comentario 2', '2020-06-07'),
        (6, 4, 'Este es el comentario 3', '2020-06-16'),
        (2, 13, 'Este es el comentario 4', '2020-06-15'),
        (6, 6, 'Este es el comentario 5', '2020-05-14'),
        (3, 3, 'Este es el comentario 6', '2020-07-08'),
        (6, 1, 'Este es el comentario 7', '2020-05-22'),
        (6, 7, 'Este es el comentario 8', '2020-07-09'),
        (8, 13, 'Este es el comentario 9', '2020-06-30'),
        (8, 6, 'Este es el comentario 10', '2020-06-19'),
        (5, 1, 'Este es el comentario 11', '2020-05-09'),
        (8, 15, 'Este es el comentario 12', '2020-06-17'),
        (1, 9, 'Este es el comentario 13', '2020-05-01'),
        (2, 5, 'Este es el comentario 14', '2020-05-31'),
        (4, 3, 'Este es el comentario 15', '2020-06-28')
RETURNING *;

-- 4. Seleccionar el correo, id y titulo de todos los posts publicados por el usuario 5.
SELECT email, usuarios.id, titulo 
FROM usuarios JOIN posts 
ON usuarios.id = posts.usuario_id
WHERE usuarios.id = 5;

-- 5. Listar el correo, id, y el detalle de todos los comentarios que no hayan sido 
--    realizados por el usuario con email usuario06@hotmail.com.
SELECT usuarios.id AS id_usuario, 
email, comentarios.id AS id_comentario, 
post_id, texto, fecha 
FROM usuarios JOIN comentarios
ON usuarios.id = comentarios.usuario_id
WHERE usuarios.email != 'usuario06@hotmail.com'
ORDER BY usuarios.email ASC;

-- 6. Listar todos los usuarios que no han publicado ningún post.
SELECT usuarios.id, usuarios.email 
FROM usuarios LEFT JOIN posts
ON usuarios.id = posts.usuario_id
WHERE posts.usuario_id IS NULL;

-- 7. Listar todos los posts con sus comentarios (incluyendo los que no poseen comentarios).
SELECT * 
FROM posts FULL OUTER JOIN comentarios
ON posts.id = comentarios.post_id
ORDER BY posts.id ASC;

-- 8. Listar todos los usuarios que hayan publicado un post en Junio.
SELECT usuarios.id, email, fecha
FROM usuarios INNER JOIN posts
ON usuarios.id = posts.usuario_id
WHERE posts.fecha BETWEEN '2020-06-01' AND '2020-06-30';

