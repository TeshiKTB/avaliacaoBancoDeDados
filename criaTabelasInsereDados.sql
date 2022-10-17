CREATE TABLE IF NOT EXISTS alunos(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    nascimento DATE
);

CREATE TABLE IF NOT EXISTS professores(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    nascimento DATE
);

CREATE TABLE IF NOT EXISTS enderecos(
	id INT PRIMARY KEY AUTO_INCREMENT,
    pais VARCHAR(30) DEFAULT 'Brasil',
    estado VARCHAR(2),
    cidade VARCHAR(30),
    cep VARCHAR(30),
);

CREATE TABLE IF NOT EXISTS enderecos_alunos(
	idaluno INT,
    idendereco INT,
    CONSTRAINT FOREIGN KEY(idaluno) REFERENCES alunos(id),
    CONSTRAINT FOREIGN KEY(idendereco) REFERENCES enderecos(id)
);

CREATE TABLE IF NOT EXISTS enderecos_professores(
	idprofessor INT,
    idendereco INT,
    CONSTRAINT FOREIGN KEY(idprofessor) REFERENCES professores(id),
    CONSTRAINT FOREIGN KEY(idendereco) REFERENCES enderecos(id)
);

CREATE TABLE IF NOT EXISTS materias(
	codigo INT PRIMARY KEY AUTO_INCREMENT,
    idprofessor INT,
    nome VARCHAR(50),
    CONSTRAINT FOREIGN KEY(idprofessor) REFERENCES professores(id)
);

