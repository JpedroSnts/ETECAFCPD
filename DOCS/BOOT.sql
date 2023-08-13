DROP SCHEMA IF EXISTS gerenciamento_cpd;
CREATE SCHEMA gerenciamento_cpd;
USE gerenciamento_cpd;

/*PARTE CPD*/
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
	cd_notificacao INT,
	ds_conteudo LONGTEXT,
	dt_notificacao DATETIME,
	nm_notificacao VARCHAR(100),
	CONSTRAINT pk_notificacao PRIMARY KEY (cd_notificacao)
);

CREATE TABLE usuario_notificacao
(
	cd_rm INT,
	cd_notificacao INT,
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
	cd_tipo_ocorrencia INT,
	ds_ocorrencia TEXT,
	CONSTRAINT pk_ocorrencia_equipamento PRIMARY KEY (dt_ocorrencia, sg_equipamento, cd_rm, cd_tipo_ocorrencia),
	CONSTRAINT fk_ocorrencia_equipamento_reserva_equipamento FOREIGN KEY(sg_equipamento, cd_rm)
		REFERENCES reserva_equipamento (sg_equipamento, cd_rm),
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
	cd_tipo_ocorrencia INT,
	ds_ocorrencia TEXT,
	CONSTRAINT pk_ocorrencia_ambiente PRIMARY KEY (dt_ocorrencia, sg_ambiente, cd_rm, cd_tipo_ocorrencia),
	CONSTRAINT fk_ocorrencia_ambiente_reserva_ambiente FOREIGN KEY(sg_ambiente, cd_rm)
		REFERENCES reserva_ambiente (sg_ambiente, cd_rm),
	CONSTRAINT fk_ocorrencia_ambiente_tipo_ocorrencia_ambiente FOREIGN KEY (cd_tipo_ocorrencia)
		REFERENCES tipo_ocorrencia_ambiente (cd_tipo_ocorrencia)
);
