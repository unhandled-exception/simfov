
{$O+,F+}


Unit PPlanet;

Interface

Procedure ShowPlanets;

Implementation

Uses
 Crt, Graph, PVar, Sort, PATan2, PProFld ;


 Var

         OldExist,
         AnnularEclipse,
         Prima,
         PointInFild,
         PointLimbFind     : Boolean ;


         PlanetColor,
         ColorPixel                 : Byte    ;

         nX,  nY,
         SxV, SyV,
         SxN, SyN,
         SxT, SyT                   : Integer ;

         XZaichik,
         YZaichik,
         ZZaichik,
         SVectX, SVectY             : Double  ;

         SxMoon,
         SyMoon,
         SxEarth,
         SyEarth,
         SxLimbEarth,
         SyLimbEarth,
         Sx  , Sy  ,
         SxPt, SyPt, RPt,
         SxOld , SyOld              : LongInt ;


         RPoint,
         RPointMax,
         dRPointMax,
         RPointMaxEartch,
         REarth,
         XX, YY, ZZ,
         XIg,  YIg,  ZIg,  RIg,
         XPl, YPL, ZPL,
         dX, dY,
         DxObj, DyObj,
         DxSc,  DySc,
         CLSObs, SLSObs,
         SDSObs, CDSObs,
         SD, CD, SR, CR,
         SH, CH, SA, CA,
         ST, CT,
         SDA, CDA,
         SPOZ, CPOZ,
         Maschtab,
         Index,
         XSt, YSt                   : Double ;


         Kvadrant : Array [ 1 ..   4 ] Of Byte ;




 Procedure IzoGrid ;
  Begin

         RPoint := Sqrt ( Sqr ( XIg ) + Sqr ( YIg ) + Sqr ( ZIg ) ) ;


         If ( RPoint <= RPointMaxEartch )  Then
           Begin  { íÆÁ™† °´®ß™Æ }

              { ë‰•p®Á•·™®• ™ÆÆp§®≠†‚Î }

              SD   := ZIg / RPoint                     ;
              CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;
              If ( CD > 2.0E-10 )  Then
                 Begin
                   SR := YIg / RPoint / CD ;
                   CR := XIg / RPoint / CD ;
                 End
               Else
                 Begin
                   SR := C10 ;
                   CR := 0.0 ;
                 End ;


              ST   := SSTime * CR  -  CSTime * SR ;
              CT   := CSTime * CR  +  SSTime * SR ;

              SH   := SD * SFiS + CD * CFiS * CT ;

              SA   :=   CD * ST ;
              CA   := - SD * CFiS + CD * SFiS * CT ;


               { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }

              CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
	      CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

              If ( CRo > 0.02 ) Then
                Begin  { CRo > 0 }

                  SDA  := SAOpt * CA  -  CAOpt  * SA ;

	          SPoz := SDA;
                  CPoz := SH * CHOpt  -  SHOpt * CDA ;

	          YSt  :=   FD * CPoz / CRo ;
	          XSt  := - FD * SPoz / CRo ;


                  If ( NPolFix )  Then
                    Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }

                      Index :=    XSt ;
                      XSt   :=    XSt  * CPozNP  +  YSt * SPozNP ;
                      YSt   := - Index * SPozNP  +  YSt * CPozNP ;

                    End ;


                  DxObj := ( XSt - CenterX ) * DxSc ;
                  DyObj := ( YSt - CenterY ) * DySc ;

                  Sx :=  Round ( dX + DxObj ) ;
                  Sy :=  Round ( dY - DyObj ) ;


                  If (     ( Sx >= Sw.x1 )
                       And ( Sx <= Sw.x2 )
                       And ( Sy >= Sw.y1 )
                       And ( Sy <= Sw.y2 ) )
                    Then

                       Begin  { Ç ØÆ´• ßp•≠®Ô }

                         SetColor ( ColorPixel ) ;

                         If ( Prima )
                           Then
                             Begin
                               PutPixel ( Sx, Sy, ColorPixel ) ;
                               Prima := False ;
                             End
                           Else
                             Begin
                               If ( OldExist )  Then
                                 Line  ( SxOld, SyOld, Sx, Sy ) ;
                             End ;

                         PointInFild := True ;

                       End   { Ç ØÆ´• ßp•≠®Ô }

                    Else

                       Begin
                         If (     ( PointInFild )
                              And ( Not Prima   ) )  Then
                            Line  ( SxOld, SyOld, Sx, Sy ) ;
                         PointInFild  := False ;
                       End ;

                    SxOld    := Sx ;
                    SyOld    := Sy ;
                    OldExist := True ;

                End ;  { CRo > 0 }

           End     { íÆÁ™† °´®ß™Æ }

         Else

           Begin
             OldExist     := False ;
             PointInFild  := False ;
           End ;


  End ; { IzoGrid }






 Procedure  ShowMateriki ( S_Planet : PlanetType ) ;
           {‹‹‹‹‹‹‹‹‹‹‹‹}

 Const

     DRTerm     = 2.0      ;
     PhaseKrit  = Pi / 30  ;
     ColorNight = DarkGray ;
     LimbNot    = - 32123  ;

     RoMinTermVizInit = 2.0e15 ;

 Var

     CenterMoon,
     MoonEclipse,
     PointExist,
     FildDay,
     PointLimbExist,
     ReIzo            : Boolean ;

     NPoz,
     NNeg,
     ColPix           : Integer ;

     I,
     SigDx,
     SigDy,
     NSat,
     SxCFld, SyCFld,
     NPointLimbViz,
     NPTermViz,
     PixColor         : Word    ;

     SxC, SyC,
     SxP, SyP,
     SxCTen, SyCTen,
     SxProxTen,
     SyProxTen        : LongInt ;

     Phase            : Single  ;

     PozSunEarth,
     SPozSunEarth,
     CPozSunEarth,
     RaSunPl,
     DeclSunPl,
     DRRadNotTerm,
     SxPoint,
     SyPoint,
     RTen, RTenMin, RTenUgl,
     LHTen, RHTen,
     SinRHTen, CosRHTen, TgRHTen,
     RTenMoon,
     RTenMoonMin,
     RPoint,
     RPl,
     R_Pl,
     PhasePl,
     XN ,  YN ,  ZN ,
     X1, Y1, Z1,
     XPlN, YPLN, ZPLN,
     XOptPl  , YOptPl   , ZOptPl   , ROptPl ,
     XOptPlN , YOptPlN  , ZOptPlN  ,
     FiPlOpt , SFiPlOpt , CFiPlOpt ,
     FiSatPlOpt, SFiSatPlOpt,
     MoonTenUgl,
     CosMoonTenUgl,
     SinMoonTenUgl,
     TgMoonTenUgl,
     CosTenUgl,
     SinTenUgl,
     TenUgl, TgTenUgl,
     XSun  , YSun  , ZSun  , RSun ,
     XPlSun, YPlSun, ZPlSun, RPlSun,
     XMoon , YMoon , ZMoon , RMoon, RMoonUgl,
     XMoonN, YMoonN, ZMoonN,
     XTen  , YTen  , ZTen  ,
     XHTen , YHTen , ZHTen ,
     XTenN , YTenN , ZTenN ,
     XSunN , YSunN , ZSunN ,
     XSun0 , YSun0 , ZSun0 ,
     XObs  , YObs  , ZObs  , RObs,
     XObsN , YObsN , ZObsN ,
     XObs0 , YObs0 , ZObs0 , RObs0,
     SXm, SYm,
     DxPix,
     DyPix,
     DxTerm,
     DyTerm,
     Xc, Yc,
     SRoPl, HOptPl,
     XpGor, YpGor, ZpGor,
     CHSunGor,
     CHSunGorMax,
     SHSunGorMax,
     HSunGor,
     R0Pl                   : Double  ;

     PSxTermVizNeg,
     PSyTermVizNeg  : Integer ;

     SxTermViz     : Array [ 0 .. 363 ] Of Integer ;
     SyTermViz     : Array [ 0 .. 363 ] Of Integer ;
     PozTermViz    : Array [ 0 .. 363 ] Of Single  ;

     SxTermNeg     : Array [ 0 .. 363 ] Of Integer ;
     SyTermNeg     : Array [ 0 .. 363 ] Of Integer ;

     SxLimbViz     : Array [ 0 .. 363 ] Of Integer ;
     SyLimbViz     : Array [ 0 .. 363 ] Of Integer ;




