
{$O+,F+}

UNIT PNlttFLD ;   { ÇõÅéê áÇÖáÑ  Nltt }
                  { ================= }


  INTERFACE


    PROCEDURE NlttFLD ;


  IMPLEMENTATION

    USES  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, PFldGrn,
          Crt, MLib ;


    PROCEDURE NlttFLD ;
   {*****************}


    LABEL EndMemory ;


   Var

         Spectr,
         Cat, SdS           : Byte    ;

         Index,
         Mv,
         ADecFild,
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
         CRo,
         DtMu,
         DDeclPM,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         MR, MD, PmX, PmY   : Double  ;

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



 Begin  { PRO NlttFLD }


        FileMode := 0 ;

        Reset  ( NlttFile    ) ;
        Reset  ( NlttKeyFile );


        IndCat [ CatNltt ].RoDet := Param.RoHdDet ;
        {
        If ( Not  B_Det_Cdc )
          Then  DtMu := ( JDate               - JdCat [ CatNltt ] ) / 365.25
          Else  DtMu := ( JdCat [ CatCdcMoz ] - JdCat [ CatNltt ] ) / 365.25 ;
        }
        DtMu := ( JDate - JdCat [ CatNltt ] ) / 365.25 ;

        FldGrn ( CatNltt, DtMu, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;




	FOR  JDEC := 1 TO  NUMDEC  DO
         Begin  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;

          NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDECFILD := SinDecFild [ NFILDDEC ] ;
          CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;


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
              { ----------------------------------------------- }


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

             Seek ( NlttKeyFile , NRA       ) ;
             Read ( NlttKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

             Read ( NlttKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;


	    If ( JNEND >= JNBEG )  Then
            Begin { JEND >= JNBEG }

             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  èêéëåéíê  áÇÖáÑ  Nltt  }
                {  =====================  }


             Seek ( NlttFile , JNBEG - 1 ) ;


	     FOR  JSTAR := JNBEG  TO  JNEND  DO
             Begin  { JSTAR }

              Read ( NlttFile , NlttRecord) ;

              MV     := NlttRecord.Mv / C100  ;
              If ( Mv > 20.0 )  Then
                Mv := 20.0 ;

              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax ) )  Then
              Begin  { MV <- MVMAX }


               SDRA   := NlttRecord.SDRA  / CONSTDSIN ;
               SDDEC  := NlttRecord.SDDEC / CONSTDSIN ;

               CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
               CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;


               CAT    := NlttRecord.Cat ;

               SDS    := CAT MOD 2 ;
               If ( SDS = 1 )  Then
                 SDRA  := - SDRA  ;

               CAT    := CAT DIV 2 ;

               SDS    := CAT MOD 2 ;
               If ( SDS = 1 )  Then
                 SDDEC := - SDDEC ;

               CAT    := CAT DIV 2 ;


               SRaSt  := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
               CRaSt  := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

               SDecSt := SDECFILD * CDDEC + CDECFILD * SDDEC ;
               CDecSt := CDECFILD * CDDEC - SDECFILD * SDDEC ;


               MR := NlttRecord.MURA  / 0.6 / 1000000000.0 * DtMu ;
               MD := NlttRecord.MUDEC / 0.6 / 1000000000.0 * DtMu ;


               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;

               X1  := - XRect * SRaOptFld    +  YRect * CRaOptFld    ;
               Y1  := - XRect * CRaOptFld    -  YRect * SRaOptFld    ;
               Z1  :=   ZRect                                        ;

               X2  :=   X1                                           ;
               Y2  :=   Y1    * SDeclOptFld  +  Z1    * CDeclOptFld  ;
               Z2  := - Y1    * CDeclOptFld  +  Z1    * SDeclOptFld  ;


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
                   XSt := XSt + XSt * FRaFild ( YSt ) ;
                   YSt := YSt + YSt * FRaFild ( XSt ) ;
                 End ;
}


               If (    ( Abs ( XSt ) < XMax )
                   And ( Abs ( YSt ) < YMax ) )  Then
                 Begin  { XSt, YSt  < X(Y)MAX }
                        { ------------------- }

                   If  ( NumberOfStars mod ObjectBlockSize = 0 )  Then
                         CBlock :=  NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or (  AllocBlock               )  )  Then
                       Begin

                         With ObjectPtr[NumberOfStars div ObjectBlockSize]^
                                       [NumberOfStars mod ObjectBlockSize] do
                            Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }


			      X	      := XST ;
			      Y	      := YST ;

                              Sp      := 70 ;
			      M	      := Round ( ( MV + 5.0 ) * C100 ) ;

			      NRecC   := JSTAR ;

                            End ;

                         If ( IndCat [ CatNltt ].NBEG = -1 )  Then
                              IndCat [ CatNltt ].NBEG := NumberOfStars ;

                         Inc ( NumberOfStars ) ;


                       End   { Å´Æ™ ¢Î§•´•≠ }
                             { ------------ }
                      Else  GoTo EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                              { ---------------- }

                 End ;  { XST, YST  < X(Y)MAX }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEND >= JNBEG }

            End ;  { NRA  }

           End ; { JRA }

         End ; { JDEC }

   EndMemory : ;

       Close ( NlttFile    ) ;
       Close ( NlttKeyFile );

       FileMode := 2 ;


     If ( IndCat [ CatNltt ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatNltt ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatNltt ].TypeCoord := IdCoord           ;
       End ;

    End ;  { PRO NlttFld }

End.

