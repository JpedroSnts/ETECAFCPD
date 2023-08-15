DROP SCHEMA IF EXISTS gerenciamento_cpd;
CREATE SCHEMA gerenciamento_cpd;
USE gerenciamento_cpd;

CREATE TABLE tipo_usuario
(
	cd_tipo_usuario INT,
	nm_tipo_usuario VARCHAR(45),
	CONSTRAINT pk_tipo_usuario PRIMARY KEY (cd_tipo_usuario) 
);

CREATE TABLE usuario
(
	cd_rm INT,
	nm_usuario VARCHAR(255),
	nm_email VARCHAR(255),
	nm_senha VARCHAR(255),
	nm_referencia_imagem VARCHAR(255),
	cd_tipo_usuario INT,
	CONSTRAINT pk_usuario PRIMARY KEY (cd_rm),
	CONSTRAINT fk_usuario_tipo FOREIGN KEY (cd_tipo_usuario)
		REFERENCES tipo_usuario (cd_tipo_usuario)
);

CREATE TABLE notificacao
(
	cd_notificacao INT AUTO_INCREMENT,
	ds_conteudo LONGTEXT,
	dt_notificacao DATETIME,
	nm_notificacao VARCHAR(100),
	CONSTRAINT pk_notificacao PRIMARY KEY (cd_notificacao)
);

CREATE TABLE usuario_notificacao
(
	cd_rm INT,
	cd_notificacao INT,
    ic_lida BOOL,
	CONSTRAINT pk_usuario_notificacao PRIMARY KEY (cd_rm, cd_notificacao),
	CONSTRAINT fk_usuario_notificacao_usuario FOREIGN KEY (cd_rm)
		REFERENCES usuario (cd_rm),
	CONSTRAINT fk_usuario_notificacao_notificacao FOREIGN KEY (cd_notificacao)
		REFERENCES notificacao (cd_notificacao)
);

CREATE TABLE equipamento
(
	sg_equipamento VARCHAR(20),
	nm_equipamento VARCHAR(255),
	ic_danificado BOOLEAN,
	CONSTRAINT pk_equipamento PRIMARY KEY (sg_equipamento)
);


CREATE TABLE reserva_equipamento
(
	sg_equipamento VARCHAR(20),
	cd_rm INT,
	dt_saida_prevista DATETIME,
	dt_devolucao_prevista DATETIME,
	dt_saida DATETIME,
	dt_devolucao DATETIME,
	dt_cancelamento DATETIME,
	CONSTRAINT pk_reserva_equipamento PRIMARY KEY (sg_equipamento, cd_rm, dt_saida_prevista),
	CONSTRAINT fk_reserva_equipamento_equipamento FOREIGN KEY (sg_equipamento)
		REFERENCES equipamento (sg_equipamento),
	CONSTRAINT fk_reserva_equipamento_usuario FOREIGN KEY (cd_rm)
		REFERENCES usuario (cd_rm)
);

CREATE TABLE tipo_ocorrencia_equipamento
(
	cd_tipo_ocorrencia INT,
	nm_tipo_ocorrencia VARCHAR(45),
	CONSTRAINT pk_tipo_ocorrencia_equipamento PRIMARY KEY (cd_tipo_ocorrencia)
);

CREATE TABLE ocorrencia_equipamento
(
	dt_ocorrencia DATETIME,
	sg_equipamento VARCHAR(20),
	cd_rm INT,
    dt_saida_prevista DATETIME,
	cd_tipo_ocorrencia INT,
	ds_ocorrencia TEXT,
	CONSTRAINT pk_ocorrencia_equipamento PRIMARY KEY (dt_ocorrencia, sg_equipamento, cd_rm, dt_saida_prevista),
	CONSTRAINT fk_ocorrencia_equipamento_reserva_equipamento FOREIGN KEY(sg_equipamento, cd_rm, dt_saida_prevista)
		REFERENCES reserva_equipamento (sg_equipamento, cd_rm, dt_saida_prevista),
	CONSTRAINT fk_ocorrencia_equipamento_tipo_ocorrencia_equipamento FOREIGN KEY (cd_tipo_ocorrencia)
		REFERENCES tipo_ocorrencia_equipamento (cd_tipo_ocorrencia)
);

