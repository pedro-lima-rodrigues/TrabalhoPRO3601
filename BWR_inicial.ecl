IMPORT $;

// receita por hub, numero de entregadores do hub
// primeiro faz join com loja, dps join com hub

orders := $.File_orders.File;
deliveries := $.File_deliveries.File;
stores := $.File_stores.File;
hubs := $.File_hubs.File;
drivers := $.File_drivers.File;

orders_finished := orders(order_status='FINISHED');

// output(orders_finished);
// deliveries;
// output(sum(orders_finished,orders_finished.order_delivery_cost));

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
// output(sum(join1,join1.order_delivery_cost));

// JUNCAO COM A DRIVERS

join2_rec := RECORD
  join1;
  drivers.driver_modal;
END;

join2_rec MyJoin2(join1 Le, drivers Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join2:= JOIN(join1,drivers,
                LEFT.driver_id=RIGHT.driver_id, 
                MyJoin2(LEFT, RIGHT),
                LEFT OUTER, LOOKUP);

// join2;

// JUNCAO COM A STORES

join3_rec := RECORD
  stores.hub_id;
  join2;                  
END;

join3_rec MyJoin3(join2 Le, stores Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join3_antiga := JOIN(join2,stores,
                LEFT.store_id=RIGHT.store_id, 
                MyJoin3(LEFT, RIGHT),
                LEFT OUTER, LOOKUP);
                
join3 := join3_antiga(hub_id<>73);
                
// output(sum(join2,join2.order_delivery_cost));                
// OUTPUT(join2,,'~class::plr::trabalho::inicial',overwrite);

// JUNCAO COM A HUB

join4_rec := RECORD
  hubs.hub_city;
  join3;                  
END;

join4_rec MyJoin4(join3 Le, hubs Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join4 := JOIN(join3,hubs,
                LEFT.hub_id=RIGHT.hub_id, 
                MyJoin4(LEFT, RIGHT),
                LEFT OUTER, LOOKUP);

OUTPUT(join4,,'~class::plr::trabalho::inicial',overwrite);
// output(sum(join3,join3.order_delivery_cost));