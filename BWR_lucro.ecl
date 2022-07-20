IMPORT $,STD;

municipios := $.File_municipios;
// stores := $.File_stores.File;
// hubs := $.File_hubs.File;
inicial := $.File_inicial;
// order := $.File_orders.File;
// delivery := $.File_deliveries.File;

// output(sum(inicial.File,inicial.File.order_delivery_cost));

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
    real preco_combustivel;
END;

rec_transf MyTransf(municipios.Layout Le) := TRANSFORM
  SELF.data_inicial1 := STD.Date.FromStringToDate(Le.data_inicial[1..10], '%d/%m/%Y');
  SELF.data_final1 := STD.Date.FromStringToDate(Le.data_final[1..10], '%d/%m/%Y');
  // SELF.preco_combustivel := TRANSFER(STD.Str.FindReplace(Le.preco_medio_revenda, ',','.'),UNSIGNED);
  SELF.preco_combustivel := (real)STD.Str.FindReplace(Le.preco_medio_revenda, ',','.');
  // SELF.preco_combustivel := Le.preco_medio_revenda;
  SELF := Le;
END;

municipios_transf := PROJECT(municipios_filtro,MyTransf(LEFT));

// municipios_filtro;
// municipios_transf;

// count(municipios_transf);
// count(municipios_transf);
// count(municipios_transf(preco_combustivel<5));
// count(municipios_transf(preco_combustivel>0 AND preco_combustivel<10));

// TRANSFORM EM INICIAL

rec_transf2 := RECORD
    UNSIGNED1 hub_id;
    STRING14 hub_city;
    UNSIGNED3 driver_id;
    STRING7 driver_modal;
    UNSIGNED4 delivery_distance_meters;
    REAL4 order_delivery_cost;
    UNSIGNED data_atual;
END;

rec_transf2 MyTransf2(inicial.Layout Le) := TRANSFORM
  SELF.data_atual := STD.Date.DateFromParts(Le.order_created_year,Le.order_created_month,Le.order_created_day);
  SELF.hub_city := if(Le.hub_city<>'PORTO ALEGRE' AND Le.hub_city<>'CURITIBA' AND Le.hub_city<>'RIO DE JANEIRO','SAO PAULO',Le.hub_city);
  SELF := Le;
END;

inicial_transf := PROJECT(inicial.File,MyTransf2(LEFT));

// inicial.File(hub_city<>'PORTO ALEGRE' AND hub_city<>'CURITIBA' AND hub_city<>'RIO DE JANEIRO');
// inicial_transf;
// inicial_transf(hub_city='SAO PAULO');
// output(sum(inicial_transf,inicial_transf.order_delivery_cost));

// JOIN ENTRE INICIAL E MUNICIPIOS

join1_rec := RECORD
    inicial_transf.hub_id;
    inicial_transf.hub_city;
    inicial_transf.driver_id;
    inicial_transf.driver_modal;
    inicial_transf.delivery_distance_meters;
    inicial_transf.order_delivery_cost;
    municipios_transf.preco_combustivel;
END;

