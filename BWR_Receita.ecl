IMPORT $;

orders := $.File_orders.File;

orders_finished := orders(order_status='FINISHED');

outrec := RECORD
		orders_finished.store_id;
	  unsigned soma:=count(GROUP);
	END;

mytable := TABLE(orders_finished,outrec,order_delivery_cost);	

// Output(mytable);

output(sum(orders_finished,order_delivery_cost));
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