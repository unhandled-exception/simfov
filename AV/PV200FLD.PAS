
{$O+,F+}

Unit PV200FLD ;   { ВЫБОР ЗВЕЗД  Gcvs_2000 }
                  { ────────────────────── }


  InterFace

    Uses  PVAR, PVarMenu, V_CATAL, PPRENew, PMem, PProFld, PFldGrn,
          Crt, MLib ;


    Procedure Gcvs2000FLD ;


  Implementation


    Procedure Gcvs2000FLD ;
   {─────────────────────}


    Label EndMemory ;

    Var
         Cat, SdS           : Byte    ;

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
         Mr, Md, DtMu,
         DecMin, DecMax,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         Index              : Double  ;

     Begin  { PRO STARFLD }


        FileMode := 0 ;

        Assign    ( Gcvs2000File ,  ParamDir.GcvsDir + '\' + CatFile.Gcvs2000FileName    ) ;
        Reset     ( Gcvs2000File                                                         ) ;
        Assign    ( GcvsKeyFile  ,  ParamDir.GcvsDir + '\' + CatFile.Gcvs2000KeyFileName ) ;
        Reset     ( GcvsKeyFile                                                          ) ;

        DtMu := ( JDate - J2000 ) / 365.25 ;

        IndCat [ CatGcvs ].RoDet := Param.RoGcvsDet ;



        FldGrn ( CatGcvs, 0.0, NumRa, NumDec,
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


              { ВЫЧИСЛЕНИЕ НАЧАЛА И КОНЦА ИНФОРМАЦИИ В КАТАЛОГЕ }
              { ----------------------------------------------- }


	    NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            For  NRA := NBEG  To  NEND  Do
            Begin  { NRA }

             Seek ( GcvsKeyFile , NRA       ) ;
             Read ( GcvsKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG      ;

             Read ( GcvsKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;


	    If ( JNEND >= JNBEG )  Then

            Begin { JEND >= JNBEG }

             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  ПРОСМОТР  ЗВЕЗД  Gcvs  }
                {  ====================  }


             Seek ( Gcvs2000File , JNBEG - 1 ) ;


	     For  JSTAR := JNBEG  To  JNEND  Do
             Begin  { JSTAR }

              Read ( Gcvs2000File , Gcvs2000Record ) ;

              Mv := MvMax ;

              If ( MV <= MVMAX )  Then
              Begin  { MV <= MVMAX }

               SDRA   := Gcvs2000Record.SDRA  / CONSTDSIN ;
               SDDEC  := Gcvs2000Record.SDDEC / CONSTDSIN ;

               CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
               CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;


               CAT    := Gcvs2000Record.Cat ;

               SDS    := CAT Mod 2 ;
                 If ( SDS = 1 )  Then SDRA  := - SDRA  ;

               CAT    := CAT Div 2 ;

               SDS    := CAT Mod 2 ;
                 If ( SDS = 1 )  Then SDDEC := - SDDEC ;

               CAT    := CAT Div 2 ;


               SRaSt  := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
               CRaSt  := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

               SDecSt := SDECFILD * CDDEC + CDECFILD * SDDEC ;
               CDecSt := CDECFILD * CDDEC - SDECFILD * SDDEC ;


               If ( Gcvs2000Record.PmRa <> -32000 )
                 Then
                   Begin
                     MR := Gcvs2000Record.PmRa   / 1000.0 / SekRad * DtMu ;
                     MD := Gcvs2000Record.PmDecl / 1000.0 / SekRad * DtMu ;
                   End
                 Else
                   Begin
                     MR := 0.0 ;
                     MD := 0.0 ;
                   End ;

               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;

               X1    := - XRect * SRaOptFld + YRect * CRaOptFld  ;
               Y1    := - XRect * CRaOptFld - YRect * SRaOptFld  ;
               Z1    :=   ZRect                                  ;

               X2    :=   X1                                     ;
               Y2    :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld    ;
               Z2    := - Y1 * CDeclOptFld + Z1 * SDeclOptFld    ;

               XSt   := - Fd * X2 / Z2  ;
               YSt   :=   Fd * Y2 / Z2  ;


                { Повоpот Экв Сист JdCat -> Экв Сист JdFld }
                { ──────────────────────────────────────── }

               Index :=   XSt ;
               XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
               YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;

                  { Ось 'Y' в полюсе JdFld }



               If ( Not ( NPolFix ) )   Then
                   Begin { Стабилизация оси Y в зенит }
                         { ────────────────────────── }
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

                   If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                     CBlock :=  NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or (  AllocBlock               )  )
                     Then
                       Begin

                         With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                       [NumberOfStars Mod ObjectBlockSize] Do
                           Begin  { Очередная звезда }

                             X    := XST ;
                             Y    := YST ;

                             Sp   := 100 ;
                             M    := Round ( ( 10 + 5 ) * 10 ) ;
                             Date :=   0 ;

                             NRecC    := JStar ;

                           End ;

                         If ( IndCat [ CatGcvs ].NBEG = -1 )  Then
                              IndCat [ CatGcvs ].NBEG := NumberOfStars ;

                         NumberOfStars  :=  NumberOfStars  +   1 ;

                       End   { Блок выделен }

                     Else

                         GoTo EndMemory ;  { Исчеpпана память }

                 End ;  { XST, YST  < X(Y)MAX }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEND >= JNBEG }

            End ;  { NRA  }

           End ; { JRA }

         End ; { JDEC }

 EndMemory : ;

     Close ( Gcvs2000File ) ;
     Close ( GcvsKeyFile  ) ;

     FileMode := 2 ;


     If ( IndCat [ CatGcvs ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatGcvs ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatGcvs ].TypeCoord := IdCoord           ;
       End ;

    End ;  { PRO GcvsFLD }

End.

