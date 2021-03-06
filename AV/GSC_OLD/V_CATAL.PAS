
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
                      NUM     : Longint ;  { ���� * 10000 + H����  }

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

      Source_no : Longint ; { H���p �.�. * 100 000 + ����p * 10 + Mult (0-1) }
      Plate     : Word    ; { H���p ����⨭�� � ⠡��� PLATES.TBL;
                              ��ꥤ����  c �������樥� ���� ����� GSC :
                               1. �� - �����䨪��� ��ꥪ� ( 0 - 1 )
                               2. �� - ����� � ������ ( 0 - 6 )
                              �� �p�㫥 Plate = KO + ��*2 + Plate_no * 16   }
      PosErr    : Byte    ; { �訡�� ��������� � ������� ����� ᥪ㭤� �㣨  }
      MvErr     : Byte    ; { �訡�� ����稭� � 0.01                         }

    End ;



         {  -----------  *  -----------  }



      { �����  H��� }
      { =========== }

 AKInfType  =

    Record

      ZoneNo	  : Byte       ;  { H���p ���� ( �. ������� ���p���p�� ) }

      DCg         : Integer    ;
      RAh,
      RAm         : Byte       ;

      Day,
      Mon         : Byte       ;
      Year        : Integer    ;

      Tag         : Char       ;

      NBeg        : LongInt    ;  { H�砫쭠� ������ � 䠩�� ���p����� }
      RecCount    : Word       ;  { ��᫮ ����ᥩ    � 䠩�� ���p����� }

      XScale,
      YScale,
      XShift,
      YShift      : Double     ;

      MeType  ,	                  { 0 �᫨ ������p � 1 �᫨ ����稭� }
      MeTable ,
      MeTblInd	  : Byte       ;

    End;




 AkStarType =
    Record

       N   : Longint ; { H���p � 䫠�� ��� ����� � 楫��           }
       X   : Longint ; { ���p������ (� �p��������� ����) � �� 䫠�� }
       Y   : Longint ;
       E   : Word    ; { �業�� �p���� � �� 䫠��                  }

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
