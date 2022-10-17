

# Mostra os alunos cujo nome começa com 'T'
SELECT nome FROM alunos WHERE nome LIKE 'T%';


# Mostra o professor mais novo cadastrado
SELECT nome from professores WHERE datediff(now(), nascimento) = (SELECT min(datediff(now(), nascimento)) FROM professores);


# Mostra o aluno mais velho
SELECT nome FROM alunos WHERE datediff(now(), nascimento) = (SELECT max(datediff(now(), nascimento)) FROM alunos);


# Mostra os professores que ensinam duas ou mais materias
SELECT professores.nome FROM professores
INNER JOIN materias ON materias.idprofessor = professores.id
GROUP BY professores.nome
HAVING count(materias.nome) > 1;


# Mostra o nome do aluno, o nome da materia e se o aluno reprovou ou nao na materia
SELECT a.nome AS 'Aluno', m.nome AS 'Matéria', IF(na.nota >= 7, 'Aprovado!', 'Reprovado.')
FROM alunos a, materias m, notas_alunos na
WHERE a.id = na.idaluno AND m.codigo = na.codigomateria
ORDER BY a.nome;