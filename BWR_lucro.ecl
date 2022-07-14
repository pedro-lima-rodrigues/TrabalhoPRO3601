IMPORT $,STD;

municipios := $.File_municipios;
// stores := $.File_stores.File;
// hubs := $.File_hubs.File;
inicial := $.File_inicial;
// order := $.File_orders.File;
// delivery := $.File_deliveries.File;

// TRANSFORM EM MUNICIPIOS

municipios_filtro := municipios.File(municipio='SAO PAULO' OR municipio='PORTO ALEGRE' OR municipio='CURITIBA' OR municipio='RIO DE JANEIRO',
 produto='GASOLINA COMUM');

// municipios_filtro;

rec_transf := RECORD
    UNSIGNED data_inicial1;
    UNSIGNED data_final1;
    STRING27 municipio;
    STRING18 produto;
    // STRING7 preco_combustivel;
    UNSIGNED preco_combustivel;
END;

rec_transf MyTransf(municipios.Layout Le) := TRANSFORM
  SELF.data_inicial1 := STD.Date.FromStringToDate(Le.data_inicial[1..10], '%d/%m/%Y');
  SELF.data_final1 := STD.Date.FromStringToDate(Le.data_final[1..10], '%d/%m/%Y');
  // SELF.preco_combustivel := TRANSFER(STD.Str.FindReplace(Le.preco_medio_revenda, ',','.'),UNSIGNED);
  SELF.preco_combustivel := (>unsigned<)STD.Str.FindReplace(Le.preco_medio_revenda, ',','.'); //PROBLEMA AQUI
  SELF := Le;
END;

municipios_transf := PROJECT(municipios_filtro,MyTransf(LEFT));

// municipios_transf;

// TRANSFORM EM INICIAL

rec_transf2 := RECORD
    UNSIGNED1 hub_id;
    UNSIGNED3 driver_id;
    UNSIGNED4 delivery_distance_meters;
    REAL4 order_delivery_cost;
    UNSIGNED data_atual;
END;

rec_transf2 MyTransf2(inicial.Layout Le) := TRANSFORM
  SELF.data_atual := STD.Date.DateFromParts(Le.order_created_year,Le.order_created_month,Le.order_created_day);;
  SELF := Le;
END;

inicial_transf := PROJECT(inicial.File,MyTransf2(LEFT));

inicial_transf;

// JOIN ENTRE INICIAL E MUNICIPIOS

join1_rec := RECORD
    inicial_transf.hub_id;
    inicial_transf.driver_id;
    inicial_transf.delivery_distance_meters;
    inicial_transf.order_delivery_cost;
    municipios_transf.preco_combustivel;
END;

join1_rec MyJoin(inicial_transf Le, municipios_transf Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join1:= JOIN(inicial_transf,municipios_transf,
                LEFT.data_atual>RIGHT.data_inicial1 AND LEFT.data_atual<RIGHT.data_final1, 
                MyJoin(LEFT, RIGHT),
                ALL);
                
join1;

// CALCULOS

rec_transf3 := RECORD
    UNSIGNED1 hub_id;
    UNSIGNED3 driver_id;
    UNSIGNED4 delivery_distance_meters;
    REAL4 order_delivery_cost;
    UNSIGNED preco_combustivel;
    // string7 preco_combustivel;
    UNSIGNED lucro;
END;

// a := 10/2*2;

rec_transf3 MyTransf3(join1_rec Le) := TRANSFORM
  SELF.lucro := (10/5*2) /*Le.order_delivery_cost - Le.preco_combustivel/40000*Le.delivery_distance_meters*/; //PROBLEMA AQUI
  SELF := Le;
END;

join1_transf := PROJECT(join1,MyTransf3(LEFT));

join1_transf;

// AGRUPAMENTO POR ENTREGADOR E HUB

entreg_rec := RECORD
		join1_transf.hub_id;
    join1_transf.driver_id;
	  unsigned receita:=sum(GROUP,join1_transf.order_delivery_cost);
    unsigned lucro:=sum(GROUP,join1_transf.lucro);
	END;

entreg := SORT(TABLE(join1_transf,entreg_rec,hub_id,driver_id),hub_id);	

n_entreg_rec := RECORD
		entreg.hub_id;
    unsigned entregadores:=count(GROUP);
	  unsigned receita:=sum(GROUP,entreg.receita);
    unsigned receita_por_entregador:=ave(GROUP,entreg.receita);
    unsigned lucro:=sum(GROUP,entreg.lucro);
    unsigned lucro_por_entregador:=ave(GROUP,entreg.lucro);
	END;

n_entreg := SORT(TABLE(entreg,n_entreg_rec,hub_id),hub_id);

OUTPUT(n_entreg,,'~class::plr::trabalho::n_entreg',overwrite);