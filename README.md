# SQLime no Docker e no Railway

Este projeto publica o [SQLime](https://sqlime.org/), um ambiente relacional SQLite que funciona diretamente no navegador por WebAssembly.

Cada aluno recebe uma sessão independente. O banco e as consultas não ficam automaticamente armazenados no Railway, portanto cada aluno deve exportar ou compartilhar o próprio trabalho.

## Arquivos

```text
sqlime-docker/
├── Dockerfile
├── default.conf.template
├── compose.yaml
├── .dockerignore
└── README.md
```

O `Dockerfile` baixa o código oficial do SQLime e cria uma imagem final com Nginx. O Railway encontra esse arquivo automaticamente.

## Testar localmente

Com o Docker Desktop aberto, execute na pasta do projeto:

```bash
docker compose up -d --build
```

Abra:

```text
http://localhost:8080
```

Para acompanhar os registros:

```bash
docker compose logs -f
```

Para desligar:

```bash
docker compose down
```

## Publicar no Railway

1. Crie um repositório chamado `sqlime-docker` no GitHub.
2. Envie os arquivos deste pacote para a raiz do repositório.
3. No Railway, escolha **New Project**.
4. Selecione **Deploy from GitHub Repo**.
5. Escolha o repositório `sqlime-docker`.
6. Não configure **Pre-deploy Command** nem **Start Command**.
7. Aguarde o build aparecer como **Success**.
8. Entre em **Settings > Networking > Public Networking**.
9. Clique em **Generate Domain** e selecione a porta `8080`.

## Redeploy

Faça uma alteração válida no repositório e confirme um novo commit. O Railway deverá iniciar automaticamente uma nova construção. Também é possível abrir o deployment e escolher **Redeploy**.

## Exemplo para testar

```sql
PRAGMA foreign_keys = ON;

CREATE TABLE cursos (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE alunos (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    curso_id INTEGER,
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

INSERT INTO cursos (nome)
VALUES ('Análise e Desenvolvimento de Sistemas');

INSERT INTO alunos (nome, curso_id)
VALUES
    ('Ana', 1),
    ('Carlos', 1),
    ('Mariana', 1);

SELECT
    alunos.nome AS aluno,
    cursos.nome AS curso
FROM alunos
INNER JOIN cursos
    ON alunos.curso_id = cursos.id;
```

## Créditos

O SQLime é um projeto open source de [nalgeon/sqlime](https://github.com/nalgeon/sqlime), distribuído sob licença MIT. O código oficial é baixado durante a construção da imagem Docker.
