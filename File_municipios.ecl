EXPORT File_municipios := MODULE
	EXPORT Layout := RECORD
    STRING10 data_inicial;
    STRING10 data_final;
    STRING12 regiao;
    STRING19 estado;
    STRING27 municipio;
    STRING18 produto;
    UNSIGNED2 numero_de_postos_pesquisados;
    STRING7 unidade_de_medida;
    STRING7 preco_medio_revenda;
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
	EXPORT File := DATASET('~class::plr::trabalho::semanal-municipios-2018-a-2021.csv', Layout, csv(heading(1)));
END;