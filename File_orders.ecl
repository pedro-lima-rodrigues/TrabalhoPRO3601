EXPORT File_orders := MODULE
	EXPORT Layout := RECORD
    UNSIGNED4 order_id;
    UNSIGNED2 store_id;
    UNSIGNED1 channel_id;
    UNSIGNED4 payment_order_id;
    UNSIGNED4 delivery_order_id;
    STRING8 order_status;
    REAL8 order_amount;
    REAL4 order_delivery_fee;
    REAL4 order_delivery_cost;
    UNSIGNED1 order_created_hour;
    UNSIGNED1 order_created_minute;
    UNSIGNED1 order_created_day;
    UNSIGNED1 order_created_month;
    UNSIGNED2 order_created_year;
    STRING21 order_moment_created;
    STRING21 order_moment_accepted;
    STRING21 order_moment_ready;
    STRING21 order_moment_collected;
    STRING21 order_moment_in_expedition;
    STRING21 order_moment_delivering;
    STRING21 order_moment_delivered;
    STRING21 order_moment_finished;
    REAL4 order_metric_collected_time;
    REAL8 order_metric_paused_time;
    REAL8 order_metric_production_time;
    REAL4 order_metric_walking_time;
    REAL4 order_metric_expediton_speed_time;
    REAL8 order_metric_transit_time;
    REAL8 order_metric_cycle_time;
  END;
	EXPORT File := DATASET('~class::plr::trabalho::orders.csv', Layout, csv(heading(1)));
END;