-- continentes, países, subdivisões de países e grupos geopolíticos

CREATE TABLE R_CONTINENTES (
  ID_CONTINENTE INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_CONTINENTE_PORTUGUES TEXT NOT NULL,
  NOME_CONTINENTE_INGLES TEXT NOT NULL
);


CREATE TABLE R_PAISES (
  ID_PAIS INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ID_CONTINENTE INTEGER NOT NULL,
  NOME_PAIS_PORTUGUES TEXT NOT NULL,
  NOME_PAIS_INGLES TEXT NOT NULL,
  FOREIGN KEY (ID_CONTINENTE) REFERENCES R_CONTINENTES(ID_CONTINENTE)
);


CREATE TABLE R_PAISES_APELIDOS_TIPOS (
    ID_TIPO_APELIDO INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    TIPO_APELIDO TEXT NOT NULL
);


CREATE TABLE R_PAISES_APELIDOS (
  ID_APELIDO_PAIS INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ID_TIPO_APELIDO INTEGER NOT NULL,
  APELIDO TEXT NOT NULL,
  ID_PAIS INTEGER NOT NULL,
  FOREIGN KEY (ID_TIPO_APELIDO) REFERENCES R_PAISES_APELIDOS_TIPOS(ID_TIPO_APELIDO),
  FOREIGN KEY (ID_PAIS) REFERENCES R_PAISES(ID_PAIS)
);


CREATE TABLE R_GRUPOS_GEOPOLITICOS (
  ID_GRUPO_GEOPOLITICO INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_GRUPO_PORTUGUES TEXT NOT NULL,
  NOME_GRUPO_INGLES TEXT NOT NULL,
  SIGLA TEXT DEFAULT NULL
);


CREATE TABLE R_PAISES_PARA_GRUPOS_GEOPOLITICOS (
  ID_GRUPO_GEOPOLITICO INTEGER NOT NULL,
  ID_PAIS INTEGER NOT NULL,
  PRIMARY KEY (ID_GRUPO_GEOPOLITICO, ID_PAIS),
  FOREIGN KEY (ID_GRUPO_GEOPOLITICO) REFERENCES R_GRUPOS_GEOPOLITICOS (ID_GRUPO_GEOPOLITICO),
  FOREIGN KEY (ID_PAIS) REFERENCES R_PAISES(ID_PAIS)
);


-- universidades e seus grupos

CREATE TABLE R_UNIVERSIDADES (
  ID_UNIVERSIDADE INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_UNIVERSIDADE_PORTUGUES TEXT NOT NULL,
  NOME_UNIVERSIDADE_INGLES TEXT NOT NULL,
  SIGLA TEXT DEFAULT NULL,
  ID_APELIDO_PAIS INTEGER NOT NULL,
  FOREIGN KEY (ID_APELIDO_PAIS) REFERENCES R_PAISES_APELIDOS(ID_APELIDO_PAIS)
);


CREATE TABLE R_UNIVERSIDADES_APELIDOS (
  ID_APELIDO_UNIVERSIDADE INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ID_UNIVERSIDADE INTEGER NOT NULL,
  APELIDO TEXT NOT NULL,
  FOREIGN KEY (ID_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES(ID_UNIVERSIDADE)
);


CREATE TABLE R_UNIVERSIDADES_GRUPOS (
  ID_GRUPO_UNIVERSIDADES INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_GRUPO_PORTUGUES TEXT NOT NULL,
  NOME_GRUPO_INGLES TEXT NOT NULL
);


CREATE TABLE R_UNIVERSIDADES_PARA_GRUPOS (
  ID_UNIVERSIDADE INTEGER NOT NULL,
  ID_GRUPO_UNIVERSIDADES INTEGER NOT NULL,
  PRIMARY KEY (ID_UNIVERSIDADE, ID_GRUPO_UNIVERSIDADES),
  FOREIGN KEY (ID_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES(ID_UNIVERSIDADE),
  FOREIGN KEY (ID_GRUPO_UNIVERSIDADES) REFERENCES R_UNIVERSIDADES_GRUPOS(ID_GRUPO_UNIVERSIDADES)
);


-- rankings e métricas

CREATE TABLE R_RANKINGS (
  ID_RANKING INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_RANKING TEXT UNIQUE NOT NULL
);


CREATE TABLE R_PILARES (
  ID_PILAR INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  ID_RANKING INTEGER NOT NULL,
  NOME_PILAR_PORTUGUES TEXT NOT NULL,
  NOME_PILAR_INGLES TEXT NOT NULL,
  DESCRICAO_PILAR_PORTUGUES TEXT DEFAULT NULL,
  DESCRICAO_PILAR_INGLES TEXT DEFAULT NULL,
  FOREIGN KEY (ID_RANKING) REFERENCES R_RANKINGS(ID_RANKING)
);


CREATE TABLE R_METRICAS (
  ID_METRICA INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_METRICA_PORTUGUES TEXT NOT NULL,
  NOME_METRICA_INGLES TEXT NOT NULL,
  DESCRICAO_METRICA_PORTUGUES TEXT DEFAULT NULL,
  DESCRICAO_METRICA_INGLES TEXT DEFAULT NULL
);


CREATE TABLE R_PILARES_GRUPOS (
  ID_GRUPO_PILARES INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_GRUPO_PORTUGUES TEXT NOT NULL,
  NOME_GRUPO_INGLES TEXT NOT NULL
);


CREATE TABLE R_PILARES_PARA_GRUPOS (
  ID_PILAR INTEGER NOT NULL,
  ID_GRUPO_PILARES INTEGER NOT NULL,
  PRIMARY KEY (ID_PILAR, ID_GRUPO_PILARES),
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR),
  FOREIGN KEY (ID_GRUPO_PILARES) REFERENCES R_PILARES_GRUPOS(ID_GRUPO_PILARES)
);


CREATE TABLE R_METRICAS_PARA_PILARES (
  ID_METRICA INTEGER NOT NULL,
  ID_PILAR INTEGER NOT NULL,
  PESO REAL NOT NULL,
  PRIMARY KEY (ID_PILAR, ID_METRICA),
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR),
  FOREIGN KEY (ID_METRICA) REFERENCES R_METRICAS(ID_METRICA)
);


