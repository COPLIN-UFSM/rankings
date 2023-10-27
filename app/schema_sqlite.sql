-- continentes, países, subdivisões de países e grupos geopolíticos
CREATE TABLE R_CONTINENTES (
  ID_CONTINENTE INTEGER PRIMARY KEY,
  NOME_CONTINENTE_PORTUGUES TEXT NOT NULL,
  NOME_CONTINENTE_INGLES TEXT NOT NULL
);

CREATE TABLE R_PAISES (
  ID_PAIS INTEGER PRIMARY KEY,
  ID_CONTINENTE INTEGER NOT NULL,
  NOME_PAIS_PORTUGUES TEXT NOT NULL,
  NOME_PAIS_INGLES TEXT NOT NULL,
  FOREIGN KEY (ID_CONTINENTE) REFERENCES R_CONTINENTES(ID_CONTINENTE) ON UPDATE CASCADE
);

CREATE TABLE R_PAISES_APELIDOS_TIPOS (
    ID_TIPO_APELIDO INTEGER PRIMARY KEY,
    TIPO_APELIDO TEXT NOT NULL
);

CREATE TABLE R_PAISES_APELIDOS (
  ID_APELIDO_PAIS INTEGER PRIMARY KEY,
  ID_TIPO_APELIDO INTEGER NOT NULL,
  APELIDO TEXT NOT NULL,
  ID_PAIS INTEGER NOT NULL,
  FOREIGN KEY (ID_TIPO_APELIDO) REFERENCES R_PAISES_APELIDOS_TIPOS(ID_TIPO_APELIDO) ON UPDATE CASCADE,
  FOREIGN KEY (ID_PAIS) REFERENCES R_PAISES(ID_PAIS) ON UPDATE CASCADE
);

CREATE TABLE R_GRUPOS_GEOPOLITICOS (
  ID_GRUPO_GEOPOLITICO INTEGER PRIMARY KEY,
  NOME_GRUPO_PORTUGUES TEXT NOT NULL,
  NOME_GRUPO_INGLES TEXT NOT NULL,
  SIGLA TEXT DEFAULT NULL
);

CREATE TABLE R_PAISES_PARA_GRUPOS_GEOPOLITICOS (
  ID_GRUPO_GEOPOLITICO INTEGER NOT NULL,
  ID_PAIS INTEGER NOT NULL,
  PRIMARY KEY (ID_GRUPO_GEOPOLITICO, ID_PAIS),
  FOREIGN KEY (ID_GRUPO_GEOPOLITICO) REFERENCES R_GRUPOS_GEOPOLITICOS (ID_GRUPO_GEOPOLITICO) ON UPDATE CASCADE,
  FOREIGN KEY (ID_PAIS) REFERENCES R_PAISES(ID_PAIS) ON UPDATE CASCADE
);

-- universidades e seus grupos
CREATE TABLE R_UNIVERSIDADES (
  ID_UNIVERSIDADE INTEGER PRIMARY KEY,
  NOME_UNIVERSIDADE_PORTUGUES TEXT NOT NULL,
  NOME_UNIVERSIDADE_INGLES TEXT NOT NULL,
  SIGLA TEXT DEFAULT NULL,
  ID_APELIDO_PAIS INTEGER NOT NULL,
  FOREIGN KEY (ID_APELIDO_PAIS) REFERENCES R_PAISES_APELIDOS(ID_APELIDO_PAIS) ON UPDATE CASCADE
);

CREATE TABLE R_UNIVERSIDADES_APELIDOS (
  ID_APELIDO_UNIVERSIDADE INTEGER PRIMARY KEY,
  ID_UNIVERSIDADE INTEGER NOT NULL,
  APELIDO TEXT NOT NULL,
  FOREIGN KEY (ID_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES(ID_UNIVERSIDADE) ON UPDATE CASCADE
);

CREATE TABLE R_UNIVERSIDADES_GRUPOS (
  ID_GRUPO_UNIVERSIDADES INTEGER PRIMARY KEY,
  NOME_GRUPO_PORTUGUES TEXT NOT NULL,
  NOME_GRUPO_INGLES TEXT NOT NULL
);

CREATE TABLE R_UNIVERSIDADES_PARA_GRUPOS (
  ID_UNIVERSIDADE INTEGER NOT NULL,
  ID_GRUPO_UNIVERSIDADES INTEGER NOT NULL,
  PRIMARY KEY (ID_UNIVERSIDADE, ID_GRUPO_UNIVERSIDADES),
  FOREIGN KEY (ID_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES(ID_UNIVERSIDADE) ON UPDATE CASCADE,
  FOREIGN KEY (ID_GRUPO_UNIVERSIDADES) REFERENCES R_UNIVERSIDADES_GRUPOS(ID_GRUPO_UNIVERSIDADES) ON UPDATE CASCADE
);

-- rankings e métricas
CREATE TABLE R_RANKINGS (
  ID_RANKING INTEGER PRIMARY KEY,
  NOME_RANKING TEXT UNIQUE NOT NULL
);

CREATE TABLE R_PILARES (
  ID_PILAR INTEGER PRIMARY KEY,
  ID_RANKING INTEGER NOT NULL,
  NOME_PILAR_PORTUGUES TEXT NOT NULL,
  NOME_PILAR_INGLES TEXT NOT NULL,
  DESCRICAO_PILAR_PORTUGUES TEXT DEFAULT NULL,
  DESCRICAO_PILAR_INGLES TEXT DEFAULT NULL,
  FOREIGN KEY (ID_RANKING) REFERENCES R_RANKINGS(ID_RANKING) ON UPDATE CASCADE
);

CREATE TABLE R_METRICAS (
  ID_METRICA INTEGER PRIMARY KEY,
  NOME_METRICA_PORTUGUES TEXT NOT NULL,
  NOME_METRICA_INGLES TEXT NOT NULL,
  DESCRICAO_METRICA_PORTUGUES TEXT DEFAULT NULL,
  DESCRICAO_METRICA_INGLES TEXT DEFAULT NULL
);

CREATE TABLE R_PILARES_GRUPOS (
  ID_GRUPO_PILARES INTEGER PRIMARY KEY,
  NOME_GRUPO_PORTUGUES TEXT NOT NULL,
  NOME_GRUPO_INGLES TEXT NOT NULL
);

CREATE TABLE R_PILARES_PARA_GRUPOS (
  ID_PILAR INTEGER NOT NULL,
  ID_GRUPO_PILARES INTEGER NOT NULL,
  PRIMARY KEY (ID_PILAR, ID_GRUPO_PILARES),
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR) ON UPDATE CASCADE,
  FOREIGN KEY (ID_GRUPO_PILARES) REFERENCES R_PILARES_GRUPOS(ID_GRUPO_PILARES) ON UPDATE CASCADE
);

CREATE TABLE R_METRICAS_PARA_PILARES (
  ID_METRICA INTEGER NOT NULL,
  ID_PILAR INTEGER NOT NULL,
  PESO REAL NOT NULL,
  PRIMARY KEY (ID_PILAR, ID_METRICA),
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR) ON UPDATE CASCADE,
  FOREIGN KEY (ID_METRICA) REFERENCES R_METRICAS(ID_METRICA) ON UPDATE CASCADE
);

