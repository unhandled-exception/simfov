
{$O+,F+}

Unit PIKO ;

Interface

Procedure  IKO ;


Implementation

Uses

 Graph, Crt, Dos,
 PVar, V_Catal, PVarMenu, PJd8, PMem,
 PDayJd, PXYFLHJ, PXYSatGP, PSGP4, PPreNXYZ,  PreBsIko,
 POptAx, PPLPRO,  GLib, MDef, PATan2, PRefr ;

Procedure LocalInitGr; Forward;

Procedure  IKO ;
         { ‹‹‹ }


Const

      TDayBeg    : Double  = 123456.5                         ;
      RSunMean   : Double  = 16.00 * 60.0 / 206264.8062470964 ;
      H45        : Double  = Pi / 4.0                         ;
      H24        : Double  =  86400.0                         ;
      NSatFound  : Integer =   -100                           ;

Var

 Prima,
 SunVosh,
 SunZah,
 MoonVosh,
 MoonZah,
 SunVoshOut,
 SunZahOut,
 NightBegOut,
 NightEndOut,
 MoonVoshOut,
 MoonZahOut,
 BDaySun,
 BDayMoon,
 BNight,
 SatExist,
 FoundSat,
 FoundPlanet,
 DoMove,
 Selected,
 Quit,
 B_Out_IKO,
 B_Out_Next,
 B_Out_Prima,
 SatIzo,
 Metka               : Boolean      ;

 chh                 : Char         ;

 HH, IMin, ISek      : Integer ;

 Dx, Dy, DxD2,
 Dx10, Dy10,
 DxScale,
 DyScale,
 Xc, Yc,
 DxScr,
 DyScr,
 Cx, Cy,
 CxMax, CyMax,
 Ind,
 NSat,
 NStar,
 SRadii,
 DayOutIko,
 IndColorSky,
 IndColorSkyOld,
 Speed        : Integer      ;

 Page,
 SColor,
 col,
 ColorSky,
 xasp , yasp  : Word         ;

 YearDateOut,
 MonthDateOut    : LongInt      ;

 R,
 MPred,  MBsPred,
 AKrest, HKrest,
 SAKrest, SHKrest,
 CAKrest, CHKrest,
 RaKrest, DeclKrest,
 TKrest,
 STKrest, CTKrest,
 SDeclKrest, CDeclKrest,
 CRoEar,
 CRoSun,
 RoSat, SRoSat, CRoSat,
 Dx10Real,
 Dy10Real,
 DJDateReal,
 ASat, HSat,
 ASunVosh,
 ASunZah,
 AMoonVosh,
 AMoonZah,
 TDay,
 TSunVosh,
 TSunZah,
 TMoonVosh,
 TMoonZah,
 TNightBeg,
 TNightEnd,
 ASunOld,
 AMoonOld,
 HSunLimb,
 HMoonLimb,
 HSunLimbOld,
 HMoonLimbOld,
 SD, CD, SR, CR,
 SH, CH, SA, CA,
 HGorIko, DhGorAlt,
 HNightIko,
 SinDhGorAlt, CosDhGorAlt,
 ST, CT,
 SDA, CDA,
 SPOZ, CPOZ,
   X,   Y,   Z,
 PmX, PmY, PmZ,
 TGRO,
 XSat,  YSat,  ZSat,  RSat,
 VXSat, VYSat, VZSat,
 XSat1,  YSat1,  ZSat1,  RSat1,
 VXSat1, VYSat1, VZSat1,
 PhaseEarth, PhaseMoon,
 DayDateOut,
 Mx, My                           : Double           ;

 SwIko,
 pvp          : ViewPortType     ;

 fs,
 FillInfo     : FillSettingsType ;


 S, SOut      : String        ;
 Sn           : String [ 24 ] ;
 Sn1          : String [  9 ] ;

 OutIkoFile   : Text ;



Procedure TimeSek ;
  Begin

     If ( Sek >= H24 )  Then
          Sek := Sek - H24 ;

     Hh   := Trunc ( Sek / C36000 ) ;
     Sek  := Sek - Hh    * C36000   ;
     IMin := Trunc ( Sek /   C600 ) ;
     Sek  := Sek - IMin  *   C600   ;
     ISEK := Round ( Sek          ) ;

     If ( ISek = 60 )  Then
       Begin
         ISek := 0          ;
         IMin := IMin + 1   ;
       End ;

     If ( IMin = 60 )  Then
       Begin
         IMin := 0      ;
         Hh   := Hh + 1 ;
       End ;

     If ( Hh = 24 )  Then
       Hh := 0 ;

  End ;

Procedure STimeSek ;
  Begin

     If ( Sek >= H24 )  Then
          Sek := Sek - H24 ;

     Hh   := Trunc ( Sek / C36000 ) ;
     Sek  := Sek - Hh    * C36000   ;
     IMin := Trunc ( Sek /   C600 ) ;
     Sek  := Sek - IMin  *   C600   ;
     ISEK := Trunc ( Sek          ) ;

     If ( ISek = 60 )  Then
       Begin
         ISek := 0          ;
         Sek  := Sek - 60.0 ;
         IMin := IMin + 1   ;
       End ;

     If ( IMin = 60 )  Then
       Begin
         IMin := 0      ;
         Hh   := Hh + 1 ;
       End ;

     If ( Hh = 24 )  Then
       Hh := 0 ;

  End ;




Procedure TimeMin ;
  Begin

    Sek := ( Sek + 0.5 ) * 24.0 * C36000  ;

    If ( Sek >= H24 )  Then
      Sek := Sek - H24 ;

    Hh   := Trunc ( Sek / C36000 ) ;
    Sek  := Sek - Hh    * C36000   ;
    IMin := Round ( Sek /   C600 ) ;

    If ( IMin = 60 )  Then
      Begin
        IMin := 0      ;
        Hh   := Hh + 1 ;
      End ;

    If ( Hh  = 24 )  Then
      Hh := 0 ;

    Str ( Hh   : 2 , Sn ) ;
    If ( B_Out_Next )  Then
      SOut := SOut + Sn ;

    S := S + Sn +  Chr  ( 240 )  ;

    Str ( IMin : 3 , Sn ) ;
    If ( B_Out_Next )  Then
      SOut := SOut + Sn + '  ' ;

    S := S + Sn +  Chr  ( 241 )  ;

  End ;




Procedure TimeMinOutFile ;
  Begin

    If ( Sek >= H24 )  Then
      Sek := Sek - H24 ;

    Hh   := Trunc ( Sek / C36000 ) ;
    Sek  := Sek - Hh * C36000 ;
    IMin := Round ( Sek / C600 ) ;

    If ( IMin = 60 )  Then
      Begin
        IMin := 0 ;
        Hh := Hh + 1 ;
      End ;

    If ( Hh  = 24 )  Then
      Hh := 0 ;

    SOut := SOut + '  ' ;

    Str ( Hh   : 2 , Sn ) ;
    If ( B_Out_Next )  Then
      SOut := SOut + Sn ;

    Str ( IMin : 3 , Sn ) ;
    If ( B_Out_Next )  Then
      SOut := SOut + Sn + ' ' ;

  End ;


{ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }


