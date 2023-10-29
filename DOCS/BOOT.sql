DROP SCHEMA IF EXISTS gerenciamento_cpd;
CREATE SCHEMA gerenciamento_cpd;
USE gerenciamento_cpd;
SET SQL_SAFE_UPDATES = 0;

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
	cd_reserva_equipamento INT,
	sg_equipamento VARCHAR(20),
	cd_rm INT,
	dt_saida_prevista DATETIME,
	dt_devolucao_prevista DATETIME,
	dt_saida DATETIME,
	dt_devolucao DATETIME,
	dt_cancelamento DATETIME,
	CONSTRAINT pk_reserva_equipamento PRIMARY KEY (cd_reserva_equipamento),
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
	cd_reserva_equipamento INT,
	cd_tipo_ocorrencia INT,
	ds_ocorrencia TEXT,
	CONSTRAINT pk_ocorrencia_equipamento PRIMARY KEY (dt_ocorrencia, cd_reserva_equipamento),
	CONSTRAINT fk_ocorrencia_equipamento_reserva_equipamento FOREIGN KEY(cd_reserva_equipamento)
		REFERENCES reserva_equipamento (cd_reserva_equipamento),
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
	cd_reserva_ambiente INT,
	sg_ambiente VARCHAR(20),
	cd_rm INT,
	dt_saida_prevista DATETIME,
    dt_devolucao_prevista DATETIME,
	dt_saida DATETIME,
	dt_devolucao DATETIME,
	dt_cancelamento DATETIME,
	CONSTRAINT pk_reserva_ambiente PRIMARY KEY (cd_reserva_ambiente),
	CONSTRAINT fk_reserva_ambiente_ambiente FOREIGN KEY (sg_ambiente)
		REFERENCES ambiente (sg_ambiente),
	CONSTRAINT fk_reserva_ambiente_usuario FOREIGN KEY (cd_rm)
		REFERENCES usuario (cd_rm)
);

CREATE TABLE ocorrencia_ambiente
(
	dt_ocorrencia DATETIME,
	cd_reserva_ambiente INT,
	cd_tipo_ocorrencia INT,
	ds_ocorrencia TEXT,
	CONSTRAINT pk_ocorrencia_ambiente PRIMARY KEY (dt_ocorrencia, cd_reserva_ambiente),
	CONSTRAINT fk_ocorrencia_ambiente_reserva_ambiente FOREIGN KEY(cd_reserva_ambiente)
		REFERENCES reserva_ambiente (cd_reserva_ambiente),
	CONSTRAINT fk_ocorrencia_ambiente_tipo_ocorrencia_ambiente FOREIGN KEY (cd_tipo_ocorrencia)
		REFERENCES tipo_ocorrencia_ambiente (cd_tipo_ocorrencia)
);

