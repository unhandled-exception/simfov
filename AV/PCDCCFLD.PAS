
{$O+,F+}

Unit PCdcCFld ;   { ÇõÅéê áÇÖáÑ  ä†‚†´Æ£† AK }
                  { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


  Interface

    Uses  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, SHELL_X,
          PFldGrn, PBinObj, Crt, MLib ;


    Procedure CdcCatFld ;


  Implementation

  Var

         Cat, SdS           : Byte    ;
         Spectr             : Byte    ;

         X, Y,
         SP, CP,
         SG, CG,
         P,S, CS, SS,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         DTMU,
         DDeclPm,
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
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         DecMin, DecMax,
         Index              : Double  ;

         NumRa,
         NumDec,
         NFildRa,
         NFildDec,
         JRa, JDec,
         JStar,
         JNBeg, JNEnd,
         NRa,
         NBeg , NEnd,
         N1, N2             : LongInt ;





    Procedure CdcCatFld ;
   {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}


    Label  EndMemory ;


   Var

        DelPM,
        PpmStar                      : Boolean ;

        Sp0                          : Byte    ;

        MR, MD, PMX, PMY,
        RaPol, DeclPol,
        SRaPol, SDeclPol,
        CRaPol, CDeclPol,
        SPozPrec, CPozPrec,
        SG, CG                       : Double  ;

        AkDate                       : LongInt ;


     Begin  { PRO CdcCatFLD }


        IndCat [ CatCdc ].RoDet := Param.RoCdcDet  ;

        DtMu := ( JDate - JdCat [ CatCdc ] ) / 365.25 ;



        FldGrn ( CatCdc, DtMu, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;



	FOR  JDEC := 1 TO  NUMDEC  DO
         Begin  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;

          NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDecFild := SinDecFild [ NFILDDEC ] ;
          CDecFild := SQRT ( C10 - SDecFild * SDecFild ) ;


	  FOR  JRA := 1  TO  NUMRA  DO
           Begin  { JRA }

	    If ( JRA = 2 )  Then
              Begin { JRA = 2 }
		RAMIN := RAMIN2;
		RAMAX := RAMAX2;
              End  { JRA = 2 }
             Else
              Begin  { JRA <> 2 }
		RAMIN := RAMIN1;
		RAMAX := RAMAX1;
	      End ;  { JRA <> 2 }


              { ÇõóàëãÖçàÖ çÄóÄãÄ à äéçñÄ àçîéêåÄñàà Ç äÄíÄãéÉÖ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


	    NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            FOR  NRA := NBEG  TO  NEND  DO
            Begin  { NRA }

            If ( KeyPressed )  Then
              Begin

                KeyExist := True    ;
                UserKey  := GetKey  ;
                UngetCh ( UserKey ) ;

                If ( UserKey = EscKey )  Then
                  Begin
                    EndStars := True ;
                    GoTo EndMemory ;
                  End ;
              End ;

             Seek ( CdcKeyFile , NRA       ) ;
             Read ( CdcKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

             Read ( CdcKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;


	    If ( JNEND >= JNBEG )  Then

            Begin { JEND >= JNBEG }

             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRaFild := SinRaFild [ NFILDRA ] ;
             CRaFild := CosRaFild [ NFILDRA ] ;




		{  èêéëåéíê  áÇÖáÑ  CdcCat  }
                {  ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹  }

             Seek ( CdcFile , JNBEG - 1 ) ;

	     FOR  JSTAR := JNBEG  TO  JNEND  DO
             Begin  { JSTAR }

              Read ( CdcFile , CdcRecord ) ;

              AkDate :=  JStar ;

              MV     := CdcRecord.MV / 10.0 - 5.0 ;

              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax ) )  Then
              Begin  { MV <- MVMAX }

               SdRa   := CdcRecord.SdRa  / ConstDSin ;
               SdDec  := CdcRecord.SdDec / ConstDSin ;

               CdRa   := SQRT ( C10 - SdRa  * SdRa  ) ;
               CdDec  := SQRT ( C10 - SdDec * SdDec ) ;

               CAT    := CdcRecord.Cat ;

               If ( ( CAT Mod 2 ) = 1 )  Then SdRa  := - SdRa  ;

               CAT    := CAT Div 2 ;
               If ( ( CAT Mod 2 ) = 1 )  Then SdDec := - SdDec ;

               SRaSt  := SRaFild  * CdRa   +  CRaFild  * SdRa  ;
               CRaSt  := CRaFild  * CdRa   -  SRaFild  * SdRa  ;

               SDecSt := SDecFild * CdDec  +  CDecFild * SdDec ;
               CDecSt := CDecFild * CdDec  -  SDecFild * SdDec ;


	       CDA := CRaSt       * CRaOptFld  +  SRaSt * SRaOptFld          ;
	       CRO := SDeclOptFld * SDecSt     +  CDeclOptFld * CDecSt * CDA ;


	       SDA   := SRaSt * CRaOptFld - CRaSt * SRaOptFld;
               {
	       SPoz  := CDecSt * SDA ;
	       CPoz  := SDecSt * CDeclOptFld - CDecSt * SDeclOptFld * CDA ;

	       XSt := - FD * SPoz / CRO ;
	       YSt :=   FD * CPoz / CRO ;
               }


               If ( CdcRecord.MuRa <> 32123 )
                 Then
                   Begin  { Ö·‚Ï  P.M. }
                     MR := CdcRecord.MURA  / 206264806.247 * DtMu ;
                     MD := CdcRecord.MUDEC / 206264806.247 * DtMu ;
                   End
                 Else
                   Begin
                     Mr := 0.0 ;
                     Md := 0.0 ;
                   End ;

               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;

               X1 := - XRect * SRaOptFld + YRect * CRaOptFld ;
               Y1 := - XRect * CRaOptFld - YRect * SRaOptFld ;
               Z1 :=   ZRect                       ;

               X2 :=   X1                          ;
               Y2 :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld     ;
               Z2 := - Y1 * CDeclOptFld + Z1 * SDeclOptFld     ;

               XSt := - Fd * X2 / Z2 ;
               YSt :=   Fd * Y2 / Z2 ;



               If ( CdcRecord.MuRa <> 32123 )  Then
                   Begin  { Ö·‚Ï  P.M. }

                     Spectr := 20 ;

                     MR := FD * CdcRecord.MURA  / 206264806.247 ;
                     MD := FD * CdcRecord.MUDEC / 206264806.247 ;

                   End    { Ö·‚Ï  P.M. }
                 Else
                   Begin  { H•‚  P.M. }

                     Spectr := NotPmAc ;

                     MR := 0.0 ;
                     MD := 0.0 ;

                   End ;




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
               (* *)
               If (     ( B_Det_Imp )
                    And ( B_GSC Or B_A20 )  )  Then
                 Begin { H• Æ·‚†¢´Ô•¨ * °•ß P.M. Øp® ≠†´®Á®® GSC ®´® A20 }
                   If (  Spectr Mod 100 = NotPmAc )   Then
                     XSt := XMax * C20 ;  { H•‚ P.M. }
                 End ;
               (* *)

               If (     (    ( B_Object_Tracks   )
                          Or ( B_VectDiagr       )
                          Or (     ( B_Det_Imp )
                               And ( B_Gsc     ) )
                          Or ( B_Inport_Ccd      )  )
                    And ( Spectr Mod 100 = NotPmAc  )  )  Then
                  XSt := XMax * C20 ;  { H•‚ P.M. Øp® Tracks or VectDiagr }
                                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


               Sp0  := CdcRecord.Cat Div 4 ;
               If (    ( ( Sp0 Div 15 ) = 1 )
                    Or ( ( Sp0 Div 15 ) = 3 ) )
                  Then
                    Begin
                      {
                      PpmStar := True ;
                      }
                      Spectr  := Spectr + 100 ;  { èp®ß≠†™ PPM }
                    End
                  Else
                    Begin
                      {
                      PpmStar := False ;
                      }
                    End ;

               {
               If ( Not PpmStar )  Then
               XSt := XMax * C20 ;
               }

               If (    ( Abs ( XSt ) < XMax )
                   And ( Abs ( YSt ) < YMax ) )  Then
                 Begin  { XSt, YSt  < X(Y)MAX }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                   If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                         CBlock :=  NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or (  AllocBlock               )  )  Then
                       Begin

                         With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                       [NumberOfStars Mod ObjectBlockSize] do
                            Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

			      X	      := XSt ;
			      Y	      := YSt ;

                              Sp0     := Sp0 Mod 15 ;
                              If ( Sp0 > 9 )  Then
                                Sp0 := 9 ;

                              Sp      := Sp0 + Spectr ;
			      M	      := Round ( ( MV + 5 ) * 10 ) ;

			      NRecC   := AkDate ;

                              {
                              If (     ( B_SURF )
                                   And ( SH < 0 )
                                   And ( NOT B_GEOC )  )
                                 Then
                                   NumberOfStars := NumberOfStars - 1 ;
                              }
                            End ;


                         DelPM := False ;

                         If ( B_VectDiagr ) Then
                           Begin

                             XRect := CRaSt * CDecSt  ;
                             YRect := SRaSt * CDecSt  ;
                             ZRect := SDecSt          ;


                             X1  := - XRect * SRaOptFld
                                    + YRect * CRaOptFld ;
                             Y1  := - XRect * CRaOptFld
                                    - YRect * SRaOptFld ;
                             Z1  :=   ZRect             ;


                             X2  :=   X1                ;
                             Y2  :=   Y1 * SDeclOptFld
                                    + Z1 * CDeclOptFld  ;
                             Z2  := - Y1 * CDeclOptFld
                                    + Z1 * SDeclOptFld  ;


                             XSt := - Fd * X2 / Z2 ;
                             YSt :=   Fd * Y2 / Z2 ;


                             If ( ( C10 - CRo ) < 1.0E-9 )
                               Then
                                 Begin
                                   PmX  := - MR ;
                                   PmY  :=   MD ;
                                 End
                               Else
                                 Begin

                                   S    :=    Sqrt ( Sqr ( XSt )  +  Sqr ( YSt ) ) ;
                                   SP   :=    YSt / S ;
                                   CP   :=  - XSt / S ;

                                   SS   :=   Sqrt ( C10 - CRo * CRo ) ;
                                   SPoz :=   CDeclOptFld * ( - SdA ) / SS ;
                                   CPoz := ( SDeclOptFld * CDecSt -
                                             CDeclOptFld * SDecSt * CdA ) / SS ;

                                   SG   := SPoz * CP + CPoz * SP ;
                                   CG   := CPoz * CP - SPoz * SP ;

                                   PmX  :=  MR * SG  +  MD * CG  ;
                                   PmY  :=  MR * CG  -  MD * SG  ;

                                 End ;

                             XSt := PMX / PmMaxMm * C1270 ;
                             YSt := PMY / PmMaxMm * C1270 ;
                             (*
                             { èÆ¢ÆpÆ‚ ù™¢ ë®·‚ JdCat -> ù™¢ ë®·‚ JdFld }
                             Index :=   XSt ;
                             XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
                             YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;


                             If ( Not ( NPolFix ) )  Then
                               Begin { ë‚†°®´®ß†Ê®Ô Æ·® Y ¢ ß•≠®‚ }
                                     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                                 Index := XSt ;

                                 XSt :=   XSt  * CPozNp  -  YSt * SPozNp ;
                                 YSt :=  Index * SPozNp  +  YSt * CPozNp ;

                               End ;
                             *)


                             If (    ( Abs ( XSt ) > 127.49 )
                                  Or ( Abs ( YSt ) > 127.49 ) )
                               Then
                                 Begin
                                   DelPM := True ;
                                 End
                               Else
                                 Begin
                                   PmVect^[ NumberOfStars ].PmX := Round ( XSt ) ;
                                   PmVect^[ NumberOfStars ].PmY := Round ( YSt ) ;
                                 End ;

                           End ;  { B_VectDiagr }


                          If ( IndCat [ CatCdc ].NBEG = -1 )  Then
                               IndCat [ CatCdc ].NBEG := NumberOfStars ;

                          If ( Not DelPM )  Then
                            Inc ( NumberOfStars )


                       End   { Å´Æ™ ¢Î§•´•≠ }
                             { ƒƒƒƒƒƒƒƒƒƒƒƒ }
                      Else  GoTo EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                 End ;  { XSt, YSt  < X(Y)MAX }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEND >= JNBEG }

            End ;  { NRA  }

           End ; { JRA }

         End ; { JDEC }

     EndMemory : ;

     If ( IndCat [ CatCdc ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatCdc ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatCdc ].TypeCoord := IdCoord           ;
          {
          DelBinStars ( CatCdc ) ;
          }
       End ;

    End ;  { PRO CdcFLD }

End.

