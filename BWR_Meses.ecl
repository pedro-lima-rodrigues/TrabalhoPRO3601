IMPORT $;

join2 := $.File_inicial.File;
join2_rec := $.File_inicial.Layout;

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