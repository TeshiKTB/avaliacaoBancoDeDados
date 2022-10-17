# Procedures para a tabela de alunos



DELIMITER $$
# O nome deve ter pelo menos 3 letras e deve ter um espaco " " para separar nome e sobrenome
# O aluno deve ter pelo menos 5 anos de idade.
# Nao deve haver dois ou mais aluno com mesmo nome e mesma data de nascimento cadastrados
CREATE PROCEDURE cadastra_aluno( IN pNome VARCHAR(50), IN pNascimento DATE )
proc: BEGIN
	IF pNome IS NULL OR length(pNome) < 3 THEN
		SELECT "O nome deve ter ao menos 3 caracteres";
        LEAVE proc;
	END IF;
    
    IF length(pNome) - length(replace(pNome, " ", "")) = 0 THEN
		SELECT 'O nome deve conter um sobrenome separado por espaco (" ")';
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM alunos WHERE nome = pNome AND nascimento = pNascimento) THEN
		SELECT 'Já existe um aluno cadastrado com esse nome e essa data de nascimento';
        LEAVE proc;
	END IF;
    
    IF datediff(now(), pNascimento) < 5 * 365 THEN
		SELECT 'Data de nascimento inválida. O aluno deve ter no mínimo 5 anos de idade.';
        LEAVE proc;
	END IF;
    
	INSERT INTO alunos(nome, nascimento) VALUES(pNome, pNascimento);
    SELECT 'Aluno cadastrado com sucesso!';
END $$


# Troca o nome de um aluno.
# Localiza esse aluno pelo seu nome e pela sua data de nascimento.
CREATE PROCEDURE muda_nome_aluno( IN nome_antigo VARCHAR(50), IN nome_novo VARCHAR(50), IN pNascimento DATE )
proc: BEGIN
	IF nome_novo IS NULL OR length(nome_novo) < 3 THEN
		SELECT "O nome deve ter ao menos 3 caracteres";
        LEAVE proc;
	END IF;
    
    IF length(nome_novo) - length(replace(nome_novo, " ", "")) = 0 THEN
		SELECT 'O nome deve conter um sobrenome separado por espaco (" ")';
        LEAVE proc;
	END IF;
    
    IF NOT EXISTS (SELECT * FROM alunos WHERE nome = nome_antigo AND nascimento = pNascimento) THEN
		SELECT concat('Aluno ', nome_antigo, ' não foi encontrado.');
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM alunos WHERE nome = nome_novo AND nascimento = pNascimento) THEN
		SELECT 'Já existe um aluno cadastrado com esse nome e data de nascimento.';
        LEAVE proc;
	END IF;
    
    UPDATE alunos SET nome = nome_novo WHERE nome = nome_antigo AND nascimento = pNascimento;
    SELECT 'Nome alterado com sucesso!';
END $$


# Deleta um aluno, localiza este pelo seu nome e sua data de nascimento
CREATE PROCEDURE deleta_aluno( IN pNome VARCHAR(50), IN pNascimento DATE )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM alunos WHERE nome = pNome AND nascimento = pNascimento) THEN
		SELECT 'Aluno não encontrado';
        LEAVE proc;
	END IF;
    
    DELETE FROM alunos WHERE nome = pNome and nascimento = pNascimento;
    SELECT 'Aluno deletado com sucesso!';
END $$
DELIMITER ;



# Procedures para a tabela de professores


DELIMITER $$

# O professor deve ter no mínimo 18 anos
# Nao deve haver dois ou mais professores com o mesmo nome e mesma data de nascimento
CREATE PROCEDURE cadastra_professor( IN pNome VARCHAR(50), IN pNascimento DATE )
proc: BEGIN
	IF length(pNome) < 3 OR pNome IS NULL THEN
		SELECT 'O nome deve ter no mínimo 3 caracteres.';
        LEAVE proc;
    END IF;
    
    IF EXISTS (SELECT * FROM professores WHERE nome = pNome AND nascimento = pNascimento) THEN
		SELECT 'Já existe um professor cadastrado com esse nome e essa data de nascimento.';
        LEAVE proc;
	END IF;
    
    IF datediff(now(), pNascimento) < 18 * 365 THEN
		SELECT 'O professor deve ter no mínimo 18 anos.';
        LEAVE proc;
	END IF;
    
    INSERT INTO professores(nome, nascimento) VALUES(pNome, pNascimento);
    SELECT 'Professor cadastrado com sucesso!';
