# Projeto SQL Wine Store

Projeto de banco de dados relacional para uma loja de vinhos, cobrindo o pipeline completo de modelagem/modelo conceitual à implementação física e consultas SQL.


---

## 1. Sobre o projeto

Este projeto demonstra a construção completa de um banco de dados relacional, transformando requisitos de negócio em um modelo de dados estruturado, funcional e organizado.
O banco registra e relaciona informações essenciais sobre:

- Vinhos e suas características (nome, tipo, ano, descrição)
- Vinícolas responsáveis pela produção
- Regiões associadas a cada vinícola
- Relacionamentos entre as entidades, preservando a integridade referencial

A modelagem foi pensada para garantir consistência, integridade referencial e facilidade na obtenção de informações relevantes.

---

## 2. O que foi implementado 

Modelo conceitual (DER) representando entidades e relacionamentos
Modelo lógico criado no MySQL Workbench
Modelo físico completo em SQL (DDL + inserts)
Aplicação correta de chaves primárias e estrangeiras
Consultas SQL com JOINs integrando dados entre tabelas
Criação de usuário com permissões restritas (perfil Sommelier)


---

## 3. Estrutura do Repositório

```plaintext
sql-wine-store/
├── modelo_conceitual.png     # Diagrama Entidade-Relacionamento (DER)
├── modelo_logico.png         # Modelo lógico exportado do MySQL Workbench
├── modelo_fisico.sql         # Criação das tabelas + inserção de dados
├── consultas.sql             # Consultas SQL principais
└── usuario_sommelier.sql     # Usuário com permissões restritas

```

## 4. Tecnologias Utilizadas

- MySQL Workbench  
- MySQL Server  
- SQL padrão (DDL, DML e DQL)

---

## 5. Como Executar

Para reproduzir o projeto em qualquer ambiente MySQL:

 1. Crie um schema no MySQL.
 2. Execute o arquivo modelo_fisico.sql para gerar as tabelas e popular os dados.
 3. Utilize consultas.sql para validar as consultas principais
 4. Opcionalmente execute usuario_sommelier.sql para testar o controle de permissões de usuário

---

## 6. Conceitos de SQL aplicados

- Modelagem Entidade-Relacionamento (conceitual → lógico → físico)
- Criação de tabelas com chaves primárias e estrangeiras
- Inserção de dados e restrições de integridade
- Consultas com JOIN entre múltiplas tabelas
- Consultas analíticas cruzando dados de vinhos, vinícolas e regiões.
- Criação de usuário e gerenciamento de permissões (GRANT/REVOKE)

---


