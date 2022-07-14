EXPORT File_municipios := MODULE
	EXPORT Layout := RECORD
    STRING10 mes;
    STRING18 produto;
    STRING19 regiao;
    STRING19 estado;
    STRING27 municipio;
    UNSIGNED2 numero_de_postos_pesquisados;
    STRING7 unidade_de_medida;
    DECIMAL preco_medio_revenda;
    STRING6 desvio_padrao_revenda;
    STRING7 preco_minimo_revenda;
    STRING7 preco_maximo_revenda;
    STRING6 margem_media_revenda;
    STRING5 coef_de_variacao_revenda;
    STRING6 preco_medio_distribuicao;
    STRING6 desvio_padrao_distribuicao;
    STRING6 preco_minimo_distribuicao;
    STRING6 preco_maximo_distribuicao;
    STRING5 coef_de_variacao_distribuicao;
  END;
	EXPORT File := DATASET('~class::intro::dma::gas_price.csv', Layout, csv(heading(1)));
END;