Procedure CalcLimb ;
         {‹‹‹‹‹‹‹‹}

    { ÇÎÁ®·´•≠®• Ì™p†≠≠ÎÂ ™ÆÆp§®≠†‚ ´®¨°† }
    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 Var

     I, J    : Integer ;


     X, Y, Z,
     RZaichik,
     RRCenterMoon,
     RRLimbEarth,
     R0,
     Ra,
     Decl        : Double ;

  Begin

     NPoz := 0 ;
     NNeg := 0 ;

     XSun  :=  RectCoordPl [ 11 , 1 ] ;
     YSun  :=  RectCoordPl [ 11 , 2 ] ;
     ZSun  :=  RectCoordPl [ 11 , 3 ] ;

     XSun0 := XSun - XPl ;
     YSun0 := YSun - YPl ;
     ZSun0 := ZSun - ZPl ;


      { è´†≠•‚ÆÊ•≠‚p®Á•·™®• Ì™¢†‚Æp®†´Ï≠Î• ™ÆÆp§®≠†‚Î ëÆ´≠Ê† }
      { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

     If ( NPl <> 11 )  Then
       Begin

         RSun := Sqrt ( Sqr ( XSun0 ) + Sqr ( YSun0 ) + Sqr ( ZSun0 ) ) ;

         XSunN := XSun0 / RSun ;
         YSunN := YSun0 / RSun ;
         ZSunN := ZSun0 / RSun ;

         RaSunPl := ArcTan ( YSunN / XSunN ) ;
           If ( XSunN   < 0.0 ) Then RaSunPl := RaSunPl + Pi       ;
           If ( RaSunPl < 0.0 ) Then RaSunPl := RaSunPl + Pi * C20 ;

         DeclSunPl := ArcTan ( ZSunN / SQRT ( C10 - Sqr ( ZSunN ) )  ) ;



         { á Ä â ó à ä }
         { ‹‹‹‹‹‹‹‹‹‹‹ }


         XObs0 := - XPl ;
         YObs0 := - YPl ;
         ZObs0 := - ZPl ;

         XZaichik := 0.0 ;
         YZaichik := 0.0 ;
         ZZaichik := 0.0 ;


         For I := 1  To  5  Do
           Begin

             XObs := XObs0 - XZaichik ;
             YObs := YObs0 - YZaichik ;
             ZObs := ZObs0 - ZZaichik ;

             RObs := Sqrt ( Sqr ( XObs ) + Sqr ( YObs ) + Sqr ( ZObs ) ) ;

             XObsN := XObs / RObs ;
             YObsN := YObs / RObs ;
             ZObsN := ZObs / RObs ;

             XSun := XSun0 - XZaichik ;
             YSun := YSun0 - YZaichik ;
             ZSun := ZSun0 - ZZaichik ;

             RSun := Sqrt ( Sqr ( XSun ) + Sqr ( YSun ) + Sqr ( ZSun ) ) ;

             XSunN := XSun / RSun ;
             YSunN := YSun / RSun ;
             ZSunN := ZSun / RSun ;


             XZaichik := ( XSunN + XObsN ) / C20 ;
             YZaichik := ( YSunN + YObsN ) / C20 ;
             ZZaichik := ( ZSunN + ZObsN ) / C20 ;

             RZaichik := Sqrt ( Sqr ( XZaichik ) +
                                Sqr ( YZaichik ) +
                                Sqr ( ZZaichik ) ) ;

             XZaichik := XZaichik / RZaichik * R_Pl ;
             YZaichik := YZaichik / RZaichik * R_Pl ;
             ZZaichik := ZZaichik / RZaichik * R_Pl ;

           End ;


         If (     ( NPl      =    3 )
              And ( Materiki <> Nil ) ) Then
           Begin
             Materiki^[ NumPointMateriki + 1 ].X := Round ( XZaichik * 5.0 ) ;
             Materiki^[ NumPointMateriki + 1 ].Y := Round ( YZaichik * 5.0 ) ;
             Materiki^[ NumPointMateriki + 1 ].Z := Round ( ZZaichik * 5.0 ) ;
             Materiki^[ NumPointMateriki + 1 ].E := 7 ;
           End ;

         RZaichik := Sqrt ( Sqr ( XZaichik ) +
                            Sqr ( YZaichik ) +
                            Sqr ( ZZaichik ) ) ;

         RSun := Sqrt ( Sqr ( XSun0 ) + Sqr ( YSun0 ) + Sqr ( ZSun0 ) ) ;

         XSunN := XSun0 / RSun ;
         YSunN := YSun0 / RSun ;
         ZSunN := ZSun0 / RSun ;

       End ; { NPl <> 11 }


          { äÆÆp§®≠†‚Î Ø´†≠•‚Î }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     XX := XPl / RPl ;
     YY := YPl / RPl ;
     ZZ := ZPl / RPl ;

     Ra := ArcTan ( YY / XX ) ;
        If ( XX < 0.0 ) Then Ra := Ra + Pi       ;
        If ( Ra < 0.0 ) Then Ra := Ra + Pi * C20 ;

     Decl := ArcTan ( ZZ / SQRT ( C10 - ZZ * ZZ ) ) ;


        { äÆÆp§®≠†‚Î H†°´Ó§†‚•´Ô }
        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     Decl := - Decl ;
     Ra   := Ra + Pi ;


     SDSObs := Sin ( - ( Pi / C20 - Decl ) ) ;
     CDSObs := Cos ( - ( Pi / C20 - Decl ) ) ;

     SLSObs := Sin ( - Ra ) ;
     CLSObs := Cos ( - Ra ) ;


          { å†·Ë‚†° ¢ •§®≠®Ê†Â R_Pl / REarth }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     R0 := R_Pl / RPointMax ;
     Maschtab := RPl * R0 / R_Planets [ 3 ] ;

     For I := 1  To  4  Do
       Kvadrant [ I ] := 0 ;

     For I := 0 To 363 Do
       Begin
         SxLimbViz [ I ] := LimbNot ;
         SyLimbViz [ I ] := LimbNot ;
       End ;

     PointLimbExist := False ;
     PointExist     := False ;
     PointInFild    := False ;
     NPointLimbViz  :=   0   ;
     J              :=   0   ;
     CHSunGorMax    := - 3.0 ;


     For  I := 0  To  362  Do
       Begin { I }

         Inc ( J ) ;

         If ( I < 1 )
           Then
             Begin  { Center Planet }

               X1 := 0.0 ;
               Y1 := 0.0 ;
               Z1 := 0.0 ;

             End
           Else
             Begin
               X1  := Ekv^[ I ].X / 100000.0 * Maschtab ;
               Y1  := Ekv^[ I ].Y / 100000.0 * Maschtab ;
               Z1  := Ekv^[ I ].Z / 100000.0 * Maschtab ;
             End ;

         { ÇÆ™p„£ Æ·® Y ≠† 90 - Decl }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         X  :=  X1 * CDSObs  -  Z1 * SDSObs  ;
         Y  :=  Y1                           ;
         Z  :=  X1 * SDSObs  +  Z1 * CDSObs  ;

         { ÇÆ™p„£ Æ·® Z ≠† R.A. }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         X1 := X *     CLSObs    +  Y * SLSObs ;
         Y1 := X * ( - SLSObs )  +  Y * CLSObs ;
         Z1 := Z                               ;

         X  := X1  +  XPl ;
         Y  := Y1  +  YPl ;
         Z  := Z1  +  ZPl ;

         RPoint := Sqrt ( X*X + Y*Y + Z*Z ) ;


              { ë‰•p®Á•·™®• ™ÆÆp§®≠†‚Î }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         SD   := Z / RPoint                     ;
         CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;
         If ( CD > 2.0E-10 )
           Then
             Begin
               SR := Y / RPoint / CD ;
               CR := X / RPoint / CD ;
             End
           Else
             Begin
               SR := C10 ;
               CR := 0.0 ;
             End ;

         ST   := SSTime * CR  -  CSTime * SR ;
         CT   := CSTime * CR  +  SSTime * SR ;

         SH   := SD * SFiS + CD * CFiS * CT ;

         SA   :=   CD * ST ;
         CA   := - SD * CFiS + CD * SFiS * CT ;

           { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
	 CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

         If ( CRo > 0.1 ) Then
          Begin { CRo > 0.1 }

            SDA  := SAOpt * CA  -  CAOpt  * SA ;

	    SPoz := SDA;
            CPoz := SH * CHOpt  -  SHOpt * CDA ;

	    YSt  :=   FD * CPoz / CRo ;
	    XSt  := - FD * SPoz / CRo ;


            If ( NPolFix )  Then
              Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                Index :=    XSt ;
                XSt   :=    XSt  * CPozNP  +  YSt * SPozNP ;
                YSt   := - Index * SPozNP  +  YSt * CPozNP ;
              End ;


            DxObj := ( XSt - CenterX ) * DxSc ;
            DyObj := ( YSt - CenterY ) * DySc ;

            Sx :=  Round ( dX + DxObj ) ;
            Sy :=  Round ( dY - DyObj ) ;


            If (     ( NPl  =  3 )
                 And ( NPl0 = 11 )
                 And ( I    =  0 )  )   Then
              Begin
                SxEarth := Sx     ;
                SyEarth := Sy     ;
                REarth  := RPoint ;
              End ;


            If (     ( NPl  =  3 )
                 And ( NPl0 = 11 )
                 And ( I = 1       )  )   Then
              Begin
                SxLimbEarth := Sx     ;
                SyLimbEarth := Sy     ;
              End ;


            If ( I = 0 )  Then
              Begin
                SxMoon  := Sx     ;
                SyMoon  := Sy     ;
              End ;


            If (     ( CenterMoon  )
                 And ( I = 0       )  )   Then
              Begin

                RMoon   := RPoint ;

                RRCenterMoon := Sqrt (
                   Sqr ( ( SxMoon - SxEarth ) * XAsp / YAsp )
                 + Sqr (   SyMoon - SyEarth                 ) ) ;

                RRLimbEarth  := Sqrt (
                   Sqr ( ( SxLimbEarth - SxEarth ) * XAsp / YAsp )
                 + Sqr (   SyLimbEarth - SyEarth                 ) ) ;

                AnnularEclipse := False ;

                If ( RRCenterMoon < RRLimbEarth )  Then
                  Begin

                    REarth := REarth - Sqrt (
                       Sqr ( R_Planets [ 3 ] )
                     - Sqr ( R_Planets [ 3 ] * RRCenterMoon / RRLimbEarth ) );

                    If (   ( R_Planets [ 10 ] / ( REarth - RMoon ) )
                         < ( R_Planets [ 11 ] / ( REarth         ) ) )  Then
                      AnnularEclipse := True ;

                  End ;

              End ;


            If ( I = 0 )
              Then
                Begin { Center Planet }
                  If (    ( Sx >= Sw.x1 )
                      And ( Sx <= Sw.x2 )
                      And ( Sy >= Sw.y1 )
                      And ( Sy <= Sw.y2 )
                      And ( CRo > 0     )  )
                    Then
                      Begin { In Fild }

                        If ( PointExist )  Then
                          Begin
                            SxLimbViz [ J - 1 ] := SxOld ;
                            SyLimbViz [ J - 1 ] := SyOld ;
                          End ;

                        Inc ( NPointLimbViz ) ;

                        SxLimbViz [ J ] := Sx ;
                        SyLimbViz [ J ] := Sy ;

                      End ; { In Fild }

                End   { Center Planet }
              Else
                Begin { No Center Planet }

                  If ( Sx > SxCFld )
                    Then
                      Begin
                        If ( Sy > SyCFld )
                           Then  Kvadrant [ 4 ] := 1
                           Else  Kvadrant [ 1 ] := 1 ;
                      End
                    Else
                      Begin
                        If ( Sy > SyCFld )
                           Then  Kvadrant [ 3 ] := 1
                           Else  Kvadrant [ 2 ] := 1 ;
                      End ;


                  If (    ( Sx >= Sw.x1 )
                      And ( Sx <= Sw.x2 )
                      And ( Sy >= Sw.y1 )
                      And ( Sy <= Sw.y2 )
                      And ( CRo > 0     )  )
                    Then
                      Begin { In Fild }

                        If ( PointExist )  Then
                          Begin
                            SxLimbViz [ J - 1 ] := SxOld ;
                            SyLimbViz [ J - 1 ] := SyOld ;
                          End ;

                        Inc ( NPointLimbViz ) ;

                        SxLimbViz [ J ] := Sx ;
                        SyLimbViz [ J ] := Sy ;

                        PointInFild := True ;

                        If ( NPl <> 11 )  Then
                          Begin { ÇÎ·Æ‚† ëÆ´≠Ê† ≠† ´®¨°• }

                            XpGor := X * RPointMax / RPoint  - XPl  ;
                            YpGor := Y * RPointMax / RPoint  - YPl  ;
                            ZpGor := Z * RPointMax / RPoint  - ZPl  ;

                            RPoint := Sqrt (   Sqr ( XpGor )
                                             + Sqr ( YpGor )
                                             + Sqr ( ZpGor ) ) ;

                            XpGor := XpGor / RPoint ;
                            YpGor := YpGor / RPoint ;
                            ZpGor := ZpGor / RPoint ;



                            CHSunGor := (    XpGor * XSunN
                                          +  YpGor * YSunN
                                          +  ZpGor * ZSunN ) ;

                            If ( CHSunGor > C10 )  Then
                              CHSunGor := C10 ;

                            If ( CHSunGor > CHSunGorMax )  Then
                               CHSunGorMax := CHSunGor ;

                            If ( CHSunGor > 0.0 )
                              Then  Inc ( NPoz )
                              Else  Inc ( NNeg ) ;

                          End ;

                      End  { In Fild }
                    Else
                      Begin  { Not In Fild }

                        If ( PointInFild )  Then
                          Begin { ÇÎË´† ®ß ØÆ´Ô, ≠Æ ¢ ØÆ´• °Î´Æ }
                            SxLimbViz [ J ] :=    Sx ;
                            SyLimbViz [ J ] :=    Sy ;
                            PointInFild     := False ;
                          End ;

                      End ;  { Not In Fild }

                  PointExist := True ;
                  SxOld      := Sx   ;
                  SyOld      := Sy   ;

                End ; { No Center Planet }


          End ; { CRo > 0.1 }

       End ; { I }


     If ( ChSunGorMax > -2 )  Then
       Begin

         If ( ChSunGorMax > 0.0 )
           Then
             Begin
               If ( NPoz <= 2 )  Then
                 ChSunGorMax := - ChSunGorMax ;
             End
           Else
             Begin
               If ( NNeg <= 2 )  Then
                 ChSunGorMax := - ChSunGorMax ;
             End ;

         SHSunGorMax := Sqrt ( C10 - Sqr ( CHSunGorMax )) ;

         HSunGor := ATan2 ( SHSunGorMax, CHSunGorMax );
         {
         If ( HSunGor > Pi )  Then
           HSunGor := HSunGor - Pi2 ;
         }
         {
         If ( CHSunGorMax < 0.0 )  Then
            HSunGor := HSunGor + PI  ;
         }
         HSunGor := Pi / C20 - HSunGor ;

         PointLimbExist := True ;

       End ;


     If (    ( NPointLimbViz > 0                      )
          Or (   Kvadrant [ 1 ] * Kvadrant [ 2 ]
               * Kvadrant [ 3 ] * Kvadrant [ 4 ]  = 1 )  )
       Then PointLimbFind := True
       Else PointLimbFind := False ;



  End ; { Procedure CalcLimb }


         { ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ }





 Procedure  Limb ( LimbColor : Word ; Full : Boolean ) ;
           {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}

 Var
     PointFind : Boolean ;
     I         : Integer ;

   Begin

     PointFind := False ;
     SetColor ( LimbColor ) ;

     SxOld := LimbNot ;
     SYOld := LimbNot ;

     If ( NPointLimbViz > 0 )  Then
       Begin  { NPointLimbViz > 0 }

         For  I := 1  To  363  Do
           Begin { I }
                 { - }
             {
             If I = 360 Then
               Sx := SxLimbViz [ I ] ;
             }
             Sx := SxLimbViz [ I ] ;
             Sy := SyLimbViz [ I ] ;

             If ( I = 1 )
               Then
                 Begin { Center Moon }
                   If ( CenterMoon )  Then
                     Begin
                       If ( AnnularEclipse )
                         Then
                           Begin
                             Circle ( Sx, Sy, 4 ) ;
                           End
                         Else
                           Begin
                             Line ( Sx - 5, Sy    , Sx + 5, Sy     ) ;
                             Line ( Sx    , Sy - 4, Sx    , Sy + 4 ) ;
                           End ;

                     End ;
                 End   { Center Sun }
               Else
                 Begin { No Center Moon }
                   If (     ( SxOld <> LimbNot )
                        And ( SyOld <> LimbNot )
                        And ( Sx    <> LimbNot )
                        And ( Sy    <> LimbNot )  )
                     Then
                      Begin

                        Line  ( SxOld, SyOld, Sx, Sy ) ;

                        {
                        SetLineStyle ( SolidLn, 0, ThickWidth ) ;
                        Line  ( SxOld, SyOld, Sx, Sy ) ;
                        SetLineStyle ( SolidLn, 0, NormWidth ) ;
                        }
                      End ;

                   SxOld := Sx ;
                   SyOld := Sy ;


                   If ( Not PointFind )  Then
                     Begin { Not PointFind }

                       If (    ( Sx > Sw.x1+2 )
                           And ( Sx < Sw.x2-2 )
                           And ( Sy > Sw.y1+2 )
                           And ( Sy < Sw.y2-2 ) )  Then
                         Begin

                           If ( Sx > SxC )
                              Then SxP := Sx - 2
                              Else SxP := Sx + 2 ;

                           If ( Sy > SyC )
                              Then SyP := Sy - 2
                              Else SyP := Sy + 2 ;

                           If (    ( SxP > Sw.x1+1 )
                               And ( SxP < Sw.x2-1 )
                               And ( SyP > Sw.y1+1 )
                               And ( SyP < Sw.y2-1 ) )  Then
                             Begin
                               PointFind := True ;
                             End ;

                         End ;

                     End ; { Not PointFind }

                 End ; { No Center Sun }

           End ; { I }

       End ;  { NPointLimbViz > 0 }




     If ( Full )  Then
       Begin
         If ( PointFind )
           Then
             Begin
               SetFillStyle ( SolidFill , LimbColor ) ;
                          {
                          SetColor ( White ) ;
                          Circle ( SxP, SyP, 2 ) ;

                          SetColor ( ColorNight ) ;
                          Circle ( SxP, SyP, 2 ) ;

                          SetColor ( LimbColor ) ;
                          }
               FloodFill ( SxP, SyP, LimbColor ) ;
               I := GraphResult ;
             End
           Else
             Begin
               If (   Kvadrant [ 1 ] * Kvadrant [ 2 ]
                    * Kvadrant [ 3 ] * Kvadrant [ 4 ]  = 1 )  Then
                 Begin

                   SetFillStyle ( SolidFill , LimbColor ) ;
                   FloodFill    ( SxCFld , SyCFld , LimbColor ) ;
                   I := GraphResult ;
                 End ;

             End ;
       End ;

   End ;

         { ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ }


 Procedure Terminator ;
          {‹‹‹‹‹‹‹‹‹‹}

  Const
     Grad20   : Double  = Pi /  18.0 ;
     StepTerm : Double  = Pi / 180.0 ;
     StepGran : Integer = 2          ;
     {
     StepTerm : Double  = Pi / 180.0 ;
     }
  Var

      CExit,
      B_Gran,
      PointDay,
      PointNight,
      PixNight,
      CalcTerm,
      VPointFind,
      NPointFind,
      TermViz                  : Boolean ;

      I, II, J, K,
      NOutFild,
      Sxt, Syt,
      SxNeg, SyNeg             : Integer ;

      Color                    : Word    ;

      Sxht, Syht,
      SxhtOld, SyhtOld         : LongInt ;

      RMoonN,
      X, Y, Z, R,
      Xt, Yt, Zt, Rt,
      Xht, Yht, Zht, Rht, Rh,
      RTSun, KInt,
      Xp,Yp,Zp,
      XpN,YpN,ZpN,
      RHalfTen, MHalfTen,
      CLS, SLS,
      SDS, CDS,
      R_Planets_3,
      XZ, YZ,
      SinPozSaichik, CosPozSaichik,
      SinPozTerm, CosPozTerm,
      PozSaichik,
      PozTerm,
      dPozTerm, dPozTermOld,
      XCPlan, YCPlan,
      DxCTerm,  DyCTerm,  DzCTerm,  RCTerm,
      DxCTerm1, DyCTerm1, DzCTerm1, RCTerm1,
      RGor,  SinRGor,  CosRGor,
      RGor1, SinRGor1, CosRGor1,
      MTerm, MTerm1                                : Double  ;


   Function Pair : Boolean ;

     Var ExitPair : Boolean ;

     Begin

       SVectX := SxN - SxV ;
       SVectY := SyN - SyV ;

       ExitPair := False ;
       Pair     := False ;
       {
       If (    ( Abs ( SVectX ) > 1 )
            Or ( Abs ( SVectY ) > 1 ) )  Then
       }
       If (    ( Abs ( SVectX ) > 1 )
            Or ( Abs ( SVectY ) > 1 ) )  Then
         Begin

           SxT := SxV ;
           SyT := SyV ;

           If ( SVectX ) <> 0
             Then Nx := Round ( Abs ( SVectX ) / ( SVectX ) )
             Else Nx := 0 ;

           If ( SVectY ) <> 0
             Then Ny := Round ( Abs ( SVectY ) / ( SVectY ) )
             Else Ny := 0 ;

           PixColor := GetPixel ( SxV , SyV ) ;
           If ( PixColor <> ColorNight ) Then
             Begin
               Nx := 0 ;
               Ny := 0 ;
             End ;

           PixColor := GetPixel ( SxN , SyN ) ;
           If ( PixColor <> ColorNight ) Then
             Begin
               Nx := 0 ;
               Ny := 0 ;
             End ;

           If (     ( Abs ( SVectX ) >= Abs ( SVectY ) )
                And ( Nx     <> 0      ) )  Then
             Repeat

               SxT := SxT + Nx ;
               SyT := SyV + Round (( SxT - SxV ) * ( SVectY ) / ( SVectX ) ) ;

               If ( SxT <> SxN )  Then
                 Begin
                   PixColor := GetPixel ( SxT , SyT ) ;
                   If ( PixColor = PlanetColor ) Then
                     ExitPair := True ;
                 End ;

             Until (    ( SxT = SxN )
                     Or ( ExitPair  ) ) ;


           If (     ( Abs ( SVectX ) < Abs ( SVectY ) )
                And ( Ny             <> 0             ) )  Then
             Repeat

               SyT := SyT + Ny ;
               SxT := SxV + Round (( SyT - SyV ) * ( SVectX ) / ( SVectY ) ) ;

               If ( SyT <> SyN )  Then
                 Begin
                   PixColor := GetPixel ( SxT , SyT ) ;
                   If ( PixColor = PlanetColor ) Then
                     ExitPair := True  ;
                 End ;

             Until (    ( SyT = SyN )
                     Or ( ExitPair  ) ) ;

           Pair := ExitPair ;

         End ;

     End ;  { Pro Pair }





   Begin
     {
     If ( Abs ( 90.0 - PhasePl * 57.3 ) < 70.0 )
       Then  StepTerm := Pi / 180.0
       Else  StepTerm := Pi /  45.0 ;
     }
     XSun0 := XSunGeoc * Ae ;
     YSun0 := YSunGeoc * Ae ;
     ZSun0 := ZSunGeoc * Ae ;


     { Geocentric Suns Distance }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     RSun  := Sqrt ( Sqr ( XSun0 ) + Sqr ( YSun0 ) + Sqr ( ZSun0 ) ) ;

     XSunN := XSun0 / RSun ;
     YSunN := YSun0 / RSun ;
     ZSunN := ZSun0 / RSun ;


     If ( Not MoonEclipse )
       Then
         Begin

           MTerm := R_Pl / R_Planets [ 3 ] ;

         End { Not MoonEclipse }
       Else
         Begin  { ê†§®„· í•≠® Øp® á†‚¨•≠®® }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           R_Planets_3 := R_Planets [ 3 ] + 20.0 ;

           XMoon := XMoonGeoc * Ae ;
           YMoon := YMoonGeoc * Ae ;
           ZMoon := ZMoonGeoc * Ae ;

           { Geocentric Moons Distance }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           RMoon := Sqrt ( Sqr ( XMoon ) + Sqr ( YMoon ) + Sqr ( ZMoon ) ) ;

           XMoonN := XMoon / RMoon ;
           YMoonN := YMoon / RMoon ;
           ZMoonN := ZMoon / RMoon ;



           CosMoonTenUgl := - (   XMoonN * XSunN
                                + YMoonN * YSunN
                                + ZMoonN * ZSunN ) ;
           SinMoonTenUgl := Sqrt ( C10 - Sqr ( CosMoonTenUgl ) )  ;
           TgMoonTenUgl  := SinMoonTenUgl / CosMoonTenUgl ;


                 { íÆÁ™† ë®¨¨•‚p®® }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           X1 := XSun0 *   R_Planets_3
                       / ( R_Planets_3 + R_Planets [ 11 ] ) ;
           Y1 := YSun0 *   R_Planets_3
                       / ( R_Planets_3 + R_Planets [ 11 ] ) ;
           Z1 := ZSun0 *   R_Planets_3
                       / ( R_Planets_3 + R_Planets [ 11 ] ) ;


           LHTen    := Sqrt ( Sqr ( X1 ) + Sqr ( Y1 ) + Sqr ( Z1 ) ) ;

           SinRHTen := ( R_Planets_3 ) / LHTen ;
           CosRHten := Sqrt ( C10 - Sqr ( SinRHTen ) ) ;
           TgRHTen  := SinRHTen / CosRHTen ;

           { ä-‚Î ã„≠Î Æ‚≠Æ·®‚•´Ï≠Æ íÆÁ™® ë®¨¨•‚p®® }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           Xt := XMoon - X1 ;
           Yt := YMoon - Y1 ;
           Zt := ZMoon - Z1 ;

           Rt := Sqrt ( Sqr ( Xt ) + Sqr ( Yt ) + Sqr ( Zt )  ) ;

           LHTen := Sqrt ( Sqr ( Rt ) - Sqr ( R_Planets [ 10 ] )  ) ;
           LHTen := LHTen * CosRHten ;

           MHalfTen := LHTen * TgRHten ;
           MHalfTen := MHalfTen / R_Planets [ 3 ] ;


           { äÆÆp§®≠†‚Î Ê•≠‚pÆ¢ ‚•≠•© }

           XHTen := X1 - XSunN * LHTen - Xs ;
           YHTen := Y1 - YSunN * LHTen - Ys ;
           ZHTen := Z1 - ZSunN * LHTen - Zs ;

           XTen  := X1 - XSunN * LHTen - Xs ;
           YTen  := Y1 - YSunN * LHTen - Ys ;
           ZTen  := Z1 - ZSunN * LHTen - Zs ;

           RTen := Sqrt (   Sqr ( XTen )
                          + Sqr ( YTen )
                          + Sqr ( ZTen )
                        ) ;

           XTenN := XTen / RTen ;
           YTenN := YTen / RTen ;
           ZTenN := ZTen / RTen ;




           RTen := R_Planets_3 -
                  ( ( R_Planets [ 11 ] - R_Planets_3 ) / RSun * RMoon ) ;

           MTerm    := RTen / R_Planets [ 3 ] ;

           RTenUgl  := RTen / RMoon  ; { Sin }





           XMoon := RectCoordPl [ 10 , 1 ]  ;
           YMoon := RectCoordPl [ 10 , 2 ]  ;
           ZMoon := RectCoordPl [ 10 , 3 ]  ;

           RMoon := Sqrt ( Sqr ( XMoon ) + Sqr ( YMoon ) + Sqr ( ZMoon ) ) ;

           XMoonN := XMoon / RMoon ;
           YMoonN := YMoon / RMoon ;
           ZMoonN := ZMoon / RMoon ;



           { Tg ì£´Æ¢Æ£Æ ê†§®„·† ã„≠Î }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
           RMoonUgl := R_Planets [ 10 ] / RMoon  ; { Tg }


         End ;  { ê†§®„· í•≠® Øp® á†‚¨•≠®® }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }




      { è´†≠•‚ÆÊ•≠‚p®Á•·™®• ØpÔ¨Æ„£Æ´Ï≠Î• ™ÆÆp§®≠†‚Î ëÆ´≠Ê† }
      { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

     If ( NPl <> 11 )  Then
       Begin

         XSun0 :=  RectCoordPl [ 11 , 1 ] - XPl  ;
         YSun0 :=  RectCoordPl [ 11 , 2 ] - YPl  ;
         ZSun0 :=  RectCoordPl [ 11 , 3 ] - ZPl  ;

         RSun := Sqrt ( Sqr ( XSun0 ) + Sqr ( YSun0 ) + Sqr ( ZSun0 ) ) ;

         XSunN := XSun0 / RSun ;
         YSunN := YSun0 / RSun ;
         ZSunN := ZSun0 / RSun ;

         SinRGor := Sin ( ( R_Planets [ 11 ] - R_Pl ) / RSun  ) ;
         CosRGor := Cos ( ( R_Planets [ 11 ] - R_Pl ) / RSun  ) ;

         RGor    := ATan2 ( SinRGor, CosRGor ) ;

         MTerm   := MTerm * CosRGor ;

         { ñ•≠‚p ‚•p¨®≠†‚Æp† ¢ ‚•´• è´†≠•‚Î }
         RCTerm  := R_Planets [ NPl ] * SinRGor ;

         { ë¨•È•≠®• Ê•≠‚p† ‚•p¨®≠†‚Æp† }
         DxCTerm := - XSunN * RCTerm ;
         DyCTerm := - YSunN * RCTerm ;
         DzCTerm := - ZSunN * RCTerm ;

       End ;


         { í•p¨®≠†‚Æp }
         { ‹‹‹‹‹‹‹‹‹‹ }

     If ( MoonEclipse )
       Then Limb ( ColorNight  , False )
       Else Limb ( PlanetColor , False ) ;

     SetColor ( PlanetColor ) ;
     ColorPixel := PlanetColor ;

     Prima        := True  ;
     PointExist   := False ;
     PointInFild  := False ;
     CalcTerm     := False ;
     VPointFind   := False ;
     TermViz      := False ;
     PixNight     := False ;


     B_Gran       := False ;
     NPTermViz    := 1     ;
     dPozTermOld  := 1.0e9 ;

     SDS := Sin ( - Pi / C20 - DeclSunPl ) ;
     CDS := Cos ( - Pi / C20 - DeclSunPl ) ;

     SLS := Sin ( - RaSunPl + Pi / C20 ) ;
     CLS := Cos ( - RaSunPl + Pi / C20 ) ;

     SxhtOld  := 2000000 ;
     SyhtOld  := 2000000 ;

     SxProxTen   :=    -100 ;
     SyProxTen   :=    -100 ;
     RTenMin     := 1000000 ;
     RTenMoonMin := 1000000 ;
     RTenMoon    := 1000000 ;

     NOutFild    :=       0 ;

     {
     For  II := 0  To  361  Do
     For  II := 0  To  450  Do
     }

     For  II := 0  To  450  Do
       Begin { I }

         If ( II > 361 )
           Then I := II - 361
           Else I := II ;

         If ( I < 1 )
           Then
             Begin  { Center Planet }

               Xt := 0.0 ;
               Yt := 0.0 ;
               Zt := 0.0 ;

               Xht := 0.0 ;
               Yht := 0.0 ;
               Zht := 0.0 ;

             End
           Else
             Begin

               Xt  := Ekv^[ I ].X / 100000.0 * MTerm ;
               Yt  := Ekv^[ I ].Y / 100000.0 * MTerm ;
               Zt  := Ekv^[ I ].Z / 100000.0 * MTerm ;

               If ( MoonEclipse )  Then
                 Begin
                   Xht := Ekv^[ I ].X / 100000.0 * MHalfTen ;
                   Yht := Ekv^[ I ].Y / 100000.0 * MHalfTen ;
                   Zht := Ekv^[ I ].Z / 100000.0 * MHalfTen ;
                 End ;

             End ;


         X1 := Xt                                ;
         Y1 :=       Yt *     CDS   +  Zt * SDS  ;
         Z1 :=       Yt * ( - SDS ) +  Zt * CDS  ;

         Xt := X1 *     CLS    +  Y1 * SLS  ;
         Yt := X1 * ( - SLS )  +  Y1 * CLS  ;
         Zt := Z1                           ;


         If ( MoonEclipse )  Then
           Begin

             X1 := Xht                                  ;
             Y1 :=        Yht *     CDS   +  Zht * SDS  ;
             Z1 :=        Yht * ( - SDS ) +  Zht * CDS  ;

             Xht := X1 *     CLS    +  Y1 * SLS  ;
             Yht := X1 * ( - SLS )  +  Y1 * CLS  ;
             Zht := Z1                           ;

           End ;


         If ( Not MoonEclipse )
           Then
             Begin

               Xp  := Xt + XPl ;
               Yp  := Yt + YPl ;
               Zp  := Zt + ZPl ;

               { ™-‚Î ‚ÆÁ™® Æ‚≠. ≠†°´. }

               Xp := Xp + DxCTerm ;
               Yp := Yp + DyCTerm ;
               Zp := Zp + DzCTerm ;

             End
           Else
             Begin

               Xp  := Xt + XTen ;
               Yp  := Yt + YTen ;
               Zp  := Zt + ZTen ;

               RTenMoon := Sqrt (   Sqr ( Xp )
                                  + Sqr ( Yp )
                                  + Sqr ( Zp )  ) ;

               XpN := Xp / RTenMoon ;
               YpN := Yp / RTenMoon ;
               ZpN := Zp / RTenMoon ;

               RTenMoon :=   XpN * XMoonN
                           + YpN * YMoonN
                           + ZpN * ZMoonN ;  { Cos }

               RTenMoon := Sqrt ( C10 - Sqr ( RTenMoon ) ) / RTenMoon ; { Tg }

             End ;

         RPoint := Sqrt ( Sqr ( Xp ) + Sqr ( Yp ) + Sqr ( Zp )  ) ;


         If (    ( RPoint <= RPointMax )
              Or ( MoonEclipse         )
              Or ( I = 0               ) )   Then
           Begin  { íÆÁ™† °´®ß™Æ }

              XN := Xp / RPoint ;
              YN := Yp / RPoint ;
              ZN := Zp / RPoint ;

              { ë‰•p®Á•·™®• ™ÆÆp§®≠†‚Î }

              SD   := ZN ;
              CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;
              If ( CD > 2.0E-10 )  Then
                 Begin
                   SR := YN / CD ;
                   CR := XN / CD ;
                 End
               Else
                 Begin
                   SR := C10 ;
                   CR := 0.0 ;
                 End ;


              ST   := SSTime * CR  -  CSTime * SR ;
              CT   := CSTime * CR  +  SSTime * SR ;

              SH   := SD * SFiS + CD * CFiS * CT ;

              SA   :=   CD * ST ;
              CA   := - SD * CFiS + CD * SFiS * CT ;


               { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }

              CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
	      CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

              SDA  := SAOpt * CA  -  CAOpt  * SA ;

	      SPoz := SDA;
              CPoz := SH * CHOpt  -  SHOpt * CDA ;

	      YSt  :=   FD * CPoz / CRo ;
	      XSt  := - FD * SPoz / CRo ;


              If ( NPolFix )  Then
                Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }

                  Index :=    XSt ;
                  XSt   :=    XSt  * CPozNP  +  YSt * SPozNP ;
                  YSt   := - Index * SPozNP  +  YSt * CPozNP ;

                End ;


              If ( I = 0 )  Then
                Begin { èÆß®Ê®Æ≠≠Î© „£Æ´ á†©Á®™† Æ‚≠. Ê•≠‚p† Ø´†≠•‚Î }
                      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                  XCPlan := XSt ;
                  YCPlan := YSt ;
                  {
                  X := XZaichik + XPl ;
                  Y := YZaichik + YPl ;
                  Z := ZZaichik + ZPl ;
                  }

                  X := XPl ;
                  Y := YPl ;
                  Z := ZPl ;

                  { ë‰•p®Á•·™®• ™ÆÆp§®≠†‚Î }

                  RPoint := Sqrt ( Sqr ( X ) + Sqr ( Y ) + Sqr ( Z )  ) ;

                  SD   := Z / RPoint                     ;
                  CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;
                  If ( CD > 2.0E-10 )
                    Then
                      Begin
                        SR := Y / RPoint / CD ;
                        CR := X / RPoint / CD ;
                      End
                    Else
                      Begin
                        SR := C10 ;
                        CR := 0.0 ;
                      End ;


                  ST   := SSTime * CR  -  CSTime * SR ;
                  CT   := CSTime * CR  +  SSTime * SR ;

                  SH   := SD * SFiS + CD * CFiS * CT ;

                  SA   :=   CD * ST ;
                  CA   := - SD * CFiS + CD * SFiS * CT ;

                  { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }

                  CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
                  CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

                  SDA  := SAOpt * CA  -  CAOpt  * SA ;

	          SPoz := SDA;
                  CPoz := SH * CHOpt  -  SHOpt * CDA ;

	          XZ   := - FD * SPoz / CRo ;
	          YZ   :=   FD * CPoz / CRo ;


                  If ( NPolFix )  Then
                    Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }

                      Index :=   XZ                                 ;
                      XZ    :=   XZ        * CPozNP  +  YZ * SPozNP ;
                      YZ    := - Index     * SPozNP  +  YZ * CPozNP ;

                    End ;

                  DxObj := ( Xz - CenterX ) * DxSc ;
                  DyObj := ( Yz - CenterY ) * DySc ;

                  Xz :=  Round ( dX + DxObj ) ;
                  Yz :=  Round ( dY - DyObj ) ;
                  {
                  SetColor ( LightRed ) ;
                  Circle ( Round ( Xz ), Round ( Yz ), 3 ) ;
                  }
                  R := Sqrt ( Sqr ( XZ ) + Sqr ( YZ ) ) ;
                  {
                  If ( R > 0.0 )
                    Then
                      Begin
                        SinPozSaichik := YZ / R ;
                        CosPozSaichik := XZ / R ;
                      End
                    Else
                      Begin
                        SinPozSaichik := 0.0 ;
                        CosPozSaichik := 0.0 ;
                      End ;

                  PozSaichik := ATan2 ( SinPozSaichik, CosPozSaichik ) ;
                  }
                End ;


              DxObj := ( XSt - CenterX ) * DxSc ;
              DyObj := ( YSt - CenterY ) * DySc ;

              Sx :=  Round ( dX + DxObj ) ;
              Sy :=  Round ( dY - DyObj ) ;

              If ( I = 0 )  Then
                Begin
                  SxCTen := Sx ;
                  SyCTen := Sy ;
                End ;


              If ( MoonEclipse )  Then
                Begin

                  If (     ( CRo > 0     )
                       And ( I   > 0     )  )  Then
                    Begin

                      If ( RTenMoon < RTenMoonMin  )  Then
                        RTenMoonMin := RTenMoon ;

                      RTen := Sqrt (   Sqr ( ( Sx - SxMoon ) * XAsp / YAsp )
                                     + Sqr ( Sy - SyMoon ) ) ;

                      If ( RTen < RTenMin )  Then
                        Begin

                          If (     ( Sx >= Sw.x1 )
                               And ( Sx <= Sw.x2 )
                               And ( Sy >= Sw.y1 )
                               And ( Sy <= Sw.y2 ) )  Then
                            Begin
                              RTenMin := RTen ;
                              SxProxTen := Sx ;
                              SyProxTen := Sy ;
                            End ;

                        End ;


                      Xp  := Xht + XHTen ;
                      Yp  := Yht + YHTen ;
                      Zp  := Zht + ZHTen ;


                      RPoint := Sqrt (   Sqr ( Xp )
                                       + Sqr ( Yp )
                                       + Sqr ( Zp )  ) ;

                      XN := Xp / RPoint ;
                      YN := Yp / RPoint ;
                      ZN := Zp / RPoint ;

                      { ë‰•p®Á•·™®• ™ÆÆp§®≠†‚Î }

                      SD   := ZN ;
                      CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;
                      If ( CD > 2.0E-10 )
                        Then
                          Begin
                            SR := YN / CD ;
                            CR := XN / CD ;
                          End
                        Else
                          Begin
                            SR := C10 ;
                            CR := 0.0 ;
                          End ;


                      ST   := SSTime * CR  -  CSTime * SR ;
                      CT   := CSTime * CR  +  SSTime * SR ;

                      SH   := SD * SFiS + CD * CFiS * CT ;

                      SA   :=   CD * ST ;
                      CA   := - SD * CFiS + CD * SFiS * CT ;


                      { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }

                      CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
	              CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

                      SDA  := SAOpt * CA  -  CAOpt  * SA ;

	              SPoz := SDA;
                      CPoz := SH * CHOpt  -  SHOpt * CDA ;

	              YSt  :=   FD * CPoz / CRo ;
	              XSt  := - FD * SPoz / CRo ;


                      If ( NPolFix )  Then
                        Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }

                          Index :=    XSt ;
                          XSt   :=    XSt  * CPozNP  +  YSt * SPozNP ;
                          YSt   := - Index * SPozNP  +  YSt * CPozNP ;

                        End ;


                      DxObj := ( XSt - CenterX ) * DxSc ;
                      DyObj := ( YSt - CenterY ) * DySc ;

                      Sxht :=  Round ( dX + DxObj ) ;
                      Syht :=  Round ( dY - DyObj ) ;

                      If ( SxhtOld <> 2000000 ) Then
                        Begin
                          Color := GetColor ;
                          SetColor ( ColorNight ) ;
                          Line  ( SxhtOld, SyhtOld, Sxht, Syht ) ;
                          SetColor ( Color ) ;
                        End ;

                      SxhtOld := Sxht ;
                      SyhtOld := Syht ;

                    End ; { ( CRo > 0 )  And ( I > 0 ) }

                End ; { MoonEclipse }



              If (     ( CRo > 0     )
                   And ( I   > 0     )
                   And ( Sx >= Sw.x1 )
                   And ( Sx <= Sw.x2 )
                   And ( Sy >= Sw.y1 )
                   And ( Sy <= Sw.y2 ) )
                Then
                  Begin { In Fild }

                    If ( PointInFild Or PointExist )  Then
                      Begin

                        If ( MoonEclipse )
                          Then
                            Begin

                              Color := GetColor ;
                              SetColor ( ColorNight ) ;
                              Line  ( SxOld, SyOld, Sx, Sy ) ;
                              SetColor ( Color ) ;

                              SxOld    := Sx ;
                              SyOld    := Sy ;

                            End
                          Else
                            Begin

                              CalcTerm := True ;

                              PixColor := GetPixel ( Sx, Sy ) ;
                              If ( PixColor = PlanetColor ) Then
                                CalcTerm := False ;

                              Line  ( SxOld, SyOld, Sx, Sy ) ;
                              {
                              SetLineStyle ( SolidLn, 0, ThickWidth ) ;
                              Line  ( SxOld, SyOld, Sx, Sy ) ;
                              SetLineStyle ( SolidLn, 0, NormWidth ) ;
                              }
                              SxOld := Sx ;
                              SyOld := Sy ;

                              If (     (    ( Sx <= Sw.x1 + StepGran )
                                         Or ( Sx >= Sw.x2 - StepGran ) )
                                   Or  (    ( Sy <= Sw.y1 + StepGran )
                                         Or ( Sy >= Sw.y2 - StepGran ) ) )
                                Then
                                  Begin { Å´®ß™Æ ™ ™p†Ó }

                                    If ( VPointFind )  Then
                                      Begin
                                        Inc ( NPTermViz )  ;
                                        DPozTermOld := 100 ;
                                        B_Gran := True ;
                                      End ;

                                    CalcTerm   := False ;
                                    VPointFind := False ;

                                  End  { Å´®ß™Æ ™ ™p†Ó }
                                Else
                                    CalcTerm := True ;

                            End ;

                        TermViz  := True ;

                      End ;

                    PointInFild := True ;

                  End    { In Fild }
                Else
                  Begin  { Not In Fild }

                    If ( PointInFild )  Then
                      Begin { ÇÎË´† ®ß ØÆ´Ô, ≠Æ ¢ ØÆ´• °Î´Æ }

                        If ( MoonEclipse )
                          Then
                            Begin
                              Color := GetColor ;
                              SetColor ( ColorNight ) ;
                              Line  ( SxOld, SyOld, Sx, Sy ) ;
                              SetColor ( Color ) ;
                            End
                          Else
                            Begin

                              Line  ( SxOld, SyOld, Sx, Sy ) ;

                              Inc ( NOutFild ) ;

                              If ( VPointFind )  Then
                                Begin

                                  Inc ( NPTermViz ) ;

                                  VPointFind := False ;
                                  CalcTerm   := False ;

                                End ;

                            End ;

                        CalcTerm     := False            ;
                        PointInFild  := False            ;
                        DPozTermOld  := 100              ;

                      End ;

                  End ;  { Not In Fild }


              If ( I > 0 )  Then
                Begin
                  PointExist := True ;
                  SxOld      := Sx   ;
                  SyOld      := Sy   ;
                  SxhtOld    := Sxht ;
                  SyhtOld    := Syht ;
                End ;



                { íÆÁ™® §´Ô ß†ØÆ´≠•≠®Ô ·•pØ† }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


              If (     ( I    > 3 )
                   And ( CRo  > 0 )
                   And ( CalcTerm ) )
                Then
                  Begin  { Calc Point Term }

                    { èÆß®Ê®Æ≠≠Î© „£Æ´ ‚ÆÁ™® í•p¨®≠†‚Æp† }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                    {
                    DxObj := ( XSt - CenterX ) * DxSc ;
                    DyObj := ( YSt - CenterY ) * DySc ;

                    X :=  Round ( dX + DxObj ) ;
                    Y :=  Round ( dY - DyObj ) ;

                    dPozTerm := Sqrt ( Sqr ( X - Xz ) + Sqr ( Y - Yz ) ) ;
                    }

                    {
                    dPozTerm := Sqrt (   Sqr ( ( Sx - Xz ) * XAsp / YAsp )
                                       + Sqr   ( Sy - Yz )                 ) ;
                    }
                    dPozTerm := Sqrt (   Sqr ( Xt - XZaichik )
                                       + Sqr ( Yt - YZaichik )
                                       + Sqr ( Zt - ZZaichik )  ) ;
                    {


                    dPozTerm := Sqrt ( Sqr ( X - XCPlan ) + Sqr ( Y - YCPlan ) ) ;
                    }
                    {
                    SxPt :=  Round ( dX + X ) ;
                    SyPt :=  Round ( dY - Y ) ;
                    RPt := Round ( Sqrt ( Sqr ( SxPt ) + Sqr ( SyPt ) ) ) ;
                    }
                    (*
                    R := Sqrt ( Sqr ( X ) + Sqr ( Y ) ) ;

                    If ( R > 0.0 )
                      Then
                        Begin
                          SinPozTerm := Y / R ;
                          CosPozTerm := X / R ;
                        End
                      Else
                        Begin
                          SinPozTerm := 0.0 ;
                          CosPozTerm := 0.0 ;
                        End ;


                    PozTerm := ATan2 ( SinPozTerm, CosPozTerm ) ;

                    dPozTerm := Abs ( PozTerm - PozSaichik ) ;

                    If ( dPozTerm > Pi ) Then
                      dPozTerm := Abs ( Pi2 - dPozTerm ) ;

                    If ( dPozTerm > Pid2 ) Then
                      dPozTerm := Abs ( Pi - dPozTerm ) ;
                    *)

                     {
                     If (    ( Abs ( dPozTerm * 57.3 ) < 80.0 )
                          Or ( R                       < 20   )  ) Then
                     }

                    If (    ( dPozTerm < dPozTermOld )
                         Or ( Not VPointFind         )  )  Then
                      Begin { PointTerm °´®¶• ™ ëÆ´≠Ê„ }

                         { H•£†‚®¢≠†Ô íÆÁ™† }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                        NPointFind := False ;

                        If (    ( dPozTerm < dPozTermOld )
                             Or ( Not VPointFind         )  )  Then
                          Begin { H•£†‚®¢≠†Ô íÆÁ™† }

                            RGor1 := RGor + StepTerm ;

                            CExit := False ;

                            While (     ( Not CExit             )
                                    And ( RGor1 < Grad20 )  ) Do
                              Begin

                                SinRGor1 := Sin ( RGor1 ) ;
                                CosRGor1 := Cos ( RGor1 ) ;

                                MTerm1   := R_Pl / R_Planets [ 3 ] * CosRGor1 ;

                                { ñ•≠‚p ‚•p¨®≠†‚Æp† ¢ ‚•´• á•¨´® }
                                RCTerm1  := R_Planets [ NPl ] * SinRGor1 ;

                                DxCTerm1 := - XSunN * RCTerm1 ;
                                DyCTerm1 := - YSunN * RCTerm1 ;
                                DzCTerm1 := - ZSunN * RCTerm1 ;


                                Xt  := Ekv^[ I - 1 ].X / 100000.0 * MTerm1 ;
                                Yt  := Ekv^[ I - 1 ].Y / 100000.0 * MTerm1 ;
                                Zt  := Ekv^[ I - 1 ].Z / 100000.0 * MTerm1 ;

                                X1 := Xt                                ;
                                Y1 :=       Yt *     CDS   +  Zt * SDS  ;
                                Z1 :=       Yt * ( - SDS ) +  Zt * CDS  ;

                                Xt := X1 *     CLS    +  Y1 * SLS  ;
                                Yt := X1 * ( - SLS )  +  Y1 * CLS  ;
                                Zt := Z1                           ;

                                Xp  := Xt + XPl ;
                                Yp  := Yt + YPl ;
                                Zp  := Zt + ZPl ;

                                Xp := Xp + DxCTerm1 ;
                                Yp := Yp + DyCTerm1 ;
                                Zp := Zp + DzCTerm1 ;

                                R := Sqrt (   Sqr ( Xp )
                                            + Sqr ( Yp )
                                            + Sqr ( Zp )  ) ;

                                If ( R <= RPointMax )  Then
                                  Begin  { íÆÁ™† °´®ß™Æ }

                                    SD   := Zp / R ;
                                    CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;

                                    If ( CD > 2.0E-10 )
                                      Then
                                        Begin
                                          SR := Yp / R / CD ;
                                          CR := Xp / R / CD ;
                                        End
                                      Else
                                        Begin
                                          SR := C10 ;
                                          CR := 0.0 ;
                                        End ;

                                    ST   := SSTime * CR  -  CSTime * SR ;
                                    CT   := CSTime * CR  +  SSTime * SR ;

                                    SH   := SD * SFiS + CD * CFiS * CT ;

                                    SA   :=   CD * ST ;
                                    CA   := - SD * CFiS + CD * SFiS * CT ;

                                    { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }

                                    CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
                                    CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

                                    SDA  := SAOpt * CA  -  CAOpt  * SA ;

                                    SPoz := SDA;
                                    CPoz := SH * CHOpt  -  SHOpt * CDA ;

                                    YSt  :=   FD * CPoz / CRo ;
                                    XSt  := - FD * SPoz / CRo ;


                                    If ( NPolFix )  Then
                                      Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }

                                        Index :=    XSt ;
                                        XSt   :=    XSt  * CPozNP  +  YSt * SPozNP ;
                                        YSt   := - Index * SPozNP  +  YSt * CPozNP ;

                                      End ;


                                    DxObj := ( XSt - CenterX ) * DxSc ;
                                    DyObj := ( YSt - CenterY ) * DySc ;

                                    Sxt :=  Round ( dX + DxObj ) ;
                                    Syt :=  Round ( dY - DyObj ) ;


                                    If (     ( Sxt > Sw.x1 )
                                         And ( Sxt < Sw.x2 )
                                         And ( Syt > Sw.y1 )
                                         And ( Syt < Sw.y2 ) )  Then
                                      Begin { In Fild }

                                        PixColor := GetPixel ( Sxt , Syt ) ;

                                        If ( PixColor = ColorNight )  Then
                                          Begin

                                            SxN := SxT ;
                                            SyN := SyT ;

                                            NPointFind := True ;

                                            PixNight := True ;

                                            {≠ÆÁÏ}
                                            {
                                            SetColor ( Yellow ) ;
                                            Circle ( Sxt, Syt, 2 ) ;
                                            SetColor ( PlanetColor ) ;
                                            }
                                            CExit := True ;

                                            If ( dPozTerm > DPozTermOld ) Then
                                              Begin
                                                DPozTermOld := 100 ;
                                              End ;

                                          End ;

                                      End ; { In Fild }

                                  End ;  { íÆÁ™† °´®ß™Æ }

                                RGor1 := RGor1 + StepTerm ;

                              End ; { While }

                          End ; { H•£†‚®¢≠†Ô íÆÁ™† }



                         { é·¢•È•≠≠†Ô ‚ÆÁ™† |
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                        If (    ( dPozTerm < dPozTermOld )
                             Or ( Not VPointFind         ) )  Then
                          Begin  { VPointFind }

                            RGor1 := RGor - StepTerm ;

                            CExit := False ;

                            While (     ( Not CExit    )
                                    And ( RGor1 > RGor-Grad20 )  ) Do
                              Begin { While }

                                SinRGor1 := Sin ( RGor1 ) ;
                                CosRGor1 := Cos ( RGor1 ) ;

                                MTerm1   := R_Pl / R_Planets [ 3 ] * CosRGor1 ;

                                { ñ•≠‚p ‚•p¨®≠†‚Æp† ¢ ‚•´• è´†≠•‚Î }
                                RCTerm1  :=  R_Planets [ NPl ] * SinRGor1 ;

                                DxCTerm1 := - XSunN * RCTerm1 ;
                                DyCTerm1 := - YSunN * RCTerm1 ;
                                DzCTerm1 := - ZSunN * RCTerm1 ;

                                Xt  := Ekv^[ I - 1 ].X / 100000.0 * MTerm1 ;
                                Yt  := Ekv^[ I - 1 ].Y / 100000.0 * MTerm1 ;
                                Zt  := Ekv^[ I - 1 ].Z / 100000.0 * MTerm1 ;

                                X1 := Xt                                ;
                                Y1 :=       Yt *     CDS   +  Zt * SDS  ;
                                Z1 :=       Yt * ( - SDS ) +  Zt * CDS  ;

                                Xt := X1 *     CLS    +  Y1 * SLS  ;
                                Yt := X1 * ( - SLS )  +  Y1 * CLS  ;
                                Zt := Z1                           ;

                                Xp  := Xt + XPl ;
                                Yp  := Yt + YPl ;
                                Zp  := Zt + ZPl ;

                                Xp := Xp + DxCTerm1 ;
                                Yp := Yp + DyCTerm1 ;
                                Zp := Zp + DzCTerm1 ;


                                R := Sqrt (   Sqr ( Xp )
                                            + Sqr ( Yp )
                                            + Sqr ( Zp )  ) ;

                                If ( R <= RPointMax )  Then
                                  Begin  { íÆÁ™† °´®ß™Æ }

                                    SD   := Zp / R ;
                                    CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;
                                    If ( CD > 2.0E-10 )  Then
                                      Begin
                                        SR := Yp / R / CD ;
                                        CR := Xp / R / CD ;
                                      End
                                     Else
                                      Begin
                                        SR := C10 ;
                                        CR := 0.0 ;
                                      End ;

                                    ST   := SSTime * CR  -  CSTime * SR ;
                                    CT   := CSTime * CR  +  SSTime * SR ;

                                    SH   := SD * SFiS + CD * CFiS * CT ;

                                    SA   :=   CD * ST ;
                                    CA   := - SD * CFiS + CD * SFiS * CT ;

                                    { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }

                                    CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
                                    CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

                                    SDA  := SAOpt * CA  -  CAOpt  * SA ;

                                    SPoz := SDA;
                                    CPoz := SH * CHOpt  -  SHOpt * CDA ;

                                    YSt  :=   FD * CPoz / CRo ;
                                    XSt  := - FD * SPoz / CRo ;


                                    If ( NPolFix )  Then
                                      Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }

                                        Index :=    XSt ;
                                        XSt   :=    XSt  * CPozNP  +  YSt * SPozNP ;
                                        YSt   := - Index * SPozNP  +  YSt * CPozNP ;

                                      End ;


                                    DxObj := ( XSt - CenterX ) * DxSc ;
                                    DyObj := ( YSt - CenterY ) * DySc ;

                                    Sxt :=  Round ( dX + DxObj ) ;
                                    Syt :=  Round ( dY - DyObj ) ;

                                    If (     ( Sxt > Sw.x1 )
                                         And ( Sxt < Sw.x2 )
                                         And ( Syt > Sw.y1 )
                                         And ( Syt < Sw.y2 ) )  Then
                                      Begin { In Fild }

                                        PixColor := GetPixel ( Sxt, Syt ) ;

                                        If ( PixColor = ColorNight ) Then
                                          Begin

                                            If ( NPointFind )
                                              Then
                                                Begin

                                                  SxV := SxT ;
                                                  SyV := SyT ;

                                                  If ( Pair ) Then
                                                    Begin
                                                      {
                                                      SetColor ( White ) ;
                                                      Circle ( SxV, SyV, 3 ) ;
                                                      SetColor ( Yellow ) ;
                                                      Circle ( SxN, SyN, 3 ) ;
                                                      SetColor ( PlanetColor ) ;
                                                      }
                                                      VPointFind := True ;

                                                      SxTermNeg  [ NPTermViz ] := SxN ;
                                                      SyTermNeg  [ NPTermViz ] := SyN ;

                                                      SxTermViz  [ NPTermViz ] := SxV ;
                                                      SyTermViz  [ NPTermViz ] := SyV ;
                                                      {
                                                      PozTermViz [ NPTermViz ]
                                                          := Round ( dPozTerm );
                                                      }
                                                      PozTermViz [ NPTermViz ]
                                                          := dPozTerm ;

                                                      CExit := True ;

                                                    End ;

                                                End ;

                                          End ;

                                        End ; { In Fild }

                                    End ;  { íÆÁ™† °´®ß™Æ }

                                RGor1 := RGor1 - StepTerm ;

                              End ; { While }

                          End ;  { VPointFind }

                        dPozTermOld := dPozTerm ;

                      End ; { PointTerm °´®¶• ™ ëÆ´≠Ê„ }


                    If ( dPozTerm > DPozTermOld ) Then
                      Begin
                        CalcTerm := False ;
                      End ;

                  End ;  { Calc Point Term }

           End     { íÆÁ™† °´®¶• £Æp®ßÆ≠‚† }
                   { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
          Else
           Begin

             PointExist   := False ;
             PointInFild  := False ;
             CalcTerm     := False ;
             {}
             If ( VPointFind )  Then
               Begin
                 Inc ( NPTermViz ) ;
                 VPointFind := False ;
               End ;
             {}
           End ;

       End ; { I }


     If ( VPointFind )  Then
       Begin
         Inc ( NPTermViz ) ;
         VPointFind := False ;
       End ;



        { èpÆ¢•p™† ≠†´®Á®Ô ‚•p¨®≠†‚Æp† ¢ ØÆ´• ßp•≠®Ô }
        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     ReIzo    := False ;
     CExit    := False ;
     I        := 1     ;
     {
     PixNight := False ;
     }

     If ( MoonEclipse )  Then
       Begin

         If (     ( RTenMoonMin < RMoonUgl )
              And ( RTenMoonMin < 1000     ) )
           Then
             Begin { í•≠Ï Ø•p•·•™†•‚ ã„≠„ }

               If ( SxProxTen <> -100 )
                 Then
                   Begin  { íÆÁ™† ¢ ØÆ´• ßp•≠®Ô }

                     If ( SxMoon < SxCTen )
                       Then Inc ( SxProxTen )
                       Else Dec ( SxProxTen ) ;

                     If ( SyMoon < SyCTen )
                       Then Inc ( SyProxTen )
                       Else Dec ( SyProxTen ) ;
                     {
                     PutPixel  ( SxProxTen , SyProxTen , Yellow  ) ;
                     }

                     PixColor := GetPixel ( SxProxTen , SyProxTen ) ;

                     If ( PixColor = PlanetColor ) Then
                       Begin
                         SetFillStyle ( SolidFill, ColorNight ) ;
                         FloodFill ( SxProxTen , SyProxTen , ColorNight );
                         I := GraphResult ;
                      End ;

                   End
                 Else
                   Begin  { íÆÁ™† ¢≠• ØÆ´Ô ßp•≠®Ô }
                   End ;

             End
           Else
             Begin { í•≠Ï ≠• Ø•p•·•™†•‚ ã„≠„ }

               If ( SinMoonTenUgl <= RTenUgl )
                 Then
                   Begin
                     FildDay := False ;
                     Limb ( ColorNight , True ) ;
                   End
                 Else
                   Begin
                     FildDay := True ;
                     Limb ( PlanetColor , True ) ;
                   End ;

             End ;


       End ; { MoonEclipse }

     {
     For I := 1 To NPTermViz + 1  Do
       Begin
         SetColor ( White ) ;
         Circle ( SxTermViz  [ I ],
                  SyTermViz  [ I ], 3 ) ;

         SetColor ( Yellow ) ;
         Circle ( SxTermNeg  [ I ],
                  SyTermNeg  [ I ], 3 ) ;

         SetColor ( PlanetColor ) ;
       End ;
     }



     If ( Not MoonEclipse )  Then
      Begin { Not MoonEclipse }

       { Ä≠†´®ß Ø†p ‚ÆÁ•™ }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

       K         := NPTermViz - 1 ;
       NPTermViz := 0             ;
       {
       If (     ( NOutFild = 0 )
            And ( K        > 0 )  )  Then
         K := 1 ;
       }
       For I := 1 To K Do
         Begin

             SxV := SxTermViz [ I ] ;
             SyV := SyTermViz [ I ] ;

             SxN := SxTermNeg [ I ] ;
             SyN := SyTermNeg [ I ] ;
             {
             SVectX := SxN - SxV ;
             SVectY := SyN - SyV ;
             }
             {
             SetColor ( White ) ;
             Circle ( SxV, SyV, 1 ) ;
             SetColor ( Yellow ) ;
             Circle ( SxN, SyN, 1 ) ;
             }
             CExit  := False ;

             If ( Pair )  Then
               CExit := True ;

             If ( CExit )  Then
               Begin

                 Inc ( NPTermViz ) ;

                 SxTermViz  [ NPTermViz ] := SxTermViz  [ I ] ;
                 SyTermViz  [ NPTermViz ] := SyTermViz  [ I ] ;
                 PozTermViz [ NPTermViz ] := PozTermViz [ I ] ;

                 SxTermNeg  [ NPTermViz ] := SxTermNeg [ I ] ;
                 SyTermNeg  [ NPTermViz ] := SyTermNeg [ I ] ;
                 {
                 SetColor ( White ) ;
                 Circle ( SxV, SyV, 1 ) ;
                 SetColor ( Yellow ) ;
                 Circle ( SxN, SyN, 1 ) ;
                 }
                 {
                 SetColor ( White ) ;
                 PutPixel ( SxV, SyV, 3 ) ;
                 SetColor ( Yellow ) ;
                 PutPixel ( SxN, SyN, 3 ) ;
                 }
               End ;

         End ;

       (*
       For I := 1 To NPTermViz  Do
         Begin
           SetColor ( White ) ;
           Circle ( SxTermViz  [ I ],
                    SyTermViz  [ I ], 3 ) ;

           SetColor ( Yellow ) ;
           Circle ( SxTermNeg  [ I ],
                    SyTermNeg  [ I ], 3 ) ;

           SetColor ( PlanetColor ) ;
         End ;
       *)


        If ( NPTermViz > 0 )  Then
         Begin  { Ö·‚Ï é·¢•È•≠≠†Ô }

           CExit := False ;
           If ( B_Gran )
             Then I := 1
             Else I := NPTermViz ;

           While (     ( Not CExit      )
                   And ( I <= NPTermViz )  )  Do
            Begin

              DPozTerm := 1.0e12 ;

              For J := 1 To NPTermViz Do
                Begin { J }
                  If ( PozTermViz [ J ] < DPozTerm )  Then
                    Begin
                      K := J ;
                      DPozTerm := PozTermViz [ J ] ;
                    End ;
                End ; { J }

                  Sx := SxTermViz [ K ] ;
                  Sy := SyTermViz [ K ] ;

                  PozTermViz [ K ] := 1.0e13 ;
                  PixColor := GetPixel ( Sx, Sy ) ;

                  If ( PixColor = ColorNight )  Then
                    Begin

                        Begin
                          {
                          SetColor ( White ) ;
                          Circle ( Sx, Sy, 2 ) ;
                          }
                          {
                          SetColor ( ColorNight ) ;
                          Circle ( Sx, Sy, 2 ) ;
                          }

                          SetColor ( PlanetColor ) ;

                          SetFillStyle ( SolidFill, PlanetColor ) ;
                          FloodFill ( Sx , Sy , PlanetColor );

                          J := GraphResult ;

                        End ;

                    End ;
                  {
                  PutPixel ( Sx, Sy, White ) ;
                  }
              Inc ( I ) ;

            End { While } ;

         End ;   { Ö·‚Ï í•p¨®≠†‚Æp ¢ ØÆ´• }


      (*
      If (     ( Not PixNight   )
           And ( NpTermNeg > 0  )  )  Then
       Begin   { H® Æ§≠Æ© ‚ÆÁ™® ‚•p¨®≠†‚Æp† ≠•‚, ≠Æ •·‚Ï ≠•£†‚®¢≠Î• }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         PixNight := True  ;
         FildDay  := False ;

       End ;
       *)


      If ( NPTermViz = 0 )  Then
         Begin  { H•‚ í•p¨®≠†‚Æp† ® Æ·¢•È•≠≠Æ© ‚ÆÁ™® ¢ ØÆ´• }

           FildDay := True ;

           If ( PointLimbExist )
             Then
               Begin { HSunGor éØp•§•´Ô´†·Ï, í•p¨®≠†‚Æp† ≠† £Æp®ßÆ≠‚• ≠•‚ }

                 ReIzo := True ;
                 {
                 If ( ChSunGorMax > -2 )
                   Then
                     Begin
                       If ( HSunGor > 0 )
                         Then  FildDay := True
                         Else  FildDay := False ;
                     End
                   Else
                     Begin
                       If ( PhasePl < Pid2 )
                         Then  FildDay := True
                         Else  FildDay := False ;
                     End ;
                 }


                 If ( NNeg < NPoz )
                   Then  FildDay := True
                   Else  FildDay := False ;

                 If ( PhasePl*57.3 < 20.0 )
                   Then  FildDay := True ;

                 If ( PhasePl*57.3 > 160.0 )
                   Then  FildDay := False ;

                 {
                 If ( PhasePl < Pid2 )
                   Then  FildDay := True
                   Else  FildDay := False ;
                 }
               End   { HSunGor éØp•§•´Ô´†·Ï }
             Else
               Begin { ã®¨° ≠• ¢®§•≠ }

                 ReIzo := True  ;

                 If ( GScale > 1.000001 )
                   Then
                     Begin
                       {
                       If ( B_Import_Fld Or OptRd )
                         Then  IdToEq1 ( CenterX, CenterY,
                                         RaOptGlass, DeclOptGlass )
                         Else  IdToEq  ( CenterX, CenterY,
                                         NPolFix, SPozNp,CPozNp,
                                         RaOptGlass, DeclOptGlass );
                       }

                       IdToEq1 ( CenterX, CenterY,
                                          RaOptGlass, DeclOptGlass ) ;

                          { äÆÆp§®≠†‚Î Ê•≠‚p† „¢•´®Á•≠≠Æ£Æ ØÆ´Ô }
                          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                       XOptPlN := Cos ( RaOptGlass ) * Cos ( DeclOptGlass ) ;
                       YOptPlN := Sin ( RaOptGlass ) * Cos ( DeclOptGlass ) ;
                       ZOptPlN :=                      Sin ( DeclOptGlass ) ;

                     End
                   Else
                     Begin

                          { äÆÆp§®≠†‚Î Ê•≠‚p† Æ·≠Æ¢≠Æ£Æ ØÆ´Ô }
                          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                       XOptPlN := Cos ( RaOpt ) * Cos ( DeclOpt ) ;
                       YOptPlN := Sin ( RaOpt ) * Cos ( DeclOpt ) ;
                       ZOptPlN :=                 Sin ( DeclOpt ) ;

                     End ;



                 XPlN := XPl / RPl ;
                 YPlN := YPl / RPl ;
                 ZPlN := ZPl / RPl ;


                 { Cos „£´† 'Ê•≠‚p ØÆ´Ô' - 'Ø´†≠•‚†' }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                 CFiPlOpt :=   XOptPlN * XPlN
                             + YOptPlN * YPlN
                             + ZOptPlN * ZPlN ;

                 SFiPlOpt := Sqrt (   Sqr ( YOptPlN * ZPlN - ZOptPlN * YPlN )
                                    + Sqr ( ZOptPlN * XPlN - XOptPlN * ZPlN )
                                    + Sqr ( XOptPlN * YPlN - YOptPlN * XPlN )  )  ;
                 {
                 If ( Sqr ( CFiPlOpt ) > C10 )
                   Then
                     Begin
                       CFiPlOpt := C10 ;
                       SFiPlOpt := 0.0 ;
                     End
                   Else
                       SFiPlOpt := Sqrt ( C10 - Sqr ( CFiPlOpt ) ) ;
                 }
                    { ì£Æ´  'Ê•≠‚p ØÆ´Ô' - 'Ø´†≠•‚†' }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                 FiPlOpt := ArcTAn ( SFiPlOpt / CFiPlOpt ) ;


                 SFiSatPlOpt := RPl * SFiPlOpt / R_Pl ;
                 FiSatPlOpt  := Pi - ArcTan ( SFiSatPlOpt /
                                              Sqrt ( C10 - Sqr ( SFiSatPlOpt ) ) ) ;

                 FiSatPlOpt  := Pi - ( FiPlOpt + FiSatPlOpt ) ;

                 If ( Abs ( SFiPlOpt ) > 1.0e-11 )
                   Then  ROptPl := R_Pl * Sin ( FiSatPlOpt ) / SFiPlOpt
                   Else  ROptPl := RPl - R_Pl ;


               { Ç•™‚Æp H†°´Ó§†‚•´Ï - íÆÁ™† Ø•p•·•Á•≠®Ô éØ‚. é·® · Ø´†≠•‚Æ© }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                 XOptPl := XOptPlN * ROptPl ;
                 YOptPl := YOptPlN * ROptPl ;
                 ZOptPl := ZOptPlN * ROptPl ;


               { Ç•™‚Æp ñ. è´. - íÆÁ™† Ø•p•·•Á•≠®Ô éØ‚. é·® · Ø´†≠•‚Æ© }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                 XOptPl := XOptPl - XPl ;
                 YOptPl := YOptPl - YPl ;
                 ZOptPl := ZOptPl - ZPl ;


                 ROptPl := Sqrt (   Sqr ( XOptPl )
                                  + Sqr ( YOptPl )
                                  + Sqr ( ZOptPl )  ) ;

                 XOptPlN := XOptPl / ROptPl ;
                 YOptPlN := YOptPl / ROptPl ;
                 ZOptPlN := ZOptPl / ROptPl ;

                 XSun0 :=  RectCoordPl [ 11 , 1 ] - XPl ;
                 YSun0 :=  RectCoordPl [ 11 , 2 ] - YPl  ;
                 ZSun0 :=  RectCoordPl [ 11 , 3 ] - ZPl  ;

                 RSun := Sqrt ( Sqr ( XSun0 ) + Sqr ( YSun0 ) + Sqr ( ZSun0 ) ) ;

                 XSunN := XSun0 / RSun ;
                 YSunN := YSun0 / RSun ;
                 ZSunN := ZSun0 / RSun ;


                 If (   XOptPlN * XSunN
                      + YOptPlN * YSunN
                      + ZOptPlN * ZSunN ) > 0
                   Then FildDay := True
                   Else FildDay := False ;

               End ; { ã®¨° ≠• ¢®§•≠ }

         End ;  { H•‚ í•p¨®≠†‚Æp† ® Æ·¢•È•≠≠Æ© ‚ÆÁ™® ¢ ØÆ´• }

      End ; { Not MoonEclipse }

   End ; { Terminator }


          { *********************** }




 Procedure IzoMateriki ;

  Var

      I, J, IEnd    : Integer ;

      X, Y, Z,
      Rx, Ry, Rh,
      CLS, SLS,
      SDS, CDS,
      SLat, CLat,
      SLong, CLong  : Double  ;

   Begin

         { å†‚•p®™® }
         { ‹‹‹‹‹‹‹‹ }


     SLS := Sin ( - SGrinv ) ;
     CLS := Cos ( - SGrinv ) ;


     ColorPixel  := Black ;
     Prima       := False ;
     OldExist    := False ;
     PointInFild := False ;


        { ù™¢†‚Æp }
        { ƒƒƒƒƒƒƒ }

     For  I := 1  To  361 Do
       Begin { I }
             { - }

         ColorPixel := Red ;

         XIg := Ekv^[ I ].X / 100000.0 + XPl ;
         YIg := Ekv^[ I ].Y / 100000.0 + YPl  ;
         ZIg := Ekv^[ I ].Z / 100000.0 + ZPl  ;

         IzoGrid ;

       End ; { I }
             { - }






        { è†p†´´•´® }
        { ƒƒƒƒƒƒƒƒƒ }


     For J := -2 To 2 Do
       If ( J <> 0 )  Then
         Begin

           Prima       := False ;
           OldExist    := False ;
           PointInFild := False ;
           ColorPixel  := Black ;

           RY := 3.14159265359 / 6.0 * J ;  { Lat  }
           SLat := Sin ( RY ) ;
           CLat := Cos ( RY ) ;
           {
           RH := 0.99832707 + 0.00167644 * Cos ( C20 * RY ) -
                              0.00000352 * Cos ( 4.0 * RY )   ;
           }

           For I := 1 To 365 Do
             Begin

               RX := 3.14159265359 / 180.0 * I ;  { Long }
               {
               X := R_Planets [3] * RH * Cos ( RX ) * CLat + XPl ;
               Y := R_Planets [3] * RH * Sin ( RX ) * CLat + YPl ;
               Z := R_Planets [3] * RH *              SLat + ZPl ;
               }

               XIg := R_Planets [3] * Cos ( RX ) * CLat + XPl ;
               YIg := R_Planets [3] * Sin ( RX ) * CLat + YPl ;
               ZIg := R_Planets [3] *              SLat + ZPl ;

               IzoGrid ;

             End ;

         End ;





        { å•p®§®†≠Î }
        { ƒƒƒƒƒƒƒƒƒ }

     For J := 1 To 6 Do
       Begin

         Prima       := False ;
         OldExist    := False ;
         PointInFild := False ;
         If ( J = 1 )
           Then ColorPixel := Red
           Else ColorPixel := Black ;

         RX := 3.14159265359 / 6.0 * (J-1) ;  { Long }
         SLong := Sin ( RX ) ;
         CLong := Cos ( RX ) ;

         For I := 1 To 365 Do
           Begin

             RY := 3.14159265359 / 180.0 * I ;  { Lat  }
             SLat := Sin ( RY ) ;
             CLat := Cos ( RY ) ;

             X1 := R_Planets [3] * CLong * CLat ;
             Y1 := R_Planets [3] * SLong * CLat ;
             Z1 := R_Planets [3] *         SLat ;

               { ëÆ°·‚¢•≠≠Æ• ¢p†È•≠®• á•¨´® }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
             XIg := X1 *     CLS    +  Y1 * SLS  +  XPl ;
             YIg := X1 * ( - SLS )  +  Y1 * CLS  +  YPl ;
             ZIg := Z1                           +  ZPl ;

             IzoGrid ;

           End ;

       End ;







     ColorPixel  := Black ;
     Prima       := False ;
     OldExist    := False ;
     PointInFild := False ;



        { å†‚•p®™® }
        { ƒƒƒƒƒƒƒƒ }

     If ( NPl = 3 )
       Then
         Begin
           If ( RPl < SekRad )
             Then  IEnd := NumPointMateriki + 1
             Else  IEnd := NumPointMateriki     ;
         End
       Else
           IEnd := NumPointMateriki     ;

     If ( Materiki <> Nil )  Then
      For  I := 1  To  IEnd Do
       Begin { I }
             { - }

         If ( Materiki^[ I ].E  =  3 )  Then
           ColorPixel := Blue ;

         If ( Materiki^[ I ].E  =  5 )  Then
           Begin
             ColorPixel := Yellow ;
             Prima := True ;
           End ;

         X1 := Materiki^[ I ].X / 5.0 ;
         Y1 := Materiki^[ I ].Y / 5.0 ;
         Z1 := Materiki^[ I ].Z / 5.0 ;

         If ( I <= NumPointMateriki )
           Then
             Begin  { ëÆ°·‚¢•≠≠Æ• ¢p†È•≠®• á•¨´® }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
               X := X1 *     CLS    +  Y1 * SLS  +  XPl ;
               Y := X1 * ( - SLS )  +  Y1 * CLS  +  YPl ;
               Z := Z1                           +  ZPl ;
             End
           Else
             Begin
               X := X1 +  XPl ;
               Y := Y1 +  YPl ;
               Z := Z1 +  ZPl ;
               Prima := True  ;
             End ;

         RPoint := Sqrt ( X*X + Y*Y + Z*Z ) ;


         If (    ( RPoint <= RPointMax )
              Or (     ( PointInFild )
                   And ( Not Prima   ) ) ) Then
           Begin  { íÆÁ™† °´®ß™Æ }

              { ë‰•p®Á•·™®• ™ÆÆp§®≠†‚Î }

              SD   := Z / RPoint                     ;
              CD   := SQRT ( ABS ( C10 - SD * SD ) ) ;
              If ( CD > 2.0E-10 )  Then
                 Begin
                   SR := Y / RPoint / CD ;
                   CR := X / RPoint / CD ;
                 End
               Else
                 Begin
                   SR := C10 ;
                   CR := 0.0 ;
                 End ;


              ST   := SSTime * CR  -  CSTime * SR ;
              CT   := CSTime * CR  +  SSTime * SR ;

              SH   := SD * SFiS + CD * CFiS * CT ;

              SA   :=   CD * ST ;
              CA   := - SD * CFiS + CD * SFiS * CT ;


               { ÇÎÁ®·´•≠Î £Æp®ßÆ≠‚†´Ï≠Î• ™ - ‚Î }

              CDA  :=  CA   * CAOpt  +  SA   * SAOpt  ;
	      CRo  := SHOpt *  SH    + CHOpt *  CDA   ;

              If ( CRo > 0.02 ) Then
                Begin  { CRo > 0 }

                  SDA  := SAOpt * CA  -  CAOpt  * SA ;

	          SPoz := SDA;
                  CPoz := SH * CHOpt  -  SHOpt * CDA ;

	          YSt  :=   FD * CPoz / CRo ;
	          XSt  := - FD * SPoz / CRo ;


                  If ( NPolFix )  Then
                    Begin { ëíÄÅàãàáÄñàü éëà Y çÄ ëÖÇÖêçõâ èéãûë }

                      Index :=    XSt ;
                      XSt   :=    XSt  * CPozNP  +  YSt * SPozNP ;
                      YSt   := - Index * SPozNP  +  YSt * CPozNP ;

                    End ;


                  DxObj := ( XSt - CenterX ) * DxSc ;
                  DyObj := ( YSt - CenterY ) * DySc ;

                  Sx :=  Round ( dX + DxObj ) ;
                  Sy :=  Round ( dY - DyObj ) ;


                  If (     ( Sx >= Sw.x1 )
                       And ( Sx <= Sw.x2 )
                       And ( Sy >= Sw.y1 )
                       And ( Sy <= Sw.y2 ) )
                    Then

                       Begin  { Ç ØÆ´• ßp•≠®Ô }

                         SetColor ( ColorPixel ) ;

                         If ( I = NumPointMateriki + 1 )
                           Then
                             Begin  { Zaichik }
                               SetColor     ( LightGray ) ;
                               SetFillStyle ( SolidFill, LightGray ) ;
                               FillEllipse  ( Sx, Sy, 5, 4 ) ;
                             End
                           Else
                             Begin

                               If ( Prima )
                                 Then
                                   Begin
                                     If ( ColorPixel = Yellow )
                                       Then
                                         Begin
                                           SetColor     ( Yellow ) ;
                                           SetFillStyle ( SolidFill, Yellow ) ;
                                           FillEllipse  ( Sx, Sy, 1, 1 ) ;
                                         End
                                       Else
                                         Begin
                                           PutPixel ( Sx, Sy, ColorPixel ) ;
                                           Prima := False ;
                                         End ;
                                   End
                                 Else
                                   Begin
                                     If ( OldExist )  Then
                                       Line  ( SxOld, SyOld, Sx, Sy ) ;
                                   End ;

                             End ;

                         PointInFild := True ;

                       End   { Ç ØÆ´• ßp•≠®Ô }
                    Else
                       Begin
                         If (     ( PointInFild )
                              And ( Not Prima   ) )  Then
                            Line  ( SxOld, SyOld, Sx, Sy ) ;
                         PointInFild  := False ;
                       End ;

                    If ( RPoint <= RPointMax )
                      Then
                        Begin
                          SxOld    := Sx ;
                          SyOld    := Sy ;
                          OldExist := True ;
                        End
                      Else
                        Begin
                          OldExist     := False ;
                          PointInFild  := False ;
                        End ;

                End ;  { CRo > 0 }

           End   { íÆÁ™† °´®ß™Æ }
         Else
           Begin { íÆÁ™† §†´•™Æ }
             OldExist     := False ;
             PointInFild  := False ;
           End ;

         If  (  Materiki^[ I ].E  =  1 )
           Then  Prima := True
           Else  Prima := False ;

       End ; { I }
             { - }
   End ; { IzoMateriki }

           { ********************** }

 { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

   Begin

     CenterMoon := False ;

     With Sw Do
       Begin

         SetViewPort ( x1, y1, x2, y2, clipon ) ;

         dX := ( x2 - x1 + 1 ) / C20 ;
         dY := ( y2 - y1 + 1 ) / C20 ;
         {
         DxSc := GScale / XMax * dX  ;
         DySc := GScale / YMax * dY  ;
         }
         DxSc := XOrient * GScale / XMax * dX  ;
         DySc := YOrient * GScale / YMax * dY  ;

       End;


     NPl := S_Planet.Nr ;

     Phase :=  S_Planet.Phase          ;
     R_Pl  :=  R_Planets   [ NPl     ] ;

     XPl   :=  RectCoordPl [ NPl , 1 ] ;
     YPl   :=  RectCoordPl [ NPl , 2 ] ;
     ZPl   :=  RectCoordPl [ NPl , 3 ] ;

     RPl   :=  Sqrt ( Sqr ( XPl ) + Sqr ( YPl ) + Sqr ( ZPl ) ) ;


     If ( NPl <> 11 )  Then
       If ( NPl0 <> 11 )
         Then
           Begin  { PhasePl }

             XSun  :=  RectCoordPl [ 11 , 1 ] ;
             YSun  :=  RectCoordPl [ 11 , 2 ] ;
             ZSun  :=  RectCoordPl [ 11 , 3 ] ;

             RSun :=  Sqrt ( Sqr ( XSun ) + Sqr ( YSun ) + Sqr ( ZSun ) ) ;

             XPlSun := XSun - XPl ;
             YPlSun := YSun - YPl ;
             ZPlSun := ZSun - ZPl ;

             RPlSun :=  Sqrt ( Sqr ( XPlSun ) + Sqr ( YPlSun ) + Sqr ( ZPlSun ) ) ;

             PhasePl :=  (   XPlSun * ( - XPl )
                           + YPlSun * ( - YPl )
                           + ZPlSun * ( - ZPl ) ) / ( RPl * RPlSun ) ;
             PhasePl := ATan2 ( Sqrt ( 1.0 - Sqr ( PhasePl ) ), PhasePl ) ;

           End  { PhasePl }
         Else
             PhasePl := 0.0 ;


     RPointMax  := Sqrt ( Sqr ( RPl ) - Sqr ( R_Pl ) ) ;
     dRPointMax := RPointMax / RPl ;
     dRPointMax := RPl - RPointMax * dRPointMax ;

     If ( NPl = 3 )  Then
       RPointMaxEartch := RPointMax ;

     Xc  := S_Planet.X ;
     Yc  := S_Planet.Y ;

     If ( Abs ( Xc ) < 2147483646.0 )
       Then  SxC :=  Round ( Xc )
       Else  SxC :=  2147483646 * Round ( Xc / Abs ( Xc ) ) ;
     If ( Abs ( Yc ) < 2147483646.0 )
       Then  SyC :=  Round ( Yc )
       Else  SyC :=  2147483646 * Round ( Yc / Abs ( Yc ) ) ;

     SxP := SxC ;
     SyP := SyC ;

     SxCFld := Round ( ( Sw.x1 + Sw.x2 ) / C20 ) ;
     SyCFld := Round ( ( Sw.y1 + Sw.y2 ) / C20 ) ;

     PlanetColor := PlColArr [ NPl ] ;
     {
     PhasePl     := S_Planet.Phase ;
     }

     CenterMoon := False ;
     If (     ( NPl  = 10 )
          And ( NPl0 = 11 )  )  Then
       CenterMoon := True ;  { ã„≠† ≠† ‰Æ≠• á•¨´® · ëÆ´≠Ê† }



     MoonEclipse := False ;


      If (     ( Not B_From_Star )
          And ( NPl  = 10       )
          And ( NPl0 =  3       )  )   Then
       Begin
         If ( PhasePl * Rg ) <= 2.5  Then
           MoonEclipse := True  ;
       End ;


       { ê®·Æ¢†≠®• }
       { ‹‹‹‹‹‹‹‹‹ }

    CalcLimb ;

    If ( PointLimbFind )  Then
    Begin { PointLimbFind }
      If ( NPl = 11 )
       Then
           Limb ( PlanetColor, True )
       Else
         Begin

           If (    ( Not B_Surf                  )
                Or ( B_Surf And ( NPl <> NPl0 )  )  )
             Then
               Begin

                 If (     ( NPl  = 10 )
                      And ( NPl0 = 11 )
                      And ( R_Planets [ 10 ] < R_Planets [ 3 ] )  )
                   Then
                     Begin
                       CenterMoon := True ;
                       Limb ( PlanetColor, False ) ; { ã„≠† ≠† ‰Æ≠• á•¨´® }
                       CenterMoon := False ;
                     End
                   Else
                     Begin

                       CenterMoon := False ;

                       Limb ( Brown, True ) ; { ÇÎp•ß†≠®• §ÎpÎ ¢ ≠•°• }

                       If ( MoonEclipse )
                         Then  Limb ( PlanetColor, True )
                         Else  Limb ( ColorNight , True ) ;

                       Terminator ;

                       If ( ReIzo )  Then
                         Begin { è•p•p®·Æ¢Î¢†•¨ : Term - }
                           If ( FildDay )  Then
                             Limb ( PlanetColor , True ) ;
                         End ;


                       Limb ( Black , False ) ;         { Ç≠•Ë≠®© ™p„£ }

                       If (     ( NPl = 3    )
                            And ( Not B_Surf
                                  Or  B_Geoc )  )   Then
                          IzoMateriki ;                 { ä†p‚† á•¨´® }

                     End ;

               End ;

         End ;

     End ; { PointLimbFind }

   End ;  { ShowMateriki }
          { ƒƒƒƒƒƒƒƒƒƒƒƒ }




Procedure ShowPlanets;

Const

 SRStpX    : Integer = 2             ;
 SRStpY    : Integer = 1             ;



Var

 CCol     : Byte        ;
 SColor   : Byte        ;

 NPoint,
 SRadii   : Word        ;

 I, J,
 Ind,
 sx, sy   : Integer     ;

 NSat     : LongInt     ;

 DMvPlanet,
 SradiiReal,
 {
 DxSc  ,
 DySc  ,
 }
 DxObj ,
 DyObj ,
 D,
 XUgol,
 YUgol,
 SXm , SYm                : DOUBLE       ;

 C_P                      : PointType    ;
 vp                       : ViewPortType ;



Procedure RegVis ;  { é°´†·‚Ï ¢®§®¨Æ·‚® ëØ„‚≠®™† }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
Var

   I                   : Integer ;

   XSat,  YSat,  ZSat  : Single  ;

   SSat,
   SS, CS, SP, CP,
   SDSat, CDSat,
   SRSat, CRSat,
   SdRa, CdRa, DRaGrn,
   RaSat,
   XcSat, YcSat, ZcSat,
   RcSat,
   SRGrn, CRGrn,
   SDGrn, CDGrn,
   RSat                : Double  ;


  Begin


    XSat := SatEartchPoint^[NPoint].XGeoc ;
    YSat := SatEartchPoint^[NPoint].YGeoc ;
    ZSat := SatEartchPoint^[NPoint].ZGeoc ;

    RSat := Sqrt ( Sqr ( XSat ) + Sqr ( YSat ) + Sqr ( ZSat ) ) ;

    XX := Sqrt ( Sqr ( RSat ) - Sqr ( R_Planets [ 3 ] ) ) ;

    SS := XX / RSat ;
    CS := R_Planets [ 3 ] / RSat ;

    { ìÁ•‚ ê•‰p†™Ê®® }
    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
    SSat := ATan2 ( SS, CS ) ;
    SSat := SSat + Abs ( HGor ) ;
    SS := Sin ( SSat ) ;
    CS := Cos ( SSat ) ;

    Prima       := True  ;
    OldExist    := False ;
    PointInFild := False ;
    ColorPixel  := White ;

    SDSat := ZSat / RSat ;
    CDSat := Sqrt ( C10 - Sqr ( SDSat ) ) ;
    If ( Abs ( CDSat ) > 1.0e-10 )
      Then
        Begin
          SRSat := YSat / RSat / CDSat ;
          CRSat := XSat / RSat / CDSat ;
        End
      Else
        Begin
          SRSat := 0.0 ;
          CRSat := C10 ;
        End ;

    RaSat := ATan2 ( SRSat, CRSat ) ;

    XcSat := RectCoordPl [ 3 , 1 ] ;
    YcSat := RectCoordPl [ 3 , 2 ] ;
    ZcSat := RectCoordPl [ 3 , 3 ] ;

    RcSat := R_Planets   [ 3     ] ;


    For I := 1 To 361 Do
      Begin

        XX := Pi2 / 360.0 * I ;

        SP := Sin ( XX ) ;
        CP := Cos ( XX ) ;

        SDGrn := CS * SDSat + SS * CDSat * CP ;
        CDGrn := Sqrt ( C10 - Sqr ( SDGrn ) ) ;

        SdRa := SS * SP ;
        CdRa := CS * CDSat - SS * SDSat * CP ;

        DRaGrn := ATan2 ( SdRa, CdRa ) ;

        SRGrn := Sin ( RaSat + DRaGrn ) ;
        CRGrn := Cos ( RaSat + DRaGrn ) ;

        XIg := RcSat * CRGrn * CDGrn ;
        YIg := RcSat * SRGrn * CDGrn ;
        ZIg := RcSat *         SDGrn ;


        XIg := XIg + XcSat ;
        YIg := YIg + YcSat ;
        ZIg := ZIg + ZcSat ;


        IzoGrid ;

      End ;

  End ; { RegVis }


  { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

Begin

 GetViewSettings ( vp ) ;

 With Sw Do
 Begin

  setviewport(x1,y1,x2,y2,clipon);

  SXm := (x2-x1+C10)/C20;
  SYm := (y2-y1+C10)/C20;

  DxSc := XOrient * GScale / XMax * SXm  ;
  DySc := YOrient * GScale / YMax * SYm  ;
  {
  DxSc :=           GScale / XMax * SXm  ;
  DySc :=           GScale / YMax * SYm  ;
  }
 End;

 If B_Import_Sat Then
   Reset ( SatNameFile ) ;

 If ( NPlanetsInFild > 0 )  Then
 SortPlanetsInField ;

 NSatInFild := 0 ;


 If ( NPlanetsInFild > 0 )  Then
 For Ind := NPlanetsInFild DownTo 1 Do
 Begin { Ind }

  PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                            [ Ind Mod PlanetBlockSize ] ;

  If PlanetRecord.Visible Then    { In field }
                                  { ƒƒƒƒƒƒƒƒ }
  Begin { Visible }


   With PlanetRecord Do
   Begin { Planet[Ind] }
         { ƒƒƒƒƒƒƒƒƒƒƒ }

    NowVisible := False ;

    D := D_IZO * GScale / XMax * ( Sw.x2 - Sw.x1 + 1 ) / C20;


    If (     ( Abs ( x - SXm ) <= SXm                         )
         And ( Abs ( y - SYm ) <= SYm + D / C20 * XAsp / YAsp ) )  Then
      NowVisible := True ;

    If (     ( Abs ( y - SYm ) <= SYm                         )
         And ( Abs ( x - SXm ) <= SXm + D / C20               ) )  Then
      NowVisible := True ;


    For I := -1 To 1 Do
      For J := -1 To 1 Do
        Begin
          If (     ( I <> 0 )
               And ( J <> 0 )  )  Then
            Begin

              XUgol := SXm + I * SXm ;
              YUgol := SYm + J * SYm ;

              If ( Sqrt (   Sqr   ( X - XUgol                     )
                          + Sqr ( ( Y - YUgol ) / ( XAsp / YAsp ) ) )
                   <= D / C20                                         )  Then
                NowVisible := True ;

            End ;
        End ;



    If ( NowVisible ) Then
    Begin  { NowVisible }
           { ƒƒƒƒƒƒƒƒƒƒ }

     c_p.x :=  Round ( X ) ;
     c_p.y :=  Round ( Y ) ;

     If ( D > 10.0 )
      Then
       Begin   { Ñ®·™ }
               { ƒƒƒƒ }

          If (    ( Not B_Object_Tracks       )
               Or (     ( B_Object_Tracks   )
                    And ( NPlOpt = 11     ) ) )  Then

             PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                       [ Ind Mod PlanetBlockSize ] ;

             ShowMateriki ( PlanetRecord ) ;

       End     { Ñ®·™ }
               { ƒƒƒƒ }
      Else

       Begin  { á¢•ß§ÆÆ°p†ß≠Æ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

        ccol  := getcolor;

        PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                  [ Ind Mod PlanetBlockSize ] ;

        If ( PlanetRecord.Nr > Max_PL_PPLFLD )  Then
          Begin  { SATELLIT }
                 { ƒƒƒƒƒƒƒƒ }

            SetColor ( LightGreen ) ;
            NSat := PlanetRecord.Nr - Max_Pl_PPlFld ;

            If ( PlanetRecord.Phase > 0 )
              Then
                Begin
                  SetColor ( White ) ;
                  If ( B_Cdc_Cat )  Then
                     SetColor ( LightGreen ) ;
                  If ( B_Gsc )  Then
                     SetColor ( LightBlue  ) ;
                End
              Else
                Begin
                  SetColor ( LightRed  ) ;
                End ;


            SColor := GetColor ;

            Seek ( SatNameFile, NSat - 1   ) ;
            Read ( SatNameFile, SatNameRec ) ;

            If ( SatNameRec.NumberSat < 0 )
              Then
                Begin { å•Á•≠Î• }
                  Inc ( NSatInFild ) ;
                End   { å•Á•≠Î• }
              Else
                Begin

                  Inc ( NSatInFild ) ;

                  If ( StarsInFild )

                    Then
                      Begin
                        If ( B_Object_Tracks )
                          Then
                            PutPixel ( C_p.x, C_p.y, SColor )
                          Else
                            Rectangle ( ( C_p.X - SRStpX ), ( C_p.Y - SRStpY ),
                                        ( C_p.X + SRStpX ), ( C_p.Y + SRStpY ) ) ;
                      End
                    Else
                      Begin
                        If ( SColor = LightRed )
                          Then
                            Begin
                              Line ( C_p.x - 1  , C_p.y  ,
                                     C_p.x + 1  , C_p.y   ) ;

                              Line ( C_p.x , C_p.y - 1  ,
                                     C_p.x , C_p.y + 1    ) ;
                            End
                          Else
                            Begin
                              PutPixel ( C_p.x, C_p.y, SColor ) ;
                            End ;
                      End ;
                End ;

          End    { SATELLIT }
                 { ƒƒƒƒƒƒƒƒ }
         Else

          If (    ( Not  B_Object_Tracks                    )
               Or ( B_Object_Tracks And B_Import_Sat        )
               Or ( B_Object_Tracks And ( Not StarsInFild ) ) ) Then
          Begin  { PLANET }
                 { ƒƒƒƒƒƒ }

            PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                      [ Ind Mod PlanetBlockSize ] ;

            SetFillStyle( solidfill, PlColArr [ PlanetRecord.Nr ] );

            DMvPlanet :=  MVMAX - M ;

            SradiiReal := 1 +  KMD * DMvPlanet ;

            If ( SRadiiReal > 6 )  Then
              SRadiiReal := 6.0 ;
            If ( SRadiiReal < 1 )  Then
              SRadiiReal := C10 ;

            Sradii := Trunc ( Sradiireal ) ;

            SColor := PlColArr [ PlanetRecord.Nr ] ;
            SetColor     ( SColor            );
            SetFillStyle ( Solidfill, SColor );

            Sx := c_p.x ;
            Sy := c_p.y ;

            Case SRadii Of

                 1:  Begin

                       PutPixel ( Sx, Sy, SColor ) ;

                       If ( StarsInFild Or ( NumberOfSatellits > 0 ) ) Then
                         Begin
                           PutPixel ( Sx-2, Sy, SColor ) ;
                           PutPixel ( Sx+2, Sy, SColor ) ;
                           PutPixel ( Sx, Sy-2, SColor ) ;
                           PutPixel ( Sx, Sy+2, SColor ) ;
                         End ;

                     End ;

                 2:  Begin

                       PutPixel ( Sx  , Sy   , SColor ) ;
                       PutPixel ( Sx+1, Sy   , SColor ) ;

                       If ( StarsInFild Or ( NumberOfSatellits > 0 ) ) Then
                         Begin
                          PutPixel ( Sx-2, Sy, SColor ) ;
                          PutPixel ( Sx+3, Sy, SColor ) ;
                          PutPixel ( Sx, Sy-2, SColor ) ;
                          PutPixel ( Sx, Sy+2, SColor ) ;
                         End ;

                     End ;

                 3:  Begin

                       Line ( Sx-1 , Sy   , Sx+1 , Sy   ) ;
                       Line ( Sx   , Sy-1 , Sx   , Sy+1 ) ;

                       If ( StarsInFild Or ( NumberOfSatellits > 0 ) ) Then
                         Begin
                          PutPixel ( Sx-3, Sy, SColor ) ;
                          PutPixel ( Sx+3, Sy, SColor ) ;
                          PutPixel ( Sx, Sy-3, SColor ) ;
                          PutPixel ( Sx, Sy+3, SColor ) ;
                         End ;

                     End ;

                 4: Begin

                      Line ( Sx-1  , Sy-1   , Sx+1  , Sy-1   ) ;
                      Line ( Sx-1  , Sy     , Sx+1  , Sy     ) ;
                      Line ( Sx-1  , Sy+1   , Sx+1  , Sy+1   ) ;

                      If ( StarsInFild Or ( NumberOfSatellits > 0 ) ) Then
                        Begin
                          PutPixel ( Sx-3, Sy, SColor ) ;
                          PutPixel ( Sx+3, Sy, SColor ) ;
                          PutPixel ( Sx, Sy-3, SColor ) ;
                          PutPixel ( Sx, Sy+3, SColor ) ;
                        End ;

                     End ;

                 5: Begin

                      Line ( Sx-1 , Sy-1 , Sx+1 , Sy-1 ) ;
                      Line ( Sx-2 , Sy   , Sx+2 , Sy   ) ;
                      Line ( Sx-1 , Sy+1 , Sx+1 , Sy+1 ) ;
                      Line ( Sx   , Sy-2 , Sx   , Sy+2 ) ;

                      If ( StarsInFild Or ( NumberOfSatellits > 0 ) ) Then
                        Begin
                          PutPixel ( Sx-4, Sy, SColor ) ;
                          PutPixel ( Sx+4, Sy, SColor ) ;
                          PutPixel ( Sx, Sy-4, SColor ) ;
                          PutPixel ( Sx, Sy+4, SColor ) ;
                        End ;

                     End ;

                 6: Begin

                      Line ( Sx-1 , Sy-2 , Sx+1 , Sy-2 ) ;
                      Line ( Sx-2 , Sy-1 , Sx+2 , Sy-1 ) ;
                      Line ( Sx-3 , Sy   , Sx+3 , Sy   ) ;
                      Line ( Sx-2 , Sy+1 , Sx+2 , Sy+1 ) ;
                      Line ( Sx-1 , Sy+2 , Sx+1 , Sy+2 ) ;

                      If ( StarsInFild Or ( NumberOfSatellits > 0 ) ) Then
                        Begin
                          PutPixel ( Sx-5, Sy, SColor ) ;
                          PutPixel ( Sx+5, Sy, SColor ) ;
                          PutPixel ( Sx, Sy-4, SColor ) ;
                          PutPixel ( Sx, Sy+4, SColor ) ;
                        End ;

                     End ;

            End ; { Case }

          End    { PLANET } ;

        SetColor ( CCol ) ;


       End ;  { á¢•ß§ÆÆ°p†ß≠Æ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    End ;  { NowVisible }
           { ƒƒƒƒƒƒƒƒƒƒ }

   End;  { Planet[Ind] }
         { ƒƒƒƒƒƒƒƒƒƒƒ }

  End ; { Visible }

 End ; { Ind }





 { èÆ¨•Á•≠Î• ·Ø„‚≠®™® }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 If ( NPlanetsInFild > 0 )  Then
 {
 For Ind := NPlanetsInFild DownTo ( Max_PL_PPLFLD + 1 ) Do
 }
 For Ind := NPlanetsInFild DownTo 1 Do
 Begin { Ind }

  PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                            [ Ind Mod PlanetBlockSize ] ;

  If PlanetRecord.Visible Then  { In field }
                                { ƒƒƒƒƒƒƒƒ }
  Begin { Visible }

   With PlanetRecord Do
   Begin { Planet[Ind] }
         { ƒƒƒƒƒƒƒƒƒƒƒ }
    NowVisible := False ;

    D := D_IZO * GScale / XMax * ( Sw.x2 - Sw.x1 + 1 ) / C20;

    SxOld :=  Round ( X ) ;
    SyOld :=  Round ( Y ) ;


    If (     ( Abs ( x - SXm ) <= SXm                         )
         And ( Abs ( y - SYm ) <= SYm + D / C20 * XAsp / YAsp ) )  Then
      NowVisible := True ;


    If (     ( Abs ( y - SYm ) <= SYm                         )
         And ( Abs ( x - SXm ) <= SXm + D / C20               ) )  Then
      NowVisible := True ;


    For I := -1 To 1 Do
      For J := -1 To 1 Do
        Begin
          If (     ( I <> 0 )
               And ( J <> 0 )  )  Then
            Begin

              XUgol := SXm + I * SXm ;
              YUgol := SYm + J * SYm ;

              If ( Sqrt (   Sqr   ( X - XUgol                     )
                          + Sqr ( ( Y - YUgol ) / ( XAsp / YAsp ) ) )
                   <= D / C20                                         )  Then
                NowVisible := True ;

            End ;
        End ;



    If ( NowVisible ) Then
    Begin  { NowVisible }
           { ƒƒƒƒƒƒƒƒƒƒ }

     c_p.x :=  Round ( X ) ;
     c_p.y :=  Round ( Y ) ;

     If ( D > 10.0 )
      Then
       Begin   { Ñ®·™ }
               { ƒƒƒƒ }

       End     { Ñ®·™ }
               { ƒƒƒƒ }
      Else

       Begin  { á¢•ß§ÆÆ°p†ß≠Æ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

        ccol  := getcolor;

        PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                  [ Ind Mod PlanetBlockSize ] ;

        If ( PlanetRecord.Nr > Max_PL_PPLFLD )  Then
          Begin  { SATELLIT }
                 { ƒƒƒƒƒƒƒƒ }

            SetColor ( LightGreen ) ;
            NSat := PlanetRecord.Nr - Max_Pl_PPlFld ;

            If ( PlanetRecord.Phase > 0 )
              Then
                Begin
                  SetColor ( White ) ;
                  If ( B_Cdc_Cat )  Then
                     SetColor ( LightGreen ) ;
                  If ( B_Gsc )  Then
                     SetColor ( LightBlue  ) ;
                End
              Else
                Begin
                  SetColor ( LightRed  ) ;
                End ;

            {
            SColor := GetColor ;
            }
            Seek ( SatNameFile, NSat - 1   ) ;
            Read ( SatNameFile, SatNameRec ) ;

            If ( SatNameRec.NumberSat < 0 )
              Then
                Begin { å•Á•≠Î• }

                  If ( StarsInFild )
                    Then
                      Begin

                        Rectangle (  ( C_p.X - SRStpX ) , ( C_p.Y - SRStpY ),
                                     ( C_p.X + SRStpX ) , ( C_p.Y + SRStpY ) );

                        Line ( C_p.x - 4       , C_p.y  ,
                               C_p.X - SRStpX  , C_p.y ) ;
                        Line ( C_p.X + SRStpX  , C_p.y  ,
                               C_p.x + 4       , C_p.y ) ;

                        Line ( C_p.x , C_p.y - 3        ,
                               C_p.x , C_p.Y - SRStpY   ) ;
                        Line ( C_p.x , C_p.Y + SRStpY   ,
                               C_p.x , C_p.y + 3        ) ;
                      End
                    Else
                      Begin

                        Line ( C_p.x - 4  , C_p.y  ,
                               C_p.x + 4  , C_p.y   ) ;

                        Line ( C_p.x , C_p.y - 3  ,
                               C_p.x , C_p.y + 3    ) ;

                      End ;


                  PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                            [ Ind Mod PlanetBlockSize ] ;

                  If ( Abs ( PlanetRecord.Phase ) > 100 ) Then
                    NPoint := Round ( Abs ( PlanetRecord.Phase ) - 100 ) ;


                  { èÆ§·Ø„‚≠®™Æ¢†Ô ‚ÆÁ™† }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


                  If ( Abs ( PlanetRecord.Phase ) > 1000 )  Then
                    Begin

                      NPoint := Round ( Abs ( PlanetRecord.Phase ) ) - 1000 ;

                      SetColor ( White ) ;

                      Sx := Round ( SatEartchPoint^[NPoint].X ) ;
                      Sy := Round ( SatEartchPoint^[NPoint].Y ) ;
                      {
                      If (     ( Sx >= Sw.x1 )
                           And ( Sx <= Sw.x2 )
                           And ( Sy >= Sw.y1 )
                           And ( Sy <= Sw.y2 ) )
                        Then
                          Line ( C_p.x, C_p.y, Sx, Sy ) ;
                      }
                      Line ( SxOld, SyOld, Sx, Sy ) ;

                    End ; { èÆ§·Ø„‚≠®™Æ¢†Ô ‚ÆÁ™† }



                  { é°´†·‚Ï ¢®§®¨Æ·‚® }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                  PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                            [ Ind Mod PlanetBlockSize ] ;

                  If ( Abs ( PlanetRecord.Phase ) > 100 ) Then
                    RegVis ;


                End ;  { å•Á•≠Î• }

          End ;  { SATELLIT }
                 { ƒƒƒƒƒƒƒƒ }

        SetColor ( CCol ) ;


       End ;  { á¢•ß§ÆÆ°p†ß≠Æ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    End    { NowVisible }
           { ƒƒƒƒƒƒƒƒƒƒ }
   Else

    Begin

      PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                [ Ind Mod PlanetBlockSize ] ;

      If ( PlanetRecord.Nr > Max_PL_PPLFLD )  Then
        Begin

          NSat := PlanetRecord.Nr - Max_Pl_PPlFld ;

          Seek ( SatNameFile, NSat - 1   ) ;
          Read ( SatNameFile, SatNameRec ) ;

          If ( SatNameRec.NumberSat < 0 ) Then
            Begin  { å•Á•≠Î• }

              PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                        [ Ind Mod PlanetBlockSize ] ;

              If ( Abs ( PlanetRecord.Phase ) > 100 ) Then
                NPoint := Round ( Abs ( PlanetRecord.Phase ) ) - 100 ;


              { èÆ§·Ø„‚≠®™Æ¢†Ô ‚ÆÁ™† }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

              If ( Abs ( PlanetRecord.Phase ) > 1000 )  Then
                Begin

                  NPoint := Round ( Abs ( PlanetRecord.Phase ) ) - 1000 ;

                  SetColor ( White ) ;

                  Sx := Round ( SatEartchPoint^[NPoint].X ) ;
                  Sy := Round ( SatEartchPoint^[NPoint].Y ) ;
                  {
                  If (     ( Sx >= Sw.x1 )
                       And ( Sx <= Sw.x2 )
                       And ( Sy >= Sw.y1 )
                       And ( Sy <= Sw.y2 ) )  Then
                    Line ( C_p.x, C_p.y, Sx, Sy ) ;
                  }
                  Line ( SxOld, SyOld, Sx, Sy ) ;

                End ;


              { é°´†·‚Ï ¢®§®¨Æ·‚® }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

              If ( Abs ( PlanetRecord.Phase ) > 100 ) Then
                RegVis ;


            End ;  { å•Á•≠Î• }

        End ;

    End ;

   End;  { Planet[Ind] }
         { ƒƒƒƒƒƒƒƒƒƒƒ }

  End ; { Visible }

 End ; { Ind }



 If B_Import_Sat Then
   Close ( SatNameFile ) ;


 With Vp Do
   SetViewPort ( x1, y1, x2, y2, ClipOn );

End; { ShowPlanets }

End.