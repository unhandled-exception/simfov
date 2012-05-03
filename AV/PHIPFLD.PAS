
{$O+,F+}

Unit PHipFld ;   { ÇõÅéê áÇÖáÑ  ä†‚†´Æ£† Hip+Pm }
                 { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


  Interface

    Uses  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, SHELL_X,
          PFldGrn, Crt, MLib ;


    Procedure HipFld ;


  Implementation

  Var

         Cat, SdS           : Byte    ;
         Spectr             : Byte    ;

         Ir                 : Integer ;

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


         R,
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



    Procedure HipFld ;
   {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}


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



     Begin  { PRO HipCatFLD }



        FileMode := 0 ;

        Reset ( HipFile    ) ;
        Reset ( HipKeyFile ) ;

        If ( B_Hip_Add )  Then
          Reset ( HipAddFile ) ;

        IndCat [ CatHip ].RoDet := Param.RoPpmDet  ;

        DtMu := ( JDate - JdCat [ CatHip ] ) / 365.25 ;
        DtMu := DtMu + 8.75;



        FldGrn ( CatHip, DtMu, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;




	For  JDec := 1 To  NUMDEC  Do
         Begin  { JDec }

	  DECTEK := DECMIN + ( JDec - 1 ) * STEPRAD;

          NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDecFild := SinDecFild [ NFILDDEC ] ;
          CDecFild := SQRT ( C10 - SDecFild * SDecFild ) ;


	  For  JRa := 1  To  NUMRA  Do
           Begin  { JRa }

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

	    If ( JRa = 2 )  Then
              Begin { JRa = 2 }
		RAMIN := RAMIN2;
		RAMAX := RAMAX2;
              End  { JRa = 2 }
             Else
              Begin  { JRa <> 2 }
		RAMIN := RAMIN1;
		RAMAX := RAMAX1;
	      End ;  { JRa <> 2 }


              { ÇõóàëãÖçàÖ çÄóÄãÄ à äéçñÄ àçîéêåÄñàà Ç äÄíÄãéÉÖ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


	    NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            For  NRa := NBEG  To  NEND  Do
            Begin  { NRa }

             Seek ( HipKeyFile , NRa       ) ;
             Read ( HipKeyFile , KeyRecord ) ;

                 JNBeg := KeyRecord.NBEG     ;

             Read ( HipKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;


	    If ( JNEND >= JNBeg )  Then

            Begin { JNEnd >= JNBeg }

             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRa - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRaFild := SinRaFild [ NFILDRA ] ;
             CRaFild := CosRaFild [ NFILDRA ] ;




		{  èêéëåéíê  áÇÖáÑ  HipCat  }
                {  ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹  }

             Seek ( HipFile , JNBeg - 1 ) ;
             If ( B_Hip_Add )  Then
               Seek ( HipAddFile , JNBeg - 1 ) ;

	     For  JStar := JNBeg  To  JNEND  Do
             Begin  { JStar }

              Read ( HipFile , HipRecord ) ;

              If ( B_Hip_Add )  Then
                Read ( HipAddFile , HipAddRecord ) ;


              Mv := HipRecord.Mv / C100 ;

              If ( Mv > C1000 )  Then
                Mv := Mv - C1000 ;

              If ( HipRecord.Mv = -32000 )  Then
                Mv := 10.0 ;

              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax ) )  Then
              Begin  { Mv <- MvMax }

               SdRa   := HipRecord.SdRa  / ConstDSin ;
               SdDec  := HipRecord.SdDec / ConstDSin ;

               CdRa   := SQRT ( C10 - SdRa  * SdRa  ) ;
               CdDec  := SQRT ( C10 - SdDec * SdDec ) ;

               CAT    := HipRecord.Cat ;

               SDS    := CAT Mod 2 ;
               If ( SDS = 1 )  Then
                 SdRa  := - SdRa  ;

               CAT    := CAT Div 2 ;

               SDS    := CAT Mod 2 ;
               If ( SDS = 1 )  Then
                 SdDec := - SdDec ;


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


               If ( HipRecord.PmRa > -32000 )
                 Then
                   Begin  { Ö·‚Ï  P.M. }
                     MR := HipRecord.PmRa   / C10000 / SekRad * DtMu ;
                     MD := HipRecord.PmDecl / C10000 / SekRad * DtMu ;
                     {
                     MR := HipRecord.MURA  / 206264806.247 * DtMu ;
                     MD := HipRecord.MUDEC / 206264806.247 * DtMu ;
                     }
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



               If ( HipRecord.PmRa > -32000 )  Then
                   Begin  { Ö·‚Ï  P.M. }

                     Spectr := 40 ;

                     MR := Fd * HipRecord.PmRa   / C10000 / SekRad  ;
                     MD := Fd * HipRecord.PmDecl / C10000 / SekRad  ;

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
               (*
               If (  Spectr Mod 100 = NotPmAc )   Then
                  XSt := XMax * C20 ;  { H•‚ P.M. }
                                       { ƒƒƒƒƒƒƒƒ }
               *)

               If (     (    ( B_Object_Tracks )
                          Or ( B_VectDiagr     )   )
                    And ( Spectr Mod 100 = NotPmAc )  )  Then
                  XSt := XMax * C20 ;  { H•‚ P.M. Øp® Tracks or VectDiagr }
                                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


               Sp0  := HipRecord.Cat Div 4 ;
               If (    ( ( Sp0 Div 15 ) = 1 )
                    Or ( ( Sp0 Div 15 ) = 3 ) )
                  Then
                    Begin
                      PpmStar := True ;
                      Spectr  := Spectr + 100 ;
                    End
                  Else
                    Begin
                      PpmStar := False ;
                    End ;


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
                                       [NumberOfStars Mod ObjectBlockSize] Do
                            Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

			      X	      := XSt ;
			      Y	      := YSt ;

                              Sp0     := Sp0 Mod 15 ;
                              If ( Sp0 > 9 )  Then
                                Sp0 := 9 ;



                              { ñ¢•‚ Øp® ≠†´®Á®® B-V }
                              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                              If ( B_Hip_Add )  Then
                                Begin

                                  Spectr :=  90 ;

                                  If (    ( HipAddRecord.BmV <> -32000        )
                                       Or (     ( HipAddRecord.BT <> -32000 )
                                            And ( HipAddRecord.VT <> -32000 ) ) )  Then
                                    Begin

                                      If ( HipAddRecord.BmV <> -32000 )
                                        Then  R :=   HipAddRecord.BmV / C10000
                                        Else  R := (   HipAddRecord.BT
                                                     - HipAddRecord.VT ) / C10000 ;

                                      Ir := Round ( R / 0.4 ) + 2 ;

                                      If ( Ir < 0 )  Then
                                        Ir := 0 ;

                                      If ( Ir > 6 )  Then
                                        Ir := 6 ;

                                      Spectr := Ir * 10 ;

                                    End ;


                                End ;

                             If Spectr = 90 Then
                               R := 0.0 ;


                              Sp      := Sp0 + Spectr ;
			      M	      := Round ( ( Mv + 5 ) * 10 ) ;

			      NRecC   := JStar ;

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


                          If ( IndCat [ CatHip ].NBEG = -1 )  Then
                               IndCat [ CatHip ].NBEG := NumberOfStars ;

                          If ( Not DelPM )  Then
                            Inc ( NumberOfStars )


                       End   { Å´Æ™ ¢Î§•´•≠ }
                             { ƒƒƒƒƒƒƒƒƒƒƒƒ }
                      Else  GoTo EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                 End ;  { XSt, YSt  < X(Y)MAX }

              End ;  { Mv < MvMax }

             End ; { JStar }

            End ; { JNEnd >= JNBeg }

            End ;  { NRa  }

           End ; { JRa }

         End ; { JDec }

     EndMemory : ;

     If ( IndCat [ CatHip ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatHip ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatHip ].TypeCoord := IdCoord           ;

       End ;


     Close ( HipFile    ) ;
     Close ( HipKeyFile ) ;

     If ( B_Hip_Add )  Then
       Close ( HipAddFile ) ;


     FileMode := 2 ;



    End ;  { PRO HipFLD }

End.