END $$



CREATE PROCEDURE muda_nome_professor( IN nome_antigo VARCHAR(50), IN nome_novo VARCHAR(50), IN pNascimento DATE)
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM professores WHERE nome = nome_antigo AND nascimento = pNascimento) THEN
		SELECT 'Professor não encontrado.';
        LEAVE proc;
	END IF;
    
    IF nome_novo IS NULL OR length(nome_novo) < 3 THEN
		SELECT 'O nome novo deve ter no mínimo 3 caracteres.';
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM professores WHERE nome = nome_novo AND nascimento = pNascimento) THEN
		SELECT 'Já existe um professor cadastrado com esses dados.';
        LEAVE proc;
	END IF;
    
    UPDATE professores SET nome = nome_novo WHERE nome = nome_antigo AND nascimento = pNascimento;
    SELECT 'Nome alterado com sucesso.';
END $$


CREATE PROCEDURE deleta_professor( IN pNome VARCHAR(50), IN pNascimento DATE )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM professores WHERE nome = pNome AND nascimento = pNascimento) THEN
		SELECT 'Professor não encontrado.';
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM materias INNER JOIN professores ON professores.id = materias.idprofessor
					AND materias.idprofessor = (SELECT id FROM professores WHERE nome = pNome AND nascimento = pNascimento)) THEN
		SELECT 'Ainda há matérias cadastradas com o professor. Por favor, exclua-as antes de excluir o professor.';
        LEAVE proc;
	END IF;
    
    DELETE FROM professores WHERE nome = pNome AND nascimento = pNascimento;
    SELECT 'Professor deletado com sucesso!';
END $$
DELIMITER ;




# Procedures relacionadas a tabela materias

DELIMITER $$

# CADASTRA UMA MATERIA
# O NOME DA MATERIA NAO DEVE TER 2 OU MAIS CARACTERES
# A MATERIA DEVE OBRIGATORIAMENTE TER UM PROFESSOR CADASTRADO
CREATE PROCEDURE cadastra_materia( IN nome_professor VARCHAR(50), IN nascimento_professor DATE, IN nome_materia VARCHAR(50) )
proc: BEGIN
	DECLARE pIdProfessor INT;

	IF nome_materia IS NULL OR length(nome_materia) < 2 THEN
		SELECT 'O nome da matéria deve ter no mínimo dois caracteres.';
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM materias WHERE nome = nome_materia) THEN
		SELECT 'Já existe uma matéria cadastrada com esse nome.';
        LEAVE proc;
	END IF;
    
	IF NOT EXISTS (SELECT * FROM professores WHERE nome = nome_professor AND nascimento = nascimento_professor) THEN
		SELECT 'Professor não encontrado.';
        LEAVE proc;
	END IF;
    
    SET pIdProfessor = (SELECT id FROM professores WHERE nome = nome_professor AND nascimento = nascimento_professor);
    INSERT INTO materias(idprofessor, nome) VALUES(pIdProfessor, nome_materia);
    SELECT 'Matéria cadastrada com sucesso!';
END $$


CREATE PROCEDURE muda_nome_materia( IN nome_antigo VARCHAR(50), IN nome_novo VARCHAR(50) )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM materias WHERE nome = nome_antigo) THEN
		SELECT 'Matéria não encontrada.';
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM materias WHERE nome = nome_novo) THEN
		SELECT 'Já existe uma matéria cadastrada com esse nome.';
        LEAVE proc;
	END IF;
    
    UPDATE materias SET nome = nome_novo WHERE nome = nome_antigo;
    SELECT 'Nome trocado com sucesso!';
END $$

