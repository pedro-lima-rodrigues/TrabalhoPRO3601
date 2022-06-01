IMPORT $,STD;

a := $.File_channels.File;

bestrecord := STD.DataPatterns.BestRecordStructure(a);

OUTPUT(bestrecord, ALL, NAMED('BestRecord'));