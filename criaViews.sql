# Views com inner join contemplando DUAS tabelas

# Mostra a matéria e o nome do professor que a leciona
CREATE VIEW MateriasLecionadas AS
SELECT materias.nome AS 'Matéria', professores.nome AS 'Professor'
FROM materias
INNER JOIN professores ON materias.idprofessor = professores.id
ORDER BY materias.nome;


# Mostra o aluno e a média entre todas as suas notas
CREATE VIEW mediaAlunos AS
SELECT a.nome AS 'Aluno', round(avg(n.nota), 2) AS 'Média das Notas'
FROM alunos a
INNER JOIN notas_alunos n ON a.id = n.idaluno
GROUP BY a.nome
ORDER BY a.nome;


# --------------------------------------------
# Views com inner join contemplando TRES tabelas

# Mostra o aluno e a turma que está matriculado
CREATE VIEW AlunosTurmas AS
SELECT alunos.nome AS 'Aluno', turmas.nome AS 'Turma'
FROM ((alunos
INNER JOIN turmas_alunos ON alunos.id = turmas_alunos.idaluno)
INNER JOIN turmas ON turmas.id = turmas_alunos.idturma)
ORDER BY alunos.nome;

# Mostra o nome do professor e seu endereco
CREATE VIEW dadosProfessores AS
SELECT p.nome AS 'Professor', e.pais AS 'País', e.estado AS 'Estado', e.cidade AS 'Cidade', e.cep AS 'CEP'
FROM ((professores p
INNER JOIN enderecos_professores ep ON ep.idprofessor = p.id)
INNER JOIN enderecos e ON ep.idendereco = e.id)
ORDER BY p.nome;


# --------------------------------------------
# Views com inner join contemplando CINCO tabelas

# Mostra o aluno, seu endereco, sua turma
CREATE VIEW dadosAlunos AS
SELECT a.nome AS 'Aluno', e.pais AS 'País', e.estado AS 'Estado', e.cidade AS 'Cidade', e.cep AS 'CEP', t.nome AS 'Turma'
FROM ((((alunos a
INNER JOIN turmas_alunos ta ON ta.idaluno = a.id)
INNER JOIN  turmas t ON ta.idturma = t.id)
INNER JOIN enderecos_alunos ea ON ea.idaluno = a.id)
INNER JOIN enderecos e ON ea.idendereco = e.id)
ORDER BY a.nome;


# -------------------------------------------
# View com LEFT JOIN

# Mostra o professor e a quantidade de materias que ele leciona
CREATE VIEW quantidadeMateriasProfessores AS
SELECT p.nome, count(m.nome) AS 'Quantidade de matérias lecionadas.'
FROM professores p
LEFT JOIN materias m ON m.idprofessor = p.id
GROUP BY p.nome
ORDER BY p.nome;

# ------------------------------------
# View com RIGHT JOIN

# Mostra o endereco e a quantidade de pessoas que moram nele
SELECT e.pais AS 'País', e.estado AS 'Estado', e.cidade AS 'Cidade', e.cep AS 'CEP', count(a.nome) + count(p.nome) AS 'Quantidade Moradores'
FROM ((((professores p
INNER JOIN enderecos_professores ep ON ep.idprofessor = p.id)
RIGHT JOIN enderecos e ON ep.idendereco = e.id)
RIGHT JOIN enderecos_alunos ea ON ea.idendereco = e.id)
INNER JOIN alunos a ON ea.idaluno = a.id)
GROUP BY e.cep;