CREATE TABLE R_PILARES_VALORES (
  ID_APELIDO_UNIVERSIDADE INTEGER NOT NULL,
  ID_PILAR INTEGER NOT NULL,
  ANO INTEGER NOT NULL,
  VALOR_INICIAL REAL DEFAULT NULL,  -- valor final do intervalo caso o pilar possua um intervalo de valores
  VALOR_FINAL REAL DEFAULT NULL,  -- valor final do intervalo caso o pilar possua um intervalo de valores
  PRIMARY KEY (ID_APELIDO_UNIVERSIDADE, ID_PILAR, ANO),
  FOREIGN KEY (ID_APELIDO_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES_APELIDOS(ID_APELIDO_UNIVERSIDADE),
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR)
);


CREATE TABLE R_METRICAS_VALORES (
  ID_APELIDO_UNIVERSIDADE INTEGER NOT NULL,
  ID_METRICA INTEGER NOT NULL,
  ANO INTEGER NOT NULL,
  VALOR_INICIAL REAL DEFAULT NULL,
  VALOR_FINAL REAL DEFAULT NULL,
  PRIMARY KEY (ID_APELIDO_UNIVERSIDADE, ID_METRICA, ANO),
  FOREIGN KEY (ID_APELIDO_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES_APELIDOS(ID_APELIDO_UNIVERSIDADE),
  FOREIGN KEY (ID_METRICA) REFERENCES R_METRICAS(ID_METRICA)
);


-- tabelas estruturas genéricas - evitar ao máximo seu uso

CREATE TABLE R_TIPOS_METADADOS (
  ID_TIPO_METADADO INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_TIPO_METADADO TEXT NOT NULL
);


CREATE TABLE R_TIPOS_ENTIDADES (
  ID_TIPO_ENTIDADE INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  NOME_TIPO_ENTIDADE TEXT NOT NULL
);


CREATE TABLE R_METADADOS (
  ID_METADADO INTEGER NOT NULL,
  ID_TIPO_METADADO INTEGER NOT NULL,
  ID_TIPO_ENTIDADE INTEGER NOT NULL,
  ID_ENTIDADE INTEGER DEFAULT NULL NOT NULL,
  ANO INTEGER NOT NULL,
  VALOR TEXT DEFAULT NULL,
  PRIMARY KEY (ID_METADADO, ID_TIPO_METADADO, ID_TIPO_ENTIDADE, ANO),
  FOREIGN KEY (ID_TIPO_METADADO) REFERENCES R_TIPOS_METADADOS(ID_TIPO_METADADO),
  FOREIGN KEY (ID_TIPO_ENTIDADE) REFERENCES R_TIPOS_ENTIDADES(ID_TIPO_ENTIDADE)
);


CREATE TABLE R_FORMULARIOS (
    ID_FORMULARIO INTEGER NOT NULL PRIMARY KEY,
    ID_RANKING INTEGER NOT NULL,
    FORMULARIO TEXT NOT NULL,
    DATA TEXT NOT NULL,
    FOREIGN KEY (ID_RANKING) REFERENCES R_RANKINGS(ID_RANKING)
);


