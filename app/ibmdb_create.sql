-- continentes, países, subdivisões de países e grupos geopolíticos
CREATE TABLE R_CONTINENTES (
  ID_CONTINENTE INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_CONTINENTE_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_CONTINENTE_INGLES VARCHAR(255) NOT NULL
);
COMMENT ON TABLE R_CONTINENTES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_PAISES (
  ID_PAIS INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  ID_CONTINENTE INTEGER NOT NULL,
  NOME_PAIS_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_PAIS_INGLES VARCHAR(255) NOT NULL,
  FOREIGN KEY (ID_CONTINENTE) REFERENCES R_CONTINENTES(ID_CONTINENTE)
);
COMMENT ON TABLE R_PAISES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_PAISES_APELIDOS_TIPOS (
    ID_TIPO_APELIDO INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    TIPO_APELIDO VARCHAR(255) NOT NULL
);
COMMENT ON TABLE R_PAISES_APELIDOS_TIPOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_PAISES_APELIDOS (
  ID_APELIDO_PAIS INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  ID_TIPO_APELIDO INTEGER NOT NULL,
  APELIDO VARCHAR(255) NOT NULL,
  ID_PAIS INTEGER NOT NULL,
  FOREIGN KEY (ID_TIPO_APELIDO) REFERENCES R_PAISES_APELIDOS_TIPOS(ID_TIPO_APELIDO),
  FOREIGN KEY (ID_PAIS) REFERENCES R_PAISES(ID_PAIS)
);
COMMENT ON TABLE R_PAISES_APELIDOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_GRUPOS_GEOPOLITICOS (
  ID_GRUPO_GEOPOLITICO INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_GRUPO_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_GRUPO_INGLES VARCHAR(255) NOT NULL,
  SIGLA VARCHAR(255) DEFAULT NULL
);
COMMENT ON TABLE R_GRUPOS_GEOPOLITICOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_PAISES_PARA_GRUPOS_GEOPOLITICOS (
  ID_GRUPO_GEOPOLITICO INTEGER NOT NULL,
  ID_PAIS INTEGER NOT NULL,
  PRIMARY KEY (ID_GRUPO_GEOPOLITICO, ID_PAIS),
  FOREIGN KEY (ID_GRUPO_GEOPOLITICO) REFERENCES R_GRUPOS_GEOPOLITICOS (ID_GRUPO_GEOPOLITICO),
  FOREIGN KEY (ID_PAIS) REFERENCES R_PAISES(ID_PAIS)
);
COMMENT ON TABLE R_PAISES_PARA_GRUPOS_GEOPOLITICOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

-- universidades e seus grupos
CREATE TABLE R_UNIVERSIDADES (
  ID_UNIVERSIDADE INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_UNIVERSIDADE_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_UNIVERSIDADE_INGLES VARCHAR(255) NOT NULL,
  SIGLA VARCHAR(255) DEFAULT NULL,
  ID_APELIDO_PAIS INTEGER NOT NULL,
  FOREIGN KEY (ID_APELIDO_PAIS) REFERENCES R_PAISES_APELIDOS(ID_APELIDO_PAIS)
);
COMMENT ON TABLE R_UNIVERSIDADES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_UNIVERSIDADES_APELIDOS (
  ID_APELIDO_UNIVERSIDADE INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  ID_UNIVERSIDADE INTEGER NOT NULL,
  APELIDO VARCHAR(255) NOT NULL,
  FOREIGN KEY (ID_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES(ID_UNIVERSIDADE)
);
COMMENT ON TABLE R_UNIVERSIDADES_APELIDOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_UNIVERSIDADES_GRUPOS (
  ID_GRUPO_UNIVERSIDADES INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_GRUPO_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_GRUPO_INGLES VARCHAR(255) NOT NULL
);
COMMENT ON TABLE R_UNIVERSIDADES_GRUPOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_UNIVERSIDADES_PARA_GRUPOS (
  ID_UNIVERSIDADE INTEGER NOT NULL,
  ID_GRUPO_UNIVERSIDADES INTEGER NOT NULL,
  PRIMARY KEY (ID_UNIVERSIDADE, ID_GRUPO_UNIVERSIDADES),
  FOREIGN KEY (ID_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES(ID_UNIVERSIDADE),
  FOREIGN KEY (ID_GRUPO_UNIVERSIDADES) REFERENCES R_UNIVERSIDADES_GRUPOS(ID_GRUPO_UNIVERSIDADES)
);
COMMENT ON TABLE R_UNIVERSIDADES_PARA_GRUPOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

-- rankings e métricas
CREATE TABLE R_RANKINGS (
  ID_RANKING INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_RANKING VARCHAR(255) UNIQUE NOT NULL
);
COMMENT ON TABLE R_RANKINGS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_PILARES (
  ID_PILAR INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  ID_RANKING INTEGER NOT NULL,
  NOME_PILAR_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_PILAR_INGLES VARCHAR(255) NOT NULL,
  DESCRICAO_PILAR_PORTUGUES VARCHAR(255) DEFAULT NULL,
  DESCRICAO_PILAR_INGLES VARCHAR(255) DEFAULT NULL,
  FOREIGN KEY (ID_RANKING) REFERENCES R_RANKINGS(ID_RANKING)
);
COMMENT ON TABLE R_PILARES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_METRICAS (
  ID_METRICA INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_METRICA_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_METRICA_INGLES VARCHAR(255) NOT NULL,
  DESCRICAO_METRICA_PORTUGUES VARCHAR(255) DEFAULT NULL,
  DESCRICAO_METRICA_INGLES VARCHAR(255) DEFAULT NULL
);
COMMENT ON TABLE R_METRICAS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_PILARES_GRUPOS (
  ID_GRUPO_PILARES INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_GRUPO_PORTUGUES VARCHAR(255) NOT NULL,
  NOME_GRUPO_INGLES VARCHAR(255) NOT NULL
);
COMMENT ON TABLE R_PILARES_GRUPOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_PILARES_PARA_GRUPOS (
  ID_PILAR INTEGER NOT NULL,
  ID_GRUPO_PILARES INTEGER NOT NULL,
  PRIMARY KEY (ID_PILAR, ID_GRUPO_PILARES),
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR),
  FOREIGN KEY (ID_GRUPO_PILARES) REFERENCES R_PILARES_GRUPOS(ID_GRUPO_PILARES)
);
COMMENT ON TABLE R_PILARES_PARA_GRUPOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_METRICAS_PARA_PILARES (
  ID_METRICA INTEGER NOT NULL,
  ID_PILAR INTEGER NOT NULL,
  PESO REAL NOT NULL,
  PRIMARY KEY (ID_PILAR, ID_METRICA),
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR),
  FOREIGN KEY (ID_METRICA) REFERENCES R_METRICAS(ID_METRICA)
);
COMMENT ON TABLE R_METRICAS_PARA_PILARES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

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
COMMENT ON TABLE R_METRICAS_VALORES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

