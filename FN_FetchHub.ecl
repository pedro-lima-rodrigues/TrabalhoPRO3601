IMPORT $,STD;

EXPORT FN_FetchHub (STRING hub_info):= FUNCTION

	basekey1 := $.NormLucroRecs.IDX_Lucro; //principal
	basekey2 := $.NormHubRecs.IDX_Hub; //hub
	
	FilteredKey := 	basekey2(STD.Str.FindWord(hub_name,STD.Str.ToUpperCase(hub_info),true));
	
	joinedrec := RECORD
    basekey2.hub_name;
		basekey1.lucro;
																							
	END;
	
	joinedrec MyJoin(basekey1 Le, FilteredKey Ri):= TRANSFORM
		SELF:=Le;
		SELF:=Ri;
  END;
	
	JoinRecs:= JOIN(basekey1,FilteredKey,
									LEFT.hub_id=RIGHT.hub_id, 
									MyJoin(LEFT, RIGHT),
									ALL);
	
	RETURN OUTPUT(joinrecs);
END;