CREATE PROCEDURE muda_professor_materia( IN nome_materia VARCHAR(50), IN nome_professor VARCHAR(50), IN nascimento_professor DATE)
proc: BEGIN
	DECLARE pIdProfessor INT;
    
	IF NOT EXISTS (SELECT * FROM materias WHERE nome = nome_materia) THEN
		SELECT 'Matéria não encontrada.';
        LEAVE proc;
	END IF;
    
    IF NOT EXISTS (SELECT * FROM professores WHERE nome = nome_professor AND nascimento = nascimento_professor) THEN
		SELECT 'Professor não encontrado.';
        LEAVE proc;
    END IF;
    
    SET pIdProfessor = (SELECT id from professores WHERE nome= nome_professor AND nascimento = nascimento_professor);
    
    UPDATE materias SET idprofessor = pIdProfessor WHERE nome = nome_materia;
    SELECT 'Professor trocado com sucesso!.';
END $$


CREATE PROCEDURE deleta_materia( IN nome_materia VARCHAR(50) )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM materias WHERE nome = nome_materia) THEN
		SELECT 'Matéria não encontrada.';
        LEAVE proc;
	END IF;
    
    DELETE FROM materias WHERE nome = nome_materia;
    SELECT 'Matéria deletada com sucesso!';
END $$
DELIMITER ;




# PROCEDURES RELACIONADAS A TABELA ENDERECOS

DELIMITER $$
# O CEP EH UNICO PARA CADA ENDERECO
# O CEP PODE CONTER OU NAO UM '-'
# O CEP DEVE TER MENOS DE 20 CARACTERES E MAIS DE 5 CARACTERES
CREATE PROCEDURE cadastra_endereco( IN pPais VARCHAR(30), IN pEstado VARCHAR(2), IN pCidade VARCHAR(30), IN pCep VARCHAR(30) )
proc: BEGIN
	IF pPais IS NULL THEN
		SELECT 'Insira um país válido.';
        LEAVE proc;
	END IF;
    
    IF pEstado IS NULL OR length(pEstado) != 2 THEN
		SELECT 'Insira um estado válido.';
        LEAVE proc;
	END IF;
    
    IF pCidade IS NULL OR length(pCidade) < 2 THEN
		SELECT 'Insira uma cidade válida.';
        LEAVE proc;
	END IF;
    
    IF pCep IS NULL OR length(pCep) < 5 OR length(pCep) > 30 THEN
		SELECT 'Insira um CEP válido.';
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM enderecos WHERE cep = pCep) THEN
		SELECT 'Já existe um endereco cadastrado para esse cep.';
        LEAVE proc;
	END IF;
    
    INSERT INTO enderecos(pais, estado, cidade, cep) VALUES(pPais, pEstado, pCidade, pCep);
    SELECT 'Endereco cadastrado com sucesso!';
END $$


CREATE PROCEDURE muda_cep_endereco( IN cep_antigo VARCHAR(50), IN cep_novo VARCHAR(50) )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM enderecos WHERE cep = cep_antigo) THEN
		SELECT 'Endereço não encontrado.';
        LEAVE proc;
	END IF;
    
    IF cep_novo IS NULL OR length(cep_novo) NOT BETWEEN 5 AND 30 THEN
		SELECT 'CEP inválido.';
        LEAVE proc;
    END IF;
    
    IF EXISTS (SELECT * FROM enderecos WHERE cep = cep_novo) THEN
		SELECT 'CEP já cadastrado.';
        LEAVE proc;
	END IF;
    
	UPDATE enderecos SET cep = cep_novo WHERE cep = cep_antigo;
    SELECT 'CEP mudado com sucesso!';
END $$


CREATE PROCEDURE deleta_endereco( IN pCep VARCHAR(50) )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM enderecos WHERE cep = pCep) THEN
		SELECT 'Endereco não encontrado.';
        LEAVE proc;
	END IF;
    
    DELETE FROM enderecos WHERE cep = pCep;
    SELECT 'Endereço deletado com sucesso!';
END $$


