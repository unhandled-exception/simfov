
{$O+,F+}

Unit PPpmFld ;   { ‚› ‡‚…‡„  Ppm }
                 { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


  InterFace

    Uses  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, PFldGrn,
          Crt, MLib ;


    Procedure PpmFld ;


  Implementation


    Procedure PpmFld ;
   {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}


    Label EndMemory ;

   Var

         Cat, SdS, Spectr          : Byte    ;

         Index,
         Mv,
         SDD,
         RaMin, RaMax,
         RaMin1, RaMax1, RaMin2, RaMax2,
         R0, dRa, DecTec,
         SRaFild, CRaFild, SDecFild, CDecFild,
         SdRa, CdRa, SdDec, CdDec,
         XSt, YSt,
         SRaSt, CRaSt,
         SDecSt, CDecSt,
         DecMin, DecMax,
         P, S, CS, SS,
         SP, CP, SG, CG, DtMu,
         dDeclPm,
         ST, CT,
         SDA, CDA,
         SPoz, CPoz,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         MR, MD, PmX, PmY          : Double  ;

         AddRazr,
         NumRA,
         NumDec,
         NFildRa,
         NFildDec,
         JStar,
         JNBeg, JNEnd,
         JRa, JDec,
         NRa,
         NBeg , NEnd,
         N1, N2                    : LongInt ;

     Begin  { PRO PpmFld }



        FileMode := 0 ;

        Reset ( PPMFile    ) ;
        Reset ( PPMKeyFile ) ;


        IndCat [ CatPpm ].RoDet := Param.RoPpmDet  ;
        {
        If ( Not  B_Det_Cdc )
          Then  DtMu := ( JDate               - JdCat [ CatPpm ] ) / 365.25
          Else  DtMu := ( JdCat [ CatCdcMoz ] - JdCat [ CatPpm ] ) / 365.25 ;
        }

        DtMu := ( JDate - JdCat [ CatPpm ] ) / 365.25 ;

        FldGrn ( CatPpm, DtMu, NumRA, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;


	For  JDec := 1 To  NumDec  Do
         Begin  { JDec }

	  DecTec := DecMin + ( JDec - 1 ) * StepRad;

          NFildDec := Trunc ( ( DecTec * RG + StepGr + 90.0 ) / StepGr ) ;
          SDecFild := SinDecFild [ NFildDec ] ;
          CDecFild := Sqrt ( C10 - SDecFild * SDecFild ) ;


	  For  JRA := 1  To  NumRA  Do
           Begin  { JRA }

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

	    If ( JRA = 2 )  Then
              Begin { JRA = 2 }
		RaMin := RaMin2;
		RaMax := RaMax2;
              End  { JRA = 2 }
             Else
              Begin  { JRA <> 2 }
		RaMin := RaMin1;
		RaMax := RaMax1;
	      End ;  { JRA <> 2 }


              { ‚›—ˆ‘‹…ˆ… €—€‹€ ˆ Š–€ ˆ”Œ€–ˆˆ ‚ Š€’€‹ƒ… }
              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


	    NBeg :=        Trunc ( ( DecTec * RG + 90.0   ) / StepGr ) * NRaMax ;
            NBeg := NBeg + Trunc ( ( RaMin  * RG + StepGr ) / StepGr ) -  1     ;

	    NEnd :=        Trunc ( ( DecTec * RG + 90.0   ) / StepGr ) * NRaMax ;
     	    NEnd := NEnd + Trunc ( ( RaMax  * RG + StepGr ) / StepGr ) -  1     ;


            For  NRA := NBeg  To  NEnd  Do
            Begin  { NRA }

            Seek ( PpmKeyFile , NRA       ) ;

            Read ( PpmKeyFile , KeyRecord ) ;
            JNBeg := KeyRecord.NBeg         ;

            Read ( PpmKeyFile , KeyRecord ) ;
            JNEnd := KeyRecord.NBeg - 1     ;


	    If ( JNEnd >= JNBeg )  Then
            Begin { JEnd >= JNBeg }

             NFildRa := Trunc ( ( RaMin  * RG + StepGr * ( NRA - NBeg + 1 ) )
                                              / StepGr                      ) ;

             SRaFild := SinRaFild [ NFildRa ] ;
             CRaFild := CoSRaFild [ NFildRa ] ;

             {  ‘Œ’  ‡‚…‡„  Ppm  }
             {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }

             Seek ( PpmFile , JNBeg - 1 ) ;

	     For  JSTAR := JNBeg  To  JNEnd  Do
             Begin  { JSTAR }

              Read ( PpmFile , PpmRecord) ;

              Spectr := PpmRecord.Sp              ;
              Mv     := PpmRecord.Mv / C100 - 5.0 ;

              If (     ( B_Fot_Sys   )
                   And ( Spectr < 70 ) )  Then
                Mv := Mv + DMv [ Spectr + 1 ] ;


              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax ) )  Then
              Begin  { Mv <- MVMAX }


               AddRazr := PpmRecord.Ppm Div 1000000 ;

               SdRa   := PpmRecord.SdRa  ;
               SdDec  := PpmRecord.SdDec ;

               SdDec  := SdDec + ( AddRazr Mod 30 ) / 30.0 ;
               SdRa   := SdRa  + ( AddRazr Div 30 ) / 30.0 ;

               SdRa   := SdRa  / ConstDSin ;
               SdDec  := SdDec / ConstDSin ;

               CdRa   := Sqrt ( C10 - SdRa  * SdRa  ) ;
               CdDec  := Sqrt ( C10 - SdDec * SdDec ) ;


               Cat    := PpmRecord.Cat ;

               SDS    := Cat Mod 2 ;
               If ( SDS = 1 )  Then
                 SdRa  := - SdRa  ;

               Cat    := Cat Div 2 ;

               SDS    := Cat Mod 2 ;
               If ( SDS = 1 )  Then
                 SdDec := - SdDec ;

               Cat    := Cat Div 2 ;
               If ( Cat Mod 2 = 1 )  Then
                 Spectr := Spectr + 100 ;   { Not Astrometric Star }
                                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

               SRaSt  := SRaFild  * CdRa  + CRaFild  * SdRa  ;
               CRaSt  := CRaFild  * CdRa  - SRaFild  * SdRa  ;

               SDecSt := SDecFild * CdDec + CDecFild * SdDec ;
               CDecSt := CDecFild * CdDec - SDecFild * SdDec ;


	       CdA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SdA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;

	       CRo := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CdA ;

               MR := PpmRecord.MuRa  / 3000.0 / SekRad * DtMu ;
               MD := PpmRecord.MuDec / 3000.0 / SekRad * DtMu ;


               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;

               X1 := - XRect * SRaOptFld + YRect * CRaOptFld ;
               Y1 := - XRect * CRaOptFld - YRect * SRaOptFld ;
               Z1 :=   ZRect                                 ;

               X2 :=   X1                                    ;
               Y2 :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld   ;
               Z2 := - Y1 * CDeclOptFld + Z1 * SDeclOptFld   ;

               XSt := - Fd * X2 / Z2 ;
               YSt :=   Fd * Y2 / Z2 ;


                { ®¢®p®â ª¢ ‘¨áâ JdCat -> ª¢ ‘¨áâ JdFld }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

               Index :=   XSt ;
               XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
               YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;

                  { áì 'Y' ¢ ¯®«îá¥ JdFld }


               If ( Not ( NPolFix ) )   Then
                 Begin { ‘â ¡¨«¨§ æ¨ï ®á¨ Y ¢ §¥­¨â }
                       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
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
                        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                   If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                     CBlock :=  NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or ( AllocBlock                )  )  Then
                     Begin

                       With ObjectPtr [ NumberOfStars Div ObjectBlockSize ]^
                                      [ NumberOfStars Mod ObjectBlockSize ] Do
                         Begin  { ç¥à¥¤­ ï §¢¥§¤  }

                           X     := XSt ;
                           Y     := YSt ;

                           Sp    := Spectr ;
                           M     := Round ( ( Mv + 5 ) * 10 ) ;

                           NRecC := JSTAR ;
                           {
                           If (     ( B_SURF )
                                And ( SH < 0 )
                                And ( NOT B_GEOC )  )
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

                           MR := FD * PpmRecord.MuRa  / 3000.0 / SekRad  ;
                           MD := FD * PpmRecord.MuDec / 3000.0 / SekRad  ;

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

                           XSt := PmX / PmMaxMm * C1270 ;
                           YSt := PmY / PmMaxMm * C1270 ;

                           If (    ( Abs ( XSt ) > 127.4 )
                                Or ( Abs ( YSt ) > 127.4 ) )  Then
                             Begin
                               XSt := - 128 ;
                               YSt := - 128 ;
                             End ;

                           PmVect^[NumberOfStars].PmX := Round ( XSt ) ;
                           PmVect^[NumberOfStars].PmY := Round ( YSt ) ;

                         End ;  { B_VectDiagr }

                       If ( IndCat [ CatPpm ].NBeg = -1 )  Then
                            IndCat [ CatPpm ].NBeg := NumberOfStars ;

                       NumberOfStars  :=  NumberOfStars  +   1 ;


                     End   { «®ª ¢ë¤¥«¥­ }
                           { ÄÄÄÄÄÄÄÄÄÄÄÄ }
                    Else  GOTO EndMemory ;  { ˆáç¥p¯ ­  ¯ ¬ïâì }
                                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                 End ;  { XSt, YSt  < X(Y)MAX }

              End ;  { Mv < MVMAX }

             End ; { JSTAR }

            End ; { JEnd >= JNBeg }

            End ;  { NRA  }

           End ; { JRA }

         End ; { JDec }

 EndMemory : ;

     If ( IndCat [ CatPpm ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatPpm ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatPpm ].TypeCoord := IdCoord           ;
       End ;

     Close ( PPMFile    ) ;
     Close ( PPMKeyFile ) ;

     FileMode := 2 ;

  End ;  { PRO PpmFld }

End.