Begin

 GetViewSettings ( pvp ) ;
 GetFillSettings(fs);
 SetViewPort  ( 0, 0, GetMaxX, GetMaxY, clipon ) ;

 Col            := GetColor ;
 ColorSky       :=   1      ;
 Page           :=   0      ;
 IndColorSkyOld := 100      ;

 SetRGBPalette ( ColorSky, 0, 0, 0 ) ;

 EndProc := False ;
 GetAspectRatio ( Xasp, Yasp ) ;


 For Page := 0  To  NGPages - 1  Do
   Begin

     SetActivePage ( Page ) ;

       { ë‚pÆ®¨ p†¨™„ ØÆ´Ô ßp•≠®Ô }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     With SwIko Do
       Begin

         x1 := 25 ;
         y1 :=  4 ;
         x2 := GetMaxX ;
         y2 := y1 + Trunc ( ( x2 - x1 ) / 3.0 * XAsp/YAsp ) ;

         If ( ( x2 - x1  ) Mod 2 <> 0 ) Then
            Dec ( x2 ) ;
         If ( ( y2 - y1  ) Mod 2 <> 0 ) Then
            Dec ( y2 ) ;

       End ;

     SetColor  ( LightGray ) ;
     RectAngle ( SwIko.x1, SwIko.y1, SwIko.x2, SwIko.y2 ) ;

     Inc ( SwIko.x1 ) ;
     Inc ( SwIko.y1 ) ;
     Dec ( SwIko.x2 ) ;
     Dec ( SwIko.y2 ) ;


     DxScr := SwIko.x2 - SwIko.x1 + 1 ;
     DyScr := SwIko.y2 - SwIko.y1 + 1 ;
     Dx    := DxScr Div 2 ;
     Dy    := DyScr Div 2 ;
     DxD2  := Dx    Div 2 ;

     Xc    := Dx ;
     Yc    := Dy ;

     Mx    := Dx / Pi  ;
     My    := Dy / H45 ;

     CxMax := 2 * Dx ;
     CyMax := 2 * Dy ;


     For Ind := 0 To 11 Do
       Begin

         If ( Ind Mod 3 = 0 )
           Then  DyScale := 6
           Else  DyScale := 3 ;

         ASat := Ind * 30.0 / RG ;
         If ( ASat > Pi )  Then
           ASat := ASat - Pi2 ;
         Cx   := Round  ( Xc + SwIko.x1  +  ASat * Mx ) ;
         Line ( Cx,  SwIko.y2+1,  Cx,  SwIko.y2+1 + DyScale ) ;

         If ( Ind = 6 )  Then
           Begin
             Cx   := Round  ( Xc + SwIko.x1  -  ASat * Mx ) ;
             Line ( Cx,  SwIko.y2+1,  Cx,  SwIko.y2+1 + DyScale ) ;
           End ;

       End ;



     For Ind := 0 To 9 Do
       Begin

         If ( Ind Mod 3 = 0 )
           Then  DxScale := 7
           Else  DxScale := 3 ;

         HSat := Ind * C100 / RG - H45 ;
         Cy   := Round  ( Yc + SwIko.y1 - HSat * My ) ;

         If ( Ind Mod 3 = 0 )  Then
           Begin
             HSat := Ind * C100 ;
             Str ( HSat : 2:0, S ) ;
             SetTextJustify ( LeftText, CenterText );
             S := S + '¯' ;
             OutTextXY ( 0, Cy, S ) ;
           End ;

         Line ( SwIko.x1-2-DxScale, Cy, SwIko.x1-1, Cy ) ;

       End ;


     SetTextJustify ( CenterText, CenterText );

     SetColor  ( LightRed ) ;
     OutTextXY ( SwIko.x1+Xc, SwIko.y2 + 15 , 'S' ) ;
     SetColor  ( LightGray ) ;
     OutTextXY ( SwIko.x1+Xc+3, SwIko.y2 + 25 , '0¯' ) ;

     SetColor  ( Cyan ) ;

     OutTextXY ( SwIko.x1+Xc+DxD2 , SwIko.y2 + 15 , 'W' ) ;
     OutTextXY ( SwIko.x1+   DxD2 , SwIko.y2 + 15 , 'E' ) ;

     SetColor  ( LightGray ) ;
     OutTextXY ( SwIko.x1+Xc+DxD2 , SwIko.y2 + 25 ,  '90¯' ) ;
     OutTextXY ( SwIko.x1+   DxD2 , SwIko.y2 + 25 , '270¯' ) ;

     SetColor  ( LightBlue ) ;
     OutTextXY ( SwIko.x1 + 1, SwIko.y2 + 15 , 'N' ) ;
     OutTextXY ( SwIko.x2 - 3, SwIko.y2 + 15 , 'N' ) ;

     SetColor  ( LightGray ) ;
     OutTextXY ( SwIko.x1 +  1, SwIko.y2 + 25 , '180¯' ) ;
     OutTextXY ( SwIko.x2 - 15, SwIko.y2 + 25 , '180¯' ) ;


   End ;





 StepTime := Param.StepTime ;
 If ( Abs ( StepTime ) < 1E-8 )  Then
   Begin
     RealTimeStep := True ;  { ò†£ ¢ p•†´Ï≠Æ¨ ¢p•¨•≠® }
   End ;

 StepTime := StepTime / C36000 / 24.0 ;

 TDay        := TDayBeg ;
 Prima       := True    ;
 SunVosh     := False   ;
 SunZah      := False   ;
 MoonVosh    := False   ;
 MoonZah     := False   ;

 SunVoshOut  := False   ;
 SunZahOut   := False   ;
 NightBegOut := False   ;
 NightEndOut := False   ;
 MoonVoshOut := False   ;
 MoonZahOut  := False   ;

 DayOutIko   :=   - 1 ;
 B_Out_IKO   := False ;
 B_Out_Next  := False ;
 B_Out_Prima := True  ;


 S := Param.ImportStarDir ;
 While (     ( Length ( S )   > 0 )
         And ( Pos ( ' ', S ) > 0 ) )  Do
   Delete ( S, Pos ( ' ', S ), 1 ) ;

 If ( Length ( S ) > 0 )  Then
   Begin

     B_Out_IKO := True ;

     Assign  ( OutIkoFile, S ) ;
     ReWrite ( OutIkoFile    ) ;

   End ;



 If ( B_Bs )  Then
   PrepareBsIko ( NBsIko ) ;



 Page := 0 ;
 {
 SetVisualPage ( Page );
 }
 While Not EndProc Do
   Begin

     Page  := ( Page + NGPages - 1 ) mod 2;
     SetActivePage ( Page ) ;

     With SwIko Do
       Begin

         SetViewPort  ( x1, y1, x2, y2, ClipOn ) ;
         SetFillStyle ( SolidFill, ColorSky );
         Bar ( 0, 0, x2-x1, y2-y1 );

       End;


     XYFLHJ  ( FiSAstron, LongSAstron, Alt, JDATE,
               XS, YS, ZS, VXS, VYS, VZS, R_PLANET, FiSGeoc, STime ) ;

     { èÆ≠®¶•≠®• £Æp®ßÆ≠‚† }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     If ( Abs ( Alt ) > 1.0e-3 )
       Then
         Begin
           SinDhGorAlt := R_Planets [ 3 ] / ( Alt + R_Planets [ 3 ] ) ;
           CosDhGorAlt := Sqrt ( C10 - Sqr ( SinDhGorAlt ) ) ;
           DhGorAlt := ArcTan ( SinDhGorAlt / CosDhGorAlt ) ;
           DhGorAlt := DhGorAlt - Pid2 ;
         End
       Else
           DhGorAlt := 0.0 ;

     HGorIko   := HGor + DhGorAlt ;
     HNightIko := -6.0 / RG ;
     {
     If ( BOlValMenu )  Then
       STime := STime + Frac ( STime ) * STime ;
     }

     SSTIME := Sin ( STime ) ;
     CSTIME := Cos ( STime ) ;


     SFiS := Sin ( FiSAstron ) ;
     CFiS := Cos ( FiSAstron ) ;


            { á¢•ß§Î BS }
            { ƒƒƒƒƒƒƒƒƒ }

     If (     ( Not Prima       )
          And ( B_Bs            )
          And ( HSun*RG <= -5.0 ) )  Then
       Begin { B_Bs }

         MPred := MvMax ;
         If ( MPred > 4.5 )  Then
           MPred := 4.5 ;

         If ( HSun*RG > - 11.5 )
           Then  MBsPred := 5.5 - ( HSun*RG + 11.5 ) * 0.8
           Else  MBsPred := Mpred ;

         If ( MBsPred > MPred ) Then
           MBsPred := MPred ;

         If ( BsIko <> Nil )  Then
          For NStar := 1 To NBsIko Do
           Begin

            BsIkoRec := BsIko^ [ NStar ] ;

            If ( ( BsIkoRec.Mv / C100 -5.0 ) <= MBsPred )  Then
            Begin

             SD := BsIkoRec.SD / 32000.0     ;
             CD := Sqrt ( C10 - Sqr ( SD ) ) ;

             SR := BsIkoRec.SA / 32000.0  ;
             CR := BsIkoRec.CA / 32000.0  ;

             R  := BsIkoRec.Mv / C100 -5.0 ;
             SRadii := Round ( MBsPred - R ) + 1 ;
             {
             SRadii := Round ( MPred - R ) + 1 ;
             }
             ST   := SSTIME * CR  -  CSTIME * SR ;
             CT   := CSTIME * CR  +  SSTIME * SR ;

             SH   := SD * SFIS + CD * CFIS * CT ;
             If ( Abs ( SH ) >= C10 )
               Then
                 Begin
                   If ( SH > 0.0 )
                     Then  HSat :=   Pi / C20
                     Else  HSat := - Pi / C20 ;
                 End
               Else
                 Begin
                   CH   := Sqrt ( C10 - Sqr ( SH ) )  ;
                   HSat := ArcTan  ( SH / CH ) ;
                 End ;


             SA   :=   CD * ST                     ;
             CA   := - SD * CFIS + CD * SFIS * CT  ;

             ASat := ATan2  ( SA , CA ) ;



               { ê®·„•¨ ØÆ´• ßp•≠®Ô }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

             If ( HSat > HGor )  Then
               Begin

                 If ( ASat > Pi )  Then
                   ASat := ASat - Pi2 ;
                 HSat := HSat - H45 ;

                 Cx := Round  ( Xc + ASat * Mx ) ;
                 Cy := Round  ( Yc - HSat * My ) ;

                 SColor := LightCyan ;
                 SetColor ( SColor ) ;

                 Case SRadii Of

                 1 : Begin
                       PutPixel ( Cx, Cy, SColor ) ;
                     End ;

                 2 : Begin
                       PutPixel ( Cx  , Cy  , SColor ) ;
                       PutPixel ( Cx-1, Cy  , SColor ) ;
                       PutPixel ( Cx  , Cy+1, SColor ) ;
                     End ;

                 3 : Begin
                       Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                       Line ( Cx  , Cy-1, Cx  , Cy+1 ) ;
                     End ;

                 4 : Begin
                       Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;
                       Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                       Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                     End ;

                 5..9 : Begin
                       Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;
                       Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                       Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                       Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;
                       End ;
                 End ; { Case }

               End ; { HSat > 0 }

            End ; { MBs }

           End ; { NStar }

       End ; { B_Bs }



                    { ÇëÖ èãÄçÖíõ }
                    { ƒƒƒƒƒƒƒƒƒƒƒ }

     PLPRO ( False,
             JDATE, JDATE, NPl0, XS/AE, YS/AE, ZS/AE,
             0, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );

           { äÆÆp§®≠†‚Î ëÆ´≠Ê† }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     XSun := RectCoordPl [ 11 , 1 ] ;
     YSun := RectCoordPl [ 11 , 2 ] ;
     ZSun := RectCoordPl [ 11 , 3 ] ;


      { ÇÎÁ®·´Ô•¨ ™ÆÆp§®≠†‚Î ·Ø„‚≠®™Æ¢ }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     NumberOfSatellits := 0    ;
     CBlockPlanet      := 0    ;
     SatIzo            := True ;

     SetColor  ( White ) ;

     If ( B_Import_Sat )  Then
       Begin
         Reset ( SatElemFile ) ;
         Reset ( SatNameFile ) ;
       End ;

     For NSat := -10 To  MaxSatellitsInFile  Do
      If ( ( NSat + 11 ) <> 3 )  Then
       Begin  { For NSat ... }
              { ƒƒƒƒƒƒƒƒƒƒƒƒ }

         Metka    := False ;
         SatExist := True  ;

         If ( NSat > 0 )
           Then
             Begin  { ëØ„‚≠®™ }
                    { ƒƒƒƒƒƒƒ }

               NPlSat := 3 ;

               Seek  ( SatNameFile, NSat - 1   ) ;
               Read  ( SatNameFile, SatNameRec ) ;

               If ( SatNameRec.NumberSat < 0 )  Then
                 Begin
                   Metka  := True           ;
                 End ;


               If ( B_Object_Tracks ) Then
                 Begin
                   If ( Metka )
                     Then SatIzo := True
                     Else SatIzo := False ;
                 End ;


               Seek  ( SatElemFile, NSat - 1      ) ;
               Read  ( SatElemFile, SatElementRec ) ;

               If (      ( SatElementRec.NSat >= 0.0 )
                    And  ( NPlSat = 3                )
                    And  ( SatIzo                    )  )  Then
                 Begin  { NSat àåÖÖíëü }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒ }

                   If ( Abs ( SatElementRec.ISat ) < 1.0e-6 )  Then
                     SatElementRec.ISat := 1.0e-6 ;

                   XYSatGP (  JDATE             ,
                            SatElementRec.T0    ,
                            NPlSat              ,
                            SatElementRec.EKSC  ,
                            SatElementRec.ISat  ,
                            SatElementRec.OMG   ,
                            SatElementRec.OML   ,
                            SatElementRec.M0    ,
                            SatElementRec.Mot   ,
                            SatElementRec.Mot1  ,
                            SatElementRec.Mot2  ,
                            SatElementRec.BStar ,
                            XSat,  YSat,  ZSat  ,
                            VXSat, VYSat, VZSat    ) ;

                   {
                   PreNXYZ ( SatElementRec.T0, JDATE,  XSat, YSat, ZSat ) ;
                   }

                      { Cos  „£´†, ØÆ§ ™Æ‚ÆpÎ¨ ¢®§•≠ p†§®„· á•¨´® }
                      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                   RSat   := Sqrt ( XSat*XSat + YSat*YSat + ZSat*ZSat ) ;

                   If ( RSat <= R_PLANETS [ NPl0 ] )
                     Then
                       Begin

                         SatExist := False ;

                         XSat := C10 ;
                         YSat := 0.0 ;
                         ZSat := 0.0 ;

                       End
                     Else
                       Begin

                         CRoEar := Sqrt ( RSat * RSat -
                                   Sqr ( R_PLANETS [ NPl0 ] ) ) / RSat ;


                         { Cos  „£´†  ëÆ´≠Ê• - Ê•≠‚p á•¨´®, ¢®§®¨Æ£Æ ·Æ ·Ø„‚≠®™† }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                         CRoSun := - XSat * ( XSun - XSat )
                                   - YSat * ( YSun - YSat )
                                   - ZSat * ( ZSun - ZSat ) ;

                         CRoSun := CRoSun / RSat ;

                         CRoSun := CRoSun / Sqrt ( Sqr ( XSun - XSat ) +
                                                   Sqr ( YSun - YSat ) +
                                                   Sqr ( ZSun - ZSat )   ) ;


                         If ( NPl0 <> NPlSat )  Then
                           Begin
                             XSat := RectCoordPl [ NPlSat , 1 ] + XSat ;
                             YSat := RectCoordPl [ NPlSat , 2 ] + YSat ;
                             ZSat := RectCoordPl [ NPlSat , 3 ] + ZSat ;
                           End ;


                         { íéèéñÖHíêàóÖëäàÖ äééêÑàHÄíõ }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                         XSat := XSat - XS ;
                         YSat := YSat - YS ;
                         ZSat := ZSat - ZS ;

                       End ;

                 End   { NSat àåÖÖíëü }
                       { ƒƒƒƒƒƒƒƒƒƒƒƒ }
                Else

                 Begin { NSat é‚·„‚·‚¢„•‚ }
                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                   XSat := C10 ;
                   YSat := 0.0 ;
                   ZSat := 0.0 ;

                   SatExist := False ;

                 End ; { NSat é‚·„‚·‚¢„•‚ }
                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               RSat := Sqrt ( XSat*XSat + YSat*YSat + ZSat*ZSat ) ;


             End    { ëØ„‚≠®™ }
           Else
             Begin  { è´†≠•‚† }

               XSat := RectCoordPl [ NSat + 11 , 1 ] ;
               YSat := RectCoordPl [ NSat + 11 , 2 ] ;
               ZSat := RectCoordPl [ NSat + 11 , 3 ] ;

               RSat   := Sqrt ( XSat*XSat + YSat*YSat + ZSat*ZSat ) ;
               SRoSat := R_Planets [ NSat + 11 ] / RSat ;
               CRoSat := Sqrt ( C10 - Sqr ( SRoSat ) ) ;
               RoSat  := ArcTan ( SRoSat / CRoSat ) ;

               CRoSun := C10 ;
               CRoEar := 0.0 ;

             End ;  { è´†≠•‚† }





              { ëîÖêàóÖëäàÖ äééêÑàHÄíõ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         SD   := ZSat / RSat                    ;
         CD   := Sqrt ( ABS ( C10 - SD * SD ) ) ;
         If ( CD > 2.0E-10 )
           Then
             Begin
               SR := YSat / RSat / CD ;
               CR := XSat / RSat / CD ;
             End
           Else
             Begin
               SR := C10 ;
               CR := 0.0 ;
             End ;



         ST   := SSTIME * CR  -  CSTIME * SR ;
         CT   := CSTIME * CR  +  SSTIME * SR ;

         SH   := SD * SFIS + CD * CFIS * CT ;
         CH   := Sqrt ( C10 - Sqr ( SH ) )  ;

         HSat := ArcTan  ( SH / CH ) ;


         SA   :=   CD * ST ;
         CA   := - SD * CFIS + CD * SFIS * CT ;

         ASat := ATan2  ( SA , CA ) ;



         { èÆØp. ß† ê•‰p, •·´® °„§•‚ ¢ÎË• £Æp®ßÆ≠‚† }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         If  ( ( NSat + 11 ) = 11 )  Then
           Begin
             HSunLimb :=           ( HSat + RoSat ) ;
             HSun     := HApparent ( HSat         ) ;
             ASun     := ASat                       ;
           End ;


         If  ( ( NSat + 11 ) = 10 )  Then
           Begin
             HMoonLimb :=           ( HSat + RoSat ) ;
             HMoon     := HApparent ( HSat         ) ;
             AMoon     := ASat                       ;
           End ;

         {
         If (     ( ( NSat + 11 ) <> 10 )
              And ( ( NSat + 11 ) <> 11 ) )  Then
           HSat := HApparent ( HSat ) ;
         }

         HSat := HApparent ( HSat ) ;

         If ( ( NSat + 11 ) = 11 )  Then
           Begin  { Sun }

             If ( HSunLimb >= HGorIko )
               Then  BDaySun  := True
               Else  BDaySun  := False ;


             IndColorSky := Round ( - ( HSun * RG * 3.3 )  ) ;
             If ( IndColorSky < 0 )  Then
               IndColorSky := 0 ;

             If ( IndColorSky > 60 )  Then
               IndColorSky := 60 ;
             {
             If ( IndColorSky <> IndColorSkyOld )  Then
             }
               SetRGBPalette ( ColorSky, 0, 0, 60 - IndColorSky ) ;
             {
             If ( Page = 0 )  Then
               Begin
                 IndColorSkyOld := IndColorSky ;
               End ;
             }

             { ÇÆ·ÂÆ§ - á†ÂÆ§ ëÆ´≠Ê† }
             { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

             If ( Not Prima )  Then
               Begin
                 If ( HSunLimb > HSunLimbOld )
                   Then
                     Begin { H p†·‚•‚ }

                       If (     ( HSunLimb    >= HGorIko )
                            And ( HSunLimbOld <= HGorIko )  )  Then
                         Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                           If ( Abs ( HSunLimb - HSunLimbOld ) > 0.0 )
                             Then
                               R := ( HGorIko   - HSunLimbOld ) /
                                    ( HSunLimb  - HSunLimbOld )
                             Else
                               R := 0.0 ;

                           ASunVosh := ASunOld + R * ( ASun - ASunOld ) ;
                           TSunVosh := JDate - StepTime * ( C10 - R ) ;

                           SunVosh    := True ;
                           SunVoshOut := True ;

                         End ;

                       If (     ( HSunLimb    - RoSat >= HNightIko )
                            And ( HSunLimbOld - RoSat <= HNightIko )  )  Then
                         Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                           If ( Abs ( HSunLimb - HSunLimbOld ) > 0.0 )
                             Then
                               R := ( HNightIko - ( HSunLimbOld - RoSat ) ) /
                                    ( HSunLimb  -   HSunLimbOld           )
                             Else
                               R := 0.0 ;

                           TNightEnd := JDate - StepTime * ( C10 - R ) ;

                           NightEndOut := True ;

                         End ;

                     End
                   Else
                     Begin { H „°Î¢†•‚ }

                       If (     ( HSunLimb    <= HGorIko )
                            And ( HSunLimbOld >= HGorIko )  )  Then
                         Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                           If ( Abs ( HSunLimbOld - HSunLimb ) > 0.0 )
                             Then
                               R := ( HGorIko   - HSunLimbOld ) /
                                    ( HSunLimb  - HSunLimbOld )
                             Else
                               R := 0.0 ;

                           ASunZah := ASunOld + R * ( ASun - ASunOld ) ;
                           TSunZah := JDate - StepTime * ( C10 - R ) ;

                           SunZah     := True  ;
                           SunZahOut  := True  ;

                           If ( SunVosh )  Then
                             Begin
                               TDay  := TSunZah - TSunVosh ;
                             End ;

                         End ;

                       If (     ( HSunLimb    - RoSat <= HNightIko )
                            And ( HSunLimbOld - RoSat >= HNightIko )  )  Then
                         Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                           If ( Abs ( HSunLimbOld - HSunLimb ) > 0.0 )
                             Then
                               R := ( HNightIko - ( HSunLimbOld - RoSat ) ) /
                                    ( HSunLimb  -   HSunLimbOld           )
                             Else
                               R := 0.0 ;

                           TNightBeg := JDate - StepTime * ( C10 - R ) ;

                           NightBegOut := True ;

                         End ;

                     End ;

               End ; { Not Prima }


             HSunLimbOld := HSunLimb ;
             ASunOld     := ASun     ;

           End ; { Sun }





         If ( ( NSat + 11 ) = 10 )  Then
           Begin  { Moon }

             If ( HMoonLimb >= HGorIko )
               Then  BDayMoon := True
               Else  BDayMoon := False ;

             If ( Not Prima )  Then
               Begin { Not Prima }
                 If ( HMoonLimb > HMoonLimbOld )
                   Then
                     Begin { H p†·‚•‚ }

                       If (     ( HMoonLimb    >= HGorIko )
                            And ( HMoonLimbOld <= HGorIko )  )  Then
                         Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                           If ( Abs ( HMoonLimbOld - HMoonLimb ) > 0.0 )
                             Then
                               R := ( HGorIko   - HMoonLimbOld ) /
                                    ( HMoonLimb - HMoonLimbOld )
                             Else
                               R := 0.0 ;

                           AMoonVosh := AMoonOld + R * ( AMoon - AMoonOld ) ;
                           TMoonVosh := JDate - StepTime * ( C10 - R ) ;

                           MoonVosh     := True ;
                           MoonVoshOut  := True ;

                         End ;

                     End
                   Else
                     Begin { H „°Î¢†•‚ }

                       If (     ( HMoonLimb    <= HGorIko )
                            And ( HMoonLimbOld >= HGorIko )  )  Then
                         Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                           If ( Abs ( HMoonLimbOld - HMoonLimb ) > 0.0 )
                             Then
                               R := ( HGorIko   - HMoonLimbOld ) /
                                    ( HMoonLimb - HMoonLimbOld )
                             Else
                               R := 0.0 ;

                           AMoonZah := AMoonOld + R * ( AMoon - AMoonOld ) ;
                           TMoonZah := JDate - StepTime * ( C10 - R ) ;

                           MoonZah     := True ;
                           MoonZahOut  := True ;

                         End ;

                     End ;

               End ; { Not Prima }

             HMoonLimbOld := HMoonLimb ;
             AMoonOld     := AMoon     ;

           End ;



         If ( Not SatExist )  Then
           HSat := -C10 ;



               { ê®·„•¨ ØÆ´• ßp•≠®Ô }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         If (    ( HSat > 0                   )
              Or (     ( NSat <      1     )
                   And ( HSat > - RSunMean )  )  )
           Then
                Begin

                  If ( ASat > Pi )  Then
                    ASat := ASat - Pi2 ;
                  HSat := HSat - H45 ;

                  Cx := Round  ( Xc + ASat * Mx ) ;
                  Cy := Round  ( Yc - HSat * My ) ;

                  If ( CRoSun > CRoEar )
                    Then
                      Begin   { Ç ‚•≠® }
                        SetColor  ( LightRed ) ;
                        If ( Metka )
                          Then
                            Begin
                              Line ( Cx - 4 , Cy     , Cx + 4 , Cy     ) ;
                              Line ( Cx     , Cy - 3 , Cx     , Cy + 3 ) ;
                            End
                          Else
                            Begin

                              If ( NSat > 0 )
                                Then
                                  Begin
                                    Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                                    Line ( Cx  , Cy-1, Cx  , Cy+1 ) ;
                                  End
                                Else
                                  Begin

                                    SColor := PlColArr [ NSat + 11 ] ;

                                    If ( NSat < - 1 )
                                      Then
                                        Begin

                                          GetFillSettings ( FillInfo ) ;

                                          PutPixel ( Cx, Cy, SColor ) ;

                                          PutPixel ( Cx-2, Cy, SColor ) ;
                                          PutPixel ( Cx+2, Cy, SColor ) ;
                                          PutPixel ( Cx, Cy-2, SColor ) ;
                                          PutPixel ( Cx, Cy+2, SColor ) ;

                                          With FillInfo Do
                                            SetFillStyle ( Pattern, Color ) ;

                                        End
                                      Else
                                        Begin

                                          GetFillSettings ( FillInfo ) ;

                                          SetFillStyle ( SolidFill , SColor ) ;
                                          SetColor ( SColor ) ;

                                          FillEllipse ( Cx, Cy, 3, 2 ) ;

                                          With FillInfo Do
                                            SetFillStyle ( Pattern, Color ) ;

                                        End ;


                                  End ;

                            End ;
                      End
                    Else
                      Begin
                        SetColor  ( White ) ;
                        If ( Metka )
                          Then
                            Begin
                              Line ( Cx - 4 , Cy     , Cx + 4 , Cy     ) ;
                              Line ( Cx     , Cy - 3 , Cx     , Cy + 3 ) ;
                            End
                          Else
                            Begin
                              PutPixel ( Cx, Cy, White    ) ;
                            End ;
                      End ;

                  SetColor  ( DarkGray ) ;

                  Inc ( NumberOfSatellits ) ;

                  If ( NumberOfSatellits >= 0 )  Then
                    Begin

                      PlanetRecord := PlanetPtr [ NumberOfSatellits Div PlanetBlockSize ]^
                                                [ NumberOfSatellits Mod PlanetBlockSize ] ;
                      PlanetRecord.X  := Cx    ;
                      PlanetRecord.Y  := Cy    ;
                      PlanetRecord.Nr := NSat  ;

                      CBlockPlanet := ( NumberOfSatellits + Max_Pl_PPlFld )
                                       Div PlanetBlockSize ;

                     If (    ( PlanetAllocFlag [ CBlockPlanet ] )
                          Or ( AllocBlockPlanet                 )  )  Then
                        PlanetPtr [ NumberOfSatellits Div PlanetBlockSize ]^
                                  [ NumberOfSatellits Mod PlanetBlockSize ] :=
                           PlanetRecord ;

                    End ;


                End ;


       End ;  { For NSat ... }
              { ƒƒƒƒƒƒƒƒƒƒƒƒ }


     If ( B_Import_Sat )  Then
       Begin
         Close ( SatElemFile ) ;
         Close ( SatNameFile ) ;
       End ;



     If ( Prima )  Then
       Begin
         HSunLimbOld  := HSunLimb  ;
         HMoonLimbOld := HMoonLimb ;
         ASunOld      := ASun      ;
         AMoonOld     := AMoon     ;
         Prima        := False     ;
       End ;



     DayJd ( JDate + DtGrTopo / 24.0, YearDate, MonthDate, DayDate ) ;
    {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}

     DayDate := Trunc ( DayDate ) ;


     { HÆ¢†Ô ·‚pÆ™† §´Ô ¢Î¢Æ§† ? }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     If ( Trunc ( DayDate ) <> DayOutIko ) Then
       Begin

         If ( DayOutIko <> -1 )  Then
           Begin


             SunZah  := SunZahOut  ; { Pol Day   }
             SunVosh := SunVoshOut ; { Pol Night }


             If ( B_Out_IKO )  Then
               Begin

                 B_Out_Next := True ;
                 SOut       :=    '';

                 If ( Not B_Out_Prima )  Then
                   Begin
                     Sound ( 500 ) ;
                     Delay (  20 ) ;
                     NoSound       ;
                   End ;

               End ;

           End ;

         DayOutIko := Trunc ( DayDate ) ;

       End ;



     Sek := Abs ( JDate + DtGrTopo / 24.0 ) -
            LongInt ( Trunc ( Abs ( JDate + DtGrTopo / 24.0 )  ) ) ;
     Sek := ( Sek + 0.5 ) * 24.0 * C36000  ;

     TimeSek ;

     GetFillSettings ( FillInfo ) ;

     SetViewPort ( 4, SwIko.y2+40, GetMaxX, GetMaxY, True) ;
     ClearViewPort ;
     SetTextJustify ( LeftText, CenterText ) ;


     S := 'Lat  :' ;
     Str ( FiSAstron   * RG : 6:1, Sn ) ; S := S + Sn + Chr (243) ;
     SetColor ( LightGray ) ;
     OutTextXY (  0,  6 , S ) ;

     S := 'Long :' ;
     Str ( LongSAstron * RG : 6:1, Sn ) ; S := S + Sn + Chr (243) ;
     SetColor ( LightGray ) ;
     OutTextXY (  0, 16 , S ) ;

     S := 'Alt  :' ;
     Str ( Alt : 8:3, Sn ) ; S := S + Sn + ' km' ;
     SetColor ( LightGray ) ;
     OutTextXY (  0, 26 , S ) ;


     S := 'Date :  ' ;
     SetColor ( LightGray ) ;
     OutTextXY (  0, 40 , S ) ;
     Str ( YearDate  : 4, Sn ) ; S := Sn ;
     S := S + '  ' + MonthName [ MonthDate ]    ;
     Str ( DayDate   : 4:0 , Sn ) ;
     S := S + Sn ;
     SetColor ( White ) ;
     OutTextXY (  66, 40 , S ) ;

     If ( B_Out_Next )  Then
       Begin

         DayJd ( JDate - StepTime + DtGrTopo / 24.0, YearDateOut  ,
                                                     MonthDateOut ,
                                                     DayDateOut    ) ;
         DayDateOut := Trunc ( DayDateOut ) ;
         Str ( YearDateOut  : 4, Sn ) ;
         S := Sn ;
         S := S + ' ' + MonthName [ MonthDateOut ] ;
         SOut := SOut + S ;
         Str ( DayDateOut  : 3:0 , Sn ) ;
         SOut := SOut + Sn + '   ' ;
       End ;


             { Time }
             { ƒƒƒƒ }

     If ( DtGrTopo <> 0 )
       Then  S := 'T Civil : '
       Else  S := '     UT : ' ;
     SetColor ( LightGray ) ;
     OutTextXY (  220, 40 , S ) ;

     S := '' ;

     Str ( Hh   : 2   , Sn ) ;   S := S + Sn +  Chr  ( 240 ) + ' '  ;
     Str ( IMin : 3   , Sn ) ;   S := S + Sn +  Chr  ( 241 ) + ' '  ;
     Str ( ISEK : 3   , Sn ) ;   S := S + Sn +  Chr  ( 242 ) + ' '  ;

     If ( HSun*RG >= -6.0 )
       Then  SetColor ( Yellow    )
       Else  SetColor ( LightBlue ) ;

     OutTextXY (  300, 40 , S ) ;


                { S Time }
                { ƒƒƒƒƒƒ }

     Sek := STime * RG / 15.0 * C36000 + 0.5 ;

     TimeSek ;

     S := 'STime : ' ;
     SetColor ( LightGray ) ;
     OutTextXY (  445, 40 , S ) ;

     S := '' ;

     Str ( Hh   : 2   , Sn ) ; S := S + Sn +  Chr  ( 240 ) + ' '  ;
     Str ( IMin : 3   , Sn ) ; S := S + Sn +  Chr  ( 241 ) + ' '  ;
     Str ( SEK  : 6:1 , Sn ) ; S := S + Sn +  Chr  ( 242 ) + ' '  ;

     SetColor ( White ) ;
     OutTextXY (  506, 40 , S ) ;




     S := ( '          A         H' ) ;
     SetColor  ( LightGray ) ;
     OutTextXY (  5, 60 , S ) ;

     Str ( ASun * RG: 5:1 , Sn ) ;
     S := 'Sun     ' + Sn + Chr (243) ;
     Str ( Abs ( HSun ) * RG: 5:1 , Sn ) ;
     If ( HSun < 0 )  Then
       Sn [ 1 ] := '-' ;
     S := S + '    ' + Sn + Chr (243) ;
     SetColor  ( Yellow ) ;
     OutTextXY (  0, 75 , S ) ;

     Str ( AMoon * RG: 5:1 , Sn ) ;
     S := 'Moon    ' + Sn + Chr (243) ;
     Str ( Abs ( HMoon ) * RG: 5:1 , Sn ) ;
     If ( HMoon < 0 )  Then
       Sn [ 1 ] := '-' ;
     S := S + '    ' + Sn + Chr (243) ;
     SetColor  ( LightGreen ) ;
     OutTextXY (  0, 85 , S ) ;


     S := '' ;

     If ( SunVosh )
       Then
         Begin { SunVosh }
               { ‹‹‹‹‹‹‹ }

           Sek := Abs ( TSunVosh + DtGrTopo / 24.0 ) -
                  LongInt ( Trunc ( Abs ( TSunVosh + DtGrTopo / 24.0  )  ) ) ;

           S := 'Sunrise  : ' ;

           TimeMin ;

    	   If ( BDaySun )
     	     Then  SetColor  ( Yellow    )
      	     Else  SetColor  ( LightGray  ) ;


           Str ( ASunVosh * RG: 3:0 , Sn ) ;
           S := S + ',  A = ' + Sn + Chr (243) ;

           OutTextXY ( 0, 110 , S ) ;

         End  { SunVosh }
               { ‹‹‹‹‹‹‹ }
       Else
          SOut := SOut + '       ' ;



     If ( SunZah  )  Then
       Begin { SunZah  }
             { ‹‹‹‹‹‹‹ }

         Sek := Abs ( TSunZah + DtGrTopo / 24.0 ) -
                LongInt ( Trunc ( Abs ( TSunZah + DtGrTopo / 24.0  )  ) ) ;

         S := 'Sunset  : ' ;

         TimeMin ;

    	 If ( Not BDaySun )
     	   Then  SetColor  ( Yellow    )
      	   Else  SetColor  ( LightGray  ) ;


         Str ( ASunZah * RG: 3:0 , Sn ) ;
         S := S + ',  A = '+ Sn + Chr (243) ;

         OutTextXY ( 272, 110 , S ) ;


         If (     SunVosh
              And ( TDay <> TDayBeg ) )
          Then
           Begin

             Sek := Abs ( TDay ) ;
             Sek := Sek * 24.0 * C36000  ;
             If ( Sek >= H24 )  Then
                  Sek := Sek - H24 ;

             Hh   := Trunc ( Sek / C36000 ) ;
             Sek  := Sek - Hh * C36000 ;
             IMin := Round ( Sek / 6.0 ) ;

             If ( IMin = 600 )  Then
               Begin
                 IMin := 0      ;
                 Hh   := Hh + 1 ;
               End ;

             If ( Hh = 24 )  Then
               Hh := 0 ;

             S := ' Day ' ;

             Str ( Hh   : 3 , Sn ) ;
             If ( B_Out_Next )  Then
               If ( Not SunVoshOut )
                 Then  SOut := ' ' + SOut + '   '
                 Else  SOut := ' ' + SOut + Sn ;
             S := S + Sn +  Chr  ( 240 )  ;

             Str ( IMin / C100 : 5:1 , Sn ) ;
             If ( B_Out_Next )  Then
               If ( Not SunVoshOut )
                 Then  SOut := SOut + '         '
                 Else  SOut := SOut + Sn + '    ' ;
             S := S + Sn +  Chr  ( 241 )  ;
             {
             If ( Not BDaySun )
               Then  SetColor  ( Yellow    )
               Else  SetColor  ( LightGray  ) ;
             }
             SetColor  ( Cyan ) ;

             OutTextXY ( 516, 110 , S ) ;

           End
          Else
            SOut := ' ' + SOut + '            ' ;

       End   { SunSah  }
             { ‹‹‹‹‹‹‹ }
      Else
        SOut := ' ' + SOut + '                   ' ;



     If ( NightEndOut )
       Then
        Begin

         Sek := Abs ( TNightEnd + DtGrTopo / 24.0 ) -
                LongInt ( Trunc ( Abs ( TNightEnd + DtGrTopo / 24.0  )  ) ) ;
         Sek := ( Sek + 0.5 ) * 24.0 * C36000  ;

         TimeMinOutFile ;

        End
       Else
        Begin
          SOut := SOut + '        ' ;
        End ;



     If ( NightBegOut )
       Then
        Begin

         Sek := Abs ( TNightBeg + DtGrTopo / 24.0 ) -
                LongInt ( Trunc ( Abs ( TNightBeg + DtGrTopo / 24.0  )  ) ) ;
         Sek := ( Sek + 0.5 ) * 24.0 * C36000  ;

         TimeMinOutFile ;

        End
       Else
        Begin
          SOut := SOut + '        ' ;
        End ;




     S := '' ;

     If ( MoonVosh )
       Then
         Begin { MoonVosh }
               { ‹‹‹‹‹‹‹ }

           Sek := Abs ( TMoonVosh + DtGrTopo / 24.0 ) -
                  LongInt ( Trunc ( Abs ( TMoonVosh + DtGrTopo / 24.0  )  ) ) ;

           SOut := SOut + '      ' ;
           S := 'Moonrise : ' ;

           If ( MoonVoshOut )
             Then
               TimeMin
             Else
               Begin
                 If ( B_Out_Next )
                   Then
                     Begin
                       B_Out_Next := False ;
                       TimeMin ;
                       B_Out_Next := True  ;
                       SOut := SOut + '       ' ;
                     End
                   Else
                       TimeMin
               End ;

    	   If ( BDayMoon )
             Then  SetColor  ( LightGreen )
      	     Else  SetColor  ( LightGray  ) ;

           Str ( AMoonVosh * RG: 3:0 , Sn ) ;
           S := S + ',  A = ' + Sn + Chr (243) ;

           OutTextXY ( 0, 120 , S ) ;


         End  { MoonVosh }
              { ‹‹‹‹‹‹‹ }
       Else

           SOut := SOut + '             ' ;



     If ( MoonZah  )
      Then
       Begin { MoonZah  }
             { ‹‹‹‹‹‹‹ }

         Sek := Abs ( TMoonZah + DtGrTopo / 24.0 ) -
                LongInt ( Trunc ( Abs ( TMoonZah + DtGrTopo / 24.0  )  ) ) ;

         S := 'Moonset : ' ;

         If ( MoonZahOut )
             Then
               TimeMin
             Else
               Begin
                 If ( B_Out_Next )
                   Then
                     Begin
                       B_Out_Next := False ;
                       TimeMin ;
                       B_Out_Next := True  ;
                       SOut := SOut + '       ' ;
                     End
                   Else
                       TimeMin
               End ;


    	 If ( Not BDayMoon )
           Then  SetColor  ( LightGreen )
      	   Else  SetColor  ( LightGray  ) ;

         Str ( AMoonZah * RG: 3:0 , Sn ) ;
         S := S + ',  A = '+ Sn + Chr (243) ;

         OutTextXY ( 272, 120 , S ) ;

       End  { MoonSah  }
             { ‹‹‹‹‹‹‹ }
      Else

           SOut := SOut + '       ' ;




     With FillInfo Do
       SetFillStyle ( Pattern, Color ) ;

     SetVisualPage ( Page );



     With SwIko Do
       SetViewPort (x1,y1,x2,y2,clipon);
     SetColor   ( LightGray ) ;


     If ( KeyPressed )  Then
       Begin  { ÇÎ°®p†•¨ ÆØ‚®Á•·™®© Ê•≠‚p }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         UserKey := ReadKey ;
         If UserKey = #0  Then
            UserKey := ReadKey ;

         EndProc := True   ;

         With SwIko Do
           SetViewPort (x1,y1,x2,y2,clipon);
         SetColor   ( LightGray ) ;

         SetWriteMode ( XorPut ) ;
         SetColor     ( Green  ) ;

         Cx := Xc ;
         Cy := Yc ;

         Line ( Cx - 6 , Cy     , Cx - 1 , Cy     ) ;
         Line ( Cx + 1 , Cy     , Cx + 6 , Cy     ) ;
         Line ( Cx     , Cy - 4 , Cx     , Cy - 1 ) ;
         Line ( Cx     , Cy + 1 , Cx     , Cy + 4 ) ;

         SetWriteMode ( NormalPut ) ;

         Speed := 5 ;
         Dx    := 0 ;
         Dy    := 0 ;

         Selected := False ;
         Quit     := False ;

         Sn       := '' ;


         Repeat

           chh    := GetKey ;
           DoMove := False  ;

           Case chh Of

             LeftKey  : Begin
                          DoMove :=  True  ;
                          Dx     := -Speed ;
                          Dy     :=  0     ;
                        End;

             RightKey : Begin
                          DoMove :=  True  ;
                          Dx     :=  Speed ;
                          Dy     :=  0     ;
                        End;

             UpKey    : Begin
                          DoMove :=  True  ;
                          Dx     :=  0     ;
                          Dy     := -Speed ;
                        End;

             DownKey  : Begin
                          DoMove :=  True  ;
                          Dx     :=  0     ;
                          Dy     :=  Speed ;
                        End;

             '1'..'9' : Val ( chh, Speed, code );

             CRKey    : Selected := True;

             ESCKey   : Begin
                          Quit    := True  ;
                          EndProc := False ;
                        End ;

             Pusto    : Begin
                          Selected := True ;
                          Stop     := True ;
                        End ;

           End;



           If ( Sn <> '' )  Then
             Begin

               SetViewPort ( SwIko.x1+80, SwIko.y2+40, GetMaxX, SwIko.y2+50, true);
               ClearViewPort ;
               SetViewPort ( SwIko.x1, SwIko.y2+40, GetMaxX, SwIko.y2+50, true);
               SetTextJustify ( CenterText, CenterText );
               SetColor  ( Black ) ;

               If ( FoundSat )
                 Then
                       OutTextXY (   GetMaxX Div 2
                                   - Length ( Sn ) Div 2 - 8, 5 ,
                                    'AutoGuiding :  ' + Sn )
                 Else
                       OutTextXY (   GetMaxX Div 2
                                   - Length ( Sn ) Div 2 - 8, 5 ,
                                    'AutoGuiding :  ' + Sn ) ;

               SetColor ( LightGray ) ;
               Sn := '' ;

               SetViewPort ( SwIko.x1, SwIko.y1, SwIko.x2, SwIko.y2, clipon );

             End ;


           If ( DoMove )  Then
             Begin

               SetWriteMode ( XorPut ) ;
               SetColor     ( Green  ) ;

               Line ( Cx - 6 , Cy     , Cx - 1 , Cy     ) ;
               Line ( Cx + 1 , Cy     , Cx + 6 , Cy     ) ;
               Line ( Cx     , Cy - 4 , Cx     , Cy - 1 ) ;
               Line ( Cx     , Cy + 1 , Cx     , Cy + 4 ) ;

               Cx := Cx + Dx ;
               Cy := Cy + Dy ;

               If ( Cx  < 0     ) Then
                    Cx := 0 ;
               If ( Cx  > CxMax ) Then
                    Cx := CxMax ;

               If ( Cy  < 0     ) Then
                    Cy := 0 ;
               If ( Cy  > CyMax ) Then
                    Cy := CyMax ;

               Line ( Cx - 6 , Cy     , Cx - 1 , Cy     ) ;
               Line ( Cx + 1 , Cy     , Cx + 6 , Cy     ) ;
               Line ( Cx     , Cy - 4 , Cx     , Cy - 1 ) ;
               Line ( Cx     , Cy + 1 , Cx     , Cy + 4 ) ;

               SetWriteMode ( NormalPut ) ;

               FoundSat    := False ;
               FoundPlanet := False ;
               NSatFound   := - 100 ;


                { Äß®¨„‚ ® ÇÎ·Æ‚† ä„p·Æp† }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
               AKrest := ( Cx - Xc ) / Mx  ;
               HKrest := ( Yc - Cy ) / My  ;

               If ( AKrest < 0 )  Then
                 AKrest := AKrest + Pi2 ;
               HKrest := HKrest + H45 ;
               If ( HKrest < 0.0 ) Then
                 HKrest := 0.0 ;

               SetViewPort ( SwIko.x1+80, SwIko.y2+40, GetMaxX, SwIko.y2+50, true);
               ClearViewPort ;
               SetViewPort ( SwIko.x1, SwIko.y2+40, GetMaxX, SwIko.y2+50, true);
               SetColor   ( White ) ;


               { ù™¢†‚Æp®†´Ï≠Î• ™ÆÆp§®≠†‚Î ™p•·‚† }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               SHKrest := Sin ( HMean ( HKrest ) ) ;
               CHKrest := Cos ( HMean ( HKrest ) ) ;

               SAKrest := Sin ( AKrest ) ;
               CAKrest := Cos ( AKrest ) ;


               SDeclKrest := SHKrest * SFiS - CHKrest * CFiS * CAKrest ;
               CDeclKrest := Sqrt ( C10 - Sqr ( SDeclKrest ) ) ;

               If ( Abs ( CDeclKrest ) > 1.0E-13 )
                 Then
                   Begin

                     CTKrest := ( SHKrest * CFiS + CHKrest * SFiS * CAKrest ) / CDeclKrest ;
                     STKrest := ( CHKrest * SAKrest ) / CDeclKrest ;

                     TKrest  := ATan2 ( STKrest , CTKrest ) ;

                     DeclKrest := ATan2 ( SDeclKrest , CDeclKrest ) ;
                     If ( DeclKrest > Pi )  Then
                       DeclKrest := DeclKrest - Pi2 ;

                   End

                 Else

                   Begin

                     STKrest := CHKrest * SAKrest ;
                     CTKrest := SHKrest * CFiS + CHKrest * SFiS * CAKrest ;

                     TKrest := 0.0 ;

                     If ( SDeclKrest > 0.0 )
                       Then
                         Begin

                           DeclKrest := PiD2 ;

                           If ( Abs ( CTKrest ) > 1.0E-13 )  Then
                             TKrest  := ATan2 ( STKrest, CTKrest ) ;

                         End
                       Else
                         Begin

                           DeclKrest := - PiD2 ;

                           If ( Abs ( CTKrest ) > 1.0E-13 )  Then
                             Begin

                               STKrest := - STKrest ;
                               CTKrest := - CTKrest ;

                               TKrest  := ATan2 ( STKrest, CTKrest ) ;

                             End ;

                         End ;

                   End ;


               RaKrest := STime - TKrest ;

               If ( RaKrest < 0.0 )  Then
                 RaKrest := RaKrest + Pi2 ;
               If ( RaKrest > Pi2 )  Then
                 RaKrest := RaKrest - Pi2 ;


               Str ( RaKrest * RG / 15.0 : 4:1, Sn ) ;
               S := 'Ra = ' + Sn + Chr (240) ;
               Str ( DeclKrest * RG : 3:0, Sn ) ;
               If ( Sn [ 1 ] = ' ' )  Then
                 Delete ( Sn, 1, 1 ) ;
               S := S + '  Decl = ' + Sn + Chr (243) ;

               SetTextJustify ( LeftText, CenterText );
               OutTextXY ( 220 , 5 , S ) ;



               Str ( AKrest * RG : 3:0, Sn ) ;
               S := 'A = ' + Sn + Chr (243) ;
               Str ( HKrest * RG : 2:0, Sn ) ;
               S := S + ' H = ' + Sn + Chr (243) ;

               SetTextJustify ( LeftText, CenterText );
               OutTextXY (   484 , 5 , S ) ;

               With SwIko Do
                 SetViewPort (x1,y1,x2,y2,clipon);

               Sn := '' ;

               If ( NumberOfSatellits > 0 )  Then
                For  NSat := 1 To NumberOfSatellits  Do
                 Begin

                   PlanetRecord := PlanetPtr [ NSat Div PlanetBlockSize ]^
                                             [ NSat Mod PlanetBlockSize ] ;

                   If (     ( Cx = Round ( PlanetRecord.X ) )
                        And ( Cy = Round ( PlanetRecord.Y ) ) )  Then
                     Begin

                       SetViewPort ( SwIko.x1+80, SwIko.y2+40, GetMaxX, SwIko.y2+50, true);
                       ClearViewPort ;
                       SetViewPort ( SwIko.x1, SwIko.y2+40, GetMaxX, SwIko.y2+50, true);
                       SetTextJustify ( CenterText, CenterText );
                       SetColor   ( White ) ;

                       Sn := '' ;

                       NSatFound := NSat ;

                       If ( PlanetRecord.Nr > 0 )
                         Then
                           Begin

                             NSatFound := PlanetRecord.Nr ;

                             Reset ( SatNameFile                      ) ;
                             Seek  ( SatNameFile, PlanetRecord.Nr - 1 ) ;
                             Read  ( SatNameFile, SatNameRec          ) ;
                             Close ( SatNameFile                      ) ;

                             Sn := SatNameRec.NameSat ;
                             Sn := 'Satellit' + ' ' + Sn ;
                             OutTextXY (   GetMaxX Div 2
                                         - Length ( Sn ) Div 2 - 8, 5 ,
                                        'AutoGuiding :  ' + Sn ) ;

                             FoundSat    := True  ;
                             FoundPlanet := False ;

                           End
                         Else
                           Begin

                             Sn  := PlanetName [ PlanetRecord.Nr + 11 ] ;
                             While ( Sn [ Length ( Sn ) ] = ' ' ) Do
                               Delete ( Sn, Length ( Sn ), 1 ) ;
                             Str ( RezPl [ PlanetRecord.Nr + 11 , 3 ]
                                  : 4 : 1, Sn1 )  ;
                             Sn := Sn + ',  Mv = ' + Sn1 ;
                             OutTextXY (   GetMaxX Div 2
                                         - Length ( Sn ) Div 2 - 8, 5 ,
                                        'AutoGuiding :  ' + Sn ) ;

                             FoundPlanet := True  ;
                             FoundSat    := False ;

                           End ;

                         Str ( AKrest * RG : 3:0, Sn ) ;
                         S := 'A = ' + Sn + Chr (243) ;
                         Str ( HKrest * RG : 2:0, Sn ) ;
                         S := S + ' H = ' + Sn + Chr (243) ;
                         OutTextXY (   547 , 5 , S ) ;

                       With SwIko Do
                         SetViewPort (x1,y1,x2,y2,clipon);

                     End ;

                 End ;


             End;

         Until ( Selected Or Quit );

       End    { ÇÎ°®p†•¨ ÆØ‚®Á•·™®© Ê•≠‚p }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
      Else

       Begin

        If (     ( B_Out_Next = True )
             And ( B_Out_IKO         ) ) Then
          Begin

            B_Out_Next := False ;

            If ( Not B_Out_Prima )
              Then
                Begin
                  WriteLn ( OutIkoFile, SOut ) ;
                End
              Else
                Begin

                  Writeln ( OutIkoFile ) ;

                  Write   ( OutIkoFile,
                            ' Lat :',
                            Param.LatSig    : 2,
                            Param.LatG      : 2,
                            '¯',
                            Param.LatM      : 3,
                            '''     Long :',
                            Param.LongSig   : 2,
                            Param.LongG     : 3,
                            '¯',
                            Param.LongM     : 3,
                            ''''
                          ) ;

                  If ( Param.Alt > 0.001 )  Then
                    Write ( OutIkoFile,
                            '       Alt :',
                            Param.Alt       : 7:3,
                            ' km'
                          ) ;

                  Writeln ( OutIkoFile ) ;
                  Writeln ( OutIkoFile ) ;
                  Writeln ( OutIkoFile,
                  '                    Sun         Day       Night(HSun<-6¯)          Moon'
                          ) ;
                  Writeln ( OutIkoFile,
                  '               ƒƒƒƒƒƒƒƒƒƒƒƒ   ƒƒƒƒƒƒƒ     ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ      ƒƒƒƒƒƒƒƒƒƒƒƒ'
                          ) ;
                  Writeln ( OutIkoFile,
                  '                h  m   h  m    h  m         h  m    h  m        h  m   h  m'
                          ) ;
                  {
                  Writeln ( OutIkoFile ) ;
                  }
                End ;


            If ( ( Trunc ( JDate + 1 ) Mod 7 ) = 0 )  Then
              WriteLn ( OutIkoFile ) ;

            SOut := '' ;

            B_Out_Prima := False   ;
            SunVoshOut  := False   ;
            SunZahOut   := False   ;
            NightBegOut := False   ;
            NightEndOut := False   ;
            MoonVoshOut := False   ;
            MoonZahOut  := False   ;

            If ( SunZah = False )  Then
              SunVosh := False ; { Pol Day }

          End ;

        If ( Abs ( StepTime ) > 1E-8 )
          Then
            JDate := JDate + StepTime
          Else
            Begin  { êÖÜàå êÖÄãúHéÉé ÇêÖåÖHà }
                   { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

              GetDate ( TimerYear, TimerMonth, TimerDay, TimerDayOfWeek );

              IY := TimerYear  ;
              IM := TimerMonth ;
              ID := TimerDay   ;
              JD8 ( IY, IM, ID, JDTimer2 ) ;

               Repeat
                 GetTime ( TimerHOUR, TimerMin, TimerSEC, TimerSEC100 ) ;
               Until (    ( TimerSEC100 > 95 )
                       Or ( TimerSEC100 <  5 ) )  ;

               If ( TimerSec100 >= 95 )
                 Then TimerSec100 := 2
                 Else TimerSec100 := 1 ;

               JDTimer2 := JDTimer2 + (   ( TimerHour ) * C36000
                                        +   TimerMin * C600    ) / 86400 ;
               JDTimer2 := JDTimer2 + (     TimerSEC + TimerSEC100 ) / 86400 ;

               JDTimer2 := JDTimer2 - ( DtGrTopo / 24.0 ) ;

               If ( Not RealTimeDate )
                 Then
                   Begin

                     If ( RealTimeStep )
                       Then
                         Begin
                           JDate := JDateParam + ( JdTimer2 - JdTimer2Param ) ;
                         End
                       Else
                         Begin
                           JDate := JDate + StepTime ;
                         End ;
                   End
                 Else
                   Begin
                     JDate := JDTimer2 ;
                   End ;

            End ;

       End ;

   End ;  { While Not EndProc }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }



 If ( Selected )  Then
   Begin  { ì·‚†≠Æ¢™† p•¶®¨Æ¢ SimFOV }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
     Selected := False ;

     If ( NSatFound > -100 )  Then
       Begin

         Selected          := True ;
         Param.OptAxOrient := 4    ;  { èÆ Æ°Í•™‚„  }
                                      { ƒƒƒƒƒƒƒƒƒƒ  }
         If ( FoundSat )
           Then
             Begin

               Param.NObj  := 2    ;  { èÆ ëØ„‚≠®™„ }
                                      { ƒƒƒƒƒƒƒƒƒƒƒ }
               {
               PlanetRecord := PlanetPtr [ NSatFound Div PlanetBlockSize ]^
                                         [ NSatFound Mod PlanetBlockSize ] ;

               PaRam.NSat  := PlanetRecord.Nr ;
               }
               PaRam.NSat  := NSatFound ;

             End
           Else
             Begin

               Param.NObj  := 1    ;  { èÆ è´†≠•‚• }
                                      { ƒƒƒƒƒƒƒƒƒƒ }

               PlanetRecord := PlanetPtr [ NSatFound Div PlanetBlockSize ]^
                                         [ NSatFound Mod PlanetBlockSize ] ;

               PaRam.NPlan := PlanetRecord.Nr + 11 ;

             End ;

       End ; { NSatFound > -100 }

   End ;



 If ( Not Selected )  Then
   Begin    { ëØ„‚≠®™ ≠• ß†Â¢†Á•≠ }
            { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     AOpt0 := ( Cx - Xc ) / Mx  ;

     If ( Aopt0 < 0 ) Then
          AOpt0 := AOpt0 + Pi2 ;

     HOpt0 := ( Yc - Cy ) / My + H45  ;
     HOpt0 := HMean ( HOpt0 ) ;

     Param.OptAxOrient := 2 ;
     Param.HOptType    := 1 ;

     JdEp := JDate ;

   End ;


 For Page := 0  To  NGPages - 1  Do
   Begin
     SetActivePage ( Page ) ;
     With pvp Do SetViewPort ( x1, y1, x2, y2, clip );
     SetColor   ( Col   ) ;
     SetBkColor ( Black ) ;
     With Fs Do
       SetFillStyle(Pattern, Color);
     SetWriteMode ( NormalPut );
     ClearViewPort;
   End;


 If ( B_Out_IKO )  Then
   Close ( OutIkoFile ) ;

 If ( B_Bs )  Then
   FreeMem ( BsIko, SizeOf ( BsIkoArr ) ) ; ;
 BsIko := Nil ;

 LocalInitGr;

End;

Procedure LocalInitGr;
         {‹‹‹‹‹‹}
Var
 GDriver, GMode : Integer;

Begin

 CloseGraph;

 GDriver := EGA;
 GMode   := EGAHi;

 InitGraph( GDriver,GMode,'' );

 If GraphResult < 0 Then
   Begin
     TextMode ( LastMode );
     WriteLn  ( GraphErrorMsg ( GraphResult ) ) ;
   End;

  getaspectratio(xasp,yasp);

  setcolor(LightGray);

End;


End.
