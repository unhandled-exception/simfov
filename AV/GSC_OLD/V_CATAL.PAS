
{$O+,F+}

Unit V_Catal;

Interface

Uses Dos;

Const

    CatPPM          =    1 ;
    CatBs           =    2 ;
    CatHd           =    3 ;
    CatOkpz         =    4 ;
    CatCdc          =    5 ;
    CatGsc          =    6 ;
    CatIras         =    7 ;
    CatImp          =    8 ;
    CatIrasSAO      =    9 ;
    CatNLTT         =   10 ;
    CatCdcMoz       =   11 ;

    JD50   = 2433282.42345 ;
    J2000  = 2451545.0     ;


    JDPPMCat   = J2000 ;
    JDBsCat    = J2000 ;
    JDOkpzCat  = J2000 ;
    JDHdCat    = J2000 ;
    JDGscCat   = J2000 ;
    JDIrasCat  = JD50  ;
    JDCdcCat   = J2000 ;
    JDNLTTCat  = JD50  ;


Type


         BSType = Record
                                                                     {  ERR   }
		      SDRA    : Word    ;  { SIN DRA   * CONSTDSIN }
		      SDDEC   : Word    ;  { SIN DDEC  * CONSTDSIN }
                      MURA    : Integer ;  { MURA *CDEC*.6*10**9  }  { 0.0003 }
                      MUDEC   : Integer ;  { MUDEC*    *.6*10**9  }  { 0.0003 }
		      MV      : Byte    ;  { ( MV+5 )  *     10   }  { 0.05   }
		      SP      : Byte    ;  { SP        *     10   }
		      CAT     : Byte    ;
		      NUMSTAR : LongInt ;
                      SAO     : Longint ;

                   end;


         {  -----------  *  -----------  }

         PPMType = Record
                                                                     {  ERR   }
		      SDRA    : Word    ;  { SIN DRA   * CONSTDSIN }
		      SDDEC   : Word    ;  { SIN DDEC  * CONSTDSIN }
                      MURA    : Integer ;  { MURA *CDEC*.6*10**9  }  { 0.0003 }
                      MUDEC   : Integer ;  { MUDEC*    *.6*10**9  }  { 0.0003 }
		      MV      : Byte    ;  { ( MV+5 )  *     10   }  { 0.05   }
		      SP      : Byte    ;  { SP        *     10   }
		      CAT     : Byte    ;
                      PPM     : Longint ;

                   end;


         {  -----------  *  -----------  }



    OkpzType   = Record
                                                                     {  ERR   }
		      SDRA    : Word    ;  { SIN DRA   * CONSTDSIN }
		      SDDEC   : Word    ;  { SIN DDEC  * CONSTDSIN }
		      MVMAX   : Byte    ;  { ( MVMAX   *      10   } { 0.05   }
		      MVMIN   : Byte    ;  { ( MVMIN   *      10   } { 0.05   }
		      CAT     : Byte    ;  { 0 - P, 40 - V, 80 - ? }
                      NUM     : Longint ;  { СОЗВ * 10000 + HОМЕР  }

                 End ;


         {  -----------  *  -----------  }



           HdType = Record
                                                                   {  ERR   }
		     SDRA   : Word    ;  { SIN DRA   * CONSTDSIN }
		     SDDEC  : Word    ;  { SIN DDEC  * CONSTDSIN }
		     MV     :  Byte   ;  { ( MV+5 )  *      10   } { 0.05   }
		     SPECTR :  Byte   ;  { SP        *      10   }
                     CAT    :  Byte   ;
		     DM     : LongInt ;

		    end;



         {  -----------  *  -----------  }



       GSCType = Record
                                                                     {  ERR   }

		      SDRA    : Integer ;  { SIN DRA   * CONSTDSIN           }
		      SDDEC   : Integer ;  { SIN DDEC  * CONSTDSIN           }
		      MV      : Byte    ;  { Round ( (MV-4)*10 ) * 2 + Class }
                      Date    : Byte    ;  { Round ( ( Year - 70 ) * 10 )    }
                                           { If Date = 0 -> ( Year = 51.5    }

                   end;


 GSCAddType =

    Record

      Source_no : Longint ; { Hомеp м.п. * 100 000 + номеp * 10 + Mult (0-1) }
      Plate     : Word    ; { Hомеp пластинки в таблице PLATES.TBL;
                              объединен  c комбинацией двух полей GSC :
                               1. КО - классификация объекта ( 0 - 1 )
                               2. ПЭ - полоса и эмульсия ( 0 - 6 )
                              по фоpмуле Plate = KO + ПЭ*2 + Plate_no * 16   }
      PosErr    : Byte    ; { Ошибка положения в десятых долях секунды дуги  }
      MvErr     : Byte    ; { Ошибка величины в 0.01                         }

    End ;



         {  -----------  *  -----------  }



      { КАРТА  HЕБА }
      { =========== }

 AKInfType  =

    Record

      ZoneNo	  : Byte       ;  { Hомеp зоны ( см. Таблицу обсеpватоpий ) }

      DCg         : Integer    ;
      RAh,
      RAm         : Byte       ;

      Day,
      Mon         : Byte       ;
      Year        : Integer    ;

      Tag         : Char       ;

      NBeg        : LongInt    ;  { Hачальная запись в файле кооpдинат }
      RecCount    : Word       ;  { Число записей    в файле кооpдинат }

      XScale,
      YScale,
      XShift,
      YShift      : Double     ;

      MeType  ,	                  { 0 если диаметp и 1 если величина }
      MeTable ,
      MeTblInd	  : Byte       ;

    End;




 AkStarType =
    Record

       N   : Longint ; { Hомеp и флаги для записи в целом           }
       X   : Longint ; { Кооpдинаты (в пpиведенном виде) и их флаги }
       Y   : Longint ;
       E   : Word    ; { Оценка яpкости и ее флаги                  }

    End;

 ConstType = Record
                Ax, Bx, Cx,
                Ay, By, Cy,
                D, E         : Double ;
                MeanMPPM,
                MeanMAcPPM ,
                K0PPM,
                K1PPM,
                K2PPM        : Double ;
                MeanMGSC,
                MeanMAcGSC ,
                K0GSC,
                K1GSC,
                K2GSC        : Double ;
              End ;




    CdcType = Record

		      SDRA    : Integer ;  { SIN DRA   * CONSTDSIN  }
		      SDDEC   : Integer ;  { SIN DDEC  * CONSTDSIN  }
		      MV      : Byte    ;  { ( MV +    3 ) *   10   }
                      Date    : Word    ;  { ( Y  - 1890 ) * 1000    }
               End;




         {  -----------  *  -----------  }


   IRASTYPE =

    Record

      SDRA    : Word    ;  { SIN DRA   * CONSTDSIN         }
      SDDEC   : Word    ;  { SIN DDEC  * CONSTDSIN         }
      MURA    : Integer ;  { TRUNC (NUMIRAS DIV 10 )       }
      MUDEC   : Integer ;  { NUMIRAS MOD 10 + (M1+9)*1000  }
      MV      : Byte    ;  { ( MV+5 )  *      10           }
      SP      : Byte    ;  { SP        *      10           }
      CAT     : Byte    ;  { SIGNS                         }
      NUMSTAR : LongInt ;  { IRSUR                         }
      SAO     : Longint ;  { SAO * 8000 + (M2+9) * 100/2   }
      NRECSP  : Integer ;  { NUMBER REC. IN SPECTR. ARRAY  }

    end;


         {  -----------  *  -----------  }



         KeyType = Record
                      NBEG    : LongInt ;
                   end;


         {  -----------  *  -----------  }


  ObjectInputType = Record
                      Ra      : Single ;
                      Decl    : Single ;
                      Mv      : Byte   ;
                    End ;

  ObjectStringType = String ;


         {  -----------  *  -----------  }



 CatFilesType     = Record
                      PPMFileName        : PathStr ;
                      PPMKeyFileName     : PathStr ;
                      BsFileName         : PathStr ;
                      BsKeyFileName      : PathStr ;
                      HdFileName         : PathStr ;
                      HdKeyFileName      : PathStr ;
                      OkpzFileName       : PathStr ;
                      OkpzKeyFileName    : PathStr ;
                      CdcFileName        : PathStr ;
                      CdcKeyFileName     : PathStr ;
                      GSCFileName        : PathStr ;
                      GSCAddFileName     : PathStr ;
                      GSCKeyFileName     : PathStr ;
                      NLTTFileName       : PathStr ;
                      NLTTKeyFileName    : PathStr ;
                    End;

{
 ConstRecordType  = Record
                      CX0   : SINGLE  ;
                      CY0   : SINGLE  ;
                      NXY   : INTEGER ;
                    End ;
}



Implementation
End.
