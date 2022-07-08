IMPORT $;

municipios := $.File_municipios.File;
stores := $.File_stores.File;
hubs := $.File_hubs.File;

municipios_filtro := municipios(municipio='SAO PAULO' /*OR municipio='PORTO ALEGRE' OR municipio='CURITIBA' OR municipio='RIO DE JANEIRO'*/,
 produto='GASOLINA COMUM');

output(municipios_filtro);
stores;
hubs;