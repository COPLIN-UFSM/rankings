INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Shanghai');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_PORTUGUES, NOME_PILAR_INGLES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'Alumni (Score)', 'Alumni (Score)',  NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'N&S (Score)', 'N&S (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'PUB (Score)', 'PUB (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'PCP (Score)', 'PCP (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'Award (Score)', 'Award (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'HiCi (Score)', 'HiCi (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'Geral (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Shanghai'), 'Posição no Ranking Mundial (Rank)', 'World (Rank)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Times Higher Education - World Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'World (Rank)', 'Posição no Ranking Mundial', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Teaching (Score)', 'Ensino (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Teaching (Rank)', 'Ensino (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'International Outlook (Score)', 'Perspectiva Internacional (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'International Outlook (Rank)', 'Perspectiva Internacional (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Industry Income (Score)', 'Investimento da Indústria (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Industry Income (Rank)', 'Investimento da Indústria (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Research (Score)', 'Pesquisa (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Research (Rank)', 'Pesquisa (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Citations (Score)', 'Citações (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Citations (Rank)', 'Citações (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Number of Students', 'Número de estudantes', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Students to Staff Ratio', 'Proporção de estudantes para funcionários', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Percent of International Students', 'Porcentagem de estudantes internacionais', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - World Ranking'), 'Female to male students ratio', 'Proporção de estudantes mulheres para estudantes homens', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Times Higher Education - Latin Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'World (Rank)', 'Posição no Ranking Mundial', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Teaching (Score)', 'Ensino (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Teaching (Rank)', 'Ensino (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'International Outlook (Score)', 'Perspectiva Internacional (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'International Outlook (Rank)', 'Perspectiva Internacional (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Industry Income (Score)', 'Investimento da Indústria (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Industry Income (Rank)', 'Investimento da Indústria (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Research (Score)', 'Pesquisa (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Research (Rank)', 'Pesquisa (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Citations (Score)', 'Citações (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Latin Ranking'), 'Citations (Rank)', 'Citações (Rank)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Times Higher Education - Impact Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'World (Rank)', 'Posição no Ranking Mundial', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'no Poverty (Score)', 'no Poverty (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'no Poverty (Rank)', 'no Poverty (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Decent Work and Economic Growth (Score)', 'Decent Work and Economic Growth (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Decent Work and Economic Growth (Rank)', 'Decent Work and Economic Growth (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Life Below Water (Score)', 'Life Below Water (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Life Below Water (Rank)', 'Life Below Water (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Climate Action (Score)', 'Climate Action (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Climate Action (Rank)', 'Climate Action (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Partnership for the Goals (Score)', 'Partnership for the Goals (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Partnership for the Goals (Rank)', 'Partnership for the Goals (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Quality Education (Score)', 'Quality Education (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Quality Education (Rank)', 'Quality Education (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Industry Innovation and Infrastructure (Score)', 'Industry Innovation and Infrastructure (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Industry Innovation and Infrastructure (Rank)', 'Industry Innovation and Infrastructure (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Gender Equality (Score)', 'Gender Equality (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Gender Equality (Rank)', 'Gender Equality (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Good Health and Well-being (Score)', 'Good Health and Well-being (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Good Health and Well-being (Rank)', 'Good Health and Well-being (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Zero Hunger (Score)', 'Zero Hunger (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Zero Hunger (Rank)', 'Zero Hunger (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Peace, Justice and Strong Institutions (Score)', 'Peace, Justice and Strong Institutions (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Peace, Justice and Strong Institutions (Rank)', 'Peace, Justice and Strong Institutions (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Sustainable Cities and Communities (Score)', 'Sustainable Cities and Communities (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Sustainable Cities and Communities (Rank)', 'Sustainable Cities and Communities (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Life On Land (Score)', 'Life On Land (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Life On Land (Rank)', 'Life On Land (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Responsible Consumption and Production (Score)', 'Responsible Consumption and Production (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Responsible Consumption and Production (Rank)', 'Responsible Consumption and Production (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Clean Water and Sanitation (Score)', 'Clean Water and Sanitation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Clean Water and Sanitation (Rank)', 'Clean Water and Sanitation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Reduced Inequalities (Score)', 'Reduced Inequalities (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Reduced Inequalities (Rank)', 'Reduced Inequalities (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Affordable and Clean Energy (Score)', 'Affordable and Clean Energy (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Affordable and Clean Energy (Rank)', 'Affordable and Clean Energy (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Number of Students', 'Número de estudantes', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Students to Staff Ratio', 'Proporção de estudantes para funcionários', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Percent of International Students', 'Porcentagem de estudantes internacionais', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Impact Ranking'), 'Female to male students ratio', 'Proporção de estudantes mulheres para estudantes homens', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'World (Rank)', 'World (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Faculty to Student Ratio (Rank)', 'Faculty to Student Ratio (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Faculty to Student Ratio (Score)', 'Faculty to Student Ratio (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Faculty (Rank)', 'International Faculty (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Faculty (Score)', 'International Faculty (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Students (Rank)', 'International Students (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Students (Score)', 'International Students (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Citations per Faculty (Rank)', 'Citations per Faculty (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Citations per Faculty (Score)', 'Citations per Faculty (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Arts & Humanities (Rank)', 'Arts & Humanities (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Arts & Humanities (Score)', 'Arts & Humanities (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Engineering & Technology (Rank)', 'Engineering & Technology (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Engineering & Technology (Score)', 'Engineering & Technology (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Life Sciences & Medicine (Rank)', 'Life Sciences & Medicine (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Life Sciences & Medicine (Score)', 'Life Sciences & Medicine (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Natural Sciences (Rank)', 'Natural Sciences (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Natural Sciences (Score)', 'Natural Sciences (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Social Sciences & Management (Rank)', 'Social Sciences & Management (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Social Sciences & Management (Score)', 'Social Sciences & Management (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Employment Outcomes (Rank)', 'Employment Outcomes (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Employment Outcomes (Score)', 'Employment Outcomes (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Sustainability (Rank)', 'Sustainability (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'Sustainability (Score)', 'Sustainability (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Student Diversity (Rank)', 'International Student Diversity (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World Ranking'), 'International Student Diversity (Score)', 'International Student Diversity (Score)', NULL, NULL);


INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS Latin America Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'World (Rank)', 'World (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Faculty Staff with PhD (Rank)', 'Faculty Staff with PhD (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Faculty Staff with PhD (Score)', 'Faculty Staff with PhD (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Web Impact (Rank)', 'Web Impact (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Web Impact (Score)', 'Web Impact (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Papers per Faculty (Rank)', 'Papers per Faculty (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Papers per Faculty (Score)', 'Papers per Faculty (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Faculty to Student Ratio (Rank)', 'Faculty Student Ratio (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Latin America Ranking'), 'Faculty to Student Ratio (Score)', 'Faculty Student Ratio (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Arts & Humanities');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'World (Rank)', 'World (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Stars', 'Stars', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Arts & Humanities'), 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Engineering and Technology');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'World (Rank)', 'World (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Stars', 'Stars', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Engineering and Technology'), 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Life Sciences & Medicine');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'World (Rank)', 'World (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Stars', 'Stars', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Life Sciences & Medicine'), 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS World University Rankings by Subject - Natural Sciences');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'World (Rank)', 'World (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Stars', 'Stars', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Academic Reputation (Rank)', 'Academic Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Academic Reputation (Score)', 'Academic Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Citations per Paper (Rank)', 'Citations per Paper (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Citations per Paper (Score)', 'Citations per Paper (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Employer Reputation (Rank)', 'Employer Reputation (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'Employer Reputation (Score)', 'Employer Reputation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'H-index Citations (Rank)', 'H-index Citations (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'H-index Citations (Score)', 'H-index Citations (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'International Research Network (Rank)', 'International Research Network (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS World University Rankings by Subject - Natural Sciences'), 'International Research Network (Score)', 'International Research Network (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Green Metric');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'World (Rank)', 'World (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'Overall (Score)', 'Overall (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'Setting & Infrastructure (Score)', 'Setting & Infrastructure (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'Energy & Climate Change (Score)', 'Energy & Climate Change (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'Waste (Score)', 'Waste (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'Water (Score)', 'Water (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'Transportation (Score)', 'Transportation (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Green Metric'), 'Education & Research (Score)', 'Education & Research (Score)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Ranking Universitário Folha de São Paulo');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Geral (Score)', 'Geral (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Geral (Rank)', 'Geral (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Ensino (Rank)', 'Ensino (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Ensino (Score)', 'Ensino (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Pesquisa (Rank)', 'Pesquisa (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Pesquisa (Score)', 'Pesquisa (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Mercado (Rank)', 'Mercado (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Mercado (Score)', 'Mercado (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Inovação (Rank)', 'Inovação (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Inovação (Score)', 'Inovação (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Internacionalização (Rank)', 'Internacionalização (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Internacionalização (Score)', 'Internacionalização (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Instrução dos Professores (Rank)', 'Instrução dos Professores (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Instrução dos Professores (Score)', 'Instrução dos Professores (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Tempo de dedicação dos Professores (Rank)', 'Tempo de dedicação dos Professores (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Tempo de dedicação dos Professores (Score)', 'Tempo de dedicação dos Professores (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Enade (Rank)', 'Enade (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Enade (Score)', 'Enade (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Desistência (Rank)', 'Desistência (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Desistência (Score)', 'Desistência (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'MEC (Rank)', 'MEC (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'MEC (Score)', 'MEC (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Número de patentes depositadas (Score)', 'Número de patentes depositadas (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Número de patentes depositadas (Rank)', 'Número de patentes depositadas (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Artigos em colaboração com empresas (Score)', 'Artigos em colaboração com empresas (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Artigos em colaboração com empresas (Rank)', 'Artigos em colaboração com empresas (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Citações Internacionais por Docente (Rank)', 'Citações Internacionais por Docente (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Citações Internacionais por Docente (Score)', 'Citações Internacionais por Docente (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Coautoria Internacional (Rank)', 'Coautoria Internacional (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Coautoria Internacional (Score)', 'Coautoria Internacional (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Avaliação do Mercado (Score)', 'Avaliação do Mercado (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Total de Publicação (Rank)', 'Total de Publicação (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Total de Publicação (Score)', 'Total de Publicação (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Total de Citações (Rank)', 'Total de Citações (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Total de Citações (Score)', 'Total de Citações (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Citações por Artigo (Rank)', 'Citações por Artigo (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Citações por Artigo (Score)', 'Citações por Artigo (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Publicações por Docente (Rank)', 'Publicações por Docente (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Publicações por Docente (Score)', 'Publicações por Docente (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Citações por Docente (Rank)', 'Citações por Docente (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Citações por Docente (Score)', 'Citações por Docente (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Publicações em Revistas Nacionais (Rank)', 'Publicações em Revistas Nacionais (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Publicações em Revistas Nacionais (Score)', 'Publicações em Revistas Nacionais (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Recursos Captados (Rank)', 'Recursos Captados (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Recursos Captados (Score)', 'Recursos Captados (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Bolsista CNPq (Rank)', 'Bolsista CNPq (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Bolsista CNPq (Score)', 'Bolsista CNPq (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Teses (Rank)', 'Teses (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Teses (Score)', 'Teses (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Professores com doutorado e mestrado (Rank)', 'Professores com doutorado e mestrado (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Professores com doutorado e mestrado (Score)', 'Professores com doutorado e mestrado (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Nota dos concluintes (Rank)', 'Nota dos concluintes (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Nota dos concluintes (Score)', 'Nota dos concluintes (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Avaliação dos docentes (Rank)', 'Avaliação dos docentes (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Avaliação dos docentes (Score)', 'Avaliação dos docentes (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Número de patentes concedidas (Score)', 'Número de patentes concedidas (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Ranking Universitário Folha de São Paulo'), 'Número de patentes concedidas (Rank)', 'Número de patentes concedidas (Rank)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Times Higher Education - Interdisciplinary Sciences Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'World (Rank)', 'Posição no Ranking Mundial', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Overall (Rank)', 'Geral (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Inputs (Score)', 'Entradas (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Inputs (Rank)', 'Entradas (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Outputs (Score)', 'Saídas (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Outputs (Rank)', 'Saídas (Rank)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Process (Score)', 'Processos (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'Times Higher Education - Interdisciplinary Sciences Ranking'), 'Process (Rank)', 'Processos (Rank)', NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('QS Sustainability Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Overall (Score)', 'Geral (Score)', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'World (Rank)', 'Posição no Ranking Mundial', NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Impact (Rank)','Impacto Ambiental (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Impact (Score)','Impacto Ambiental (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Sustainability (Rank)','Sustentabilidade Ambiental (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Sustainability (Score)','Sustentabilidade Ambiental (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Education (Rank)','Educação Ambiental (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Education (Score)','Educação Ambiental (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Research (Rank)','Pesquisa Ambiental (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Environmental Research (Score)','Pesquisa Ambiental (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Social Impact (Rank)','Impacto Social (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Social Impact (Score)','Impacto Social (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Equality (Rank)','Igualdade (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Equality (Score)','Igualdade (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Knowledge Exchange (Rank)','Troca de Conhecimentos (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Knowledge Exchange (Score)','Troca de Conhecimentos (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Impact of Education (Rank)','Impacto da Educação (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Impact of Education (Score)','Impacto da Educação (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Employability & Opportunities (Rank)','Empregabilidade & Oportunidades (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Employability & Opportunities (Score)','Empregabilidade & Oportunidades (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Health and Wellbeing (Rank)','Saúde e Bem-estar (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Health and Wellbeing (Score)','Saúde e Bem-estar (Score)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Governance (Rank)','Governança (Rank)',NULL, NULL),
    ((SELECT ID_RANKING FROM R_RANKINGS WHERE NOME_RANKING = 'QS Sustainability Ranking'), 'Governance (Score)','Governança (Score)',NULL, NULL);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Unirank Latin America');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES (
    (select ID_RANKING from r_rankings where NOME_RANKING = 'Unirank Latin America'),
    'Rank (Rank)',
    'Rank (Rank)',
    NULL,
    NULL
);

INSERT INTO R_RANKINGS(NOME_RANKING) VALUES ('Webometrics World Ranking');
INSERT INTO R_PILARES(
    ID_RANKING, NOME_PILAR_INGLES, NOME_PILAR_PORTUGUES, DESCRICAO_PILAR_PORTUGUES, DESCRICAO_PILAR_INGLES
) VALUES
    (
       (select ID_RANKING from r_rankings where NOME_RANKING = 'Webometrics World Ranking'),
       'World Rank (Rank)',
       'Ranking Mundial (Rank)',
       NULL,
       NULL
    ), (
       (select ID_RANKING from r_rankings where NOME_RANKING = 'Webometrics World Ranking'),
       'Impact (Rank)',
       'Impacto (Rank)',
       NULL,
       NULL
    ), (
       (select ID_RANKING from r_rankings where NOME_RANKING = 'Webometrics World Ranking'),
       'Openness (Rank)',
       'Abertura (Rank)',
       NULL,
       NULL
    ), (
       (select ID_RANKING from r_rankings where NOME_RANKING = 'Webometrics World Ranking'),
       'Excellence (Rank)',
       'Excelência (Rank)',
       NULL,
       NULL
    );