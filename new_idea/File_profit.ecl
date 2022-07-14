IMPORT $;

orders := $.File_orders.File;
costs := $.File_cost.File;

profit := RECORD
    UNSIGNED4 order_id;
    STRING8 order_status;
    UNSIGNED1 hub_id;
    REAL4 order_revenue;
    DECIMAL order_cost;
    DECIMAL order_profit;
END;

profit calculateProfit($.File_orders.Layout L,$.File_cost.Layout R) := TRANSFORM
    SELF.order_id := L.order_id;
    SELF.order_status := L.order_status;
    SELF.hub_id := R.hub_id;
    SELF.order_revenue := L.order_delivery_cost;
    SELF.order_cost := R.fuel_cost;
    SELF.order_profit := L.order_delivery_cost - R.fuel_cost;
END;

profit1 := JOIN(orders,costs,LEFT.order_id = RIGHT.order_id, calculateProfit(LEFT,RIGHT),LEFT OUTER, LOOKUP);

EXPORT File_profit := MODULE
	EXPORT Layout := RECORDOF(profit1);
	EXPORT File := profit1:PERSIST('~class::intro::dma::file_profit');
END;