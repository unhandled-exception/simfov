
{$O+,F+}


UNIT PIRASFLD ;   { ÇõÅéê áÇÖáÑ  IRAS }
                  { ================= }


  INTERFACE

    USES  PVAR, PVarMenu, V_CATAL, PPREOLD, PMem, PProFld, PFldGrn ;


    PROCEDURE IrasFLD ;


  IMPLEMENTATION


    PROCEDURE IrasFld ;
   {*****************}


    LABEL EndMemory ;

    Var

         Index,
         Mv,
         ADECC,
         SDD,
         RAMIN, RAMax,
         RAMIN1, RAMax1, RAMIN2, RAMax2,
         R0, DRA, DECTEK,
         SRAFILD, CRAFILD, SDECFILD, CDECFILD,
         SDRA, CDRA, SDDEC, CDDEC,
         SRaSt, CRaSt,
         SDecSt, CDecSt,
         XSt, YSt,
         DecMin, DecMax,
         SP, CP,
         SG, CG,
         DTMU,
         DDeclPm,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         FL1, FL2           : Double  ;

         Cat, SdS           : Byte    ;

         Sao,
         NumRa,
         NumDec,
         NFildRa,
         NFildDec,
         JRa, JDec,
         JStar,
         JNBeg, JNEnd,
         NRa,
         NBeg , NEnd,
         IRASRecNo,
         N1, N2             : LongInt ;


     BEGIN  { PRO STARFLD }


        FileMode := 0 ;

        Reset   ( IrasFile    ) ;
        Reset   ( IrasKeyFile ) ;

        IndCat [ CatIRed ].RoDet := Param.RoIrasDet ;

        DTMU := ( JDate - JdIrasCat ) / 365.25 ;



        FldGrn ( CatIRed, DtMu, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;





	FOR  JDEC := 1 TO  NUMDEC  DO
         BEGIN  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;

          NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDECFILD := SinDecFild [ NFILDDEC ] ;
          CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;


	  FOR  JRA := 1  TO  NUMRA  DO
           BEGIN  { JRA }

	    IF ( JRA = 2 )  THEN
              BEGIN { JRA = 2 }
		RAMIN := RAMIN2;
		RAMAX := RAMAX2;
              END  { JRA = 2 }
             ELSE
              BEGIN  { JRA <> 2 }
		RAMIN := RAMIN1;
		RAMAX := RAMAX1;
	      END ;  { JRA <> 2 }


              { ÇõóàëãÖçàÖ çÄóÄãÄ à äéçñÄ àçîéêåÄñàà Ç äÄíÄãéÉÖ }
              { ----------------------------------------------- }


	    NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            FOR  NRA := NBEG  TO  NEND  DO
            BEGIN  { NRA }

             Seek ( IrasKeyFile , NRA       ) ;
             Read ( IrasKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

             Read ( IrasKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;


	    IF ( JNEND >= JNBEG )  THEN
            BEGIN { JEND >= JNBEG }

             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  èêéëåéíê  áÇÖáÑ  Iras  }
                {  =====================  }


             Seek ( IrasFile , JNBEG - 1 ) ;


	     FOR  JSTAR := JNBEG  TO  JNEND  DO
             BEGIN  { JSTAR }

               Read ( IrasFile , IrasRecord) ;


               SDRA   := IrasRecord.SDRA  / CONSTDSIN ;
               SDDEC  := IrasRecord.SDDEC / CONSTDSIN ;

               CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
               CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;


               CAT    := IrasRecord.Cat ;

               SDS    := CAT MOD 2 ;
                      IF ( SDS = 1 )  THEN SDRA  := - SDRA  ;

               CAT    := CAT DIV 2 ;

               SDS    := CAT MOD 2 ;
                      IF ( SDS = 1 )  THEN SDDEC := - SDDEC ;

               CAT    := CAT DIV 2 ;


               SRaSt  := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
               CRaSt  := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

               SDecSt := SDECFILD * CDDEC + CDECFILD * SDDEC ;
               CDecSt := CDECFILD * CDDEC - SDECFILD * SDDEC ;

               {
	       CDA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SDA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;

	       CRO := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CDA ;

	       SPoz  := CDecSt * SDA ;
	       CPoz  := SDecSt * CDeclOptFld - CDecSt * SDeclOptFld * CDA ;

	       YSt :=   FD * CPoz / CRO ;
	       XSt := - FD * SPoz / CRO ;
               }

               XRect :=   CRaSt * CDecSt  ;
               YRect :=   SRaSt * CDecSt  ;
               ZRect :=   SDecSt          ;

               X1    := - XRect * SRaOptFld + YRect * CRaOptFld  ;
               Y1    := - XRect * CRaOptFld - YRect * SRaOptFld  ;
               Z1    :=   ZRect                                  ;

               X2    :=   X1                                     ;
               Y2    :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld    ;
               Z2    := - Y1 * CDeclOptFld + Z1 * SDeclOptFld    ;

               XSt   := - Fd * X2 / Z2  ;
               YSt   :=   Fd * Y2 / Z2  ;


                { èÆ¢ÆpÆ‚ ù™¢ ë®·‚ JdCat -> ù™¢ ë®·‚ JdFld }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               Index :=   XSt ;
               XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
               YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;

                  { é·Ï 'Y' ¢ ØÆ´Ó·• JdFld }



               If ( Not ( NPolFix ) )   Then
                   Begin { ë‚†°®´®ß†Ê®Ô Æ·® Y ¢ ß•≠®‚ }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                     Index := XSt ;
                     XSt :=   XSt  * CPozNp  -  YSt * SPozNp ;
                     YSt :=  Index * SPozNp  +  YSt * CPozNp ;

                   End ;

               {
               If ( BOlValMenu )  Then
                 Begin
                   XSt := XSt + XSt * Frac ( YSt ) ;
                   YSt := YSt + YSt * Frac ( XSt ) ;
                 End ;
               }

               FL1 := ( IrasRecord.MUDEC DIV   10 ) / C1000 - 9.0 ; { 12 mkm. }
               FL2 := ( IrasRecord.SAO   MOD 1000 ) /  50.0 - 9.0 ; { 25 mkm. }

               Mv  := FL1 ;

               If (    ( Abs ( XSt ) < XMax )
                   And ( Abs ( YSt ) < YMax )
                   And (     ( Mv >= MvMin  )
                         And ( Mv <= MvMax  ) ) ) Then
                      Begin  { XSt, YSt  < X(Y)MAX }
                             { ------------------- }

                        IF  ( NumberOfStars mod ObjectBlockSize = 0 )  Then
                              CBlock :=  NumberOfStars Div ObjectBlockSize ;

                        If (    ( BlockAllocFlag [ CBlock ] )
                             Or (  AllocBlock               )  )  Then

                            BEGIN

                             With ObjectPtr[NumberOfStars div ObjectBlockSize]^
                                           [NumberOfStars mod ObjectBlockSize]
                             do
                              begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

			        X   := XST ;
			        Y   := YST ;

                                IF ( IrasRecord.NRECSP Div 4 = 0 )
                                  THEN
                                        Sp := 110
                                  ELSE
                                        Sp := 111 ;

				M   := Round ( ( Mv + 9 ) * 10 ) ;
                                (*
  		                IRASRecNo := LongInt ( IrasRecord.MURA  )  *  10
				           + LongInt ( IrasRecord.MUDEC ) mod 10 ;

			        NRecC    := IRASRecNo * 8 ; { HÆ¨•p ¢ .SRC }
                                *)
			        NRecC    := JStar * 2 ; { HÆ¨•p ¢ .Srt }

                                SAO      := IrasRecord.SAO Div 8000  ;
                                IF ( SAO > 0 )  THEN
                                     NRecC := NRecC + 1 ;

                                {
                                IF (     ( B_SURF )
                                     AND ( SH < 0 )
                                     AND ( NOT B_GEOC )  )
                                  THEN
                                    NumberOfStars := NumberOfStars - 1 ;
                                }
                              end ;

                              If ( IndCat [ CatIRed ].NBEG = -1 )  Then
                                   IndCat [ CatIRed ].NBEG := NumberOfStars ;

                              NumberOfStars  :=  NumberOfStars  +   1 ;


                            END   { Å´Æ™ ¢Î§•´•≠ }
                                  { ------------ }
                          ELSE  GOTO EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                                  { ---------------- }

                      END ;  { XST, YST  < X(Y)MAX }

             END ; { JSTAR }

            END ; { JEND >= JNBEG }

            END ;  { NRA  }

           END ; { JRA }

         END ; { JDEC }

 EndMemory : ;


     If ( IndCat [ CatIRed ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatIRed ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatIRed ].TypeCoord := IdCoord           ;
       End ;

     Close   ( IrasFile     ) ;
     Close   ( IrasKeyFile  ) ;

    END ;  { PRO IrasFld }


END.