join1_rec MyJoin(inicial_transf Le, municipios_transf Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

Join11:= JOIN(inicial_transf,municipios_transf,
                LEFT.data_atual>RIGHT.data_inicial1 AND LEFT.data_atual<RIGHT.data_final1
                AND LEFT.hub_city=RIGHT.municipio AND LEFT.driver_modal='MOTOBOY', 
                MyJoin(LEFT, RIGHT),
                LEFT OUTER, LOOKUP);
                
join1:=join11(driver_modal='MOTOBOY');
join1_biker:=join11(driver_modal='BIKER');
// output(sum(join1,join1.order_delivery_cost));
// output(count(join1(driver_modal='MOTOBOY')));
// output(count(join1(driver_modal='BIKER')));

// CALCULOS - MOTOBOY

rec_transf3 := RECORD
    UNSIGNED1 hub_id;
    UNSIGNED3 driver_id;
    UNSIGNED4 delivery_distance_meters;
    REAL4 order_delivery_cost;
    UNSIGNED preco_combustivel;
    // string7 preco_combustivel;
    real lucro;
END;

rec_transf3 MyTransf3(join1_rec Le) := TRANSFORM
  SELF.lucro := (Le.order_delivery_cost - Le.preco_combustivel/40000*Le.delivery_distance_meters);
  SELF := Le;
END;

join1_transf := PROJECT(join1,MyTransf3(LEFT));

// join1_transf;

// output(sum(join1_transf,join1_transf.order_delivery_cost));

// AGRUPAMENTO POR ENTREGADOR E HUB - MOTOBOY

entreg_rec := RECORD
    join1_transf.hub_id;
    join1_transf.driver_id;
	  unsigned receita:=sum(GROUP,join1_transf.order_delivery_cost);
    unsigned lucro:=sum(GROUP,join1_transf.lucro);
	END;

entreg := SORT(TABLE(join1_transf,entreg_rec,hub_id,driver_id),hub_id);	

// entreg;
// output(sum(entreg,entreg.receita));

n_entreg_rec := RECORD
		entreg.hub_id;
    unsigned entregadores:=count(GROUP);
	  unsigned receita:=sum(GROUP,entreg.receita);
    unsigned receita_por_entregador:=ave(GROUP,entreg.receita);
    unsigned lucro:=sum(GROUP,entreg.lucro);
    unsigned lucro_por_entregador:=ave(GROUP,entreg.lucro);
	END;

n_entreg := SORT(TABLE(entreg,n_entreg_rec,hub_id),hub_id);

// OUTPUT(n_entreg,,'~class::plr::trabalho::n_entreg',overwrite);
// output(sum(n_entreg,n_entreg.receita));

// NORMALIZACAO - MOTOBOY

max_lucro := MAX(n_entreg,lucro_por_entregador);
min_lucro := MIN(n_entreg,lucro_por_entregador);

hubsScore := RECORD
    RECORDOF(n_entreg);
    INTEGER score;
END;

hubsScore calculateScore(n_entreg L) := TRANSFORM
  SELF.score := (L.lucro_por_entregador-min_lucro)/(max_lucro-min_lucro)*1000;
  SELF := L;
END;

score := PROJECT(n_entreg,calculateScore(LEFT));
// output(score);
// OUTPUT(score,,'~class::plr::trabalho::score',overwrite);

// AGRUPAMENTO POR ENTREGADOR E HUB - BIKER

entreg2_rec := RECORD
    join1_biker.hub_id;
    join1_biker.driver_id;
	  unsigned lucro:=sum(GROUP,join1_biker.order_delivery_cost);
	END;

entreg2 := SORT(TABLE(join1_biker,entreg2_rec,hub_id,driver_id),hub_id);	
// entreg2;

n_entreg2_rec := RECORD
		entreg2.hub_id;
    unsigned entregadores_bike:=count(GROUP);
    unsigned lucro_bike:=sum(GROUP,entreg2.lucro);
    unsigned lucro_por_entregador_bike:=ave(GROUP,entreg2.lucro);
	END;

n_entreg2 := SORT(TABLE(entreg2,n_entreg2_rec,hub_id),hub_id);

// OUTPUT(n_entreg,,'~class::plr::trabalho::n_entreg',overwrite);
// output(sum(n_entreg,n_entreg.receita));

// NORMALIZACAO - BIKER

max_lucro_bike := MAX(n_entreg2,lucro_por_entregador_bike);
min_lucro_bike := MIN(n_entreg2,lucro_por_entregador_bike);

hubsScore2 := RECORD
    RECORDOF(n_entreg2);
    INTEGER score_bike;
END;

hubsScore2 calculateScore2(n_entreg2 L) := TRANSFORM
  SELF.score_bike := (L.lucro_por_entregador_bike-min_lucro_bike)/(max_lucro_bike-min_lucro_bike)*1000;
  SELF := L;
END;

score2 := PROJECT(n_entreg2,calculateScore2(LEFT));
// output(score2);
// OUTPUT(score,,'~class::plr::trabalho::score',overwrite);

// JOIN ENTRE MOTOBOY E BIKER

score_cons_rec := RECORD
    RECORDOF(score);
    score2.entregadores_bike;
    score2.lucro_bike;
    score2.lucro_por_entregador_bike;
    score2.score_bike;
END;

score_cons_rec MyJoin2(score Le, score2 Ri):= TRANSFORM
  SELF:=Le;
  SELF:=Ri;
END;

score_cons:= JOIN(score,score2,
                LEFT.hub_id=RIGHT.hub_id, 
                MyJoin2(LEFT, RIGHT),
                LEFT OUTER, LOOKUP);
                
OUTPUT(score_cons,,'~class::plr::trabalho::score',overwrite);
output(sort(score_cons,-score));