IMPORT $, STD;

// orders := $.File_orders.File;
// deliveries := $.File_deliveries.File;
// stores := $.File_stores.File;

// orders_finished := orders(order_status='FINISHED');
// gas_prices_2021 = gas_prices()
// municipios := TABLE(gas_prices,{municipio},municipio);

// OUTPUT(gas_prices);

// rec_gas_price := RECORD
// 	STRING27   municipio;
// 	STRING6 preco;
// END;

// rec_gas_price filter_average(ResType L, ResType R) := TRANSFORM
//     MyRecordSet := municipios(municipio = cidade);
//     // municipios := TABLE(gas_prices,{municipio},municipio);
//     SELF.Rtot := L.Rtot + R.Val;
//     SELF := R;
// END;

// average_cost_gas = PROJECT(municipios, filter_average);


// deliveries := $.File_deliveries.File;
// average_gas_price := AVE($.gasPricesTransformed(produto = 'GASOLINA COMUM', mes < 5, ano = 2021), preco_medio_revenda);
// average_km_L := 40;

// deliveriesCost := RECORD
// 	RECORDOF(deliveries);
//     DECIMAL fuel_cost;
// END;

// deliveriesCost addFuelCost($.File_deliveries.Layout L) := TRANSFORM
//     SELF := L;
//     SELF.fuel_cost := (DECIMAL)(average_gas_price*L.delivery_distance_meters)/(1000*average_km_L);
// END;

// deliveries_cost_gas := PROJECT(deliveries, addFuelCost(LEFT));

// OUTPUT(deliveries_cost_gas);


orders := $.File_orders.File;
stores := $.File_stores.File;
hubs := $.File_hubs.File;
fuel := $.File_gasPrices.gasPricesTransformed;
deliveries := $.File_deliveries.File;

cost := RECORD
    // RECORDOF(orders);
    UNSIGNED4 order_id;
    UNSIGNED2 store_id;
    UNSIGNED1 hub_id;
    UNSIGNED4 delivery_order_id;
    UNSIGNED1 order_created_day;
    UNSIGNED1 order_created_month;
    UNSIGNED2 order_created_year;
END;

cost addHub($.File_orders.Layout L,$.File_stores.Layout R) := TRANSFORM
    SELF.order_id := L.order_id;
    SELF.store_id := L.store_id;
    SELF.hub_id := R.hub_id;
    SELF.delivery_order_id := L.delivery_order_id;
    SELF.order_created_day := L.order_created_day;
    SELF.order_created_month := L.order_created_month;
    SELF.order_created_year := L.order_created_year;
END;

cost1 := JOIN(orders,stores,LEFT.store_id = RIGHT.store_id,addHub(LEFT,RIGHT),LEFT OUTER, LOOKUP);

// OUTPUT(cost1);

costCity := RECORD
    RECORDOF(cost1);
    STRING14 hub_city;
    STRING18 produto := 'GASOLINA COMUM';
END;

costCity addCity(cost L,$.File_hubs.Layout R) := TRANSFORM
    SELF.hub_city := R.hub_city;
    SELF := L;
END;

cost2 := JOIN(cost1,hubs,LEFT.hub_id = RIGHT.hub_id,addCity(LEFT,RIGHT),LEFT OUTER, LOOKUP);

// OUTPUT(cost2);

costFuel := RECORD
    RECORDOF(cost2);
    DECIMAL fuel_price;
    
END;

costFuel addFuel(costCity L,$.File_gasPrices.gas_prices_transformed R) := TRANSFORM
    SELF.fuel_price := R.preco_medio_revenda;
    SELF := L;
END;

cost3 := JOIN(cost2,fuel,
                        LEFT.order_created_month = RIGHT.mes AND
                        LEFT.order_created_year = RIGHT.ano AND
                        LEFT.produto = RIGHT.produto AND
                        LEFT.hub_city = RIGHT.municipio,
                        addFuel(LEFT,RIGHT),LEFT OUTER, LOOKUP);

// OUTPUT(cost3);
// OUTPUT(cost2);
// OUTPUT(fuel);

costDelivery := RECORD
    RECORDOF(cost3);
    DECIMAL distance_km;
    DECIMAL fuel_cost;
END;

costDelivery addDistance(costFuel L,$.File_deliveries.Layout R) := TRANSFORM
    distance := ((DECIMAL)R.delivery_distance_meters)/1000;
    SELF.distance_km := distance;
    SELF.fuel_cost := (L.fuel_price*distance)/40;
    SELF := L;
END;

cost4 := JOIN(cost3,deliveries,LEFT.delivery_order_id = RIGHT.delivery_order_id, addDistance(LEFT,RIGHT),LEFT OUTER, LOOKUP);

EXPORT File_cost := MODULE
	EXPORT Layout := RECORDOF(cost4);
	EXPORT File := cost4:PERSIST('~class::intro::dma::file_cost');
END;

// OUTPUT(cost4);
// OUTPUT(cost3);