-- tabelas estruturas genéricas - evitar ao máximo seu uso
CREATE TABLE R_TIPOS_METADADOS (
  ID_TIPO_METADADO INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_TIPO_METADADO VARCHAR(255) NOT NULL
);
COMMENT ON TABLE R_TIPOS_METADADOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_TIPOS_ENTIDADES (
  ID_TIPO_ENTIDADE INTEGER NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NOME_TIPO_ENTIDADE VARCHAR(255) NOT NULL
);
COMMENT ON TABLE R_TIPOS_ENTIDADES IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_METADADOS (
  ID_METADADO INTEGER NOT NULL,
  ID_TIPO_METADADO INTEGER NOT NULL,
  ID_TIPO_ENTIDADE INTEGER NOT NULL,
  ID_ENTIDADE INTEGER DEFAULT NULL NOT NULL,
  ANO INTEGER NOT NULL,
  VALOR VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (ID_METADADO, ID_TIPO_METADADO, ID_TIPO_ENTIDADE, ANO),
  FOREIGN KEY (ID_TIPO_METADADO) REFERENCES R_TIPOS_METADADOS(ID_TIPO_METADADO),
  FOREIGN KEY (ID_TIPO_ENTIDADE) REFERENCES R_TIPOS_ENTIDADES(ID_TIPO_ENTIDADE)
);
COMMENT ON TABLE R_METADADOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

CREATE TABLE R_FORMULARIOS (
    ID_FORMULARIO INTEGER NOT NULL PRIMARY KEY,
    ID_RANKING INTEGER NOT NULL,
    FORMULARIO VARCHAR(255) NOT NULL,
    DATA VARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_RANKING) REFERENCES R_RANKINGS(ID_RANKING)
);
COMMENT ON TABLE R_FORMULARIOS IS 'Parte do conjunto de tabelas da aplicação Rankings. Para mais informações, consulte https://github.com/COPLIN-UFSM/rankings';

INSERT INTO R_CONTINENTES(NOME_CONTINENTE_PORTUGUES, NOME_CONTINENTE_INGLES) VALUES
    ('África', 'Africa'),
    ('América Central e Caribe', 'Central America and the Caribbean'),
    ('Ásia', 'Asia'),
    ('Europa', 'Europe'),
    ('Oceania', 'Oceania'),
    ('América do Sul', 'South America'),
    ('América do Norte', 'North America');

INSERT INTO R_PAISES_APELIDOS_TIPOS(TIPO_APELIDO) VALUES
    ('Nome alternativo'),
    ('Subdivisão');

