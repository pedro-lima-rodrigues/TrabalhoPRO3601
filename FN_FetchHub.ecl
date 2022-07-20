IMPORT $,STD;

EXPORT FN_FetchHub (STRING hub_info):= FUNCTION

	basekey1 := $.NormLucroRecs.IDX_Lucro; //principal
	basekey2 := $.File_hubs.IDX_Hub; //hub
  // basekey1 := $.NormLucroRecs.File; //principal
	// basekey2 := $.File_hubs.File; //hub
	
	FilteredKey := 	basekey2(STD.Str.FindWord(hub_name,STD.Str.ToUpperCase(hub_info),true));
	
	joinedrec := RECORD
    basekey2.hub_name;
    // basekey2.hub_city;
    // basekey2.hub_state;
    // basekey2.hub_latitude;
    // basekey2.hub_longitude;
    // basekey1.entregadores;
	  // basekey1.receita;
    // basekey1.receita_por_entregador;
    // basekey1.lucro;
    // basekey1.lucro_por_entregador;
    basekey1.score;
    basekey1.score_bike;
																							
	END;
	
	joinedrec MyJoin(basekey1 Le, FilteredKey Ri):= TRANSFORM
		SELF:=Le;
		SELF:=Ri;
  END;
	
	JoinRecs:= JOIN(basekey1,FilteredKey,
									LEFT.hub_id=RIGHT.hub_id, 
									MyJoin(LEFT, RIGHT),
									ALL);
	
	RETURN OUTPUT(sort(joinrecs,-score));
END;