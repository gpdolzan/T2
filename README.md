# Trabalho 2: banco de dados usando Ruby e ActiveRecord

Criado por Gabriel Pimentel Dolzan - GRR20209948

## Visão Geral

Esse projeto utiliza o ActiveRecord para criar e manipular um BD SQLite, esse banco criado possui os seguintes relacionamentos:

> 1.  Um para Um: 1 Aluno -> 1 GRR

> 2.  Um para Muitos: 1 Aluno -> n Disciplina

> 3.  Muitos para Muitos: m Disciplinas -> n Departamentos

Com base nas relações acima, temos as seguintes tabelas:

- Aluno
- GRR
- Departamento
- Disciplinas

Também temos os seguintes comandos:

- help
- tabelas
- quit
- exclui
- insere
- altera
- lista

Para não perder muito tempo aqui, basta saber que cada um destes comandos e sua funcionalidade estão sendo explicado dentro do próprio programa.

### Associação M N (Muitos para Muitos)

No programa pode consultar essa associação a parte com o comando:

- lista dep_disc

Para criar associação o seguinte comando funciona:

- associa_dep_disc dept_id=id disciplina_id=id

Como falei acima, basta ler a documentação e do programa em execução que fará sentido como funciona a utilização do programa.

## Explicação do Código

Dentro da pasta modelos tem os códigos dos modelos do BD que estou criando. Você pode ler ali em cima sobre os relacionamentos dessas tabelas acima.

O arquivo setup.rb é o arquivo que inicia e popula o DB.

O arquivo runner.rb é o arquivo principal do programa. Ele exibe a lista de comandos disponíveis e está constantemente em um loop de execução de comandos, seja para manipular o BD ou apenas listar os itens. Esse loop é quebrado quando o usuário digita 'exit' e o programa finaliza.

## Como Rodar

Para rodar o programa basta você rodar o script `inicial.sh`, esse script inicia o BD em seu estado padrão (hard-coded) toda vez que você rodar ele. Só inicie o programa utilizando esse arquivo inicial, caso contrário o programa não irá funcionar.

Qualquer dúvida relacionada ao funcionamento do programa, pode mandar um e-mail para mim (gpd20@inf.ufpr.br) que eu respondo o mais rápido possível.
