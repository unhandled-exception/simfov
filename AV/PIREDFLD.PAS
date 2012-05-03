
{$O+,F+}


UNIT PIRedFld ;   { ÇõÅéê áÇÖáÑ  I_RED }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


  INTERFACE

    USES  PVar, PVarMenu, V_Catal, PPreNew, PMem, PProFld ;


    PROCEDURE IRedFld ;


  IMPLEMENTATION


    PROCEDURE IRedFld ;
   {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }



    Label EndMemory ;

   Type

      I_RedType  = Record

                     SDRa       : Word    ;  { Sin DRa   * ConstDSin }
		     SDDec      : Word    ;  { Sin DDec  * ConstDSin }
                     Cat        : Byte    ;
                     NumCat     : Byte    ;
                     NSerInFile : LongInt ;

                   End;


      I_RedKeyType = Record
                       NBeg : Longint ;
                     End ;


   Var

         FileExist                 : Boolean ;

         Spectr,
         Cat, SdS                  : Byte    ;

         Code                      : Integer ;

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
         P,S, CS, SS,
         SG, CG,
         ST, CT,
         SDA, CDA,
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
         N1, N2                    : LongInt ;

         I_RedFile      : File Of I_RedType    ;
         I_RedKeyFile   : File Of I_RedKeyType ;

         I_RedRecord    :         I_RedType    ;
         I_RedKeyRecord :         I_RedKeyType ;

         NameCatFile    : Text   ;

         S1,
         SNameCatFile   : String ;


  Begin  { Pro IRedFldFld }


     Assign ( I_RedFile    , ParamDir.IrasDir + '\' + 'I_Red.Srt'    ) ;
     Assign ( I_RedKeyFile , ParamDir.IrasDir + '\' + 'I_Red.Grn'    ) ;
     Assign ( NameCatFile  , ParamDir.IrasDir + '\' + 'Catalogs.Nam' ) ;


     FileMode := 0 ;


     FileExist := True ;
            {$I-}
     Reset  ( I_RedFile );
            {$I+}
     If ( IOResult <> 0 )
        Then  FileExist := False ;

            {$I-}
     Reset  ( I_RedKeyFile );
            {$I+}
     If ( IOResult <> 0 )
        Then  FileExist := False ;


            {$I-}
     Reset  ( NameCatFile );
            {$I+}
     If ( IOResult <> 0 )
        Then  FileExist := False ;



     If ( FileExist )  Then
      Begin  { FileExist }

   {
   1 100       CIO
   2  36        DO
   3 240       FSC
   4 160       PSC
   5 132     RAFGL
   6 180       SSC
   7 164      TMSS
   }

        Reset ( NameCatFile ) ;

        N1 := 0 ;

        While ( SNameCatFile [ 1 ] = ' ' )  Do
          Delete ( SNameCatFile, 1, 1 ) ;


        While ( Not Eof ( NameCatFile ) )  Do
          Begin

            ReadLn ( NameCatFile, SNameCatFile ) ;

            While ( SNameCatFile [ 1 ] = ' ' )  Do
              Delete ( SNameCatFile, 1, 1 ) ;

            While ( SNameCatFile [ 1 ] <> ' ' )  Do
              Delete ( SNameCatFile, 1, 1 ) ;

            While ( SNameCatFile [ 1 ] = ' ' )  Do
              Delete ( SNameCatFile, 1, 1 ) ;

            S1 := '' ;
            While ( SNameCatFile [ 1 ] <> ' ' )  Do
              Begin
                S1 := S1 + SNameCatFile [ 1 ] ;
                Delete ( SNameCatFile, 1, 1 ) ;
              End ;

            Val ( S1, Cat, Code ) ;

            While (    ( SNameCatFile [ 1 ] = ' ' )
                    Or (     ( SNameCatFile [ 1 ] >= '0' )
                         And ( SNameCatFile [ 1 ] <= '9' )  )
                                                              )  Do
              Delete ( SNameCatFile, 1, 1 ) ;

              Inc ( N1 ) ;

              CatNameKutcha [ N1 ] := SNameCatFile ;
              CatKutchaRecL [ N1 ] := Cat          ;

          End ;

        Close ( NameCatFile ) ;


        MV     := ( MvMin + MvMax ) / C20 ;

        IndCat [ CatIRed ].RoDet := Param.RoIrasDet  ;


          { èÆß®Ê®Æ≠≠Î© „£Æ´ ë•¢•p≠Æ£Æ èÆ´Ó·† }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

        Povorot ( JdIRedCat, SPozNp1, CPozNp1 )   ;

        IndCat [ CatIRed ].JdCat   := JdIrasCat ;

        IndCat [ CatIRed ].SPozNp1 := SPozNp1  ;
        IndCat [ CatIRed ].CPozNp1 := CPozNp1  ;



        RaOptFld   := RaOpt   ;
        DeclOptFld := DeclOpt ;

        PRENew ( JDateFld, JdIRedCat, RaOptFld, DeclOptFld );
       {==================================================}

        SDeclOptFld := Sin ( DeclOptFld ) ;
        CDeclOptFld := COS ( DeclOptFld ) ;

        SRaOptFld   := Sin ( RaOptFld   ) ;
        CRaOptFld   := COS ( RaOptFld   ) ;

        IndCat [ CatIRed ].SRaOpt    := SRaOptFld   ;
        IndCat [ CatIRed ].CRaOpt    := CRaOptFld   ;
        IndCat [ CatIRed ].SDeclOpt  := SDeclOptFld ;
        IndCat [ CatIRed ].CDeclOpt  := CDeclOptFld ;



            { éèêÖÑÖãÖçàÖ ÉêÄçàñ éÅãÄëíà Ç äÄíÄãéÉÖ }
            { ************************************* }



            NUMRA  := 1 ;
            ADecC  := ABS ( DeclOptFld ) ;

            DecMIN := DeclOptFld - ROMAX ;
            DecMAX := DeclOptFld + ROMAX ;

            If ( B_Import_Fld )
              Then  DDeclPM := 10.0 / SekRad * Abs ( DtMu )
              Else  DDeclPm :=  0.0 ;

            DecMin  := DecMin - DDeclPm ;
            DecMax  := DecMax + DDeclPm ;

	    If ( ADecC  >  DecCKR )  Then
              Begin  {  POL  }
                     { ----- }


                  SDD := CROMAX * ABS ( SDeclOptFld ) ;
                  SDD := SDD - SROMAX * CDeclOptFld * YMAX / XMAX ;

	          DecMIN := ARCTAN ( SDD / Sqrt ( C10 - SDD * SDD ) ) ;
	          DecMAX := ABS ( DeclOptFld ) + ROMAX ;

                  DecMin  := DecMin - DDeclPm ;
                  DecMax  := DecMax + DDeclPm ;

                  If ( DeclOptFld < 0.0 )  Then
                     Begin

                      DecMAX := - DecMIN ;
                      DecMIN := - R90    ;

                     End

                   Else

                     DecMAX := R90 ;


 	          RAMIN1 := 0.0;
	          RAMAX1 := R359;

              End  { ABS ( DeclOptFld ) > DecCKR }

            Else

              Begin  { NO POLE }
                     { ------- }

                DRA := SROMAX / CDeclOptFld;
	        DRA := ARCTAN ( DRA / Sqrt ( C10 - DRA * DRA ) );
                DRa := DRa + DDeclPm ;

	        RAMIN1 := RaOptFld - DRA;
	        RAMAX1 := RaOptFld + DRA;


	        If ( RAMIN1 <  0.0 )  Then  RAMIN1 := RAMIN1 + R360;
	        If ( RAMAX1 > R360 )  Then  RAMAX1 := RAMAX1 - R360;

	        If ( RAMIN1 > RAMAX1 )  Then

                  Begin  { RAMIN1 > RAMAX1 }

	            RAMIN2 := RAMIN1;
	            RAMIN1 := 0.0;
	            RAMAX2 := R359;
	            NUMRA  := 2;

                  End ;  { RAMIN1 > RAMAX1 }

              End ;  { ABS ( DeclOptFld )  <=  DecCKR }




	    N1 := TRUNC ( ( DecMIN * RG + 90.0 ) / STEPGR ) - 1;
	    N2 := TRUNC ( ( DecMAX * RG + 90.0 ) / STEPGR ) - 1;

	    NUMDec := N2 - N1 + 1;


        { äéçÖñ  éèêÖÑÖãÖçàü  ÉêÄçàñ  éÅãÄëíà  Ç  äÄíÄãéÉÖ }
        { ------------------------------------------------ }



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

             Seek ( I_RedKeyFile , NRA       ) ;
             Read ( I_RedKeyFile , I_RedKeyRecord ) ;

                 JNBeg := I_RedKeyRecord.NBeg     ;

             Read ( I_RedKeyFile , I_RedKeyRecord ) ;

                 JNEnd := I_RedKeyRecord.NBeg - 1 ;


	    If ( JNEnd >= JNBeg )  Then

            Begin { JEnd >= JNBeg }

             NFildRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBeg + 1 ) )
                                              / STEPGR                      ) ;


             SRaFild := SinRaFild [ NFildRA ] ;
             CRaFild := CoSRaFild [ NFildRA ] ;




		{  èêéëåéíê  áÇÖáÑ  HicBin  }
                {  =======================  }


             Seek ( I_RedFile , JNBeg - 1 ) ;


	     For  JSTAR := JNBeg  To  JNEnd  Do
             Begin  { JSTAR }

              Read ( I_RedFile , I_RedRecord ) ;


              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax )  )  Then
              Begin  { MV <= MVMAX }

               SdRa   := I_RedRecord.SdRa  ;
               SdDec  := I_RedRecord.SdDec ;

               SdRa   := SdRa  / ConstDSin ;
               SdDec  := SdDec / ConstDSin ;

               CdRa   := Sqrt ( C10 - SdRa  * SdRa  ) ;
               CdDec  := Sqrt ( C10 - SdDec * SdDec ) ;

               Cat    := I_RedRecord.Cat ;

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



               XRect := CRaSt * CDecSt  ;
               YRect := SRaSt * CDecSt  ;
               ZRect := SDecSt          ;

               X1  := - XRect * SRaOptFld + YRect * CRaOptFld ;
               Y1  := - XRect * CRaOptFld - YRect * SRaOptFld ;
               Z1  :=   ZRect                       ;

               X2  :=   X1                          ;
               Y2  :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld     ;
               Z2  := - Y1 * CDeclOptFld + Z1 * SDeclOptFld     ;

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

                   If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                         CBlock :=  NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or (  AllocBlock               )  )  Then
                       Begin

                         With ObjectPtr [ NumberOfStars Div ObjectBlockSize ]^
                                        [ NumberOfStars Mod ObjectBlockSize ] Do
                            Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

			      X	     := XSt ;
			      Y	     := YSt ;

                              Sp     := 50  ;

			      M	     := Round ( ( MV + 5.0 ) * 10 ) ;

			      NRecC  :=   I_RedRecord.NSerInFile * 20
                                        + I_RedRecord.NumCat          ;

                            End ;

                         If ( IndCat [ CatIRed ].NBeg = -1 )  Then
                              IndCat [ CatIRed ].NBeg := NumberOfStars ;

                         Inc ( NumberOfStars ) ;

                       End   { Å´Æ™ ¢Î§•´•≠ }
                             { ------------ }
                      Else
                        GoTo EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                          { ---------------- }
                 End ;  { XSt, YSt  < X(Y)MAX }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEnd >= JNBeg }

            End ;  { NRA  }

           End ; { JRA }

         End ; { JDec }

      End ;  { FileExist }

 EndMemory : ;

     If ( FileExist )  Then
       Begin
            {$I-}
         Reset  ( I_RedFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( I_RedFile );
            {$I-}
         Reset  ( I_RedKeyFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( I_RedKeyFile );

            {$I-}
         Reset  ( NameCatFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( NameCatFile );

       End ;


     If ( IndCat [ CatIRed ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatIRed ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatIRed ].TypeCoord := IdCoord           ;
       End ;


     FileMode := 2 ;

    End ;  { Pro IRedFldFld }


END.

