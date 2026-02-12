CREATE VIEW MoradaClientes AS
SELECT 
    C.NIF,
    C.Nome,
    C.Contacto,
    C.Moeda,
  
    CASE 
        WHEN C.Tipo = 'Pessoa' THEN P.Idade 
        ELSE NULL 
    END AS Idade,
    CASE 
        WHEN C.Tipo = 'Empresa' THEN E.CapitalSocial 
        ELSE NULL 
    END AS CapitalSocial,
    M.Rua,
    M.Porta,
    M.Andar,
    M.CodigoPostal,
    M.Distrito,
    M.Concelho,
    M.Freguesia,
    M.Pais
FROM 
    Cliente C
LEFT JOIN 
    Pessoa P ON C.NIF = P.NIFCliente    
LEFT JOIN 
    Empresa E ON C.NIF = E.NIFCliente
JOIN 
    Morada M ON C.Rua = M.Rua 
           AND C.Porta = M.Porta
           AND C.Andar = M.Andar 
           AND C.CodigoPostal = M.CodigoPostal;
                     
