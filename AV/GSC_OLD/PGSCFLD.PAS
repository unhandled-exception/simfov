

{$O+,F+}

UNIT PGSCFLD ;   { ÇõÅéê áÇÖáÑ  GSC }
                 { ================ }


  INTERFACE

    USES  DOS, V_CATAL, PVAR, PVarMenu, PPreNew, PMem, Check ;


    PROCEDURE GSCFLD ;


  IMPLEMENTATION


    PROCEDURE GSCFLD ;
   {****************}


    LABEL EndMemory ;



     BEGIN  { PRO STARFLD }
            { *********** }


        IndCat [ CatGsc ].RoDet := Param.RoGscDet ;

        CONSTDSINGSC := TRUNC ( 65535.0 / 2.0 / ( STEPRAD / 2.0 ) ) ;
        STEPGSCRAD   := 7.5 / RG ;


            RAOPTFLD   := RAOPT   ;
            DECLOPTFLD := DECLOPT ;

            PRENew ( JDATEFLD, JdGscCat, RAOPTFLD, DECLOPTFLD );
           {==================================================}

            SDECLOPTFLD := SIN ( DECLOPTFLD ) ;
            CDECLOPTFLD := COS ( DECLOPTFLD ) ;

            SRAOPTFLD   := SIN ( RAOPTFLD   ) ;
            CRAOPTFLD   := COS ( RAOPTFLD   ) ;





              { ******************** }

              { ****    G S C   **** }

              { ******************** }




        { éèêÖÑÖãÖçàÖ ÉêÄçàñ éÅãÄëíà Ç äÄíÄãéÉÖ }
        { ************************************* }


            NUMRA  := 1 ;
            ADECC  := ABS ( DECLOPTFLD ) ;

            DECMIN := DECLOPTFLD - ROMAX ;
            DECMAX := DECLOPTFLD + ROMAX ;


	    IF ( ADECC  >  DECCKR )  THEN

              BEGIN  {  POL  }
                     { ----- }


                  SDD := CROMAX * ABS ( SDECLOPTFLD ) ;
                  SDD := SDD - SROMAX * CDECLOPTFLD * YMAX / XMAX ;

	          DECMIN := ARCTAN ( SDD / SQRT ( 1.0 - SDD * SDD ) ) ;
	          DECMAX := ABS ( DECLOPTFLD ) + ROMAX ;

                  IF ( DECLOPTFLD < 0.0 )  THEN

                     BEGIN

                      DECMAX := - DECMIN ;
                      DECMIN := - R90    ;

                     END

                   ELSE


                     DECMAX := R90 ;


 	          RAMIN1 := 0.0;
	          RAMAX1 := R359;

              END  { ABS ( DECLOPTFLD ) > DECCKR }

            ELSE

              BEGIN  { NO POLE }
                     { ------- }

                DRA := SROMAX / CDECLOPTFLD;
	        DRA := ARCTAN ( DRA / SQRT ( 1.0 - DRA * DRA ) );

	        RAMIN1 := RAOPTFLD - DRA;
	        RAMAX1 := RAOPTFLD + DRA;


	        IF ( RAMIN1 <  0.0 )  THEN  RAMIN1 := RAMIN1 + R360;
	        IF ( RAMAX1 > R360 )  THEN  RAMAX1 := RAMAX1 - R360;

	        IF ( RAMIN1 > RAMAX1 )  THEN

                  BEGIN  { RAMIN1 > RAMAX1 }

	            RAMIN2 := RAMIN1;
	            RAMIN1 := 0.0;
	            RAMAX2 := R359;
	            NUMRA  := 2;

                  END ;  { RAMIN1 > RAMAX1 }

              END ;  { ABS ( DECLOPTFLD )  <=  DECCKR }



             {  èêÖñÖëëàéHHõÖ èéëíéüHHõÖ  H é Ç õ Ö  }
             {  ===================================  }

            T   := ( JdGscCat - 2451545.0 ) / 36525.0 ;
            DT  := ( JDATEFLD - JdGscCat  ) / 36525.0 ;

            T2  := T   * T  ;
            DT2 := DT  * DT ;
            DT3 := DT2 * DT ;

            S2  :=      ( 2306.2181  + 1.39656  * T   - 0.000139 * T2) * DT  ;
            S1  := S2 + (    0.30188 - 0.000344 * T ) * DT2 + 0.017998 * DT3 ;
            S3  := S2 + (    1.09468 + 0.000066 * T ) * DT2 + 0.018203 * DT3 ;
            S2  :=      ( 2004.3109  - 0.85330  * T - 0.000217 * T2)   * DT  ;
            S2  := S2 - (    0.42665 + 0.000217 * T ) * DT2 - 0.041833 * DT3 ;

            S1  := S1 / SekRad ;
            S2  := S2 / SekRad ;
            S3  := S3 / SekRad ;

            C1  := COS ( S1 ) ;
            C2  := COS ( S2 ) ;
            C3  := COS ( S3 ) ;

            S1  := SIN ( S1 ) ;
            S2  := SIN ( S2 ) ;
            S3  := SIN ( S3 ) ;



	    N1 := TRUNC ( ( DECMIN * RG + 90.0 ) / STEPGR ) - 1;
	    N2 := TRUNC ( ( DECMAX * RG + 90.0 ) / STEPGR ) - 1;

	    NUMDEC := N2 - N1 + 1;


        { äéçÖñ  éèêÖÑÖãÖçàü  ÉêÄçàñ  éÅãÄëíà  Ç  äÄíÄãéÉÖ }
        { ------------------------------------------------ }



	FOR  JDEC := 1 TO  NUMDEC  DO

         BEGIN  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;


          NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDECFILD := SinDecFild [ NFILDDEC ] ;
          CDECFILD := SQRT ( 1.0 - SDECFILD * SDECFILD ) ;


           { éØp•§•´•≠®• ®¨•≠® §®p•™‚Æp®® GSC }
           { -------------------------------- }


          NameOfDecl := TRUNC ( ABS ( DECTEK / STEPGSCRAD ) ) ;
          NameOfDecl := 750 * NameOfDecl  ;

          Str ( NameOfDecl : 5 , NameDir ) ;
          IF  ( NameDir [ 4 ] = '5' )  THEN  NameDir [ 4 ] := '3' ;

          IF ( DECTEK < 0.0 )  THEN  NameDir [ 1 ] := 'S'
                               ELSE  NameDir [ 1 ] := 'N' ;

          IF ( ABS ( NameOfDecl ) = 750 ) THEN  NameDir [ 2 ] := '0' ;

          IF ( ABS ( NameOfDecl ) =   0 ) THEN
               FOR JRA := 2 TO 5 DO  NameDir [ JRA ] := '0' ;



          IF ( NameDir <> NameDirGscOld )  THEN

            BEGIN  { HÆ¢†Ô ßÆ≠† GSC }
                   { -------------- }


              GSCFileName    :=  ParamDir.GscDir + CatFile.GSCFileName    ;
              GSCKeyFileName :=  ParamDir.GscDir + CatFile.GSCKeyFileName ;

              NPOZ := Pos ( '=' , GSCFileName ) ;
              FOR JRA := 1 TO 5 DO
                  GSCFileName [ JRA + NPOZ - 1 ] := NameDir [ JRA ] ;


              NPOZ := Pos ( '=' , GSCKeyFileName ) ;
              FOR JRA := 1 TO 5 DO
                  GSCKeyFileName [ JRA + NPOZ - 1 ] := NameDir [ JRA ] ;




                    { é‚™pÎ‚®• ≠Æ¢ÎÂ ‰†©´Æ¢ }
                    { --------------------- }

              IF (  ( FSearch(GSCFileName   , '' ) <> '' )  AND
                    ( FSearch(GSCKeyFileName, '' ) <> '' )  )
                THEN

                BEGIN   { î†©´Î ‚•™„È•£Æ ™†‚†´Æ£† •·‚Ï }
                        { ---------------------------- }

                     {$I-}

                  Reset( GSCFile );
                  If ( IOResult = 0 ) Then  Close ( GSCFile );
                  Reset( GSCKeyFile );
                  If ( IOResult = 0 ) Then  Close ( GSCKeyFile );


                  Assign ( GSCFile     , GSCFileName    )  ;
                  Reset  ( GSCFile    )                    ;

                  If ( IOResult = 0 ) Then
                    Begin  { Gsc Exist }
                      Assign ( GSCKeyFile  , GSCKeyFileName )  ;
                      Reset  ( GSCKeyFile )                    ;
                      If ( IOResult = 0 ) Then
                          Begin { GscKey Exist }
                            NameCatTekExist  :=  True    ;
                            NameDirGscOld    :=  NameDir ;
                          End
                        Else
                          Begin { GscKey Not Exist }
                            NameCatTekExist  :=  False  ;
                            NameDirGscOld    :=  ''     ;
                            Close ( GSCFile  )          ;
                          End ;
                    End
                   Else
                    Begin  { Gsc Not Exist }
                      NameCatTekExist  :=  False  ;
                      NameDirGscOld    :=  ''     ;
                    End ;

                     {$I+}

                END     { î†©´Î ‚•™„È•£Æ ™†‚†´Æ£† •·‚Ï }
                        { ---------------------------- }


               Else

                Begin   { î†©´Æ¢ ‚•™„È•£Æ ™†‚†´Æ£† ≠•‚ }
                        { ---------------------------- }

                  NameCatTekExist := False ;

                End ;   { î†©´Æ¢ ‚•™„È•£Æ ™†‚†´Æ£† ≠•‚ }
                        { ---------------------------- }

            END    { HÆ¢†Ô ßÆ≠† GSC }
                   { -------------- }
           Else

             NameCatTekExist := True ;  { Ö·‚Ï ·‚†p†Ô ßÆ≠† }



          IF ( NameCatTekExist )  THEN
          BEGIN  { NameCatTekExist }

	  FOR  JRA := 1  TO  NUMRA  DO

           BEGIN  { JRA }

	    IF ( JRA = 2 )  THEN
              BEGIN { JRA = 2 }
		RAMIN := RAMIN2;
		RAMAX := RAMAX2;
              END  { JRA = 2 }
             ELSE
              BEGIN  { JRA <> 2 }
		RAMIN := RAMIN1;
		RAMAX := RAMAX1;
	      END ;  { JRA <> 2 }


              { ÇõóàëãÖçàÖ çÄóÄãÄ à äéçñÄ àçîéêåÄñàà Ç äÄíÄãéÉÖ }
              { ----------------------------------------------- }


	    NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
            NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	    NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	    NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


            FOR  NRA := NBEG  TO  NEND  DO

            BEGIN  { NRA }

             Seek ( GSCKeyFile , NRA       ) ;
             Read ( GSCKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

             Read ( GSCKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;



	    IF ( JNEND >= JNBEG )  THEN

            BEGIN { JEND >= JNBEG }

             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  èêéëåéíê  áÇÖáÑ  GSC  }
                {  ====================  }


             Seek ( GSCFile , JNBEG - 1 ) ;


	     FOR  JSTAR := JNBEG  TO  JNEND  DO

             BEGIN  { JSTAR }

              Read ( GSCFile , GSCRecord) ;

              MV := ( GSCRecord.MV Div 2 ) / 10.0 + 4.0 ;

              IF ( MV <= MVMAX )  THEN
              BEGIN  { MV <= MVMAX }


               SDRA   := GSCRecord.SDRA  / CONSTDSINGSC ;
               SDDEC  := GSCRecord.SDDEC / CONSTDSINGSC ;

               CDRA   := SQRT ( 1.0 - SDRA  * SDRA  ) ;
               CDDEC  := SQRT ( 1.0 - SDDEC * SDDEC ) ;

               SR     := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
               CR     := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

               SD     := SDECFILD * CDDEC + CDECFILD * SDDEC ;
               CD     := CDECFILD * CDDEC - SDECFILD * SDDEC ;


                   { èêÖñÖëëàü }
                   { --------- }

               X  :=  CR  *  CD  ;
               Y  :=  SR  *  CD  ;
               Z  :=         SD  ;

               XX := X * C1 - Y * S1 ;
               YY := X * S1 + Y * C1 ;
               ZZ := Z               ;

               X   := XX * C2 - ZZ * S2 ;
               Y   := YY                ;
               Z   := XX * S2 + ZZ * C2 ;

               XX  := X * C3 - Y * S3 ;
               YY  := X * S3 + Y * C3 ;
               ZZ  := Z               ;

               SD := ZZ ;
               CD := SQRT ( 1 - SD * SD ) ;
               SR := YY / CD ;
               CR := XX / CD ;

                   {  --- * ---  }

               CT := CSTIME * CR   + SSTIME * SR ;
               ST := SSTIME * CR   - CSTIME * SR ;


               SH := SD * SFIS + CD * CFIS * CT ;

               SA :=   CD * ST ;
               CA := - SD * CFIS + CD * SFIS * CT ;


  	       CDA :=  CA * CAOPT   +   SA * SAOPT  ;
               CRO :=  SH * SHOPT   +  CDA * CHOPT  ;


	       IF  ( CRO >= CROMAX )   THEN

                  BEGIN  { CRO >= CROMAX }
                         { ------------- }


		     SDA   := SAOPT * CA - CAOPT  * SA  ;

		     SPOZ  := SDA ;
		     CPOZ  := SH * CHOPT - SHOPT  * CDA ;

	             YST   :=   FD * CPOZ / CRO ;
		     XST   := - FD * SPOZ / CRO ;


                     IF ( NPOLFIX )   THEN

                       BEGIN { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }
                             { ------------------------------------ }

                          INDEX := XST ;

                          XST :=    XST  * CPOZNP  +  YST * SPOZNP ;
                          YST := - INDEX * SPOZNP  +  YST * CPOZNP ;

                       END ;



                     IF ( (ABS(XST) < XMAX)
                      AND (ABS(YST) < YMAX) )  THEN

                      BEGIN  { XST, YST  < X(Y)MAX }
                             { ------------------- }


                       IF  ( NumberOfStars mod ObjectBlockSize = 0 )  Then
                             CBlock :=  NumberOfStars Div ObjectBlockSize ;

                       If (    ( BlockAllocFlag [ CBlock ] )
                            Or (  AllocBlock               )  )  Then

                            BEGIN

                             If ( IndCat [ CatGsc ].NBEG = -1 )  Then
                                  IndCat [ CatGsc ].NBEG := NumberOfStars ;

                             with ObjectPtr[NumberOfStars div ObjectBlockSize]^
                                           [NumberOfStars mod ObjectBlockSize]
                             do begin  { éÁ•‡•§≠†Ô ß¢•ß§† }
                                       { ---------------- }

				     X	      :=  XST ;
				     Y	      :=  YST ;

				     M	      :=  Round ( ( MV + 5 ) * 10 ) ;


				     NRecC := GscRecord.Date  ;

                                     IF ( GSCRecord.Mv Mod 2 = 0 )
                                       THEN
                                           Sp :=  80      { Star }
                                         ELSE
                                           Sp :=  81 ;    { Non Star}


                                     IF (     ( B_SURF )
                                          AND ( SH < 0 )
                                          AND ( NOT B_GEOC )  )  THEN

                                       Begin

                                         NumberOfStars := NumberOfStars - 1 ;

                                       End ;

                              end ;   { éÁ•‡•§≠†Ô ß¢•ß§† }
                                      { ---------------- }


                              NumberOfStars  :=  NumberOfStars  +   1 ;


                            END   { Å´Æ™ ¢Î§•´•≠ }
                                  { ------------ }
                          ELSE

                              GOTO EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                                { ---------------- }

                      END ;  { XST, YST  < X(Y)MAX }

                  END ;  { CRO >= CROMAX }

              END ;  { MV < MVMAX }

             END ; { JSTAR }

            END ; { JEND >= JNBEG }

            END ; { NRA  }

           END ; { JRA }

          END ; { NameCatTekExist }

         END ; { JDEC }

 EndMemory : ;

     If ( IndCat [ CatGsc ].NBEG <> -1 )  Then
          IndCat [ CatGsc ].NEND := NumberOfStars - 1 ;


    END ;  { PRO SAOFLD }

END.