CREATE TABLE dia_semana
(
	cd_dia_semana INT,
	nm_dia_semana VARCHAR(45),
	CONSTRAINT pk_dia_semana PRIMARY KEY (cd_dia_semana)
);

CREATE TABLE ambiente
(
	sg_ambiente VARCHAR(20),
	nm_ambiente VARCHAR(45),
	CONSTRAINT pk_ambiente PRIMARY KEY (sg_ambiente)
);

CREATE TABLE tipo_ocorrencia_ambiente
(
	cd_tipo_ocorrencia INT,
	nm_tipo_ocorrencia VARCHAR(45),
	CONSTRAINT pk_tipo_ocorrencia_ambiente PRIMARY KEY (cd_tipo_ocorrencia)
);

CREATE TABLE uso_ambiente
(
	sg_ambiente VARCHAR(20),
	cd_dia_semana INT,
	hr_inicio_uso TIME,
	hr_termino_uso TIME,
	CONSTRAINT pk_disponibilidade_ambiente PRIMARY KEY (hr_termino_uso, hr_inicio_uso, cd_dia_semana),
	CONSTRAINT fk_disponibilidade_ambiente_dia_semana FOREIGN KEY (cd_dia_semana)
		REFERENCES dia_semana (cd_dia_semana),
	CONSTRAINT fk_disponibilidade_ambiente_ambiente FOREIGN KEY (sg_ambiente)
		REFERENCES ambiente (sg_ambiente)
);

CREATE TABLE reserva_ambiente
(
	sg_ambiente VARCHAR(20),
	cd_rm INT,
	dt_saida_prevista DATETIME,
	dt_saida DATETIME,
	dt_devolucao_prevista DATETIME,
	dt_devolucao DATETIME,
	dt_cancelamento DATETIME,
	CONSTRAINT pk_reserva_ambiente PRIMARY KEY (sg_ambiente, cd_rm, dt_saida_prevista),
	CONSTRAINT fk_reserva_ambiente_ambiente FOREIGN KEY (sg_ambiente)
		REFERENCES ambiente (sg_ambiente),
	CONSTRAINT fk_reserva_ambiente_usuario FOREIGN KEY (cd_rm)
		REFERENCES usuario (cd_rm)
);

CREATE TABLE ocorrencia_ambiente
(
	dt_ocorrencia DATETIME,
	sg_ambiente VARCHAR(20),
	cd_rm INT,
    dt_saida_prevista DATETIME,
	cd_tipo_ocorrencia INT,
	ds_ocorrencia TEXT,
	CONSTRAINT pk_ocorrencia_ambiente PRIMARY KEY (dt_ocorrencia, sg_ambiente, cd_rm, dt_saida_prevista),
	CONSTRAINT fk_ocorrencia_ambiente_reserva_ambiente FOREIGN KEY(sg_ambiente, cd_rm, dt_saida_prevista)
		REFERENCES reserva_ambiente (sg_ambiente, cd_rm, dt_saida_prevista),
	CONSTRAINT fk_ocorrencia_ambiente_tipo_ocorrencia_ambiente FOREIGN KEY (cd_tipo_ocorrencia)
		REFERENCES tipo_ocorrencia_ambiente (cd_tipo_ocorrencia)
);

DELIMITER $$

/* ------------------------------ USUARIO ------------------------------ */

DROP FUNCTION IF EXISTS verificaSeUsuarioExiste$$ /* funciona */
CREATE FUNCTION verificaSeUsuarioExiste(pRM INT) RETURNS BOOL
BEGIN
	DECLARE vRM INT DEFAULT 0;
	SELECT cd_rm INTO vRM FROM usuario WHERE cd_rm = pRM;
	RETURN vRM <> 0;
END$$

