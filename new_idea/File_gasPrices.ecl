IMPORT $, STD;

gas_prices := $.File_municipios.File;


EXPORT File_gasPrices := MODULE
    EXPORT gas_prices_transformed := RECORD
        UNSIGNED2 ano;
        UNSIGNED1 mes;
        UNSIGNED1 dia;
        $.File_municipios.Layout;
    END;

    gas_prices_transformed addColumns($.File_municipios.Layout L) := TRANSFORM
        splitted := STD.Str.SplitWords(L.mes, '/');
        SELF.ano := (UNSIGNED2) splitted[3];
        SELF.mes := (UNSIGNED1) splitted[2];
        SELF.dia := (UNSIGNED1) splitted[1];
        SELF := L;
    END;

    EXPORT gasPricesTransformed := SORT(PROJECT($.File_municipios.File, addColumns(LEFT)), [-ano,-mes,-dia]):PERSIST('~class::intro::dma::gasPricesTransformed');
END;

// EXPORT gasPricesTransformed := transformed(produto = 'GASOLINA COMUM', mes < 5, ano = 2021):PERSIST('~class::intro::dma::gasPricesTransformed');

// OUTPUT(AVE(filtered_prices,preco_medio_revenda));

// EXPORT gasPricesTransformed := SORT(PROJECT($.File_municipios.File, addColumns(LEFT)), [-ano,-mes,-dia])
//                                                                 :PERSIST('~class::intro::dma::gasPricesTransformed');

// gas_prices_transformed :=