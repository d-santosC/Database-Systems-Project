INSERT IGNORE INTO Morada (Rua, CodigoPostal, Porta, Andar, Distrito, Concelho, Freguesia, Pais)
VALUES 
('Rua das Violetas', '2870-001', '11', '0', 'Setubal', 'Montijo', 'Montijo', 'Portugal'),
('Rua Montepio Rainha D.Leonor', '2500-253', '2', '2', 'Leiria', 'Caldas da Rainha', 'Caldas da Rainha', 'Portugal'),
('Avenidade Engenheiro Duarte Pacheco', '8000-075', '1', '0', 'Faro', 'Albufeira', 'Albufeira', 'Portugal'),
('Avenidade Terra Nostra', '2735-047', '36', '4', 'Setubal', 'Montijo', 'Montijo', 'Portugal'),
('Rua das Camélias', '2900-001', '10', '3', 'Setubal', 'Setubal', 'São Julião', 'Portugal'),
('Rua do Sol', '1000-050', '5', '2', 'Lisboa', 'Lisboa', 'Santa Maria Maior', 'Portugal'),
('Avenida dos Pescadores', '4000-200', '12', '1', 'Porto', 'Porto', 'Foz', 'Portugal'),
('Travessa das Flores', '3030-120', '8', '0', 'Coimbra', 'Coimbra', 'Santa Clara', 'Portugal'),
('Praça do Comércio', '1100-148', '1', '0', 'Lisboa', 'Lisboa', 'Santa Maria Maior', 'Portugal'),
('Rua da Liberdade', '5000-010', '15', '1', 'Vila Real', 'Peso da Régua', 'Peso da Régua', 'Portugal'),
('Rua do Castelo', '7000-540', '20', '2', 'Évora', 'Évora', 'Sé e São Pedro', 'Portugal'),
('Rua das Palmeiras', '8005-092', '7', '0', 'Faro', 'Faro', 'Sé', 'Portugal'),
('Rua Nova', '9000-001', '3', '0', 'Madeira', 'Funchal', 'Sé', 'Portugal'),
('Rua Alta', '6000-123', '2', '1', 'Castelo Branco', 'Covilhã', 'Teixoso', 'Portugal'),
('Rua do Carmo', '1200-004', '6', '3', 'Lisboa', 'Lisboa', 'Santa Maria Maior', 'Portugal'),
('Rua da Saudade', '4000-123', '8', '0', 'Porto', 'Porto', 'Bonfim', 'Portugal'),
('Avenida da República', '2900-678', '15', '2', 'Setubal', 'Setubal', 'São Julião', 'Portugal'),
('Travessa do Comércio', '8000-220', '11', '1', 'Faro', 'Faro', 'Sé', 'Portugal'),
('Rua das Laranjeiras', '1100-333', '4', '3', 'Lisboa', 'Lisboa', 'Alvalade', 'Portugal'),
('Praça das Nações', '3030-987', '10', '2', 'Coimbra', 'Coimbra', 'Santa Clara', 'Portugal'),
('Rua da Alegria', '5000-111', '14', '1', 'Vila Real', 'Peso da Régua', 'Peso da Régua', 'Portugal'),
('Rua dos Combatentes', '7000-600', '18', '0', 'Évora', 'Évora', 'Horta das Figueiras', 'Portugal'),
('Avenida das Estrelas', '6000-234', '2', '1', 'Castelo Branco', 'Covilhã', 'Boidobra', 'Portugal'),
('Rua do Horizonte', '8005-333', '7', '3', 'Faro', 'Faro', 'Sé', 'Portugal');

INSERT INTO ParqueEstacionamento (Localidade, Latitude, Longitude)
VALUES 
('Montijo', 38.716667, -9.139167),
('Leiria', 41.14961, -8.61099),
('Faro', 40.64050, -8.65379);

INSERT INTO Lugar (MatriculaVeiculo, Piso, Fila, Posicao, LocalidadeParque)
VALUES 
('AB-23-CD', 1, 'A', 10, 'Montijo'),
('IJ-67-KL', '0', 'D', 2, 'Montijo'),
(NULL, '2', 'C', 5, 'Montijo'),

('EF-45-GH', 2, 'B', 15, 'Leiria'),
(NULL, 2, 'B', 15, 'Leiria'),
(NULL, 2, 'B', 15, 'Leiria'),

('HM-22-CC0', '0', 'C', 5, 'Faro'),
(NULL, '0', 'C', 5, 'Faro'),
(NULL, '0', 'C', 5, 'Faro');

