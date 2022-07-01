IMPORT $,STD;

// OUTPUT($.File_channels.File, ALL, NAMED('channels'));
// OUTPUT($.File_deliveries.File, ALL, NAMED('deliveries'));
// OUTPUT($.File_drivers.File, ALL, NAMED('drivers'));
// OUTPUT($.File_hubs.File, ALL, NAMED('hubs'));
// OUTPUT($.File_municipios.File, ALL, NAMED('municipios'));
OUTPUT($.File_orders.File, ALL, NAMED('orders'));
// OUTPUT($.File_payments.File, ALL, NAMED('payments'));
// OUTPUT($.File_stores.File, ALL, NAMED('stores'));

// bestrecord := STD.DataPatterns.BestRecordStructure(a);

// OUTPUT(bestrecord, ALL, NAMED('BestRecord'));

// receita por hub, numero de entregadores do hub
// primeiro faz join com loja, dps join com hub