EXPORT File_hubs := MODULE
	EXPORT Layout := RECORD
    UNSIGNED1 hub_id;
    STRING16 hub_name;
    STRING14 hub_city;
    STRING2 hub_state;
    REAL8 hub_latitude;
    REAL8 hub_longitude;
  END;
	EXPORT File := DATASET('~class::plr::trabalho::hubs.csv', Layout, csv(heading(1)));
  EXPORT IDX_Hub := INDEX(File,{hub_name},{hub_id,hub_city,hub_state,hub_latitude,hub_longitude},'~class::plr::trabalho::key::hub');
END;