IMPORT $;

join2 := $.File_inicial.File;
join2_rec := $.File_inicial.Layout;

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