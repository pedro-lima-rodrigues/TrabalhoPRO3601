IMPORT $;

EXPORT NormLucroRecs := MODULE
  EXPORT Layout := RECORD
    UNSIGNED1 hub_id;
    unsigned entregadores;
	  unsigned receita;
    unsigned receita_por_entregador;
    unsigned lucro;
    unsigned lucro_por_entregador;
  END;
  EXPORT File := DATASET('~class::plr::trabalho::n_entreg',Layout,THOR);
	EXPORT IDX_Lucro := INDEX(File,{hub_id},'~class::plr::trabalho::key::lucro');
END;