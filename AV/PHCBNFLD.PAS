
{$O+,F+}

Unit PHcBnFld ;   { ÇõÅéê áÇÖáÑ  HicBin }
                  { =================== }


  InterFace

    Uses  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, PFldGrn ;


    Procedure HicBinFld ;


  Implementation


    Procedure HicBinFld ;
   {********************}


    Label EndMemory ;


   Var

         FileExist                 : Boolean ;

         Spectr,
         Cat, SdS                  : Byte    ;

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

  Begin  { PRO HicBinFld }

{
     Assign ( HicBinFile    , 'E:\Catalog\Hic\' +
                               CatFile.HicBinFileName );
     Assign ( HicBinKeyFile , 'E:\Catalog\Hic\' +
                               CatFile.HicBinKeyFileName );

     Assign ( HicBinFile    , 'D:\Catalog\Hic\' +
                               CatFile.HicBinFileName );
     Assign ( HicBinKeyFile , 'D:\Catalog\Hic\' +
                               CatFile.HicBinKeyFileName );

}

     Assign ( HicBinFile    , 'E:\Catalog\Hic\' +
                               CatFile.HicBinFileName );
     Assign ( HicBinKeyFile , 'E:\Catalog\Hic\' +
                               CatFile.HicBinKeyFileName );


     FileMode := 0 ;


     FileExist := True ;
            {$I-}
     Reset  ( HicBinFile );
            {$I+}
     If ( IOResult <> 0 )
        Then  FileExist := False ;

            {$I-}
     Reset  ( HicBinKeyFile );
            {$I+}
     If ( IOResult <> 0 )
        Then  FileExist := False ;



     If ( FileExist )  Then
      Begin  { FileExist }


        IndCat [ CatHicBin ].RoDet := Param.RoPpmDet  ;

        If ( Not  B_Det_Cdc )
           Then  DtMu := ( JDate               - JdCat [ CatHicBin ] ) / 365.25
           Else  DtMu := ( JdCat [ CatCdcMoz ] - JdCat [ CatHicBin ] ) / 365.25 ;



        FldGrn ( CatHicBin, DtMu, NumRa, NumDec,
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

             Seek ( HicBinKeyFile , NRA       ) ;
             Read ( HicBinKeyFile , KeyRecord ) ;

                 JNBeg := KeyRecord.NBeg     ;

             Read ( HicBinKeyFile , KeyRecord ) ;

                 JNEnd := KeyRecord.NBeg - 1 ;


	    If ( JNEnd >= JNBeg )  Then

            Begin { JEnd >= JNBeg }

             NFildRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBeg + 1 ) )
                                              / STEPGR                      ) ;


             SRaFild := SinRaFild [ NFildRA ] ;
             CRaFild := CoSRaFild [ NFildRA ] ;




		{  èêéëåéíê  áÇÖáÑ  HicBin  }
                {  =======================  }


             Seek ( HicBinFile , JNBeg - 1 ) ;


	     For  JSTAR := JNBeg  To  JNEnd  Do

             Begin  { JSTAR }

              Read ( HicBinFile , HicBinRecord) ;

              MV     := HicBinRecord.MV / 10.0 - 5.0 ;

              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax )  )  Then
              Begin  { MV <= MVMAX }

               SdRa   := HicBinRecord.SdRa  ;
               SdDec  := HicBinRecord.SdDec ;

               SdRa   := SdRa  / ConstDSin ;
               SdDec  := SdDec / ConstDSin ;

               CdRa   := Sqrt ( C10 - SdRa  * SdRa  ) ;
               CdDec  := Sqrt ( C10 - SdDec * SdDec ) ;

               Cat    := HicBinRecord.Cat ;

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

               {
	       CdA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SdA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;

	       CRo := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CdA ;

	       SPoz  := CDecSt * SdA ;
	       CPoz  := SDecSt * CDeclOptFld - CDecSt * SDeclOptFld * CdA ;

	       YSt :=   FD * CPoz / CRo ;
	       XSt := - FD * SPoz / CRo ;
               }

               MR := HicBinRecord.MuRa  / C10000 / SekRad * DtMu ;
               MD := HicBinRecord.MuDec / C10000 / SekRad * DtMu ;

               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;

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

                         With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                       [NumberOfStars Mod ObjectBlockSize] Do
                            Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

			      X	      := XSt ;
			      Y	      := YSt ;

                              Sp      := Spectr ;
			      M	      := Round ( ( MV + 5 ) * 10 ) ;

			      NRecC   := JSTAR ;

                            End ;

                              If ( IndCat [ CatHicBin ].NBeg = -1 )  Then
                                   IndCat [ CatHicBin ].NBeg := NumberOfStars ;

                              NumberOfStars  :=  NumberOfStars  +   1 ;

                       End   { Å´Æ™ ¢Î§•´•≠ }
                             { ------------ }
                      Else  GoTo EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
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
         Reset  ( HicBinFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( HicBinFile );
            {$I-}
         Reset  ( HicBinKeyFile );
            {$I+}
         If ( IOResult = 0 )  Then
            Close ( HicBinKeyFile );

       End ;

     If ( IndCat [ CatHicBin ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatHicBin ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatHicBin ].TypeCoord := IdCoord           ;
       End ;


     FileMode := 2 ;


    End ;  { PRO HicBinFld }

End.

