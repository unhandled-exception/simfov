
{$O+,F+}

Unit PA20Fld ;   { ВЫБОР ЗВЕЗД  A20 }
                 { ================ }


  InterFace



    Procedure A20Fld ;


  Implementation

    Uses  DOS, V_CATAL, PVAR, PVarMenu, PPreNew, PMem, Check,
          PProFld, PFldGrn, Crt, MLib ;


    Procedure A20Fld ;
   {****************}


    Label EndMemory ;

    Const StepDm = 0.7 ;

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
         STEPA20RAD,
         DecMin, DecMax,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         RR                     : Double  ;


         ErrM,
         NumbS,
         NPOZ            : Byte    ;

         IndSp,
         Mv,
         Mr, Nf          : Integer ;

         NRec,
         MvAbs,
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
         CONSTDSINA20,
         N1, N2          : LongInt ;

         A20FileName           ,
         A20KeyFileName        ,
         NameDir               ,
         NameDirA20Old            : String [ 63 ] ;

         A20Record  : A20Type ;

         L1000      : LongInt ;
         L1000000   : LongInt ;
         L10000000  : LongInt ;


         A20File    : File Of A20Type  ;
         A20KeyFile : File Of KeyType  ;


     Begin  { PRO STARFLD }
            { *********** }


        L1000      := 1000     ;
        L1000000   := 1000000  ;
        L10000000  := 10000000 ;


        NameDirA20Old    := ''    ;
        NameCatTekExist  := False ;

        FileMode := 0 ;


        IndCat [ CatA20 ].RoDet := Param.RoGscDet ;

        ConstDSinA20 := Trunc ( 65535.0 / C20 / ( StepRad / C20 ) ) ;
        StepA20Rad   := 7.5 / RG ;


        FldGrn ( CatA20, 0.0, NumRa, NumDec,
                 DecMin, DecMax,
                 RaMin1, RaMax1, RaMin2, RaMax2  ) ;



	For  JDEC := 1 To  NUMDEC  Do
         Begin  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;


          NFILDDEC := Trunc ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDECFILD := SinDecFild [ NFILDDEC ] ;
          CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;


           { Опpеделение имени диpектоpии A20 }
           { -------------------------------- }


          NameOfDecl := Trunc ( Abs ( DECTEK / STEPA20RAD ) ) ;
          NameOfDecl := 750 * NameOfDecl  ;


          Str ( NameOfDecl : 5 , NameDir ) ;
          If  ( NameDir [ 4 ] = '5' )  Then
            NameDir [ 4 ] := '3' ;


          NumbS := 0 ;

          If ( DECTEK < 0.0 )
            Then
              Begin

                NameDir [ 1 ] := 'S' ;

              End
            Else
                NameDir [ 1 ] := 'N' ;

          If ( Abs ( NameOfDecl ) = 750 ) Then
            NameDir [ 2 ] := '0' ;

          If ( Abs ( NameOfDecl ) =   0 ) Then
             For JRA := 2 To 5 Do  NameDir [ JRA ] := '0' ;


          If ( NameDir > 'S0730' )
            Then  NumbS := 1
            Else  NumbS := 0 ;




          If ( NameDir <> NameDirA20Old )  Then
            Begin  { Hовая зона A20 }
                   { -------------- }

              {
              A20FileName    :=  ParamDir.A20Dir + '\'
                                                 + CatFile.A20FileName    ;
              A20KeyFileName :=  ParamDir.A20Dir + '\'
                                                 + CatFile.A20KeyFileName ;
              }
              A20FileName    :=  ParamDir.A20Dir + '\=====\A_2_0.SRT' ;
              A20KeyFileName :=  ParamDir.A20Dir + '\=====\A_2_0.GRN' ;

              NPOZ := Pos ( '=' , A20FileName ) ;
              For JRA := 1 To 5 Do
                  A20FileName [ JRA + NPOZ - 1 ] := NameDir [ JRA ] ;


              NPOZ := Pos ( '=' , A20KeyFileName ) ;
              For JRA := 1 To 5 Do
                  A20KeyFileName [ JRA + NPOZ - 1 ] := NameDir [ JRA ] ;




                    { Откpытие новых файлов }
                    { --------------------- }

              If (     ( FSearch ( A20FileName   , '' ) <> '' )
                   And ( FSearch ( A20KeyFileName, '' ) <> '' )  )
               Then
                Begin   { Файлы текущего каталога есть }
                        { ---------------------------- }

                  {$I-} Reset( A20File );  {$I+}
                  If ( IOResult = 0 ) Then
                    Close ( A20File );

                  {$I-} Reset( A20KeyFile );  {$I+}
                  If ( IOResult = 0 ) Then
                    Close ( A20KeyFile );



                  Assign ( A20File     , A20FileName    )  ;
                  {$I-} Reset  ( A20File  ) ;  {$I+}

                  If ( IOResult = 0 ) Then
                    Begin  { A20 Exist }
                      Assign ( A20KeyFile  , A20KeyFileName )  ;
                      {$I-} Reset  ( A20KeyFile ) ;  {$I+}
                      If ( IOResult = 0 ) Then
                          Begin { A20Key Exist }
                            NameCatTekExist  :=  True    ;
                            NameDirA20Old    :=  NameDir ;
                          End
                        Else
                          Begin { A20Key Not Exist }
                            NameCatTekExist  :=  False  ;
                            NameDirA20Old    :=  ''     ;
                          End ;
                    End
                   Else
                    Begin  { A20 Not Exist }
                      NameCatTekExist  :=  False  ;
                      NameDirA20Old    :=  ''     ;
                    End ;


                End     { Файлы текущего каталога есть }
                        { ---------------------------- }
               Else

                Begin   { Файлов текущего каталога нет }
                        { ---------------------------- }

                  NameCatTekExist := False ;

                End ;   { Файлов текущего каталога нет }
                        { ---------------------------- }

            End    { Hовая зона A20 }
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

             Seek ( A20KeyFile , NRA       ) ;
             Read ( A20KeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

             Read ( A20KeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;



	    If ( JNEND >= JNBEG )  Then
            Begin { JEND >= JNBEG }

             NFILDRA := Trunc ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  ПРОСМОТР  ЗВЕЗД  A20  }
                {  ====================  }


             Seek ( A20File , JNBEG - 1 ) ;

	     For  JSTAR := JNBEG  To  JNEND  Do
             Begin  { JSTAR }


              If ( KeyPressed )  Then
                Begin

                  KeyExist := True    ;
                  UserKey  := GetKey  ;
                  UngetCh ( UserKey ) ;

                  If ( UserKey = EscKey ) Then
                      Begin
                        EndStars := True ;
                        GoTo EndMemory ;
                      End ;

               End ;


              Read ( A20File , A20Record) ;

              MvAbs := Abs ( A20Record.M ) ;

              Mr    := MvAbs Mod 1000 ;
              MvAbs := MvAbs Div 1000 ;

              Mv    := MvAbs Mod 1000 ;
              MvAbs := MvAbs Div 1000 ;

              Nf    := MvAbs Mod 1000 ;
              MvAbs := MvAbs Div 1000 ;

              ErrM  := MvAbs Mod    2 ;


              If (     ( Mv / C100 >= MvMin )
                   And ( Mv / C100 <= MvMax )  ) Then
              Begin  { MV <= MVMAX }

               SDRA   := A20Record.SDRA  / CONSTDSINA20 ;
               SDDEC  := A20Record.SDDEC / CONSTDSINA20 ;

               CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
               CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;

               SRaSt  := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
               CRaSt  := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

               SDecSt := SDECFILD * CDDEC + CDECFILD * SDDEC ;
               CDecSt := CDECFILD * CDDEC - SDECFILD * SDDEC ;


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


                 { Deleted GSC no det A20 }
                 { ────────────────────── }

               If (     ( A20Record.M < 0 )
                    And ( Mv          = 0 )
                    And ( Nf          = 0 ) )  Then
                 XSt := XMax * C20 ;


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

                             If ( IndCat [ CatA20 ].NBEG = -1 )  Then
                                  IndCat [ CatA20 ].NBEG := NumberOfStars ;

                             With ObjectPtr[NumberOfStars Div ObjectBlockSize]^
                                           [NumberOfStars Mod ObjectBlockSize]
                             Do
                                Begin  { Очередная звезда }
                                       { ---------------- }


				     X	    :=  XST ;
				     Y	    :=  YST ;


                                     NRec := 0 ;


                                     If ( A20Record.M < 0 )  Then
                                       Begin         { GSC }

                                         NRec := NRec + L10000000 ;

                                         If (     ( Mv = 0 )
                                              And ( Nf = 0 )  )  Then
                                           Begin
                                             Mv :=  Mr ;
                                             Mr := 999 ;
                                           End ;

                                       End ;


                                     If ( Mv > 254 )  Then
                                       Begin           { Mv Too Great }
                                         Mv   := 254 ;
                                         ErrM :=   1 ;
                                       End ;

				     M := Mv  ;

                                     If ( Mr <> 999 )
                                       Then
                                         Begin
                                           If ( B_Color_A2_0 )
                                             Then
                                               Begin
                                                 IndSp := 10 *
                                                   Round ( 0.45 +
                                                   ( ( Mv - Mr ) / C100 + 0.5 )
                                                   / StepDm )
                                                 End
                                               Else
                                                 Begin
                                                   If ( Mv - Mr ) >= 23 Then
                                                     IndSp := 50 ;
                                                   If (     (( Mv - Mr ) < 23 )
                                                        And (( Mv - Mr ) > 05 ) ) Then
                                                     IndSp := 20 ;
                                                   If ( Mv - Mr ) <= 05 Then
                                                     IndSp :=  0 ;
                                                 End ;

                                           If ( IndSp < 0 )  Then
                                             IndSp := 0 ;
                                           If ( IndSp > 60 )  Then
                                             IndSp := 60 ;
                                         End
                                       Else
                                         IndSp := 70 ; { No B-R A20 Star }


                                     If ( A20Record.M < 0 )  Then
                                       Begin
                                         If (     ( Mr = 999 )
                                              And ( Nf =   0 ) )  Then
                                           IndSp := 80 ; { GSC? Star }
                                       End ;


                                     NRecC :=   NRec
                                              + Mr
                                              + NF   * L1000 ;

                                     If (     ( NumbS  =   1 )
                                          And ( Nf    <= 606 ) )  Then
                                       ErrM := ErrM + NumbS * 2 ;

                                     Sp := IndSp + ErrM ;

                                     Date  := 1 ;
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

     If ( IndCat [ CatA20 ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatA20 ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatA20 ].TypeCoord := IdCoord           ;
       End ;



     {$I-} Reset( A20File ); {$I+}
     If ( IOResult = 0 )  Then
       Close ( A20File );

     {$I-} Reset( A20KeyFile ); {$I+}
     If ( IOResult = 0 )  Then
       Close ( A20KeyFile );

     FileMode := 2 ;


    End ;  { Pro A20Fld }

End.

