USE tp_sbd;
ALTER DATABASE tp_sbd CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Morada
CREATE TABLE Morada (
    Rua VARCHAR(255),
    CodigoPostal VARCHAR(20),
    Porta VARCHAR(50),
    Andar VARCHAR(50),
    Distrito VARCHAR(255),
    Concelho VARCHAR(255),
    Freguesia VARCHAR(255),
    Pais VARCHAR(255),
    PRIMARY KEY (Rua, Porta, Andar, CodigoPostal)
);

-- Parque de Estacionamento
CREATE TABLE ParqueEstacionamento (
    Localidade VARCHAR(255) PRIMARY KEY,
    Latitude DOUBLE(10, 8),
    Longitude DOUBLE(11, 8)
);

-- Lugar
CREATE TABLE Lugar (
    IDLugar INT AUTO_INCREMENT PRIMARY KEY,
    MatriculaVeiculo VARCHAR(20),
    Piso INT,
    Fila VARCHAR(50),
    Posicao INT,
    LocalidadeParque VARCHAR(255),
	FOREIGN KEY (LocalidadeParque) REFERENCES ParqueEstacionamento(Localidade)
);

-- Tipo de Veículo
CREATE TABLE TipoVeiculo (
	Chassi VARCHAR(20) PRIMARY KEY,
	IDTipo INT,
    Modelo VARCHAR(255),
    Tipo VARCHAR(255),
    Marca VARCHAR(255),
    Imagem LONGBLOB
);

-- Tarifa
CREATE TABLE Tarifa (
	IDTarifa INT AUTO_INCREMENT PRIMARY KEY,
    CustoDiaUtil INT,
    CustoDiaNaoUtil INT,
	IDTipoTarifa INT
);

-- Veículo
CREATE TABLE Veiculo (
    Matricula VARCHAR(20) PRIMARY KEY,
    TipoMotor VARCHAR(50),
    CapacidadeCarga DECIMAL(10, 2),
    Potencia DECIMAL(10, 2),
    QuilometrosFeitos INT,
    QuantidadeLugares INT,
    QuantidadePortas INT,
    IDTipoVeiculo INT,
    LocalidadeVeiculo VARCHAR(255),
    ChassiVeiculo VARCHAR(20),
    FOREIGN KEY (ChassiVeiculo) REFERENCES TipoVeiculo(Chassi),
    FOREIGN KEY (LocalidadeVeiculo) REFERENCES ParqueEstacionamento(Localidade)
);

-- Intervenção
CREATE TABLE Intervencao (
    IDIntervencao INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(255),
    DataIntervencao DATE,
	MatriculaVeiculo VARCHAR(20),
    FOREIGN KEY (MatriculaVeiculo) REFERENCES Veiculo(Matricula)
);

-- Cliente
CREATE TABLE Cliente (
    NIF INT PRIMARY KEY,
    Nome VARCHAR(255),
    Contacto VARCHAR(20),
    Moeda VARCHAR(10),
    Tipo VARCHAR(10),
    Rua VARCHAR(255),
    Porta VARCHAR(50),
    Andar VARCHAR(50),
    CodigoPostal VARCHAR(20),
    FOREIGN KEY (Rua, Porta, Andar, CodigoPostal) REFERENCES Morada(Rua, Porta, Andar, CodigoPostal)
);

-- Subclasses Pessoa e Empresa
CREATE TABLE Pessoa (
    Idade INT,
    NIFCliente INT PRIMARY KEY,
    FOREIGN KEY (NIFCliente) REFERENCES Cliente(NIF)
);

CREATE TABLE Empresa (
    CapitalSocial DECIMAL(15, 2),
	NIFCliente INT PRIMARY KEY,
	FOREIGN KEY (NIFCliente) REFERENCES Cliente(NIF)
);

-- Condutor
CREATE TABLE Condutor (
    NumeroCarta VARCHAR(20) PRIMARY KEY,
    DataEmissao DATE,
    DataValidade DATE,
    Reputacao INT,
    NIFCliente INT,
    FOREIGN KEY (NIFCliente) REFERENCES Cliente(NIF)
);

-- Aluguer
CREATE TABLE Aluguer (
    IDAluguer INT AUTO_INCREMENT PRIMARY KEY,
    MatriculaAluguer VARCHAR(20),
    Tipo VARCHAR(255),
    HoraInicio DATETIME,
    HoraFim DATETIME,
    Custo DECIMAL(10, 2),
    Duracao DECIMAL(10, 2),
    CodigoDesconto VARCHAR(20),
    NIFCliente INT,
    NumeroCarta VARCHAR(20),
    FOREIGN KEY (NIFCliente) REFERENCES Cliente(NIF),
    FOREIGN KEY (NumeroCarta) REFERENCES Condutor(NumeroCarta),
    FOREIGN KEY (MatriculaAluguer) REFERENCES Veiculo(Matricula)
);

-- Tabela Reservas
CREATE TABLE Reservas (
	IDReserva INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(255),
    Marca VARCHAR(255),
    HoraInicioReserva DATETIME,
    HoraFimReserva DATETIME,
    LocalidadeParque VARCHAR(255),
    Custo DECIMAL(10, 2),
    NumeroCartaCondutor VARCHAR(20),
    NIFClienteReserva INT,
    FOREIGN KEY (NIFClienteReserva) REFERENCES Cliente(NIF)
);

-- Tabela Ativos
CREATE TABLE Ativos (
	IDAtivo INT AUTO_INCREMENT PRIMARY KEY,
    NumeroCartaCondutor VARCHAR(20),
    MatriculaAtiva VARCHAR(20),
    DataLevantamento DATETIME
);    

-- Tabela Avaliação
CREATE TABLE Avaliacao (
    IDAvaliacao INT AUTO_INCREMENT PRIMARY KEY,
    Classificacao INT,
    Comentario TEXT,
    IDAluguerAval INT,
    FOREIGN KEY (IDAluguerAval) REFERENCES Aluguer(IDAluguer)
);