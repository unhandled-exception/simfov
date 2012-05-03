{$F+,O+}

Unit SSVar;

Interface

Uses TUtil;

Type

  PString = String [ 79 ];

  TCatPath = Record

   Hip       : PString ;
   Tyc       : PString ;
   PPM       : PString ;
   BS        : PString ;
   HD        : PString ;
   Gcvs      : PString ;
   CDS       : PString ;
   Npm       : PString ;
   NLtt      : PString ;
   A20       : PString ;
   GSC       : PString ;
   Dm        : PString ;
   IRAS      : PString ;
   Satellits : PString ;

  End;

  TEDirPath = Record

   Import    : PString;
   Satellits : PString;
   FotSysDir : PString;
   Pzs       : PString;

  End;

 TStdRec = Record
   Param1 : Param4Record;
   Param2 : Param4Record;
 End;

 TEpoh = Record

   Year   : LongInt ;
   Month  : Byte    ;
   Day    : Byte    ;

   Hour     : Byte;
   Minute   : Byte;
   Sec      : Single;

 End;

 TTeleskopPosition = Record

  Shirota : Param4Record ;
  Dolgota : Param4Record ;
  Height  : Single       ;

 End;

 TKosmosOrbita = Record

  HeightAppoCentra   : Real ;
  HeightPeriCentra   : Real ;

  NaklOrbKEkv        : Real ;
  PrVoshVoshUzla     : Real ;

  ArgPeriCentra      : Real ;
  ArgShir            : Real ;


{
  NaklOrbKEkv        : Param4Record ;
  PrVoshVoshUzla     : Param4Record ;
  ArgPeriCentra      : Param4Record ;
  ArgShir            : Param4Record ;
 }
 End;

 TFotoPriemnik  =  Record

  PeriodMatrX     : Single ;
  PeriodMatrY     : Single ;

  RazmPixX        : Single ;
  RazmPixY        : Single ;

  KolElemX        : Word   ;
  KolElemY        : Word   ;

 End;

 TPoleZr        =  Record

  RazmPolX        : Single;
  RazmPolY        : Single;

  RazmDopRamkX    : Single;
  RazmDopRamkY    : Single;

  OrientX        : Integer;
  OrientY        : Integer;

 End;

 TFotometrHar   =  Record

  MvPred          : Single;
  dMPriOtogd      : Single;

 End;


 TEpohaElementov = Record

    Month    : Byte;
    Day      : Byte;
    Year     : LongInt;

    Hour     : Byte;
    Minute   : Byte;
    Sec      : Single;

 End;

 TBeginDate = Record

    Month    : Byte;
    Day      : Byte;
    Year     : LongInt;

    Hour     : Byte;
    Minute   : Byte;
    Sec      : Single;

    Step     : Single;

 End;

 TRegims   = Record

    OutFOV        : Word    ;
    Object_Tracks : Word    ;
    DetCdc        : Word    ;
    DetImp        : Word    ; { 0 - Hе отожд,  1 - Все }
    StopNoDet     : Word    ; { 0 - Hе Stop, 1 - Stop пpи неот }
    Corr_Fot_Sys  : Word    ;
    NPolFix       : Word    ;

    ImportStar    : Word    ; { 0 - Hе вводить         }
    PzsInFOV      : Word    ;

 End;


 TRCatDet  = Record

    RoPPMDet       : Single ;
    RoGscDet       : Single ;
    RoCdcDet       : Single ;
    RoBsDet        : Single ;
    RoHdDet        : Single ;
    RoGcvsDet      : Single ;
    RoDmDet        : Single ;
    RoIrasDet      : Single ;
    RoImpDet       : Single ;

 End ;


 TOrientDet  = Record

    Tangag       : Single ;
    Ryskanie     : Single ;

 End ;

  String20 = String [ 20 ] ;


