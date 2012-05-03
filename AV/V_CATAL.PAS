
Unit V_Catal;
Interface
Uses Dos;


Type

         BSType = Record { 19 }
                                                                  {  ERR   }
	            SDRA    : Word    ; { SIN DRA   * CONSTDSIN }
		    SDDEC   : Word    ; { SIN DDEC  * CONSTDSIN }
                    MURA    : Integer ; { MURA *CDEC*.6*10**9   } { 0.0003 }
                    MUDEC   : Integer ; { MUDEC*    *.6*10**9   } { 0.0003 }
		    MV      : Byte    ; { ( MV+5 )  *     10    } { 0.05   }
		    SP      : Byte    ; { SP        *     10    }
		    CAT     : Byte    ;
		    NUMSTAR : LongInt ;
                    SAO     : Longint ;

                   End;

         BsSrcType  = Record

                      BS      : Integer ;
                      HD      : Longint ;
                      DM      : Longint ;
                      RA      : Single  ;
                      DEC     : Single  ;
                      MURA    : Single  ;
                      MUDEC   : Single  ;
                      MV      : Integer ;
                      MVCOD   : Char    ;
                      IBMV    : Integer ;
                      IUMB    : Integer ;
                      IRMI    : Integer ;
                      RMICOD  : Char    ;
                      SP      : Integer ;
                      SPECTR  : Array [ 1 .. 20 ] Of Char ;
                      IRSSFL  : Char    ;
                      DMDS    : Single  ;
                      SDCOMP  : Single  ;
                      IDCOMP  : Array [ 1 ..  5 ] Of Char ;
                      NMBCOM  : Integer ;

                    End ;


        BsIkoType = Record
                      Sa, Ca,  Sd  : Integer ; { X * 32000   }
                      Mv           : Byte    ; { (Mv+5) * 10 }
                    End;



         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }

         PPMType = Record { 15 }
                                                                   {  ERR   }
		     SDRA    : Word    ; { SIN DRA   * CONSTDSIN }
		     SDDEC   : Word    ; { SIN DDEC  * CONSTDSIN }
                     MURA    : Integer ; { MURA"     * 3000      } { 0".0003 }
                     MUDEC   : Integer ; { MUDEC"    * 3000      } { 0".0003 }
		     MV      : Byte    ; { ( MV+5 )  *     10    } { 0.05    }
		     SP      : Byte    ; { SP        *     10    }
		     CAT     : Byte    ;
                     PPM     : Longint ; { Number + Frac SdRa, SdDecl }

                   End;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }

        NlttType = Record
                                                                   {  ERR   }
		     SDRA    : Word    ; { SIN DRA   * CONSTDSIN }
		     SDDEC   : Word    ; { SIN DDEC  * CONSTDSIN }
                     MURA    : Integer ; { MURA"     * 3000      } { 0".0003 }
                     MUDEC   : Integer ; { MUDEC"    * 3000      } { 0".0003 }
		     MV      : Integer ; { MV      *     10      } { 0.05    }
		     CAT     : Byte    ;
                     PPM     : Longint ; { Number + Frac SdRa, SdDecl }
                     Sp      : String [  3 ]  ;
                     Name    : String [ 14 ]  ;

                   End;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }


          SaoType = Record { 63 }
                                                                     {  ERR   }
		      SDRA    : Word    ;  { Sin DRA   * CONSTDSIN }
		      SDDEC   : Word    ;  { Sin DDEC  * CONSTDSIN }
                      MuRa    : Integer ;  { MuRa      * .6*10**9  }{0.0003" }
                      MuDec   : Integer ;  { MuDec     * .6*10**9  }{0.0003" }
		      Mv      : Integer ;  { Mv        *       10  }{0.05    }
		      Mp      : Integer ;  { Mp        *       10  }{0.05    }
		      Cat     : Byte    ;
                      Sao     : Longint ;  { Sao Number }
                      Sp      : Byte    ;
                      SpStr   : String [  3 ]  ;
                      DmStr   : String [ 13 ]  ;
                      HDStr   : String [  7 ]  ;
                      GCStr   : String [  5 ]  ;
                      CodeStr : String [ 12 ]  ;

		    End;



         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }

         NpmType = Record
                                                                     {  ERR   }
		      SDRA    : Word    ;  { SIN DRA   * CONSTDSIN }
		      SDDEC   : Word    ;  { SIN DDEC  * CONSTDSIN }
                      MURA    : Single  ;  { MURA"                 }
                      MUDEC   : Single  ;  { MUDEC"                }
		      B       : Byte    ;  { ( B+5   ) *     10    } { 0.05    }
		      BmV     : ShortInt;  { ( B - V ) *     10    }
		      CAT     : Byte    ;
                      Num     : Longint ;  { Number * 10000             }

                   End;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }



    GcvsType   = Record
                                                                     {  ERR   }
		      SDRA    : Word           ;
		      SDDEC   : Word           ;
		      Cat     : Byte           ;
                      NameStr : String [ 16 ]  ;
                      MStr    : String [ 17 ]  ;
                      SpStr   : String [ 17 ]  ;

                 End ;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }



  Gcvs2000Type   = Record
                                                                     {  ERR   }
		      SDRA    : Word           ;
		      SDDEC   : Word           ;
                      PmRa    : Integer        ; { P.M." * 1000       }
                      PmDecl  : Integer        ; { -32001.0 - No P.M. }
		      Cat     : Byte           ;
                      NameStr : String [ 16 ]  ;
                      MStr    : String [ 17 ]  ;
                      SpStr   : String [ 17 ]  ;

                 End ;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }


           (*
           HdType = Record
                                                                   {  ERR   }
		     SDRA   : Word    ;  { SIN DRA   * CONSTDSIN }
		     SDDEC  : Word    ;  { SIN DDEC  * CONSTDSIN }
		     MV     : Byte    ;  { ( MV+5 )  *      10   } { 0.05   }
		     SPECTR : Byte    ;  { SP        *      10   }
                     CAT    : Byte    ;
		     DM     : LongInt ;

		    End;
           *)

           HdType = Record { 32 }

		      SDRa    : Word          ;  { Sin DRa   * ConstDSin   }
		      SDDec   : Word          ;  { Sin DDec  * ConstDSin   }
                      Cat     : Byte          ;
		      Mv      : Integer       ;  { Mv * 100                }
		      Mp      : Integer       ;  { Mp * 100                }
                      Sp      : String [  3 ] ;
                      SpByte  : Byte          ;
                      Num     : Longint       ;  { HD Number               }
                      DM      : String [ 12 ] ;
                      Remarks : Char          ;

		    End;


           HdEType = Record  { 17 }

		     SDRA   : Word     ;  { SIN DRA   * CONSTDSIN        }
		     SDDec  : Word     ;  { SIN DDEC  * CONSTDSIN        }
                     MuRA   : Integer  ;  { MURA"  * 1000                }
                                          { = 32000 - P.M. Not Present   }
                     MuDec  : Integer  ;  { MUDEC" * 1000                }
                                          { ( Ep Coord - 1900 ) * 10     }
		     MV     : Byte     ;  { ( MV+5 )  *      10          }
                     Sp     : String [ 2 ]  ;
		     Cat    : Byte     ;
                     Num    : Longint  ;  { HDE NUMBER * 10 + Ind Mult   }

                     End;



         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }

       A20Type = Record

                   M       : LongInt ; { SCFFFVVVRRR
                                         S: '-' A20  corellate with GSC
                                         C:  0 - OK
                                             1 - Probable Error Magn.
                                         FFF # Plate
                                         VVV Mv*10
                                         RRR Mr*10
                                       }
	           SdRa    : Integer ; { Sin DRa   * ConstDSin  }
		   SDDec   : Integer ; { Sin DDec  * ConstDSin  }


                 End;



       GSCType = Record

                   Class   : Byte    ;
		   Mv      : Byte    ; { Round ( ( Mv   +  4 ) *   10 )  }
	           SdRa    : Integer ; { Sin DRa   * ConstDSin           }
		   SDDec   : Integer ; { Sin DDec  * ConstDSin           }

     { Class :
       ÍÍÍÍÍ
     0 - star
     1 - galaxy
     2 - blend or member of incorrectly resolved blend.
     3 - non-star
     5 - potential artifact
	 (Note that code 1 is used only For a few  hand-entered errata;
	 galaxies successfully processed by the software have a classi-
	 fication of 3 [non-stellar].  Also code 4 is never used.)
     }


                 End;

    GSCAddType = Record

                   NumGsc  : Longint ; { NFild * 10 000 + NSerInFild     }
                   Date    : Word    ; { Round ( ( Year - 70 ) * 1000 )  }
                                       { If Date = 0 -> ( Year = 51.487 )}
                                       {   If CatDir - Gsc1  Then        }
                                       { ( Year - 50 ) * 1000 )          }

                 End ;

         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }



      { Š€’€  H…€ }
      { =========== }

 AKInfType  =

    Record          { 36 Byts }

      ZoneNo	  : Byte       ;  { H®¬¥p §®­ë ( á¬. ’ ¡«¨æã ®¡á¥p¢ â®p¨© ) }

      DCg         : Integer    ;
      RAh,
      RAm         : Byte       ;

      Day,
      Mon         : Byte       ;
      Year        : Integer    ;

      Tag         : Char       ;

      NBeg        : LongInt    ;  { H ç «ì­ ï § ¯¨áì ¢ ä ©«¥ ª®®p¤¨­ â }
      RecCount    : Word       ;  { —¨á«® § ¯¨á¥©    ¢ ä ©«¥ ª®®p¤¨­ â }

      XScale,
      YScale,
      XShift,
      YShift      : Double     ;

      MeType  ,	                  { 0 ¥á«¨ ¤¨ ¬¥âp ¨ 1 ¥á«¨ ¢¥«¨ç¨­  }
      MeTable ,
      MeTblInd	  : Byte       ;

    End;




 AkStarType =
    Record

       N   : Longint ; { H®¬¥p ¨ ä« £¨ ¤«ï § ¯¨á¨ ¢ æ¥«®¬           }
       X   : Longint ; { Š®®p¤¨­ âë (¢ ¯p¨¢¥¤¥­­®¬ ¢¨¤¥) ¨ ¨å ä« £¨ }
       Y   : Longint ;
       E   : Word    ; { æ¥­ª  ïpª®áâ¨ ¨ ¥¥ ä« £¨                  }

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


 ConstAddType = Record
                Ax, Bx, Cx,
                Ay, By, Cy,
                D, E,
                Koma1,
                Koma2,
                Dist ,
                K0Ppm,
                K1Ppm,
                K2Ppm        : Single ;
              End ;



    CdcType = Record { 10 }

      SDRa    : Word    ;  { Sin DRa   * ConstDSin }
      SDDec   : Word    ;  { Sin DDec  * ConstDSin }
      MURa    : Integer ;  { P.M. R.A. in  ArcSec / y * 1000 }
                           { PmRa = 32123 - ­¥â P.M.         }
      MUDec   : Integer ;  { P.M. Decl in  ArcSec / y * 1000 }
                           { ( Mean Ep. AK - 1900 ) * 100 If no det. P.M. }
      Mv      : Byte    ;  { ( Mv + 5.0 ) * 10                            }
      Cat     : Byte    ;  { ( NObsAk      ) * 4 + Signs ( Sin )                                  }
                           { ( NObsAK + 15 ) * 4 + Signs ( Sin ), ¥á«¨  PPM                       }
                           { ( NObsAK + 30 ) * 4 + Signs ( Sin ), ¥á«¨ ª®¬¯. ªp â­®© á¨áâ¥¬ë AK   }
                           { ( NObsAK + 45 ) * 4 + Signs ( Sin ), ¥á«¨ ª®¬¯. ªp â­®© á¨áâ¥¬ë PPM  }
              End;


    HipType  =
     Record

       SDRa       : Word    ; { Sin DRa   * ConstDSin }
       SDDec      : Word    ; { Sin DDec  * ConstDSin }
       PmRa       : Integer ; { ArcSec/y * 1000    -32000 No P.M. }
       PmDecl     : Integer ; { ArcSec/y * 1000    -32000 No P.M. }
       Cat        : Byte    ;
       NSerInFile : LongInt ; { For HIP : 1000000+NSerInFile -> NoCrd }
       Mv         : Integer ; { Mv * 10      -32000 No Mv   }

     End;




   HipAddType  = Record  { 26 }

                   HipNumber    : LongInt       ;

                   BT,                              { * 1000 }
                   VT,                              { * 1000 }
                   BmV,                             { * 1000 }
                   VmI          : Integer       ;   { *  100 }

                   RefFlgColInd,
                   FlgVar,
                   SrcBmV,
                   SrcVmI,
                   SrcSp          : Char           ;

                   Spectr         : String [ 12 ]  ;

                   Par            : Real           ; { Par In ArcSek }

                   MqePar,                           { MAs * 100 }
                   MqePmRA,
                   MqePmDecl       : Integer       ;

                   PmRa,                             { ArcSek }
                   PmDecl          : Real          ;

                   CorrPmRaPmDecl  : Integer       ;

                 End ;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }



       TycAddType = Record

                      PmRa,
                      PmDecl    : Single  ; { ArcSec/Y                    }
                      MqePmRa   : Byte    ; { MAs * 10      -32000 If Not }
                      MqePmDecl : Byte    ; { MAs * 10                    }
                      VT        : Integer ; { Magn * 1000                 }
                      BT        : Integer ; { Magn * 1000                 }
                      MqeVT     : Integer ; { Magn * 1000                 }
                      MqeBT     : Integer ; { Magn * 1000                 }

                    End ;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }


       HicBinType = Record

		      SDRA         : Word    ;  { Sin DRA   * ConstDSin }
		      SDDEC        : Word    ;  { Sin DDEC  * ConstDSin }
                      MuRa         : Integer ;  { MuRa "    * 1000      }
                      MuDec        : Integer ;  { MuDec"    * 1000      }
		      Mv           : Byte    ;  { ( Mv+5 )  *      10   }
		      Cat          : Byte    ;
                      Numb         : LongInt ;  { HicBinNumber          }

                      Comp1   	   : Char    ;
                      Comp2        : Char    ;
                      EpPosAngle   : Word    ;
                      Orbit        : Char    ;
                      Astrom       : Char    ;
                      Hd           : LongInt ;
                      Ids1         : Integer ;
                      SignIds      : Char    ;
                      Ids2         : Integer ;
                      CompIds      : Char    ;
                      Ads          : Integer ;

		    End;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }

       DMType =     Record

                      Num     : LongInt ;
		      SDRA    : Word    ;  { Sin DRA   * ConstDSin }
		      SDDEC   : Word    ;  { Sin DDEC  * ConstDSin }
                      Cat     : Byte    ;
		      Mv      : Byte    ;  { ( Mv+5 )  *      10   }{0.05   }

		    End;

         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }


         KeyType = Record
                      NBeg    : LongInt ;
                   End;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }


  ObjectInputType = Record
                      Ra,
                      Decl    : Double ;
                      Mv      : Byte   ;
                      PmRa,
                      PmDecl  : Single ;
                    End ;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }



  CCDType          = Record

                       X,
                       Y     : Real   ;
                       Diam  : Single ;

                     End ;


         {  ÄÄÄÄÄÄÄÄÄÄÄ  *  ÄÄÄÄÄÄÄÄÄÄÄ  }



 S12              = String [ 12 ] ;

 CatFilesType     = Record
                      HipFileName         : S12 ;
                      HipKeyFileName      : S12 ;
                      HipAddFileName      : S12 ;
                      TycFileName         : S12 ;
                      TycKeyFileName      : S12 ;
                      TycSaiFileName      : S12 ;
                      TycSaiKeyFileName   : S12 ;
                      Tyc_2_FileName      : S12 ;
                      Tyc_2_AddName       : S12 ;
                      Tyc_2_KeyFileName   : S12 ;
                      PPMFileName         : S12 ;
                      PPMKeyFileName      : S12 ;
                      SaoFileName         : S12 ;
                      SaoKeyFileName      : S12 ;
                      NpmFileName         : S12 ;
                      NpmKeyFileName      : S12 ;
                      HdFileName          : S12 ;
                      HdKeyFileName       : S12 ;
                      HdEFileName         : S12 ;
                      HdEKeyFileName      : S12 ;
                      DmFileName          : S12 ;
                      DmKeyFileName       : S12 ;
                      GcvsFileName        : S12 ;
                      GcvsKeyFileName     : S12 ;
                      Gcvs2000FileName    : S12 ;
                      Gcvs2000KeyFileName : S12 ;
                      CdcCatFileName      : S12 ;
                      CdcKeyFileName      : S12 ;
                      NLTTFileName        : S12 ;
                      NLTTKeyFileName     : S12 ;
                    End;



 SatNameFileType = Record

                     NameSat    : String [ 63 ] ;
                     NumberSat  : String [  6 ] ;
                     InternDes  : String [  8 ] ;

                   End ;



Implementation
End.
