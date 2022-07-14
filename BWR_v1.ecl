IMPORT $;

// receita por hub, numero de entregadores do hub
// primeiro faz join com loja, dps join com hub

orders := $.File_orders.File;
deliveries := $.File_deliveries.File;
stores := $.File_stores.File;

orders_finished := orders(order_status='FINISHED');

// JUNCAO COM A DELIVERIES

joinedrec := RECORD
  orders_finished.store_id;
  orders_finished.delivery_order_id;
  deliveries.driver_id; 
  orders_finished.order_delivery_cost;                  
END;

joinedrec MyJoin(orders_finished Le, deliveries Ri):= TRANSFORM
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

joinedrec2 := RECORD
  stores.hub_id;
  join1;                  
END;

joinedrec2 MyJoin2(join1 Le, stores Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join2 := JOIN(join1,stores,
                LEFT.store_id=RIGHT.store_id, 
                MyJoin2(LEFT, RIGHT),
                ALL);

// output(sort(stores,store_id));
// output(sort(Join2,store_id));

outrec2 := RECORD
		join2.hub_id;
    join2.driver_id;
	  unsigned receita:=sum(GROUP,join2.order_delivery_cost);
    // unsigned entregadores:=count(DEDUP(GROUP));
	END;

join3 := SORT(TABLE(join2,outrec2,hub_id,driver_id),hub_id);	

// Output(join3);
// output(count(join3(hub_id=3)));

outrec3 := RECORD
		join3.hub_id;
    unsigned entregadores:=count(GROUP);
	  unsigned receita:=sum(GROUP,join3.receita);
    unsigned receita_por_entregador:=ave(GROUP,join3.receita);
    // unsigned entregadores:=count(DEDUP(GROUP));
	END;

mytable := SORT(TABLE(join3,outrec3,hub_id),hub_id);	

Output(mytable);





// joinedrec MyJoin(basekey1 Le, FilteredKey Ri):= TRANSFORM
		// SELF:=Le;
		// SELF:=Ri;
// END;
	
	// JoinRecs:= JOIN(basekey1,FilteredKey,
									// KEYED(LEFT.block_id=RIGHT.block_id) AND WILD(RIGHT.Block), 
									// MyJoin(LEFT, RIGHT),
									// ALL);

	// outrec := RECORD
		// joinrecs.block;
	  // joinrecs.primary_type;
	  // joinrecs.description;
	  // unsigned cnt:=COUNT(GROUP);
	// END;

 // mytable := CHOOSEN(SORT(TABLE(joinrecs,outrec,block,primary_type,description),-cnt),10);	