Const

  FlagSdIzo         : Boolean       = False  ;
  DmFlag            : Boolean       = False  ;
  GscFlag           : Boolean       = False  ;
  SaoFlag           : Boolean       = False  ;
  DmDel             : Boolean       = False  ;
  MainParamFileName : String [ 79 ] = ''     ;
  MainParamFileMemo : String [ 79 ] = 'Setup';
  MPFFlag           : Boolean       =  False ;
  ListParamFileName : String [ 79 ] = ''     ;
  DmNumber          : String20      = ''     ;


  CCatalogFlag : Word = 0;
  CatalogDir   : TCatPath = (
                              HIP    : '' ;
                              TYC    : '' ;
                              PPM    : '' ;
                              BS     : '' ;
                              HD     : '' ;
                              Gcvs   : '' ;
                              CDS    : '' ;
                              NPM    : '' ;
                              NLTT   : '' ;
                              A20    : '' ;
                              GSC    : '' ;
                              Dm     : '' ;
                              IRAS   : ''
                                              );

  EDir       : TEDirPath = ( Import    : '' ;
                             Satellits : '' ;
                             FotSysDir : '' ;
                             Pzs       : ''  ) ;

  KosmosCentralTelo           : Byte     = 1 ;
  KosmosCentralTeloSputnikNum : Integer  = 0 ;

  NObject           : Byte    = 1 ;
  NObjectSputnikNum : Integer = 0 ;

  EkvCoord   : TStdRec = ( Param1 : ( BChar : ' ';
                                           PI1 : 1;
                                           PI2 : 1;
                                           PD  : 1 );
                                Param2 : ( BChar : ' ';
                                           PI1 : 1;
                                           PI2 : 1;
                                           PD  : 1 ) );


  HorCoord   : TStdRec = ( Param1 : ( BChar : ' ';
                                           PI1 : 1;
                                           PI2 : 1;
                                           PD  : 1 );
                                Param2 : ( BChar : ' ';
                                           PI1 : 1;
                                           PI2 : 1;
                                           PD  : 1 ) );

  EpModel : Byte = 1;

  EpIzobr         : TEpoh     = ( Year  : 1950 ;
                                  Month :    1 ;
                                  Day   :    1 ;
                                  Hour  :    0 ;
                                  Minute :   0 ;
                                  Sec    :   0 );

  EpInform        : TEpoh     = ( Year  : 1950 ;
                                  Month :    1 ;
                                  Day   :    1 ;
                                  Hour   :   0 ;
                                  Minute :   0 ;
                                  Sec    :   0 );

  TeleskopPosition   : TTeleskopPosition  = (   Shirota : ( BChar : ' ';
                                                            PI1 : 1;
                                                            PI2 : 1;
                                                            PD  : 1 );
                                                Dolgota : ( BChar : ' ';
                                                            PI1 : 1;
                                                            PI2 : 1;
                                                            PD  : 1 );
                                                Height  : 0        );

  TeleskopHeoCenterFlag : Boolean = False ;
  TPCP                  : Byte    = 2     ;

  KosmosOrbita   :  TKosmosOrbita = (  HeightAppoCentra   : 0.0 ;
                                       HeightPeriCentra   : 0.0 ;

                                       NaklOrbKEkv        :  0.0;
                                                            { ( BChar : '-';
                                                              PI1 : 1;
                                                              PI2 : 1;
                                                              PD  : 1 ) ;
                                                            }
                                       PrVoshVoshUzla     :  0.0;
                                                            {( BChar : ' ';
                                                              PI1 : 1;
                                                              PI2 : 1;
                                                              PD  : 1 ) ;}

                                       ArgPeriCentra      :  0.0;
                                                             {( BChar : ' ';
                                                              PI1 : 1;
                                                              PI2 : 1;
                                                              PD  : 1 ) ;}

                                       ArgShir            :  0.0
                                                             {( BChar : ' ';
                                                              PI1 : 1;
                                                              PI2 : 1;
                                                              PD  : 1 ) }
                                                              );

  FotoPriemnik   :  TFotoPriemnik = (  PeriodMatrX     : 0.0 ;
                                       PeriodMatrY     : 0.0 ;

                                       RazmPixX        : 0.0 ;
                                       RazmPixY        : 0.0 ;

                                       KolElemX        : 0 ;
                                       KolElemY        : 0  );

  PoleZr         :  TPoleZr       = (
                                       RazmPolX        : 0 ;
                                       RazmPolY        : 0 ;

                                       RazmDopRamkX    : 0 ;
                                       RazmDopRamkY    : 0 ;

                                       OrientX        : 0 ;
                                       OrientY        : 0  );

  FotometrHar    :  TFotometrHar  = (  MvPred          : 0 ;
                                       dMPriOtogd      : 0  );

  EpohaElementov :  TEpoh = (

                       Year     : 1950 ;
                       Month    :    1 ;
                       Day      :    1 ;

                       Hour     :  0 ;
                       Minute   :  0 ;
                       Sec      :  0  );

  BeginDate :  TBeginDate = (

                       Month    :    1 ;
                       Day      :    1 ;
                       Year     : 1950 ;

                       Hour     :  0 ;
                       Minute   :  0 ;
                       Sec      :  0 ;
                       Step     : 0.01);


  Regims    :  TRegims  = (

    OutFOV         : 0    ;
    Object_Tracks  : 0    ;
    DetCdc         : 0    ;
    DetImp         : 0    ; { 0 - Hе отожд,  1 - Все }
    StopNoDet      : 0    ; { 0 - Hе Stop, 1 - Stop пpи неот }
    Corr_Fot_Sys   : 0    ;
    NPolFix        : 1    ;

    ImportStar     : 0    ; { 0 - Hе вводить         }
    PzsInFOV       : 0
                             );


  RCatDet : TRCatDet  = (

    RoPPMDet       : 5.0 ;
    RoGscDet       : 5.0 ;
    RoCdcDet       : 5.0 ;
    RoBsDet        : 5.0 ;
    RoHdDet        : 5.0 ;
    RoGcvsDet      : 5.0 ;
    RoDmDet        : 5.0 ;
    RoIrasDet      : 5.0 ;
    RoImpDet       : 5.0   ) ;


  OrientDet : TOrientDet = (

    Tangag     : 0.0 ;
    Ryskanie   : 0.0  ) ;


  NGrImpBeg        : LongInt = 1 ;
  Space_Earth_Flag : Byte = 1;

  SetOptOrbit      : Byte = 1;

  OptOsOrient      : Byte = 1;



Var

  DateNew     : Boolean ;
  ChPassW     : Word    ;
  TscriptFont : Integer ;


Implementation
End.