-- =========================================================
-- Projeto: Loja de Vinhos
-- =========================================================

-- 1) CRIAÇÃO DO SCHEMA
CREATE DATABASE IF NOT EXISTS loja_vinhos
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE loja_vinhos;

-- =========================================================
-- 2) CRIAÇÃO DAS TABELAS
-- =========================================================

-- Tabela de Regiões (pai das vinícolas)
DROP TABLE IF EXISTS Vinho;
DROP TABLE IF EXISTS Vinicola;
DROP TABLE IF EXISTS Regiao;

CREATE TABLE Regiao (
  codRegiao       BIGINT PRIMARY KEY AUTO_INCREMENT,
  nomeRegiao      VARCHAR(100) NOT NULL,
  descricaoRegiao TEXT
) ENGINE=InnoDB;

-- Tabela de Vinícolas (cada uma pertence a uma região)
CREATE TABLE Vinicola (
  codVinicola       BIGINT PRIMARY KEY AUTO_INCREMENT,
  nomeVinicola      VARCHAR(100) NOT NULL,
  descricaoVinicola TEXT,
  foneVinicola      VARCHAR(15),
  emailVinicola     VARCHAR(15),
  codRegiao         BIGINT NOT NULL,
  INDEX idx_vinicola_regiao (codRegiao),
  CONSTRAINT fk_vinicola_regiao
    FOREIGN KEY (codRegiao) REFERENCES Regiao(codRegiao)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela de Vinhos (cada vinho pertence a uma vinícola)
CREATE TABLE Vinho (
  codVinho        BIGINT PRIMARY KEY AUTO_INCREMENT,
  nomeVinho       VARCHAR(50) NOT NULL,
  tipoVinho       VARCHAR(30),
  anoVinho        INT,
  descricaoVinho  TEXT,
  codVinicola     BIGINT NOT NULL,
  INDEX idx_vinho_vinicola (codVinicola),
  CONSTRAINT fk_vinho_vinicola
    FOREIGN KEY (codVinicola) REFERENCES Vinicola(codVinicola)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- 3) INSERÇÃO DE DADOS (mínimo 5 por tabela)
-- =========================================================

-- Regiões
INSERT INTO Regiao (nomeRegiao, descricaoRegiao) VALUES
 ('Vale dos Vinhedos','Região vitivinícola no RS, Brasil.'),
 ('Serra Catarinense','Região fria propícia a vinhos de altitude.'),
 ('Mendoza','Tradicional região da Argentina, destaque Malbec.'),
 ('Douro','Região de Portugal, famosa pelo Vinho do Porto.'),
 ('Toscana','Região italiana conhecida pelo Sangiovese.');

-- Vinícolas (vinculadas às regiões por subselect)
INSERT INTO Vinicola (nomeVinicola, descricaoVinicola, foneVinicola, emailVinicola, codRegiao) VALUES
 ('Vinícola Aurora',  'Cooperativa tradicional no Brasil.',   '5430211234', 'aurora@vinh.com',
     (SELECT codRegiao FROM Regiao WHERE nomeRegiao='Vale dos Vinhedos')),
 ('Villa Francioni',  'Vinícola de altitude em SC.',           '4832345678', 'vf@vinh.com',
     (SELECT codRegiao FROM Regiao WHERE nomeRegiao='Serra Catarinense')),
 ('Catena Zapata',    'Ícone de Mendoza.',                     '2604002000', 'catena@vinh.com',
     (SELECT codRegiao FROM Regiao WHERE nomeRegiao='Mendoza')),
 ('Quinta do Bom',    'Produtora no Douro.',                   '2223456789', 'qdb@vinh.com',
     (SELECT codRegiao FROM Regiao WHERE nomeRegiao='Douro')),
 ('Antinori',         'Clássica casa toscana.',                '5559567890', 'anti@vinh.com',
     (SELECT codRegiao FROM Regiao WHERE nomeRegiao='Toscana'));

-- Vinhos (vinculados às vinícolas por subselect)
INSERT INTO Vinho (nomeVinho, tipoVinho, anoVinho, descricaoVinho, codVinicola) VALUES
 ('Aurora Reserva',    'Tinto', 2020, 'Corte bordalês brasileiro.',
   (SELECT codVinicola FROM Vinicola WHERE nomeVinicola='Vinícola Aurora'  LIMIT 1)),
 ('VF Sauvignon Blanc','Branco',2022, 'Branco de altitude, fresco.',
   (SELECT codVinicola FROM Vinicola WHERE nomeVinicola='Villa Francioni'  LIMIT 1)),
 ('Catena Malbec',     'Tinto', 2019, 'Malbec estruturado de Mendoza.',
   (SELECT codVinicola FROM Vinicola WHERE nomeVinicola='Catena Zapata'   LIMIT 1)),
 ('Douro Clássico',    'Tinto', 2018, 'Blend típico do Douro.',
   (SELECT codVinicola FROM Vinicola WHERE nomeVinicola='Quinta do Bom'   LIMIT 1)),
 ('Chianti Classico',  'Tinto', 2021, 'Sangiovese vibrante da Toscana.',
   (SELECT codVinicola FROM Vinicola WHERE nomeVinicola='Antinori'        LIMIT 1));

-- =========================================================
-- 4) VIEW (junção de vinhos + vinícolas + regiões)
-- =========================================================
DROP VIEW IF EXISTS vw_vinhos_completo;
CREATE OR REPLACE VIEW vw_vinhos_completo AS
SELECT
  v.nomeVinho,
  v.anoVinho,
  vi.nomeVinicola,
  r.nomeRegiao
FROM Vinho v
JOIN Vinicola vi ON vi.codVinicola = v.codVinicola
JOIN Regiao  r  ON r.codRegiao   = vi.codRegiao;

-- =========================================================
-- 5) USUÁRIO RESTRITO (Somellier)
-- =========================================================
DROP USER IF EXISTS 'Somellier'@'localhost';
CREATE USER 'Somellier'@'localhost'
  IDENTIFIED BY 'SuaSenhaForteAqui'   -- Trocar por senha forte!
  WITH MAX_QUERIES_PER_HOUR 40;

-- Remove quaisquer permissões herdadas
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'Somellier'@'localhost';

-- Concede apenas acessos restritos
GRANT SELECT ON loja_vinhos.Vinho TO 'Somellier'@'localhost';
GRANT SELECT (codVinicola, nomeVinicola) ON loja_vinhos.Vinicola TO 'Somellier'@'localhost';

FLUSH PRIVILEGES;

-- =========================================================
-- 6) TESTES (opcionais; podem ser rodados após execução)
-- =========================================================
-- SELECT COUNT(*) AS qtdRegioes  FROM Regiao;      -- Deve retornar 5
-- SELECT COUNT(*) AS qtdVinicolas FROM Vinicola;  -- Deve retornar 5
-- SELECT COUNT(*) AS qtdVinhos    FROM Vinho;     -- Deve retornar 5
-- SELECT * FROM vw_vinhos_completo;               -- Deve listar 5 vinhos com vinícola e região