INSERT INTO R_PAISES(NOME_PAIS_PORTUGUES, NOME_PAIS_INGLES, ID_CONTINENTE) VALUES
    ('Afeganistão','Afghanistan',3),
    ('África do Sul','South Africa',1),
    ('Albânia','Albania',4),
    ('Alemanha','Germany',4),
    ('Andorra','Andorra',4),
    ('Angola','Angola',1),
    ('Antígua e Barbuda','Antigua and Barbuda',2),
    ('Arábia Saudita','Saudi Arabia',3),
    ('Argélia','Algeria',1),
    ('Argentina','Argentina',6),
    ('Armênia','Armenia',4),
    ('Austrália','Australia',5),
    ('Áustria','Austria',4),
    ('Azerbaijão','Azerbaijan',3),
    ('Bahamas','Bahamas',2),
    ('Bangladeche','Bangladesh',3),
    ('Barbados','Barbados',2),
    ('Barém','Bahrain',3),
    ('Bélgica','Belgium',4),
    ('Belize','Belize',2),
    ('Benim','Benin',1),
    ('Bielorrússia','Belarus',4),
    ('Bolívia','Bolivia',6),
    ('Bósnia e Herzegovina','Bosnia and Herzegovina',4),
    ('Botsuana','Botswana',1),
    ('Brasil','Brazil',6),
    ('Brunei','Brunei',3),
    ('Bulgária','Bulgaria',4),
    ('Burquina Faso','Burkina Faso',1),
    ('Burúndi','Burundi',1),
    ('Butão','Bhutan',3),
    ('Cabo Verde','Cape Verde',1),
    ('Camarões','Cameroon',1),
    ('Camboja','Cambodia',3),
    ('Canadá','Canada',7),
    ('Catar','Qatar',3),
    ('Cazaquistão','Kazakhstan',3),
    ('Chade','Chad',1),
    ('Chile','Chile',6),
    ('China','China',3),
    ('Chipre','Cyprus',4),
    ('Colômbia','Colombia',6),
    ('Comores','Comoros',1),
    ('Coreia do Norte','North Korea',3),
    ('Coreia do Sul','South Korea',3),
    ('Costa do Marfim','Ivory Coast',1),
    ('Costa Rica','Costa Rica',2),
    ('Croácia','Croatia',4),
    ('Cuba','Cuba',2),
    ('Dinamarca','Denmark',4),
    ('Dominica','Dominica',2),
    ('Egito','Egypt',1),
    ('Emirados Árabes Unidos','United Arab Emirates',3),
    ('Equador','Ecuador',6),
    ('Eritreia','Eritrea',1),
    ('Eslováquia','Slovakia',4),
    ('Eslovênia','Slovenia',4),
    ('Espanha','Spain',4),
    ('Estados Unidos','United States',7),
    ('Estônia','Estonia',4),
    ('Eswatini','Eswatini',1),
    ('Etiópia','Ethiopia',1),
    ('Fiji','Fiji',5),
    ('Filipinas','Philippines',3),
    ('Finlândia','Finland',4),
    ('França','France',4),
    ('Gabão','Gabon',1),
    ('Gâmbia','Gambia',1),
    ('Gana','Ghana',1),
    ('Geórgia','Georgia',3),
    ('Granada','Grenada',2),
    ('Grécia','Greece',4),
    ('Guatemala','Guatemala',2),
    ('Guiana','Guyana',6),
    ('Guiné','Guinea',1),
    ('Guiné Equatorial','Equatorial Guinea',1),
    ('Guiné-Bissau','Guinea-Bissau',1),
    ('Haiti','Haiti',2),
    ('Honduras','Honduras',2),
    ('Hungria','Hungary',4),
    ('Iêmen','Yemen',3),
    ('Ilhas Marshall','Marshall Islands',5),
    ('Ilhas Salomão','Solomon Islands',5),
    ('Índia','India',3),
    ('Indonésia','Indonesia',3),
    ('Irã','Iran',3),
    ('Iraque','Iraq',3),
    ('Irlanda','Ireland',4),
    ('Islândia','Iceland',4),
    ('Israel','Israel',3),
    ('Itália','Italy',4),
    ('Jamaica','Jamaica',2),
    ('Japão','Japan',3),
    ('Jibuti','Djibouti',1),
    ('Jordânia','Jordan',3),
    ('Kosovo','Kosovo',4),
    ('Kuwait','Kuwait',3),
    ('Laos','Laos',5),
    ('Lesoto','Lesotho',1),
    ('Letônia','Latvia',4),
    ('Líbano','Lebanon',3),
    ('Libéria','Liberia',1),
    ('Líbia','Libya',1),
    ('Liechtenstein','Liechtenstein',4),
    ('Lituânia','Lithuania',4),
    ('Luxemburgo','Luxembourg',4),
    ('Macedônia do Norte','North Macedonia',4),
    ('Madagascar','Madagascar',1),
    ('Malásia','Malaysia',3),
    ('Malávi','Malawi',1),
    ('Maldivas','Maldives',3),
    ('Mali','Mali',1),
    ('Malta','Malta',4),
    ('Marrocos','Morocco',1),
    ('Maurícia','Mauritius',1),
    ('Mauritânia','Mauritania',1),
    ('México','Mexico',7),
    ('Micronésia','Micronesia',5),
    ('Moçambique','Mozambique',1),
    ('Moldávia','Moldova',4),
    ('Mônaco','Monaco',4),
    ('Mongólia','Mongolia',3),
    ('Montenegro','Montenegro',4),
    ('Myanmar','Myanmar',3),
    ('Namíbia','Namibia',1),
    ('Nauru','Nauru',5),
    ('Nepal','Nepal',3),
    ('Nicarágua','Nicaragua',2),
    ('Níger','Niger',1),
    ('Nigéria','Nigeria',1),
    ('Noruega','Norway',4),
    ('Nova Zelândia','New Zealand',5),
    ('Omã','Oman',3),
    ('Países Baixos','Netherlands',5),
    ('Palau','Palau',5),
    ('Panamá','Panama',2),
    ('Papua-Nova Guiné','Papua New Guinea',5),
    ('Paquistão','Pakistan',3),
    ('Paraguai','Paraguay',6),
    ('Peru','Peru',6),
    ('Polônia','Poland',4),
    ('Portugal','Portugal',4),
    ('Quênia','Kenya',1),
    ('Quirguistão','Kyrgyzstan',3),
    ('Quiribáti','Kiribati',5),
    ('Reino Unido','United Kingdom',4),
    ('República Centro-Africana','Central African Republic',1),
    ('República Checa','Czech Republic',4),
    ('República Democrática do Congo','Democratic Republic of the Congo',1),
    ('República do Congo','Republic of the Congo',1),
    ('República Dominicana','Dominican Republic',2),
    ('Romênia','Romania',4),
    ('Ruanda','Rwanda',1),
    ('Rússia','Russia',4),
    ('Salisbúria do Norte','North Salisbury',1),
    ('Samoa','Samoa',5),
    ('Santa Lúcia','Saint Lucia',2),
    ('São Cristóvão e Neves','Saint Kitts and Nevis',2),
    ('San Marino','San Marino',4),
    ('São Tomé e Príncipe','São Tomé and Príncipe',1),
    ('São Vicente e Granadinas','Saint Vincent and the Grenadines',2),
    ('Seicheles','Seychelles',1),
    ('Senegal','Senegal',1),
    ('Serra Leoa','Sierra Leone',4),
    ('Sérvia','Serbia',4),
    ('Singapura','Singapore',3),
    ('Síria','Syria',3),
    ('Somália','Somalia',3),
    ('Sri Lanka','Sri Lanka',3),
    ('Sudão','Sudan',1),
    ('Sudão do Sul','South Sudan',1),
    ('Suécia','Sweden',4),
    ('Suíça','Switzerland',4),
    ('Suriname','Suriname',6),
    ('Tailândia','Thailand',3),
    ('Taiwan','Taiwan',3),
    ('Tajiquistão','Tajikistan',3),
    ('Tanzânia','Tanzania',1),
    ('Timor-Leste','Timor-Leste',3),
    ('Togo','Togo',1),
    ('Tonga','Tonga',5),
    ('Trinidade e Tobago','Trinidad and Tobago',2),
    ('Tunísia','Tunisia',1),
    ('Turcomenistão','Turkmenistan',3),
    ('Turquia','Turkey',3),
    ('Tuvalu','Tuvalu',5),
    ('Ucrânia','Ukraine',4),
    ('Uganda','Uganda',1),
    ('Uruguai','Uruguay',6),
    ('Uzbequistão','Uzbekistan',3),
    ('Vanuatu','Vanuatu',5),
    ('Vaticano','Vatican',4),
    ('Venezuela','Venezuela',6),
    ('Vietnã','Vietnam',3),
    ('Zâmbia','Zambia',1),
    ('Zimbábue','Zimbabwe',1),
    ('Palestina','Palestine',3),
    ('El Salvador','El Salvador', 2);

