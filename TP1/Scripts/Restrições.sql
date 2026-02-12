-- Reputação mínima para o condutor (Restrição nº1)
ALTER TABLE Condutor
ADD CONSTRAINT chk_reputacao_minima
CHECK (Reputacao >= 6);

-- Tem de ter carta há mais de 2.5 anos (Restrição nº2)
ALTER TABLE Condutor
ADD CONSTRAINT chk_validade_carta
CHECK (2024 - YEAR(DataEmissao) > 2.5);

-- NIF tem de ter 9 digitos (Restrição nº3)
ALTER TABLE Cliente
ADD CONSTRAINT chk_nif_range
CHECK (NIF BETWEEN 000000000 AND 999999999);

--  Cliente tem de ter mais de 25 anos (Restrição nº4)
ALTER TABLE Pessoa
ADD CONSTRAINT chk_idade_pessoa
CHECK (Idade > 25);