INSERT INTO TipoVeiculo (Chassi, IDTipo, Modelo, Tipo, Marca, Imagem)
VALUES 
('WHGCM82633A123456','1','Model S', 'Comercial', 'Tesla', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/tesla_modelS.png')),
('PTUCM768576A18475','2','Accord', 'Familiar', 'Honda', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/honda_accord.png')),
('DENCM09865A185069','3','HAYABUSA', 'Motociclo', 'Suzuki', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/suzuki_hayabusa.png')),
('GODAM05565B183333','1','Kangoo', 'Comercial', 'Renault', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/renault_kangoo.png')),
('FFEMM44441C152411','2','3008', 'Familiar', 'Peugeot', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/peugeot_3008.png')),
('TESLA12345A192834', '1', 'Model 3', 'Comercial', 'Tesla', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/tesla_model3.png')),
('FORD67890B1839001', '3', 'Focus', 'Comercial', 'Ford', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/ford_focus.png')),
('TOYO12312C1923892', '3', 'Corolla', 'Comercial', 'Toyota', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/toyota_corolla.png')),
('HYUN98765D1843214', '2', 'Ioniq', 'Familiar', 'Hyundai', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/hyundai_ioniq.png')),
('MERC45678E1930125', '1', 'Sprinter', 'Comercial', 'Mercedes-Benz', LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 9.1/Uploads/mercedes_sprinter.png'));

INSERT INTO Tarifa (CustoDiaUtil, CustoDiaNaoUtil, IDTipoTarifa)
VALUES 
(10, 15, 1),
(5, 7, 2),
(2, 5, 3);

INSERT INTO Veiculo (Matricula, TipoMotor, CapacidadeCarga, Potencia, QuilometrosFeitos, QuantidadeLugares, QuantidadePortas, IDTipoVeiculo, LocalidadeVeiculo, ChassiVeiculo)
VALUES 
('AB-23-CD', 'Elétrico', 2500.0, 200.0, 5000, 5, 5, 1, 'Montijo', 'WHGCM82633A123456'),
('EF-45-GH', 'Híbrido', 5000.0, 75.0, 1250, 5, 5, 2, 'Leiria', 'PTUCM768576A18475'),
('IJ-67-KL', 'Gasolina', 700.0, 150.0, 2000, 2, 0, 3, 'Montijo', 'DENCM09865A185069'),
('XX-56-YY', 'Gasolina', 1000.0, 70.0, 7000, 5, 5, 1, 'Leiria', 'GODAM05565B183333'),
('HM-22-CC', 'Híbrido', 1500.0, 100.0, 15000, 7, 5, 2, 'Faro', 'FFEMM44441C152411'),
('BC-12-XY', 'Elétrico', 3000.0, 180.0, 4500, 5, 5, 1, 'Montijo', 'TESLA12345A192834'),
('QR-34-WE', 'Gasolina', 1200.0, 90.0, 8000, 5, 5, 3, 'Faro', 'FORD67890B1839001'),
('LM-78-NO', 'Gasolina', 900.0, 160.0, 6000, 4, 3, 3, 'Leiria', 'TOYO12312C1923892'),
('OP-90-HG', 'Híbrido', 2500.0, 110.0, 10000, 7, 5, 2, 'Montijo', 'HYUN98765D1843214'),
('ZX-01-CV', 'Gasolina', 5000.0, 75.0, 1200, 5, 5, 1, 'Faro', 'MERC45678E1930125');

INSERT INTO Intervencao (Tipo, DataIntervencao, MatriculaVeiculo)
VALUES 
('Manutenção', '2024-01-15', 'AB-23-CD'),
('Reparação', '2024-02-20', 'EF-45-GH'),
('Manutenção', '2024-03-10', 'IJ-67-KL');

INSERT IGNORE INTO Cliente (NIF, Nome, Contacto, Moeda, Tipo, Rua, Porta, Andar, CodigoPostal)
VALUES 
('227904568', 'Maria Francisca', '912345678', 'EUR', 'Pessoa', 'Rua das Violetas' , '11', '0', '2870-001'),
('778549014', 'Empresa SBD', '212345679', 'EUR', 'Empresa', 'Rua Montepio Rainha D.Leonor' , '2', '2', '2500-253'),
('341', 'Bernardo Alberto', '934567866', 'EUR', 'Pessoa', 'Avenidade Luis Gomes', '2', '1', '2300-565'), -- viola restrição nª3
('345927071', 'Francisco Mário', '912345680', 'EUR', 'Pessoa', 'Avenidade Engenheiro Duarte Pacheco', '1', '0', '8000-075'),
('444456789', 'Silvia Esteves', '935554441', 'EUR', 'Pessoa', 'Avenidade Terra Nostra', '36', '4', '2735-047'),
('123456780', 'João Silva', '912345123', 'EUR', 'Pessoa', 'Rua das Camélias', '10', '3', '2900-001'),
('123456781', 'Ana Lopes', '911112222', 'EUR', 'Pessoa', 'Rua do Sol', '5', '2', '1000-050'),
('123456782', 'Carlos Marques', '913333444', 'EUR', 'Pessoa', 'Avenida dos Pescadores', '12', '1', '4000-200'),
('123456783', 'Empresa XYZ', '222333444', 'EUR', 'Empresa', 'Travessa das Flores', '8', '0', '3030-120'),
('123456784', 'Rita Costa', '915555666', 'EUR', 'Pessoa', 'Praça do Comércio', '1', '0', '1100-148'),
('123456785', 'Empresa ABC', '223344556', 'EUR', 'Empresa', 'Rua da Liberdade', '15', '1', '5000-010'),
('123456786', 'Pedro Almeida', '917777888', 'EUR', 'Pessoa', 'Rua do Castelo', '20', '2', '7000-540'),
('123456787', 'Marta Figueiredo', '918888999', 'EUR', 'Pessoa', 'Rua das Palmeiras', '7', '0', '8005-092'),
('123456788', 'Empresa LMN', '334455667', 'EUR', 'Empresa', 'Rua Nova', '3', '0', '9000-001'),
('123456789', 'José Pereira', '919999000', 'EUR', 'Pessoa', 'Rua Alta', '2', '1', '6000-123'),
('223456781', 'Vítor Manuel', '912345987', 'EUR', 'Pessoa', 'Rua do Carmo', '6', '3', '1200-004'),
('223456782', 'Joana Ribeiro', '913456123', 'EUR', 'Pessoa', 'Rua da Saudade', '8', '0', '4000-123'),
('223456783', 'Empresa DEF', '222555444', 'EUR', 'Empresa', 'Avenida da República', '15', '2', '2900-678'),
('223456784', 'André Coelho', '914567234', 'EUR', 'Pessoa', 'Travessa do Comércio', '11', '1', '8000-220'),
('223456785', 'Beatriz Silva', '915678345', 'EUR', 'Pessoa', 'Rua das Laranjeiras', '4', '3', '1100-333'),
('223456786', 'Empresa GHI', '333666555', 'EUR', 'Empresa', 'Praça das Nações', '10', '2', '3030-987'),
('223456787', 'Filipe Costa', '916789456', 'EUR', 'Pessoa', 'Rua da Alegria', '14', '1', '5000-111'),
('223456788', 'Carla Santos', '917890567', 'EUR', 'Pessoa', 'Rua dos Combatentes', '18', '0', '7000-600'),
('223456789', 'Hugo Pereira', '918901678', 'EUR', 'Pessoa', 'Avenida das Estrelas', '2', '1', '6000-234'),
('223456790', 'Rafael Gonçalves', '919012789', 'EUR', 'Pessoa', 'Rua do Horizonte', '7', '3', '8005-333');

INSERT IGNORE INTO Pessoa (Idade, NIFCliente)
VALUES 
(26, '227904568'),
(21, '210953368'), -- viola restrição nº4
(46, '345927071'),
(32, '123456780'),
(28, '123456781'),
(45, '123456782'),
(34, '123456784'),
(50, '123456786'),
(40, '123456787'),
(29, '123456789'),
(25, '223456781'),
(31, '223456782'),
(40, '223456784'),
(27, '223456785'),
(35, '223456787'),
(29, '223456788'),
(33, '223456789');

INSERT INTO Empresa (CapitalSocial, NIFCliente)
VALUES 
(50000.00, '778549014'),
(20000.00, '123456783'),
(15000.00, '123456785'),
(40000.00, '123456788'),
(30000.00, '223456783'),
(45000.00, '223456786');

INSERT IGNORE INTO Condutor (NumeroCarta, DataEmissao, DataValidade, Reputacao, NIFCliente)
VALUES 
('A1234567', '2020-01-01', '2030-01-01', 10, '227904568'),
('B2345678', '2019-05-10', '2029-05-10', 7, '778549014'),
('D3477789', '2021-09-15', '2031-09-15', 5,'111444222'), -- viola restrição nº1
('C3456789', '2021-09-15', '2031-09-15', 6, '345927071'),
('F3457244', '2020-02-22', '2030-09-15', 10, '444456789'),
('E4567890', '2018-03-15', '2028-03-15', 8, '123456780'),
('G5678901', '2017-07-20', '2027-07-20', 9, '123456781'),
('H6789012', '2021-06-05', '2031-06-05', 6, '123456782'),
('I7890123', '2019-08-14', '2029-08-14', 7, '123456783'),
('J8901234', '2020-11-30', '2030-11-30', 9, '123456784'),
('K9012345', '2021-01-25', '2031-01-25', 10, '123456785'),
('L0123456', '2016-04-12', '2026-04-12', 5, '123456786'),
('M1234567', '2019-09-19', '2029-09-19', 8, '123456787'),
('N2345678', '2015-12-01', '2025-12-01', 7, '123456788'),
('P3456789', '2018-02-10', '2028-02-10', 6, '123456789'),
('Q4567890', '2021-03-03', '2031-03-03', 7, '223456781'),
('R5678901', '2020-08-16', '2030-08-16', 9, '223456782'),
('S6789012', '2019-05-25', '2029-05-25', 10, '223456783'),
('T7890123', '2018-12-14', '2028-12-14', 6, '223456784'),
('U8901234', '2021-09-01', '2031-09-01', 8, '223456785'),
('V9012345', '2019-07-07', '2029-07-07', 7, '223456786'),
('W0123456', '2020-06-22', '2030-06-22', 9, '223456787'),
('X1234567', '2021-11-15', '2031-11-15', 7, '223456788'),
('Y2345678', '2017-04-19', '2027-04-19', 6, '223456789'),
('Z3456789', '2016-10-08', '2026-10-08', 8, '223456790');


INSERT INTO Aluguer (MatriculaAluguer, Tipo, HoraInicio, HoraFim, Custo, Duracao, CodigoDesconto, NIFCliente, NumeroCarta)
VALUES 
('AB-23-CD', 'Comercial', '2025-02-02 08:00:00', '2025-02-2 18:00:00', 10.00, 10.00, NULL, '227904568', 'A1234567'),
('EF-45-GH', 'Familiar', '2025-02-04 09:00:00', '2025-02-04 14:00:00', 2.00, 5.00, 'DISCOUNT20', '778549014', 'B2345678'),
('IJ-67-KL', 'Motociclo', '2025-01-01 00:00:00', '2025-01-11 00:00:00', 10.00, 10.00, 'DISCOUNT10', '345927071', 'C3456789'),
('XX-56-YY', 'Comercial', '2024-10-15 10:00:00', '2024-10-25 00:00:00', 10.00, 10.00, NULL, '444456789', 'F3457244'),
('HM-22-CC', 'Familiar', '2024-11-26 10:00:00', '2024-11-30 18:00:00', 50.00, 5.00, NULL, '123456780', 'E4567890'),
('BC-12-XY', 'Comercial', '2024-10-27 08:00:00', '2024-10-30 20:00:00', 40.00, 4.00, 'DISCOUNT15', '123456781', 'G5678901'),
('QR-34-WE', 'Familiar', '2024-11-28 09:00:00', '2024-11-30 19:00:00', 30.00, 2.00, NULL, '123456782', 'H6789012'),
('LM-78-NO', 'Comercial', '2024-12-29 08:00:00', '2024-12-31 12:00:00', 60.00, 5.00, 'DISCOUNT10', '123456783', 'I7890123'),
('OP-90-HG', 'Familiar', '2024-12-30 08:00:00', '2024-01-02 20:00:00', 35.00, 5.00, NULL, '123456784', 'J8901234'),
('ZX-01-CV', 'Comercial', '2024-01-15 10:00:00', '2024-02-20 18:00:00', 45.00, 5.00, NULL, '123456785', 'K9012345');

INSERT INTO Reservas (Tipo, Marca, HoraInicioReserva, HoraFimReserva, LocalidadeParque, Custo, NumeroCartaCondutor, NIFClienteReserva)
VALUES 
('Comercial', 'Renault', '2024-12-31 09:00:00', '2025-01-3 18:00:00', 'Leiria', '40.00','F3457244', '123456789'),
('Familiar', 'Peugeot', '2024-12-31 09:00:00', '2025-01-3 18:00:00', 'Montijo', '40.00','G5512134', '123456789');


INSERT INTO Avaliacao (Classificacao, Comentario, IDAluguerAval)
VALUES 
(5, 'Excelente serviço!', 1),
(4, 'Muito bom, mas pode melhorar', 2),
(3, 'Serviço razoável', 3),
(4, 'Gostei bastante, mas o veículo estava um pouco sujo.', 4),
(5, 'Veículo em excelente estado!', 5),
(3, 'Bom custo-benefício, mas poderia ser mais rápido.', 6),
(4, 'Serviço eficiente e atendimento cordial.', 7),
(5, 'Motociclo em perfeitas condições, recomendo.', 8),
(4, 'Boa experiência no geral, recomendo para viagens curtas.', 9),
(3, 'O veículo teve alguns problemas mecânicos, mas foi resolvido rapidamente.', 10);