INSERT INTO R_PAISES_APELIDOS(ID_TIPO_APELIDO, ID_PAIS, APELIDO) VALUES
    (1, 1,'Afeganistão'),
    (1, 2,'África do Sul'),
    (1, 3,'Albânia'),
    (1, 4,'Alemanha'),
    (1, 5,'Andorra'),
    (1, 6,'Angola'),
    (1, 7,'Antígua e Barbuda'),
    (1, 8,'Arábia Saudita'),
    (1, 9,'Argélia'),
    (1, 10,'Argentina'),
    (1, 11,'Armênia'),
    (1, 12,'Austrália'),
    (1, 13,'Áustria'),
    (1, 14,'Azerbaijão'),
    (1, 15,'Bahamas'),
    (1, 16,'Bangladeche'),
    (1, 17,'Barbados'),
    (1, 18,'Barém'),
    (1, 19,'Bélgica'),
    (1, 20,'Belize'),
    (1, 21,'Benim'),
    (1, 22,'Bielorrússia'),
    (1, 23,'Bolívia'),
    (1, 24,'Bósnia e Herzegovina'),
    (1, 25,'Botsuana'),
    (1, 26,'Brasil'),
    (1, 27,'Brunei'),
    (1, 28,'Bulgária'),
    (1, 29,'Burquina Faso'),
    (1, 30,'Burúndi'),
    (1, 31,'Butão'),
    (1, 32,'Cabo Verde'),
    (1, 33,'Camarões'),
    (1, 34,'Camboja'),
    (1, 35,'Canadá'),
    (1, 36,'Catar'),
    (1, 37,'Cazaquistão'),
    (1, 38,'Chade'),
    (1, 39,'Chile'),
    (1, 40,'China'),
    (1, 41,'Chipre'),
    (1, 42,'Colômbia'),
    (1, 43,'Comores'),
    (1, 44,'Coreia do Norte'),
    (1, 45,'Coreia do Sul'),
    (1, 46,'Costa do Marfim'),
    (1, 47,'Costa Rica'),
    (1, 48,'Croácia'),
    (1, 49,'Cuba'),
    (1, 50,'Dinamarca'),
    (1, 51,'Dominica'),
    (1, 52,'Egito'),
    (1, 53,'Emirados Árabes Unidos'),
    (1, 54,'Equador'),
    (1, 55,'Eritreia'),
    (1, 56,'Eslováquia'),
    (1, 57,'Eslovênia'),
    (1, 58,'Espanha'),
    (1, 59,'Estados Unidos'),
    (1, 60,'Estônia'),
    (1, 61,'Eswatini'),
    (1, 62,'Etiópia'),
    (1, 63,'Fiji'),
    (1, 64,'Filipinas'),
    (1, 65,'Finlândia'),
    (1, 66,'França'),
    (1, 67,'Gabão'),
    (1, 68,'Gâmbia'),
    (1, 69,'Gana'),
    (1, 70,'Geórgia'),
    (1, 71,'Granada'),
    (1, 72,'Grécia'),
    (1, 73,'Guatemala'),
    (1, 74,'Guiana'),
    (1, 75,'Guiné'),
    (1, 76,'Guiné Equatorial'),
    (1, 77,'Guiné-Bissau'),
    (1, 78,'Haiti'),
    (1, 79,'Honduras'),
    (1, 80,'Hungria'),
    (1, 81,'Iêmen'),
    (1, 82,'Ilhas Marshall'),
    (1, 83,'Ilhas Salomão'),
    (1, 84,'Índia'),
    (1, 85,'Indonésia'),
    (1, 86,'Irã'),
    (1, 87,'Iraque'),
    (1, 88,'Irlanda'),
    (1, 89,'Islândia'),
    (1, 90,'Israel'),
    (1, 91,'Itália'),
    (1, 92,'Jamaica'),
    (1, 93,'Japão'),
    (1, 94,'Jibuti'),
    (1, 95,'Jordânia'),
    (1, 96,'Kosovo'),
    (1, 97,'Kuwait'),
    (1, 98,'Laos'),
    (1, 99,'Lesoto'),
    (1, 100,'Letônia'),
    (1, 101,'Líbano'),
    (1, 102,'Libéria'),
    (1, 103,'Líbia'),
    (1, 104,'Liechtenstein'),
    (1, 105,'Lituânia'),
    (1, 106,'Luxemburgo'),
    (1, 107,'Macedônia do Norte'),
    (1, 108,'Madagascar'),
    (1, 109,'Malásia'),
    (1, 110,'Malávi'),
    (1, 111,'Maldivas'),
    (1, 112,'Mali'),
    (1, 113,'Malta'),
    (1, 114,'Marrocos'),
    (1, 115,'Maurícia'),
    (1, 116,'Mauritânia'),
    (1, 117,'México'),
    (1, 118,'Micronésia'),
    (1, 119,'Moçambique'),
    (1, 120,'Moldávia'),
    (1, 121,'Mônaco'),
    (1, 122,'Mongólia'),
    (1, 123,'Montenegro'),
    (1, 124,'Myanmar'),
    (1, 125,'Namíbia'),
    (1, 126,'Nauru'),
    (1, 127,'Nepal'),
    (1, 128,'Nicarágua'),
    (1, 129,'Níger'),
    (1, 130,'Nigéria'),
    (1, 131,'Noruega'),
    (1, 132,'Nova Zelândia'),
    (1, 133,'Omã'),
    (1, 134,'Países Baixos'),
    (1, 135,'Palau'),
    (1, 136,'Panamá'),
    (1, 137,'Papua-Nova Guiné'),
    (1, 138,'Paquistão'),
    (1, 139,'Paraguai'),
    (1, 140,'Peru'),
    (1, 141,'Polônia'),
    (1, 142,'Portugal'),
    (1, 143,'Quênia'),
    (1, 144,'Quirguistão'),
    (1, 145,'Quiribáti'),
    (1, 146,'Reino Unido'),
    (1, 147,'República Centro-Africana'),
    (1, 148,'República Checa'),
    (1, 149,'República Democrática do Congo'),
    (1, 150,'República do Congo'),
    (1, 151,'República Dominicana'),
    (1, 152,'Romênia'),
    (1, 153,'Ruanda'),
    (1, 154,'Rússia'),
    (1, 155,'Salisbúria do Norte'),
    (1, 156,'Samoa'),
    (1, 157,'Santa Lúcia'),
    (1, 158,'São Cristóvão e Neves'),
    (1, 159,'San Marino'),
    (1, 160,'São Tomé e Príncipe'),
    (1, 161,'São Vicente e Granadinas'),
    (1, 162,'Seicheles'),
    (1, 163,'Senegal'),
    (1, 164,'Serra Leoa'),
    (1, 165,'Sérvia'),
    (1, 166,'Singapura'),
    (1, 167,'Síria'),
    (1, 168,'Somália'),
    (1, 169,'Sri Lanka'),
    (1, 170,'Sudão'),
    (1, 171,'Sudão do Sul'),
    (1, 172,'Suécia'),
    (1, 173,'Suíça'),
    (1, 174,'Suriname'),
    (1, 175,'Tailândia'),
    (1, 176,'Taiwan'),
    (1, 177,'Tajiquistão'),
    (1, 178,'Tanzânia'),
    (1, 179,'Timor-Leste'),
    (1, 180,'Togo'),
    (1, 181,'Tonga'),
    (1, 182,'Trinidade e Tobago'),
    (1, 183,'Tunísia'),
    (1, 184,'Turcomenistão'),
    (1, 185,'Turquia'),
    (1, 186,'Tuvalu'),
    (1, 187,'Ucrânia'),
    (1, 188,'Uganda'),
    (1, 189,'Uruguai'),
    (1, 190,'Uzbequistão'),
    (1, 191,'Vanuatu'),
    (1, 192,'Vaticano'),
    (1, 193,'Venezuela'),
    (1, 194,'Vietnã'),
    (1, 195,'Zâmbia'),
    (1, 196,'Zimbábue'),
    (1, 1,'Afghanistan'),
    (1, 2,'South Africa'),
    (1, 3,'Albania'),
    (1, 4,'Germany'),
    (1, 5,'Andorra'),
    (1, 6,'Angola'),
    (1, 7,'Antigua and Barbuda'),
    (1, 8,'Saudi Arabia'),
    (1, 9,'Algeria'),
    (1, 10,'Argentina'),
    (1, 11,'Armenia'),
    (1, 12,'Australia'),
    (1, 13,'Austria'),
    (1, 14,'Azerbaijan'),
    (1, 15,'Bahamas'),
    (1, 16,'Bangladesh'),
    (1, 17,'Barbados'),
    (1, 18,'Bahrain'),
    (1, 19,'Belgium'),
    (1, 20,'Belize'),
    (1, 21,'Benin'),
    (1, 22,'Belarus'),
    (1, 23,'Bolivia'),
    (1, 24,'Bosnia and Herzegovina'),
    (1, 25,'Botswana'),
    (1, 26,'Brazil'),
    (1, 27,'Brunei'),
    (1, 28,'Bulgaria'),
    (1, 29,'Burkina Faso'),
    (1, 30,'Burundi'),
    (1, 31,'Bhutan'),
    (1, 32,'Cape Verde'),
    (1, 33,'Cameroon'),
    (1, 34,'Cambodia'),
    (1, 35,'Canada'),
    (1, 36,'Qatar'),
    (1, 37,'Kazakhstan'),
    (1, 38,'Chad'),
    (1, 39,'Chile'),
    (1, 40,'China'),
    (1, 41,'Cyprus'),
    (1, 42,'Colombia'),
    (1, 43,'Comoros'),
    (1, 44,'North Korea'),
    (1, 45,'South Korea'),
    (1, 46,'Ivory Coast'),
    (1, 47,'Costa Rica'),
    (1, 48,'Croatia'),
    (1, 49,'Cuba'),
    (1, 50,'Denmark'),
    (1, 51,'Dominica'),
    (1, 52,'Egypt'),
    (1, 53,'United Arab Emirates'),
    (1, 54,'Ecuador'),
    (1, 55,'Eritrea'),
    (1, 56,'Slovakia'),
    (1, 57,'Slovenia'),
    (1, 58,'Spain'),
    (1, 59,'United States'),
    (1, 60,'Estonia'),
    (1, 61,'Eswatini'),
    (1, 62,'Ethiopia'),
    (1, 63,'Fiji'),
    (1, 64,'Philippines'),
    (1, 65,'Finland'),
    (1, 66,'France'),
    (1, 67,'Gabon'),
    (1, 68,'Gambia'),
    (1, 69,'Ghana'),
    (1, 70,'Georgia'),
    (1, 71,'Grenada'),
    (1, 72,'Greece'),
    (1, 73,'Guatemala'),
    (1, 74,'Guyana'),
    (1, 75,'Guinea'),
    (1, 76,'Equatorial Guinea'),
    (1, 77,'Guinea-Bissau'),
    (1, 78,'Haiti'),
    (1, 79,'Honduras'),
    (1, 80,'Hungary'),
    (1, 81,'Yemen'),
    (1, 82,'Marshall Islands'),
    (1, 83,'Solomon Islands'),
    (1, 84,'India'),
    (1, 85,'Indonesia'),
    (1, 86,'Iran'),
    (1, 87,'Iraq'),
    (1, 88,'Ireland'),
    (1, 89,'Iceland'),
    (1, 90,'Israel'),
    (1, 91,'Italy'),
    (1, 92,'Jamaica'),
    (1, 93,'Japan'),
    (1, 94,'Djibouti'),
    (1, 95,'Jordan'),
    (1, 96,'Kosovo'),
    (1, 97,'Kuwait'),
    (1, 98,'Laos'),
    (1, 99,'Lesotho'),
    (1, 100,'Latvia'),
    (1, 101,'Lebanon'),
    (1, 102,'Liberia'),
    (1, 103,'Libya'),
    (1, 104,'Liechtenstein'),
    (1, 105,'Lithuania'),
    (1, 106,'Luxembourg'),
    (1, 107,'North Macedonia'),
    (1, 108,'Madagascar'),
    (1, 109,'Malaysia'),
    (1, 110,'Malawi'),
    (1, 111,'Maldives'),
    (1, 112,'Mali'),
    (1, 113,'Malta'),
    (1, 114,'Morocco'),
    (1, 115,'Mauritius'),
    (1, 116,'Mauritania'),
    (1, 117,'Mexico'),
    (1, 118,'Micronesia'),
    (1, 119,'Mozambique'),
    (1, 120,'Moldova'),
    (1, 121,'Monaco'),
    (1, 122,'Mongolia'),
    (1, 123,'Montenegro'),
    (1, 124,'Myanmar'),
    (1, 125,'Namibia'),
    (1, 126,'Nauru'),
    (1, 127,'Nepal'),
    (1, 128,'Nicaragua'),
    (1, 129,'Niger'),
    (1, 130,'Nigeria'),
    (1, 131,'Norway'),
    (1, 132,'New Zealand'),
    (1, 133,'Oman'),
    (1, 134,'Netherlands'),
    (1, 135,'Palau'),
    (1, 136,'Panama'),
    (1, 137,'Papua New Guinea'),
    (1, 138,'Pakistan'),
    (1, 139,'Paraguay'),
    (1, 140,'Peru'),
    (1, 141,'Poland'),
    (1, 142,'Portugal'),
    (1, 143,'Kenya'),
    (1, 144,'Kyrgyzstan'),
    (1, 145,'Kiribati'),
    (1, 146,'United Kingdom'),
    (1, 147,'Central African Republic'),
    (1, 148,'Czech Republic'),
    (1, 149,'Democratic Republic of the Congo'),
    (1, 150,'Republic of the Congo'),
    (1, 151,'Dominican Republic'),
    (1, 152,'Romania'),
    (1, 153,'Rwanda'),
    (1, 154,'Russia'),
    (1, 155,'North Salisbury'),
    (1, 156,'Samoa'),
    (1, 157,'Saint Lucia'),
    (1, 158,'Saint Kitts and Nevis'),
    (1, 159,'San Marino'),
    (1, 160,'São Tomé and Príncipe'),
    (1, 161,'Saint Vincent and the Grenadines'),
    (1, 162,'Seychelles'),
    (1, 163,'Senegal'),
    (1, 164,'Sierra Leone'),
    (1, 165,'Serbia'),
    (1, 166,'Singapore'),
    (1, 167,'Syria'),
    (1, 168,'Somalia'),
    (1, 169,'Sri Lanka'),
    (1, 170,'Sudan'),
    (1, 171,'South Sudan'),
    (1, 172,'Sweden'),
    (1, 173,'Switzerland'),
    (1, 174,'Suriname'),
    (1, 175,'Thailand'),
    (1, 176,'Taiwan'),
    (1, 177,'Tajikistan'),
    (1, 178,'Tanzania'),
    (1, 179,'Timor-Leste'),
    (1, 180,'Togo'),
    (1, 181,'Tonga'),
    (1, 182,'Trinidad and Tobago'),
    (1, 183,'Tunisia'),
    (1, 184,'Turkmenistan'),
    (1, 185,'Turkey'),
    (1, 186,'Tuvalu'),
    (1, 187,'Ukraine'),
    (1, 188,'Uganda'),
    (1, 189,'Uruguay'),
    (1, 190,'Uzbekistan'),
    (1, 191,'Vanuatu'),
    (1, 192,'Vatican'),
    (1, 193,'Venezuela'),
    (1, 194,'Vietnam'),
    (1, 195,'Zambia'),
    (1, 196,'Zimbabwe'),
    (1, 197,'Palestina'),
    (1, 197,'Palestine'),
    (1, 198,'El Salvador');


