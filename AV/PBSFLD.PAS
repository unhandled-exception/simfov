
{$O+,F+}


UNIT PBsFld ;   { ‚› ‡‚…‡„  BS }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


  INTERFACE

    USES  PVAR, PVarMenu, V_CatAL, PPreNew, PMem, PProFld, PFldGrn,
          Crt, MLib ;


    PROCEDURE BsFld ;


  IMPLEMENTATION


    PROCEDURE BsFld ;
   {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


    LABEL EndMemory ;


    Var

         Spectr             : Byte       ;
         Cat, SdS           : Byte       ;

         Index,
         Mv,
         ADecC,
         SDD,
         RaMin, RaMax,
         RaMin1, RaMax1, RaMin2, RaMax2,
         R0, dRa, DecTek,
         SRaFild, CRaFild, SDecFild, CDecFild,
         SdRa, CdRa, SdDec, CdDec,
         XSt, YSt,
         SRaSt, CRaSt,
         SDecSt, CDecSt,
         DecMin, DecMax,
         P,S, CS, SS,
         DtMu,
         SdA, CdA,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         MR, MD             : Double     ;

         BsSrcRecord        : BSSrcType  ;

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


     Begin  { PRO BsFld }

        FileMode := 0 ;

        Assign ( BsFile    , PaRamDir.BsDir + '\' + 'Bs.Srt' ) ;
        Reset  ( BsFile                                      ) ;

        Assign ( BsKeyFile , PaRamDir.BsDir + '\' + 'Bs.Grn' ) ;
        Reset  ( BsKeyFile                                   ) ;


        IndCat [ CatBs ].RoDet := PaRam.RoBsDet  ;
        {
        If ( Not  B_Det_Cdc )
          Then  DtMu := ( JDate               - JdCat [ CatBs ] ) / 365.25
          Else  DtMu := ( JdCat [ CatCdcMoz ] - JdCat [ CatBs ] ) / 365.25 ;
        }

        DtMu := ( JDate - JdCat [ CatBs ] ) / 365.25 ;


        FldGrn ( CatBs, DtMu, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;




	For  JDec := 1 To  NumDec  Do
         Begin  { JDec }

	  DecTek := DecMin + ( JDec - 1 ) * STEPRaD;

          NFildDec := Trunc ( ( DecTek * RG + StepGr + 90.0 ) / StepGr ) ;
          SDecFild := SinDecFild [ NFildDec ] ;
          CDecFild := Sqrt ( C10 - SDecFild * SDecFild ) ;


	  For  JRa := 1  To  NumRa  Do
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

	    If ( JRa = 2 )
             Then
              Begin { JRa = 2 }
		RaMin := RaMin2;
		RaMax := RaMax2;
              End  { JRa = 2 }
             Else
              Begin  { JRa <> 2 }
		RaMin := RaMin1;
		RaMax := RaMax1;
	      End ;  { JRa <> 2 }


              { ‚›—ˆ‘‹…ˆ… €—€‹€ ˆ Š–€ ˆ”Œ€–ˆˆ ‚ Š€’€‹ƒ… }
              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


	    NBeg :=        Trunc ( ( DecTek * RG + 90.0   ) / StepGr ) * NRaMax ;
            NBeg := NBeg + Trunc ( ( RaMin  * RG + StepGr ) / StepGr ) -  1     ;

	    NEnd :=        Trunc ( ( DecTek * RG + 90.0   ) / StepGr ) * NRaMax ;
     	    NEnd := NEnd + Trunc ( ( RaMax  * RG + StepGr ) / StepGr ) -  1     ;


            For  NRa := NBeg  To  NEnd  Do
            Begin  { NRa }

            Seek ( BsKeyFile , NRa       ) ;
            Read ( BsKeyFile , KeyRecord ) ;

                 JNBeg := KeyRecord.NBeg     ;

            Read ( BsKeyFile , KeyRecord ) ;

                 JNEnd := KeyRecord.NBeg - 1 ;


            If ( JNEnd >= JNBeg )  Then
            Begin { JEnd >= JNBeg }

             NFildRa := Trunc ( ( RaMin  * RG + StepGr * ( NRa - NBeg + 1 ) )
                                              / StepGr                      ) ;


             SRaFild := SinRaFild [ NFildRa ] ;
             CRaFild := CoSRaFild [ NFildRa ] ;




		{  ‘Œ’  ‡‚…‡„  BS  }
                {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }

             Seek ( BsFile , JNBeg - 1 ) ;


	     For  JStar := JNBeg  To  JNEnd  Do
             Begin  { JStar }

              Read ( BsFile , BsRecord) ;

              Spectr := BsRecord.SP              ;
              Mv     := BsRecord.Mv / C100 - 5.0 ;

              If ( B_FOT_SYS And ( Spectr < 70 ) )  Then
                Mv := Mv + DMv [ Spectr + 1 ] ;


              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax ) )  Then
              Begin  { Mv <= MVMax }

               SdRa   := BsRecord.SdRa  / ConstDSin ;
               SdDec  := BsRecord.SdDec / ConstDSin ;

               CdRa   := Sqrt ( C10 - SdRa  * SdRa  ) ;
               CdDec  := Sqrt ( C10 - SdDec * SdDec ) ;

               Cat    := BsRecord.Cat ;
               SDS    := Cat Mod 2 ;
               If ( SDS = 1 )  Then
                 SdRa  := - SdRa  ;
               Cat    := Cat Div 2 ;
               SDS    := Cat Mod 2 ;
               If ( SDS = 1 )  Then
                 SdDec := - SdDec ;

               SRaSt     := SRaFild  * CdRa  + CRaFild  * SdRa  ;
               CRaSt     := CRaFild  * CdRa  - SRaFild  * SdRa  ;

               SDecSt     := SDecFild * CdDec + CDecFild * SdDec ;
               CDecSt     := CDecFild * CdDec - SDecFild * SdDec ;


	       CdA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SdA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;

	       CRo := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CdA ;


               MR := BsRecord.MuRa  / 0.6 / 1000000000.0 * DtMu ;
               MD := BsRecord.MuDec / 0.6 / 1000000000.0 * DtMu ;


               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;

               X1 := - XRect * SRaOptFld + YRect * CRaOptFld ;
               Y1 := - XRect * CRaOptFld - YRect * SRaOptFld ;
               Z1 :=   ZRect                                 ;

               X2 :=   X1                                      ;
               Y2 :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld     ;
               Z2 := - Y1 * CDeclOptFld + Z1 * SDeclOptFld     ;

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


               If (    ( Abs ( XSt ) < XMax )
                   And ( Abs ( YSt ) < YMax ) )  Then
                 Begin  { XSt, YSt  < X(Y)Max }

                   If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                     CBlock := NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or ( AllocBlock                )  )  Then
                       Begin

                         With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                       [NumberOfStars Mod ObjectBlockSize] Do
                            Begin  { ç¥à¥¤­ ï §¢¥§¤  }

			      X	      := XSt ;
			      Y	      := YSt ;

                              Sp      := Spectr                    ;
			      M	      := Round ( ( Mv + 5 ) * 10 ) ;

			      NRecC   := JStar ;

                            End ;

                              If ( IndCat [ CatBs ].NBeg = -1 )  Then
                                   IndCat [ CatBs ].NBeg := NumberOfStars ;

                              NumberOfStars  :=  NumberOfStars  +   1 ;


                       End   { «®ª ¢ë¤¥«¥­ }
                             { ÄÄÄÄÄÄÄÄÄÄÄÄ }
                      Else
                        GoTo EndMemory ;  { ˆáç¥p¯ ­  ¯ ¬ïâì }
                                          { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                 End ;  { XSt, YSt  < X(Y)Max }

              End ;  { Mv < MVMax }

             End ; { JStar }

            End ; { JEnd >= JNBeg }

            End ;  { NRa  }

           End ; { JRa }

         End ; { JDec }

     EndMemory : ;

     Close ( BsFile    ) ;
     Close ( BsKeyFile ) ;


     If ( IndCat [ CatBs ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatBs ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatBs ].TypeCoord := IdCoord           ;
       End ;

     FileMode := 2 ;


    End ;  { PRO BsFld }

End.
