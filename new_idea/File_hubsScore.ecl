IMPORT $;

profit := $.File_profit.File;

deliveredOrders := profit(order_status = 'FINISHED', order_revenue > 0, order_profit > 0);


// OUTPUT($.File_cost.File(order_id = 68666838));
// OUTPUT(COUNT(deliveredOrders));
// OUTPUT(deliveredOrders);
// OUTPUT(COUNT(deliveredOrders(order_profit < 0)));
// OUTPUT(deliveredOrders(order_profit < 0));

avg_profit := AVE(deliveredOrders,order_profit);

// OUTPUT(avg_profit)
hubsRec := RECORD
    deliveredOrders.hub_id;
    DECIMAL avg_profit := AVE(GROUP,deliveredOrders.order_profit);
END;

// avg := TABLE(deliveredOrders,{hub_id,AVE(GROUP,order_profit)},hub_id);

avg := TABLE(deliveredOrders,hubsRec,hub_id);

hubs := $.File_hubs.File;

hubsAvg := RECORD
    RECORDOF(hubs);
    DECIMAL avg_profit;
END;


hubsAvg addAvg($.File_hubs.Layout L,hubsRec R) := TRANSFORM
    SELF.avg_profit := R.avg_profit;
    SELF := L;
END;

avg2 := JOIN(hubs,avg,LEFT.hub_id = RIGHT.hub_id, addAvg(LEFT,RIGHT),LEFT OUTER, LOOKUP);

// OUTPUT(avg2);

max_profit := MAX(avg2,avg_profit);

hubsScore := RECORD
    RECORDOF(avg2);
    INTEGER score;
END;

hubsScore calculateScore(hubsAvg L) := TRANSFORM
  SELF.score := (L.avg_profit*1000)/max_profit;
  SELF := L;
END;

score := PROJECT(avg2,calculateScore(LEFT));

score;

EXPORT File_hubsScore := MODULE
	EXPORT Layout := RECORDOF(score);
	EXPORT File := score:PERSIST('~class::intro::dma::file_hubsScore');
END;