CREATE PROCEDURE altera_endereco_aluno( IN nome_aluno VARCHAR(50), IN nascimento_aluno DATE, IN cep_novo VARCHAR(50) )
proc: BEGIN
	DECLARE pIdAluno INT;
    DECLARE pIdEndereco INT;
	IF NOT EXISTS (SELECT * FROM alunos WHERE nome = nome_aluno AND nascimento = nascimento_aluno) THEN
		SELECT 'Aluno não encontrado.';
        LEAVE proc;
	END IF;
    
	IF NOT EXISTS (SELECT * FROM enderecos WHERE cep = cep_novo) THEN
		SELECT 'Endereço não encontrado.';
        LEAVE proc;
	END IF;
    
    SET pIdAluno = (SELECT id FROM alunos WHERE nome = nome_aluno AND nascimento = nascimento_aluno);
    SET pIdEndereco = (SELECT id FROM enderecos WHERE cep = cep_novo);
    
    IF NOT EXISTS (SELECT * FROM enderecos_alunos WHERE idaluno = pIdAluno) THEN
		INSERT INTO enderecos_alunos(idaluno, idendereco) VALUES(pIdAluno, pIdEndereco);
	ELSE
		UPDATE enderecos_alunos SET idendereco = pIdEndereco WHERE idaluno = pIdAluno;
	END IF;
    
    SELECT 'Endereco mudado com sucesso.';
END $$


CREATE PROCEDURE altera_endereco_professor( IN nome_professor VARCHAR(50), IN nascimento_professor DATE, IN cep_novo VARCHAR(50) )
proc: BEGIN
	DECLARE pIdProfessor INT;
    DECLARE pIdEndereco  INT;
    
    IF NOT EXISTS (SELECT * FROM professores WHERE nome = nome_professor AND nascimento = nascimento_professor) THEN
		SELECT 'Professor não encontrado.';
        LEAVE proc;
	END IF;
    
    IF NOT EXISTS (SELECT * FROM enderecos WHERE cep = cep_novo) THEN
		SELECT 'Endereço não encontrado.';
        LEAVE proc;
	END IF;
    
    
    SET pIdProfessor = (SELECT id FROM professores WHERE nome = nome_professor AND nascimento = nascimento_professor);
    SET pIdEndereco  = (SELECT id FROM enderecos   WHERE cep = cep_novo);
    IF NOT EXISTS (SELECT * FROM enderecos_professores WHERE idprofessor = pIdProfessor) THEN
		INSERT INTO enderecos_professores(idprofessor, idendereco) VALUES(pIdProfessor, pIdEndereco);
	ELSE
		UPDATE enderecos_professores SET idendereco = pIdEndereco WHERE idprofessor = pIdProfessor;
	END IF;
    
    SELECT 'Endereço alterado com sucesso!';
END $$
DELIMITER ;








# PROCEDURES RELACIONADAS A TABELA TURMAS

DELIMITER $$
CREATE PROCEDURE cadastra_turma( IN pNome VARCHAR(2), IN pTurno VARCHAR(20) )
proc: BEGIN
	IF pNome IS NULL OR length(pNome) != 2 THEN
		SELECT 'Nome da turma inválido.';
        LEAVE proc;
	END IF;
    
    IF pTurno NOT IN ('MATUTINO', 'VESPERTINO', 'NOTURNO') THEN
		SELECT 'Turno inválido.';
        LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM turmas WHERE nome = pNome) THEN
		SELECT 'Já existe uma turma cadastrada com esse nome.';
        LEAVE proc;
	END IF;
    
    INSERT INTO turmas(nome, turno) VALUES(pNome, pTurno);
    SELECT 'Turma cadastrada com sucesso!';
END $$


CREATE PROCEDURE altera_nome_turma( IN nome_antigo VARCHAR(2), IN nome_novo VARCHAR(2) )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM turmas WHERE nome = nome_antigo) THEN
		SELECT 'Turma não encontrada.';
        LEAVE proc;
	END IF;
    
    IF nome_novo IS NULL OR length(nome_novo) != 2 THEN
		SELECT 'O nome novo é inválido.';
		LEAVE proc;
	END IF;
    
    IF EXISTS (SELECT * FROM turmas WHERE nome = nome_novo) THEN
		SELECT 'Já existe uma turma cadastrada com esse nome.';
        LEAVE proc;
	END IF;
    
    UPDATE turmas SET nome = nome_novo WHERE nome = nome_antigo;
    SELECT 'Nome mudado com sucesso!';
END $$


CREATE PROCEDURE deleta_turma( IN nome_turma VARCHAR(2) )
proc: BEGIN
	IF NOT EXISTS (SELECT * FROM turmas WHERE nome = nome_turma) THEN
		SELECT 'Turma não encontrada.';
        LEAVE proc;
	END IF;
    
    DELETE FROM turmas WHERE nome = nome_turma;
END $$
DELIMITER ;