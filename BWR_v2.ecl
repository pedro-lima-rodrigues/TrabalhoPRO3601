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

// output(join2);

// FIM DA 1A ETAPA

// COUNT DISCTINCT DE ENTREGADORES

entreg_rec := RECORD
		join2.hub_id;
    join2.driver_id;
	  unsigned receita:=sum(GROUP,join2.order_delivery_cost);
	END;

entreg := SORT(TABLE(join2,entreg_rec,hub_id,driver_id),hub_id);	

// Output(join3);
// output(count(join3(hub_id=3)));

n_entreg_rec := RECORD
		entreg.hub_id;
    unsigned entregadores:=count(GROUP);
	END;

n_entreg := SORT(TABLE(entreg,n_entreg_rec,hub_id),hub_id);	

Output(n_entreg);

// COUNT DISCTINCT DE MESES

meses_rec := RECORD
    join2.hub_id;
    STRING ano_mes;
		join2.order_delivery_cost;
	END;

meses_rec MyTransf(join2_rec Le) := TRANSFORM
    SELF.ano_mes := (string)Le.order_created_month+'/'+(string)Le.order_created_year;
    SELF := Le;
  END;

meses := SORT(PROJECT(join2,MyTransf(LEFT)),hub_id);

// output(meses);

meses2_rec := RECORD
		meses.hub_id;
    meses.ano_mes;
	  unsigned receita:=sum(GROUP,meses.order_delivery_cost);
	END;

meses2 := SORT(TABLE(meses,meses2_rec,hub_id,ano_mes),-hub_id);

output(meses2);

n_meses_rec := RECORD
		meses2.hub_id;
    unsigned meses:=count(GROUP);
	END;

n_meses := SORT(TABLE(meses2,n_meses_rec,hub_id),hub_id);

Output(n_meses);





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