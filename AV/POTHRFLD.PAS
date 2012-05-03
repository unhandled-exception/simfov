
{$O+,F+}


Unit POthrFld ;   { ‚› ‡‚…‡„  Others }
                  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


  InterFace

    Uses  PVar, PVarMenu, V_Catal, PPreNew, PMem, PProFld, Crt, MLib ;


    Procedure OthersFld ;


  Implementation


    Procedure OthersFld ;
   {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }



    Label EndMemory ;

   Type


      OthersType  = Record

                      SDRa       : Word    ; { Sin DRa   * ConstDSin }
	  	      SDDec      : Word    ; { Sin DDec  * ConstDSin }
                      PmRa       : Integer ; { ArcSec/y * 1000    -32000 No P.M. }
                      PmDecl     : Integer ; { ArcSec/y * 1000    -32000 No P.M. }
                      Cat        : Byte    ;
                      NSerInFile : LongInt ;
                      Mv         : Integer ; { Mv * 10      -32000 No Mv   }
                                             { Mv + 100  -> Mv Johnson     }
                    End;



      OthersKeyType = Record
                        NBeg : Longint ;
                      End ;



   Var

         FileExist                 : Boolean ;

         Spectr,
         Cat, SdS                  : Byte    ;

         Code                      : Integer ;

         LRecCat                   : Word    ;


         Index,
         Mv,
         ADECC,
         SDD,
         RaMin, RaMax,
         RaMin1, RaMax1, RaMin2, RaMax2,
         R0, DRa, DecTek,
         SRAFILD, CRAFILD, SDECFILD, CDECFILD,
         SDRA, CDRA, SDDEC, CDDEC,
         SRaSt, CRaSt,
         SDecSt, CDecSt,
         XSt, YSt,
         DecMin, DecMax,
         SP, CP,
         P,S, CS, SS,
         SG, CG,
         ST, CT,
         SDA, CDA, CRo,
         SPOZ, CPOZ,
         TGRO,
         DTMU,
         DDeclPm,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         MR, MD, PMX, PMY          : Double  ;

         NumRa,
         NumDec,
         NFildRa,
         NFildDec,
         JRa, JDec,
         JStar,
         JNBeg, JNEnd,
         NRa,
         NBeg , NEnd,
         NCats,
         IndCatOthers,
         N1, N2                    : LongInt ;

         OthersFile      : File Of OthersType    ;
         OthersKeyFile   : File Of OthersKeyType ;

         OthersRecord    :         OthersType    ;
         OthersKeyRecord :         OthersKeyType ;

         NameCatFile    : Text   ;

         S1,
         SNameCatFile   : String ;

         NameCat        : String [ 15 ] ;


  Begin



     FileExist := True ;



       { ‚ â¥ªãé¥© ¤¨p¥ªâ®p¨¨ }
       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

     Assign ( NameCatFile, 'Catalogs.Nam'  ) ;

            {$I-}

     FileMode := 0 ;

     Reset  ( NameCatFile );
            {$I+}
     If ( IOResult <> 0 )   Then
       Begin
         Close ( NameCatFile );
         FileExist := False
       End ;


       { ‚ ¤¨p¥ªâ®p¨¨ Š â «®£®¢ }
       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

     If ( Not FileExist ) Then
       Begin

         Assign ( NameCatFile   , ParamDir.IrasDir + '\' + 'Catalogs.Nam'  ) ;

            {$I-}

         FileMode := 0 ;

         Reset  ( NameCatFile );
            {$I+}
         If ( IOResult <> 0 )  Then
           Begin
             FileExist := False ;
             Close ( NameCatFile );
           End ;

       End ;



     If ( FileExist )  Then
      Begin  { FileExist }

        NCats := 0 ;

        While ( Not Eof ( NameCatFile ) )  Do
          Begin

            ReadLn ( NameCatFile, SNameCatFile ) ;

            While ( SNameCatFile [ 1 ] = ' ' )  Do
              Delete ( SNameCatFile, 1, 1 ) ;

            If (     ( SNameCatFile [ 1 ] <> 'C' )
                 And ( SNameCatFile [ 1 ] <> 'c' )
                 And ( SNameCatFile       <> ''  )  )  Then
                Begin

                  S1 := '' ;
                  While ( SNameCatFile [ 1 ] <> ' ' )  Do
                    Begin
                      S1 := S1 + SNameCatFile [ 1 ] ;
                      Delete ( SNameCatFile, 1, 1 ) ;
                    End ;

                  Val ( S1, LRecCat, Code ) ;

                  While (    ( SNameCatFile [ 1 ] = ' ' )
                          Or (     ( SNameCatFile [ 1 ] >= '0' )
                               And ( SNameCatFile [ 1 ] <= '9' )  )
                                                                  )  Do
                    Delete ( SNameCatFile, 1, 1 ) ;


                  Inc ( NCats ) ;

                  CatNameKutcha [ NCats ] := SNameCatFile ;
                  CatKutchaRecL [ NCats ] := LRecCat      ;



                End ; { Not Comment }

          End ; { FileExist }

        Close ( NameCatFile ) ;




        IndCat [ CatOthers ].RoDet := Param.RoIrasDet  ;


          { ®§¨æ¨®­­ë© ã£®« ‘¥¢¥p­®£® ®«îá  }
          { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        Povorot ( JdCat [ CatOthers ], SPozNp1, CPozNp1 )   ;

        IndCat [ CatOthers ].JdCat   := JdCat [ CatOthers ] ;

        IndCat [ CatOthers ].SPozNp1 := SPozNp1  ;
        IndCat [ CatOthers ].CPozNp1 := CPozNp1  ;



        RaOptFld   := RaOpt   ;
        DeclOptFld := DeclOpt ;

        PRENew ( JDateFld, JdCat [ CatOthers ], RaOptFld, DeclOptFld );
       {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        SDeclOptFld := Sin ( DeclOptFld ) ;
        CDeclOptFld := COS ( DeclOptFld ) ;

        SRaOptFld   := Sin ( RaOptFld   ) ;
        CRaOptFld   := COS ( RaOptFld   ) ;

        IndCat [ CatOthers ].SRaOpt    := SRaOptFld   ;
        IndCat [ CatOthers ].CRaOpt    := CRaOptFld   ;
        IndCat [ CatOthers ].SDeclOpt  := SDeclOptFld ;
        IndCat [ CatOthers ].CDeclOpt  := CDeclOptFld ;



            { …„…‹…ˆ… ƒ€ˆ– ‹€‘’ˆ ‚ Š€’€‹ƒ… }
            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        For IndCatOthers := 1 To NCats Do
          Begin { NCats }
            {
            If ( Not  B_Det_Cdc )
              Then
                Begin
                  If (    ( CatNameKutcha [ IndCatOthers ] = 'HIP' )
                       Or ( CatNameKutcha [ IndCatOthers ] = 'TYC' ) )  Then
                    Begin
                      DtMu := ( JDate - JdCat [ CatOthers ] ) / 365.25 ;
                      DtMu := DtMu + 8.75;
                    End ;
                End
              Else
                DtMu := ( JdCat [ CatCdcMoz ] - JdCat [ CatOthers ] ) / 365.25 ;
            }

            DtMu := ( JDate - JdCat [ CatOthers ] ) / 365.25 ;

            If (    ( CatNameKutcha [ IndCatOthers ] = 'HIP' )
                 Or ( CatNameKutcha [ IndCatOthers ] = 'TYC' ) )  Then
              Begin
                DtMu := ( JDate - JdCat [ CatOthers ] ) / 365.25 ;
                DtMu := DtMu + 8.75;
              End ;


            NumRa  := 1 ;
            ADecC  := Abs ( DeclOptFld ) ;

            DecMin := DeclOptFld - RoMax ;
            DecMAX := DeclOptFld + RoMax ;

            If ( B_Import_Fld )
              Then  DDeclPm := C100 / SekRad * Abs ( DtMu )
              Else  DDeclPm :=  0.0 ;

            DecMin  := DecMin - DDeclPm ;
            DecMax  := DecMax + DDeclPm ;

	    If ( ADecC  >  DecCKR )
              Then
                Begin  {  POL  }
                       { ÄÄÄÄÄ }

                  SDD := CRoMax * Abs ( SDeclOptFld ) ;
                  SDD := SDD - SRoMax * CDeclOptFld * YMax / XMax ;

	          DecMin := ArcTan ( SDD / Sqrt ( C10 - SDD * SDD ) ) ;
	          DecMax := Abs ( DeclOptFld ) + RoMax ;

                  DecMin  := DecMin - DDeclPm ;
                  DecMax  := DecMax + DDeclPm ;

                  If ( DeclOptFld < 0.0 )
                    Then
                      Begin
                        DecMax := - DecMin ;
                        DecMin := - R90    ;
                      End
                    Else
                        DecMax := R90 ;


 	          RaMin1 := 0.0;
	          RaMax1 := R359;

                End  { Abs ( DeclOptFld ) > DecCKR }
              Else
                Begin  { NO POLE }
                       { ÄÄÄÄÄÄÄ }

                  DRa := SRoMax / CDeclOptFld;
	          DRa := ArcTan ( DRa / Sqrt ( C10 - DRa * DRa ) );
                  DRa := DRa + DDeclPm ;

	          RaMin1 := RaOptFld - DRa;
	          RaMax1 := RaOptFld + DRa;


	          If ( RaMin1 <  0.0 )  Then
                    RaMin1 := RaMin1 + R360;

	          If ( RaMax1 > R360 )  Then
                    RaMax1 := RaMax1 - R360;

	          If ( RaMin1 > RaMax1 )  Then
                    Begin  { RaMin1 > RaMax1 }

	              RaMin2 := RaMin1;
	              RaMin1 := 0.0;
	              RaMax2 := R359;
	              NumRa  := 2;

                    End ;  { RaMin1 > RaMax1 }

                End ;  { Abs ( DeclOptFld )  <=  DecCKR }




	    N1 := Trunc ( ( DecMin * RG + 90.0 ) / StepGr ) - 1;
	    N2 := Trunc ( ( DecMAX * RG + 90.0 ) / StepGr ) - 1;

	    NumDec := N2 - N1 + 1;


              { Š…–  …„…‹…ˆŸ  ƒ€ˆ–  ‹€‘’ˆ  ‚  Š€’€‹ƒ… }
              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


            NameCat := CatNameKutcha [ IndCatOthers ] ;

            Assign ( OthersFile    ,   ParamDir.IrasDir
                                     + '\'
                                     + NameCat
                                     + '.Srt'    ) ;
            Assign ( OthersKeyFile ,   ParamDir.IrasDir
                                     + '\'
                                     + NameCat
                                     + '.Grn'    ) ;

            FileExist := True ;
            {$I-}

            FileMode := 0 ;

            Reset  ( OthersFile );
            {$I+}
            If ( IOResult <> 0 ) Then
              FileExist := False ;

            {$I-}

            FileMode := 0 ;

            Reset  ( OthersKeyFile );
            {$I+}
            If ( IOResult <> 0 ) Then
              FileExist := False ;



            If ( FileExist )  Then
              Begin  { FileExist Cat }
                {
                If ( Not  B_Det_Cdc )
                  Then  DtMu := ( JDate               - JdCat [ CatOthers ] ) / 365.25
                  Else  DtMu := ( JdCat [ CatCdcMoz ] - JdCat [ CatOthers ] ) / 365.25 ;
                }
                {
                DtMu := ( JDate - JdCat [ CatOthers ] ) / 365.25 ;
                }

                Spectr := 50 ;

                If (    ( CatNameKutcha [ IndCatOthers ] = 'HIP' )
                     Or ( CatNameKutcha [ IndCatOthers ] = 'TYC' ) )  Then
                  Begin
                    DtMu := DtMu + 8.75;
                    Spectr := 90 ;
                  End ;


	        For  JDec := 1 To  NumDec  Do
                  Begin  { JDec }

	            DecTek := DecMin + ( JDec - 1 ) * StepRad;

                    NFildDec := Trunc ( ( DecTek * RG + StepGr + 90.0 ) / StepGr ) ;
                    SDecFild := SinDecFild [ NFildDec ] ;
                    CDecFild := Sqrt ( C10 - SDecFild * SDecFild ) ;


	            For  JRa := 1  To  NumRa  Do
                      Begin  { JRa }

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


	              NBeg :=        Trunc ( ( DecTek * RG + 90.0   )
                                     / StepGr ) * NRaMax ;
                      NBeg := NBeg + Trunc ( ( RaMin  * RG + StepGr )
                                     / StepGr ) -  1     ;

	              NEnd :=        Trunc ( ( DecTek * RG + 90.0   )
                                     / StepGr ) * NRaMax ;
     	              NEnd := NEnd + Trunc ( ( RaMax  * RG + StepGr )
                                     / StepGr ) -  1     ;


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


                          Seek ( OthersKeyFile , NRA             ) ;
                          Read ( OthersKeyFile , OthersKeyRecord ) ;

                          JNBeg := OthersKeyRecord.NBeg     ;

                          Read ( OthersKeyFile , OthersKeyRecord ) ;

                          JNEnd := OthersKeyRecord.NBeg - 1 ;


	                  If ( JNEnd >= JNBeg )  Then
                            Begin { JEnd >= JNBeg }

                              NFildRA := Trunc ( (   RaMin  * RG
                                         + StepGr * ( NRA - NBeg + 1 ) )
                                         / StepGr                      ) ;


                              SRaFild := SinRaFild [ NFildRA ] ;
                              CRaFild := CoSRaFild [ NFildRA ] ;


		              {  ‘Œ’  ‡‚…‡„  }
                              {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }


                              Seek ( OthersFile , JNBeg - 1 ) ;


	                      For  JStar := JNBeg  To  JNEnd  Do
                                Begin  { JStar }

                                  Read ( OthersFile , OthersRecord ) ;

                                  If ( OthersRecord.Mv <> -32000 )
                                    Then Mv := OthersRecord.Mv   / C100
                                    Else Mv := ( MvMin + MvMax ) /  C20 ;

                                  If ( Mv > C1000 )  Then
                                    Mv := Mv - C1000 ;

                                  If (     ( Mv >= MvMin )
                                       And ( Mv <= MvMax )  )  Then
                                      Begin  { MV <= MVMAX }

                                        SdRa   := OthersRecord.SdRa  ;
                                        SdDec  := OthersRecord.SdDec ;

                                        SdRa   := SdRa  / ConstDSin ;
                                        SdDec  := SdDec / ConstDSin ;

                                        CdRa   := Sqrt ( C10 - SdRa  * SdRa  ) ;
                                        CdDec  := Sqrt ( C10 - SdDec * SdDec ) ;

                                        Cat    := OthersRecord.Cat ;

                                        SDS    := Cat Mod 2 ;
                                        If ( SDS = 1 )  Then
                                           SdRa  := - SdRa  ;

                                        Cat    := Cat Div 2 ;

                                        SDS    := Cat Mod 2 ;
                                        If ( SDS = 1 )  Then
                                           SdDec := - SdDec ;

                                        SRaSt  :=   SRaFild  * CdRa
                                                  + CRaFild  * SdRa  ;
                                        CRaSt  :=   CRaFild  * CdRa
                                                  - SRaFild  * SdRa  ;

                                        SDecSt :=   SDecFild * CdDec
                                                  + CDecFild * SdDec ;
                                        CDecSt :=   CDecFild * CdDec
                                                  - SDecFild * SdDec ;


                              	        CdA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	                                SdA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;
	                                CRo := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CdA ;


                                        XRect := CRaSt * CDecSt  ;
                                        YRect := SRaSt * CDecSt  ;
                                        ZRect := SDecSt          ;

                                        If ( OthersRecord.PmRa <> -32000 )  Then
                                          Begin

                                            Mr :=   OthersRecord.PmRa
                                                  / C10000
                                                  / SekRad * DtMu ;
                                            Md :=   OthersRecord.PmDecl
                                                  / C10000
                                                  / SekRad * DtMu ;

                                            XRect :=   XRect
                                                     - Md * SDecSt * CRaSt
                                                     - Mr * SRaSt ;

                                            YRect :=   YRect
                                                     - Md * SDecSt * SRaSt
                                                     + Mr * CRaSt ;

                                            ZRect :=   ZRect + Md * CDecSt ;

                                          End ;


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


                                        { ®¢®p®â ª¢ ‘¨áâ JdCat -> ª¢ ‘¨áâ JdFld }
                                        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                                        Index :=     XSt            ;
                                        XSt   :=     XSt * CPozNp1
                                                 -   YSt * SPozNp1  ;
                                        YSt   :=   Index * SPozNp1
                                                 +   YSt * CPozNp1  ;

                                        { áì 'Y' ¢ ¯®«îá¥ JdFld }



                                        If ( Not ( NPolFix ) )   Then
                                          Begin { ‘â ¡¨«¨§ æ¨ï ®á¨ Y ¢ §¥­¨â }
                                                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                                            Index := XSt ;

                                            XSt :=     XSt  * CPozNp
                                                    -  YSt  * SPozNp ;
                                            YSt :=    Index * SPozNp
                                                    +  YSt  * CPozNp ;

                                          End ;


                                        If (    ( Abs ( XSt ) < XMax )
                                            And ( Abs ( YSt ) < YMax ) )  Then
                                          Begin  { XSt, YSt  < X(Y)MAX }

                                            If (    NumberOfStars
                                                Mod ObjectBlockSize = 0 ) Then
                                              CBlock :=     NumberOfStars
                                                        Div ObjectBlockSize ;

                                            If (    ( BlockAllocFlag [ CBlock ] )
                                                 Or (  AllocBlock               )  )
                                             Then
                                              Begin

                                                With ObjectPtr [ NumberOfStars Div ObjectBlockSize ]^
                                                               [ NumberOfStars Mod ObjectBlockSize ] Do
                                                  Begin  { ç¥à¥¤­ ï §¢¥§¤  }

			                            X     := XSt ;
			                            Y     := YSt ;

                                                    Sp    := Spectr ;

			                            M     := Round ( ( MV + 5.0 ) * 10 ) ;

			                            NRecC :=   ( Abs ( OthersRecord.NSerInFile ) Mod 2000000 ) * 20
                                                             + IndCatOthers ;

                                                  End ;


                                                If (     ( B_VectDiagr                                     )
                                                     And (    ( NameCat = 'HIP' )
                                                           Or ( NameCat = 'TYC' ) ) ) Then
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

                                                    Mr :=   OthersRecord.PmRa
                                                            / C10000
                                                            / SekRad * Fd ;
                                                    Md :=   OthersRecord.PmDecl
                                                            / C10000
                                                            / SekRad * Fd ;

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
                                                    { ®¢®p®â ª¢ ‘¨áâ JdCat -> ª¢ ‘¨áâ JdFld }
                                                    Index :=   XSt ;
                                                    XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
                                                    YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;


                                                    If ( Not ( NPolFix ) )  Then
                                                      Begin { ‘â ¡¨«¨§ æ¨ï ®á¨ Y ¢ §¥­¨â }
                                                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
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

                                                If ( IndCat [ CatOthers ].NBeg = -1 )  Then
                                                     IndCat [ CatOthers ].NBeg := NumberOfStars ;

                                                Inc ( NumberOfStars ) ;

                                              End   { «®ª ¢ë¤¥«¥­ }
                                                    { ÄÄÄÄÄÄÄÄÄÄÄÄ }
                                             Else
                                                GoTo EndMemory ;  { ˆáç¥p¯ ­  ¯ ¬ïâì }
                                                                  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                                          End ;  { XSt, YSt  < X(Y)MAX }

                                      End ;  { MV < MVMAX }

                                  End ; { JStar }

                              End ; { JEnd >= JNBeg }

                          End ;  { NRA  }

                      End ; { JRa }

                  End ; { JDec }


                Close ( OthersFile );
                Close ( OthersKeyFile );


              End ;  { FileExist Cat }

          End ; { NCats }

      End ;  { FileExist NameCat }



     EndMemory : ;

     If ( FileExist )  Then
       Begin
            {$I-}

         FileMode := 0 ;

         Reset  ( OthersFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( OthersFile );
            {$I-}
         Reset  ( OthersKeyFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( OthersKeyFile );

            {$I-}
         Reset  ( NameCatFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( NameCatFile );

       End ;


     If ( IndCat [ CatOthers ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatOthers ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatOthers ].TypeCoord := IdCoord           ;
       End ;


     FileMode := 2 ;

    End ;


End.

