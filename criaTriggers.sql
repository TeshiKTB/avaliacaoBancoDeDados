
DELIMITER $$

CREATE TRIGGER insere_notas_aluno AFTER INSERT
ON alunos
FOR EACH ROW
BEGIN
	DECLARE i INT DEFAULT 0;
    loop_notas: LOOP
		SET i = i + 1;
        
        IF i > (SELECT max(codigo) FROM materias) THEN
			LEAVE loop_notas;
		END IF;
        
        IF EXISTS (SELECT * FROM materias WHERE codigo = i) THEN
			INSERT INTO notas_alunos(idaluno, codigomateria) VALUES(NEW.id, i);
		END IF;
	END LOOP loop_notas;
END $$


CREATE TRIGGER deleta_endereco_turma_aluno BEFORE DELETE
ON alunos
FOR EACH ROW
BEGIN
	DELETE FROM enderecos_alunos WHERE idaluno = OLD.id;
	DELETE FROM turmas_alunos WHERE idaluno = OLD.id;
    DELETE FROM notas_alunos WHERE idaluno = OLD.id;
END $$


CREATE TRIGGER deleta_endereco_professor BEFORE DELETE
ON professores
FOR EACH ROW
BEGIN
	DELETE FROM enderecos_professores WHERE idprofessor = OLD.id;
END $$



CREATE TRIGGER insere_nota_alunos AFTER INSERT
ON materias
FOR EACH ROW
BEGIN
	DECLARE i INT DEFAULT 0;
    loop_alunos: LOOP
		SET i = i + 1;
        
        IF i > (SELECT max(id) FROM alunos) THEN
			LEAVE loop_alunos;
		END IF;
        
        IF EXISTS (SELECT * FROM alunos WHERE id = i) THEN
			INSERT INTO notas_alunos(idaluno, codigomateria) VALUES(i, NEW.codigo);
		END IF;
    END LOOP loop_alunos;
END $$


CREATE TRIGGER deleta_materia_notas BEFORE DELETE
ON materias
FOR EACH ROW
BEGIN
	DELETE FROM notas_alunos WHERE codigomateria = OLD.codigo;
END $$



CREATE TRIGGER deleta_enderecos_alunos_professores BEFORE DELETE
ON enderecos
FOR EACH ROW
BEGIN
	DELETE FROM enderecos_alunos WHERE idendereco = OLD.id;
    DELETE FROM enderecos_professores WHERE idendereco = OLD.id;
END $$


CREATE TRIGGER deleta_alunos_turma BEFORE DELETE
ON turmas
FOR EACH ROW
BEGIN
	DELETE FROM turmas_alunos WHERE idturma = OLD.id;
END $$

DELIMITER ;

DROP TRIGGER deleta_alunos_turma;