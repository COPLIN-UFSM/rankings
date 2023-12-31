-- TODO colocar grupos geopolíticos, grupos de universidades, grupos de pilares, etc, nas dimensões!

-- dimensão de rankings
CREATE VIEW R_V_RANKINGS_DIMENSAO (
    ID_RANKING, NOME_RANKING,
    ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES,
    DESCRICAO_PILAR_INGLES, DESCRICAO_PILAR_PORTUGUES
) AS
SELECT
    RR.ID_RANKING, RR.NOME_RANKING,
    RP.ID_PILAR, RP.NOME_PILAR_INGLES, RP.NOME_PILAR_PORTUGUES,
    RP.DESCRICAO_PILAR_INGLES, RP.DESCRICAO_PILAR_PORTUGUES
FROM R_PILARES RP
INNER JOIN R_RANKINGS RR ON RP.ID_RANKING = RR.ID_RANKING;
COMMENT ON TABLE R_V_RANKINGS_DIMENSAO IS 'Parte do conjunto de views da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings;';

-- dimensão de universidades, países e continentes
CREATE VIEW R_V_UNIVERSIDADES_DIMENSAO (
    ID_UNIVERSIDADE, NOME_UNIVERSIDADE_INGLES, NOME_UNIVERSIDADE_PORTUGUES,
    ID_PAIS, NOME_PAIS_PORTUGUES, NOME_PAIS_INGLES,
    ID_CONTINENTE, NOME_CONTINENTE_INGLES, NOME_CONTINENTE_PORTUGUES
) AS
SELECT
    RU.ID_UNIVERSIDADE, RU.NOME_UNIVERSIDADE_INGLES, RU.NOME_UNIVERSIDADE_PORTUGUES,
    RP.ID_PAIS, RP.NOME_PAIS_PORTUGUES, RP.NOME_PAIS_INGLES,
    RC.ID_CONTINENTE, RC.NOME_CONTINENTE_INGLES, RC.NOME_CONTINENTE_PORTUGUES
FROM R_UNIVERSIDADES_APELIDOS RUA
INNER JOIN R_UNIVERSIDADES RU ON RUA.ID_UNIVERSIDADE = RU.ID_UNIVERSIDADE
INNER JOIN R_PAISES_APELIDOS RPA ON RU.ID_APELIDO_PAIS = RPA.ID_APELIDO_PAIS
INNER JOIN R_PAISES RP ON RPA.ID_PAIS = RP.ID_PAIS
INNER JOIN R_CONTINENTES RC ON RP.ID_CONTINENTE = RC.ID_CONTINENTE;
COMMENT ON TABLE R_V_UNIVERSIDADES_DIMENSAO IS 'Parte do conjunto de views da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings;';

-- fatos: valores de pilares
CREATE VIEW R_V_PILARES_VALORES_FATO (
    ID_UNIVERSIDADE, ID_PILAR, ANO, VALOR_INICIAL, VALOR_FINAL
) AS
SELECT RU.ID_UNIVERSIDADE, RPV.ID_PILAR, RPV.ANO, RPV.VALOR_INICIAL, RPV.VALOR_FINAL
FROM R_PILARES_VALORES RPV
INNER JOIN R_UNIVERSIDADES_APELIDOS RUA ON RPV.ID_APELIDO_UNIVERSIDADE = RUA.ID_APELIDO_UNIVERSIDADE
INNER JOIN R_UNIVERSIDADES RU ON RUA.ID_UNIVERSIDADE = RU.ID_UNIVERSIDADE;
COMMENT ON TABLE R_V_PILARES_VALORES_FATO IS 'Parte do conjunto de views da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings;';