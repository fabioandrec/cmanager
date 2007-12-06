unit CPluginConsts;

interface

const
  //Plugin type constants
  CPLUGINTYPE_INCORRECT     = $00;
  CPLUGINTYPE_CURRENCYRATE  = $01;
  CPLUGINTYPE_JUSTEXECUTE   = $02;
  CPLUGINTYPE_HTMLREPORT    = $03;
  CPLUGINTYPE_CHARTREPORT   = $04;
  CPLUGINTYPE_EXTRACTION    = $05;
  CPLUGINTYPE_SELECTEDITEM  = $06;
  CPLUGINTYPE_STOCKEXCHANGE = $07;

  //Series type constants
  CSERIESTYPE_PIE  = $01;
  CSERIESTYPE_LINE = $02;
  CSERIESTYPE_BAR  = $03;

  //Domain type constants
  CSERIESDOMAIN_DATETIME = $01;
  CSERIESDOMAIN_FLOAT    = $00;

  //Currency rate types
  CCURRENCYRATE_AVG  = 'A';
  CCURRENCYRATE_SELL = 'S';
  CCURRENCYRATE_BUY  = 'B';

  //Extraction item types
  CEXTRACTION_INMOVEMENT  = 'I';
  CEXTRACTION_OUTMOVEMENT = 'O';

  //Exchange search types
  CINSTRUMENTSEARCHTYPE_BYNAME = 'N';
  CINSTRUMENTSEARCHTYPE_BYSYMBOL = 'S';

  //Dialog box types
  CDIALOGBOX_WARNING  = $00;
  CDIALOGBOX_ERROR    = $01;
  CDIALOGBOX_INFO     = $02;
  CDIALOGBOX_QUESTION = $03;

  //Selected item types
  CSELECTEDITEM_INCORRECT        = $000000000000;
  CSELECTEDITEM_BASEMOVEMENT     = $000000000100;
  CSELECTEDITEM_MOVEMENTLIST     = $000000000200;
  CSELECTEDITEM_PLANNEDDONE      = $000000000400;
  CSELECTEDITEM_PLANNEDMOVEMENT  = $000000000800;
  CSELECTEDITEM_ACCOUNT          = $000000001000;
  CSELECTEDITEM_CASHPOINT        = $000000002000;
  CSELECTEDITEM_PRODUCT          = $000000004000;
  CSELECTEDITEM_FILTER           = $000000008000;
  CSELECTEDITEM_PROFILE          = $000000010000;
  CSELECTEDITEM_LIMIT            = $000000020000;
  CSELECTEDITEM_CURRENCY         = $000000040000;
  CSELECTEDITEM_CURRENCYRATE     = $000000080000;
  CSELECTEDITEM_EXTRACTION       = $000000100000;
  CSELECTEDITEM_EXTRACTIONITEM   = $000000200000;
  CSELECTEDITEM_UNITDEF          = $000000400000;
  CSELECTEDITEM_INSTRUMENT       = $000000800000;
  CSELECTEDITEM_INSTRUMENTVALUE  = $000001000000;

  //Just execute types
  CJUSTEXECUTE_EXECUTEONSTART   = $000000000100;
  CJUSTEXECUTE_EXECUTEONEXIT    = $000000000200;
  CJUSTEXECUTE_DISABLEONDEMAND  = $000000000400;

  //Messages to frames
  CFRAMEMESSAGE_REFRESH      = $01;
  CFRAMEMESSAGE_ITEMADDED    = $02;
  CFRAMEMESSAGE_ITEMMODIFIED = $03;
  CFRAMEMESSAGE_ITEMDELETED  = $04;

  CFRAMETYPE_UNKNOWN             = $0000;
  CFRAMETYPE_CASHPOINTSFRAME     = $0001;
  CFRAMETYPE_ACCOUNTSFRAME       = $0002;
  CFRAMETYPE_PRODUCTSFRAME       = $0003;
  CFRAMETYPE_MOVEMENTFRAME       = $0004;
  CFRAMETYPE_PLANNEDFRAME        = $0005;
  CFRAMETYPE_DONEFRAME           = $0006;
  CFRAMETYPE_FILTERFRAME         = $0007;
  CFRAMETYPE_PROFILEFRAME        = $0008;
  CFRAMETYPE_LIMITSFRAME         = $0009;
  CFRAMETYPE_CURRENCYDEFFRAME    = $0010;
  CFRAMETYPE_CURRENCYRATEFRAME   = $0011;
  CFRAMETYPE_EXTRACTIONSFRAME    = $0012;
  CFRAMETYPE_EXTRACTIONITEMFRAME = $0013;
  CFRAMETYPE_UNITDEFFRAME        = $0014;
  CFRAMETYPE_INSTRUMENT          = $0015;
  CFRAMETYPE_INSTRUMENTVALUE     = $0016;

  CFRAMEOPTPARAM_NULL         = $00;
  CFRAMEOPTPARAM_BASEMOVEMENT = $01;
  CFRAMEOPTPARAM_MOVEMENTLIST = $02;

  //CManager states
  CMANAGERSTATE_STARTING = $01;
  CMANAGERSTATE_RUNNING  = $02;
  CMANAGERSTATE_CLOSING  = $03;

implementation

end.
