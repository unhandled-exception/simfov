
Unit PVar;

Interface

  Uses  V_Catal, Dos, Graph ;


  Const


    Version  = '17 Mar 2002' ;

    NGPagesConst : Byte    = 2 ; { Для отладки гpафики - 1, для pаботы - 2 }
                                 { ─────────────────────────────────────── }
    DtGrTopo     : Integer = 3 ; { Разность сpедних Местного и Гpинвичского
                                   вpемен в часах }
    PointerWidth : LongInt = 5 ; { Размеp куpсоpа по оси 'X'в пикселях }
                                 { ─────────────────────────────────── }
    PmMarkingMin     =  0.0005 ; { Min pасцвечиваемое значение P.M. ArcSec }
                                 { ─────────────────────────────────────── }

    SatElementFileName  : String = 'S_E.Dat' ;
    SatNameFileName     : String = 'S_N.Dat' ;

    NULL     =   #0  ;     { Keys for GetKey & UnGetKey }
    ESCKEY   =  #27  ;

    SatElementsOld : Boolean = False ;
    SDIzo          : Boolean = False ;
    ScrIzo         : Boolean = True  ;

    Hist    : Byte      =     1 ;
    (*
    NotPmAc : Word      =    10 ;  { LightBlue  }
    *)
    NotPmAc : Word      =    90 ;  { LightGreen }
    IdCoord : Word      =     1 ;

    ObjectBlockSize     =   100 ;
    PlanetBlockSize     =   100 ;
    GraphBuffSize       = 24576 ;
    ObjectMaxBlocksInit =   250 ;
    PlanetMaxBlocksInit =    90 ;

    MaxSatellits        =  6600 ;
    MaxSatMark          =   100 ;

    NPointSatMark : Word =                 0 ;
    MaxPlanets    : Word = MaxSatellits + 15 ;



      { Для МHК }
      { ▄▄▄▄▄▄▄ }

    NEqMaxMnk              =  1050   ;  { Mnk in Memory }
    NVarMnk                =     9   ;
    RedModelType : Byte    =     2   ;
    ErrorMaxDet  : Single  =     3.0 ;  { Max Error MNK in ArcSec }


    C10      : Double =      1.0  ;
    C20      : Double =      2.0  ;
    C100     : Double =     10.0  ;
    C600     : Double =     60.0  ;
    C1000    : Double =    100.0  ;
    C1270    : Double =    127.0  ;
    C10000   : Double =   1000.0  ;
    C36000   : Double =   3600.0  ;
    C864000  : Double =  86400.0  ;

    FD     : Extended = 3437.75 ;

    Pi2    : Extended = 6.283185307179586 ;
    Pid2   : Extended = 1.570796326794897 ;

    GR     : Extended =   3600.0          / 206264.8062470964 ;
    RG     : Extended = 206264.8062470964 / 3600.0            ;
    SekRad : Extended = 206264.8062470964                     ;
    AE     : Double   = 149597870.66                          ;

    HGor : Double  = - ( 35.0 * 60.0 ) / 206264.8062470964 ; { Refr Gor }

    RaGalPol50   : Double = 192.25 / 206264.8062470964 * 3600.0 ;
    DeclGalPol50 : Double =   27.4 / 206264.8062470964 * 3600.0 ;

    StepGR : Double = 1.25 ;

    JD50   = 2433282.42345 ;
    J2000  = 2451545.0      ;


    SpectraName : String [     8 ]         = 'OBAFGKM ';

    SpectraCol  : Array  [ 0..12 ] Of Byte =
                                      ( Blue, LightBlue, White, White,
                                        Yellow, LightMagenta, LightRed, {Red,}
                                        LightGray, LightCyan,  LightGreen,
                                        LightMagenta,
                                        LightMagenta, LightGray  );

    A20Col  : Array  [ 0..8 ] Of Byte =
                                      ( LightBlue, LightCyan, White,
                                        Yellow, LightMagenta,
                                        LightRed, Red, LightGreen,
                                        LightGray                      );

    PlColArr  : Array [ 1 .. 15 ] Of Byte =
             ( White ,    LightBlue, Green,     LightRed,  LightCyan,
               LightCyan, Cyan,      LightBlue, LightBlue, LightGreen,
               Yellow   , Cyan,      Cyan,      Cyan,      Cyan        ) ;

    MarkingCol : Array [1..12] Of Byte =                        (
                 Red,           Brown,             LightRed,
                 Green,         Cyan,              LightGreen,
                 LightCyan,     White,             Yellow,
                 LightBlue,     Blue,              Magenta
                                                                );

    PlanetName : Array [1..15] Of String[8] = (
              'Mercury ','Venus   ','Earth   ','Marth   ','Jupiter ',
              'Saturn  ','Uran    ','Neptun  ','Pluto   ','Moon    ',
              'Sun     ','Io      ','Europa  ','Ganimed ','Kallisto');


    MonthName  : Array [ 0 .. 13 ] Of String [ 3 ] = ( '  ',
                   'Jan','Feb','Mar','Apr','May','Jun',
                   'Jul','Aug','Sep','Oct','Nov','Dec', '???' ) ;


    CatIzoMax       =   16 ;

    CatHip          =    1 ;
    CatTyc          =    2 ;
    CatPPM          =    3 ;
    CatSao          =    4 ;
    CatBs           =    5 ;
    CatHd           =    6 ;

    CatGcvs         =    7 ;
    CatCdc          =    8 ;
    CatNPM          =    9 ;
    CatNLtt         =   10 ;
    CatA20          =   11 ;
    CatGsc          =   12 ;
    CatDm           =   13 ;

    CatOthers       =   14 ;
    CatImp          =   15 ;
    CatCdcMoz       =   16 ;


    NameCat : Array [ 1 .. CatIzoMax ]  Of String [ 4 ] =
     (
       'Hip'  , 'Tyc'  , 'PPM'  , 'Sao'  , 'BS'   ,
       'HD'   , 'GCVS' , 'AC'   , 'Npm'  , 'Lt'   ,
       'A20'  , 'Gsc'  , 'Dm'   , 'Oth'  , 'Imp'  ,
       'AcPl'
     );


    JdCat : Array [ 1 .. CatIzoMax ]  Of Double =  (
            J2000, J2000, J2000, J2000, J2000,
            J2000, JD50 , J2000, JD50 , JD50 ,
            J2000, J2000, J2000, J2000, J2000,
            J2000
                                                   ) ;


    PrioritetIzo    : Array [ 1 .. CatIzoMax ]  Of  Integer =
     (
       CatGcvs     , CatOthers  , CatHip     , CatTyc     , CatCdc    ,
       CatPpm      , CatNpm     , CatNLtt    ,
       CatBs       , CatGsc     , CatHd      ,
       CatDm       , CatCdcMoz  , CatImp     , CatSao    ,
       CatA20
     ) ;


    FormatImport : Array [ 1 .. 8 ]  Of ShortInt = (
       1,    { R.A. S                              }
       1,    { Decl S                              }
       0,    { P.M.       < 0 - P.M.Ra in Sec      }
       1,    { M                                   }
       0,    { N Pusto                             }
       0,    { N Pos Name                          }
       0,    { Epoc Observation Exist ( 1 )        }
       0     { 1 - Coord In Grad                   }
                                                            ) ;

    NameDm : Array [ 1 .. 4 ]  Of String [ 2 ] = ( 'BD', 'SD', 'CD', 'CP' ) ;
    NDmAdd : Array [ 0 .. 6 ]  Of Char = ( ' ','a', 'b','d','m','?','*' ) ;


    OutFileName = 'SimFOV.Out' ;

    CatFile : CatFilesType =
               (
                 HipFileName         : 'Hip.SRT'         ;
                 HipKeyFileName      : 'Hip.GRN'         ;
                 HipAddFileName      : 'Hip.Add'         ;
                 TycFileName         : 'Tyc.SRT'         ;
                 TycKeyFileName      : 'Tyc.GRN'         ;
                 TycSaiFileName      : 'Tyc_Sai.SRT'     ;
                 TycSaiKeyFileName   : 'Tyc_Sai.GRN'     ;
                 Tyc_2_FileName      : 'Tyc_2.SRT'       ;
                 Tyc_2_AddName       : 'Tyc_2.Add'       ;
                 Tyc_2_KeyFileName   : 'Tyc_2.GRN'       ;
                 PPMFileName         : 'Ppm.SRT'         ;
                 PPMKeyFileName      : 'Ppm.GRN'         ;
                 SaoFileName         : 'Sao.SRT'         ;
                 SaoKeyFileName      : 'Sao.GRN'         ;
                 NpmFileName         : 'Npm1.SRT'        ;
                 NpmKeyFileName      : 'Npm1.GRN'        ;
                 HdFileName          : 'Hd.SRT'          ;
                 HdKeyFileName       : 'Hd.GRN'          ;
                 HdEFileName         : 'HdE.SRT'         ;
                 HdEKeyFileName      : 'HdE.GRN'         ;
                 DmFileName          : 'Dm.SRT'          ;
                 DmKeyFileName       : 'Dm.GRN'          ;
                 GcvsFileName        : 'GCVS_New.SRT'    ;
                 GcvsKeyFileName     : 'GCVS_New.GRN'    ;
                 Gcvs2000FileName    : 'GCVS2000.SRT'    ;
                 Gcvs2000KeyFileName : 'GCVS2000.GRN'    ;
                 CdcCatFileName      : 'Ak.Srt'          ;
                 CdcKeyFileName      : 'Ak.Grn'          ;
                 NLTTFileName        : 'NLTT.SRT'        ;
                 NLTTKeyFileName     : 'NLTT.GRN'
                 {
                 HicBinFileName      : 'Hic_bin.SRT'     ;
                 HicBinKeyFileName   : 'Hic_bin.GRN'
                 }
               );


    R_Planets : Array [ 1 .. 15 ] Of Double = (   2424.0   ,
                                                  6100.0   ,
                                                  6368.137 ,
                                                  3412.0   ,
                                                 71420.0   ,
                                                 60440.0   ,
                                                 24860.0   ,
                                                 26500.0   ,
                                                  7250.0   ,
                                                  1738.2   ,
                                                695992.0   ,
                                                  1735.0   ,
                                                  1550.0   ,
                                                  2500.0   ,
                                                  2350.0
                                                             ) ;


        FM : Array [ 1..11 ] Of Double = ( 1.618816E14    ,
                                           2.4250176E15   ,
                                           2.975555451E15 ,
                                           3.2082756E14   ,
                                           9.4588956E17   ,
          { KM*KM*KM/DAY/DAY }             2.8306158E17   ,
                                           4.3321343E16   ,
                                           5.2449346E16   ,
                                           2.4767886E15   ,
                                           2.659801E13    ,
                                           9.9071556E20
                                         ) ;

 (*
 O_HA_W  =  1;
 O_HP_W  =  2;
 O_OM_W  =  3;
 O_IN_W  =  4;
 M_DT_W  =  5;
 M_TI_W  =  6;
 M_AN_W  =  7;
 M_HG_W  =  8;
 C_RA_W  =  9;
 C_DC_W  = 10;
 C_AZ_W  = 11;
 C_ZR_W  = 12;
 F_W     = 13;
 N_W     = 14;
 S_RO_W  = 15;
 S_PA_W  = 16;
 M_RO_W  = 17;


 Width : Array [1..17] Of Byte = (
          9, { HA }
          9, { HP }
          8, { Om }
          8, { I  }
         10, { date }
          8, { time }
          8, { anom }
          8, { HT   }
         10, { Az   }
         10, { Zr   }
          8, { RA   }
          8, { Dc   }
          9, { Field}
          7, { Net  }
          8, { Sun r}
          8, { Sun p}
          8  { Moon }            );
 *)

    {PSaveDate : Boolean = False;} { Пpизнак сохpанения даты пpи -> Меню Ол. }
                                   { ─────────────────────────────────────── }
    {
    BOlValMenu : Boolean = False ;

    NoCoord : Word   =    0    ;
    SqCoord : Word   =    2    ;
    EqCoord : Word   =    3    ;

    H24    : Double =     86400.0     ;

    DayOfWeek : Array [0..6] Of String [9] =
                    ('Sunday','Monday','Tuesday',
                     'Wednesday','Thursday','Friday',
                     'Saturday');

    JDHipCat    : Double = J2000 ;
    JDTycCat    : Double = J2000 ;
    JDPpmCat    : Double = J2000 ;
    JDSaoCat    : Double = J2000 ;
    JDBsCat     : Double = J2000 ;
    JDHdCat     : Double = J2000 ;
    JDCdcCat    : Double = J2000 ;
    JDGcvsCat   : Double = JD50  ;
    JDNpmCat    : Double = Jd50  ;
    JDNLttCat   : Double = Jd50  ;

    JDA10Cat    : Double = J2000 ;
    JDGscCat    : Double = J2000 ;
    JDDmCat     : Double = J2000 ;
    JDOthersCat : Double = J2000 ;
    JdAK        : Double = J2000 ;

    NameCat : Array [ 1 .. CatIzoMax ]  Of String [ 4 ] =
     (
       'Hip'  , 'Tyc'  , 'PPM'  , 'Sao'  , 'BS'   ,
       'HD'   , 'GCVS' , 'AC'   , 'Npm'  , 'Lt'   ,
       'A10'  , 'Gsc'  , 'Dm'   , 'Oth'  , 'Imp'  ,
       'AcPl'
     );

    }


