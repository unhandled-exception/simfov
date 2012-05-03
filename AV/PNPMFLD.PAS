
{$O+,F+}

Unit PNPMFld ;   { ÇõÅéê áÇÖáÑ  Npm }
                 { ================ }


  InterFace

    Uses  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, Check,
          PFldGrn, Crt, MLib ;


    Procedure NpmFld ;


  Implementation


    Procedure NpmFld ;
   {****************}


    Label EndMemory ;

   Var

         Cat, SdS                  : Byte   ;

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
         P,S, CS, SS,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         DTMU,
         DDeclPm,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         MR, MD, PMX, PMY          : Double ;

         NumRa,
         NumDec,
         NFildRa,
         NFildDec,
         JRa, JDec,
         JStar,
         JNBeg, JNEnd,
         NRa,
         NBeg , NEnd,
         N1, N2                    : LongInt ;

   Begin  { PRO NpmFld }



        FileMode := 0 ;

        Reset  ( NpmFile     ) ;
        Reset  ( NpmKeyFile  ) ;

        IndCat [ CatNpm ].RoDet := Param.RoPpmDet  ;
        {
        If ( Not  B_Det_Cdc )
          Then  DtMu := ( JDate               - JdCat [ CatNpm ] ) / 365.25
          Else  DtMu := ( JdCat [ CatCdcMoz ] - JdCat [ CatNpm ] ) / 365.25 ;
        }
        DtMu := ( JDate - JdCat [ CatNpm ] ) / 365.25 ;

        FldGrn ( CatNpm, DtMu, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;



	For  JDec := 1 To  NUMDec  Do
         Begin  { JDec }

	  DecTEK := DecMIN + ( JDec - 1 ) * STEPRAD;

          NFildDec := TRUNC ( ( DecTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDecFild := SinDecFild [ NFildDec ] ;
          CDecFild := Sqrt ( C10 - SDecFild * SDecFild ) ;


	  For  JRA := 1  To  NUMRA  Do
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
              { ----------------------------------------------- }


	    NBeg :=        TRUNC ( ( DecTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBeg := NBeg + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEnd :=        TRUNC ( ( DecTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEnd := NEnd + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            For  NRA := NBeg  To  NEnd  Do
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

             Seek ( NpmKeyFile , NRA       ) ;
             Read ( NpmKeyFile , KeyRecord ) ;

                 JNBeg := KeyRecord.NBeg     ;

             Read ( NpmKeyFile , KeyRecord ) ;

                 JNEnd := KeyRecord.NBeg - 1 ;


	    If ( JNEnd >= JNBeg )  Then
            Begin { JEnd >= JNBeg }

             NFildRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBeg + 1 ) )
                                              / STEPGR                      ) ;


             SRaFild := SinRaFild [ NFildRA ] ;
             CRaFild := CoSRaFild [ NFildRA ] ;


		{  èêéëåéíê  áÇÖáÑ  Npm  }
                {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

             Seek ( NpmFile , JNBeg - 1 ) ;

	     For  JSTAR := JNBeg  To  JNEnd  Do
             Begin  { JSTAR }

              Read ( NpmFile , NpmRecord) ;

              MV     := NpmRecord.B / C100 - 5.0 ;


              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax ) )  Then
              Begin  { MV <- MVMAX }

               SdRa   := NpmRecord.SdRa  ;
               SdDec  := NpmRecord.SdDec ;

               SdRa   := SdRa  / ConstDSin ;
               SdDec  := SdDec / ConstDSin ;

               CdRa   := Sqrt ( C10 - SdRa  * SdRa  ) ;
               CdDec  := Sqrt ( C10 - SdDec * SdDec ) ;


               Cat    := NpmRecord.Cat ;

               SDS    := Cat Mod 2 ;
                      If ( SDS = 1 )  Then SdRa  := - SdRa  ;

               Cat    := Cat Div 2 ;

               SDS    := Cat Mod 2 ;
                      If ( SDS = 1 )  Then SdDec := - SdDec ;

               Cat    := Cat Div 2 ;

               SRaSt  := SRaFild  * CdRa  + CRaFild  * SdRa  ;
               CRaSt  := CRaFild  * CdRa  - SRaFild  * SdRa  ;

               SDecSt := SDecFild * CdDec + CDecFild * SdDec ;
               CDecSt := CDecFild * CdDec - SDecFild * SdDec ;


	       CdA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SdA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;

	       CRo := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CdA ;
               {
	       SPoz  := CDecSt * SdA ;
	       CPoz  := SDecSt * CDeclOptFld - CDecSt * SDeclOptFld * CdA ;

	       YSt :=   FD * CPoz / CRo ;
	       XSt := - FD * SPoz / CRo ;
               }

               MR := NpmRecord.MuRa  / SekRad * DtMu ;
               MD := NpmRecord.MuDec / SekRad * DtMu ;

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

               If (    ( Abs ( XSt ) < XMax )
                   And ( Abs ( YSt ) < YMax ) )  Then
                 Begin  { XSt, YSt  < X(Y)MAX }
                        { ------------------- }

                   If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                         CBlock :=  NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or (  AllocBlock               )  )  Then
                       Begin

                         With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                       [NumberOfStars Mod ObjectBlockSize] Do
                            Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

			      X	    := XSt ;
			      Y	    := YSt ;

                              Sp    := NpmRecord.BmV + 120 ;
			      M	    := Round ( ( MV + 5 ) * 10 ) ;

			      NRecC := JStar ;
                              {
                              If (     ( B_SURF )
                                   AND ( SH < 0 )
                                   AND ( NOT B_GEOC )  )
                                 Then
                                   NumberOfStars := NumberOfStars - 1 ;
                              }
                            End ;

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

                             MR := FD * NpmRecord.MuRa  / SekRad ;
                             MD := FD * NpmRecord.MuDec / SekRad ;

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


                             If (    ( Abs ( XST ) > 127.4 )
                                  Or ( Abs ( YST ) > 127.4 ) )  Then
                                Begin
                                  XSt := - 128 ;
                                  YSt := - 128 ;
                                End ;

                             PmVect^[NumberOfStars].PmX := Round ( XSt ) ;
                             PmVect^[NumberOfStars].PmY := Round ( YSt ) ;

                           End ;  { B_VectDiagr }

                         If ( IndCat [ CatNpm ].NBeg = -1 )  Then
                              IndCat [ CatNpm ].NBeg := NumberOfStars ;

                         NumberOfStars  :=  NumberOfStars  +   1 ;


                       End   { Å´Æ™ ¢Î§•´•≠ }
                             { ------------ }
                      Else  GOTO EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                              { ---------------- }

                 End ;  { XSt, YSt  < X(Y)MAX }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEnd >= JNBeg }

            End ;  { NRA  }

           End ; { JRA }

         End ; { JDec }

 EndMemory : ;

     If ( IndCat [ CatNpm ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatNpm ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatNpm ].TypeCoord := IdCoord           ;
       End ;

     Close  ( NpmFile     ) ;
     Close  ( NpmKeyFile  ) ;

     FileMode := 2 ;

    End ;  { PRO NpmFld }

End.

