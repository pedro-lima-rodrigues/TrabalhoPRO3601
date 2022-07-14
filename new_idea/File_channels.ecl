EXPORT File_channels := MODULE
	EXPORT Layout := RECORD
    UNSIGNED1 channel_id;
    STRING14 channel_name;
    STRING11 channel_type;
  END;
	EXPORT File := DATASET('~class::intro::dma::channels.csv', Layout, csv(heading(1)));
END;