CREATE TABLE token
(
	cd_token VARCHAR(32),
	nm_email VARCHAR(255),
	dt_token DATETIME,
	CONSTRAINT pk_token PRIMARY KEY (cd_token)
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

DROP PROCEDURE IF EXISTS buscarProfessores$$
CREATE PROCEDURE buscarProfessores(pFiltro VARCHAR(255))
BEGIN
	
    SELECT cd_rm, nm_usuario FROM usuario 
    WHERE cd_tipo_usuario = 2 
    AND (nm_usuario LIKE CONCAT(pFiltro, "%") OR cd_rm LIKE CONCAT(pFiltro, "%")) 
    ORDER BY nm_usuario;
    
END$$

DROP PROCEDURE IF EXISTS buscarUsuarioPorRM$$
CREATE PROCEDURE buscarUsuarioPorRM(pRM INT)
BEGIN
	
    SELECT nm_usuario, nm_email FROM usuario 
    WHERE cd_rm = pRM;
    
END$$

/* ------------------------------ RESERVA EQUIPAMENTO ------------------------------ */

DROP FUNCTION IF EXISTS verificarSeDataPassaDe7Dias$$
CREATE FUNCTION verificarSeDataPassaDe7Dias(pData DATETIME) RETURNS BOOL
BEGIN
	DECLARE vDataAcimaDoLimite BOOL DEFAULT FALSE;
    
    SELECT DATE(pData) > DATE_ADD(CURDATE(), INTERVAL 7 DAY) INTO vDataAcimaDoLimite;
    
    RETURN vDataAcimaDoLimite;
END$$

DROP FUNCTION IF EXISTS verificarSeEquipamentoPodeSerReservado$$
CREATE FUNCTION verificarSeEquipamentoPodeSerReservado(pSiglaEquipamento VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME) RETURNS BOOL
BEGIN
	DECLARE vDanificado BOOL DEFAULT FALSE;
	DECLARE vDevolvido BOOL DEFAULT FALSE;
	DECLARE vNaoPego BOOL DEFAULT FALSE;
	DECLARE vJaReservadoParaDataEHora BOOL DEFAULT FALSE;

	IF verificarSeDataPassaDe7Dias(pDTSaidaPrevista) THEN
		RETURN false;
    END IF;

	SELECT ic_danificado INTO vDanificado FROM equipamento 
	WHERE sg_equipamento = pSiglaEquipamento;
	IF (vDanificado = TRUE) THEN 
		RETURN false;
	END IF;

	SELECT 
		COUNT(*) = 0 INTO vNaoPego
	FROM
		reserva_equipamento
	WHERE
		sg_equipamento = pSiglaEquipamento
			AND dt_saida IS NULL;

	SELECT 
		COUNT(*) = 0 INTO vDevolvido
	FROM
		reserva_equipamento
	WHERE
		sg_equipamento = pSiglaEquipamento 
	AND ((dt_saida IS NOT NULL AND dt_devolucao IS NULL));

	SELECT 
		COUNT(*) <> 0 INTO vJaReservadoParaDataEHora
	FROM
		reserva_equipamento
	WHERE
		sg_equipamento = pSiglaEquipamento
			AND pDTSaidaPrevista <= dt_devolucao_prevista AND pDTDevolucaoPrevista >= dt_saida_prevista
			AND dt_cancelamento IS NULL;

	IF (vDevolvido = FALSE) THEN 
		IF (vNaoPego = FALSE) THEN
			RETURN FALSE;
		END IF;
		RETURN FALSE;
	END IF;
	IF (vJaReservadoParaDataEHora = FALSE) THEN 
		RETURN TRUE;
	END IF;
	RETURN FALSE;
END$$

DROP PROCEDURE IF EXISTS reservarEquipamento$$
CREATE PROCEDURE reservarEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	DECLARE vCodigo INT DEFAULT 0;

	IF(!verificaSeUsuarioExiste(pRM)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário não existe';
	END IF;

	IF (!verificarSeEquipamentoPodeSerReservado(pSiglaEquipamento , pDTSaidaPrevista , pDTDevolucaoPrevista)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Equipamento já reservado';
	END IF;
		
	SELECT COALESCE((SELECT cd_reserva_equipamento FROM reserva_equipamento ORDER BY cd_reserva_equipamento DESC LIMIT 1) + 1, 1) INTO vCodigo;

	INSERT INTO reserva_equipamento VALUES (vCodigo, pSiglaEquipamento, pRM, pDTSaidaPrevista, pDTDevolucaoPrevista, null ,null, null);
END$$

DROP PROCEDURE IF EXISTS atualizarDevolucaoReservaEquipamento$$
CREATE PROCEDURE atualizarDevolucaoReservaEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_equipamento SET dt_devolucao = now()
	WHERE sg_equipamento = pSiglaEquipamento AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS atualizarSaidaReservaEquipamento$$
CREATE PROCEDURE atualizarSaidaReservaEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_equipamento SET dt_saida = now()
	WHERE sg_equipamento = pSiglaEquipamento AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS cancelarReservaEquipamento$$
CREATE PROCEDURE cancelarReservaEquipamento(pSiglaEquipamento VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_equipamento SET dt_cancelamento = DATE_FORMAT(now(), "%Y-%m-%d %H:%m:00")
	WHERE sg_equipamento = pSiglaEquipamento AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS listarReservasEquipamentos$$
CREATE PROCEDURE listarReservasEquipamentos(pCodigoStatus int, pFiltro VARCHAR(255), pData DATE)
BEGIN
	-- 1. Reservado
	-- 2. Em andamento
    -- 3. Entrega Atrasada
    -- 4. Aguardando Retirada
    -- 5. Não Retirados
    -- 6. Canceladas
    -- 7. Concluida
	SELECT 
        e.sg_equipamento,
        u.cd_rm,
        u.nm_usuario,
        re.dt_saida_prevista,
        re.dt_devolucao_prevista,
        re.dt_saida,
        re.dt_devolucao,
        re.dt_cancelamento,
        verificarStatusReserva(dt_saida_prevista, dt_devolucao_prevista, dt_saida, dt_devolucao, dt_cancelamento) as cd_status
    FROM reserva_equipamento re
    JOIN equipamento e ON re.sg_equipamento = e.sg_equipamento
    JOIN usuario u ON re.cd_rm = u.cd_rm
    WHERE 
        ((pCodigoStatus = 0 OR pCodigoStatus IS NULL) OR
			(pCodigoStatus = 1 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() < dt_saida_prevista) OR
            (pCodigoStatus = 2 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 3 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 4 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 5 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 6 AND 
				dt_cancelamento IS NOT NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL) OR
            (pCodigoStatus = 7 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NOT NULL
				AND dt_saida IS NOT NULL ))
        AND (pFiltro IS NULL OR
            u.cd_rm LIKE CONCAT(pFiltro, '%') OR u.nm_usuario LIKE CONCAT(pFiltro, '%') OR
            e.sg_equipamento LIKE CONCAT(pFiltro, '%') OR e.nm_equipamento LIKE CONCAT(pFiltro, '%'))
        AND (pData IS NULL OR
            DATE_FORMAT(re.dt_saida_prevista, "%Y-%m-%d") = pData)
    ORDER BY re.dt_saida_prevista ASC;
END$$

DROP PROCEDURE IF EXISTS listarReservasEquipamentosProfessor$$
CREATE PROCEDURE listarReservasEquipamentosProfessor(pRm INT)
BEGIN 
	SELECT 
        e.sg_equipamento,
		e.nm_equipamento,
        u.cd_rm,
        u.nm_usuario,
        re.dt_saida_prevista,
        re.dt_devolucao_prevista,
        re.dt_saida,
        re.dt_devolucao,
        re.dt_cancelamento,
		verificarStatusReserva(dt_saida_prevista, dt_devolucao_prevista, dt_saida, dt_devolucao, dt_cancelamento) as cd_status
	FROM reserva_equipamento re
    JOIN equipamento e ON re.sg_equipamento = e.sg_equipamento
    JOIN usuario u ON re.cd_rm = u.cd_rm
    WHERE 
        u.cd_rm = pRm AND DATE(re.dt_saida_prevista) >= curdate()
        AND re.dt_cancelamento IS NULL
    ORDER BY re.dt_saida_prevista ASC;
END$$

DROP PROCEDURE IF EXISTS listarEquipamentosDisponiveis$$
CREATE PROCEDURE listarEquipamentosDisponiveis(pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT sg_equipamento, nm_equipamento FROM equipamento 
	WHERE verificarSeEquipamentoPodeSerReservado(sg_equipamento, pDTSaidaPrevista, pDTDevolucaoPrevista);
END$$

DROP PROCEDURE IF EXISTS listarEquipamentosDisponiveisSigla$$
CREATE PROCEDURE listarEquipamentosDisponiveisSigla(pSigla VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT sg_equipamento, nm_equipamento FROM equipamento 
	WHERE sg_equipamento LIKE CONCAT(pSigla, '%') 
	AND verificarSeEquipamentoPodeSerReservado(sg_equipamento, pDTSaidaPrevista, pDTDevolucaoPrevista);
END$$

DROP PROCEDURE IF EXISTS listarEquipamento$$
CREATE PROCEDURE listarEquipamento(pSigla VARCHAR(20))
BEGIN
	SELECT * FROM equipamento WHERE sg_equipamento = pSigla;
END$$

DROP PROCEDURE IF EXISTS listarReservaParaEnviarEmail$$
CREATE PROCEDURE listarReservaParaEnviarEmail(pDataSaidaPrevista DATETIME, pRM INT)
BEGIN
	
	SELECT 
		e.nm_equipamento,
		re.dt_saida_prevista,
		re.dt_devolucao_prevista
	FROM
		reserva_equipamento re
			JOIN
		equipamento e ON re.sg_equipamento = e.sg_equipamento
	WHERE
		re.cd_rm = pRM
			AND re.dt_saida_prevista = pDataSaidaPrevista
	UNION SELECT 
		a.nm_ambiente,
		ra.dt_saida_prevista,
		ra.dt_devolucao_prevista
	FROM
		reserva_ambiente ra
			JOIN
		ambiente a ON ra.sg_ambiente = a.sg_ambiente
	WHERE
		ra.cd_rm = pRM
			AND ra.dt_saida_prevista = pDataSaidaPrevista;

END$$

/* ------------------------------ RESERVA AMBIENTE ------------------------------ */

DROP FUNCTION IF EXISTS verificarSeAmbientePodeSerReservado$$
CREATE FUNCTION verificarSeAmbientePodeSerReservado(pSiglaAmbiente VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME) RETURNS BOOL
BEGIN
	DECLARE vEmUsoPorAulaFixa BOOL DEFAULT FALSE;
	DECLARE vDevolvido BOOL DEFAULT FALSE;
	DECLARE vJaReservadoParaDataEHora BOOL DEFAULT FALSE;

	IF verificarSeDataPassaDe7Dias(pDTSaidaPrevista) THEN
		RETURN false;
    END IF;

	SELECT 
		COUNT(cd_dia_semana) = 0
	INTO vEmUsoPorAulaFixa FROM
		uso_ambiente
	WHERE
		sg_ambiente = pSiglaAmbiente
			AND cd_dia_semana = WEEKDAY(pDTSaidaPrevista) + 1
			AND ((TIME(pDTSaidaPrevista) BETWEEN hr_inicio_uso AND hr_termino_uso)
			OR (TIME(pDTDevolucaoPrevista) BETWEEN hr_inicio_uso AND hr_termino_uso));

	IF (vEmUsoPorAulaFixa = false) THEN
		RETURN false;
	END IF;

	SELECT 
		COUNT(*) = 0 INTO vDevolvido
	FROM
		reserva_ambiente
	WHERE
		sg_ambiente = pSiglaAmbiente 
	AND ((dt_saida IS NOT NULL AND dt_devolucao IS NULL));

	SELECT 
		COUNT(*) <> 0 INTO vJaReservadoParaDataEHora
	FROM
		reserva_ambiente
	WHERE
		sg_ambiente = pSiglaAmbiente
			AND pDTSaidaPrevista <= dt_devolucao_prevista AND pDTDevolucaoPrevista >= dt_saida_prevista
			AND dt_cancelamento IS NULL;

	IF (vJaReservadoParaDataEHora = FALSE) THEN 
		RETURN TRUE;
	ELSE 
		IF (vDevolvido = FALSE) THEN 
			RETURN TRUE;
		END IF;
	END IF;
	RETURN FALSE;

END$$

DROP PROCEDURE IF EXISTS reservarAmbiente$$
CREATE PROCEDURE reservarAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	DECLARE vCodigo INT DEFAULT 0;

	IF(!verificaSeUsuarioExiste(pRM)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário não existe';
	END IF;
	
	IF (!verificarSeAmbientePodeSerReservado(pSiglaAmbiente, pDTSaidaPrevista, pDTDevolucaoPrevista)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ambiente já reservado';
	END IF;

	SELECT COALESCE((SELECT cd_reserva_ambiente FROM reserva_ambiente ORDER BY cd_reserva_ambiente DESC LIMIT 1) + 1, 1) INTO vCodigo;

	INSERT INTO reserva_ambiente VALUES (vCodigo, pSiglaAmbiente, pRM, pDTSaidaPrevista, pDTDevolucaoPrevista, null, null, null);		
END$$

DROP PROCEDURE IF EXISTS atualizarDevolucaoReservaAmbiente$$
CREATE PROCEDURE atualizarDevolucaoReservaAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_ambiente SET dt_devolucao = now()
	WHERE sg_ambiente = pSiglaAmbiente AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS atualizarSaidaReservaAmbiente$$
CREATE PROCEDURE atualizarSaidaReservaAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_ambiente SET dt_saida = now()
	WHERE sg_ambiente = pSiglaAmbiente AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP PROCEDURE IF EXISTS cancelarReservaAmbiente$$
CREATE PROCEDURE cancelarReservaAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME)
BEGIN
	UPDATE reserva_ambiente SET dt_cancelamento = DATE_FORMAT(now(), "%Y-%m-%d %H:%m:00")
	WHERE sg_ambiente = pSiglaAmbiente AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
END$$

DROP FUNCTION IF EXISTS verificarStatusReserva$$
CREATE FUNCTION verificarStatusReserva(pDataSaidaPrevista DATETIME, pDataDevolucaoPrevista DATETIME, pDataSaida DATETIME, pDataDevolucao DATETIME, pDataCancelamento DATETIME) RETURNS INT
BEGIN
	RETURN CASE
			WHEN 	
				pDataCancelamento IS NULL
				AND pDataDevolucao IS NULL
				AND pDataSaida IS NULL
				AND NOW() < pDataDevolucaoPrevista
				AND NOW() < pDataSaidaPrevista THEN 1
			WHEN 	
				pDataCancelamento IS NULL
				AND pDataDevolucao IS NULL
				AND pDataSaida IS NOT NULL
				AND NOW() < pDataDevolucaoPrevista
				AND NOW() > pDataSaidaPrevista THEN 2
			WHEN 
				pDataCancelamento IS NULL
				AND pDataDevolucao IS NULL
				AND pDataSaida IS NOT NULL
				AND NOW() > pDataDevolucaoPrevista
				AND NOW() > pDataSaidaPrevista THEN 3
			WHEN 
				pDataCancelamento IS NULL
				AND pDataDevolucao IS NULL
				AND pDataSaida IS NULL
				AND NOW() < pDataDevolucaoPrevista
				AND NOW() > pDataSaidaPrevista THEN 4
			WHEN
				pDataCancelamento IS NULL
				AND pDataDevolucao IS NULL
				AND pDataSaida IS NULL
				AND NOW() > pDataDevolucaoPrevista
				AND NOW() > pDataSaidaPrevista THEN 5
			WHEN 
				pDataCancelamento IS NOT NULL
				AND pDataDevolucao IS NULL
				AND pDataSaida IS NULL THEN 6
			WHEN 
				pDataCancelamento IS NULL
				AND pDataDevolucao IS NOT NULL
				AND pDataSaida IS NOT NULL THEN 7
			ELSE 0
		END;
END$$

DROP PROCEDURE IF EXISTS listarReservasAmbientes$$
CREATE PROCEDURE listarReservasAmbientes(pCodigoStatus int, pFiltro VARCHAR(255), pData DATE)
BEGIN
	-- 1. Reservado
	-- 2. Em andamento
    -- 3. Entrega Atrasada
    -- 4. Aguardando Retirada
    -- 5. Não Retirados
    -- 6. Canceladas
    -- 7. Concluida
	SELECT 
        a.sg_ambiente,
        u.cd_rm,
        u.nm_usuario,
        ra.dt_saida_prevista,
        ra.dt_devolucao_prevista,
        ra.dt_saida,
        ra.dt_devolucao,
        ra.dt_cancelamento,
        verificarStatusReserva(dt_saida_prevista, dt_devolucao_prevista, dt_saida, dt_devolucao, dt_cancelamento) as cd_status
    FROM reserva_ambiente ra
    JOIN ambiente a ON ra.sg_ambiente = a.sg_ambiente
    JOIN usuario u ON ra.cd_rm = u.cd_rm
    WHERE 
        ((pCodigoStatus = 0 OR pCodigoStatus IS NULL) OR
			(pCodigoStatus = 1 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() < dt_saida_prevista) OR
            (pCodigoStatus = 2 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 3 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 4 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 5 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista) OR
            (pCodigoStatus = 6 AND 
				dt_cancelamento IS NOT NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL) OR
            (pCodigoStatus = 7 AND 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NOT NULL
				AND dt_saida IS NOT NULL ))
        AND (pFiltro IS NULL OR
            u.cd_rm LIKE CONCAT(pFiltro, '%') OR u.nm_usuario LIKE CONCAT(pFiltro, '%') OR
            a.sg_ambiente LIKE CONCAT(pFiltro, '%') OR a.nm_ambiente LIKE CONCAT(pFiltro, '%'))
        AND (pData IS NULL OR DATE(ra.dt_saida_prevista) = pData)
		ORDER BY ra.dt_saida_prevista ASC;
END$$

DROP PROCEDURE IF EXISTS listarReservasAmbientesProfessor$$
CREATE PROCEDURE listarReservasAmbientesProfessor(pRm INT)
BEGIN 
	SELECT 
        a.sg_ambiente,
		a.nm_ambiente,
        u.cd_rm,
        u.nm_usuario,
        ra.dt_saida_prevista,
        ra.dt_devolucao_prevista,
        ra.dt_saida,
        ra.dt_devolucao,
        ra.dt_cancelamento,
		verificarStatusReserva(dt_saida_prevista, dt_devolucao_prevista, dt_saida, dt_devolucao, dt_cancelamento) as cd_status
	FROM reserva_ambiente ra
    JOIN ambiente a ON ra.sg_ambiente = a.sg_ambiente
    JOIN usuario u ON ra.cd_rm = u.cd_rm
    WHERE 
        u.cd_rm = pRm AND DATE(ra.dt_saida_prevista) >= curdate()
        AND ra.dt_cancelamento IS NULL
    ORDER BY ra.dt_saida_prevista ASC;
END$$

DROP PROCEDURE IF EXISTS listarAmbientesDisponiveis$$
CREATE PROCEDURE listarAmbientesDisponiveis(pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT sg_ambiente, nm_ambiente FROM ambiente 
	WHERE verificarSeAmbientePodeSerReservado(sg_ambiente, pDTSaidaPrevista, pDTDevolucaoPrevista);
END$$

DROP PROCEDURE IF EXISTS listarAmbientesDisponiveisSigla$$
CREATE PROCEDURE listarAmbientesDisponiveisSigla(pSigla VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT sg_ambiente, nm_ambiente FROM ambiente 
	WHERE sg_ambiente LIKE CONCAT(pSigla, '%') 
	AND verificarSeAmbientePodeSerReservado(sg_ambiente, pDTSaidaPrevista, pDTDevolucaoPrevista);
END$$

DROP PROCEDURE IF EXISTS listarAmbiente$$
CREATE PROCEDURE listarAmbiente(pSigla VARCHAR(20))
BEGIN
	SELECT * FROM ambiente WHERE sg_ambiente = pSigla;
END$$

DROP PROCEDURE IF EXISTS listarAmbientes$$
CREATE PROCEDURE listarAmbientes()
BEGIN
	SELECT * FROM ambiente;
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
CREATE PROCEDURE listarUsosAmbientes(pSiglaAmbiente VARCHAR(20), pDiaSemana INT, pInicio TIME, pFim TIME)
BEGIN
	SELECT ua.*, ds.nm_dia_semana, a.nm_ambiente FROM uso_ambiente ua
	JOIN dia_semana ds ON ua.cd_dia_semana = ds.cd_dia_semana
    JOIN ambiente a ON a.sg_ambiente = ua.sg_ambiente
	WHERE (pSiglaAmbiente IS NULL OR ua.sg_ambiente = pSiglaAmbiente) 
	AND (pDiaSemana IS NULL OR ua.cd_dia_semana = pDiaSemana) 
	AND ((pInicio IS NULL OR pFim IS NULL) OR ua.hr_inicio_uso BETWEEN pInicio AND pFim AND ua.hr_termino_uso BETWEEN pInicio AND pFim)
	ORDER BY ua.cd_dia_semana ASC, ua.hr_inicio_uso ASC;
END$$
/* ------------------------------ OCORRENCIA AMBIENTE ------------------------------ */

DROP FUNCTION IF EXISTS ocorrenciaAmbienteJaExiste$$
CREATE FUNCTION ocorrenciaAmbienteJaExiste(pDataOcorrencia DATETIME, pReservaAmbiente INT) RETURNS BOOL
BEGIN
	DECLARE vReserva INT DEFAULT 0;
	SELECT cd_reserva_ambiente INTO vReserva FROM ocorrencia_ambiente
    WHERE dt_ocorrencia = pDataOcorrencia AND cd_reserva_ambiente = pReservaAmbiente;
    RETURN vReserva <> 0;
END$$

DROP PROCEDURE IF EXISTS registrarOcorrenciaAmbiente$$
CREATE PROCEDURE registrarOcorrenciaAmbiente(pDataOcorrencia DATETIME, pReservaAmbiente INT, pTipoOcorrencia INT, pDescricao TEXT)
BEGIN
	IF ocorrenciaAmbienteJaExiste(pDataOcorrencia,  pReservaAmbiente) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ocorrencia para esta reserva já registrada';
    END IF;
	INSERT INTO ocorrencia_ambiente VALUES (pDataOcorrencia , pReservaAmbiente, pTipoOcorrencia, pDescricao);
END$$

DROP PROCEDURE IF EXISTS listarTipoOcorrenciaAmbiente$$
CREATE PROCEDURE listarTipoOcorrenciaAmbiente()
BEGIN
	SELECT * FROM tipo_ocorrencia_ambiente;
END$$

/* ------------------------------ OCORRENCIA EQUIPAMENTO ------------------------------ */

DROP FUNCTION IF EXISTS ocorrenciaEquipamentoJaExiste$$
CREATE FUNCTION ocorrenciaEquipamentoJaExiste(pDataOcorrencia DATETIME, pReservaEquipamento INT) RETURNS BOOL
BEGIN
	DECLARE vReserva INT DEFAULT 0;
	SELECT cd_reserva_equipamento INTO vReserva FROM ocorrencia_equipamento
    WHERE dt_ocorrencia = pDataOcorrencia AND cd_reserva_equipamento = pReservaEquipamento;
    RETURN vReserva <> 0;
END$$

DROP PROCEDURE IF EXISTS registrarOcorrenciaEquipamento$$
CREATE PROCEDURE registrarOcorrenciaEquipamento(pDataOcorrencia DATETIME, pReservaEquipamento INT, pTipoOcorrencia INT, pDescricao TEXT)
BEGIN
	IF ocorrenciaEquipamentoJaExiste(pDataOcorrencia, pReservaEquipamento) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ocorrencia para esta reserva já registrada';
    END IF;
	INSERT INTO ocorrencia_equipamento VALUES (pDataOcorrencia , pReservaEquipamento, pTipoOcorrencia, pDescricao);
END$$

DROP PROCEDURE IF EXISTS listarTipoOcorrenciaEquipamento$$
CREATE PROCEDURE listarTipoOcorrenciaEquipamento()
BEGIN
	SELECT * FROM tipo_ocorrencia_equipamento;
END$$

/* ------------------------------ NOTIFICACAO ------------------------------ */

DROP PROCEDURE IF EXISTS enviarNotificacao$$
CREATE PROCEDURE enviarNotificacao(pTitulo VARCHAR(100), pConteudo TEXT, pRm INT)
BEGIN
	INSERT INTO notificacao VALUES(DEFAULT, pConteudo, now(), pTitulo);
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

DROP PROCEDURE IF EXISTS relatorioOcorrencia$$
CREATE PROCEDURE relatorioOcorrencia(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT 
		ra.sg_ambiente, a.nm_ambiente, ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista,
		u.cd_rm, u.nm_usuario, u.nm_email,
		oa.dt_ocorrencia, oa.ds_ocorrencia,
		toa.nm_tipo_ocorrencia
		FROM reserva_ambiente ra
		JOIN usuario u ON u.cd_rm = ra.cd_rm
		JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente 
		JOIN ocorrencia_ambiente oa ON ra.cd_reserva_ambiente = oa.cd_reserva_ambiente
		JOIN tipo_ocorrencia_ambiente toa ON oa.cd_tipo_ocorrencia = toa.cd_tipo_ocorrencia
		WHERE ra.dt_saida_prevista BETWEEN pDataInicio AND pDataFinal
	UNION
	SELECT
		re.sg_equipamento, e.nm_equipamento, re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista,
		u.cd_rm, u.nm_usuario, u.nm_email,
		oe.dt_ocorrencia, oe.ds_ocorrencia,
		toe.nm_tipo_ocorrencia
		FROM reserva_equipamento re
		JOIN usuario u ON u.cd_rm = re.cd_rm
		JOIN equipamento e ON e.sg_equipamento = re.sg_equipamento 
		JOIN ocorrencia_equipamento oe ON re.cd_reserva_equipamento = oe.cd_reserva_equipamento
		JOIN tipo_ocorrencia_equipamento toe ON oe.cd_tipo_ocorrencia = toe.cd_tipo_ocorrencia
		WHERE dt_saida_prevista BETWEEN pDataInicio AND pDataFinal
	ORDER BY dt_saida_prevista;
END$$

DROP PROCEDURE IF EXISTS relatorioReservasCanceladas$$
CREATE PROCEDURE relatorioReservasCanceladas(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
		ra.sg_ambiente, a.nm_ambiente ,ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista, ra.dt_cancelamento,
		u.cd_rm, u.nm_usuario, u.nm_email
		FROM reserva_ambiente ra
		JOIN usuario u ON u.cd_rm = ra.cd_rm
		JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente
		where ra.dt_cancelamento is not null AND
		(dt_saida_prevista BETWEEN pDataInicio AND pDataFinal)
	UNION
		SELECT
		re.sg_equipamento, e.nm_equipamento ,re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista, re.dt_cancelamento,
		u.cd_rm, u.nm_usuario, u.nm_email
		FROM reserva_equipamento re
		JOIN usuario u ON u.cd_rm = re.cd_rm
		JOIN equipamento e ON e.sg_equipamento = re.sg_equipamento
		where re.dt_cancelamento is not null AND
		(dt_saida_prevista BETWEEN pDataInicio AND pDataFinal)
	ORDER BY dt_saida_prevista;
END$$

DROP PROCEDURE IF EXISTS relatorioReservasAtrasadas$$
CREATE PROCEDURE relatorioReservasAtrasadas(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	ra.sg_ambiente, a.nm_ambiente ,ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_ambiente ra
	JOIN usuario u ON u.cd_rm = ra.cd_rm
	JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente 
	where ra.dt_saida_prevista < ra.dt_saida AND
	(ra.dt_saida_prevista BETWEEN pDataInicio AND pDataFinal)
UNION
	SELECT
	re.sg_equipamento, e.nm_equipamento ,re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_equipamento re
	JOIN usuario u ON u.cd_rm = re.cd_rm
	JOIN equipamento e ON e.sg_equipamento = re.sg_equipamento 
	where dt_saida_prevista < dt_saida AND
	(re.dt_saida_prevista BETWEEN pDataInicio AND pDataFinal)
ORDER BY dt_saida_prevista;
END$$

DROP PROCEDURE IF EXISTS relatorioReservasNaoRealizadas$$
CREATE PROCEDURE relatorioReservasNaoRealizadas(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	ra.sg_ambiente, a.nm_ambiente ,ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_ambiente ra
	JOIN usuario u ON u.cd_rm = ra.cd_rm
	JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente 
	where ra.dt_devolucao is null and ra.dt_saida is null and ra.dt_saida_prevista < now() AND
	(ra.dt_saida_prevista BETWEEN pDataInicio AND pDataFinal)
UNION
	SELECT
	re.sg_equipamento, e.nm_equipamento ,re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_equipamento re
	JOIN usuario u ON u.cd_rm = re.cd_rm
	JOIN equipamento e ON e.sg_equipamento = re.sg_equipamento 
	where re.dt_devolucao is null and re.dt_saida is null and re.dt_saida_prevista < now() AND
	(re.dt_saida_prevista BETWEEN pDataInicio AND pDataFinal)
ORDER BY dt_saida_prevista;
END$$

-- TOKEN

DROP PROCEDURE IF EXISTS buscarToken$$
CREATE PROCEDURE buscarToken(pCodigoToken VARCHAR(32))
BEGIN
	SELECT * FROM token WHERE cd_token = pCodigoToken;
END$$

DROP PROCEDURE IF EXISTS gerarToken$$
CREATE PROCEDURE gerarToken(pEmailUsuario VARCHAR(255), pCodigoToken VARCHAR(32))
BEGIN
	DECLARE vQtUsuarios INT DEFAULT 0;
	DELETE FROM token WHERE nm_email = pEmailUsuario;
	SELECT COUNT(*) INTO vQtUsuarios FROM usuario WHERE nm_email = pEmailUsuario;
	IF (vQtUsuarios = 0) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email não cadastrado';
	END IF;
	INSERT INTO token VALUES (pCodigoToken, pEmailUsuario, now());
END$$

DROP PROCEDURE IF EXISTS alterarSenhaToken$$
CREATE PROCEDURE alterarSenhaToken(pCodigoToken VARCHAR(32), pNovaSenha VARCHAR(255), pConfirmacaoSenha VARCHAR(255))
BEGIN
	DECLARE vRm INT DEFAULT 0;
	DECLARE vEmail VARCHAR(255) DEFAULT '';
	DECLARE vDataToken DATETIME;
	SELECT nm_email, dt_token INTO vEmail, vDataToken FROM token WHERE cd_token = pCodigoToken;
	IF (vEmail = '') THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Token inexistente';
	END IF;
	IF (DATE_ADD(vDataToken, INTERVAL 5 MINUTE) < NOW()) THEN
		DELETE FROM token WHERE cd_token = pCodigoToken;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Token inválido';
	END IF;
	IF (pNovaSenha <> pConfirmacaoSenha) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'As senhas não coincidem';
	END IF;
	SELECT cd_rm INTO vRm FROM usuario WHERE nm_email = vEmail;
	UPDATE usuario SET nm_senha = md5(pNovaSenha) WHERE cd_rm = vRM;
	DELETE FROM token WHERE cd_token = pCodigoToken;
END$$

DELIMITER ;


/*MASSA DE TESTE*ocorrencia_equipamento */
INSERT INTO tipo_usuario VALUES (01, 'CPD');
INSERT INTO tipo_usuario VALUES (02, 'Professor');
INSERT INTO tipo_usuario VALUES (03, 'Diretor');
/*SELECT * FROM tipo_usuario;*/

INSERT INTO usuario VALUES (36400, 'Thiago Lima', 'thiago.lima144@etec.sp.gov.br', md5('123321'), '36400.png', 1);
INSERT INTO usuario VALUES (36401, 'Rafael dos Santos', 'rafael.santos11@etec.sp.gov.br', md5('123'), '36401.png', 2);
INSERT INTO usuario VALUES (36402, 'João Lima', 'joao.lima143@etec.sp.gov.br', md5('123'), 'default.png', 2);
INSERT INTO usuario VALUES (36403, 'Miguel Soares Nascimento', 'miguel.nascimento11@etec.sp.gov.br', md5('123'), 'default.png', 2);
INSERT INTO usuario VALUES (36404, 'Caio Victor Gonçalves', 'caio.goncalves2@etec.sp.gov.br', md5('123'), 'default.png', 2);
INSERT INTO usuario VALUES (36427, 'Rafael Gomes da Costa', 'rafael.costa23@etec.sp.gov.br', md5('123'), 'default.png', 2);
INSERT INTO usuario VALUES (36421, 'Carlos Eduardo Pietro Costa', 'carlos.costa08@etec.sp.gov.br', md5('123'), 'default.png', 2);
INSERT INTO usuario VALUES (36429, 'Márcia Heloise Teixeira', 'marcia.teixeira03@etec.sp.gov.br', md5('123'), 'default.png', 2);
INSERT INTO usuario VALUES (36300, 'Isabela Marli Helena Moraes', 'isabela.moraes@etec.sp.gov.br', md5('123'), 'default.png', 3);
INSERT INTO usuario VALUES (36412, 'João Pedro Santos', 'siqueirasantos100@gmail.com', md5('123'), 'default.png', 2);
/*SELECT * FROM usuario;*/

INSERT INTO notificacao VALUES(1, '1 Notebook está disponivel para reserva', '2023-08-01 08:50:00', 'Equipamento Disponível');
INSERT INTO notificacao VALUES(2, '3 Notebooks estão disponíveis para reserva', '2023-08-02 10:00:00', 'Equipamento Disponível');
INSERT INTO notificacao VALUES(3, '1 Laboratório está disponível para reserva', '2023-08-03 14:50:00', 	'Espaço Disponível');
INSERT INTO notificacao VALUES(4, '2 Notebooks estão disponíveis para reserva', '2023-08-04 09:40:00', 'Equipamento Disponível');
INSERT INTO notificacao VALUES(5, '2 Laboratórios estão disponíveis para reserva', '2023-08-05 10:50:00', 'Equipamento Disponível');
/*SELECT * FROM notificacao;*/
INSERT INTO usuario_notificacao VALUES(36427, 1, false);
INSERT INTO usuario_notificacao VALUES(36429, 2, false);
INSERT INTO usuario_notificacao VALUES(36404, 3, false);
INSERT INTO usuario_notificacao VALUES(36402, 4, false);
INSERT INTO usuario_notificacao VALUES(36421, 5, false);
INSERT INTO usuario_notificacao VALUES(36401, 1, false);
INSERT INTO usuario_notificacao VALUES(36401, 2, true);
INSERT INTO usuario_notificacao VALUES(36401, 3, false);
INSERT INTO usuario_notificacao VALUES(36401, 4, true);
INSERT INTO usuario_notificacao VALUES(36401, 5, false);
/*SELECT * FROM usuario_notificacao;*/
INSERT INTO equipamento VALUES ('NOTE05', 'Notebook 5', 0);
INSERT INTO equipamento VALUES ('HDMI03', 'Cabo HDMI 3', 0);
INSERT INTO equipamento VALUES ('CONTROLE12', 'Controle Remoto 12', 1);
INSERT INTO equipamento VALUES ('HDMI05', 'Cabo HDMI 5', 0);
INSERT INTO equipamento VALUES ('NOTE02', 'Notebook 2', 1);
INSERT INTO equipamento VALUES ('NOTE01', 'Notebook 1', 0);
INSERT INTO equipamento VALUES ('NOTE03', 'Notebook 3', 0);
INSERT INTO equipamento VALUES ('NOTE04', 'Notebook 4', 0);
INSERT INTO equipamento VALUES ('NOTE06', 'Notebook 6', 0);
INSERT INTO equipamento VALUES ('NOTE07', 'Notebook 7', 0);
INSERT INTO equipamento VALUES ('NOTE08', 'Notebook 8', 0);
INSERT INTO equipamento VALUES ('NOTE09', 'Notebook 9', 0);
INSERT INTO equipamento VALUES ('NOTE10', 'Notebook 10', 1);
INSERT INTO equipamento VALUES ('CONTROLE01', 'Controle Remoto 1', 0);
INSERT INTO equipamento VALUES ('CONTROLE02', 'Controle Remoto 2', 0);
INSERT INTO equipamento VALUES ('CONTROLE03', 'Controle Remoto 3', 0);
INSERT INTO equipamento VALUES ('CONTROLE04', 'Controle Remoto 4', 0);
INSERT INTO equipamento VALUES ('CONTROLE05', 'Controle Remoto 5', 0);
INSERT INTO equipamento VALUES ('CONTROLE06', 'Controle Remoto 6', 0);
INSERT INTO equipamento VALUES ('CONTROLE07', 'Controle Remoto 7', 0);
INSERT INTO equipamento VALUES ('CONTROLE08', 'Controle Remoto 8', 1);
INSERT INTO equipamento VALUES ('CONTROLE09', 'Controle Remoto 9', 0);
INSERT INTO equipamento VALUES ('CONTROLE10', 'Controle Remoto 10', 0);
INSERT INTO equipamento VALUES ('CONTROLE11', 'Controle Remoto 11', 0);
INSERT INTO equipamento VALUES ('DS01', 'DataShow 1', 0);
INSERT INTO equipamento VALUES ('DS02', 'DataShow 2', 0);
INSERT INTO equipamento VALUES ('DS03', 'DataShow 3', 1);
INSERT INTO equipamento VALUES ('DS04', 'DataShow 4', 0);
INSERT INTO equipamento VALUES ('DS05', 'DataShow 5', 0);
INSERT INTO equipamento VALUES ('DS06', 'DataShow 6', 1);
INSERT INTO equipamento VALUES ('DS07', 'DataShow 7', 0);
INSERT INTO equipamento VALUES ('DS08', 'DataShow 8', 1);
INSERT INTO equipamento VALUES ('DS09', 'DataShow 9', 0);
INSERT INTO equipamento VALUES ('DS10', 'DataShow 10', 1);
/*SELECT * FROM equipamento;*/

INSERT INTO reserva_equipamento VALUES (1, 'NOTE05', 36401, '2023-06-23 12:00:00', '2023-06-23 18:00:00', null, null, '2023-06-23 11:59:00');
INSERT INTO reserva_equipamento VALUES (2, 'HDMI03', 36401, '2023-06-23 12:00:00', '2023-06-23 18:00:00', '2023-06-23 12:00:00', null, null);
INSERT INTO reserva_equipamento VALUES (3, 'CONTROLE12', 36402, '2023-06-06 07:50:00', '2023-06-06 12:35:00', null, null, '2023-06-06 07:49:00');
INSERT INTO reserva_equipamento VALUES (4, 'NOTE02', 36402, '2023-06-05 13:30:00', '2023-06-05 14:25:00', '2023-06-05 13:27:00', '2023-06-05 14:23:00', null);
INSERT INTO reserva_equipamento VALUES (5, 'HDMI05', 36402, '2023-06-05 13:30:01', '2023-06-05 14:25:00', '2023-06-05 13:27:00', '2023-06-05 14:23:00', null);
INSERT INTO reserva_equipamento VALUES (6, 'HDMI05', 36402, '2023-06-06 13:30:01', '2023-06-06 14:25:00', '2023-06-06 13:25:00', '2023-06-06 14:22:00', null);
INSERT INTO reserva_equipamento VALUES (7, 'NOTE05', 36401, DATE_ADD(ADDTIME(NOW(), "03:00:00"), INTERVAL 2 DAY), DATE_ADD(ADDTIME(NOW(), "05:00:00"), INTERVAL 2 DAY), null, null, null);
INSERT INTO reserva_equipamento VALUES (8, 'HDMI03', 36401, DATE_ADD(ADDTIME(NOW(), "02:00:00"), INTERVAL 4 DAY), DATE_ADD(ADDTIME(NOW(), "05:00:00"), INTERVAL 4 DAY), null, null, null);
INSERT INTO reserva_equipamento VALUES (9, 'CONTROLE12', 36401, DATE_ADD(ADDTIME(NOW(), "06:00:00"), INTERVAL 6 DAY), DATE_ADD(ADDTIME(NOW(), "08:00:00"), INTERVAL 6 DAY), null, null, DATE_ADD(NOW(), INTERVAL 1 DAY));
/*SELECT * FROM reserva_equipamento;*/

INSERT INTO tipo_ocorrencia_equipamento VALUES (1, 'Notebook com defeito fisico leve');
INSERT INTO tipo_ocorrencia_equipamento VALUES (2, 'Notebook com defeito fisico médio');
INSERT INTO tipo_ocorrencia_equipamento VALUES (3, 'Notebook com defeito fisico grave');
INSERT INTO tipo_ocorrencia_equipamento VALUES (4, 'Notebook inoperável');
INSERT INTO tipo_ocorrencia_equipamento VALUES (5, 'Cabo com mau contato');
INSERT INTO tipo_ocorrencia_equipamento VALUES (6, 'Cabo desemcapado');
INSERT INTO tipo_ocorrencia_equipamento VALUES (7, 'Cabo com entrada quebrada');
INSERT INTO tipo_ocorrencia_equipamento VALUES (8, 'Cabo rompido');
INSERT INTO tipo_ocorrencia_equipamento VALUES (9, 'Controle com mau contato');
INSERT INTO tipo_ocorrencia_equipamento VALUES (10, 'Controle remoto com defeito físico leve');
INSERT INTO tipo_ocorrencia_equipamento VALUES (11, 'Controle remoto com defeito físico médio');
INSERT INTO tipo_ocorrencia_equipamento VALUES (12, 'Controle remoto com defeito físico grave');
/*SELECT * FROM tipo_ocorrencia_equipamento;*/

INSERT INTO ocorrencia_equipamento VALUES ('2023-06-06 14:22:00', 6, 5, 'Cabo após testado está dando mau contato');
/*SELECT * FROM ocorrencia_equipamento;*/

INSERT INTO dia_semana VALUES (1, 'Segunda-Feira');
INSERT INTO dia_semana VALUES (2, 'Terça-Feira');
INSERT INTO dia_semana VALUES (3, 'Quarta-Feira');
INSERT INTO dia_semana VALUES (4, 'Quinta-Feira');
INSERT INTO dia_semana VALUES (5, 'Sexta-Feira');
/*SELECT * FROM dia_semana;*/

INSERT INTO ambiente VALUES ('INFOLAB01', 'Laboratório de Informática 01');
INSERT INTO ambiente VALUES ('INFOLAB02', 'Laboratório de Informática 02');
INSERT INTO ambiente VALUES ('INFOLAB03', 'Laboratório de Informática 03');
INSERT INTO ambiente VALUES ('INFOLAB04', 'Laboratório de Informática 04');
INSERT INTO ambiente VALUES ('INFOLAB05', 'Laboratório de Informática 05');
INSERT INTO ambiente VALUES ('INFOLAB06', 'Laboratório de Informática 06');
INSERT INTO ambiente VALUES ('INFOLAB07', 'Laboratório de Informática 07');
INSERT INTO ambiente VALUES ('AUDIT', 'Auditório Escolar');
INSERT INTO ambiente VALUES ('MINIAUDIT01', 'Mini Auditório 01');
INSERT INTO ambiente VALUES ('MINIAUDIT02', 'Mini Auditório 02');
INSERT INTO ambiente VALUES ('MINIAUDIT03', 'Mini Auditório 03');
INSERT INTO ambiente VALUES ('MINIAUDIT04', 'Mini Auditório 04');
INSERT INTO ambiente VALUES ('MINIAUDIT05', 'Mini Auditório 05');
INSERT INTO ambiente VALUES ('MINIAUDIT06', 'Mini Auditório 06');
/*SELECT * FROM ambiente;*/

INSERT INTO tipo_ocorrencia_ambiente VALUES (1, 'Laboratório com luz ligada');
INSERT INTO tipo_ocorrencia_ambiente VALUES (2, 'Laboratório com computador ligado');
INSERT INTO tipo_ocorrencia_ambiente VALUES (3, 'Laboratório com cadeiras desarrumadas');
INSERT INTO tipo_ocorrencia_ambiente VALUES (4, 'Laboratório com cadeiras que não o pertencem');
INSERT INTO tipo_ocorrencia_ambiente VALUES (5, 'Auditório com luz ligada');
INSERT INTO tipo_ocorrencia_ambiente VALUES (6, 'Auditorio com ventilador ligado');
INSERT INTO tipo_ocorrencia_ambiente VALUES (7, 'Mini Auditório com luz ligada');
INSERT INTO tipo_ocorrencia_ambiente VALUES (8, 'Mini Auditório com cadeiras desarrumadas');
INSERT INTO tipo_ocorrencia_ambiente VALUES (9, 'Mini Auditório com ventilador ligado');
/*SELECT * FROM tipo_ocorrencia_ambiente;*/

INSERT INTO uso_ambiente VALUES ('INFOLAB05', 2, '13:30:00', '14:20:00');
INSERT INTO uso_ambiente VALUES ('INFOLAB01', 1, '13:30:00', '15:10:00');
INSERT INTO uso_ambiente VALUES ('INFOLAB07', 3, '16:00:00', '17:10:00');
INSERT INTO uso_ambiente VALUES ('INFOLAB05', 2, '10:00:00', '11:40:00');
INSERT INTO uso_ambiente VALUES ('INFOLAB01', 1, '08:00:00', '10:00:00');
INSERT INTO uso_ambiente VALUES ('INFOLAB07', 3, '17:10:00', '18:00:00');
/*SELECT * FROM disponibilidade_ambiente;*/

INSERT INTO reserva_ambiente VALUES (1, 'INFOLAB01', 36401, '2023-06-12 13:30:00', '2023-06-12 14:20:00', null, null, '2023-06-12 13:26:35');
INSERT INTO reserva_ambiente VALUES (2, 'MINIAUDIT05', 36402, '2023-05-21 11:00:00', '2023-05-21 15:00:00', '2023-05-21 11:00:00', null, null);
INSERT INTO reserva_ambiente VALUES (3, 'INFOLAB05', 36401, '2023-06-13 13:30:00', '2023-06-13 14:15:00', null, null, '2023-06-13 12:34:27');
INSERT INTO reserva_ambiente VALUES (4, 'INFOLAB07', 36401, '2023-06-14 16:00:00', '2023-06-14 17:10:00', null, null, null);
INSERT INTO reserva_ambiente VALUES (5, 'INFOLAB01', 36402, '2023-06-12 08:00:00', '2023-06-12 08:02:00', '2023-06-12 08:50:00', '2023-06-12 08:49:23', null);
INSERT INTO reserva_ambiente VALUES (6, 'INFOLAB05', 36402, '2023-06-13 10:00:00', '2023-06-13 10:50:00', null, null, null);
INSERT INTO reserva_ambiente VALUES (7, 'INFOLAB07', 36402, '2023-06-14 17:10:00', '2023-06-14 18:00:00', null , null, null);
INSERT INTO reserva_ambiente VALUES (8, 'INFOLAB01', 36401, '2023-06-05 13:30:00', '2023-06-05 13:32:00', '2023-06-05 14:20:00', '2023-06-05 14:21:30', null);
INSERT INTO reserva_ambiente VALUES (9, 'INFOLAB05', 36401, '2023-06-06 13:30:00', '2023-06-06 13:31:43', '2023-06-06 14:15:00', '2023-06-06 14:17:00', null);
INSERT INTO reserva_ambiente VALUES (10, 'INFOLAB07', 36402, '2023-06-07 16:00:00', '2023-06-07 16:01:46', '2023-06-07 17:10:00', '2023-06-07 17:11:20', null);
INSERT INTO reserva_ambiente VALUES (11, 'INFOLAB01', 36401, DATE_ADD(ADDTIME(NOW(), "02:00:00"), INTERVAL 3 DAY), DATE_ADD(ADDTIME(NOW(), "04:00:00"), INTERVAL 3 DAY), null, null, null);
INSERT INTO reserva_ambiente VALUES (12, 'INFOLAB05', 36401, DATE_ADD(ADDTIME(NOW(), "05:00:00"), INTERVAL 5 DAY), DATE_ADD(ADDTIME(NOW(), "08:00:00"), INTERVAL 5 DAY), null, null, null);
INSERT INTO reserva_ambiente VALUES (13, 'INFOLAB07', 36401, DATE_ADD(ADDTIME(NOW(), "07:00:00"), INTERVAL 7 DAY), DATE_ADD(ADDTIME(NOW(), "09:00:00"), INTERVAL 7 DAY), null, null, DATE_ADD(NOW(), INTERVAL 1 DAY));
/*SELECT * FROM reserva_ambiente;*/

INSERT INTO ocorrencia_ambiente VALUES ('2023-06-12 08:55:00', 1, 2, 'O professor João, novamente, ao entrar no laboratório notou que o laboratório tinha 4 computadores ligados'); 
INSERT INTO ocorrencia_ambiente VALUES ('2023-06-05 14:27:00', 1, 2, 'O professor João ao entrar no laboratório notou que o laboratório tinha 4 computadores ligados'); 
INSERT INTO ocorrencia_ambiente VALUES ('2023-06-07 18:01:00', 7, 2, 'O professor Rafael ao entrar no laboratório notou que o laboratório estava com a luz ligada'); 

call reservarAmbiente('AUDIT', 36401, DATE_ADD(now(), INTERVAL 67 MINUTE), DATE_ADD(DATE_ADD(now(), INTERVAL 4 HOUR), INTERVAL 12 MINUTE));
call reservarAmbiente('MINIAUDIT04', 36402, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 3 HOUR), INTERVAL 22 MINUTE));
call reservarEquipamento('DS01', 36401, DATE_ADD(now(), INTERVAL 67 MINUTE), DATE_ADD(DATE_ADD(now(), INTERVAL 4 HOUR), INTERVAL 12 MINUTE));
call reservarEquipamento('NOTE04', 36401, DATE_ADD(now(), INTERVAL 67 MINUTE), DATE_ADD(DATE_ADD(now(), INTERVAL 4 HOUR), INTERVAL 12 MINUTE));
call reservarEquipamento('CONTROLE04', 36402, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 3 HOUR), INTERVAL 22 MINUTE));
call reservarEquipamento('NOTE09', 36403, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 3 HOUR), INTERVAL 22 MINUTE));
call reservarEquipamento('NOTE08', 36404, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 2 HOUR), INTERVAL 22 MINUTE));
call reservarEquipamento('DS09', 36402, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 4 HOUR), INTERVAL 22 MINUTE));
call reservarAmbiente('MINIAUDIT03', 36401, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 5 HOUR), INTERVAL 20 MINUTE));
call reservarAmbiente('MINIAUDIT05', 36402, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 1 HOUR), INTERVAL 25 MINUTE));
call reservarAmbiente('MINIAUDIT01', 36404, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 3 HOUR), INTERVAL 30 MINUTE));
call reservarAmbiente('MINIAUDIT06', 36403, now(), DATE_ADD(DATE_ADD(now(), INTERVAL 2 HOUR), INTERVAL 45 MINUTE));