EXPORT File_payments := MODULE
	EXPORT Layout := RECORD
    UNSIGNED4 payment_id;
    UNSIGNED4 payment_order_id;
    REAL8 payment_amount;
    REAL4 payment_fee;
    STRING24 payment_method;
    STRING10 payment_status;
  END;
	EXPORT File := DATASET('~class::intro::dma::payments.csv', Layout, csv(heading(1)));
END;