INSERT INTO R_PAISES_APELIDOS(ID_TIPO_APELIDO, ID_PAIS, APELIDO) VALUES (2, 40, 'China-Hong Kong');
INSERT INTO R_PAISES_APELIDOS(ID_TIPO_APELIDO, ID_PAIS, APELIDO) VALUES (2, 40, 'China-Macau');
INSERT INTO R_PAISES_APELIDOS(ID_TIPO_APELIDO, ID_PAIS, APELIDO) VALUES (2, 40, 'China-Taiwan');

INSERT INTO R_GRUPOS_GEOPOLITICOS(NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES ('BRICS', 'BRICS');
INSERT INTO R_GRUPOS_GEOPOLITICOS(NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES ('Mercosul', 'Mercosur');
INSERT INTO R_GRUPOS_GEOPOLITICOS(NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES ('América Latina', 'Latin America');

-- BRICS
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (1, 2);  -- áfrica do sul
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (1, 26);  -- brasil
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (1, 40);  -- china
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (1, 84);  -- índia
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (1, 154); -- rússia

-- -- MERCOSUL
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (2, 10);  -- argentina
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (2, 26);  -- brasil
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (2, 139);  -- paraguai
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (2, 189);  -- uruguai
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, ID_PAIS) VALUES (2, 193);  -- venezuela

-- AMÉRICA LATINA
INSERT INTO R_PAISES_PARA_GRUPOS_GEOPOLITICOS (ID_GRUPO_GEOPOLITICO, ID_PAIS)
SELECT 3, ID_PAIS FROM (
    select ID_PAIS
    from R_PAISES
    WHERE ID_CONTINENTE IN (
        SELECT ID_CONTINENTE FROM R_CONTINENTES WHERE lower(NOME_CONTINENTE_PORTUGUES) IN (
            lower('América do Sul'), lower('América Central e Caribe')
        )
    )
    UNION
        SELECT ID_PAIS
        FROM R_PAISES WHERE LOWER(NOME_PAIS_PORTUGUES) = lower('México')
);
DELETE FROM R_PAISES_PARA_GRUPOS_GEOPOLITICOS
WHERE ID_PAIS IN (
    SELECT ID_PAIS
    FROM R_PAISES
    WHERE lower(NOME_PAIS_PORTUGUES) IN (
        lower('Guiana'), lower('Suriname'), lower('Belize'), lower('Jamaica'), lower('Trinidade e Tobago')
    )
);

INSERT INTO R_UNIVERSIDADES(
    NOME_UNIVERSIDADE_PORTUGUES, NOME_UNIVERSIDADE_INGLES, SIGLA, ID_APELIDO_PAIS
) VALUES
    ('Universidade Federal de Santa Maria', 'Federal University of Santa Maria', 'UFSM', 26),
    ('Universidade Federal do Pampa', 'Federal University of the Pampa', 'Unipampa', 26);

INSERT INTO R_UNIVERSIDADES_APELIDOS(ID_UNIVERSIDADE, APELIDO) VALUES
    (1, 'Universidade Federal de Santa Maria'),
    (1, 'Federal University of Santa Maria'),
    (1, 'UFSM'),
    (2, 'Universidade Federal do Pampa'),
    (2, 'Federal University of the Pampa'),
    (2, 'Unipampa');

INSERT INTO R_UNIVERSIDADES_GRUPOS(NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES
    ('Universidades Federais Gaúchas', 'Federal Universities from Rio Grande do Sul');

INSERT INTO R_UNIVERSIDADES_PARA_GRUPOS(ID_GRUPO_UNIVERSIDADES, ID_UNIVERSIDADE) VALUES (1, 1);
INSERT INTO R_UNIVERSIDADES_PARA_GRUPOS(ID_GRUPO_UNIVERSIDADES, ID_UNIVERSIDADE) VALUES (1, 2);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Shanghai');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_PORTUGUES, NOME_PILAR_INGLES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (1, 'Alumni', 'Alumni',  NULL, NULL),
    (1, 'N&S', 'N&S', NULL, NULL),
    (1, 'PUB', 'PUB', NULL, NULL),
    (1, 'PCP', 'PCP', NULL, NULL),
    (1, 'Award', 'Award', NULL, NULL),
    (1, 'HiCi', 'HiCi', NULL, NULL),
    (1, 'Geral', 'Total Score', NULL, NULL),
    (1, 'Posição no Ranking Mundial', 'World Rank', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Times Higher Education - World Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (2, 'World Rank', 'Posição no Ranking Mundial', NULL, NULL),
    (2, 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    (2, 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    (2, 'Teaching (Score)', 'Ensino (Score)', NULL, NULL),
    (2, 'Teaching (Rank)', 'Ensino (Rank)', NULL, NULL),
    (2, 'International Outlook (Score)', 'Perspectiva Internacional (Score)', NULL, NULL),
    (2, 'International Outlook (Rank)', 'Perspectiva Internacional (Rank)', NULL, NULL),
    (2, 'Industry Income (Score)', 'Investimento da Indústria (Score)', NULL, NULL),
    (2, 'Industry Income (Rank)', 'Investimento da Indústria (Rank)', NULL, NULL),
    (2, 'Research (Score)', 'Pesquisa (Score)', NULL, NULL),
    (2, 'Research (Rank)', 'Pesquisa (Rank)', NULL, NULL),
    (2, 'Citations (Score)', 'Citações (Score)', NULL, NULL),
    (2, 'Citations (Rank)', 'Citações (Rank)', NULL, NULL),
    (2, 'Number of Students', 'Número de estudantes', NULL, NULL),
    (2, 'Students to Staff Ratio', 'Proporção de estudantes para funcionários', NULL, NULL),
    (2, 'Percent of International Students', 'Porcentagem de estudantes internacionais', NULL, NULL),
    (2, 'Female to male students ratio', 'Proporção de estudantes mulheres para estudantes homens', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Times Higher Education - Latin Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (3, 'World Rank', 'Posição no Ranking Mundial', NULL, NULL),
    (3, 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    (3, 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    (3, 'Teaching (Score)', 'Ensino (Score)', NULL, NULL),
    (3, 'Teaching (Rank)', 'Ensino (Rank)', NULL, NULL),
    (3, 'International Outlook (Score)', 'Perspectiva Internacional (Score)', NULL, NULL),
    (3, 'International Outlook (Rank)', 'Perspectiva Internacional (Rank)', NULL, NULL),
    (3, 'Industry Income (Score)', 'Investimento da Indústria (Score)', NULL, NULL),
    (3, 'Industry Income (Rank)', 'Investimento da Indústria (Rank)', NULL, NULL),
    (3, 'Research (Score)', 'Pesquisa (Score)', NULL, NULL),
    (3, 'Research (Rank)', 'Pesquisa (Rank)', NULL, NULL),
    (3, 'Citations (Score)', 'Citações (Score)', NULL, NULL),
    (3, 'Citations (Rank)', 'Citações (Rank)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Times Higher Education - Impact Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (4, 'World Rank', 'Posição no Ranking Mundial', NULL, NULL),
    (4, 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    (4, 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    (4, 'no Poverty (Score)', 'no Poverty (Score)', NULL, NULL),
    (4, 'no Poverty (Rank)', 'no Poverty (Rank)', NULL, NULL),
    (4, 'Decent Work and Economic Growth (Score)', 'Decent Work and Economic Growth (Score)', NULL, NULL),
    (4, 'Decent Work and Economic Growth (Rank)', 'Decent Work and Economic Growth (Rank)', NULL, NULL),
    (4, 'Life Below Water (Score)', 'Life Below Water (Score)', NULL, NULL),
    (4, 'Life Below Water (Rank)', 'Life Below Water (Rank)', NULL, NULL),
    (4, 'Climate Action (Score)', 'Climate Action (Score)', NULL, NULL),
    (4, 'Climate Action (Rank)', 'Climate Action (Rank)', NULL, NULL),
    (4, 'Partnership for the Goals (Score)', 'Partnership for the Goals (Score)', NULL, NULL),
    (4, 'Partnership for the Goals (Rank)', 'Partnership for the Goals (Rank)', NULL, NULL),
    (4, 'Quality Education (Score)', 'Quality Education (Score)', NULL, NULL),
    (4, 'Quality Education (Rank)', 'Quality Education (Rank)', NULL, NULL),
    (4, 'Industry Innovation and Infrastructure (Score)', 'Industry Innovation and Infrastructure (Score)', NULL, NULL),
    (4, 'Industry Innovation and Infrastructure (Rank)', 'Industry Innovation and Infrastructure (Rank)', NULL, NULL),
    (4, 'Gender Equality (Score)', 'Gender Equality (Score)', NULL, NULL),
    (4, 'Gender Equality (Rank)', 'Gender Equality (Rank)', NULL, NULL),
    (4, 'Good Health and Well-being (Score)', 'Good Health and Well-being (Score)', NULL, NULL),
    (4, 'Good Health and Well-being (Rank)', 'Good Health and Well-being (Rank)', NULL, NULL),
    (4, 'Zero Hunger (Score)', 'Zero Hunger (Score)', NULL, NULL),
    (4, 'Zero Hunger (Rank)', 'Zero Hunger (Rank)', NULL, NULL),
    (4, 'Peace, Justice and Strong Institutions (Score)', 'Peace, Justice and Strong Institutions (Score)', NULL, NULL),
    (4, 'Peace, Justice and Strong Institutions (Rank)', 'Peace, Justice and Strong Institutions (Rank)', NULL, NULL),
    (4, 'Sustainable Cities and Communities (Score)', 'Sustainable Cities and Communities (Score)', NULL, NULL),
    (4, 'Sustainable Cities and Communities (Rank)', 'Sustainable Cities and Communities (Rank)', NULL, NULL),
    (4, 'Life On Land (Score)', 'Life On Land (Score)', NULL, NULL),
    (4, 'Life On Land (Rank)', 'Life On Land (Rank)', NULL, NULL),
    (4, 'Responsible Consumption and Production (Score)', 'Responsible Consumption and Production (Score)', NULL, NULL),
    (4, 'Responsible Consumption and Production (Rank)', 'Responsible Consumption and Production (Rank)', NULL, NULL),
    (4, 'Clean Water and Sanitation (Score)', 'Clean Water and Sanitation (Score)', NULL, NULL),
    (4, 'Clean Water and Sanitation (Rank)', 'Clean Water and Sanitation (Rank)', NULL, NULL),
    (4, 'Reduced Inequalities (Score)', 'Reduced Inequalities (Score)', NULL, NULL),
    (4, 'Reduced Inequalities (Rank)', 'Reduced Inequalities (Rank)', NULL, NULL),
    (4, 'Affordable and Clean Energy (Score)', 'Affordable and Clean Energy (Score)', NULL, NULL),
    (4, 'Affordable and Clean Energy (Rank)', 'Affordable and Clean Energy (Rank)', NULL, NULL),
    (4, 'Number of Students', 'Número de estudantes', NULL, NULL),
    (4, 'Students to Staff Ratio', 'Proporção de estudantes para funcionários', NULL, NULL),
    (4, 'Percent of International Students', 'Porcentagem de estudantes internacionais', NULL, NULL),
    (4, 'Female to male students ratio', 'Proporção de estudantes mulheres para estudantes homens', NULL, NULL);


INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (5, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (5, 'World Rank', 'World Rank', NULL, NULL),
    (5, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (5, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (5, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (5, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (5, 'Faculty Student (Rank)', 'Faculty Student (Rank)', NULL, NULL),
    (5, 'Faculty Student (Score)', 'Faculty Student (Score)', NULL, NULL),
    (5, 'International Faculty (Rank)', 'International Faculty (Rank)', NULL, NULL),
    (5, 'International Faculty (Score)', 'International Faculty (Score)', NULL, NULL),
    (5, 'International Students (Rank)', 'International Students (Rank)', NULL, NULL),
    (5, 'International Students (Score)', 'International Students (Score)', NULL, NULL),
    (5, 'Citations per Faculty (Rank)', 'Citations per Faculty (Rank)', NULL, NULL),
    (5, 'Citations per Faculty (Score)', 'Citations per Faculty (Score)', NULL, NULL),
    (5, 'Arts & Humanities (Rank)', 'Arts & Humanities (Rank)', NULL, NULL),
    (5, 'Arts & Humanities (Score)', 'Arts & Humanities (Score)', NULL, NULL),
    (5, 'Engineering & Technology (Rank)', 'Engineering & Technology (Rank)', NULL, NULL),
    (5, 'Engineering & Technology (Score)', 'Engineering & Technology (Score)', NULL, NULL),
    (5, 'Life Sciences & Medicine (Rank)', 'Life Sciences & Medicine (Rank)', NULL, NULL),
    (5, 'Life Sciences & Medicine (Score)', 'Life Sciences & Medicine (Score)', NULL, NULL),
    (5, 'Natural Sciences (Rank)', 'Natural Sciences (Rank)', NULL, NULL),
    (5, 'Natural Sciences (Score)', 'Natural Sciences (Score)', NULL, NULL),
    (5, 'Social Sciences & Management (Rank)', 'Social Sciences & Management (Rank)', NULL, NULL),
    (5, 'Social Sciences & Management (Score)', 'Social Sciences & Management (Score)', NULL, NULL),
    (5, 'International Students Ratio (Rank)', 'International Students Ratio (Rank)', NULL, NULL),
    (5, 'International Students Ratio (Score)', 'International Students Ratio (Score)', NULL, NULL),
    (5, 'International Faculty Ratio (Rank)', 'International Faculty Ratio (Rank)', NULL, NULL),
    (5, 'International Faculty Ratio (Score)', 'International Faculty Ratio (Score)', NULL, NULL),
    (5, 'Faculty Student Ratio (Rank)', 'Faculty Student Ratio (Rank)', NULL, NULL),
    (5, 'Faculty Student Ratio (Score)', 'Faculty Student Ratio (Score)', NULL, NULL),
    (5, 'Social Sciences and Management (Rank)', 'Social Sciences and Management (Rank)', NULL, NULL),
    (5, 'Social Sciences and Management (Score)', 'Social Sciences and Management (Score)', NULL, NULL),
    (5, 'Life Sciences and Medicine (Rank)', 'Life Sciences and Medicine (Rank)', NULL, NULL),
    (5, 'Life Sciences and Medicine (Score)', 'Life Sciences and Medicine (Score)', NULL, NULL),
    (5, 'Engineering and Technology (Rank)', 'Engineering and Technology (Rank)', NULL, NULL),
    (5, 'Engineering and Technology (Score)', 'Engineering and Technology (Score)', NULL, NULL),
    (5, 'Arts and Humanities (Rank)', 'Arts and Humanities (Rank)', NULL, NULL),
    (5, 'Arts and Humanities (Score)', 'Arts and Humanities (Score)', NULL, NULL),
    (5, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (5, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL),
    (5, 'Employment Outcomes (Rank)', 'Employment Outcomes (Rank)', NULL, NULL),
    (5, 'Employment Outcomes (Score)', 'Employment Outcomes (Score)', NULL, NULL),
    (5, 'Sustainability (Rank)', 'Sustainability (Rank)', NULL, NULL),
    (5, 'Sustainability (Score)', 'Sustainability (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS Latin America Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (6, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (6, 'World Rank', 'World Rank', NULL, NULL),
    (6, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (6, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (6, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (6, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (6, 'Faculty Student (Rank)', 'Faculty Student (Rank)', NULL, NULL),
    (6, 'Faculty Student (Score)', 'Faculty Student (Score)', NULL, NULL),
    (6, 'Faculty Staff with PhD (Rank)', 'Faculty Staff with PhD (Rank)', NULL, NULL),
    (6, 'Faculty Staff with PhD (Score)', 'Faculty Staff with PhD (Score)', NULL, NULL),
    (6, 'Web Impact (Rank)', 'Web Impact (Rank)', NULL, NULL),
    (6, 'Web Impact (Score)', 'Web Impact (Score)', NULL, NULL),
    (6, 'Papers per Faculty (Rank)', 'Papers per Faculty (Rank)', NULL, NULL),
    (6, 'Papers per Faculty (Score)', 'Papers per Faculty (Score)', NULL, NULL),
    (6, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (6, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (6, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (6, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL),
    (6, 'Faculty Student Ratio (Rank)', 'Faculty Student Ratio (Rank)', NULL, NULL),
    (6, 'Faculty Student Ratio (Score)', 'Faculty Student Ratio (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Arts & Humanities');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (7, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (7, 'World Rank', 'World Rank', NULL, NULL),
    (7, 'Stars', 'Stars', NULL, NULL),
    (7, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (7, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (7, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (7, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (7, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (7, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (7, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (7, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (7, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (7, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Engineering and Technology');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (8, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (8, 'World Rank', 'World Rank', NULL, NULL),
    (8, 'Stars', 'Stars', NULL, NULL),
    (8, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (8, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (8, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (8, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (8, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (8, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (8, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (8, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (8, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (8, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Life Sciences & Medicine');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (9, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (9, 'World Rank', 'World Rank', NULL, NULL),
    (9, 'Stars', 'Stars', NULL, NULL),
    (9, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (9, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (9, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (9, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (9, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (9, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (9, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (9, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (9, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (9, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Natural Sciences');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (10, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (10, 'World Rank', 'World Rank', NULL, NULL),
    (10, 'Stars', 'Stars', NULL, NULL),
    (10, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (10, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (10, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (10, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (10, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (10, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (10, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (10, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (10, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (10, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Green Metric');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (11, 'World Rank', 'World Rank', NULL, NULL),
    (11, 'Score (Overall)', 'Score (Overall)', NULL, NULL),
    (11, 'Setting & Infrastructure', 'Setting & Infrastructure', NULL, NULL),
    (11, 'Energy & Climate Change', 'Energy & Climate Change', NULL, NULL),
    (11, 'Waste', 'Waste', NULL, NULL),
    (11, 'Water', 'Water', NULL, NULL),
    (11, 'Transportation', 'Transportation', NULL, NULL),
    (11, 'Education & Research', 'Education & Research', NULL, NULL),
    (11, 'Setting and Infrastructure', 'Setting and Infrastructure', NULL, NULL),
    (11, 'Energy and Climate Change', 'Energy and Climate Change', NULL, NULL),
    (11, 'Education', 'Education', NULL, NULL);