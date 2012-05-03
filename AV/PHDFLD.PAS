
{$O+,F+}

Unit PHdFld ;     { ÇõÅéê áÇÖáÑ  H D }
                  { ================ }


  InterFace



    Procedure HdFld ;


  Implementation

    Uses  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, PFldGrn,
          Crt, MLib ;

    Procedure HdFld ;
   {****************}


    Label EndMemory ;

    Var

         HdKeyRecord   :          KeyType    ;

         HdKeyFile     : File Of KeyType     ;
         HdEKeyFile    : File Of KeyType     ;

         SpStr         : String [ 3 ] ;

         Index,
         Mv,
         ADECC,
         SDD,
         RAMIN, RAMax,
         RAMIN1, RAMax1,
         RAMIN2, RAMax2,
         R0, DRA, DECTEK,
         SRAFILD, CRAFILD,
         SDECFILD, CDECFILD,
         SDRA, CDRA,
         SDDEC, CDDEC,
         XSt, YSt,
         SRaSt, CRaSt,
         SDecSt, CDecSt,
         DecMin, DecMax,
         SP, CP,
         SG, CG,
         DTMU,
         DDeclPm,
         P,S, CS, SS,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         Mr, Md                             : Double ;

         Spectr,
         Cat, SdS                           : Byte   ;

         NumRa,
         NumDec,
         NFildRa,
         NFildDec,
         JRa, JDec,
         JStar,
         JNBeg, JNEnd,
         NRa,
         NBeg , NEnd,
         N1, N2                             : LongInt ;



  Begin  { PRO STARFLD }



    FileMode := 0 ;

    Assign  ( HdFile    , ParamDir.HdDir + '\' + CatFile.HdFileName    ) ;
    Reset   ( HdFile                                                   ) ;

    Assign  ( HdKeyFile , ParamDir.HdDir + '\' + CatFile.HdKeyFileName ) ;
    Reset   ( HdKeyFile                                                ) ;


    IndCat [ CatHd ].RoDet := Param.RoHdDet ;

    DtMu := ( JDate - JdCat [ CatHd ] ) / 365.25 ;




    FldGrn ( CatHd, DtMu, NumRa, NumDec,
             DecMin, DecMax,
             RaMin1, RaMax1, RaMin2, RaMax2  ) ;




    For  JDEC := 1 To  NUMDEC  Do
      Begin  { JDEC }

        DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;

        NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
        SDECFILD := SinDecFild [ NFILDDEC ] ;
        CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;


	For  JRA := 1  To  NUMRA  Do
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

	    If ( JRA = 2 )
              Then
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


	    NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            For  NRA := NBEG  To  NEND  Do
              Begin  { NRA }

                Seek ( HdKeyFile , NRA       ) ;
                Read ( HdKeyFile , KeyRecord ) ;

                JNBEG := KeyRecord.NBEG     ;

                Read ( HdKeyFile , KeyRecord ) ;

                JNEND := KeyRecord.NBEG - 1 ;


	        If ( JNEND >= JNBEG )  Then
                  Begin { JEND >= JNBEG }

                    NFILDRA := TRUNC ( (  RAMIN  * RG
                                        + STEPGR * ( NRA - NBEG + 1 ) )
                                        / STEPGR                      ) ;

                    SRAFILD := SinRaFild [ NFILDRA ] ;
                    CRAFILD := CosRaFild [ NFILDRA ] ;




                    {  èêéëåéíê  áÇÖáÑ  Hd  }
                    {  ====================  }


                    Seek ( HdFile , JNBEG - 1 ) ;


	            For  JSTAR := JNBEG  To  JNEND  Do
                      Begin  { JSTAR }

                        Read ( HdFile , HdRecord) ;

                        MV := HdRecord.MV / C1000 ;
                        If ( Abs ( Mv ) > 19 )  Then
                          MV := HdRecord.Mp / C1000 ;
                        If ( Mv > 19 ) Then
                          Mv := ( MvMin + MvMax ) / C20 ;

                        If (     ( Mv >= MvMin )
                             And ( Mv <= MvMax ) )  Then
                          Begin  { MV <= MVMAX }

                            SDRA   := HdRecord.SDRA  / CONSTDSIN ;
                            SDDEC  := HdRecord.SDDEC / CONSTDSIN ;

                            CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
                            CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;

                            Cat    := HdRecord.Cat ;

                            SDS    := CAT Mod 2 ;
                            If ( SDS = 1 )  Then
                              SDRA := - SDRA  ;

                            CAT    := CAT Div 2 ;

                            SDS    := CAT Mod 2 ;
                            If ( SDS = 1 )  Then
                              SDDEC := - SDDEC ;


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

                                        X     := XST ;
                                        Y     := YST ;

                                        Sp    := HdRecord.SpByte  ;
                                        M     := Round ( ( MV + 5 ) * 10.0 ) ;

                                        NRecC := JStar ;

                                      End ;

                                    If ( IndCat [ CatHd ].NBEG = -1 )  Then
                                      IndCat [ CatHd ].NBEG := NumberOfStars ;

                                    NumberOfStars  :=  NumberOfStars  +   1 ;


                                  End   { Å´Æ™ ¢Î§•´•≠ }
                                        { ------------ }
                                 Else
                                  Begin

                                    Close  ( HdFile    ) ;
                                    Close  ( HdKeyFile ) ;

                                    GOTO EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                                      { ---------------- }
                                  End ;

                              End ;  { XST, YST  < X(Y)MAX }

                          End ;  { MV < MVMAX }

                      End ; { JSTAR }

                  End ; { JEND >= JNBEG }

              End ;  { NRA  }

          End ; { JRA }

      End ; { JDEC }


    Close  ( HdFile    ) ;
    Close  ( HdKeyFile ) ;


    {
         H D E
         ‹‹‹‹‹
    }


    Assign  ( HdEFile    , ParamDir.HdDir + '\' + CatFile.HdEFileName  ) ;
    Reset   ( HdEFile                                                  ) ;

    Assign  ( HdEKeyFile , ParamDir.HdDir + '\' + CatFile.HdEKeyFileName ) ;
    Reset   ( HdEKeyFile                                                 ) ;


    For  JDEC := 1 To  NUMDEC  Do
      Begin  { JDEC }

        DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;

        NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
        SDECFILD := SinDecFild [ NFILDDEC ] ;
        CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;


	For  JRA := 1  To  NUMRA  Do
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

	    If ( JRA = 2 )
              Then
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


	    NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            For  NRA := NBEG  To  NEND  Do
              Begin  { NRA }

                Seek ( HdEKeyFile , NRA       ) ;
                Read ( HdEKeyFile , KeyRecord ) ;

                JNBEG := KeyRecord.NBEG     ;

                Read ( HdEKeyFile , KeyRecord ) ;

                JNEND := KeyRecord.NBEG - 1 ;


	        If ( JNEND >= JNBEG )  Then
                  Begin { JEND >= JNBEG }

                    NFILDRA := TRUNC ( (  RAMIN  * RG
                                        + STEPGR * ( NRA - NBEG + 1 ) )
                                        / STEPGR                      ) ;

                    SRAFILD := SinRaFild [ NFILDRA ] ;
                    CRAFILD := CosRaFild [ NFILDRA ] ;




                    {  èêéëåéíê  áÇÖáÑ  HdE  }
                    {  ====================  }


                    Seek ( HdEFile , JNBEG - 1 ) ;


	            For  JSTAR := JNBEG  To  JNEND  Do
                      Begin  { JSTAR }

                        Read ( HdEFile , HdERecord) ;

                        MV     := HdERecord.MV / C100 - 5.0 ;


                        If (     ( Mv >= MvMin )
                             And ( Mv <= MvMax ) )  Then
                          Begin  { MV <= MVMAX }

                            SDRA   := HdERecord.SDRA  / CONSTDSIN ;
                            SDDEC  := HdERecord.SDDEC / CONSTDSIN ;

                            CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
                            CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;

                            CAT    := HdERecord.Cat ;

                            SDS    := CAT Mod 2 ;
                            If ( SDS = 1 )  Then
                              SDRA  := - SDRA  ;

                            CAT    := CAT Div 2 ;

                            SDS    := CAT Mod 2 ;
                            If ( SDS = 1 )  Then
                              SDDEC := - SDDEC ;


                            SRaSt  := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
                            CRaSt  := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

                            SDecSt := SDECFILD * CDDEC + CDECFILD * SDDEC ;
                            CDecSt := CDECFILD * CDDEC - SDECFILD * SDDEC ;


	                    CDA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	                    SDA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;

	                    CRO := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CDA ;
{
	                    SPoz  := CDecSt * SDA ;
	                    CPoz  := SDecSt * CDeclOptFld - CDecSt * SDeclOptFld * CDA ;

	                    YSt :=   FD * CPoz / CRO ;
	                    XSt := - FD * SPoz / CRO ;
}

                            If ( HdERecord.MuRa <> 32000 )
                             Then
                              Begin
                                MR := HdERecord.MuRa  / C10000 / SekRad * DtMu ;
                                MD := HdERecord.MuDec / C10000 / SekRad * DtMu ;
                              End
                             Else
                              Begin
                                Mr := 0.0 ;
                                Md := 0.0 ;
                              End ;


                            XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt
                                                    - Mr * SRaSt           ;
                            YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt
                                                    + Mr * CRaSt           ;
                            ZRect := SDecSt         + Md * CDecSt          ;

                            X1 := - XRect * SRaOptFld + YRect * CRaOptFld  ;
                            Y1 := - XRect * CRaOptFld - YRect * SRaOptFld  ;
                            Z1 :=   ZRect                                  ;

                            X2 :=   X1                                     ;
                            Y2 :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld    ;
                            Z2 := - Y1 * CDeclOptFld + Z1 * SDeclOptFld    ;

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


                            If (    ( Abs ( XSt ) < XMax )
                                And ( Abs ( YSt ) < YMax ) )  Then
                              Begin  { XSt, YSt  < X(Y)MAX }
                                     { ------------------- }

                                If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                                  CBlock :=  NumberOfStars Div ObjectBlockSize ;

                                If (    ( BlockAllocFlag [ CBlock ] )
                                     Or (  AllocBlock               )  )  Then
                                  Begin

                                    SpStr := HdERecord.Sp  ;

                                    Case SpStr [ 1 ] Of
                                      'O' : Spectr :=  0 ;
                                      'B' : Spectr := 10 ;
                                      'A' : Spectr := 20 ;
                                      'F' : Spectr := 30 ;
                                      'G' : Spectr := 40 ;
                                      'K' : Spectr := 50 ;
                                      'M' : Spectr := 60 ;
                                     Else
                                            Spectr := 70 ;
                                    End ; { Case }

                                    If ( SpStr [ 2 ] <> ' ' )  Then
                                      Spectr := Spectr +
                                          Ord ( SpStr [ 2 ] )
                                        - Ord ( '0' ) ;

                                    With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                                  [NumberOfStars Mod ObjectBlockSize] Do
                                      Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

                                        X     := XST ;
                                        Y     := YST ;

                                        M     := Round ( ( MV + 5 ) * 10 ) ;
                                        Sp    := Spectr + 100 ;
                                        NRecC := JStar  ;

                                      End ;

                                    If ( IndCat [ CatHd ].NBEG = -1 )  Then
                                      IndCat [ CatHd ].NBEG := NumberOfStars ;

                                    Inc ( NumberOfStars ) ;

                                  End   { Å´Æ™ ¢Î§•´•≠ }
                                        { ------------ }
                                 Else
                                  Begin

                                    Close  ( HdEFile    ) ;
                                    Close  ( HdEKeyFile ) ;

                                    GOTO EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                                      { ---------------- }
                                  End ;

                              End ;  { XST, YST  < X(Y)MAX }

                          End ;  { MV < MVMAX }

                      End ; { JSTAR }

                  End ; { JEND >= JNBEG }

              End ;  { NRA  }

          End ; { JRA }

      End ; { JDEC }

    Close  ( HdEFile    ) ;
    Close  ( HdEKeyFile ) ;



    EndMemory : ;


    If ( IndCat [ CatHd ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatHd ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatHd ].TypeCoord := IdCoord           ;
       End ;

    FileMode := 2 ;

  End ;  { PRO HdFld }

End.

