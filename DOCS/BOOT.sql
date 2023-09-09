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
    dt_devolucao_prevista DATETIME,
	dt_saida DATETIME,
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
	DECLARE vPodeSerReservado BOOL DEFAULT FALSE;
    
    IF verificarSeDataPassaDe7Dias(pDTSaidaPrevista) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data de saída acima do limite de 7 dias';
    END IF;
    
    SELECT COUNT(e.sg_equipamento) <> 0 INTO vPodeSerReservado FROM equipamento e
	LEFT JOIN reserva_equipamento re ON e.sg_equipamento = re.sg_equipamento
		AND (
			(dt_saida_prevista >= pDTSaidaPrevista AND dt_saida_prevista < pDTDevolucaoPrevista) OR
			(dt_devolucao_prevista > pDTSaidaPrevista AND dt_devolucao_prevista <= pDTDevolucaoPrevista)
		)
	WHERE
		e.sg_equipamento = pSiglaEquipamento
		AND re.sg_equipamento IS NULL
		AND e.ic_danificado = FALSE
        AND NOT EXISTS (
			SELECT 1
			FROM reserva_equipamento re2
			WHERE re2.sg_equipamento = e.sg_equipamento
			AND DATE(re2.dt_saida_prevista) < CURDATE()
            AND re2.dt_devolucao IS NULL
		);

	RETURN vPodeSerReservado;
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

	INSERT INTO reserva_equipamento VALUES (pSiglaEquipamento, pRM, pDTSaidaPrevista, pDTDevolucaoPrevista, null ,null, null);
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
	UPDATE reserva_equipamento SET dt_cancelamento = now()
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
        CASE
			WHEN 	
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() < dt_saida_prevista THEN 1
			WHEN 	
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 2
			WHEN 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 3
			WHEN 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 4
			WHEN
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 5
			WHEN 
				dt_cancelamento IS NOT NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL THEN 6
			WHEN 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NOT NULL
				AND dt_saida IS NOT NULL THEN 7
			ELSE 0
		END as cd_status
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