CREATE TABLE IF NOT EXISTS turmas(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(2),
    turno VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS turmas_alunos(
	idaluno INT,
    idturma INT,
    CONSTRAINT FOREIGN KEY(idaluno) REFERENCES alunos(id),
    CONSTRAINT FOREIGN KEY(idturma) REFERENCES turmas(id),
    PRIMARY KEY(idaluno, idturma)
);

CREATE TABLE IF NOT EXISTS notas_alunos(
	idaluno INT,
    codigomateria INT,
    nota DOUBLE DEFAULT 0,
    CONSTRAINT FOREIGN KEY(idaluno) REFERENCES alunos(id),
    CONSTRAINT FOREIGN KEY(codigomateria) REFERENCES materias(codigo)
);


INSERT INTO alunos(nome, nascimento) VALUES
	('João Silva', '2005-05-21'),
    ('João Dutra', '2005-07-23'),
    ('Caio Dutra', '2004-03-14'),
    ('Flavin du Pneu', '2006-08-18'),
    ('Xiaolin Matador de Porco', '2006-12-02'),
    ('Lucas Porto', '2003-09-10'),
    ('Rie Takahashi', '2005-10-23'),
    ('Maria Debe', '2003-11-05'),
    ('Flavia Sayuri', '2004-01-09'),
    ('Juliana Brás', '2002-12-31');
    
INSERT INTO enderecos(estado, cidade, cep) VALUES
	('DF', 'Brasilia', '50403-020'),
    ('SC', 'Blumenau', '51413-121'),
    ('BA', 'Salvador', '52423-222'),
    ('SP', 'São Paulo', '53433-323'),
    ('SC', 'Pomerode', '54443-424'),
    ('SP', 'Campinas', '55453-525'),
    ('RJ', 'Rio de Janeiro', '56463-626'),
    ('RJ', 'Niterói', '57473-727'),
    ('AM', 'Manaus', '58483-828'),
    ('MG', 'Belo Horizonte', '59493-929'),
    ('SP', 'Guarulhos', '60504-030');

INSERT INTO enderecos_alunos(idaluno, idendereco) VALUES
	(1, 3),
    (2, 2),
    (3, 2),
    (4, 1),
    (5, 4),
    (6, 10),
    (7, 9),
    (8, 8),
    (9, 7),
    (10, 6);
    
INSERT INTO professores(nome, nascimento) VALUES
	('Juracy', '2000-02-02'),
    ('Claudio', '1980-01-30'),
    ('Aline', '1999-07-19'),
    ('Maria', '1997-06-09'),
    ('Clara', '1989-01-02'),
    ('Maria', '2001-01-06'),
    ('Ana', '1995-07-20'),
    ('Jubilut', '1990-10-10'),
    ('Ferrarezi', '1995-08-08'),
    ('Pedro', '2000-08-09');
    
INSERT INTO enderecos_professores(idprofessor, idendereco) VALUES
	(1, 10),
    (2, 5),
    (3, 5),
    (4, 10),
    (5, 3),
    (6, 8),
    (7, 9),
    (8, 9),
    (9, 4),
    (10, 7);
    

ALTER TABLE notas_alunos ADD CONSTRAINT PRIMARY KEY(idaluno, codigomateria);
    
INSERT INTO materias(idprofessor, nome) VALUES
	(2, 'Português'),
    (1, 'Filosofia'),
    (1, 'Sociologia'),
    (3, 'Inglês'),
    (9, 'Matemática'),
    (9, 'Física'),
    (9, 'Química'),
    (8, 'Biologia'),
    (7, 'Atualidades'),
    (6, 'Literatura');
    
INSERT INTO notas_alunos(idaluno, codigomateria, nota) VALUES
	(1, 1, 2),
    (1, 2, 4),
    (1, 3, 10),
    (1, 4, 10),
    (1, 5, 10),
    (1, 6, 5),
    (1, 7, 9),
    (1, 8, 10),
    (1, 9, 0),
    (1, 10, 0),
    (2, 1, 0),
    (2, 2, 2),
    (2, 3, 4),
    (2, 4, 5),
    (2, 5, 1),
    (2, 6, 7),
    (2, 7, 10),
    (2, 8, 10),
    (2, 9, 1),
    (2, 10, 4),
    (3, 1, 1),
    (3, 2, 1),
    (3, 3, 4),
    (3, 4, 3),
    (3, 5, 5),
    (3, 6, 10),
    (3, 7, 10),
    (3, 8, 9),
    (3, 9, 1),
    (3, 10, 0),
    (4, 1, 0),
    (4, 2, 3),
    (4, 3, 10),
    (4, 4, 1),
    (4, 5, 0),
    (4, 6, 10),
    (4, 7, 9),
    (4, 8, 10),
    (4, 9 , 9),
    (4, 10, 8),
    (5, 1, 5);

INSERT INTO notas_alunos(idaluno, codigomateria, nota) VALUES
    (5, 2, 3),
    (5, 3, 9.8),
    (5, 4, 8),
    (5, 5, 6.5),
    (5, 6, 7),
    (5, 7, 9),
    (5, 8, 9.1),
    (5, 9, 4),
    (5, 10, 1.1),
    (6, 1, 9),
    (6, 2, 4),
    (6, 3, 5.5),
    (6, 4, 4),
    (6, 5, 6.3),
    (6, 6, 7.2),
    (6, 7, 8),
    (6, 8, 10),
    (6, 9, 1),
    (6, 10, 0),
    (7, 1, 0),
    (7, 2, 0.2),
    (7, 3, 0),
    (7, 4, 1.4),
    (7, 5, 2.1),
    (7, 6, 0),
    (7, 7, 0.9),
    (7, 8, 1),
    (7, 9, 5),
    (7, 10, 3),
    (8, 1, 0),
    (8, 2, 10),
    (8, 3, 10),
    (8, 4, 10),
    (8, 5, 3),
    (8, 6, 10),
    (8, 7, 10),
    (8, 8, 9.5),
    (8, 9, 0);

INSERT INTO notas_alunos(idaluno, codigomateria, nota) VALUES
    (8, 10, 5.5),
    (9, 1, 9),
    (9, 2, 9.1),
    (9, 3, 6.6),
    (9, 4, 10),
    (9, 5, 1),
    (9, 6, 3),
    (9, 7, 8),
    (9, 8, 1),
    (9, 9, 10),
    (9, 10, 10),
    (10, 1, 10),
    (10, 2, 10),
    (10, 3, 10),
    (10, 4, 10),
    (10, 5, 10),
    (10, 6, 10),
    (10, 7, 10),
    (10, 8, 10),
    (10, 9, 10),
    (10, 10, 10);
    
INSERT INTO turmas(nome, turno) VALUES
	('1A', 'MATUTINO'),
    ('1B', 'MATUTINO'),
    ('1C', 'VESPERTINO'),
    ('1D', 'VESPERTINO'),
    ('2A', 'MATUTINO'),
    ('2B', 'VESPERTINO'),
    ('3A', 'MATUTINO'),
    ('3B', 'VESPERTINO'),
    ('3C', 'VESPERTINO'),
    ('3D', 'VESPERTINO');
    
INSERT INTO turmas_alunos(idaluno, idturma) VALUES
	(1, 1),
    (2, 1),
    (3, 10),
    (4, 10),
    (5, 10),
    (6, 9),
    (7, 9),
    (8, 3),
    (9, 5),
    (10, 2);
    