CREATE TABLE R_PILARES_VALORES (
  ID_APELIDO_UNIVERSIDADE INTEGER NOT NULL,
  ID_PILAR INTEGER NOT NULL,
  ANO INTEGER NOT NULL,
  VALOR_INICIAL REAL DEFAULT NULL,  -- valor final do intervalo caso o pilar possua um intervalo de valores
  VALOR_FINAL REAL DEFAULT NULL,  -- valor final do intervalo caso o pilar possua um intervalo de valores
  PRIMARY KEY (ID_APELIDO_UNIVERSIDADE, ID_PILAR, ANO),
  FOREIGN KEY (ID_APELIDO_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES_APELIDOS(ID_APELIDO_UNIVERSIDADE) ON UPDATE CASCADE,
  FOREIGN KEY (ID_PILAR) REFERENCES R_PILARES(ID_PILAR) ON UPDATE CASCADE
);

CREATE TABLE R_METRICAS_VALORES (
  ID_APELIDO_UNIVERSIDADE INTEGER NOT NULL,
  ID_METRICA INTEGER NOT NULL,
  ANO INTEGER NOT NULL,
  VALOR_INICIAL REAL DEFAULT NULL,
  VALOR_FINAL REAL DEFAULT NULL,
  PRIMARY KEY (ID_APELIDO_UNIVERSIDADE, ID_METRICA, ANO),
  FOREIGN KEY (ID_APELIDO_UNIVERSIDADE) REFERENCES R_UNIVERSIDADES_APELIDOS(ID_APELIDO_UNIVERSIDADE) ON UPDATE CASCADE,
  FOREIGN KEY (ID_METRICA) REFERENCES R_METRICAS(ID_METRICA) ON UPDATE CASCADE
);

-- tabelas estruturas genéricas - evitar ao máximo seu uso
CREATE TABLE R_TIPOS_METADADOS (
  ID_TIPO_METADADO INTEGER PRIMARY KEY,
  NOME_TIPO_METADADO TEXT NOT NULL
);

CREATE TABLE R_TIPOS_ENTIDADES (
  ID_TIPO_ENTIDADE INTEGER PRIMARY KEY,
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
  FOREIGN KEY (ID_TIPO_METADADO) REFERENCES R_TIPOS_METADADOS(ID_TIPO_METADADO) ON UPDATE CASCADE,
  FOREIGN KEY (ID_TIPO_ENTIDADE) REFERENCES R_TIPOS_ENTIDADES(ID_TIPO_ENTIDADE) ON UPDATE CASCADE
);

CREATE TABLE R_FORMULARIOS (
    ID_FORMULARIO INTEGER PRIMARY KEY,
    ID_RANKING INTEGER NOT NULL,
    FORMULARIO TEXT NOT NULL,
    DATA TEXT NOT NULL,
    FOREIGN KEY (ID_RANKING) REFERENCES R_RANKINGS(ID_RANKING) ON UPDATE CASCADE
);

INSERT INTO R_CONTINENTES(ID_CONTINENTE, NOME_CONTINENTE_PORTUGUES, NOME_CONTINENTE_INGLES) VALUES
    (1, 'África', 'Africa'),
    (2, 'América Central e Caribe', 'Central America and the Caribbean'),
    (3, 'Ásia', 'Asia'),
    (4, 'Europa', 'Europe'),
    (5, 'Oceania', 'Oceania'),
    (6, 'América do Sul', 'South America'),
    (7, 'América do Norte', 'North America');

INSERT INTO R_PAISES_APELIDOS_TIPOS(ID_TIPO_APELIDO, TIPO_APELIDO) VALUES
    (1, 'Nome alternativo'),
    (2, 'Subdivisão');

INSERT INTO R_PAISES(ID_PAIS, NOME_PAIS_PORTUGUES, NOME_PAIS_INGLES, ID_CONTINENTE) VALUES
    (1,'Afeganistão','Afghanistan',3),
    (2,'África do Sul','South Africa',1),
    (3,'Albânia','Albania',4),
    (4,'Alemanha','Germany',4),
    (5,'Andorra','Andorra',4),
    (6,'Angola','Angola',1),
    (7,'Antígua e Barbuda','Antigua and Barbuda',2),
    (8,'Arábia Saudita','Saudi Arabia',3),
    (9,'Argélia','Algeria',1),
    (10,'Argentina','Argentina',6),
    (11,'Armênia','Armenia',4),
    (12,'Austrália','Australia',5),
    (13,'Áustria','Austria',4),
    (14,'Azerbaijão','Azerbaijan',3),
    (15,'Bahamas','Bahamas',2),
    (16,'Bangladeche','Bangladesh',3),
    (17,'Barbados','Barbados',2),
    (18,'Barém','Bahrain',3),
    (19,'Bélgica','Belgium',4),
    (20,'Belize','Belize',2),
    (21,'Benim','Benin',1),
    (22,'Bielorrússia','Belarus',4),
    (23,'Bolívia','Bolivia',6),
    (24,'Bósnia e Herzegovina','Bosnia and Herzegovina',4),
    (25,'Botsuana','Botswana',1),
    (26,'Brasil','Brazil',6),
    (27,'Brunei','Brunei',3),
    (28,'Bulgária','Bulgaria',4),
    (29,'Burquina Faso','Burkina Faso',1),
    (30,'Burúndi','Burundi',1),
    (31,'Butão','Bhutan',3),
    (32,'Cabo Verde','Cape Verde',1),
    (33,'Camarões','Cameroon',1),
    (34,'Camboja','Cambodia',3),
    (35,'Canadá','Canada',7),
    (36,'Catar','Qatar',3),
    (37,'Cazaquistão','Kazakhstan',3),
    (38,'Chade','Chad',1),
    (39,'Chile','Chile',6),
    (40,'China','China',3),
    (41,'Chipre','Cyprus',4),
    (42,'Colômbia','Colombia',6),
    (43,'Comores','Comoros',1),
    (44,'Coreia do Norte','North Korea',3),
    (45,'Coreia do Sul','South Korea',3),
    (46,'Costa do Marfim','Ivory Coast',1),
    (47,'Costa Rica','Costa Rica',2),
    (48,'Croácia','Croatia',4),
    (49,'Cuba','Cuba',2),
    (50,'Dinamarca','Denmark',4),
    (51,'Dominica','Dominica',2),
    (52,'Egito','Egypt',1),
    (53,'Emirados Árabes Unidos','United Arab Emirates',3),
    (54,'Equador','Ecuador',6),
    (55,'Eritreia','Eritrea',1),
    (56,'Eslováquia','Slovakia',4),
    (57,'Eslovênia','Slovenia',4),
    (58,'Espanha','Spain',4),
    (59,'Estados Unidos','United States',7),
    (60,'Estônia','Estonia',4),
    (61,'Eswatini','Eswatini',1),
    (62,'Etiópia','Ethiopia',1),
    (63,'Fiji','Fiji',5),
    (64,'Filipinas','Philippines',3),
    (65,'Finlândia','Finland',4),
    (66,'França','France',4),
    (67,'Gabão','Gabon',1),
    (68,'Gâmbia','Gambia',1),
    (69,'Gana','Ghana',1),
    (70,'Geórgia','Georgia',3),
    (71,'Granada','Grenada',2),
    (72,'Grécia','Greece',4),
    (73,'Guatemala','Guatemala',2),
    (74,'Guiana','Guyana',6),
    (75,'Guiné','Guinea',1),
    (76,'Guiné Equatorial','Equatorial Guinea',1),
    (77,'Guiné-Bissau','Guinea-Bissau',1),
    (78,'Haiti','Haiti',2),
    (79,'Honduras','Honduras',2),
    (80,'Hungria','Hungary',4),
    (81,'Iêmen','Yemen',3),
    (82,'Ilhas Marshall','Marshall Islands',5),
    (83,'Ilhas Salomão','Solomon Islands',5),
    (84,'Índia','India',3),
    (85,'Indonésia','Indonesia',3),
    (86,'Irã','Iran',3),
    (87,'Iraque','Iraq',3),
    (88,'Irlanda','Ireland',4),
    (89,'Islândia','Iceland',4),
    (90,'Israel','Israel',3),
    (91,'Itália','Italy',4),
    (92,'Jamaica','Jamaica',2),
    (93,'Japão','Japan',3),
    (94,'Jibuti','Djibouti',1),
    (95,'Jordânia','Jordan',3),
    (96,'Kosovo','Kosovo',4),
    (97,'Kuwait','Kuwait',3),
    (98,'Laos','Laos',5),
    (99,'Lesoto','Lesotho',1),
    (100,'Letônia','Latvia',4),
    (101,'Líbano','Lebanon',3),
    (102,'Libéria','Liberia',1),
    (103,'Líbia','Libya',1),
    (104,'Liechtenstein','Liechtenstein',4),
    (105,'Lituânia','Lithuania',4),
    (106,'Luxemburgo','Luxembourg',4),
    (107,'Macedônia do Norte','North Macedonia',4),
    (108,'Madagascar','Madagascar',1),
    (109,'Malásia','Malaysia',3),
    (110,'Malávi','Malawi',1),
    (111,'Maldivas','Maldives',3),
    (112,'Mali','Mali',1),
    (113,'Malta','Malta',4),
    (114,'Marrocos','Morocco',1),
    (115,'Maurícia','Mauritius',1),
    (116,'Mauritânia','Mauritania',1),
    (117,'México','Mexico',7),
    (118,'Micronésia','Micronesia',5),
    (119,'Moçambique','Mozambique',1),
    (120,'Moldávia','Moldova',4),
    (121,'Mônaco','Monaco',4),
    (122,'Mongólia','Mongolia',3),
    (123,'Montenegro','Montenegro',4),
    (124,'Myanmar','Myanmar',3),
    (125,'Namíbia','Namibia',1),
    (126,'Nauru','Nauru',5),
    (127,'Nepal','Nepal',3),
    (128,'Nicarágua','Nicaragua',2),
    (129,'Níger','Niger',1),
    (130,'Nigéria','Nigeria',1),
    (131,'Noruega','Norway',4),
    (132,'Nova Zelândia','New Zealand',5),
    (133,'Omã','Oman',3),
    (134,'Países Baixos','Netherlands',5),
    (135,'Palau','Palau',5),
    (136,'Panamá','Panama',2),
    (137,'Papua-Nova Guiné','Papua New Guinea',5),
    (138,'Paquistão','Pakistan',3),
    (139,'Paraguai','Paraguay',6),
    (140,'Peru','Peru',6),
    (141,'Polônia','Poland',4),
    (142,'Portugal','Portugal',4),
    (143,'Quênia','Kenya',1),
    (144,'Quirguistão','Kyrgyzstan',3),
    (145,'Quiribáti','Kiribati',5),
    (146,'Reino Unido','United Kingdom',4),
    (147,'República Centro-Africana','Central African Republic',1),
    (148,'República Checa','Czech Republic',4),
    (149,'República Democrática do Congo','Democratic Republic of the Congo',1),
    (150,'República do Congo','Republic of the Congo',1),
    (151,'República Dominicana','Dominican Republic',2),
    (152,'Romênia','Romania',4),
    (153,'Ruanda','Rwanda',1),
    (154,'Rússia','Russia',4),
    (155,'Salisbúria do Norte','North Salisbury',1),
    (156,'Samoa','Samoa',5),
    (157,'Santa Lúcia','Saint Lucia',2),
    (158,'São Cristóvão e Neves','Saint Kitts and Nevis',2),
    (159,'San Marino','San Marino',4),
    (160,'São Tomé e Príncipe','São Tomé and Príncipe',1),
    (161,'São Vicente e Granadinas','Saint Vincent and the Grenadines',2),
    (162,'Seicheles','Seychelles',1),
    (163,'Senegal','Senegal',1),
    (164,'Serra Leoa','Sierra Leone',4),
    (165,'Sérvia','Serbia',4),
    (166,'Singapura','Singapore',3),
    (167,'Síria','Syria',3),
    (168,'Somália','Somalia',3),
    (169,'Sri Lanka','Sri Lanka',3),
    (170,'Sudão','Sudan',1),
    (171,'Sudão do Sul','South Sudan',1),
    (172,'Suécia','Sweden',4),
    (173,'Suíça','Switzerland',4),
    (174,'Suriname','Suriname',6),
    (175,'Tailândia','Thailand',3),
    (176,'Taiwan','Taiwan',3),
    (177,'Tajiquistão','Tajikistan',3),
    (178,'Tanzânia','Tanzania',1),
    (179,'Timor-Leste','Timor-Leste',3),
    (180,'Togo','Togo',1),
    (181,'Tonga','Tonga',5),
    (182,'Trinidade e Tobago','Trinidad and Tobago',2),
    (183,'Tunísia','Tunisia',1),
    (184,'Turcomenistão','Turkmenistan',3),
    (185,'Turquia','Turkey',3),
    (186,'Tuvalu','Tuvalu',5),
    (187,'Ucrânia','Ukraine',4),
    (188,'Uganda','Uganda',1),
    (189,'Uruguai','Uruguay',6),
    (190,'Uzbequistão','Uzbekistan',3),
    (191,'Vanuatu','Vanuatu',5),
    (192,'Vaticano','Vatican',4),
    (193,'Venezuela','Venezuela',6),
    (194,'Vietnã','Vietnam',3),
    (195,'Zâmbia','Zambia',1),
    (196,'Zimbábue','Zimbabwe',1),
    (197,'Palestina','Palestine',3),
    (198,'El Salvador','El Salvador', 2);

INSERT INTO R_PAISES_APELIDOS(ID_TIPO_APELIDO, ID_APELIDO_PAIS, ID_PAIS, APELIDO) VALUES
    (1, 1,1,'Afeganistão'),
    (1, 2,2,'África do Sul'),
    (1, 3,3,'Albânia'),
    (1, 4,4,'Alemanha'),
    (1, 5,5,'Andorra'),
    (1, 6,6,'Angola'),
    (1, 7,7,'Antígua e Barbuda'),
    (1, 8,8,'Arábia Saudita'),
    (1, 9,9,'Argélia'),
    (1, 10,10,'Argentina'),
    (1, 11,11,'Armênia'),
    (1, 12,12,'Austrália'),
    (1, 13,13,'Áustria'),
    (1, 14,14,'Azerbaijão'),
    (1, 15,15,'Bahamas'),
    (1, 16,16,'Bangladeche'),
    (1, 17,17,'Barbados'),
    (1, 18,18,'Barém'),
    (1, 19,19,'Bélgica'),
    (1, 20,20,'Belize'),
    (1, 21,21,'Benim'),
    (1, 22,22,'Bielorrússia'),
    (1, 23,23,'Bolívia'),
    (1, 24,24,'Bósnia e Herzegovina'),
    (1, 25,25,'Botsuana'),
    (1, 26,26,'Brasil'),
    (1, 27,27,'Brunei'),
    (1, 28,28,'Bulgária'),
    (1, 29,29,'Burquina Faso'),
    (1, 30,30,'Burúndi'),
    (1, 31,31,'Butão'),
    (1, 32,32,'Cabo Verde'),
    (1, 33,33,'Camarões'),
    (1, 34,34,'Camboja'),
    (1, 35,35,'Canadá'),
    (1, 36,36,'Catar'),
    (1, 37,37,'Cazaquistão'),
    (1, 38,38,'Chade'),
    (1, 39,39,'Chile'),
    (1, 40,40,'China'),
    (1, 41,41,'Chipre'),
    (1, 42,42,'Colômbia'),
    (1, 43,43,'Comores'),
    (1, 44,44,'Coreia do Norte'),
    (1, 45,45,'Coreia do Sul'),
    (1, 46,46,'Costa do Marfim'),
    (1, 47,47,'Costa Rica'),
    (1, 48,48,'Croácia'),
    (1, 49,49,'Cuba'),
    (1, 50,50,'Dinamarca'),
    (1, 51,51,'Dominica'),
    (1, 52,52,'Egito'),
    (1, 53,53,'Emirados Árabes Unidos'),
    (1, 54,54,'Equador'),
    (1, 55,55,'Eritreia'),
    (1, 56,56,'Eslováquia'),
    (1, 57,57,'Eslovênia'),
    (1, 58,58,'Espanha'),
    (1, 59,59,'Estados Unidos'),
    (1, 60,60,'Estônia'),
    (1, 61,61,'Eswatini'),
    (1, 62,62,'Etiópia'),
    (1, 63,63,'Fiji'),
    (1, 64,64,'Filipinas'),
    (1, 65,65,'Finlândia'),
    (1, 66,66,'França'),
    (1, 67,67,'Gabão'),
    (1, 68,68,'Gâmbia'),
    (1, 69,69,'Gana'),
    (1, 70,70,'Geórgia'),
    (1, 71,71,'Granada'),
    (1, 72,72,'Grécia'),
    (1, 73,73,'Guatemala'),
    (1, 74,74,'Guiana'),
    (1, 75,75,'Guiné'),
    (1, 76,76,'Guiné Equatorial'),
    (1, 77,77,'Guiné-Bissau'),
    (1, 78,78,'Haiti'),
    (1, 79,79,'Honduras'),
    (1, 80,80,'Hungria'),
    (1, 81,81,'Iêmen'),
    (1, 82,82,'Ilhas Marshall'),
    (1, 83,83,'Ilhas Salomão'),
    (1, 84,84,'Índia'),
    (1, 85,85,'Indonésia'),
    (1, 86,86,'Irã'),
    (1, 87,87,'Iraque'),
    (1, 88,88,'Irlanda'),
    (1, 89,89,'Islândia'),
    (1, 90,90,'Israel'),
    (1, 91,91,'Itália'),
    (1, 92,92,'Jamaica'),
    (1, 93,93,'Japão'),
    (1, 94,94,'Jibuti'),
    (1, 95,95,'Jordânia'),
    (1, 96,96,'Kosovo'),
    (1, 97,97,'Kuwait'),
    (1, 98,98,'Laos'),
    (1, 99,99,'Lesoto'),
    (1, 100,100,'Letônia'),
    (1, 101,101,'Líbano'),
    (1, 102,102,'Libéria'),
    (1, 103,103,'Líbia'),
    (1, 104,104,'Liechtenstein'),
    (1, 105,105,'Lituânia'),
    (1, 106,106,'Luxemburgo'),
    (1, 107,107,'Macedônia do Norte'),
    (1, 108,108,'Madagascar'),
    (1, 109,109,'Malásia'),
    (1, 110,110,'Malávi'),
    (1, 111,111,'Maldivas'),
    (1, 112,112,'Mali'),
    (1, 113,113,'Malta'),
    (1, 114,114,'Marrocos'),
    (1, 115,115,'Maurícia'),
    (1, 116,116,'Mauritânia'),
    (1, 117,117,'México'),
    (1, 118,118,'Micronésia'),
    (1, 119,119,'Moçambique'),
    (1, 120,120,'Moldávia'),
    (1, 121,121,'Mônaco'),
    (1, 122,122,'Mongólia'),
    (1, 123,123,'Montenegro'),
    (1, 124,124,'Myanmar'),
    (1, 125,125,'Namíbia'),
    (1, 126,126,'Nauru'),
    (1, 127,127,'Nepal'),
    (1, 128,128,'Nicarágua'),
    (1, 129,129,'Níger'),
    (1, 130,130,'Nigéria'),
    (1, 131,131,'Noruega'),
    (1, 132,132,'Nova Zelândia'),
    (1, 133,133,'Omã'),
    (1, 134,134,'Países Baixos'),
    (1, 135,135,'Palau'),
    (1, 136,136,'Panamá'),
    (1, 137,137,'Papua-Nova Guiné'),
    (1, 138,138,'Paquistão'),
    (1, 139,139,'Paraguai'),
    (1, 140,140,'Peru'),
    (1, 141,141,'Polônia'),
    (1, 142,142,'Portugal'),
    (1, 143,143,'Quênia'),
    (1, 144,144,'Quirguistão'),
    (1, 145,145,'Quiribáti'),
    (1, 146,146,'Reino Unido'),
    (1, 147,147,'República Centro-Africana'),
    (1, 148,148,'República Checa'),
    (1, 149,149,'República Democrática do Congo'),
    (1, 150,150,'República do Congo'),
    (1, 151,151,'República Dominicana'),
    (1, 152,152,'Romênia'),
    (1, 153,153,'Ruanda'),
    (1, 154,154,'Rússia'),
    (1, 155,155,'Salisbúria do Norte'),
    (1, 156,156,'Samoa'),
    (1, 157,157,'Santa Lúcia'),
    (1, 158,158,'São Cristóvão e Neves'),
    (1, 159,159,'San Marino'),
    (1, 160,160,'São Tomé e Príncipe'),
    (1, 161,161,'São Vicente e Granadinas'),
    (1, 162,162,'Seicheles'),
    (1, 163,163,'Senegal'),
    (1, 164,164,'Serra Leoa'),
    (1, 165,165,'Sérvia'),
    (1, 166,166,'Singapura'),
    (1, 167,167,'Síria'),
    (1, 168,168,'Somália'),
    (1, 169,169,'Sri Lanka'),
    (1, 170,170,'Sudão'),
    (1, 171,171,'Sudão do Sul'),
    (1, 172,172,'Suécia'),
    (1, 173,173,'Suíça'),
    (1, 174,174,'Suriname'),
    (1, 175,175,'Tailândia'),
    (1, 176,176,'Taiwan'),
    (1, 177,177,'Tajiquistão'),
    (1, 178,178,'Tanzânia'),
    (1, 179,179,'Timor-Leste'),
    (1, 180,180,'Togo'),
    (1, 181,181,'Tonga'),
    (1, 182,182,'Trinidade e Tobago'),
    (1, 183,183,'Tunísia'),
    (1, 184,184,'Turcomenistão'),
    (1, 185,185,'Turquia'),
    (1, 186,186,'Tuvalu'),
    (1, 187,187,'Ucrânia'),
    (1, 188,188,'Uganda'),
    (1, 189,189,'Uruguai'),
    (1, 190,190,'Uzbequistão'),
    (1, 191,191,'Vanuatu'),
    (1, 192,192,'Vaticano'),
    (1, 193,193,'Venezuela'),
    (1, 194,194,'Vietnã'),
    (1, 195,195,'Zâmbia'),
    (1, 196,196,'Zimbábue'),
    (1, 197,1,'Afghanistan'),
    (1, 198,2,'South Africa'),
    (1, 199,3,'Albania'),
    (1, 200,4,'Germany'),
    (1, 201,5,'Andorra'),
    (1, 202,6,'Angola'),
    (1, 203,7,'Antigua and Barbuda'),
    (1, 204,8,'Saudi Arabia'),
    (1, 205,9,'Algeria'),
    (1, 206,10,'Argentina'),
    (1, 207,11,'Armenia'),
    (1, 208,12,'Australia'),
    (1, 209,13,'Austria'),
    (1, 210,14,'Azerbaijan'),
    (1, 211,15,'Bahamas'),
    (1, 212,16,'Bangladesh'),
    (1, 213,17,'Barbados'),
    (1, 214,18,'Bahrain'),
    (1, 215,19,'Belgium'),
    (1, 216,20,'Belize'),
    (1, 217,21,'Benin'),
    (1, 218,22,'Belarus'),
    (1, 219,23,'Bolivia'),
    (1, 220,24,'Bosnia and Herzegovina'),
    (1, 221,25,'Botswana'),
    (1, 222,26,'Brazil'),
    (1, 223,27,'Brunei'),
    (1, 224,28,'Bulgaria'),
    (1, 225,29,'Burkina Faso'),
    (1, 226,30,'Burundi'),
    (1, 227,31,'Bhutan'),
    (1, 228,32,'Cape Verde'),
    (1, 229,33,'Cameroon'),
    (1, 230,34,'Cambodia'),
    (1, 231,35,'Canada'),
    (1, 232,36,'Qatar'),
    (1, 233,37,'Kazakhstan'),
    (1, 234,38,'Chad'),
    (1, 235,39,'Chile'),
    (1, 236,40,'China'),
    (1, 237,41,'Cyprus'),
    (1, 238,42,'Colombia'),
    (1, 239,43,'Comoros'),
    (1, 240,44,'North Korea'),
    (1, 241,45,'South Korea'),
    (1, 242,46,'Ivory Coast'),
    (1, 243,47,'Costa Rica'),
    (1, 244,48,'Croatia'),
    (1, 245,49,'Cuba'),
    (1, 246,50,'Denmark'),
    (1, 247,51,'Dominica'),
    (1, 248,52,'Egypt'),
    (1, 249,53,'United Arab Emirates'),
    (1, 250,54,'Ecuador'),
    (1, 251,55,'Eritrea'),
    (1, 252,56,'Slovakia'),
    (1, 253,57,'Slovenia'),
    (1, 254,58,'Spain'),
    (1, 255,59,'United States'),
    (1, 256,60,'Estonia'),
    (1, 257,61,'Eswatini'),
    (1, 258,62,'Ethiopia'),
    (1, 259,63,'Fiji'),
    (1, 260,64,'Philippines'),
    (1, 261,65,'Finland'),
    (1, 262,66,'France'),
    (1, 263,67,'Gabon'),
    (1, 264,68,'Gambia'),
    (1, 265,69,'Ghana'),
    (1, 266,70,'Georgia'),
    (1, 267,71,'Grenada'),
    (1, 268,72,'Greece'),
    (1, 269,73,'Guatemala'),
    (1, 270,74,'Guyana'),
    (1, 271,75,'Guinea'),
    (1, 272,76,'Equatorial Guinea'),
    (1, 273,77,'Guinea-Bissau'),
    (1, 274,78,'Haiti'),
    (1, 275,79,'Honduras'),
    (1, 276,80,'Hungary'),
    (1, 277,81,'Yemen'),
    (1, 278,82,'Marshall Islands'),
    (1, 279,83,'Solomon Islands'),
    (1, 280,84,'India'),
    (1, 281,85,'Indonesia'),
    (1, 282,86,'Iran'),
    (1, 283,87,'Iraq'),
    (1, 284,88,'Ireland'),
    (1, 285,89,'Iceland'),
    (1, 286,90,'Israel'),
    (1, 287,91,'Italy'),
    (1, 288,92,'Jamaica'),
    (1, 289,93,'Japan'),
    (1, 290,94,'Djibouti'),
    (1, 291,95,'Jordan'),
    (1, 292,96,'Kosovo'),
    (1, 293,97,'Kuwait'),
    (1, 294,98,'Laos'),
    (1, 295,99,'Lesotho'),
    (1, 296,100,'Latvia'),
    (1, 297,101,'Lebanon'),
    (1, 298,102,'Liberia'),
    (1, 299,103,'Libya'),
    (1, 300,104,'Liechtenstein'),
    (1, 301,105,'Lithuania'),
    (1, 302,106,'Luxembourg'),
    (1, 303,107,'North Macedonia'),
    (1, 304,108,'Madagascar'),
    (1, 305,109,'Malaysia'),
    (1, 306,110,'Malawi'),
    (1, 307,111,'Maldives'),
    (1, 308,112,'Mali'),
    (1, 309,113,'Malta'),
    (1, 310,114,'Morocco'),
    (1, 311,115,'Mauritius'),
    (1, 312,116,'Mauritania'),
    (1, 313,117,'Mexico'),
    (1, 314,118,'Micronesia'),
    (1, 315,119,'Mozambique'),
    (1, 316,120,'Moldova'),
    (1, 317,121,'Monaco'),
    (1, 318,122,'Mongolia'),
    (1, 319,123,'Montenegro'),
    (1, 320,124,'Myanmar'),
    (1, 321,125,'Namibia'),
    (1, 322,126,'Nauru'),
    (1, 323,127,'Nepal'),
    (1, 324,128,'Nicaragua'),
    (1, 325,129,'Niger'),
    (1, 326,130,'Nigeria'),
    (1, 327,131,'Norway'),
    (1, 328,132,'New Zealand'),
    (1, 329,133,'Oman'),
    (1, 330,134,'Netherlands'),
    (1, 331,135,'Palau'),
    (1, 332,136,'Panama'),
    (1, 333,137,'Papua New Guinea'),
    (1, 334,138,'Pakistan'),
    (1, 335,139,'Paraguay'),
    (1, 336,140,'Peru'),
    (1, 337,141,'Poland'),
    (1, 338,142,'Portugal'),
    (1, 339,143,'Kenya'),
    (1, 340,144,'Kyrgyzstan'),
    (1, 341,145,'Kiribati'),
    (1, 342,146,'United Kingdom'),
    (1, 343,147,'Central African Republic'),
    (1, 344,148,'Czech Republic'),
    (1, 345,149,'Democratic Republic of the Congo'),
    (1, 346,150,'Republic of the Congo'),
    (1, 347,151,'Dominican Republic'),
    (1, 348,152,'Romania'),
    (1, 349,153,'Rwanda'),
    (1, 350,154,'Russia'),
    (1, 351,155,'North Salisbury'),
    (1, 352,156,'Samoa'),
    (1, 353,157,'Saint Lucia'),
    (1, 354,158,'Saint Kitts and Nevis'),
    (1, 355,159,'San Marino'),
    (1, 356,160,'São Tomé and Príncipe'),
    (1, 357,161,'Saint Vincent and the Grenadines'),
    (1, 358,162,'Seychelles'),
    (1, 359,163,'Senegal'),
    (1, 360,164,'Sierra Leone'),
    (1, 361,165,'Serbia'),
    (1, 362,166,'Singapore'),
    (1, 363,167,'Syria'),
    (1, 364,168,'Somalia'),
    (1, 365,169,'Sri Lanka'),
    (1, 366,170,'Sudan'),
    (1, 367,171,'South Sudan'),
    (1, 368,172,'Sweden'),
    (1, 369,173,'Switzerland'),
    (1, 370,174,'Suriname'),
    (1, 371,175,'Thailand'),
    (1, 372,176,'Taiwan'),
    (1, 373,177,'Tajikistan'),
    (1, 374,178,'Tanzania'),
    (1, 375,179,'Timor-Leste'),
    (1, 376,180,'Togo'),
    (1, 377,181,'Tonga'),
    (1, 378,182,'Trinidad and Tobago'),
    (1, 379,183,'Tunisia'),
    (1, 380,184,'Turkmenistan'),
    (1, 381,185,'Turkey'),
    (1, 382,186,'Tuvalu'),
    (1, 383,187,'Ukraine'),
    (1, 384,188,'Uganda'),
    (1, 385,189,'Uruguay'),
    (1, 386,190,'Uzbekistan'),
    (1, 387,191,'Vanuatu'),
    (1, 388,192,'Vatican'),
    (1, 389,193,'Venezuela'),
    (1, 390,194,'Vietnam'),
    (1, 391,195,'Zambia'),
    (1, 392,196,'Zimbabwe'),
    (1, 393,197,'Palestina'),
    (1, 394,197,'Palestine'),
    (1, 395,198,'El Salvador');


INSERT INTO R_PAISES_APELIDOS(ID_APELIDO_PAIS, ID_TIPO_APELIDO, ID_PAIS, APELIDO) VALUES (395, 2, 40, 'China-Hong Kong');
INSERT INTO R_PAISES_APELIDOS(ID_APELIDO_PAIS, ID_TIPO_APELIDO, ID_PAIS, APELIDO) VALUES (396, 2, 40, 'China-Macau');
INSERT INTO R_PAISES_APELIDOS(ID_APELIDO_PAIS, ID_TIPO_APELIDO, ID_PAIS, APELIDO) VALUES (397, 2, 40, 'China-Taiwan');

INSERT INTO R_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES (1, 'BRICS', 'BRICS');
INSERT INTO R_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES (2, 'Mercosul', 'Mercosur');
INSERT INTO R_GRUPOS_GEOPOLITICOS(ID_GRUPO_GEOPOLITICO, NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES (3, 'América Latina', 'Latin America');

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
    ID_UNIVERSIDADE, NOME_UNIVERSIDADE_PORTUGUES, NOME_UNIVERSIDADE_INGLES, SIGLA, ID_APELIDO_PAIS
) VALUES
    (1, 'Universidade Federal de Santa Maria', 'Federal University of Santa Maria', 'UFSM', 26),
    (2, 'Universidade Federal do Pampa', 'Federal University of the Pampa', 'Unipampa', 26);

INSERT INTO R_UNIVERSIDADES_APELIDOS(ID_APELIDO_UNIVERSIDADE, ID_UNIVERSIDADE, APELIDO) VALUES
    (1, 1, 'Universidade Federal de Santa Maria'),
    (2, 1, 'Federal University of Santa Maria'),
    (3, 1, 'UFSM'),
    (4, 2, 'Universidade Federal do Pampa'),
    (5, 2, 'Federal University of the Pampa'),
    (6, 2, 'Unipampa');

INSERT INTO R_UNIVERSIDADES_GRUPOS(ID_GRUPO_UNIVERSIDADES, NOME_GRUPO_PORTUGUES, NOME_GRUPO_INGLES) VALUES
    (1, 'Universidades Federais Gaúchas', 'Federal Universities from Rio Grande do Sul');

INSERT INTO R_UNIVERSIDADES_PARA_GRUPOS(ID_GRUPO_UNIVERSIDADES, ID_UNIVERSIDADE) VALUES (1, 1);
INSERT INTO R_UNIVERSIDADES_PARA_GRUPOS(ID_GRUPO_UNIVERSIDADES, ID_UNIVERSIDADE) VALUES (1, 2);

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (1, 'Shanghai');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_PORTUGUES, NOME_PILAR_INGLES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
(1, 1, 'Alumni', 'Alumni',  NULL, NULL),
(1, 2, 'N&S', 'N&S', NULL, NULL),
(1, 3, 'PUB', 'PUB', NULL, NULL),
(1, 4, 'PCP', 'PCP', NULL, NULL),
(1, 5, 'Award', 'Award', NULL, NULL),
(1, 6, 'HiCi', 'HiCi', NULL, NULL),
(1, 7, 'Geral', 'Total Score', NULL, NULL),
(1, 8, 'Posição no Ranking Mundial', 'World Rank', NULL, NULL);

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (2, 'Times Higher Education - World Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (2,  9, 'World Rank', 'Posição no Ranking Mundial', NULL, NULL),
    (2, 10, 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    (2, 11, 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    (2, 12, 'Teaching (Score)', 'Ensino (Score)', NULL, NULL),
    (2, 13, 'Teaching (Rank)', 'Ensino (Rank)', NULL, NULL),
    (2, 14, 'International Outlook (Score)', 'Perspectiva Internacional (Score)', NULL, NULL),
    (2, 15, 'International Outlook (Rank)', 'Perspectiva Internacional (Rank)', NULL, NULL),
    (2, 16, 'Industry Income (Score)', 'Investimento da Indústria (Score)', NULL, NULL),
    (2, 17, 'Industry Income (Rank)', 'Investimento da Indústria (Rank)', NULL, NULL),
    (2, 18, 'Research (Score)', 'Pesquisa (Score)', NULL, NULL),
    (2, 19, 'Research (Rank)', 'Pesquisa (Rank)', NULL, NULL),
    (2, 20, 'Citations (Score)', 'Citações (Score)', NULL, NULL),
    (2, 21, 'Citations (Rank)', 'Citações (Rank)', NULL, NULL)
 ;

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (3, 'Times Higher Education - Latin Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (3, 22, 'World Rank', 'Posição no Ranking Mundial', NULL, NULL),
    (3, 23, 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    (3, 24, 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    (3, 25, 'Teaching (Score)', 'Ensino (Score)', NULL, NULL),
    (3, 26, 'Teaching (Rank)', 'Ensino (Rank)', NULL, NULL),
    (3, 27, 'International Outlook (Score)', 'Perspectiva Internacional (Score)', NULL, NULL),
    (3, 28, 'International Outlook (Rank)', 'Perspectiva Internacional (Rank)', NULL, NULL),
    (3, 29, 'Industry Income (Score)', 'Investimento da Indústria (Score)', NULL, NULL),
    (3, 30, 'Industry Income (Rank)', 'Investimento da Indústria (Rank)', NULL, NULL),
    (3, 31, 'Research (Score)', 'Pesquisa (Score)', NULL, NULL),
    (3, 32, 'Research (Rank)', 'Pesquisa (Rank)', NULL, NULL),
    (3, 33, 'Citations (Score)', 'Citações (Score)', NULL, NULL),
    (3, 34, 'Citations (Rank)', 'Citações (Rank)', NULL, NULL)
 ;

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (4, 'Times Higher Education - Impact Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (4, 35, 'World Rank', 'Posição no Ranking Mundial', NULL, NULL),
    (4, 36, 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    (4, 37, 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    (4, 38, 'no Poverty (Score)', 'no Poverty (Score)', NULL, NULL),
    (4, 39, 'no Poverty (Rank)', 'no Poverty (Rank)', NULL, NULL),
    (4, 40, 'Decent Work and Economic Growth (Score)', 'Decent Work and Economic Growth (Score)', NULL, NULL),
    (4, 41, 'Decent Work and Economic Growth (Rank)', 'Decent Work and Economic Growth (Rank)', NULL, NULL),
    (4, 42, 'Life Below Water (Score)', 'Life Below Water (Score)', NULL, NULL),
    (4, 43, 'Life Below Water (Rank)', 'Life Below Water (Rank)', NULL, NULL),
    (4, 44, 'Climate Action (Score)', 'Climate Action (Score)', NULL, NULL),
    (4, 45, 'Climate Action (Rank)', 'Climate Action (Rank)', NULL, NULL),
    (4, 46, 'Partnership for the Goals (Score)', 'Partnership for the Goals (Score)', NULL, NULL),
    (4, 47, 'Partnership for the Goals (Rank)', 'Partnership for the Goals (Rank)', NULL, NULL),
    (4, 48, 'Quality Education (Score)', 'Quality Education (Score)', NULL, NULL),
    (4, 49, 'Quality Education (Rank)', 'Quality Education (Rank)', NULL, NULL),
    (4, 50, 'Industry Innovation and Infrastructure (Score)', 'Industry Innovation and Infrastructure (Score)', NULL, NULL),
    (4, 51, 'Industry Innovation and Infrastructure (Rank)', 'Industry Innovation and Infrastructure (Rank)', NULL, NULL),
    (4, 52, 'Gender Equality (Score)', 'Gender Equality (Score)', NULL, NULL),
    (4, 53, 'Gender Equality (Rank)', 'Gender Equality (Rank)', NULL, NULL),
    (4, 54, 'Good Health and Well-being (Score)', 'Good Health and Well-being (Score)', NULL, NULL),
    (4, 55, 'Good Health and Well-being (Rank)', 'Good Health and Well-being (Rank)', NULL, NULL),
    (4, 56, 'Zero Hunger (Score)', 'Zero Hunger (Score)', NULL, NULL),
    (4, 57, 'Zero Hunger (Rank)', 'Zero Hunger (Rank)', NULL, NULL),
    (4, 58, 'Peace, Justice and Strong Institutions (Score)', 'Peace, Justice and Strong Institutions (Score)', NULL, NULL),
    (4, 59, 'Peace, Justice and Strong Institutions (Rank)', 'Peace, Justice and Strong Institutions (Rank)', NULL, NULL),
    (4, 60, 'Sustainable Cities and Communities (Score)', 'Sustainable Cities and Communities (Score)', NULL, NULL),
    (4, 61, 'Sustainable Cities and Communities (Rank)', 'Sustainable Cities and Communities (Rank)', NULL, NULL),
    (4, 62, 'Life On Land (Score)', 'Life On Land (Score)', NULL, NULL),
    (4, 63, 'Life On Land (Rank)', 'Life On Land (Rank)', NULL, NULL),
    (4, 64, 'Responsible Consumption and Production (Score)', 'Responsible Consumption and Production (Score)', NULL, NULL),
    (4, 65, 'Responsible Consumption and Production (Rank)', 'Responsible Consumption and Production (Rank)', NULL, NULL),
    (4, 66, 'Clean Water and Sanitation (Score)', 'Clean Water and Sanitation (Score)', NULL, NULL),
    (4, 67, 'Clean Water and Sanitation (Rank)', 'Clean Water and Sanitation (Rank)', NULL, NULL),
    (4, 68, 'Reduced Inequalities (Score)', 'Reduced Inequalities (Score)', NULL, NULL),
    (4, 69, 'Reduced Inequalities (Rank)', 'Reduced Inequalities (Rank)', NULL, NULL),
    (4, 70, 'Affordable and Clean Energy (Score)', 'Affordable and Clean Energy (Score)', NULL, NULL),
    (4, 71, 'Affordable and Clean Energy (Rank)', 'Affordable and Clean Energy (Rank)', NULL, NULL);

INSERT INTO R_METRICAS(ID_METRICA, NOME_METRICA_INGLES, NOME_METRICA_PORTUGUES) VALUES
    (1, 'Number of Students', 'Número de estudantes'),
    (2, 'Students to Staff Ratio', 'Proporção de estudantes para funcionários'),
    (3, 'Percent of International Students', 'Porcentagem de estudantes internacionais'),
    (4, 'Female to male students ratio', 'Proporção de estudantes mulheres para estudantes homens');

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (5, 'QS World Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (5,  72, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (5,  73, 'World Rank', 'World Rank', NULL, NULL),
    (5,  74, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (5,  75, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (5,  76, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (5,  77, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (5,  78, 'Faculty Student (Rank)', 'Faculty Student (Rank)', NULL, NULL),
    (5,  79, 'Faculty Student (Score)', 'Faculty Student (Score)', NULL, NULL),
    (5,  80, 'International Faculty (Rank)', 'International Faculty (Rank)', NULL, NULL),
    (5,  81, 'International Faculty (Score)', 'International Faculty (Score)', NULL, NULL),
    (5,  82, 'International Students (Rank)', 'International Students (Rank)', NULL, NULL),
    (5,  83, 'International Students (Score)', 'International Students (Score)', NULL, NULL),
    (5,  84, 'Citations per Faculty (Rank)', 'Citations per Faculty (Rank)', NULL, NULL),
    (5,  85, 'Citations per Faculty (Score)', 'Citations per Faculty (Score)', NULL, NULL),
    (5,  86, 'Arts & Humanities (Rank)', 'Arts & Humanities (Rank)', NULL, NULL),
    (5,  87, 'Arts & Humanities (Score)', 'Arts & Humanities (Score)', NULL, NULL),
    (5,  88, 'Engineering & Technology (Rank)', 'Engineering & Technology (Rank)', NULL, NULL),
    (5,  89, 'Engineering & Technology (Score)', 'Engineering & Technology (Score)', NULL, NULL),
    (5,  90, 'Life Sciences & Medicine (Rank)', 'Life Sciences & Medicine (Rank)', NULL, NULL),
    (5,  91, 'Life Sciences & Medicine (Score)', 'Life Sciences & Medicine (Score)', NULL, NULL),
    (5,  92, 'Natural Sciences (Rank)', 'Natural Sciences (Rank)', NULL, NULL),
    (5,  93, 'Natural Sciences (Score)', 'Natural Sciences (Score)', NULL, NULL),
    (5,  94, 'Social Sciences & Management (Rank)', 'Social Sciences & Management (Rank)', NULL, NULL),
    (5,  95, 'Social Sciences & Management (Score)', 'Social Sciences & Management (Score)', NULL, NULL),
    (5,  96, 'International Students Ratio (Rank)', 'International Students Ratio (Rank)', NULL, NULL),
    (5,  97, 'International Students Ratio (Score)', 'International Students Ratio (Score)', NULL, NULL),
    (5,  98, 'International Faculty Ratio (Rank)', 'International Faculty Ratio (Rank)', NULL, NULL),
    (5,  99, 'International Faculty Ratio (Score)', 'International Faculty Ratio (Score)', NULL, NULL),
    (5, 100, 'Faculty Student Ratio (Rank)', 'Faculty Student Ratio (Rank)', NULL, NULL),
    (5, 101, 'Faculty Student Ratio (Score)', 'Faculty Student Ratio (Score)', NULL, NULL),
    (5, 102, 'Social Sciences and Management (Rank)', 'Social Sciences and Management (Rank)', NULL, NULL),
    (5, 103, 'Social Sciences and Management (Score)', 'Social Sciences and Management (Score)', NULL, NULL),
    (5, 104, 'Life Sciences and Medicine (Rank)', 'Life Sciences and Medicine (Rank)', NULL, NULL),
    (5, 105, 'Life Sciences and Medicine (Score)', 'Life Sciences and Medicine (Score)', NULL, NULL),
    (5, 106, 'Engineering and Technology (Rank)', 'Engineering and Technology (Rank)', NULL, NULL),
    (5, 107, 'Engineering and Technology (Score)', 'Engineering and Technology (Score)', NULL, NULL),
    (5, 108, 'Arts and Humanities (Rank)', 'Arts and Humanities (Rank)', NULL, NULL),
    (5, 109, 'Arts and Humanities (Score)', 'Arts and Humanities (Score)', NULL, NULL),
    (5, 110, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (5, 111, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL),
    (5, 112, 'Employment Outcomes (Rank)', 'Employment Outcomes (Rank)', NULL, NULL),
    (5, 113, 'Employment Outcomes (Score)', 'Employment Outcomes (Score)', NULL, NULL),
    (5, 114, 'Sustainability (Rank)', 'Sustainability (Rank)', NULL, NULL),
    (5, 115, 'Sustainability (Score)', 'Sustainability (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (6, 'QS Latin America Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (6, 116, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (6, 117, 'World Rank', 'World Rank', NULL, NULL),
    (6, 118, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (6, 119, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (6, 120, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (6, 121, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (6, 122, 'Faculty Student (Rank)', 'Faculty Student (Rank)', NULL, NULL),
    (6, 123, 'Faculty Student (Score)', 'Faculty Student (Score)', NULL, NULL),
    (6, 124, 'Faculty Staff with PhD (Rank)', 'Faculty Staff with PhD (Rank)', NULL, NULL),
    (6, 125, 'Faculty Staff with PhD (Score)', 'Faculty Staff with PhD (Score)', NULL, NULL),
    (6, 126, 'Web Impact (Rank)', 'Web Impact (Rank)', NULL, NULL),
    (6, 127, 'Web Impact (Score)', 'Web Impact (Score)', NULL, NULL),
    (6, 128, 'Papers per Faculty (Rank)', 'Papers per Faculty (Rank)', NULL, NULL),
    (6, 129, 'Papers per Faculty (Score)', 'Papers per Faculty (Score)', NULL, NULL),
    (6, 130, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (6, 131, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (6, 132, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (6, 133, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL),
    (6, 134, 'Faculty Student Ratio (Rank)', 'Faculty Student Ratio (Rank)', NULL, NULL),
    (6, 135, 'Faculty Student Ratio (Score)', 'Faculty Student Ratio (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (7, 'QS World University Rankings by Subject - Arts & Humanities');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (7, 136, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (7, 137, 'World Rank', 'World Rank', NULL, NULL),
    (7, 138, 'Stars', 'Stars', NULL, NULL),
    (7, 139, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (7, 140, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (7, 141, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (7, 142, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (7, 143, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (7, 144, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (7, 145, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (7, 146, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (7, 147, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (7, 148, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (8, 'QS World University Rankings by Subject - Engineering and Technology');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (8, 149, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (8, 150, 'World Rank', 'World Rank', NULL, NULL),
    (8, 151, 'Stars', 'Stars', NULL, NULL),
    (8, 152, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (8, 153, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (8, 154, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (8, 155, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (8, 156, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (8, 157, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (8, 158, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (8, 159, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (8, 160, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (8, 161, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (9, 'QS World University Rankings by Subject - Life Sciences & Medicine');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (9, 162, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (9, 163, 'World Rank', 'World Rank', NULL, NULL),
    (9, 164, 'Stars', 'Stars', NULL, NULL),
    (9, 165, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (9, 166, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (9, 167, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (9, 168, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (9, 169, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (9, 170, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (9, 171, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (9, 172, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (9, 173, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (9, 174, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(ID_RANKING, NOME_RANKING) VALUES (10, 'QS World University Rankings by Subject - Natural Sciences');
INSERT INTO R_PILARES(
    ID_RANKING, ID_PILAR, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (10, 175, 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    (10, 176, 'World Rank', 'World Rank', NULL, NULL),
    (10, 177, 'Stars', 'Stars', NULL, NULL),
    (10, 178, 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    (10, 179, 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    (10, 180, 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    (10, 181, 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    (10, 182, 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    (10, 183, 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    (10, 184, 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    (10, 185, 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    (10, 186, 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    (10, 187, 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);
