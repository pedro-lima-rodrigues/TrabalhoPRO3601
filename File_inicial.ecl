EXPORT File_inicial := MODULE
	EXPORT Layout := RECORD
		UNSIGNED1 hub_id;
    UNSIGNED2 store_id;
    UNSIGNED4 delivery_order_id;
    UNSIGNED3 driver_id;
    REAL4 order_delivery_cost;
    UNSIGNED1 order_created_month;
    UNSIGNED2 order_created_year;
	END;
	EXPORT File := DATASET('~class::plr::trabalho::inicial',Layout,FLAT);
END;