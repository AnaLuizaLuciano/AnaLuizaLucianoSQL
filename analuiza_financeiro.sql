-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 18/02/2025 às 21:09
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `analuiza_financeiro`
--
CREATE DATABASE IF NOT EXISTS `analuiza_financeiro` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `analuiza_financeiro`;

DELIMITER $$
--
-- Procedimentos
--
DROP PROCEDURE IF EXISTS `mySp_financeiroDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mySp_financeiroDelete` (`v_id` INT)   BEGIN
if((v_id>0)&&(v_id!='')) THEN
DELETE FROM tbl_financeiro WHERE financeiro_id=v_id;
ELSE
SELECT 'O identificador do registro não foi informado' AS Msg;
END IF;
END$$

DROP PROCEDURE IF EXISTS `mySp_financeiroinsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mySp_financeiroinsert` (`v_nome` VARCHAR(60), `v_cpf` VARCHAR(20))   BEGIN
IF((v_nome!='') && (v_cpf!='')) THEN
INSERT INTO tbl_financeiro
(financeiro_nome, financeiro_cpf)
VALUES
(v_nome, v_cpf);
ELSE
SELECT 'NOME e CPF devem ser fornecidos para o cadastro!'
AS Msg;
END IF;
END$$

DROP PROCEDURE IF EXISTS `mySp_financeiroUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mySp_financeiroUpdate` (`v_id` INT, `v_nome` VARCHAR(60), `v_cpf` VARCHAR(20))   BEGIN
    if(((v_id>0)&&(v_id!=''))&&(v_nome!='')&&(v_cpf!='')) THEN
    UPDATE tbl_financeiro SET financeiro_nome = v_nome, financeiro_cpf = v_cpf
    WHERE financeiro_id = v_id;
    ELSE
    SELECT 'Os novos NOME e CPF devem ser informados!'
    as Msg;
    END IF;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `itensvenda`
--

DROP TABLE IF EXISTS `itensvenda`;
CREATE TABLE `itensvenda` (
  `venda` int(11) DEFAULT NULL,
  `produto` varchar(3) DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `itensvenda`
--
DROP TRIGGER IF EXISTS `Tgr_itensvenda_insert`;
DELIMITER $$
CREATE TRIGGER `Tgr_itensvenda_insert` AFTER INSERT ON `itensvenda` FOR EACH ROW BEGIN
	UPDATE produtos SET estoque = estoque - new.quantidade
WHERE referencia = new.produto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produtos`
--

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos` (
  `referencia` varchar(3) NOT NULL,
  `descricao` varchar(50) DEFAULT NULL,
  `estoque` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produtos`
--

INSERT INTO `produtos` (`referencia`, `descricao`, `estoque`) VALUES
('001', 'Feijão', 10),
('002', 'Arroz', 5),
('003', 'Farinha', 15);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tbl_financeiro`
--

DROP TABLE IF EXISTS `tbl_financeiro`;
CREATE TABLE `tbl_financeiro` (
  `financeiro_id` int(11) NOT NULL,
  `financeiro_nome` varchar(50) DEFAULT NULL,
  `financeiro_cpf` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `tbl_financeiro`
--

INSERT INTO `tbl_financeiro` (`financeiro_id`, `financeiro_nome`, `financeiro_cpf`) VALUES
(1, 'Ana Luiza Luciano Costa', '023.456.789-10'),
(2, 'Aria Stark', '023.456.789-12');

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `v`
-- (Veja abaixo para a visão atual)
--
DROP VIEW IF EXISTS `v`;
CREATE TABLE `v` (
`Qtde` int(11)
,`preco` decimal(10,2)
,`valor` decimal(20,2)
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendas`
--

DROP TABLE IF EXISTS `vendas`;
CREATE TABLE `vendas` (
  `Qtde` int(11) NOT NULL,
  `preco` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendas`
--

INSERT INTO `vendas` (`Qtde`, `preco`) VALUES
(3, 5.45),
(10, 45.00),
(20, 3.50);

-- --------------------------------------------------------

--
-- Estrutura para view `v`
--
DROP TABLE IF EXISTS `v`;

DROP VIEW IF EXISTS `v`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v`  AS SELECT `vendas`.`Qtde` AS `Qtde`, `vendas`.`preco` AS `preco`, `vendas`.`Qtde`* `vendas`.`preco` AS `valor` FROM `vendas` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`referencia`),
  ADD UNIQUE KEY `descricao` (`descricao`);

--
-- Índices de tabela `tbl_financeiro`
--
ALTER TABLE `tbl_financeiro`
  ADD PRIMARY KEY (`financeiro_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `tbl_financeiro`
--
ALTER TABLE `tbl_financeiro`
  MODIFY `financeiro_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
