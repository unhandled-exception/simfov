
{$O+,F+}

Unit PImpFld ;   { ÇõÅéê áÇÖáÑ  àá îÄâãÄ }
                 { ===================== }


  InterFace

    Uses  PVAR, V_CATAL, PMem, PPreNew, PProFld ;


    Procedure ImpFld ;


  Implementation


    Procedure ImpFld ;
   {*****************}


    Label EndMemory ,
          ExtraFld   ;

    Var

         Index,
         Mv,
         SRaSt, CRaSt,
         SDecSt, CDecSt,
         XSt, YSt,
         XMaxImp,
         Lx, Ly,
         SP, CP,
         SG, CG,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         TGRO,
         DTMU,
         P,S,
         RaNp1, DeclNp1, SPozNp1, CPozNp1,
         Cs, Ss,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         MR, MD, PMX, PMY                          : Double  ;

         JStar,
         JNBeg, JNEnd                              : LongInt ;

     Begin  { PRO STARFLD }


        If ( B_X_Max )  Then
           XMaxImp := - 1000001.0 ;

        NPolFix := True ;

        DtMu := ( JDate - JdEp ) / 365.25 ;


          { èÆß®Ê®Æ≠≠Î© „£Æ´ ë•¢•p≠Æ£Æ èÆ´Ó·† }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

        Povorot ( JdEp , SPozNp1 , CPozNp1 ) ;

        IndCat [ CatImp ].JdCat   := JdEp    ;

        IndCat [ CatImp ].SPozNp1 := SPozNp1 ;
        IndCat [ CatImp ].CPozNp1 := CPozNp1 ;


        RaOptFld   := RaOpt   ;
        DeclOptFld := DeclOpt ;

        PRENew ( JDateFld, JdEp, RaOptFld, DeclOptFld );
       {===============================================}

        SDeclOptFld := Sin ( DeclOptFld ) ;
        CDeclOptFld := COS ( DeclOptFld ) ;

        SRaOptFld   := Sin ( RaOptFld   ) ;
        CRaOptFld   := COS ( RaOptFld   ) ;

        IndCat [ CatImp ].SRaOpt    := SRaOptFld   ;
        IndCat [ CatImp ].CRaOpt    := CRaOptFld   ;
        IndCat [ CatImp ].SDeclOpt  := SDeclOptFld ;
        IndCat [ CatImp ].CDeclOpt  := CDeclOptFld ;


		{  èêéëåéíê  áÇÖáÑ  }
                {  ================ }

        {
        Reset ( ImportStarFile ) ;
        }
        Seek ( ImportStarFile, 0 ) ;

        For  JStar := 1  To  Nof  Do
          Begin  { JSTAR }
                 { ----- }

            Read ( ImportStarFile , OFRecord ) ;

            Mv := OFRecord.MV / 10.0 - 5.0 ;

            If (     ( Mv >= MvMin )
                 And ( Mv <= MvMax ) )  Then
              Begin  { MV <- MVMAX }


               SRaSt  := Sin ( OFRecord.Ra ) ;
               CRaSt  := Cos ( OFRecord.Ra ) ;

               SDecSt := Sin ( OFRecord.Decl ) ;
               CDecSt := Cos ( OFRecord.Decl ) ;


	       CDA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SDA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;

	       CRO := SDeclOptFld * SDecSt  +  CDeclOptFld * CDecSt * CDA ;

               {
	       SPoz  := CDecSt * SDA ;
	       CPoz  := SDecSt * CDeclOptFld - CDecSt * SDeclOptFld * CDA ;


	       XSt := - FD * SPoz / CRO ;
	       YSt :=   FD * CPoz / CRO ;
               }

               {
               MR := OFRecord.PmRa   * DtMu ;
               MD := OFRecord.PmDecl * DtMu ;

               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;
               }

               XRect := CRaSt * CDecSt ;
               YRect := SRaSt * CDecSt ;
               ZRect := SDecSt         ;

               X1 := - XRect * SRaOptFld + YRect * CRaOptFld ;
               Y1 := - XRect * CRaOptFld - YRect * SRaOptFld ;
               Z1 :=   ZRect                       ;

               X2 :=   X1                          ;
               Y2 :=   Y1 * SDeclOptFld + Z1 * CDeclOptFld     ;
               Z2 := - Y1 * CDeclOptFld + Z1 * SDeclOptFld     ;

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




               If ( B_X_Max )  Then
                 Begin

                   If ( Abs ( XSt ) > XMaxImp )  Then
                                      XMaxImp := Abs ( XSt ) ;
                   If ( Abs ( YSt ) > XMaxImp )  Then
                                      XMaxImp := Abs ( YSt ) ;
                 End  ;



               If ( Not ( B_X_Max                    )
                      And (     ( ABS ( XSt ) > XMAX )
                             Or ( ABS ( YSt ) > YMAX ) ) )  Then
                   GoTo  ExtraFld ;


               If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                         CBlock :=  NumberOfStars Div ObjectBlockSize ;

               If (    ( BlockAllocFlag [ CBlock ] )
                    Or (  AllocBlock               )  )  Then
                       Begin

                         With ObjectPtr [ NumberOfStars Div ObjectBlockSize]^
                                        [ NumberOfStars Mod ObjectBlockSize] Do
                            Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }

			      X	 := XSt ;
			      Y	 := YSt ;

                              Sp := 50  ;

                              If ( OFRecord.MV > 250 )
                                Then
                                  M := 255
                                Else
			          M := OFRecord.MV ;

			      NRecC := JStar ;


                            End  ;

                          If ( IndCat [ CatImp ].NBEG = -1 )  Then
                               IndCat [ CatImp ].NBEG := NumberOfStars ;

                          Inc ( NumberOfStars ) ;

                       End    { Å´Æ™ ¢Î§•´•≠ }
                              { ------------ }
                      Else  GoTo EndMemory ;  { à·Á•pØ†≠† Ø†¨Ô‚Ï }
                                              { ---------------- }

 ExtraFld  : ;

              End    { MV <- MVMAX }

          End  ; { JSTAR }


 EndMemory : ;


     If  ( B_X_Max )  Then

       Begin { ÇÎÁ®·´•≠®• p†ß¨•pÆ¢ ØÆ´Ô Øp® Æ‚Æ¶§•·‚¢´•≠®® ®¨ØÆp‚≠ÎÂ }
             { ----------------------------------------------------- }


         XMax := XMaxImp ;

         FldX := ArcTan  ( XMax  / FD ) * C20 + 20 /C36000 * GR ;
         FldX := FldX + RDetImp * C20 / C36000 * GR ;  { + 2 RDetImp }
                                                       { ----------- }
         FldY := FldX ;

         PARCONST.WG := FldX / GR ;
         PARCONST.HG := FldY / GR ;

         RRX    := FLDX ;
         RRY    := FLDY ;

         RRX    := RRX / 2 ;
         RRY    := RRY / 2 ;

         XMAX   := FD * SIN ( FLDX / C20 ) / COS ( FLDX / C20 ) ;
         YMAX   := XMAX ;

         LX     := XMAX * C20 ;
         LY     := YMAX * C20 ;

         XMAXGR := FLDX / C20 / GR ;
         YMAXGR := FLDY / C20 / GR ;

         DHMAX  := FLDY / C20 ;

         ROMAX  := ARCTAN  (  SQRT (  XMAX * XMAX  +  YMAX * YMAX  ) / FD  ) ;

         CROMAX := COS  ( ROMAX ) ;
         SROMAX := SIN  ( ROMAX ) ;

         DECCKR := R90 - ROMAX ;


       End  ; { ÇÎÁ®·´•≠®• p†ß¨•pÆ¢ ØÆ´Ô Øp® Æ‚Æ¶§•·‚¢´•≠®® ®¨ØÆp‚≠ÎÂ }
             { ----------------------------------------------------- }


     If ( IndCat [ CatImp ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatImp ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatImp ].TypeCoord := IdCoord           ;
       End ;

    End  ;  { PRO ImpFld }


End .

