EXPORT File_deliveries := MODULE
	EXPORT Layout := RECORD
    UNSIGNED4 delivery_id;
    UNSIGNED4 delivery_order_id;
    UNSIGNED3 driver_id;
    UNSIGNED4 delivery_distance_meters;
    STRING10 delivery_status;
  END;
	EXPORT File := DATASET('~class::intro::dma::deliveries.csv', Layout, csv(heading(1)));
END;