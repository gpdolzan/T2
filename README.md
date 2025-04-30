# Trabalho 2: banco de dados usando Ruby e ActiveRecord

Criado por Gabriel Pimentel Dolzan - GRR20209948

## Visão Geral

Esse projeto utiliza o ActiveRecord para criar e manipular um BDSQLite, esse banco criado possui os seguintes relacionamentos:

> 1.  Um para Um: 1 Aluno -> 1 GRR

> 2.  Um para Muitos: 1 Aluno -> n Disciplina

> 3.  Muitos para Muitos: n Disciplinas -> n Departamentos

Com base nas relações acima, temos as seguintes tabelas:

- Aluno
- GRR
- Departamento
- Disciplinas

Também temos os seguintes comandos:

- help
- tabelas
- q
