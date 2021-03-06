IMPORT $;

EXPORT NormLucroRecs := MODULE
  EXPORT Layout := RECORD
    UNSIGNED1 hub_id;
    UNSIGNED entregadores;
	  UNSIGNED receita;
    UNSIGNED receita_por_entregador;
    UNSIGNED lucro;
    UNSIGNED lucro_por_entregador;
    INTEGER score;
    UNSIGNED entregadores_bike;
    UNSIGNED lucro_bike;
    UNSIGNED lucro_por_entregador_bike;
    INTEGER score_bike;
  END;
  EXPORT File := DATASET('~class::plr::trabalho::score',Layout,THOR);
	EXPORT IDX_Lucro := INDEX(File,{hub_id},{entregadores,receita,receita_por_entregador,lucro,lucro_por_entregador,score,
  entregadores_bike,lucro_bike,lucro_por_entregador_bike,score_bike},
  '~class::plr::trabalho::key::lucro');
END;