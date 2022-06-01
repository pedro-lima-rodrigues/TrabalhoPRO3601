EXPORT File_stores := MODULE
	EXPORT Layout := RECORD
    UNSIGNED2 store_id;
    UNSIGNED1 hub_id;
    STRING32 store_name;
    STRING4 store_segment;
    REAL4 store_plan_price;
    REAL8 store_latitude;
    REAL8 store_longitude;
  END;
	EXPORT File := DATASET('~class::plr::trabalho::stores.csv', Layout, csv(heading(1)));
END;