EXPORT File_channels := MODULE
	EXPORT Layout := RECORD
    UNSIGNED1 channel_id;
    STRING14 channel_name;
    STRING11 channel_type;
  END;
	EXPORT File := DATASET('~class::plr::trabalho::channels.csv', Layout, csv(heading(1)));
END;