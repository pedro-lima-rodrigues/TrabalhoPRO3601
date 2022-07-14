IMPORT $;

// receita por hub, numero de entregadores do hub
// primeiro faz join com loja, dps join com hub

orders := $.File_orders.File;
deliveries := $.File_deliveries.File;
stores := $.File_stores.File;
hubs := $.File_hubs.File;

orders_finished := orders(order_status='FINISHED');

// output(orders_finished);
// deliveries;
output(sum(orders_finished,orders_finished.order_delivery_cost));

// JUNCAO COM A DELIVERIES

join1_rec := RECORD
  orders_finished.store_id;
  orders_finished.delivery_order_id;
  deliveries.driver_id;
  deliveries.delivery_distance_meters;
  orders_finished.order_delivery_cost;
  orders_finished.order_created_day; 
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
                LEFT OUTER, LOOKUP);

// output(sort(deliveries,delivery_order_id));
// output(sort(Join1,delivery_order_id));
output(sum(join1,join1.order_delivery_cost));

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
                LEFT OUTER, LOOKUP);
                
output(sum(join2,join2.order_delivery_cost));                
// OUTPUT(join2,,'~class::plr::trabalho::inicial',overwrite);

// JUNCAO COM A HUB

join3_rec := RECORD
  hubs.hub_city;
  join2;                  
END;

join3_rec MyJoin3(join2 Le, hubs Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join3 := JOIN(join2,hubs,
                LEFT.hub_id=RIGHT.hub_id, 
                MyJoin3(LEFT, RIGHT),
                LEFT OUTER, LOOKUP);

OUTPUT(join3,,'~class::plr::trabalho::inicial',overwrite);
output(sum(join3,join3.order_delivery_cost));