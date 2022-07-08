IMPORT $;

// receita por hub, numero de entregadores do hub
// primeiro faz join com loja, dps join com hub

orders := $.File_orders.File;
deliveries := $.File_deliveries.File;
stores := $.File_stores.File;

orders_finished := orders(order_status='FINISHED');

// output(orders_finished);

// JUNCAO COM A DELIVERIES

join1_rec := RECORD
  orders_finished.store_id;
  orders_finished.delivery_order_id;
  deliveries.driver_id; 
  orders_finished.order_delivery_cost;
  orders_finished.order_created_month; 
  orders_finished.order_created_year; 
END;

join1_rec MyJoin(orders_finished Le, deliveries Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join1:= JOIN(orders_finished,deliveries,
                LEFT.delivery_order_id=RIGHT.delivery_order_id, 
                MyJoin(LEFT, RIGHT),
                ALL);

// output(sort(deliveries,delivery_order_id));
// output(sort(Join1,delivery_order_id));

// JUNCAO COM A STORES

join2_rec := RECORD
  stores.hub_id;
  join1;                  
END;

join2_rec MyJoin2(join1 Le, stores Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join2 := JOIN(join1,stores,
                LEFT.store_id=RIGHT.store_id, 
                MyJoin2(LEFT, RIGHT),
                ALL);

OUTPUT(join2,,'~class::plr::trabalho::inicial',overwrite);