Type



 ObjectType =
          Record { 16 }
	    X       ,
	    Y       : Single  ; { Кооpдинаты в поле зpения, мм.        }
	    M       : Byte    ; { ( Mv + 5 ) * 10                      }
            Sp      : Byte    ; { Sp                                   }
	    NRecC   : LongInt ; { Номеp в исходном дв. каталоге
                                  + Marking * 1 000 000 000            }
                                { Видимость об'екта : NRecC > 0        }
            Date    : Word    ; { Дата GSC  или  # Marking Star        }
                                { Hомеp отожд. звезды для МHК пpи Ccd  }
          End;

 ObjectArrType = Array [ 0 .. ObjectBlockSize - 1 ] Of ObjectType ;
 ObjectPtrType = ^ ObjectArrType ;


 PairsRedType = Record
                  IndObj,
                  IndRep  : LongInt ;
                End ;



 PmVectType   = Record
                  PmX   : Shortint ;
                  PmY   : Shortint ;
                End ;

 PmVectArr     = Array [ 0 .. ( ObjectMaxBlocksInit - 1 ) * 100 ] Of PmVectType ;
 PmVectPtrType = ^ PmVectArr ;


         {  ───────────  *  ───────────  }



 PlanetType = Record { 28 }
                X          : Single  ;
                Y          : Single  ;
	        R          : Single  ; { Topocentric distance in KM }
                M          : Single  ;
                Nr         : Integer ;
                D_IZO      : Single  ; { Diameter in mm. for izo }
                Phase      : Single  ;
                Visible    : Boolean ;
                NowVisible : Boolean ;
              End ;

 SatEartchPointType =
              Record
                X      : Single ;
                Y      : Single ;
                XGeoc,
                YGeoc,
                ZGeoc  : Single ;
              End ;

         {  ───────────  *  ───────────  }


SatElementType = Record { 52 }

                   NSat  : Integer ; { Hомеp стpоки в файле имен спутников  }
                   T0    : Double  ; { Эпоха элементов в юлианских днях     }
                   ISat  : Single  ; { Наклон относительно земного экватоpа }
                   OmG   : Single  ; { Пpямое восхождение восходящего узла  }
                   Eksc  : Single  ; { Эксцентpиситет                       }
                   OmL   : Single  ; { Расстояние пеpицентpа от узла        }
                   M0    : Real    ; { Сpедняя аномалия в эпоху T0.         }
                   Mot   : Double  ; { Сpеднее движение за сутки            }
                   Mot1  : Single  ; { dMot/dT/2                            }
                   Mot2  : Single  ; { dMot/dT2/6                           }
                   BStar : Single  ; {                                      }

                   (*

                   NSat  : Integer ; { Hомеp стpоки в файле имен спутников  }
                   T0    : Double  ; { Эпоха элементов в юлианских днях     }
                   ISat  : Single  ; { Наклон относительно земного экватоpа }
                   OmG   : Single  ; { Пpямое восхождение восходящего узла  }
                   Eksc  : Single  ; { Эксцентpиситет                       }
                   OmL   : Single  ; { Расстояние пеpицентpа от узла        }
                   M0    : Real    ; { Сpедняя аномалия в эпоху T0.         }
                   Mot   : Double  ; { Сpеднее движение за сутки            }
                   Mot1  : Single  ; { dMot/dT/2                            }
                   Mot2  : Single  ; { dMot/dT2/6                           }
                   BStar : Single  ; {                                      }


                   NSat  : Integer ; { Hомеp стpоки в файле имен спутников  }
                   T0    : Double  ; { Эпоха элементов в юлианских днях     }
                   ISat  : Double  ; { Наклон относительно земного экватоpа }
                   OmG   : Double  ; { Пpямое восхождение восходящего узла  }
                   Eksc  : Double  ; { Эксцентpиситет                       }
                   OmL   : Double  ; { Расстояние пеpицентpа от узла        }
                   M0    : Double  ; { Сpедняя аномалия в эпоху T0.         }
                   Mot   : Double  ; { Сpеднее движение за сутки            }
                   Mot1  : Double  ; { dMot/dT/2                            }
                   Mot2  : Double  ; { dMot/dT2/6                           }
                   BStar : Double  ; {                                      }
                   *)

                 End ;


 SatNameType = Record

                 NameSat    : String [ 63 ] ;
                 NumberSat  : LongInt       ;
                 InternDes  : String [  8 ] ;

               End ;


         {  ───────────  *  ───────────  }



 IndCatType = Record

                JdCat         : Double  ;

                NBeg          : LongInt ;
                NEnd          : LongInt ;

                TypeCoord     : Word    ;
                RoDet         : Single  ;
                NDet          : LongInt ;

                NStarInFild   : LongInt ;
                NoDetInFild   : LongInt ;

                SPozNp1       : Double  ;
                CPozNp1       : Double  ;

                SRaOpt        : Double  ;
                CRaOpt        : Double  ;
                SDeclOpt      : Double  ;
                CDeclOpt      : Double  ;

              End ;



         {  ───────────  *  ───────────  }


 (*
 MatrixCenterType = Record   { КООРДИHАТЫ ЦЕHТРА МАТРИЦЫ В ММ. }
                      X      : Double ;
                      Y      : Double ;
                    End ;
 *)

         {  ───────────  *  ───────────  }


 DateType   = Record

                Year  : LongInt;
                Month : Byte;
                Day   : Byte;

              End;

         {  ───────────  *  ───────────  }



 TimeType   = Record

                Hour  : Byte;
                Min   : Byte;
                Sec   : Double;

              End;


         {  ───────────  *  ───────────  }



 AngularType = Record

                Neg   : Boolean;
                Deg   : Integer;
                Min   : Byte   ;
                Sec   : Byte   ;

              End;

         {  ───────────  *  ───────────  }



 ParVarType = Record


                Date    : DateType    ;
                Time    : TimeType    ;

                Ra0     : AngularType ;
                Dc0     : AngularType ;

                ZOpt    : Double      ;  { Deg. }

                A0      : AngularType ;
                Z0      : AngularType ;

                M       : Double      ;  { MEAN ANOMALY ( Deg. ) }
                H       : Double      ;  { ALTITUDE     ( Km.  ) }
                VC      : Double      ;  { V->  CENTER  ( Deg. ) }
                RC      : Double      ;  { V    CENTER  ( MM.  ) }
                NSt     : Integer     ;  {  Кол-во звезд         }
                NPl     : Integer     ;  {         планет        }
                MInt    : Double      ;  { Средн. интенсивность в поле }

              End;

         {  ───────────  *  ───────────  }



 ParConstType = Record

                 HA    : Double     ;  { H AP.  ( Km. ) }
                 HP    : Double     ;  { H PER. ( Km. ) }
                 I     : Double     ;  {        ( Deg.) }
                 OMG   : Double     ;  {        ( Deg.) }
                 DAOPT : Double     ;  {        ( Deg.) }

                 WG,
                 HG    : Double     ;  { Поле в градусах }

                 PERX,
                 PERY,                 { Матрица }
                 PIXX,
                 PIXY  : Double     ;  { Минуты дуги }
                 NPX,
                 NPY   : Integer    ;

                End;


 MaterikiType = Record

                  X,
                  Y,
                  Z   : Integer ;  {  Round ( X ( km ) * 5 )  }
                  E   : Byte    ;  {  = 1  If  End Line       }

                End ;


     EkvType = Record

                  X,
                  Y,
                  Z   : LongInt ;  {  Round ( X ( km ) *  100 000 )  }

                End ;

     S9Type = Record
                S9 : Array [ 1 .. 11 ] Of Char ;
              End ;

     S19Type = Record
                 S19 : Array [ 1 .. 21 ] Of Char ;
               End ;


 PlateZagolArr  = Array [ 1 .. 255 ] Of AkInfType ;
 PlateZagolPtr  = ^ PlateZagolArr ;

 RezArray    = Array [ 1..15 , 1..7 ] Of Double ;
 PlCoordType = Array [ 1..15 , 1..3 ] Of Double ;
 {
 AcMainNumArr = Array [ 0 .. 5600 ] Of Word ;
 AcMainNumPtr = ^AcMainNumArr ;
 }
 MaterikiArr = Array [ 1 .. 3000 ] Of MaterikiType ;
 MaterikiPtr = ^MaterikiArr ;

 EkvArr = Array [ 1 .. 365 ] Of EkvType ;
 EkvPtr = ^EkvArr ;

 PlanetArrType = Array [ 0 .. PlanetBlockSize - 1 ] Of PlanetType ;
 PlanetPtrType = ^PlanetArrType ;

 SatEartchPointArr = Array [ 1 .. MaxSatMark ] Of SatEartchPointType ;
 SatEartchPointPtr = ^SatEartchPointArr ;

 BsIkoArr = Array [ 1 .. 1000 ] Of BsIkoType ;
 BsIkoPtr = ^BsIkoArr ;

 DE200    = Array [ 1 .. 828 ] Of Double ;
 DE200Ptr = ^DE200 ;

 PT  = Record
         X,
         Y : Integer ;
       End;

 MwType = Record
            hd     : String [20]  ;
            Count  : Byte        ;
            CBack,
            CBox ,
            CFore  : Byte;
            wnd    : ViewPortType;
          End;

 IwType = ViewPortType;




         {  ───────────  *  ───────────  }



  Var

    
    (*
    AcMainNum         : AcMainNumPtr   ; { Для отождествления по 'Кpесту'}
    *)
    Materiki          : MaterikiPtr       ;
    Ekv               : EkvPtr            ;
    SatEartchPoint    : SatEartchPointPtr ;
    DE200Buf          : DE200Ptr          ;
    BsIko             : BsIkoPtr          ;
    BsIkoRec          : BsIkoType         ;
    PlateZagol        : PlateZagolPtr     ;
    PmVect            : PmVectPtrType     ;

    ObjectRecord      : ObjectType        ;
    SatElementsRecord : SatElementType    ;
    PlanetRecord      : PlanetType        ;
    PmVectRecord      : PmVectType        ;

    CatNameKutcha   : Array [ 1 .. CatIzoMax ] Of String [ 8 ] ;
    CatKutchaRecL   : Array [ 1 .. CatIzoMax ] Of Word         ;


    ObjectPtr	    : Array [ 0..ObjectMaxBlocksInit-1 ] Of ObjectPtrType ;
    BlockAllocFlag  : Array [ 0..ObjectMaxBlocksInit-1 ] Of Boolean ; { Флаг выделен / нет }


    PlanetPtr       : Array [ 0..PlanetMaxBlocksInit-1 ] Of PlanetPtrType ;
    PlanetAllocFlag : Array [ 0..PlanetMaxBlocksInit-1 ] Of Boolean ; { Флаг выделен / нет }

    CBlock 	    : Word ;
    CBlockSat       : Word ;
    CBlockPlanet    : Word ;

    IndCat          : Array [ 0 .. CatIzoMax ] Of IndCatType ;


    {
    Bal, PWisocY,
    }
    EndStars,
    A_Pressed,
    GscNew,
    MarkingRepStars,
    {
    FlagAcMainNumAlloc,
    }
    StepSectorMarkIzo,
    F4Key, OutPoint,
    NoDetCdcExist,
    NameCatTekExist,
    NameCatCdcExist,
    NameCatTekCdcExist,
    EndProc,
    CalcFild,
    ReCalcPlanets,
    GscAddExist,
    CalcVectDiagr,
    RealTimeDate, RealTimeStep,
    B_Others, B_Dm, B_PPM, B_Sao,
    B_BS, B_HD,
    B_Gcvs, B_Gcvs2000,
    B_GSC, B_A20,
    B_NPM,B_Nltt, B_Hip, B_Hip_Add,
    B_Tyc, B_Tyc_0, B_Tyc_Sai, B_Tyc_2, B_Tyc_2_Add,
    B_Cdc, B_Cdc_Cat,
    B_Color_A2_0,
    B_SURF,
    B_GEOC,
    B_From_Star,
    B_PlanDraw,
    B_Parsek,
    B_Inport_Ccd,
    CcdDiamExist,
    B_Import_Fld, B_IMPORT_Sat, B_EXPORT,
    Neg,
    B_ObserverNumSat,
    OptRd, B_Fot_Sys,
    NPolFix,
    B_Stop_NoDet,
    B_Stop_All,
    B_Ef_Sat_Cheb,
    B_VectDiagr,
    B_Det_Imp,
    B_ObjOut,
    B_X_Max,
    B_Menu,
    B_Gal,
    B_Object_Tracks,
    StarsInFild,
    PMScale,
    Start,
    FlagTCivil,
    OptIzo,
    MvFloat,
    DateOld,
    ClearScr,
    Marking,
    Refr,
    PointPrima,
    FlagF9,
    HdE,
    FlagFieldZagol,
    CatNotFound,
    ErrProcCcd,
    ErrElSat,
    ReductionExist,
    ImportReduction,
    Reenter,
    BReportOScreen,
    KeyExist
    {
    B_Det_Cdc,
    B_Matrix,
    OutCdc,
    OptAH,
    PassW,
    }
                                           : Boolean ;

    Ch, UserKey                            : Char    ;

    SClass,
    NGPages,
    CatMax,
    SClassInfo,
    Pom_Fld,
    NGrMarking,
    NMarkingRepStars                       : Byte    ;


    IndCnst,
    NSatInFild,
    NFound,
    NBsIko,
    TimerYear, TimerMonth, TimerDay,
    TimerDayOfWeek,
    TimerHOUR, TimerMIN,
    TimerSEC, TimerSEC100                  : Word    ;



    PointerWidth_Y,
    LastObject,
    NPlOpt,
    NPl0,
    MonthDate,
    NPl, NPlSum,
    NRAMax, NDecMax,
    NumberOfSatellits,
    NPlanetsInFild,
    ObserverNumSat,
    Max_PL_PPlFld,
    NPlSat,
    NDiagrScale,
    MaxSatellitsInFile,
    NMarking ,TFont,
    NVar, NOf,
    Iy, Im,
    NumPointMateriki,
    NGrImport,
    NStarGrMax,
    DateNoObj,
    NumbMarkingBegin,
    YearDate,
    NGrImportBeg,
    N,
    IFirst, ILast,
    IRecPr,
    NStepTracks,
    NRecObjectOutFile,
    NRecObjectOutFileOld,
    NMarkingStars,
    NMarkingField,
    NumberOfStars,
    IndClassInfo,
    IndCatPairs
    { N_Pixel_X, N_Pixel_Y, N_Matrix, }
                                               : LongInt ;


    D00      , D01      , D02      , D03      ,
    E00      , E01      , E02      , E03      ,
    DistX0   , DistX1   , DistX2   , DistX3   ,
    DistY0   , DistY1   , DistY2   , DistY3   ,
    D10      , D11      , D12      , D13      ,
    D20      , D21      , D22      , D23      ,
    KMx0     , KMx1     , KMx2     , KMx3     ,
    KMy0     , KMy1     , KMy2     , KMy3     ,

    D00t     , D01t     , D02t     , D03t     ,
    E00t     , E01t     , E02t     , E03t     ,
    DistX0t  , DistX1t  , DistX2t  , DistX3t  ,
    DistY0t  , DistY1t  , DistY2t  , DistY3t  ,
    D10t     , D11t     , D12t     , D13t     ,
    D20t     , D21t     , D22t     , D23t     ,
    KMx0t    , KMx1t    , KMx2t    , KMx3t    ,
    KMy0t    , KMy1t    , KMy2t    , KMy3t
                                                  : Single  ;


    LongS,
    DMvDet,
    RDetImp,
    KMD,
    Id,
    XSun,
    YSun,
    ZSun,
    PozNp,
    SPozNp, CPozNp,
    SPozNp1, CPozNp1,
    XMax, YMax,
    RRX , RRY,
    XMaxGR, YMaxGR,
    LSun,
    XOpt, YOpt,
    AOpt, HOpt,
    SHOpt, CHOpt,
    SFIS, CFIS,
    SGrinv ,
    RoSGeoc,
    FiSGeoc, SFiSGeoc, CFiSGeoc,
    FiSAstron, SFiSAstron, CFiSAstron,
    LongSAstron, Alt,
    RoSun, RoMon,
    PozSun, PozMon,
    DMvOScr,
    JdBegDE200, JdEndDE200,
    JdTimer2,
    JDate0,
    AOPT0, HOPT0,
    DAOpt0, DHOpt0,
    ARGLAT,Mot, Mot1, Mot2, BStar,
    ISAT, OMG, OML, M0, HAP, HPER, A0, EKSC,
    ISATObs, OMGObs, OMLObs, EkscObs, M0Obs,
    MotObs, Mot1Obs, Mot2Obs, BStarObs,
    RO,  SROMax, CROMax, CRO, SRO,
    XS, YS, ZS, VXS, VYS, VZS,
    ASun , HSun ,
    AMoon, HMoon,
    XSAE, YSAE, ZSAE,
    XSunGeoc, YSunGeoc, ZSunGeoc,
    XMoonGeoc, YMoonGeoc, ZMoonGeoc,
    RaOptGal, DeclOptGal,
    SRaGalPol50, SDeclGalPol50,
    CRaGalPol50, CDeclGalPol50,
    RAOPTFLD    , DECLOPTFLD  ,
    SDECLOPTFLD , CDECLOPTFLD ,
    SRAOPTFLD   , CRAOPTFLD   ,
    PmMaxMm,
    FLDX, FLDY,
    ROPT, VOPT,
    RAOPT, DECLOPT,
    SRAOPT, CRAOPT,
    SDECLOPT, CDECLOPT,
    SAOPT, CAOPT,
    RaOptGlass ,  DeclOptGlass,
    DHMax, SHMIN, SHMax,
    ROMax,
    STIME,  SSTIME, CSTIME,
    DAYDate,
    STEPRAD,
    R90, R359, R360, RR,
    DECCKR,
    EPS, SEPS, CEPS,
    CONSTDSIN,
    R_PLANET,
    SEK,
    Jd0,  JdEp,
    JdEpSat,
    JdEpSatObs,
    MvMax,  MvMin,
    MvMaxParam, MvMinParam,
    MvMaxIzo, MvMaxIzOful,
    MvMinIzo, MvMinIzOful,
    RaOptVar, DeclOptVar,
    StepRow, StepCol,
    OcRow,  OcCol,
    ARow, BCol, CRow, DCol,
    AxImp, BxImp, CxImp,
    AyImp, ByImp, CyImp,
    DImp,  EImp,  DistImp,
    ErrDImp, ErrEImp, ErrDistImp,
    StepDiamCcd,
    JDate, JDateParam, JdTimer2Param,
    JDateFLD,
    StepTime, JdOut
    {
    PERIOD_X_MIN  , PERIOD_Y_MIN ,
    PERIOD_X_MM   , PERIOD_Y_MM  ,
    PIXEL_X_MIN   , PIXEL_Y_MIN  ,
    PIXEL_X_MM    , PIXEL_Y_MM   ,
    PERXD2        , PERYD2       ,
    PIXXD2        , PIXYD2       ,
    X_Max_MATRIX  , Y_Max_MATRIX ,
    }
                                           : Double    ;


    RezPl                                  : RezArray    ;
    RectCoordPl                            : PlCoordType ;
    DateEL                                 : DateType    ;
    TimeEl                                 : TimeType    ;
    Parconst                               : parconstType;
    Parvar                                 : parvarType  ;

    {
    MatrixCenter         : Array [ 1 ..       100 ] Of MatrixCenterType ;
    }
    Triangle             : Array [ 1 ..         4 ] Of PT      ;

    CatSort              : Array [ 0 .. CatIzoMax ] Of Boolean ;
    DMv                  : Array [ 1 ..        70 ] Of Single  ;
    SinRaFild            : Array [ 1 ..       290 ] Of Double  ;
    CosRaFild            : Array [ 1 ..       290 ] Of Double  ;
    SinDecFild           : Array [ 1 ..       145 ] Of Double  ;

    NumberStarCursor     : Array [ 1 ..       100 ] Of Word    ;
    CatStarCursor        : Array [ 1 ..       100 ] Of Byte    ;

    ImportCcdFile        : File Of CcdType          ;

    ImportStarFile       : File Of ObjectInputType  ;
    OutStarFile          : File Of String           ;
    OutDetFile           : File Of String           ;

    ObjectFile           : Text  ;
    ObjectOutFile        : Text  ;
    ConstCcdFile         : Text  ;

    ObjectString,
    OutStarString,
    OutDetString,
    OutDetStringOld      : String                   ;

    DE200File            : File Of Double           ;

    SatElemFile          : File Of SatElementType   ;
    SatNameFile          : File Of SatNameType      ;

    SatElementRec        : SatElementType           ;
    SatNameRec           : SatNameType              ;


    OutFile              : Text   ;
    ParamFile            : Text   ;
    MatrixFile           : Text   ;
    MaterikiFile         : Text   ;

    SCnst                : String ;

    NameSatObs           : String [ 63 ] ;

    WS, WS1,
    NameImp,
    ObjectFileName ,
    ConstCcdFileName,
    ObjectOutFileName    : String [ 79 ] ;



    PStr           : PathStr  ;
    DStr           : DirStr   ;
    NStr           : NameStr  ;
    EStr           : ExtStr   ;
    ExtFileAk      : ExtStr   ;

    NameImpCCD     : String [ 8 ] ;

    AkZagolFileName,
    ConstFileName,
    AkNoDteFileName,
    RectCoordFileName         : PathStr ;



    ObjectS               ,
    ParamFileName         ,
    NVarDir               ,
    SatFileName           ,
    MatrixFileName        ,
    SatFileNameOld
                             : String [ 63 ]   ;


    PPMFile        : File Of PPMType           ;
    PPMKeyFile     : File Of          KeyType  ;
    SaoFile        : File Of SaoType           ;
    SaoKeyFile     : File Of          KeyType  ;
    BsFile         : File Of BSType            ;
    BsSrcFile      : File Of BSSrcType         ;
    BsKeyFile      : File Of          KeyType  ;
    GcvsFile       : File Of GcvsType          ;
    Gcvs2000File   : File Of Gcvs2000Type      ;
    GcvsKeyFile    : File Of          KeyType  ;
    CdcFile        : File Of CdcType           ;
    CdcKeyFile     : File Of          KeyType  ;
    HipFile        : File Of HipType           ;
    HipAddFile     : File Of HipAddType        ;
    HipKeyFile     : File Of          KeyType  ;
    TycFile        : File Of HipType           ;
    TycKeyFile     : File Of          KeyType  ;
    TycAddFile     : File Of TycAddType        ;
    NLTTFile       : File Of NlttType          ;
    NLTTKeyFile    : File Of          KeyType  ;
    NpmFile        : File Of NpmType           ;
    NpmKeyFile     : File Of          KeyType  ;
    HicBinFile     : File Of HicBinType        ;
    HicBinKeyFile  : File Of          KeyType  ;
    DmFile         : File Of DmType            ;
    DmKeyFile      : File Of          KeyType  ;
    HdEFile        : File Of HdEType           ;
    HdFile         : File Of HdType            ;


    KeyRecord            : KeyType             ;

    PPMRecord            : PPMType             ;
    SaoRecord            : SaoType             ;
    NpmRecord            : NpmType             ;
    NlttRecord           : NlttType            ;
    BsRecord             : BSType              ;
    DmRecord             : DmType              ;
    GcvsRecord           : GcvsType            ;
    Gcvs2000Record       : Gcvs2000Type        ;
    CdcRecord            : CdcType             ;
    HipRecord            : HipType             ;
    HipAddRecord         : HipAddType          ;
    TycAddRecord         : TycAddType          ;
    OfRecord             : ObjectInputType     ;
    CCDRecord            : CCDType             ;
    HicBinRecord         : HicBinType          ;
    HdRecord             : HdType              ;
    HdERecord            : HdEType             ;
    {
    GSCRecord            : GSCType             ;
    GSCAddRecord         : GSCAddType          ;
    }

    AkZagolFileMoz    : File  Of  AkInfType    ;
    RectCoordFileMoz  : File  Of  AkStarType   ;
    ConstFileMoz      : File  Of  ConstType    ;
    ConstAddFileMoz   : File  Of  ConstAddType ;

    AkZagolRec        :           AkInfType    ;
    AkZagolRecMoz     :           AkInfType    ;
    AkStarRecMoz      :           AkStarType   ;


    A20DateNFile      : File  Of  S9Type       ;
    A20DateSFile      : File  Of  S19Type      ;


  { Graphics variables }

  B_Color_Mess_Av     : Boolean  ;
  Out_Mess_AV         : Boolean  ;
  Stop                : Boolean  ;

  Page                : Word     ;
  xWord               : Word     ;
  xasp , yasp         : Word     ;


  CenterX   ,
  CenterY   ,
  GScale    ,
  VScale    ,
  VCenterX  ,
  VCenterY  ,
  GScaleZap   : Double   ;


  iw, ow, mw   ,
  cw, pw       ,
  fw, ww       ,
  pxw          ,
  pxsw, pxiw   ,
  dw, prw      ,
  iprw, imenuw ,
  o_haw,o_hpw  ,
  o_omw,o_inw  ,
  m_dtw,m_tmw  ,
  m_anw,m_hgw  ,
  c_azw,c_zrw  ,
  c_raw,c_dcw  ,
  p_snw,p_mnw  ,
  s_row,s_paw  ,
  m_row,m_paw  ,
  menu_w       ,               { Меню и информационное окно }
  chat_w       ,
  gcent_w      ,
  gra_w, gdc_w ,
  gsize_w      ,
  gsized_w     ,
  optinf_w     ,
  iopt                : MwType        ;

  sw, plw             : ViewPortType  ;
  mess_w              : ViewPortType  ;
  mess_AV             : ViewPortType  ;

  S_mess_AV           : String [ 28 ] ;

  CursX,
  CursY               : Integer       ;


  XPlGelioC,
  YPlGelioC,
  ZPlGelioC    : Array [ 1 .. 11 ] Of Double ;

  GScaleArr    : Array [ 1 .. 20 ] Of Double ;
  GScaleArrCx  : Array [ 1 .. 20 ] Of Single ;
  GScaleArrCy  : Array [ 1 .. 20 ] Of Single ;

  VScaleArr    : Array [ 1 .. 20 ] Of Double ;
  VScaleArrCx  : Array [ 1 .. 20 ] Of Single ;
  VScaleArrCy  : Array [ 1 .. 20 ] Of Single ;

  DetDm        : Array [ 1 ..  4 ] Of Byte   ;


  NScaleArr   : Byte ;
  NVScaleArr  : Byte ;

  XOrient  ,
  YOrient     : Integer ;

  { Command-line checking }
  Code        : Integer ;

  {
  Deb    : Text ;
  IndDeb : Word ;
  }

 Implementation

End.