DROP PROCEDURE IF EXISTS adicionarUsuario$$  /* funciona */
CREATE PROCEDURE adicionarUsuario(pRM INT,  pNome VARCHAR(255), pEmail VARCHAR(255), pSenha VARCHAR(255), pImg VARCHAR(255), pTipoUsuario INT)
BEGIN

	DECLARE vTipoUsuario INT DEFAULT 0;
	
	SELECT cd_tipo_usuario INTO vTipoUsuario FROM tipo_usuario WHERE cd_tipo_usuario = pTipoUsuario;

	IF(vTipoUsuario = 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de Usuário não existe';
	END IF;

	IF(!verificaSeUsuarioExiste(pRM)) THEN 
		INSERT INTO usuario VALUES (pRM, pNome, pEmail, md5(pSenha), pImg, pTipoUsuario);
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário já cadastrado';
	END IF;
	
END$$

DROP PROCEDURE IF EXISTS loginUsuario$$
CREATE PROCEDURE loginUsuario(pRM INT,  pSenha VARCHAR(255))
BEGIN
	DECLARE vUsuario INT DEFAULT 0;
    
	IF(!verificaSeUsuarioExiste(pRM)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário não existe';
	END IF;
    
    SELECT COUNT(cd_rm) into vUsuario FROM usuario WHERE cd_rm = pRM AND md5(pSenha) = nm_senha;
	IF (vUsuario = 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha incorreta';
	END IF;
	
	SELECT u.cd_rm, u.nm_usuario, u.nm_email, u.nm_referencia_imagem, tu.*
	FROM usuario u JOIN tipo_usuario tu ON u.cd_tipo_usuario = tu.cd_tipo_usuario
	WHERE u.cd_rm = pRM AND md5(pSenha) = u.nm_senha;
	
END$$

DROP PROCEDURE IF EXISTS alterarSenhaUsuario$$
CREATE PROCEDURE alterarSenhaUsuario(pRM INT,  pSenha VARCHAR(255), pNovaSenha VARCHAR(255), pConfirmacaoSenha VARCHAR(255))
BEGIN
	DECLARE vUsuario INT DEFAULT 0;
    
	IF(!verificaSeUsuarioExiste(pRM)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário não existe';
	END IF;
	
    SELECT COUNT(cd_rm) into vUsuario FROM usuario WHERE cd_rm = pRM AND md5(pSenha) = nm_senha;
	IF (vUsuario = 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha incorreta';
	END IF;
	
	IF (pNovaSenha <> pConfirmacaoSenha) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'As senhas não coincidem';
	END IF;
	
	UPDATE usuario SET nm_senha = md5(pNovaSenha) WHERE cd_rm = pRM;
    
END$$

/* ------------------------------ RESERVA EQUIPAMENTO ------------------------------ */

DROP FUNCTION IF EXISTS verificarSeEquipamentoPodeSerReservado$$
CREATE FUNCTION verificarSeEquipamentoPodeSerReservado(pSiglaEquipamento VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME) RETURNS BOOL
BEGIN
	DECLARE vDanificado bool default false;
	DECLARE vJaDevolvido bool default false;
    DECLARE vParaHoje bool default false;
    DECLARE vPodeReservarHoje bool default false;
    DECLARE vReservaJaPassou bool default false;

	IF (pDTSaidaPrevista > DATE_ADD(curdate(), INTERVAL 7 DAY)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data acima do prazo (7 dias)';
	END IF;
	
    -- Verifica se equipamento está danificado
	SELECT ic_danificado = 1 INTO vDanificado FROM equipamento
	WHERE sg_equipamento = pSiglaEquipamento;
    
    -- Verifica se equipamento ja foi devolvido
	SELECT COUNT(re.sg_equipamento) = 0 INTO vJaDevolvido FROM reserva_equipamento re
	JOIN equipamento e ON re.sg_equipamento = e.sg_equipamento
	WHERE 	re.sg_equipamento = pSiglaEquipamento
    AND 	re.dt_devolucao is null;
	
    -- Verifica se tem reserva para hoje
    SELECT COUNT(re.sg_equipamento) <> 0 INTO vParaHoje FROM reserva_equipamento re
	JOIN equipamento e ON re.sg_equipamento = e.sg_equipamento
	WHERE 	re.sg_equipamento = pSiglaEquipamento
    AND 	DATE(pDTSaidaPrevista) = DATE(re.dt_saida_prevista)
    AND 	DATE(pDTDevolucaoPrevista) = DATE(re.dt_devolucao_prevista);
    
    -- Verifica se equipamento pode ser reservado hoje
    SELECT COUNT(re.sg_equipamento) <> 0 INTO vPodeReservarHoje FROM reserva_equipamento re
	JOIN equipamento e ON re.sg_equipamento = e.sg_equipamento
	WHERE 	re.sg_equipamento = pSiglaEquipamento
    AND 	pDTSaidaPrevista < re.dt_saida_prevista
    AND 	pDTDevolucaoPrevista <= re.dt_saida_prevista;
    
    SELECT COUNT(re.sg_equipamento) <> 0 INTO vReservaJaPassou FROM reserva_equipamento re
	JOIN equipamento e ON re.sg_equipamento = e.sg_equipamento
	WHERE 	re.sg_equipamento = pSiglaAmbiente
    AND 	curdate() > DATE(re.dt_saida_prevista)
    AND 	curdate() > DATE(re.dt_devolucao_prevista);
    
    IF vDanificado THEN
		return false;
    ELSE
		IF vParaHoje THEN
			return vPodeReservarHoje;
		ELSE
			IF vReservaJaPassou THEN
				IF vJaDevolvido THEN 
					return true;
				END IF;
				return false;
			END IF;
		END IF;
    END IF;
END$$

DROP PROCEDURE IF EXISTS reservarEquipamento$$
CREATE PROCEDURE reservarEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN

	IF(!verificaSeUsuarioExiste(pRM)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário não existe';
	END IF;

	IF (!verificarSeEquipamentoPodeSerReservado(pSiglaEquipamento , pDTSaidaPrevista , pDTDevolucaoPrevista)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Equipamento já reservado';
	END IF;

	INSERT INTO reserva_equipamento VALUES (pSiglaEquipamento, pRM, pDTSaidaPrevista, pDTDevolucaoPrevista, null, null, null);
END$$

DROP PROCEDURE IF EXISTS atualizarDevolucaoReservaEquipamento$$
CREATE PROCEDURE atualizarDevolucaoReservaEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_equipamento SET dt_devolucao = curdate() 
	WHERE sg_ambiente = pSiglaEquipamento AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS atualizarSaidaReservaEquipamento$$
CREATE PROCEDURE atualizarSaidaReservaEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_equipamento SET dt_saida = curdate() 
	WHERE sg_ambiente = pSiglaEquipamento AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS cancelarReservaEquipamento$$
CREATE PROCEDURE cancelarReservaEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_equipamento SET dt_cancelamento = curdate() 
	WHERE sg_ambiente = pSiglaEquipamento AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS listarReservasEquipamentosDeHoje$$
CREATE PROCEDURE listarReservasEquipamentosDeHoje()
BEGIN
	SELECT 
	e.sg_equipamento, e.nm_equipamento, e.ic_danificado,
    u.cd_rm, u.nm_usuario, u.nm_email, u.nm_referencia_imagem,
    tu.cd_tipo_usuario, tu.nm_tipo_usuario,
    re.dt_saida_prevista, re.dt_devolucao_prevista, re.dt_saida, re.dt_devolucao ,re.dt_cancelamento
	FROM reserva_equipamento re
    JOIN equipamento e ON re.sg_equipamento = e.sg_equipamento
    JOIN usuario u ON re.cd_rm = u.cd_rm
    JOIN tipo_usuario tu ON tu.cd_tipo_usuario = u.cd_tipo_usuario
    WHERE DATE_FORMAT(re.dt_saida_prevista, "%Y-%m-%d") = CURDATE()
    ORDER BY re.dt_saida_prevista ASC;
END$$

/* ------------------------------ RESERVA AMBIENTE ------------------------------ */

DROP FUNCTION IF EXISTS verificarSeAmbientePodeSerReservado$$
CREATE FUNCTION verificarSeAmbientePodeSerReservado(pSiglaAmbiente VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME) RETURNS BOOL
BEGIN
	DECLARE vJaDevolvido bool default false;
    DECLARE vParaHoje bool default false;
    DECLARE vPodeReservarHoje bool default false;
    DECLARE vReservaJaPassou bool default false;
	DECLARE vEstaNaGrade bool default false;
    
    -- Verifica se equipamento ja foi devolvido
	SELECT COUNT(ra.sg_ambiente) = 0 INTO vJaDevolvido FROM reserva_ambiente ra
	JOIN ambiente a ON ra.sg_ambiente  = a.sg_ambiente
	WHERE 	ra.sg_ambiente = pSiglaAmbiente
    AND 	ra.dt_devolucao is null;
	
    -- Verifica se tem reserva para hoje
    SELECT COUNT(ra.sg_ambiente) <> 0 INTO vParaHoje FROM reserva_ambiente ra
	JOIN ambiente a ON ra.sg_ambiente = a.sg_ambiente
	WHERE 	ra.sg_ambiente = pSiglaAmbiente
    AND 	DATE(pDTSaidaPrevista) = DATE(ra.dt_saida_prevista)
    AND 	DATE(pDTDevolucaoPrevista) = DATE(ra.dt_devolucao_prevista);
    
    -- Verifica se equipamento pode ser reservado hoje
    SELECT COUNT(ra.sg_ambiente) <> 0 INTO vPodeReservarHoje FROM reserva_ambiente ra
	JOIN ambiente a ON ra.sg_ambiente = a.sg_ambiente
	WHERE 	ra.sg_ambiente = pSiglaAmbiente
    AND 	pDTSaidaPrevista < ra.dt_saida_prevista
    AND 	pDTDevolucaoPrevista <= ra.dt_saida_prevista;
    
    SELECT COUNT(ra.sg_ambiente) <> 0 INTO vReservaJaPassou FROM reserva_ambiente ra
	JOIN ambiente a ON ra.sg_ambiente = a.sg_ambiente
	WHERE 	ra.sg_ambiente = pSiglaAmbiente
    AND 	curdate() > DATE(ra.dt_saida_prevista)
    AND 	curdate() > DATE(ra.dt_devolucao_prevista);

	SELECT COUNT(sg_ambiente) <> 0 INTO vEstaNaGrade FROM uso_ambiente
	WHERE sg_ambiente = pSiglaAmbiente
	AND WEEKDAY(pDTSaidaPrevista) + 1 = cd_dia_semana
	AND DATE_FORMAT(pDTSaidaPrevista, "%H:%i:%s") <= hr_inicio_uso
	AND DATE_FORMAT(pDTDevolucaoPrevista, "%H:%i:%s") < hr_inicio_uso;
    
	IF vParaHoje THEN
		return vPodeReservarHoje;
	ELSE
		IF vReservaJaPassou THEN
			IF vJaDevolvido THEN 
				IF vEstaNaGrade THEN
					return true;
				END IF;
					return false;
			END IF;
			return false;
		END IF;
	END IF;
END$$

DROP PROCEDURE IF EXISTS reservarAmbiente$$
CREATE PROCEDURE reservarAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN

	IF(!verificaSeUsuarioExiste(pRM)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário não existe';
	END IF;
	
	IF (!verificarSeAmbientePodeSerReservado(pSiglaAmbiente, pDTDevolucaoPrevista)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ambiente já reservado';
	END IF;

	INSERT INTO reserva_ambiente VALUES (pSiglaEquipamento, pRM, pDTSaidaPrevista, pDTDevolucaoPrevista, null, null, null);		
END$$

DROP PROCEDURE IF EXISTS atualizarDevolucaoReservaAmbiente$$
CREATE PROCEDURE atualizarDevolucaoReservaAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_ambiente SET dt_devolucao = curdate() 
	WHERE sg_ambiente = pSiglaAmbiente AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS atualizarSaidaReservaAmbiente$$
CREATE PROCEDURE atualizarSaidaReservaAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_ambiente SET dt_saida = curdate() 
	WHERE sg_ambiente = pSiglaAmbiente AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS cancelarReservaAmbiente$$
CREATE PROCEDURE cancelarReservaAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_ambiente SET dt_cancelamento = curdate() 
	WHERE sg_ambiente = pSiglaAmbiente AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS listarReservasAmbientesDeHoje$$
CREATE PROCEDURE listarReservasAmbientesDeHoje()
BEGIN
	SELECT 
	a.sg_ambiente, a.nm_ambiente,
    u.cd_rm, u.nm_usuario, u.nm_email, u.nm_referencia_imagem,
    tu.cd_tipo_usuario, tu.nm_tipo_usuario,
    ra.dt_saida_prevista, ra.dt_devolucao_prevista, ra.dt_saida, ra.dt_devolucao, ra.dt_cancelamento
	FROM reserva_ambiente ra
    JOIN ambiente a ON ra.sg_ambiente = a.sg_ambiente
    JOIN usuario u ON ra.cd_rm = u.cd_rm
    JOIN tipo_usuario tu ON tu.cd_tipo_usuario = u.cd_tipo_usuario
    WHERE DATE_FORMAT(ra.dt_saida_prevista, "%Y-%m-%d") = CURDATE()
    ORDER BY ra.dt_saida_prevista ASC;
END$$

/* ------------------------------ USO AMBIENTE ------------------------------ */

DROP FUNCTION IF EXISTS usoAmbienteJaExiste$$
CREATE FUNCTION usoAmbienteJaExiste(pHorarioInicio TIME, pHorarioFim TIME, pDiaSemana INT) returns bool
BEGIN
	DECLARE vSigla VARCHAR(20) DEFAULT "";
	SELECT sg_ambiente INTO vSigla FROM uso_ambiente 
    WHERE hr_termino_uso = pHorarioFim AND hr_inicio_uso = pHorarioInicio AND cd_dia_semana = pDiaSemana;
    RETURN vSigla <> "";
END$$

DROP PROCEDURE IF EXISTS adicionarUsoAmbiente$$
CREATE PROCEDURE adicionarUsoAmbiente(pSiglaAmbiente VARCHAR(20), pHorarioInicio TIME, pHorarioFim TIME, pDiaSemana INT)
BEGIN
	IF usoAmbienteJaExiste(pHorarioInicio, pHorarioFim, pDiaSemana) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Uso ambiente já cadastrado';
    END IF;
	INSERT INTO uso_ambiente VALUES (pHorarioInicio, pHorarioFim, pDiaSemana, pSiglaAmbiente);
END$$

DROP PROCEDURE IF EXISTS removerUsoAmbiente$$
CREATE PROCEDURE removerUsoAmbiente(pHorarioInicio TIME, pHorarioFim TIME, pDiaSemana INT)
BEGIN
	IF !usoAmbienteJaExiste(pHorarioInicio, pHorarioFim, pDiaSemana) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Uso ambiente não cadastrado';
    END IF;
	DELETE FROM uso_ambiente WHERE hr_termino_uso = pHorarioFim AND hr_inicio_uso = pHorarioInicio AND cd_dia_semana = pDiaSemana;
END$$

DROP PROCEDURE IF EXISTS listarUsosAmbientes$$
CREATE PROCEDURE listarUsosAmbientes()
BEGIN
	SELECT * FROM uso_ambiente ORDER BY cd_dia_semana ASC, hr_inicio_uso ASC;
END$$

/* ------------------------------ OCORRENCIA AMBIENTE ------------------------------ */

DROP FUNCTION IF EXISTS ocorrenciaAmbienteJaExiste$$
CREATE FUNCTION ocorrenciaAmbienteJaExiste(pDataOcorrencia DATETIME, pSiglaAmbiente VARCHAR(20), pRm INT, pDataSaidaPrevista DATETIME) RETURNS BOOL
BEGIN
	DECLARE vRm INT DEFAULT 0;
	SELECT cd_rm INTO vRm FROM ocorrencia_ambiente
    WHERE dt_ocorrencia = pDataOcorrencia AND sg_ambiente = pSiglaAmbiente AND cd_rm = pRm AND dt_saida_prevista = pDataSaidaPrevista;
    RETURN vRm <> 0;
END$$

DROP PROCEDURE IF EXISTS registrarOcorrenciaAmbiente$$
CREATE PROCEDURE registrarOcorrenciaAmbiente(pDataOcorrencia DATETIME, pSiglaAmbiente VARCHAR(20), pRm INT, pDataSaidaPrevista DATETIME, pTipoOcorrencia INT, pDescricao TEXT)
BEGIN
	IF ocorrenciaAmbienteJaExiste(pDataOcorrencia, pSiglaAmbiente, pRm, pDataSaidaPrevista) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ocorrencia para esta reserva já registrada';
    END IF;
	INSERT INTO ocorrencia_ambiente VALUES (pDataOcorrencia , pSiglaAmbiente , pRm, pDataSaidaPrevista, pTipoOcorrencia, pDescricao);
END$$

/* ------------------------------ OCORRENCIA EQUIPAMENTO ------------------------------ */

DROP FUNCTION IF EXISTS ocorrenciaEquipamentoJaExiste$$
CREATE FUNCTION ocorrenciaEquipamentoJaExiste(pDataOcorrencia DATETIME, pSiglaEquipamento VARCHAR(20), pRm INT, pDataSaidaPrevista DATETIME) RETURNS BOOL
BEGIN
	DECLARE vRm INT DEFAULT 0;
	SELECT cd_rm INTO vRm FROM ocorrencia_equipamento
    WHERE dt_ocorrencia = pDataOcorrencia AND sg_equipamento = pSiglaEquipamento AND cd_rm = pRm AND dt_saida_prevista = pDataSaidaPrevista;
    RETURN vRm <> 0;
END$$

DROP PROCEDURE IF EXISTS registrarOcorrenciaEquipamento$$
CREATE PROCEDURE registrarOcorrenciaEquipamento(pDataOcorrencia DATETIME, pSiglaEquipamento VARCHAR(20), pRm INT, pDataSaidaPrevista DATETIME, pTipoOcorrencia INT, pDescricao TEXT)
BEGIN
	IF ocorrenciaEquipamentoJaExiste(pDataOcorrencia, pSiglaEquipamento, pRm, pDataSaidaPrevista) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ocorrencia para esta reserva já registrada';
    END IF;
	INSERT INTO ocorrencia_equipamento VALUES (pDataOcorrencia , pSiglaEquipamento , pRm, pDataSaidaPrevista, pTipoOcorrencia, pDescricao);
END$$

/* ------------------------------ NOTIFICACAO ------------------------------ */

DROP PROCEDURE IF EXISTS criarNotificacao$$
CREATE PROCEDURE criarNotificacao(pTitulo VARCHAR(100), pDescricao TEXT, pRm INT)
BEGIN
	INSERT INTO notificacao VALUES(DEFAULT, pDescricao, now(), pTitulo);
    INSERT INTO usuario_notificacao VALUES (pRm, last_insert_id(), false);
END$$

DROP PROCEDURE IF EXISTS exibirNotificacaoUsuario$$
CREATE PROCEDURE exibirNotificacaoUsuario(pRm int)
BEGIN
	SELECT n.* FROM usuario_notificacao un
    JOIN notificacao n ON n.cd_notificacao = un.cd_notificacao
    WHERE cd_rm = pRm;
END$$

/* ------------------------------ RELATORIOS ------------------------------ */

DELIMITER ;