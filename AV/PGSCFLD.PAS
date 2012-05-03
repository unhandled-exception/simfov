
{$O+,F+}

UNIT PGSCFLD ;   { ВЫБОР ЗВЕЗД  GSC }
                 { ================ }


  INTERFACE



    PROCEDURE GSCFLD ;


  IMPLEMENTATION

    USES  DOS, V_CATAL, PVAR, PVarMenu, PPreNew, PMem, Check,
          PProFld, PFldGrn, Crt, MLib ;


    PROCEDURE GSCFLD ;
   {****************}


    Label EndMemory ;

    Var


         Index,
         ADECC,
         SDD,
         RAMIN, RAMax,
         RAMIN1, RAMax1, RAMIN2, RAMax2,
         R0, DRA, DECTEK,
         SRAFILD, CRAFILD, SDECFILD, CDECFILD,
         SDRA, CDRA, SDDEC, CDDEC,
         XSt, YSt,
         SRaSt, CRaSt,
         SDecSt, CDecSt,
         STEPGSCRAD,
         DecMin, DecMax,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         Mv,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         RR                     : Double  ;


         NPOZ       : Byte    ;

         NumRa,
         NumDec,
         NFildRa,
         NFildDec,
         JRa, JDec,
         NameOfDecl,
         JStar,
         JNBeg, JNEnd,
         NRa,
         NBeg , NEnd,
         CONSTDSINGSC,
         N1, N2          : LongInt ;

         GSCFileName           ,
         GSCAddFileName        ,
         GSCKeyFileName        ,
         NameDir               ,
         NameDirGscOld            : String [ 63 ] ;

         GSCFile        : File Of GSCType    ;
         GSCAddFile     : File Of GSCAddType ;
         GSCKeyFile     : File Of KeyType    ;

         GSCRecord      : GSCType            ;
         GSCAddRecord   : GSCAddType         ;



     Begin  { PRO STARFLD }
            { *********** }

        NameDirGscOld    := ''    ;
        NameCatTekExist  := False ;

        FileMode := 0 ;


        CONSTDSINGSC := Trunc ( 65535.0 / C20 / ( STEPRAD / C20 ) ) ;
        STEPGSCRAD   := 7.5 / RG ;

        N1 := 1 ;
        While ( N1 <= Length ( ParamDir.GscDir ) )  Do
          Begin
            ParamDir.GscDir [ N1 ] := UpCase ( ParamDir.GscDir [ N1 ] ) ;
            Inc ( N1 ) ;
          End ;


        If ( Pos ( 'GSC_RED', ParamDir.GscDir ) > 0 )
          Then  GscNew := True
          Else  GscNew := False ;


        IndCat [ CatGsc ].RoDet := Param.RoGscDet ;


        FldGrn ( CatGsc, 0.0, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;



	For  JDEC := 1 To  NUMDEC  Do
         Begin  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;


          NFILDDEC := Trunc ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDECFILD := SinDecFild [ NFILDDEC ] ;
          CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;


           { Опpеделение имени диpектоpии GSC }
           { -------------------------------- }


          NameOfDecl := Trunc ( Abs ( DECTEK / STEPGSCRAD ) ) ;
          NameOfDecl := 750 * NameOfDecl  ;

          Str ( NameOfDecl : 5 , NameDir ) ;
          If  ( NameDir [ 4 ] = '5' )  Then
            NameDir [ 4 ] := '3' ;

          If ( DECTEK < 0.0 )
            Then  NameDir [ 1 ] := 'S'
            Else  NameDir [ 1 ] := 'N' ;

          If ( Abs ( NameOfDecl ) = 750 ) Then
            NameDir [ 2 ] := '0' ;

          If ( Abs ( NameOfDecl ) =   0 ) Then
               For JRA := 2 To 5 Do  NameDir [ JRA ] := '0' ;



          If ( NameDir <> NameDirGscOld )  Then
            Begin  { Hовая зона GSC }
                   { -------------- }

              {
              GSCFileName    :=  ParamDir.GscDir + '\'
                                                 + CatFile.GSCFileName    ;
              GSCAddFileName :=  ParamDir.GscDir + '\'
                                                 + CatFile.GSCAddFileName ;
              GSCKeyFileName :=  ParamDir.GscDir + '\'
                                                 + CatFile.GSCKeyFileName ;
              }

              GSCFileName    :=  ParamDir.GscDir + '\=====\GSC.SRT' ;
              GSCAddFileName :=  ParamDir.GscDir + '\=====\GSC.ADD' ;
              GSCKeyFileName :=  ParamDir.GscDir + '\=====\GSC.GRN' ;


              NPOZ := Pos ( '=' , GSCFileName ) ;
              For JRA := 1 To 5 Do
                  GSCFileName [ JRA + NPOZ - 1 ] := NameDir [ JRA ] ;

              NPOZ := Pos ( '=' , GSCAddFileName ) ;
              For JRA := 1 To 5 Do
                  GSCAddFileName [ JRA + NPOZ - 1 ] := NameDir [ JRA ] ;


              NPOZ := Pos ( '=' , GSCKeyFileName ) ;
              For JRA := 1 To 5 Do
                  GSCKeyFileName [ JRA + NPOZ - 1 ] := NameDir [ JRA ] ;




                    { Откpытие новых файлов }
                    { --------------------- }

              If (     ( FSearch ( GSCFileName   , '' ) <> '' )
                   And ( FSearch ( GSCKeyFileName, '' ) <> '' )  )
               Then
                Begin   { Файлы текущего каталога есть }
                        { ---------------------------- }

                  {$I-} Reset( GSCFile );  {$I+}
                  If ( IOResult = 0 ) Then
                    Close ( GSCFile );

                  {$I-} Reset( GSCAddFile );  {$I+}
                  If ( IOResult = 0 ) Then
                    Close ( GSCAddFile );

                  {$I-} Reset( GSCKeyFile );  {$I+}
                  If ( IOResult = 0 ) Then
                    Close ( GSCKeyFile );



                  Assign ( GSCFile     , GSCFileName    )  ;
                  {$I-} Reset  ( GSCFile  ) ;  {$I+}

                  If ( IOResult = 0 ) Then
                    Begin  { Gsc Exist }
                      Assign ( GSCKeyFile  , GSCKeyFileName )  ;
                      {$I-} Reset  ( GSCKeyFile ) ;  {$I+}
                      If ( IOResult = 0 ) Then
                          Begin { GscKey Exist }
                            NameCatTekExist  :=  True    ;
                            NameDirGscOld    :=  NameDir ;
                          End
                        Else
                          Begin { GscKey Not Exist }
                            NameCatTekExist  :=  False  ;
                            NameDirGscOld    :=  ''     ;
                          End ;
                    End
                   Else
                    Begin  { Gsc Not Exist }
                      NameCatTekExist  :=  False  ;
                      NameDirGscOld    :=  ''     ;
                    End ;

                  If ( NameCatTekExist )  Then
                    Begin
                      Assign ( GSCAddFile , GSCAddFileName   )  ;
                      {$I-} Reset  ( GSCAddFile )  ; {$I+}
                      If ( IOResult = 0 )
                         Then
                           Begin
                             GscAddExist := True ;
                           End
                         Else
                             GscAddExist := False ;
                    End
                   Else
                      GscAddExist :=  False  ;

                     {$I+}

                End     { Файлы текущего каталога есть }
                        { ---------------------------- }
               Else

                Begin   { Файлов текущего каталога нет }
                        { ---------------------------- }

                  NameCatTekExist := False ;

                End ;   { Файлов текущего каталога нет }
                        { ---------------------------- }

            End    { Hовая зона GSC }
                   { -------------- }
           Else

             NameCatTekExist := True ;  { Есть стаpая зона }



          If ( NameCatTekExist )  Then
          Begin  { NameCatTekExist }

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


              { ВЫЧИСЛЕНИЕ НАЧАЛА И КОНЦА ИНФОРМАЦИИ В КАТАЛОГЕ }
              { ----------------------------------------------- }


	    NBEG :=        Trunc ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + Trunc ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        Trunc ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + Trunc ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            For  NRA := NBEG  To  NEND  Do
            Begin  { NRA }

             Seek ( GSCKeyFile , NRA       ) ;
             Read ( GSCKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

             Read ( GSCKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;



	    If ( JNEND >= JNBEG )  Then
            Begin { JEND >= JNBEG }

             NFILDRA := Trunc ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  ПРОСМОТР  ЗВЕЗД  GSC  }
                {  ====================  }


             Seek ( GSCFile , JNBEG - 1 ) ;


	     For  JSTAR := JNBEG  To  JNEND  Do
             Begin  { JSTAR }

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

              Read ( GSCFile , GSCRecord) ;

              MV :=  GSCRecord.MV / C100 - 4.0 ;

              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax )
                   (*
                   And ( GSCRecord.Class <> 5 { Artifact } )
                   *)
                                                              ) Then
              Begin  { MV <= MVMAX }


               SDRA   := GSCRecord.SDRA  / CONSTDSINGSC ;
               SDDEC  := GSCRecord.SDDEC / CONSTDSINGSC ;

               CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
               CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;

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
                             { ------------------- }


                       If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                             CBlock :=  NumberOfStars Div ObjectBlockSize ;

                       If (    ( BlockAllocFlag [ CBlock ] )
                            Or (  AllocBlock               )  )  Then
                            Begin

                             If ( IndCat [ CatGsc ].NBEG = -1 )  Then
                                  IndCat [ CatGsc ].NBEG := NumberOfStars ;

                             With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                           [NumberOfStars Mod ObjectBlockSize]
                             Do
                                Begin  { Очередная звезда }
                                       { ---------------- }

				     X	    :=  XST ;
				     Y	    :=  YST ;

				     M	    :=  Round ( ( MV + 5 ) * 10 ) ;

                                     If ( GscAddExist )
                                       Then
                                         Begin

                                           Seek ( GSCAddFile , JStar - 1    );
                                           Read ( GSCAddFile , GSCAddRecord );

                                           NRecC := GscAddRecord.NumGsc ;
                                           Date  := GscAddRecord.Date   ;

                                           If ( GscNew )
                                             Then
                                               Begin
                                                 Date  := GscAddRecord.Date ;
                                               End
                                             Else
                                               Begin
                                                 If ( GscAddRecord.Date = 0 )
                                                   Then RR := 1951.487
                                                   Else RR := GscAddRecord.Date / C10000 + 1970.0 ;
                                                 Date := Round (
                                                  ( RR - 1950.0 ) * C10000 ) ;
                                               End ;
                                         End
                                       Else
                                         Begin
                                           NRecC :=     1 ;
                                           Date  := 14000 ;
                                         End ;

                                     Sp := 80 + GscRecord.Class ;
                                     {
                                     If (     ( B_SURF )
                                          And ( SH < 0 )
                                          And ( NOT B_GEOC )  )
                                       Then
                                         NumberOfStars := NumberOfStars - 1 ;
                                     }

                              End ;   { Очередная звезда }
                                      { ---------------- }

                              NumberOfStars  :=  NumberOfStars  +   1 ;


                            End   { Блок выделен }
                                  { ------------ }
                          Else

                              GoTo EndMemory ;  { Исчеpпана память }
                                                { ---------------- }

                      End ;  { XST, YST  < X(Y)MAX }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEND >= JNBEG }

            End ; { NRA  }

           End ; { JRA }

          End ; { NameCatTekExist }

         End ; { JDEC }

 EndMemory : ;

     If ( IndCat [ CatGsc ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatGsc ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatGsc ].TypeCoord := IdCoord           ;
       End ;



     NameDirGscOld := '';


     {$I-} Reset( GSCFile );  {$I+}
     If ( IOResult = 0 )  Then
       Close ( GSCFile );

     {$I-} Reset( GSCAddFile );  {$I+}
     If ( IOResult = 0 )  Then
       Close ( GSCAddFile );

     {$I-} Reset( GSCKeyFile );  {$I+}
     If ( IOResult = 0 )  Then
       Close ( GSCKeyFile );

     FileMode := 2 ;


    End ;  { PRO SAOFLD }

End.