DROP PROCEDURE IF EXISTS listarEquipamentosDisponiveis$$
CREATE PROCEDURE listarEquipamentosDisponiveis(pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT e.sg_equipamento, e.nm_equipamento FROM equipamento e
	LEFT JOIN reserva_equipamento re ON e.sg_equipamento = re.sg_equipamento
		AND (
			(dt_saida_prevista >= pDTSaidaPrevista AND dt_saida_prevista < pDTDevolucaoPrevista) OR
			(dt_devolucao_prevista > pDTSaidaPrevista AND dt_devolucao_prevista <= pDTDevolucaoPrevista)
		)
	WHERE
		re.sg_equipamento IS NULL
		AND e.ic_danificado = FALSE
        AND NOT EXISTS (
			SELECT 1
			FROM reserva_equipamento re2
			WHERE re2.sg_equipamento = e.sg_equipamento
			AND DATE(re2.dt_saida_prevista) < CURDATE()
            AND re2.dt_devolucao IS NULL
		);
END$$

DROP PROCEDURE IF EXISTS listarEquipamentosDisponiveisSigla$$
CREATE PROCEDURE listarEquipamentosDisponiveisSigla(pSigla VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT e.sg_equipamento, e.nm_equipamento FROM equipamento e
	LEFT JOIN reserva_equipamento re ON e.sg_equipamento = re.sg_equipamento
		AND (
			(dt_saida_prevista >= pDTSaidaPrevista AND dt_saida_prevista < pDTDevolucaoPrevista) OR
			(dt_devolucao_prevista > pDTSaidaPrevista AND dt_devolucao_prevista <= pDTDevolucaoPrevista)
		)
	WHERE
		e.sg_equipamento LIKE CONCAT(pSigla, '%') AND
		re.sg_equipamento IS NULL
		AND e.ic_danificado = FALSE
        AND NOT EXISTS (
			SELECT 1
			FROM reserva_equipamento re2
			WHERE re2.sg_equipamento = e.sg_equipamento
			AND DATE(re2.dt_saida_prevista) < CURDATE()
            AND re2.dt_devolucao IS NULL
		);
END$$

DROP PROCEDURE IF EXISTS listarEquipamento$$
CREATE PROCEDURE listarEquipamento(pSigla VARCHAR(20))
BEGIN
	SELECT * FROM equipamento WHERE sg_equipamento = pSigla;
END$$

/* ------------------------------ RESERVA AMBIENTE ------------------------------ */

DROP FUNCTION IF EXISTS verificarSeAmbientePodeSerReservado$$
CREATE FUNCTION verificarSeAmbientePodeSerReservado(pSiglaAmbiente VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME) RETURNS BOOL
BEGIN
	DECLARE vPodeSerReservado BOOL DEFAULT FALSE;

	SELECT COUNT(DISTINCT a.sg_ambiente) <> 0 INTO vPodeSerReservado FROM ambiente a
	LEFT JOIN reserva_ambiente ra ON a.sg_ambiente = ra.sg_ambiente
		AND (
			(ra.dt_saida_prevista >= pDTSaidaPrevista AND ra.dt_saida_prevista < pDTDevolucaoPrevista) OR
			(ra.dt_devolucao_prevista > pDTSaidaPrevista AND ra.dt_devolucao_prevista <= pDTDevolucaoPrevista)
		)
	LEFT JOIN uso_ambiente ua ON a.sg_ambiente = ua.sg_ambiente
		AND (
			(ua.hr_inicio_uso <= pDTDevolucaoPrevista AND ua.hr_termino_uso >= pDTSaidaPrevista)
			AND ua.cd_dia_semana = DAYOFWEEK(pDTSaidaPrevista)
		)
	WHERE
		ra.sg_ambiente IS NULL
        AND a.sg_ambiente = pSiglaAmbiente
		AND ua.sg_ambiente IS NULL;
        
	RETURN vPodeSerReservado;
END;

DROP PROCEDURE IF EXISTS reservarAmbiente$$
CREATE PROCEDURE reservarAmbiente(pSiglaAmbiente VARCHAR(20), pRM INT, pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN

	IF(!verificaSeUsuarioExiste(pRM)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário não existe';
	END IF;
	
	IF (!verificarSeAmbientePodeSerReservado(pSiglaAmbiente, pDTSaidaPrevista, pDTDevolucaoPrevista)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ambiente já reservado';
	END IF;

	INSERT INTO reserva_ambiente VALUES (pSiglaAmbiente, pRM, pDTSaidaPrevista, pDTDevolucaoPrevista, null, null, null);		
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
	UPDATE reserva_ambiente SET dt_cancelamento = now()
	WHERE sg_ambiente = pSiglaAmbiente AND cd_rm = pRM AND dt_saida_prevista = pDTSaidaPrevista;
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
        CASE
			WHEN 	
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() < dt_saida_prevista THEN 1
			WHEN 	
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 2
			WHEN 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NOT NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 3
			WHEN 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() < dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 4
			WHEN
				dt_cancelamento IS NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL
				AND NOW() > dt_devolucao_prevista
				AND NOW() > dt_saida_prevista THEN 5
			WHEN 
				dt_cancelamento IS NOT NULL
				AND dt_devolucao IS NULL
				AND dt_saida IS NULL THEN 6
			WHEN 
				dt_cancelamento IS NULL
				AND dt_devolucao IS NOT NULL
				AND dt_saida IS NOT NULL THEN 7
			ELSE 0
		END as cd_status
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

DROP PROCEDURE IF EXISTS listarAmbientesDisponiveis$$
CREATE PROCEDURE listarAmbientesDisponiveis(pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT DISTINCT a.sg_ambiente, a.nm_ambiente FROM ambiente a
	LEFT JOIN reserva_ambiente ra ON a.sg_ambiente = ra.sg_ambiente
		AND (
			(ra.dt_saida_prevista >= pDTSaidaPrevista AND ra.dt_saida_prevista < pDTDevolucaoPrevista) OR
			(ra.dt_devolucao_prevista > pDTSaidaPrevista AND ra.dt_devolucao_prevista <= pDTDevolucaoPrevista)
		)
	LEFT JOIN uso_ambiente ua ON a.sg_ambiente = ua.sg_ambiente
		AND (
			(ua.hr_inicio_uso <= pDTDevolucaoPrevista AND ua.hr_termino_uso >= pDTSaidaPrevista)
			AND ua.cd_dia_semana = DAYOFWEEK(pDTSaidaPrevista)
		)
	WHERE
		ra.sg_ambiente IS NULL
		AND ua.sg_ambiente IS NULL;
END$$

DROP PROCEDURE IF EXISTS listarAmbientesDisponiveisSigla$$
CREATE PROCEDURE listarAmbientesDisponiveisSigla(pSigla VARCHAR(20), pDTSaidaPrevista DATETIME, pDTDevolucaoPrevista DATETIME)
BEGIN
	SELECT DISTINCT a.sg_ambiente, a.nm_ambiente FROM ambiente a
	LEFT JOIN reserva_ambiente ra ON a.sg_ambiente = ra.sg_ambiente
		AND (
			(ra.dt_saida_prevista >= pDTSaidaPrevista AND ra.dt_saida_prevista < pDTDevolucaoPrevista) OR
			(ra.dt_devolucao_prevista > pDTSaidaPrevista AND ra.dt_devolucao_prevista <= pDTDevolucaoPrevista)
		)
	LEFT JOIN uso_ambiente ua ON a.sg_ambiente = ua.sg_ambiente
		AND (
			(ua.hr_inicio_uso <= pDTDevolucaoPrevista AND ua.hr_termino_uso >= pDTSaidaPrevista)
			AND ua.cd_dia_semana = DAYOFWEEK(pDTSaidaPrevista)
		)
	WHERE
		a.sg_ambiente LIKE CONCAT(pSigla, '%') AND
		ra.sg_ambiente IS NULL
		AND ua.sg_ambiente IS NULL;
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

DROP PROCEDURE IF EXISTS relatorioOcorrenciaEquipamento$$
CREATE PROCEDURE relatorioOcorrenciaEquipamento(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	re.sg_equipamento, e.nm_equipamento, re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email,
	oe.dt_ocorrencia, oe.ds_ocorrencia,
	toe.nm_tipo_ocorrencia
	FROM reserva_equipamento re
	JOIN usuario u ON u.cd_rm = re.cd_rm
	JOIN equipamento e ON e.sg_equipamento = re.sg_equipamento 
	JOIN ocorrencia_equipamento oe ON re.sg_equipamento = oe.sg_equipamento AND re.dt_saida_prevista = oe.dt_saida_prevista AND re.cd_rm = oe.cd_rm
	JOIN tipo_ocorrencia_equipamento toe ON oe.cd_tipo_ocorrencia = toe.cd_tipo_ocorrencia
	where pDataInicio >= DATE(re.dt_saida_prevista) AND pDataFinal <= DATE(re.dt_saida_prevista);
END$$

DROP PROCEDURE IF EXISTS relatorioOcorrenciaAmbiente$$
CREATE PROCEDURE relatorioOcorrenciaAmbiente(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT 
	ra.sg_ambiente, a.nm_ambiente, ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email,
	oa.dt_ocorrencia, oa.ds_ocorrencia,
	toa.nm_tipo_ocorrencia
	FROM reserva_ambiente ra
	JOIN usuario u ON u.cd_rm = ra.cd_rm
	JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente 
	JOIN ocorrencia_ambiente oa ON ra.sg_ambiente = oa.sg_ambiente AND ra.dt_saida_prevista = oa.dt_saida_prevista AND ra.cd_rm = oa.cd_rm
	JOIN tipo_ocorrencia_ambiente toa ON oa.cd_tipo_ocorrencia = toa.cd_tipo_ocorrencia
	where pDataInicio >= DATE(ra.dt_saida_prevista) AND pDataFinal <= DATE(ra.dt_saida_prevista);
END$$

DROP PROCEDURE IF EXISTS relatorioReservasCanceladasEquipamento$$
CREATE PROCEDURE relatorioReservasCanceladasEquipamento(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	re.sg_equipamento, e.nm_equipamento ,re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_equipamento re
	JOIN usuario u ON u.cd_rm = re.cd_rm
	JOIN equipamento e ON e.sg_ambiente = re.sg_equipamento
	where re.dt_cancelamento is not null AND
	(pDataInicio >= DATE(ra.dt_saida_prevista) AND pDataFinal <= DATE(ra.dt_saida_prevista));
END$$

DROP PROCEDURE IF EXISTS relatorioReservasCanceladasAmbiente$$
CREATE PROCEDURE relatorioReservasCanceladasAmbiente(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	ra.sg_ambiente, a.nm_ambiente ,ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_ambiente ra
	JOIN usuario u ON u.cd_rm = ra.cd_rm
	JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente
	where ra.dt_cancelamento is not null AND
	(pDataInicio >= DATE(ra.dt_saida_prevista) AND pDataFinal <= DATE(ra.dt_saida_prevista));
END$$

DROP PROCEDURE IF EXISTS relatorioReservasAtrasadasEquipamento$$
CREATE PROCEDURE relatorioReservasAtrasadasEquipamento(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	re.sg_equipamento, e.nm_equipamento ,re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_equipamento re
	JOIN usuario u ON u.cd_rm = re.cd_rm
	JOIN equipamento e ON e.sg_ambiente = re.sg_equipamento 
	where dt_saida_prevista < dt_saida AND
	(pDataInicio >= DATE(ra.dt_saida_prevista) AND pDataFinal <= DATE(ra.dt_saida_prevista));
END$$

DROP PROCEDURE IF EXISTS relatorioReservasAtrasadasAmbiente$$
CREATE PROCEDURE relatorioReservasAtrasadasAmbiente(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	ra.sg_ambiente, a.nm_ambiente ,ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_ambiente ra
	JOIN usuario u ON u.cd_rm = ra.cd_rm
	JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente 
	where ra.dt_saida_prevista < ra.dt_saida AND
	(pDataInicio >= DATE(ra.dt_saida_prevista) AND pDataFinal <= DATE(ra.dt_saida_prevista));
END$$

DROP PROCEDURE IF EXISTS relatorioReservasNaoRealizadasEquipamento$$
CREATE PROCEDURE relatorioReservasNaoRealizadasEquipamento(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	re.sg_equipamento, e.nm_equipamento ,re.dt_saida, re.dt_devolucao, re.dt_saida_prevista, re.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_equipamento re
	JOIN usuario u ON u.cd_rm = re.cd_rm
	JOIN equipamento e ON e.sg_ambiente = re.sg_equipamento 
	where re.dt_devolucao is null and re.dt_saida is null and re.dt_saida_prevista < now() AND
	(pDataInicio >= DATE(ra.dt_saida_prevista) AND pDataFinal <= DATE(ra.dt_saida_prevista));
END$$

DROP PROCEDURE IF EXISTS relatorioReservasNaoRealizadasAmbiente$$
CREATE PROCEDURE relatorioReservasNaoRealizadasAmbiente(pDataInicio DATE, pDataFinal DATE)
BEGIN
	SELECT
	ra.sg_ambiente, a.nm_ambiente ,ra.dt_saida, ra.dt_devolucao, ra.dt_saida_prevista, ra.dt_devolucao_prevista,
	u.cd_rm, u.nm_usuario, u.nm_email
	FROM reserva_ambiente ra
	JOIN usuario u ON u.cd_rm = ra.cd_rm
	JOIN ambiente a ON a.sg_ambiente = ra.sg_ambiente 
	where ra.dt_devolucao is null and ra.dt_saida is null and ra.dt_saida_prevista < now() AND
	(pDataInicio >= DATE(ra.dt_saida_prevista) AND pDataFinal <= DATE(ra.dt_saida_prevista));
END$$

DELIMITER ;
