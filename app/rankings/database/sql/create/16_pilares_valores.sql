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
COMMENT ON TABLE R_PILARES_VALORES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';