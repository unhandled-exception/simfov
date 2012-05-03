{$O+,F+}

Unit PPlDraw ;

Interface

Procedure  PlanDraw ( RaC, DeclC, DRaC : Double ) ;
{
    Ñ´Ô ¢ÎßÆ¢† ØpÆÊ•§„pÎ „·‚†≠Æ¢®‚Ï ØÆ´Æ¶•≠®• ≠†°´Ó§†‚•´Ô ≠† ·Ø„‚≠®™• -Nè´.
    èÆ´• ßp•≠®Ô: RaOpt, DeclOpt, SiseRa, SiseDecl.

    ParamStr : Latitude, MPred
               èp® Æ‚·„‚·‚¢®® MPred -> MPred = 3.0
    MGrek : Param.DMvDet
}


Implementation

Uses

 Graph, Crt, Dos, Font, PGreek,
 PVar, PVarMenu, V_Catal, PJd8,
 PDayJd, PPRENew, PPreNXyz, PNutNew, PProFld,
 PPLPRO,  GLib, PATan2, PRefr, BGIDriv,
 Greek_f;

Const

      B_Sumerki : Boolean = False ; { Ñ´Ô ·Á•‚† ·„¨•p•™ True }

      D86400 : Double = 86400.0 ;
      D30    : Double =    30.0 ;
      D10    : Double =    10.0 ;

Var
    NDate        : LongInt ;
    TDay         : Double  ;
    MonthDateOld : Word    ;

(*Procedure EGAVGADriverProc; external;
   {$L EGAVGA.OBJ}
  *)

Procedure InitGr;
         {‹‹‹‹‹‹}
Var
 GDriver, GMode : Integer ;
 xasp , yasp    : Word    ;

Begin

{ Register EGA/VGA driver }

 If RegisterBGIdriver(@EGAVGADriverProc) < 0 Then
    Begin
      Writeln('EGA/VGA');
      Halt ( 1 ) ;
    End ;

{ Register TScript font     }
{
  TFont := InstallUserFont( 'TScr' );
  if RegisterBGIfont(@TScrFontProc) < 0 then
      Abort('TScript Font');
 GDriver := EGA;
 GMode   := EGAHi;
}

 GDriver := Detect;
 InitGraph( GDriver,GMode,'' );

 If GraphResult < 0 Then
   Begin
     TextMode(LastMode);
     WriteLn(GraphErrorMsg(GraphResult));
   End;

  {
  Load8x8;
  Load_greek;
  }
  Load_greek ;


 getaspectratio ( xasp, yasp ) ;

 SetColor   ( Black    ) ;
 SetFillStyle ( SolidFill, White ) ;
 Bar ( 0, 0, GetMaxX, GetMaxY ) ;

End;

   Procedure  XYFLHJ (      Lat, Long, Height, Jd   : DOUBLE    ;
                       Var  X  , Y  , Z   ,
                            REarFL, LatGeoc, S      : DOUBLE      ) ;

                      { êÖáìãúíÄí : }
                      { ‹‹‹‹‹‹‹‹‹‹‹ }
{
                X, Y, Z  - ùäÇÄíéêàÄãúHõÖ,  Km
                REarFL   - êÄÑàìë áÖåãà Ç èìHäíÖ
                LatGeoc  - ÉÖéñÖHíêàóÖëäÄü òàêéíÄ
                S        - åÖëíHéÖ àëíàHéÖ áÇÖáÑHéÖ ÇêÖåü
}


      Const

            RE     : DOUBLE =  6378.137          ;
            S01900 : Double =  23925.836         ;

      Var

        D1, S0,  L, CLat,
        Jd0, UT, R, RH,
        T , Eps,
        OM, L1, F, D,
        DPsi, DEps,
        CEpsT
                                                  : DOUBLE ;

         Begin


             {  çìíÄñàü Ç ÑéãÉéíÖ à Ç çÄäãéçÖ  }
             {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

	   T    := ( Jd - 2415020.0 ) / 36525.0 ;

	   Eps  := ( 84428.26 - 46.845 * T - 0.06 * T * T ) / SekRad ;

	   OM   := 4.52364  - T *   33.75715 ;
	   L    := 5.168131 + T * 8328.691   ;
	   L1   := 6.256584 + T *  628.3019  ;
	   F    := 0.19632  + T * 8433.466   ;
	   D    := 6.1215   + T * 7771.377   ;

	   DPsi := (-17.233 -0.017*T) * Sin ( OM )
                    - 1.273           * Sin ( C20 * ( OM + F - D ) ) ;

	   DPsi := DPsi + 0.209 * Sin ( C20 *  OM    )
                        - 0.204 * Sin ( C20 * (OM+F) )
	                + 0.126 * Sin ( L1           ) ;


	   DEps :=  9.210 * Cos ( OM )
                  + 0.552 * Cos ( C20 * ( OM + F - D ) ) ;

	   DEps := DEps - 0.090 * Cos ( C20 *   OM       )
                        + 0.088 * Cos ( C20 * ( OM + F ) ) ;

	   DPsi := DPsi / SekRad ;
	   DEps := DEps / SekRad ;

           CEpsT := Cos ( Eps + DEps ) ;



             { åÖëíçéÖ áÇÖáÑçéÖ ÇêÖåü }
             { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           Jd0 := Trunc ( Jd ) + 0.5 ;
           If ( Jd < Jd0 )  Then
             Jd0 := Jd0 - C10 ;
           UT  := ( Jd - Jd0 ) * Pi2 ;
           D1  := Jd0 - 2415020.0 ;

           S0 := S01900 + 236.55536049 * D1 + 0.0929 * Sqr ( D1 / 36525 ) ;
           S0 := S0 * 15.0 / SekRad ;
           S0 := S0 - Trunc ( S0 / PI2 ) * PI2 ;
           S0 := S0 + DPsi * CEpsT ;
           S  := S0 + Long + UT * 1.0027379093 ;   { Long  '+' -> Russia }
           S  := S  - Trunc ( S / PI2 ) * PI2 ;


           LatGeoc := Lat             ; { Ñ´Ô X,Y,Z ≠„¶≠† †·‚pÆ≠. Ë®pÆ‚† }
           CLat    := Cos ( LatGeoc ) ;

           RH   := 0.99832707 + 0.00167644 * Cos ( C20 * Lat ) -
                                0.00000352 * Cos ( 4.0 * Lat )   ;

           REarFL := RH * RE ;  { êÄÑàìë áÖåãà Ç íéóäÖ ( Lat, Long ) Ç äå }
                                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           RH   := RH * ( RE + Height ) ;


           X    := Cos ( S )  *   CLat            ;
           Y    := Sin ( S )  *   CLat            ;
           Z    :=                Sin ( LatGeoc ) ;


           { èÖêÖÇéÑ  ä - í  Ç  äå }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           X   := X * RH  ;
           Y   := Y * RH  ;
           Z   := Z * RH  ;

         End ;



Procedure  PlanDraw ( RaC, DeclC, DRaC : Double ) ;


Const

 MGreek     : Single  =    3.0  ;
 FiPlanDrav : Single  =   56    ;
 BGreekLat  : Boolean =    True ;
 Koeff                =    1.55 ;  { é‚≠ÆË•≠®• §´®≠≠Æ© ·‚ÆpÆ≠Î ™ ™ÆpÆ‚™Æ© }


Var

 Prima,
 CNeg,
 B_H,
 BVid,
 Quit,
 ScaleHour,
 FileOut,
 Metka                  : Boolean      ;

 chh                    : Char         ;

 RaH, RaM,
 HH, IMin, ISek,
 DxScale,
 DxScale2,
 DxScale3,
 DyScale,
 DyScale2,
 DyScale3,
 XC, YC,
 DxScr,
 DyScr,
 Cx, Cy,
 CxMax, CyMax,
 BaseCx,
 SRadii,
 Ind, I,
 IndMax,
 G, Mnt,
 NScaleMin              : Integer      ;

 GreatSize,
 SColor,
 col,
 ColorSky               : Word         ;


 Sx, Sy,
 Dx, Dy                 : LongInt      ;


 R, Mv,
 CRoEar,
 CRoSun,
 JdFile,
 RaPl  , DeclPl ,
 MvPl  , Phase ,
 SD, CD, SR, CR,
 SH, CH, SA, CA,
 ST, CT,
 SDA, CDA,
 SPOZ, CPOZ,
 X,   Y,   Z,
 PmX, PmY, PmZ,
 PhaseEarth, PhaseMoon,
 DRaCH, DDeclCGr,
 StepScale,
 JDate0,
 JDateEnd,
 RaS, DeclS,
 RaSun, DeclSun,
 DDeclC,
 Sec,
 XPlGeoCentric,
 YPlGeoCentric,
 ZPlGeoCentric,
 {
 XSunGeoCentric,
 YSunGeoCentric,
 ZSunGeoCentric,
 }
 XPlGelioCentric,
 YPlGelioCentric,
 ZPlGelioCentric,
 RPlGelioCentric,
 LPl, BPl,
 StepWriteFile,
 SEps2000, CEps2000,
 Mx, My                           : Double           ;

 SwIko,
 pvp          : ViewPortType     ;

 fs,
 FillInfo     : FillSettingsType ;

 S, S1, t     : String        ;
 Sn           : String [ 24 ] ;
 Sn1          : String [  9 ] ;

 CxOld : Array [ 1 .. 16 ]  Of Integer ;
 CyOld : Array [ 1 .. 16 ]  Of Integer ;

 PlanOut : Text ;

 VSoed,
 RVSoed,
 RoVSoed,
 VElong,
 RoVElong,
 NSoed,
 RNSoed,
 RoNSoed,
 ZElong,
 RoZElong    : Array [ 1 .. 4 ] Of Double ;

 LSun,
 LPlan,
 RoPlanSun,
 MvMaxPlan   : Double ;

 IVSoed,
 IVElong,
 INSoed,
 IZElong     : Integer ;





    Procedure BsFld ;
   {****************}

   Type

          Bs5Type = Record
                                                                     { ERR }
		      SDRA    : Word    ;  { Sin DRA   * CONSTDSIN }
		      SDDEC   : Word    ;  { Sin DDEC  * CONSTDSIN }
                      MuRa    : Integer ;  { MuRa      * .6*10**9  }{0.0003" }
                      MuDec   : Integer ;  { MuDec     * .6*10**9  }{0.0003" }
		      Mv      : Integer ;  { Mv        *       10  }{0.05    }
		      Cat     : Byte    ;
                      Sp      : Byte    ;
                      Number  : Integer ;
                      Name    : String [ 7 ] ;

		    End;


    Var

         Bs5Record          :         Bs5Type ;
         Bs5File            : File Of Bs5Type ;

         CnstExist          : Boolean         ;

         Spectr,
         Cat, SdS           : Byte            ;

         SRadii             : Integer         ;

         Index,
         Mv,
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
         DecMin, DecMax,
         SP, CP, SG, CG, DTMU,
         DDeclPM,
         ST, CT, SDA, CDA,
         SPOZ, CPOZ,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         RaS, DeclS,
         MR, MD             : Double     ;


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

         IndCnst,
         FindCnst,
         NCnst    : Integer ;
         Cnst     : Array [ 1 .. 90 ]  Of  String [ 3 ] ;
         XCnst    : Array [ 1 .. 90 ]  Of  Integer      ;
         YCnst    : Array [ 1 .. 90 ]  Of  Integer      ;
         NPCnst   : Array [ 1 .. 90 ]  Of  Integer      ;


     Begin  { PRO STARFLD }


        NCnst     := 0 ;
        GreatSize := 2 ;

        For IndCnst := 1 To 90 Do
          Begin
            Cnst   [ IndCnst ] := '   ' ;
            XCnst  [ IndCnst ] :=   0   ;
            YCnst  [ IndCnst ] :=   0   ;
            NPCnst [ IndCnst ] :=   0   ;
          End ;


        CxMax := SwIko.x2 - SwIko.x1 + 1 ;
        CyMax := SwIko.y2 - SwIko.y1 + 1 ;

        With SwIko Do
          SetViewPort ( x1, y1, x2, y2, clipon ) ;

        SetFillStyle ( SolidFill, Black );



        FileMode := 0 ;

        Assign ( Bs5File   , ParamDir.BsDir + '\' + 'Bs5.Srt' ) ;
        Reset  ( Bs5File                                      ) ;

        Assign ( BsKeyFile , ParamDir.BsDir + '\' + 'Bs5.Grn' ) ;
        Reset  ( BsKeyFile                                    ) ;



        RAOPTFLD   := RAOPT   ;
        DECLOPTFLD := DECLOPT ;


        SDECLOPTFLD := SIN ( DECLOPTFLD ) ;
        CDECLOPTFLD := COS ( DECLOPTFLD ) ;

        SRAOPTFLD   := SIN ( RAOPTFLD   ) ;
        CRAOPTFLD   := COS ( RAOPTFLD   ) ;




        JD8 ( Param.TimeYear, 7, 1, JDateFld ) ;

        DTMU := ( JDateFld - JdCat [ CatBs ] ) / 365.25 ;


        NUMRA  := 1 ;


        RaMin  :=   0.0      ;
        RaMax  :=   Pi2      ;

        DecMin :=   DECLOPTFLD - ( DDeclC * 1.0123456789 )  ;
        DecMax :=   DECLOPTFLD + ( DDeclC * 1.0123456789 )  ;

        If ( DecMin < -Pid2 )  Then
          DecMin := -Pid2 ;

        If ( DecMax > ( Pid2 - 2.0 * StepRad ) ) Then
          DecMax := Pid2 - 2.0 * StepRad ;



        N1 := TRUNC ( ( DECMIN * RG + 90.0 ) / STEPGR ) - 1;
	N2 := TRUNC ( ( DECMAX * RG + 90.0 ) / STEPGR ) - 1;

	NUMDEC := N2 - N1 + 1;



	For  JDEC := 1 To  NUMDEC  Do
         Begin  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;
          If ( DecTek > Pid2 )  Then
            DecTek := Pid2 -0.001 ;

          NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDECFILD := SinDecFild [ NFILDDEC ] ;
          CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;




              { ÇõóàëãÖçàÖ çÄóÄãÄ à äéçñÄ àçîéêåÄñàà Ç äÄíÄãéÉÖ }
              { ----------------------------------------------- }


	  NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
          NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	  NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	  NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


          For  NRA := NBEG  To  NEND  Do
            Begin  { NRA }

            Seek ( BsKeyFile , NRA       ) ;
            Read ( BsKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

            Read ( BsKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;


            If ( JNEND >= JNBEG )  Then
            Begin { JEND >= JNBEG }


             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  èêéëåéíê  áÇÖáÑ  BS  }
                {  ===================  }

             Seek ( Bs5File , JNBEG - 1 ) ;


	     For  JSTAR := JNBEG  To  JNEND  Do
             Begin  { JSTAR }

              Read ( Bs5File , Bs5Record ) ;

              Mv := Bs5Record.Mv / D10 ;

              If ( Mv <= MvMax )  Then
              Begin  { MV <= MVMAX }

               SDRA   := Bs5Record.SDRA  / CONSTDSIN ;
               SDDEC  := Bs5Record.SDDEC / CONSTDSIN ;

               CDRA   := SQRT ( C10 - SDRA  * SDRA  ) ;
               CDDEC  := SQRT ( C10 - SDDEC * SDDEC ) ;

               CAT    := Bs5Record.Cat ;
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


	       CDA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SDA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;


               MR := Bs5Record.MURA  / 0.6 / 1000000000.0 * DTMU ;
               MD := Bs5Record.MUDEC / 0.6 / 1000000000.0 * DTMU ;


               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;


               PreNXyz ( JdCat [ CatBs ], JDateFld,  XRect, YRect, ZRect ) ;


               RaS   := ATan2 ( YRect , XRect ) ;
               DeclS := Atan2 ( ZRect , Sqrt ( Sqr ( XRect ) + Sqr ( YRect ) )  ) ;
               If ( DeclS > Pi )  Then
                 DeclS := DeclS - Pi2 ;



               RR := RaS - RaC ;
               If ( Abs ( RR ) > Pi )  Then
                 Begin
                   If ( RR > 0.0 )
                     Then  RR := RaS - ( RaC + Pi2 )
                     Else  RR := RaS - ( RaC - Pi2 ) ;
                 End ;


               Sx := Dx - Round ( ( ( RR            ) * Rg / 15.0 ) * Mx ) ;
               Sy := Dy - Round ( ( ( DeclS - DeclC ) * Rg        ) * My ) ;

               {
               SRadii := 1 + Round ( ( ( MvMax - Mv ) ) / C20 ) ;
               FillEllipse  ( Cx, Cy, Sradii, SRadii ) ;
               }

               If (     ( Sx >    0  )
                    And ( Sx < CxMax )
                    And ( Sy >    0  )
                    And ( Sy < CyMax )  )  Then
                 Begin

                   Cx := Dx - Round ( ( ( RR            ) * Rg / 15.0 ) * Mx ) ;
                   Cy := Dy - Round ( ( ( DeclS - DeclC ) * Rg        ) * My ) ;

                   SColor := Black ;
                   SRadii := 1 + Round ( MvMax - Mv ) ;
                   If ( SRadii > 7 )  Then
                     SRadii := 7 ;

                   Case SRadii Of

                         1:  Begin

                              PutPixel ( Cx  , Cy   , SColor ) ;
                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;

                             End ;


                         2:  Begin

                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx  , Cy-1, Cx  , Cy+1 ) ;

                             End ;


                         3: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                            End ;

                         4: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;
                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;

                            End ;

                         5: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;

                              Line ( Cx-2, Cy-1, Cx+2, Cy-1 ) ;
                              Line ( Cx-2, Cy+1, Cx+2, Cy+1 ) ;

                              Line ( Cx-1, Cy-2, Cx+1, Cy-2 ) ;
                              Line ( Cx-1, Cy+2, Cx+1, Cy+2 ) ;

                            End ;

                         6: Begin

                              Dec ( Cy ) ;

                              Line ( Cx-2, Cy-1, Cx+2, Cy-1 ) ;
                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx-2, Cy+1, Cx+2, Cy+1 ) ;

                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;

                              Line ( Cx-2, Cy-2, Cx+2, Cy-2 ) ;
                              Line ( Cx-2, Cy+2, Cx+2, Cy+2 ) ;

                              Line ( Cx-2, Cy-2, Cx+2, Cy-2 ) ;
                              Line ( Cx-2, Cy+2, Cx+2, Cy+2 ) ;

                              Line ( Cx-1, Cy-3, Cx+1, Cy-3 ) ;
                              Line ( Cx-1, Cy+3, Cx+1, Cy+3 ) ;

                              Line ( Cx-3, Cy-1, Cx-3, Cy+1 ) ;
                              Line ( Cx+3, Cy-1, Cx+3, Cy+1 ) ;

                            End ;

                         7: Begin

                              Dec ( Cy ) ;
                              SetFillStyle ( SolidFill, SColor ) ;
                              FillEllipse ( Cx, Cy, 4, 4 ) ;

                            End ;

                         {
                         1:  Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                             End ;

                         2:  Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                             End ;


                         3: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                            End ;

                         4: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                            End ;

                         5: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                              PutPixel ( Cx-1, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy-1 , SColor ) ;
                            End ;

                         6: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                              PutPixel ( Cx-1, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy-1 , SColor ) ;
                              PutPixel ( Cx-2, Cy   , SColor ) ;
                              PutPixel ( Cx+2, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+2 , SColor ) ;
                              PutPixel ( Cx  , Cy-2 , SColor ) ;
                            End ;

                         7: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                              PutPixel ( Cx-1, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy-1 , SColor ) ;
                              PutPixel ( Cx-2, Cy   , SColor ) ;
                              PutPixel ( Cx+2, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+2 , SColor ) ;
                              PutPixel ( Cx  , Cy-2 , SColor ) ;

                              PutPixel ( Cx-2, Cy+1 , SColor ) ;
                              PutPixel ( Cx-2, Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy+2 , SColor ) ;
                              PutPixel ( Cx-1, Cy-2 , SColor ) ;

                              PutPixel ( Cx+2, Cy+1 , SColor ) ;
                              PutPixel ( Cx+2, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+2 , SColor ) ;
                              PutPixel ( Cx+1, Cy-2 , SColor ) ;
                            End ;
                         }
                   End ; { Case }

                   {
                   If ( Bs5Record.Name <> '      ' )  Then
                     OutTextXY ( Cx + 8, Cy, Bs5Record.Name ) ;
                   }

                   {
                   If ( DRaCH > 1 )
                     Then
                       Begin
                         If ( DRaCH > 3 )
                           Then
                             Begin
                               S := Copy ( Bs5Record.Name, 1, 3 ) ;
                               If (     (    ( S = 'Alp' )
                                          Or ( S = 'Bet' ) )
                                    And ( Mv < 1.7         )  )   Then
                                 OutTextXY ( Cx + 8, Cy, Bs5Record.Name ) ;
                             End
                           Else
                             Begin
                               S := Copy ( Bs5Record.Name, 1, 3 ) ;
                               If (    ( S = 'Alp' )
                                    Or ( S = 'Bet' )
                                    Or ( S = 'Gam' )
                                    Or ( S = 'Del' )  )  Then
                                 OutTextXY ( Cx + 8, Cy, Bs5Record.Name ) ;
                             End
                       End
                     Else
                       Begin
                         If ( Bs5Record.Name <> '      ' )  Then
                           OutTextXY ( Cx + 8, Cy, Bs5Record.Name ) ;
                       End ;
                   }



                         { Name Star & Const }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                   If ( Bs5Record.Name <> '       ' )  Then
                     Begin

                       S := Copy ( Bs5Record.Name, 1, 4 ) ;
                       t := Copy ( Bs5Record.Name, 5, 3 ) ;

                       {
                       If (     ( DRaCH <= 9.01 )
                            And ( Mv < MGreek   )  )   Then
                         Greek ( Cx + 5, Cy, S, '   ' ) ;
                       }

                       If ( Mv < MGreek )    Then
                         Begin { Mv < MGreek }

                           If ( SRadii >= 6 )
                             Then Greek ( Cx + 8, Cy, S, '   ' )
                             Else Greek ( Cx + 5, Cy, S, '   ' ) ;


                           CnstExist := False ;

                           For IndCnst := 1 To NCnst Do
                             Begin
                               If ( Cnst [ IndCnst ] = t )  Then
                                 Begin
                                   CnstExist := True    ;
                                   FindCnst  := IndCnst ;
                                 End ;
                             End ;


                           If ( Not CnstExist )
                             Then
                               Begin

                                 Inc   ( NCnst )      ;
                                 Cnst  [ NCnst ] := t ;

                                 XCnst [ NCnst ] :=
                                 Round ( ( XCnst [ NCnst ] * NPCnst [ NCnst ]
                                       + Cx ) / ( NPCnst [ NCnst ] + C10 ) ) ;

                                 YCnst [ NCnst ] :=
                                 Round ( ( YCnst [ NCnst ] * NPCnst [ NCnst ]
                                       + Cy ) / ( NPCnst [ NCnst ] + C10 ) ) ;

                                 Inc ( NPCnst [ NCnst ] ) ;

                               End
                             Else
                               Begin

                                 XCnst [ FindCnst ] :=
                                 Round ( ( XCnst [ FindCnst ] * NPCnst [ FindCnst ]
                                       + Cx ) / ( NPCnst [ FindCnst ] + C10 ) ) ;

                                 YCnst [ FindCnst ] :=
                                 Round ( ( YCnst [ FindCnst ] * NPCnst [ FindCnst ]
                                       + Cy ) / ( NPCnst [ FindCnst ] + C10 ) ) ;

                                 Inc ( NPCnst [ FindCnst ] ) ;

                               End ;

                         End ; { Mv < MGreek }


                     End ;  { Bs5Record.Name <> '       ' }


                 End ; { In Field }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEND >= JNBEG }

           End ; { JRA }

         End ; { JDEC }


     Close ( Bs5File    ) ;
     Close ( BsKeyFile  ) ;



       { Name Const }
       { ƒƒƒƒƒƒƒƒƒƒ }

     GreatSize := 1 ;
     {
     If ( DRaCH <= 3.01 )
       Then GreatSize := 2
       Else GreatSize := 1 ;
     }

     SetTextStyle ( DefaultFont, HorizDir, GreatSize );

     For IndCnst := 1 To NCnst Do
       Begin
                {
                For Mercudy and Venera
                ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                }

             If ( Cnst [ IndCnst ] = 'And' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 16 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Aql' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  6 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Aqr' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  6 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  6 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Ara' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 46 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ]      ;
               End ;

             If ( Cnst [ IndCnst ] = 'Ari' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 24 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Aur' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 16 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Boo' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 20 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Cas' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 22 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Cen' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 33 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] +  4 ;
               End ;

             If ( Cnst [ IndCnst ] = 'CMa' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 16 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] +  8 ;
               End ;

             If ( Cnst [ IndCnst ] = 'CMi' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 16 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] +  6 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Col' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] -  6 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 12 ;
               End ;

             If ( Cnst [ IndCnst ] = 'CrB' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] + 16 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Del' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 12 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Gem' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] -  5 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  8 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Cet' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 10 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Gru' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 16 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  8 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Crt' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 24 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 11 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Cyg' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  2 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Eri' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  6 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] +  3 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Hya' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  2 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Ind' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 12 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Leo' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 12 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Lac' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 20 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 10 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Lep' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 24 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Lup' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  8 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 16 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Lyr' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 20 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Ori' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 16 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Per' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ]      ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 13 ;
               End ;

             If ( Cnst [ IndCnst ] = 'PsA' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] -  6 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] + 10 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Pup' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 12 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] + 14 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Ser' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 18 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] +  3 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Sge' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 10 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Sgr' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 10 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] + 22 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Sct' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  4 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Tau' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 20 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] + 12 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Vel' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  8 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Vir' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 10 ;
               End ;





              { Add for Mars }
              { ƒƒƒƒƒƒƒƒƒƒƒƒ }


         If ( NPl = 4 )  Then
           Begin

             If ( Cnst [ IndCnst ] = 'Aur' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 24 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Cas' )  Then
               Begin
                 {
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 16 ;
                 }
               End ;

             If ( Cnst [ IndCnst ] = 'Cap' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] -  2 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Cen' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] -  6 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  2 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Crv' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 28 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Cru' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 30 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] + 10 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Gem' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 16 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Leo' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 12 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Ori' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 12 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  2 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Per' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 14 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] - 10 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Pup' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 22 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Tau' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 40 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] +  4 ;
               End ;

             If ( Cnst [ IndCnst ] = 'UMa' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] -  8 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  8 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Vel' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] - 16 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  2 ;
               End ;

             If ( Cnst [ IndCnst ] = 'Vir' )  Then
               Begin
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] -  8 ;
               End ;


           End { NPl = 4 };



              { Add for Jupiter }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


         If ( NPl = 5 )  Then
           Begin

             If ( Cnst [ IndCnst ] = 'Cap' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  8 ;
               End ;


           End ; { NPl = 5 }




              { Add for Saturn }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         If ( NPl = 6 )  Then
           Begin

             If ( Cnst [ IndCnst ] = 'Cet' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  8 ;
               End ;

           End ; { NPl = 6 }



              { Add for Uran }
              { ƒƒƒƒƒƒƒƒƒƒƒƒ }


         If ( NPl = 7 )  Then
           Begin

             If ( Cnst [ IndCnst ] = 'Cap' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] +  2 ;
               End ;

           End ; { NPl = 7 }




              { Add for Pluto }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         If ( NPl = 9 )  Then
           Begin

             If ( Cnst [ IndCnst ] = 'Oph' )  Then
               Begin
                 XCnst [ IndCnst ] := XCnst [ IndCnst ] + 52 ;
                 YCnst [ IndCnst ] := YCnst [ IndCnst ] +  4 ;
               End ;

           End ; { NPl = 9 }







         If NPCnst [ IndCnst ] > 1
           Then
             Begin

               SetColor   ( Black    ) ;
               SetFillStyle ( SolidFill, White ) ;
               Bar ( XCnst [ IndCnst ] - GreatSize *  4 - 1 ,
                     YCnst [ IndCnst ] - GreatSize *  4 - 1 ,
                     XCnst [ IndCnst ] + GreatSize * 24 + 1 ,
                     YCnst [ IndCnst ] + GreatSize *  4 + 1   ) ;

               OutTextXY ( XCnst [ IndCnst ],
                           YCnst [ IndCnst ],
                           Cnst  [ IndCnst ]  ) ;

             End
           Else
             Begin
               {
               If ( NCnst <= 20 )  Then
               }
                 Begin

                   SetColor   ( Black    ) ;
                   SetFillStyle ( SolidFill, White ) ;

                   Bar ( XCnst [ IndCnst ] + 18 - GreatSize *  4 - 1 ,
                         YCnst [ IndCnst ] -      GreatSize *  4 - 1 ,
                         XCnst [ IndCnst ] + 18 + GreatSize * 24 + 1 ,
                         YCnst [ IndCnst ] +      GreatSize *  4 + 1   ) ;

                   OutTextXY ( XCnst [ IndCnst ] + 18 ,
                               YCnst [ IndCnst ]      ,
                               Cnst  [ IndCnst ]        ) ;

                 End ;

             End ;

       End ;

     SetTextStyle ( DefaultFont, HorizDir, 1 );

    End ;  { Pro BsFld }






    Procedure PpmFld ;
   {****************}


    Var

         Spectr             : Byte       ;
         Cat, SdS           : Byte       ;

         SRadii             : Integer    ;

         Index,
         Mv,
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
         DecMin, DecMax,
         SP, CP, SG, CG, DTMU,
         DDeclPM,
         ST, CT, SDA, CDA,
         SPOZ, CPOZ,
         XRect, YRect, ZRect,
         X1, Y1, Z1,
         X2, Y2, Z2,
         RaS, DeclS,
         MR, MD             : Double     ;


         AddRazr,
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


     Begin  { PRO STARFLD }



        With SwIko Do
          SetViewPort ( x1, y1, x2, y2, clipon ) ;

        SetFillStyle ( SolidFill, Black );



        FileMode := 0 ;

        Assign ( PpmFile    , ParamDir.PpmDir + '\' + 'Ppm.Srt' ) ;
        Reset  ( PpmFile                                      ) ;

        Assign ( PpmKeyFile , ParamDir.PpmDir + '\' + 'Ppm.Grn' ) ;
        Reset  ( PpmKeyFile                                   ) ;



        RAOPTFLD   := RAOPT   ;
        DECLOPTFLD := DECLOPT ;


        SDECLOPTFLD := SIN ( DECLOPTFLD ) ;
        CDECLOPTFLD := COS ( DECLOPTFLD ) ;

        SRAOPTFLD   := SIN ( RAOPTFLD   ) ;
        CRAOPTFLD   := COS ( RAOPTFLD   ) ;




        JD8 ( Param.TimeYear, 7, 1, JDateFld ) ;

        DTMU := ( JDateFld - JdCat [ CatPpm ] ) / 365.25 ;


        NUMRA  := 1 ;


        RaMin  :=   0.0      ;
        RaMax  :=   Pi2      ;

        DecMin :=   DECLOPTFLD - ( DDeclC * 1.0123456789 )  ;
        DecMax :=   DECLOPTFLD + ( DDeclC * 1.0123456789 )  ;

        If ( DecMin < -Pid2 )  Then
          DecMin := -Pid2 ;

        If ( DecMax > ( Pid2 - 2.0 * StepRad ) ) Then
          DecMax := Pid2 - 2.0 * StepRad ;

        N1 := TRUNC ( ( DECMIN * RG + 90.0 ) / STEPGR ) - 1;
	N2 := TRUNC ( ( DECMAX * RG + 90.0 ) / STEPGR ) - 1;

	NUMDEC := N2 - N1 + 1;



	For  JDEC := 1 To  NUMDEC  Do
         Begin  { JDEC }

	  DECTEK := DECMIN + ( JDEC - 1 ) * STEPRAD;
          If ( DecTek > Pid2 )  Then
            DecTek := Pid2 - 0/001 ;

          NFILDDEC := TRUNC ( ( DECTEK * RG + STEPGR + 90.0 ) / STEPGR ) ;
          SDECFILD := SinDecFild [ NFILDDEC ] ;
          CDECFILD := SQRT ( C10 - SDECFILD * SDECFILD ) ;




              { ÇõóàëãÖçàÖ çÄóÄãÄ à äéçñÄ àçîéêåÄñàà Ç äÄíÄãéÉÖ }
              { ----------------------------------------------- }


	  NBEG :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
          NBEG := NBEG + TRUNC ( ( RAMIN  * RG + STEPGR ) / STEPGR ) -  1     ;

	  NEND :=        TRUNC ( ( DECTEK * RG + 90.0   ) / STEPGR ) * NRAMAX ;
     	  NEND := NEND + TRUNC ( ( RAMAX  * RG + STEPGR ) / STEPGR ) -  1     ;


          For  NRA := NBEG  To  NEND  Do
            Begin  { NRA }

            Seek ( PpmKeyFile , NRA       ) ;
            Read ( PpmKeyFile , KeyRecord ) ;

                 JNBEG := KeyRecord.NBEG     ;

            Read ( PpmKeyFile , KeyRecord ) ;

                 JNEND := KeyRecord.NBEG - 1 ;


            If ( JNEND >= JNBEG )  Then
            Begin { JEND >= JNBEG }


             NFILDRA := TRUNC ( ( RAMIN  * RG + STEPGR * ( NRA - NBEG + 1 ) )
                                              / STEPGR                      ) ;


             SRAFILD := SinRaFild [ NFILDRA ] ;
             CRAFILD := CosRaFild [ NFILDRA ] ;




		{  èêéëåéíê  áÇÖáÑ  Ppm  }
                {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

             Seek ( PpmFile , JNBEG - 1 ) ;


	     For  JSTAR := JNBEG  To  JNEND  Do
             Begin  { JSTAR }

              Read ( PpmFile , PpmRecord) ;

              Mv := PpmRecord.Mv / D10 - 5.0 ;

              If (     ( Mv >= MvMin )
                   And ( Mv <= MvMax ) )  Then
              Begin  { MV <= MVMAX }

               AddRazr := PpmRecord.Ppm Div 1000000 ;

               SdRa   := PpmRecord.SdRa  ;
               SdDec  := PpmRecord.SdDec ;

               SdDec  := SdDec + ( AddRazr Mod 30 ) / D30 ;
               SdRa   := SdRa  + ( AddRazr Div 30 ) / D30 ;

               SdRa   := SdRa  / ConstDSin ;
               SdDec  := SdDec / ConstDSin ;

               CdRa   := Sqrt ( C10 - SdRa  * SdRa  ) ;
               CdDec  := Sqrt ( C10 - SdDec * SdDec ) ;


               Cat    := PpmRecord.Cat ;

               SDS    := Cat Mod 2 ;
                      If ( SDS = 1 )  Then SdRa  := - SdRa  ;

               Cat    := Cat Div 2 ;

               SDS    := Cat Mod 2 ;
                      If ( SDS = 1 )  Then SdDec := - SdDec ;

               SRaSt  := SRaFild  * CdRa  + CRaFild  * SdRa  ;
               CRaSt  := CRaFild  * CdRa  - SRaFild  * SdRa  ;

               SDecSt := SDecFild * CdDec + CDecFild * SdDec ;
               CDecSt := CDecFild * CdDec - SDecFild * SdDec ;


	       CdA := CRaSt * CRaOptFld  +  SRaSt * SRaOptFld ;
	       SdA := SRaSt * CRaOptFld  -  CRaSt * SRaOptFld ;


               MR := PpmRecord.MuRa  / 3000.0 / SekRad * DtMu ;
               MD := PpmRecord.MuDec / 3000.0 / SekRad * DtMu ;


               XRect := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
               YRect := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
               ZRect := SDecSt         + Md * CDecSt                      ;


               PreNXyz ( JdCat [ CatPpm ], JDateFld,  XRect, YRect, ZRect ) ;


               RaS   := ATan2 ( YRect , XRect ) ;
               DeclS := Atan2 ( ZRect , Sqrt ( Sqr ( XRect ) + Sqr ( YRect ) )  ) ;
               If ( DeclS > Pi )  Then
                 DeclS := DeclS - Pi2 ;



               RR := RaS - RaC ;
               If ( Abs ( RR ) > Pi )  Then
                 Begin
                   If ( RR > 0.0 )
                     Then  RR := RaS - ( RaC + Pi2 )
                     Else  RR := RaS - ( RaC - Pi2 ) ;
                 End ;


               Sx := Dx - Round ( ( ( RR            ) * Rg / 15.0 ) * Mx ) ;
               Sy := Dy - Round ( ( ( DeclS - DeclC ) * Rg        ) * My ) ;

               {
               SRadii := 1 + Round ( ( ( MvMax - Mv ) ) / C20 ) ;
               FillEllipse  ( Cx, Cy, Sradii, SRadii ) ;
               }

               If (     ( Sx >    0 )
                    And ( Sx < 2000 )
                    And ( Sy >    0 )
                    And ( Sy < 2000 )  )  Then
                 Begin

                   Cx := Dx - Round ( ( ( RR            ) * Rg / 15.0 ) * Mx ) ;
                   Cy := Dy - Round ( ( ( DeclS - DeclC ) * Rg        ) * My ) ;

                   SColor := Black ;
                   SRadii := 1 + Round ( MvMax - Mv ) ;
                   If ( SRadii > 7 )  Then
                     SRadii := 7 ;

                   Case SRadii Of

                         1:  Begin

                              PutPixel ( Cx  , Cy   , SColor ) ;
                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;

                             End ;


                         2:  Begin

                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx  , Cy-1, Cx  , Cy+1 ) ;

                             End ;


                         3: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                            End ;

                         4: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;
                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;

                            End ;

                         5: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;

                              Line ( Cx-2, Cy-1, Cx+2, Cy-1 ) ;
                              Line ( Cx-2, Cy+1, Cx+2, Cy+1 ) ;

                              Line ( Cx-1, Cy-2, Cx+1, Cy-2 ) ;
                              Line ( Cx-1, Cy+2, Cx+1, Cy+2 ) ;

                            End ;

                         6: Begin

                              Dec ( Cy ) ;

                              Line ( Cx-2, Cy-1, Cx+2, Cy-1 ) ;
                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx-2, Cy+1, Cx+2, Cy+1 ) ;

                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;

                              Line ( Cx-2, Cy-2, Cx+2, Cy-2 ) ;
                              Line ( Cx-2, Cy+2, Cx+2, Cy+2 ) ;

                              Line ( Cx-2, Cy-2, Cx+2, Cy-2 ) ;
                              Line ( Cx-2, Cy+2, Cx+2, Cy+2 ) ;

                              Line ( Cx-1, Cy-3, Cx+1, Cy-3 ) ;
                              Line ( Cx-1, Cy+3, Cx+1, Cy+3 ) ;

                              Line ( Cx-3, Cy-1, Cx-3, Cy+1 ) ;
                              Line ( Cx+3, Cy-1, Cx+3, Cy+1 ) ;

                            End ;

                         7: Begin

                              Dec ( Cy ) ;
                              SetFillStyle ( SolidFill, SColor ) ;
                              FillEllipse ( Cx, Cy, 4, 4 ) ;

                            End ;

                         {
                         1:  Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                             End ;

                         2:  Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                             End ;


                         3: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                            End ;

                         4: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                            End ;

                         5: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                              PutPixel ( Cx-1, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy-1 , SColor ) ;
                            End ;

                         6: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                              PutPixel ( Cx-1, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy-1 , SColor ) ;
                              PutPixel ( Cx-2, Cy   , SColor ) ;
                              PutPixel ( Cx+2, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+2 , SColor ) ;
                              PutPixel ( Cx  , Cy-2 , SColor ) ;
                            End ;

                         7: Begin
                              PutPixel ( Cx  , Cy   , SColor ) ;
                              PutPixel ( Cx+1, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+1 , SColor ) ;
                              PutPixel ( Cx  , Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy   , SColor ) ;
                              PutPixel ( Cx-1, Cy+1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+1 , SColor ) ;
                              PutPixel ( Cx-1, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy-1 , SColor ) ;
                              PutPixel ( Cx-2, Cy   , SColor ) ;
                              PutPixel ( Cx+2, Cy   , SColor ) ;
                              PutPixel ( Cx  , Cy+2 , SColor ) ;
                              PutPixel ( Cx  , Cy-2 , SColor ) ;

                              PutPixel ( Cx-2, Cy+1 , SColor ) ;
                              PutPixel ( Cx-2, Cy-1 , SColor ) ;
                              PutPixel ( Cx-1, Cy+2 , SColor ) ;
                              PutPixel ( Cx-1, Cy-2 , SColor ) ;

                              PutPixel ( Cx+2, Cy+1 , SColor ) ;
                              PutPixel ( Cx+2, Cy-1 , SColor ) ;
                              PutPixel ( Cx+1, Cy+2 , SColor ) ;
                              PutPixel ( Cx+1, Cy-2 , SColor ) ;
                            End ;
                         }
                   End ; { Case }

                 End ; { In Field }

              End ;  { MV < MVMAX }

             End ; { JSTAR }

            End ; { JEND >= JNBEG }

           End ; { JRA }

         End ; { JDEC }


     Close ( PpmFile    ) ;
     Close ( PpmKeyFile ) ;


    End ;  { Pro PpmFld }




  Procedure PlanetFile ( JDate : Double ) ;

    Label EndSumerki ;

    Var

      BVosh,
      BZah,
      BKulm,
      BVoshSun,
      BZahSun,
      BKulmSun,
      BEnd,
      Prima                    : Boolean ;

      I,
      Prohod,
      DirJd                    : Integer ;


      RefrMean,
      StepTimePlanetFile,
      RaPl0Ut , DeclPl0Ut ,
      RGeoc0Ut,
      HPlKulm,
      APlan,    HPlan,
      APlanOld, HPlanOld,
      ASun,    HSun,
      ASunOld, HSunOld,

      APlanVosh,
      APlanZah,
      TPlanVosh,
      TPlanZah,
      TPlanVoshOut,
      TPlanZahOut,
      TPlanKulm,

      ASunVosh,
      ASunZah,
      TSunVosh,
      TSunZah,
      TSunVoshOut,
      TSunZahOut,

      TVosh,
      TZah,

      RMoon0h,

      HGorSun,
      HSunGor,

      TNightBeg,
      TNightEnd,
      TPlanBeg,
      TPlanEnd,

      D1, S0,

      JdOld,
      JdEnd,
      STime0,
      Jd                       : Double  ;



    Begin

      HGorSun  := 7.0 / Rg ;
      RefrMean := 35.0 * C600 / SekRad ;

      BVosh    := False ;
      BZah     := False ;
      BKulm    := False ;
      BVoshSun := False ;
      BZahSun  := False ;
      BKulmSun := False ;





      Jd    := JDate ;

      FiSAstron   := FiPlanDrav * Gr ;
      LongSAstron := 0.0       ;


      SFiS := Sin ( FiSAstron ) ;
      CFiS := Cos ( FiSAstron ) ;


               { Ç 0h UT, GeoC }
               { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      XYFLHJ  ( FiSAstron, LongSAstron, Alt, Jd,
                Xs, Ys, Zs, R_Planet, FiSGeoc, STime ) ;


      PlPro ( False,
              Jd, Jd, 3,
              0.0, 0.0, 0.0,
              NPl, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );


      RaPl0Ut   := RezPl [ NPl, 1 ]                               ;
      RaPl0Ut   := RaPl0Ut - Trunc ( RaPl0Ut / Pi2 ) * Pi2        ;
      DeclPL0Ut := RezPl [ Npl , 2 ]                              ;
      RGeoc0Ut  := RezPl [ NPl , 7 ]                              ;
      MvPl      := RezPl [ Npl , 3 ]                              ;
      Phase     := Sqr ( Cos ( RezPl [ Npl , 5 ] / C20 ) )        ;
      RMoon0h   := R_Planets [ NPl ] / ( RezPl [ NPl , 7 ] * AE ) ;


      If ( NPl <> 11 )
        Then
          STime0 := STime
        Else
          Begin

            X := C10 ;
            Y := 0.0 ;
            Z := 0.0 ;
            Nutnew ( JD,  1, X, Y, Z ) ;
            D1 := ( JD - 2451545.0 ) / 36525.0 ;
            STime0 := ( 67310.54841 + D1 * ( 3164400184.812866 + D1 * ( 0.093104 + D1 * ( -6.2e-6 ) ) ) ) / D86400
                   + ( Y / X ) / Pi2 ;

            STime0 := STime0 - Round ( STime0 ) ;
            If ( STime0 < 0.0 )  Then
              STime0 := STime0 + 1 ;


            STime0 := STime0 * Pi2 ;


          End ;


      Prima   := True ;
      HPlKulm := -C10 ;







      If ( NPl <> 11 )  Then
        Begin

          RPlGelioCentric := Sqrt (   Sqr ( XPlGelioC [ NPl ] )
                                    + Sqr ( YPlGelioC [ NPl ] )
                                    + Sqr ( ZPlGelioC [ NPl ] )  ) ;

          XPlGelioCentric := XPlGelioC [ NPl ] / RPlGelioCentric ;
          YPlGelioCentric := YPlGelioC [ NPl ] / RPlGelioCentric ;
          ZPlGelioCentric := ZPlGelioC [ NPl ] / RPlGelioCentric ;

          X :=   XPlGelioCentric ;
          Y :=   ZPlGelioCentric * SEps2000
               + YPlGelioCentric * CEps2000 ;
          Z :=   ZPlGelioCentric * CEps2000
               - YPlGelioCentric * SEps2000 ;


          LPl := ATan2 ( Y, X ) ;

          BPl := Atan2 ( Z, Sqrt ( Sqr ( X ) + Sqr ( Y ) )  ) ;
          If ( BPl > Pi )  Then
            BPl := BPl - Pi2 ;

        End ;

      {
      PlPro ( False,
              Jd, Jd, 3,
              Xs/Ae, Ys/Ae, Zs/Ae,
              11, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );



      XSunGeoCentric := RectCoordPl [ 11, 1 ] ;
      YSunGeoCentric := RectCoordPl [ 11, 2 ] ;
      ZSunGeoCentric := RectCoordPl [ 11, 3 ] ;
      }


      JdEnd  := JDate + C10 ;
      BEnd   := False       ;
      DirJd  :=         0   ;
      Prohod :=         1   ;
      BVid   := True        ;


      While Prohod <= 2 Do
      Begin { Prohod }

      While ( Jd <= JdEnd )  Do
        Begin


          XYFLHJ  ( FiSAstron, LongSAstron, Alt, Jd,
                    Xs, Ys, Zs, R_Planet, FiSGeoc, STime ) ;


          If (     (                                          NPl = 11  )
               And (  Abs ( StepTimePlanetFile * D86400 - D30 ) < 0.1 )  )  Then
            Begin

              X := C10 ;
              Y := 0.0 ;
              Z := 0.0 ;

              Nutnew ( JD,  1, X, Y, Z ) ;

              D1 := ( JD - 2451545.0 ) / 36525.0 ;
              STime := ( 67310.54841 + D1 * ( 3164400184.812866 + D1 * ( 0.093104 + D1 * ( -6.2e-6 ) ) ) ) / D86400
                     + ( Y/X + LongSAstron ) / Pi2 ;

              STime := STime - Round ( STime ) ;
              If ( STime < 0.0 )  Then
                STime := STime + 1 ;

              STime := STime * Pi2 ;

            End ;


          SSTime := Sin ( STime ) ;
          CSTime := Cos ( STime ) ;



             { Sun }
             { ƒƒƒ }

          PlPro ( False,
                  Jd, Jd, 3,
                  Xs/Ae, Ys/Ae, Zs/Ae,
                  11, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );


          RaPl   := RezPl [ 11, 1 ]                   ;
          RaPl   := RaPl - Trunc ( RaPl / Pi2 ) * Pi2  ;
          DeclPL := RezPl [ 11 , 2 ]                  ;

          SD     := Sin  ( DeclPL        ) ;
          CD     := Sqrt ( C10 - SD * SD ) ;
          SR     := Sin  ( RaPL )          ;
          CR     := Cos  ( RaPL )          ;

          ST   := SSTIME * CR  -  CSTIME * SR ;
          CT   := CSTIME * CR  +  SSTIME * SR ;

          SH   := SD * SFIS + CD * CFIS * CT ;
          CH   := Sqrt ( C10 - Sqr ( SH ) )  ;

          HSun := ArcTan  ( SH / CH ) ;

          {
          If ( HSun > HGor )
            Then
              HSun := HApparent ( HSun )
            Else
              HSun := HSun - HGor ;
          }

                  { ìÁ•‚ Ñ®†¨•‚p† }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }
          {
          HSun := HSun + R_Planets [ 11 ] / ( RezPl [ 11 , 7 ] * AE ) ;
          }

            { Suns Gorizon }
            { ƒƒƒƒƒƒƒƒƒƒƒƒ }
          HSunGor := HSun + HGorSun ;



          SA   :=   CD * ST ;
          CA   := - SD * CFIS + CD * SFIS * CT ;

          ASun  := ATan2  ( SA , CA ) ;




            { Planet }
            { ƒƒƒƒƒƒ }

          PlPro ( False,
                  Jd, Jd, 3,
                  Xs/Ae, Ys/Ae, Zs/Ae,
                  NPl, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );




          RaPl   := RezPl [ NPl, 1 ]                   ;
          RaPl   := RaPl - Trunc ( RaPl / Pi2 ) * Pi2  ;
          DeclPL := RezPl [ Npl , 2 ]                  ;

          SD     := Sin  ( DeclPL        ) ;
          CD     := Sqrt ( C10 - SD * SD ) ;
          SR     := Sin  ( RaPL )          ;
          CR     := Cos  ( RaPL )          ;

          ST   := SSTIME * CR  -  CSTIME * SR ;
          CT   := CSTIME * CR  +  SSTIME * SR ;

          SH   := SD * SFIS + CD * CFIS * CT ;
          CH   := Sqrt ( C10 - Sqr ( SH ) )  ;

          HPlan := ArcTan  ( SH / CH ) ;



          {
          If ( HPlan > HGor )
            Then
              HPlan := HApparent ( HPlan )
            Else
              HPlan := HPlan - HGor ;
          }
          HPlan := HPlan + RefrMean ;

                  { ìÁ•‚ Ñ®†¨•‚p† }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

          HPlan := HPlan + R_Planets [ NPl ] / ( RezPl [ NPl , 7 ] * AE ) ;



          SA   :=   CD * ST ;
          CA   := - SD * CFIS + CD * SFIS * CT ;

          APlan := ATan2  ( SA , CA ) ;



          If (     ( Not Prima               )
               And (    ( HPlan    >= 0.0 )
                     Or ( HPlanOld >= 0.0 )  )    )  Then
            Begin


              If ( HPlan > HPlanOld )
                Then
                  Begin { H p†·‚•‚ }

                    If (     ( Not BVosh       )
                         And ( HPlan    >= 0.0 )
                         And ( HPlanOld <= 0.0 )  )  Then
                      Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                        If ( Abs ( HPlan - HPlanOld ) > 0.0 )
                          Then  R := - HPlanOld / ( HPlan - HPlanOld )
                          Else  R := 0.0 ;

                        APlanVosh := APlanOld + R * ( APlan - APlanOld ) ;
                        TPlanVosh := ( Jd - StepTimePlanetFile ) +
                                     R * StepTimePlanetFile ;
                        {
                        TPlanVosh := Jd - StepTimePlanetFile * ( C10 - R ) ;
                        }
                        TPlanVosh := TPlanVosh - JDate ;
                        BVosh     := True ;

                      End ;

                  End { H p†·‚•‚ }
                Else
                  Begin { H „°Î¢†•‚ }

                    If (     ( Not BZah        )
                         And ( HPlan    <= 0.0 )
                         And ( HPlanOld >= 0.0 )  )  Then
                      Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                        If ( Abs ( HPlan - HPlanOld ) > 0.0 )
                          Then  R := - HPlanOld / ( HPlan - HPlanOld )
                          Else  R := 0.0 ;

                        R := - HPlanOld / ( HPlan - HPlanOld ) ;
                        APlanZah  := APlanOld + R * ( APlan - APlanOld ) ;
                        TPlanZah  := ( Jd - StepTimePlanetFile ) +
                                     R * StepTimePlanetFile ;
                        {
                        APlanZah := APlanOld + R * ( APlan - APlanOld ) ;
                        TPlanZah := Jd - StepTimePlanetFile * ( C10 - R ) ;
                        }
                        TPlanZah := TPlanZah - JDate ;
                        BZah     := True ;

                      End ;

                  End ; { H „°Î¢†•‚ }




              If (     ( FiPlanDrav >= 0.0                )
                   And ( Not BKulm                        )
                   And ( HPlan          >  0.0            )
                   And (     ( APlanOld <= Pi2          )
                         And ( APlanOld > ( Pi2 - 0.1 ) ) )
                   And (     ( APlan    >= 0.0          )
                         And ( APlan    <  0.1          ) )
                                                            )
               Then
                Begin

                  R         :=   ( 0.0   - (APlanOld - Pi2)  )
                               / ( APlan - (APlanOld - Pi2)  ) ;
                  TPlanKulm := Jd - StepTimePlanetFile
                                  + StepTimePlanetFile * R ;
                  TPlanKulm := TPlanKulm - JDate ;

                  BKulm     := True  ;
                  HPlKulm   := HPlan ;

                End ;



              If (     ( FiPlanDrav < 0.0         )
                   And ( Not BKulm                )
                   And ( HPlan          >  0.0    )
                   And (     ( APlan    <= Pi   )
                         And ( APlanOld >  Pi   ) )
                                                    )
               Then
                Begin

                  R         :=   ( Pi    - APlanOld  )
                               / ( APlan - APlanOld  ) ;
                  TPlanKulm := Jd - StepTimePlanetFile
                                  + StepTimePlanetFile * R ;
                  TPlanKulm := TPlanKulm - JDate ;

                  BKulm     := True  ;
                  HPlKulm   := HPlan ;

                End ;





            End ; { Not Prima Plan }



                     { Sun }
                     { ƒƒƒ }

          If (     ( Not Prima               )
               And (    ( HSunGor  >= 0.0 )
                     Or ( HSunOld  >= 0.0 )  )    )  Then
            Begin

              If ( HSunGor > HSunOld )
                Then
                  Begin { H p†·‚•‚ }

                    If (     ( Not BVoshSun   )
                         And ( HSunGor >= 0.0 )
                         And ( HSunOld <= 0.0 )  )  Then
                      Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }


                        If ( ( HSunGor - HSunOld ) > 0.0 )
                          Then  R :=   HSunOld  /
                                     ( HSunGor - HSunOld )
                          Else  R := 0.0 ;

                        ASunVosh := ASunOld + R * ( ASun - ASunOld ) ;
                        TSunVosh := Jd - StepTimePlanetFile * ( C10 - R ) ;
                        TSunVosh := TSunVosh - JDate ;
                        BVoshSun := True ;

                      End ;

                  End { H p†·‚•‚ }
                Else
                  Begin { H „°Î¢†•‚ }

                    If (     ( Not BZahSun    )
                         And ( HSunGor <= 0.0 )
                         And ( HSunOld >= 0.0 )  )  Then
                      Begin  { è•p•·•™´® ÉÆp®ßÆ≠‚ }

                        If ( ( HSunOld - HSunGor ) > 0.0 )
                          Then  R :=   HSunOld  /
                                     ( HSunOld - HSunGor )
                          Else  R := 0.0 ;

                        ASunZah := ASunOld + R * ( ASun - ASunOld ) ;
                        TSunZah := Jd - StepTimePlanetFile * ( C10 - R ) ;
                        TSunZah := TSunZah - JDate ;
                        BZahSun := True ;


                      End ;

                  End ; { H „°Î¢†•‚ }


            End ; { Not Prima Sun }





          HPlanOld := HPlan    ;
          APlanOld := APlan    ;
          HSunOld  := HSunGor  ;
          ASunOld  := ASun     ;
          JdOld    := Jd       ;
          Prima    := False    ;




          If (     ( Abs ( HPlan   * Rg ) >  4.0 )
               And ( Abs ( HSunGor * Rg ) >  4.0 )
                                                    )
            Then
              StepTimePlanetFile := 360.0 / D86400
            Else
              Begin
                If ( NPl = 10 )
                  Then  StepTimePlanetFile :=  D10 / D86400
                  Else  StepTimePlanetFile :=  D30 / D86400 ;
              End ;


          If (     ( NPl = 11 )
               And (    (         APlan   < Pi / C600 )
                     Or ( ( Pi2 - APlan ) < Pi / C600 )  )  )  Then
            StepTimePlanetFile := D30 / D86400 ;




          If (     ( BVosh    )
               And ( BZah     )
               And ( BKulm    )
               And ( BVoshSun )
               And ( BZahSun  )  )
            Then
              Begin
                Jd := Jd + C20 ;
              End
            Else
              Begin
                Jd := Jd + StepTimePlanetFile ;
              End ;


        End ; { While Jd }




       If ( Prohod = 1 )  Then
         Begin

           TPlanVoshOut := TPlanVosh ;
           TPlanZahOut  := TPlanZah  ;

           TSunVoshOut := TSunVosh ;
           TSunZahOut  := TSunZah  ;

         End ;



       If ( NPl < 10 )  Then
       Begin  { NPlan < 10 }

       If ( TPlanZah < TPlanVosh )
         Then
           Begin { ì‚p•≠≠ÔÔ ¢®§®¨Æ·‚Ï }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

             Jd       := JDate - 0.9 ;
             JdEnd    := JDate       ;

             BZahSun  := False       ;
             BVosh    := False       ;

             Prima    := True        ;

             Inc ( Prohod ) ;

           End
         Else
           Begin

             If ( TPlanVosh < TSunVosh )
               Then
                 Begin { ì‚pÆ }

                   If ( Prohod = 1 )
                     Then
                       TPlanBeg := TPlanVosh
                     Else
                       Begin
                         If ( TPlanVosh < TSunZah )
                           Then  TPlanBeg := TSunZah
                           Else  TPlanBeg := TPlanVosh ;
                       End ;


                   If ( TPlanZah > TSunVosh )
                     Then TPlanEnd := TSunVosh
                     Else TPlanEnd := TPlanZah

                 End   { ì‚pÆ }
               Else
                 Begin { Ç•Á•p }

                   If ( TPlanVosh > TSunZah )
                     Then  TPlanBeg := TPlanVosh
                     Else  TPlanBeg := TSunZah   ;

                   If ( TPlanZah > TSunZah )
                     Then TPlanEnd := TPlanZah
                     Else BVid     := False    ;

                 End ; { Ç•Á•p }


             Prohod := 10 ;

           End ;

       End   { NPlan < 10 }
       Else
         Prohod := 10 ;


      End ; { Prohod }









           { Date }
           { ƒƒƒƒ }

     DayJd ( JDate, YearDate, MonthDate, DayDate ) ;

     If ( Not ( B_Sumerki ) )  Then
     If (     ( DayDate  =  1 )
          And ( NPl     >= 10 )  )   Then
       Begin

         Case  MonthDate  Of

           1 : t := ' ü≠¢†pÏ'   ;
           2 : t := ' î•¢p†´Ï'  ;
           3 : t := '  å†‡‚'     ;
           4 : t := ' ÄØ‡•´Ï'   ;
           5 : t := '  å†©'      ;
           6 : t := '  àÓ≠Ï'     ;
           7 : t := '  àÓ´Ï'     ;
           8 : t := ' Ä¢£„·‚'    ;
           9 : t := 'ë•≠‚Ô°pÏ'   ;
          10 : t := ' é™‚Ô°pÏ'   ;
          11 : t := ' HÆÔ°pÏ'    ;
          12 : t := ' Ñ•™†°pÏ'   ;

         End ;

         Writeln ( PlanOut ) ;
         Writeln ( PlanOut ) ;
         Writeln ( PlanOut,  t : 39 ) ;
         Writeln ( PlanOut          ) ;



         If ( NPl = 10 )  Then
           Begin
             WriteLn ( PlanOut,
'    √ƒƒƒƒƒƒƒ  ÑÆ´£Æ‚† = 0¯ ƒƒƒƒƒƒƒƒƒ¥  √ƒƒƒƒƒƒƒƒƒƒ  0 Á. Ç·•¨. Çp. ƒƒƒƒƒƒƒƒƒƒ¥ ' ) ;
             WriteLn ( PlanOut);
             WriteLn ( PlanOut,
'     ÇÆ·ÂÆ§  Ç.™.  á†ÂÆ§   Ä.Ç.  Ä.á.   èp.ÇÆ·Â.    ë™´Æ≠•≠®•  ì£´.Ñ®†¨. î†ß†' );
{
   1   9 54  14 37  19 29   -64    67    20 46 41   -15 07 11   16 05
}
             Writeln ( PlanOut          ) ;
             WriteLn ( PlanOut,
'      Á  ¨   Á  ¨   Á  ¨     ¯     ¯    Á  ¨  ·       ¯  `  "    `  "  ' ) ;
{
   1   9 54  14 37  19 29   -64    67    20 46 41   -15 07 11   16 05
}
           End ;


         If ( NPl = 11 )  Then
           Begin
             WriteLn ( PlanOut,
             '            √ƒƒƒƒƒƒ  ÑÆ´£Æ‚† = 0¯ ƒƒƒƒƒƒƒƒ¥  √ƒƒƒƒƒƒƒƒ  0 Á. Ç·•¨. Çp. ƒƒƒƒƒƒƒƒ¥ ' ) ;
             WriteLn ( PlanOut);

             WriteLn ( PlanOut,
             '      û.Ñ.   ÇÆ·ÂÆ§     Ç.ä.    á†ÂÆ§  ÒÄß    èp.ÇÆ·Â.    ë™´Æ≠•≠®•    á¢.Çp•¨Ô  ' );
             WriteLn ( PlanOut);

             If ( JDate0 > 2450000.0 )
             Then
             WriteLn ( PlanOut,
'      245     Á  ¨   Á  ¨  ·     Á  ¨    ¯    Á  ¨  ·       ¯  `  "    Á  ¨  ·  ' )
             Else
             WriteLn ( PlanOut,
'      240     Á  ¨   Á  ¨  ·     Á  ¨    ¯    Á  ¨  ·       ¯  `  "    Á  ¨  ·  ' ) ;
{
   1  0814.5   8 31  12 03 31.5  15 36   47    18 45 04   -23 01 58    6 41 47
}
           End ;


       End ;



     If ( NPl < 10 ) Or ( B_Sumerki )  Then
       Begin

         Case  MonthDate  Of

           1 : t := 'ü≠¢.' ;
           2 : t := 'î•¢.' ;
           3 : t := 'å†‡‚' ;
           4 : t := 'ÄØ‡.' ;
           5 : t := 'å†© ' ;
           6 : t := 'àÓ≠Ï' ;
           7 : t := 'àÓ´Ï' ;
           8 : t := 'Ä¢£.' ;
           9 : t := 'ë•≠.' ;
          10 : t := 'é™‚.' ;
          11 : t := 'HÆÔ.' ;
          12 : t := 'Ñ•™.' ;

         End ;


         S := t ;

         Str ( Trunc ( DayDate ) : 3, t ) ;
         S := S + t ;

         Write ( PlanOut, ' ', S ) ;

       End ;



     If ( NPl >= 10 ) And ( Not B_Sumerki )  Then
       Begin
         Str ( Trunc ( DayDate ) : 3, S ) ;
         Write ( PlanOut, S ) ;
       End ;

     If ( B_Sumerki )  Then
       GoTo EndSumerki ;

     If ( NPl = 11 ) Then
       Begin
         If ( JDate0 > 2450000.0 )
           Then
             Begin
               Str ( JDate - 2450000.0  : 6:1, S ) ;
               If ( S [ 1 ] = ' ' )  Then
                 S [ 1 ] := '0' ;
               S := '  ' + S ;
             End
           Else
             Begin
                Str ( JDate - 2400000.0  : 7:1, S ) ;
                If ( S [ 1 ] = ' ' )  Then
                     S [ 1 ] := '0' ;
                If ( S [ 2 ] = ' ' )  Then
                     S [ 2 ] := '0' ;
               S := ' ' + S ;
             End ;

         Write ( PlanOut,  S ) ;

       End ;

     S := '' ;



            { T ¢Æ·Â. }

     If ( BVosh )
       Then
         Begin

           G := Trunc ( TPlanVoshOut * 24.0 ) ;
           Sec := ( TPlanVoshOut * 24 - G ) * C600 ;

           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G := G Mod 24 ;
           Str ( G   : 4    , S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  , T )  ;  S := S + T  ;
         End
       Else
           S := '       ' ;

     Write ( PlanOut,  S ) ;


            { Ç. ä„´Ï¨. }

     If ( NPl <> 11 )  Then
     Begin
      If (     ( BKulm         )
           And ( HPlKulm > 0.0 )  )
       Then
         Begin

           G := Trunc ( TPlanKulm * 24.0 ) ;
           Sec := ( TPlanKulm * 24 - G ) * C600 ;

           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G   := G Mod 24 ;
           Str ( G   : 4    ,S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  ,T )  ;  S := S + T  ;
         End
       Else
           S := '       ' ;
     End ; { NPl <> 11 }



     If ( NPl = 11 )  Then
     Begin
      If (     ( BKulm         )
           And ( HPlKulm > 0.0 )  )
       Then
         Begin

           RadToGMS  ( TPlanKulm * Pi2 / 15.0, CNeg, G, Mnt, Sec ) ;

           Str ( G : 4  ,S )  ;
           S := S + ' ' ;

           Str ( Mnt : 2  ,T )  ;
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T + ' ' ;
           Str ( Sec : 4:1  ,T )  ;
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T  ;

         End
       Else
           S := '            ' ;

     End ; { NPl = 11 }

     Write ( PlanOut,  S ) ;





            { T ß†Â. }

     If ( BZah )
       Then
         Begin
           G := Trunc ( TPlanZahOut * 24.0 ) ;
           Sec := ( TPlanZahOut * 24 - G ) * C600 ;

           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G   := G Mod 24 ;
           Str ( G   : 4    ,S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  ,T )  ;  S := S + T  ;
         End
       Else
           S := '       ' ;

     Write ( PlanOut,  S ) ;


     If ( NPl = 11 ) Then
       Begin

           TDay := TPlanZahOut - TPlanVoshOut ;

           G := Trunc ( TDay * 24.0 ) ;
           Sec := ( TDay * 24 - G ) * C600 ;
           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G   := G Mod 24 ;
           Str ( G   : 4    ,S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  ,T )  ;  S := S + T  ;

           Write ( PlanOut,  S ) ;

       End ;


            { A Vosh }

     If ( NPl <> 10 )
       Then
         Begin

           If ( BVosh And BZah )
             Then
               Begin
                 G := Round ( ( Abs ( Pi2 - APlanVosh ) + APlanZah ) / C20 * Rg ) ;
                 Str ( G : 5  ,S )  ;
               End
             Else
                 S := '     ' ;
         End
       Else
         Begin

           S := '' ;

           If BVosh
             Then
               Begin
                 G := Round ( ( APlanVosh - Pi2 ) * Rg ) ;
                 Str ( G : 6  ,t )  ;
                 S := S + t ;
               End
             Else
                 S := S + '      ' ;

           If BZah
             Then
               Begin
                 G := Round ( APlanZah * Rg ) ;
                 Str ( G : 6  ,t )  ;
                 S := S + t ;
               End
             Else
                 S := S + '      ' ;

         End ;

     Write ( PlanOut,  S ) ;



            { è‡. ¢Æ·ÂÆ¶§•≠®• }

     RadToGMS ( RaPl0Ut / 15.0, CNeg, G, Mnt, Sec ) ;

     Str ( G : 5  ,S )  ;
     S := S      + ' ' ;

     If ( NPl < 10 )
       Then
         Begin
           Str ( ( Mnt + Sec/C600 ) : 4:1  ,t )  ;
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T  ;
         End
       Else
         Begin
           Str ( Mnt : 2  ,T )  ;
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T + ' ' ;
           Str ( Sec : 4:1  ,T )  ;
           {
           Str ( Sec : 6:3  ,T )  ;
           }
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T  ;
         End ;

     Write ( PlanOut,  S ) ;



              { ë™´Æ≠•≠®• }

     RadToGMS ( DeclPl0Ut, CNeg, G, Mnt, Sec ) ;

     If ( Round ( Sec ) >= 60 )  Then
       Begin
         Sec := 0.0 ;
         Mnt := Mnt + 1 ;
       End ;

     If ( Mnt >= 60 )  Then
       Begin
         Mnt := Mnt - 60 ;
         G   := G + 1 ;
         G   := G Mod 24 ;
       End ;

     Str ( G   : 3  , S );   S := S      +  ' ' ;
     If ( NPl < 10 )
       Then
         Begin

           If ( Sec > 30.0 )  Then
             Begin
               Sec := 0.0 ;
               Mnt := Mnt + 1 ;
             End ;

           If ( Mnt >= 60 )  Then
             Begin
               Mnt := Mnt - 60 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;


           Str ( Mnt + Sec/C600 : 2 : 0 , T );
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T  ;

         End
       Else
         Begin
           Str ( Mnt : 2  ,T )  ;
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T + ' ' ;
           Str ( Sec : 2:0  ,T )  ;
           {
           Str ( Sec : 5:2  ,T )  ;
           }
           If ( T [1] = ' ' )  Then
             T [1] := '0';
           S := S + T  ;
         End ;

     If CNeg Then
       S[1]:='-';

     Write ( PlanOut, '   ', S ) ;




             { RGeoc }
             { ƒƒƒƒƒ }

     If ( NPl < 10 )  Then
       Begin
         Str ( RGeoc0Ut : 7 : 3 , S ) ;
         Write ( PlanOut, ' '  , S ) ;
       End ;





             { R " }
             { ƒƒƒ }
     If ( NPl < 10 )  Then
       Begin
         R := R_Planets [ NPl ] / ( RezPl [ NPl , 7 ] * AE ) * SekRad ;
         Str ( R * C20 : 7 : 2, S ) ;
         Write ( PlanOut, ' ', S ) ;
       End ;



     If ( NPl = 10 )  Then
       Begin

         RadToGMS ( RMoon0h*2, CNeg, G, Mnt, Sec ) ;
         Sec := Round ( Sec ) ;
         If ( Sec >= 60 )  Then
           Begin
             Inc ( Mnt ) ;
             Sec := 0 ;
           End ;

         Str ( Mnt : 4   , S ) ;
         Str ( Sec : 3:0 , t ) ;
         If ( t [ 2 ] = ' ' )  Then
           t [ 2 ] := '0' ;
         S := S + t ;
         Write ( PlanOut, ' ', S ) ;

       End ;




             { î†ß† }
             { ƒƒƒƒ }

     If ( NPl < 11 )  Then
       Begin
         Str ( Phase : 6 : 2, S ) ;
         If ( NPl <> 11 )  Then
           Write ( PlanOut, '  ', S ) ;
       End ;



                  { Mv }
                  { ƒƒ }

     If ( NPl < 10 )  Then
       Begin
         Str ( Abs ( RezPl [ NPl, 3 ] ) : 4 : 1, S ) ;
         If ( RezPl [ NPl, 3 ] < 0 )
           Then S := '-' + S
           Else S := ' ' + S ;
         Write ( PlanOut, ' ', S ) ;
       End ;



     If ( NPl < 10 )  Then
     Begin
     If ( BVid )
       Then
         Begin

           If ( TPlanBeg < 0.0 )
             Then
               Begin
                 G   := Trunc ( ( C10 + TPlanBeg ) * 24.0 ) ;
                 Sec := ( ( C10 + TPlanBeg ) * 24 - G ) * C600 ;
               End
             Else
               Begin
                 G   := Trunc (         TPlanBeg * 24.0 ) ;
                 Sec := ( TPlanBeg * 24 - G ) * C600 ;
               End ;
           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G := G Mod 24 ;
           Str ( G   : 4    ,S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  ,T )  ;  S := S + T  ;

           Write ( PlanOut,  S ) ;


           G := Trunc ( TPlanEnd * 24.0 ) ;
           Sec := ( TPlanEnd * 24 - G ) * C600 ;
           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0   ;
               G   := G + 1 ;
             End ;
           G   := G Mod 24 ;
           Str ( G   : 3    ,S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  ,T )  ;  S := S + T  ;

           Write ( PlanOut,  S ) ;


           G := Trunc ( ( TPlanEnd - TPlanBeg ) * 24.0 ) ;
           Sec := ( ( TPlanEnd - TPlanBeg ) * 24 - G ) * C600 ;
           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G := G Mod 24 ;
           Str ( G   : 4    ,S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  ,T )  ;  S := S + T  ;

           Write ( PlanOut,  S ) ;


         End
       Else
         Begin
           If ( NPl <> 11 )  Then
             Begin
               S := '                    ' ;
               Write ( PlanOut,  S ) ;
             End ;
         End ;
     End ;



         { É•´®ÆÊ•≠‚p®Á•·™†Ô §Æ´£Æ‚† ® R }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
     {
     If ( NPl <> 11 )  Then
     }
     If ( NPl < 10 )  Then
       Begin


         Str ( LPl * Rg : 7:1, S ) ;
         Write ( PlanOut, S ) ;

         Str ( BPl * Rg : 6:1, S ) ;
         Write ( PlanOut, S ) ;

         Str ( RPlGelioCentric : 7 : 3, S ) ;
         Write ( PlanOut, S ) ;

       End ;



        { STime 0h UT }
        { ƒƒƒƒƒƒƒƒƒƒƒ }

     If ( Npl = 11 )  Then
       Begin

         RadToGMS ( STime0 / 15.0, CNeg, G, Mnt, Sec ) ;

         Str ( G : 5, S )  ;
         S := S + ' ' ;

         Str ( Mnt : 2  ,T )  ;
         {
         If ( T [1] = ' ' )  Then
           T [1] := '0';
         }
         S := S + T + ' ' ;
         Str ( Sec : 4:1  ,T )  ;
         {
         Str ( Sec : 6:3  ,T )  ;
         }
         {
         If ( T [1] = ' ' )  Then
           T [1] := '0';
         }
         S := S + T  ;

         Write ( PlanOut,  S ) ;

       End ;



     EndSumerki : ;


     If ( B_Sumerki ) Then
     Begin { B_Sumerki }

            { T ß†Â. Sun }

     If ( NPl = 11 )  Then
      Begin
       If ( BZahSun  )
        Then
         Begin
           G := Trunc ( TSunZah * 24.0 ) ;
           Sec := ( TSunZah * 24 - G ) * C600 ;
           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G := G Mod 24 ;
           Str ( G   : 4    ,S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  ,T )  ;  S := S + T  ;
         End
        Else
           S := '       ' ;

       Write ( PlanOut,  S ) ;

      End ;


            { T ¢Æ·Â. Sun }

     If ( NPl = 11 )  Then
      Begin
       If ( BVoshSun )
        Then
         Begin
           G := Trunc ( TSunVosh * 24.0 ) ;
           Sec := ( TSunVosh * 24 - G ) * C600 ;
           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G := G Mod 24 ;
           Str ( G   : 3    , S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  , T )  ;  S := S + T  ;
         End
        Else
           S := '      ' ;

       Write ( PlanOut,  S ) ;

      End ;



            { dT Night }

     If ( NPl = 11 )  Then
      Begin
       If ( BVoshSun And BZahSun)
        Then
         Begin
           G := Trunc ( ( TSunVosh + C10 - TSunZah  ) * 24.0 ) ;
           Sec := ( ( TSunVosh + C10 - TSunZah  ) * 24 - G ) * C600 ;
           If ( Round ( Sec ) = 60 )  Then
             Begin
               Sec := 0.0 ;
               G   := G + 1 ;
               G   := G Mod 24 ;
             End ;
           G := G Mod 24 ;
           Str ( G   : 3    , S )  ;  S := S      + ' ' ;
           Str ( Sec : 2:0  , T )  ;  S := S + T  ;
         End
        Else
           S := '      ' ;


       Write ( PlanOut,  S ) ;

      End ;

     End ; { B_Sumerki }



     WriteLn ( PlanOut ) ;


     If ( NPl >= 10 ) And ( Not B_Sumerki ) Then
       Begin
         If ( ( Trunc ( JDate + 2) Mod 7 ) = 0 )  Then
           WriteLn ( PlanOut ) ;
       End ;


    End ;


{ ******************************************************************** }

Begin

 InitGr ;



 For I := 1 To 4 Do
   Begin

     VSoed      [ I ] :=    0.0 ;
     RVSoed     [ I ] :=    0.0 ;
     RoVSoed    [ I ] := C10000 ;

     VElong     [ I ] :=    0.0 ;
     RoVElong   [ I ] :=    0.0 ;

     NSoed      [ I ] :=    0.0 ;
     RNSoed     [ I ] :=    0.0 ;
     RoNSoed    [ I ] := C10000 ;

     ZElong     [ I ] :=    0.0 ;
     RoZElong   [ I ] :=    0.0 ;

   End ;


 MvMaxPlan := C1000 ;

 IVSoed    :=   0   ;
 IVElong   :=   0   ;
 INSoed    :=   0   ;
 IZElong   :=   0   ;

 NDate        := 0 ;
 MonthDateOld := 0 ;


 Pi2     :=  Pi * C20 ;
 JdFile  := -2.0e10   ;

 SEps2000 := Sin ( 84381.448 / SekRad ) ;
 CEps2000 := Cos ( 84381.448 / SekRad ) ;

 NPl := Round ( Abs ( Param.ISat ) ) ;


      { Fi & MGreek for PlanDraw }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 FileOut := False ;

 If ( ParamCount > 0 )  Then
   Begin
     Val ( ParamStr(1), FiPlanDrav, Code ) ;
     FileOut := True ;
   End ;

 {
 If ( ParamCount > 1 )  Then
   Val ( ParamStr(2), MGreek, Code ) ;
 }

 MGreek := Param.DMvDet ;

 DDeclC := DRaC / Koeff ;
 If ( DDeclC * Rg ) > ( 70.0 ) Then
    DDeclC :=  70.0 / Rg ;


 GetViewSettings ( pvp ) ;
 GetFillSettings(fs);
 SetViewPort  ( 0, 0, GetMaxX, GetMaxY, clipon ) ;


 EndProc := False ;
 GetAspectRatio ( Xasp, Yasp ) ;



       { ë‚pÆ®¨ p†¨™„ ØÆ´Ô ßp•≠®Ô }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     With SwIko Do
       Begin

         x1 := 48 ;
         y1 :=  8 ;
         x2 := GetMaxX - 13 ;
         y2 := y1 + Trunc ( ( x2 - x1 ) / ( DRaC / DDeclC ) * XAsp/YAsp ) ;


         If ( ( x2 - x1  ) Mod 2 <> 0 ) Then
            Dec ( x2 ) ;
         If ( ( y2 - y1  ) Mod 2 <> 0 ) Then
            Dec ( y2 ) ;

       End ;

     SetLineStyle ( SolidLn, 0, NormWidth ) ;
     RectAngle ( SwIko.x1, SwIko.y1, SwIko.x2, SwIko.y2 ) ;
     {
     SetLineStyle ( SolidLn, 0, ThickWidth ) ;
     SetLineStyle ( SolidLn, 0, NormWidth ) ;
     }

     Inc ( SwIko.x1 ) ;
     Inc ( SwIko.y1 ) ;
     Dec ( SwIko.x2 ) ;
     Dec ( SwIko.y2 ) ;


     DxScr := SwIko.x2 - SwIko.x1 + 1 ;
     DyScr := SwIko.y2 - SwIko.y1 + 1 ;

     Dx    := DxScr Div 2 ;
     Dy    := DyScr Div 2 ;

     Xc    := SwIko.x1 + Dx ;
     Yc    := SwIko.y1 + Dy ;

     DRaCH    := DRaC   * Rg / 15.0 ;
     DDeclCGr := DDeclC * Rg        ;

     Mx    := Dx / ( DRaCH    ) ;
     My    := Dy / ( DDeclCGr ) ;

      {  R.A. }
     DyScale  :=  5 ;
     DyScale2 :=  8 ;
     DyScale3 := 10 ;

      { Decl. }
     DxScale  :=  5 ;
     DxScale2 :=  8 ;
     DxScale3 := 10 ;



         { Scale R.A. }
         { ƒƒƒƒƒƒƒƒƒƒ }

     If ( DRaCH >= 0.9999 )
       Then
         Begin

           ScaleHour := True             ;
           IndMax    := Round ( DRaCH )  ;
           StepScale := C10              ;

           RaC := Round ( RaC * Rg / 15.0 * 6.0 ) * 15.0 / 6.0 * Gr ;

           NScaleMin := 2 * Round ( DRaCH * 6.0 ) ;

         End
       Else
         Begin

           ScaleHour := False                  ;
           IndMax    := Round ( DRaCH * 6.0 )  ;
           StepScale := C10 / 6.0              ;


           { éØp•§•´•≠®• ‚®Ø† ÆÊ®‰pÆ¢™® Ë™†´Î }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           B_H       := False ;
           NScaleMin := 0     ;

           For Ind := - IndMax To IndMax Do
             Begin

               RaPl := StepScale * Ind ;

               Cx   := Round  ( Xc -  RaPl * Mx ) ;

               If (     ( Cx <= SwIko.x2 )
                    And ( Cx >= SwIko.x1 )  )  Then
                 Begin

                   RaPl := RaC * Rg / 15.0 + StepScale * Ind ;
                   If ( RaPl < -0.001 ) Then
                     RaPl := RaPl + 24.0 ;
                   If ( RaPl > 24.001 ) Then
                     RaPl := RaPl - 24.0 ;


                   RaH := Trunc ( RaPl ) ;
                   RaM := Round ( Frac ( RaPl ) * C600 ) ;
                   If ( RaM = 60 )  Then
                     Begin
                       RaM := 0 ;
                       Inc ( RaH ) ;
                       RaH := RaH Mod 24 ;
                     End ;

                   If ( RaM = 0 )  Then
                     B_H := True ;

                   Inc ( NScaleMin ) ;

                 End ;

             End ;



         End ;






     SetTextJustify ( CenterText, CenterText );

     For Ind := - IndMax To IndMax Do
       Begin

         If ( ScaleHour )
           Then
             Begin

               RaPl := StepScale * Ind ;

               Cx   := Round  ( Xc -  RaPl * Mx ) ;

               If (     ( Cx <= SwIko.x2 )
                    And ( Cx >= SwIko.x1 )  )  Then
                 Begin

                   {
                   Line ( Cx,  SwIko.y2+1,  Cx,  SwIko.y2+1 + DyScale3 ) ;
                   }

                   RaPl := RaC * Rg / 15.0 + StepScale * Ind ;

                   If ( RaPl < -0.001 ) Then
                     RaPl := RaPl + 24.0 ;

                   If ( RaPl >= 24 ) Then
                     RaPl := RaPl - 24.0 ;


                   RaH := Trunc ( RaPl ) ;
                   RaM := Round ( Frac ( RaPl ) * C600 ) ;
                   If ( RaM = 60 )  Then
                     Begin
                       RaM := 0 ;
                       Inc ( RaH ) ;
                       RaH := RaH Mod 24 ;
                     End ;


                   If ( RaM > 0 )
                     Then  Str ( RaM : 2, S )
                     Else  Str ( RaH : 2, S ) ;

                   If ( S [ 1 ] = ' ' )  Then
                     Delete ( S, 1, 1 ) ;

                   If ( S = '-0' )  Then
                     S := '0' ;

                   If ( RaM = 0 )
                     Then
                       Begin

                         S   := S + chr(240) ;

                         Line ( Cx, SwIko.y2+1, Cx, SwIko.y2+1 + DyScale3 ) ;
                         OutTextXY ( Cx, SwIko.y2+20, S ) ;

                       End
                     Else
                       Begin

                         S := S + chr(241)   ;

                         If ( RaM = 30 )
                           Then
                             Begin
                               Line ( Cx, SwIko.y2+1,
                                      Cx, SwIko.y2+1 + DyScale2 ) ;
                               If ( NScaleMin < 25 )  Then
                                 OutTextXY ( Cx, SwIko.y2+16, S ) ;
                             End
                           Else
                             Begin
                               Line ( Cx, SwIko.y2+1,
                                      Cx, SwIko.y2+1 + DyScale  ) ;
                               If ( NScaleMin < 25 )  Then
                                 OutTextXY ( Cx, SwIko.y2+13, S ) ;
                             End ;


                       End ;



                   For I := -5  To  5  Do
                    If ( I <> 0 )  Then
                     Begin

                       RaPl := RaC * Rg / 15.0 + StepScale * Ind
                                               + StepScale / 6.0 * I ;

                       If ( RaPl < -0.001 ) Then
                         RaPl := RaPl + 24.0 ;

                       If ( RaPl >= 24 ) Then
                         RaPl := RaPl - 24.0 ;

                       RaH  := Trunc ( RaPl ) ;
                       RaM  := Round ( Frac ( RaPl ) * C600 ) ;
                       If ( RaM = 60 )  Then
                         Begin
                           RaM := 0 ;
                           Inc ( RaH ) ;
                           RaH := RaH Mod 24 ;
                         End ;



                       RaPl := StepScale * Ind + StepScale / 6.0 * I ;

                       Cx   := Round  ( Xc - RaPl * Mx ) ;

                       If (     ( Cx <= SwIko.x2 )
                            And ( Cx >= SwIko.x1 )  )  Then
                         Begin
                           If ( RaM <> 0 )
                             Then
                               Begin

                                 Str ( RaM : 2, S ) ;

                                 If ( S [ 1 ] = ' ' )  Then
                                   Delete ( S, 1, 1 ) ;


                                 S := S + chr(241)   ;

                                 If ( RaM = 30 )
                                   Then
                                     Begin
                                       If ( NScaleMin < 50 )  Then
                                         Line ( Cx, SwIko.y2+1,
                                                Cx, SwIko.y2+1 + DyScale2 ) ;
                                       If ( NScaleMin < 25 )  Then
                                         OutTextXY ( Cx, SwIko.y2+16, S ) ;
                                     End
                                   Else
                                     Begin
                                       If ( NScaleMin < 50 )  Then
                                         Line ( Cx, SwIko.y2+1,
                                                Cx, SwIko.y2+1 + DyScale  ) ;
                                       If ( NScaleMin < 25 )  Then
                                         OutTextXY ( Cx, SwIko.y2+12, S ) ;
                                     End ;

                               End
                             Else
                               Begin

                                 Str ( RaH : 2, S ) ;

                                 If ( S [ 1 ] = ' ' )  Then
                                   Delete ( S, 1, 1 ) ;

                                 S := S + chr(240)   ;

                                 Line ( Cx, SwIko.y2+1,
                                        Cx, SwIko.y2+1 + DyScale3  ) ;

                                 OutTextXY ( Cx, SwIko.y2+20, S ) ;

                               End ;

                         End ;
                   {
                   For  I := -5  To  5  Do
                    If ( I <> 0 ) Then
                     Begin


                       RaPl := StepScale * Ind + StepScale / 6.0 * I ;

                       Cx   := Round  ( Xc - RaPl * Mx ) ;

                       If (     ( Cx <= SwIko.x2 )
                            And ( Cx >= SwIko.x1 )  )  Then
                         Begin
                           If ( Abs ( I ) = 3 )
                             Then Line ( Cx, SwIko.y2+1, Cx, SwIko.y2+1 + DyScale2 )
                             Else Line ( Cx, SwIko.y2+1, Cx, SwIko.y2+1 + DyScale  );
                         End ;

                         }

                     End ;

                 End ;

             End  { ScaleHour }
           Else
             Begin

               RaPl := StepScale * Ind ;

               Cx   := Round  ( Xc -  RaPl * Mx ) ;

               If (     ( Cx <= SwIko.x2 )
                    And ( Cx >= SwIko.x1 )  )  Then
                 Begin

                   RaPl := RaC * Rg / 15.0 + StepScale * Ind ;

                   If ( RaPl < -0.001 ) Then
                     RaPl := RaPl + 24.0 ;

                   If ( RaPl >= 24 ) Then
                     RaPl := RaPl - 24.0 ;


                   RaH := Trunc ( RaPl ) ;
                   RaM := Round ( Frac ( RaPl ) * C600 ) ;
                   If ( RaM = 60 )  Then
                     Begin
                       RaM := 0 ;
                       Inc ( RaH ) ;
                       RaH := RaH Mod 24 ;
                     End ;


                   If (     ( Ind = 0 )
                        And ( Not B_H )  )
                     Then
                       Begin

                         Str ( RaH : 2, S ) ;
                         Str ( RaM : 2, t ) ;

                         If ( S [ 1 ] = ' ' )  Then
                           Delete ( S, 1, 1 ) ;

                         If ( S = '-0' )  Then
                           S := '0' ;

                         S := S + chr ( 240 )
                                + ' '
                                + t
                                + chr ( 241 ) ;

                         Line ( Cx, SwIko.y2+1, Cx, SwIko.y2+1 + DyScale3 ) ;
                         OutTextXY ( Cx, SwIko.y2+20, S ) ;


                       End
                     Else
                       Begin

                         If ( RaM > 0 )
                           Then  Str ( RaM : 2, S )
                           Else  Str ( RaH : 2, S ) ;

                         If ( S [ 1 ] = ' ' )  Then
                           Delete ( S, 1, 1 ) ;

                         If ( S = '-0' )  Then
                           S := '0' ;

                         If ( RaM = 0 )
                           Then
                             Begin

                               S   := S + chr(240) ;

                               Line ( Cx, SwIko.y2+1, Cx, SwIko.y2+1 + DyScale3 ) ;
                               OutTextXY ( Cx, SwIko.y2+20, S ) ;

                             End
                           Else
                             Begin

                               S := S + chr(241)   ;

                               If ( RaM = 30 )
                                 Then
                                   Begin
                                     Line ( Cx, SwIko.y2+1,
                                            Cx, SwIko.y2+1 + DyScale2 ) ;
                                     OutTextXY ( Cx, SwIko.y2+16, S ) ;
                                   End
                                 Else
                                   Begin
                                     Line ( Cx, SwIko.y2+1,
                                            Cx, SwIko.y2+1 + DyScale  ) ;
                                     OutTextXY ( Cx, SwIko.y2+13, S ) ;
                                   End ;
                             End ;

                       End ;




                   For I := -4  To  4  Do
                    If ( I <> 0 )  Then
                     Begin

                       RaPl := RaC * Rg / 15.0 + StepScale * Ind
                                               + StepScale / 5.0 * I ;

                       If ( RaPl < -0.001 ) Then
                         RaPl := RaPl + 24.0 ;

                       If ( RaPl >= 24 ) Then
                         RaPl := RaPl - 24.0 ;

                       RaH  := Trunc ( RaPl ) ;
                       RaM  := Round ( Frac ( RaPl ) * C600 ) ;
                       If ( RaM = 60 )  Then
                         Begin
                           RaM := 0 ;
                           Inc ( RaH ) ;
                           RaH := RaH Mod 24 ;
                         End ;



                       RaPl := StepScale * Ind + StepScale / 5.0 * I ;
                       Cx   := Round  ( Xc - RaPl * Mx ) ;

                       If (     ( Cx <= SwIko.x2 )
                            And ( Cx >= SwIko.x1 )  )  Then
                         Begin
                           If ( NScaleMin < 5 )
                             Then
                               Begin

                                 If ( RaM > 0 )
                                   Then  Str ( RaM : 2, S )
                                   Else  Str ( RaH : 2, S ) ;

                                 If ( S [ 1 ] = ' ' )  Then
                                   Delete ( S, 1, 1 ) ;

                                 If ( S = '-0' )  Then
                                   S := '0' ;


                                 If ( RaM > 0 )
                                   Then S := S + chr(241)
                                   Else S := S + chr(240) ;

                                 If ( RaM = 30 )
                                   Then
                                     Begin
                                       Line ( Cx, SwIko.y2+1,
                                              Cx, SwIko.y2+1 + DyScale2 ) ;
                                       OutTextXY ( Cx, SwIko.y2+16, S ) ;
                                     End
                                   Else
                                     Begin
                                       If ( RaM = 0 )
                                         Then
                                           Begin
                                             Line ( Cx, SwIko.y2+1,
                                                    Cx, SwIko.y2+1 + DyScale3 ) ;
                                             OutTextXY ( Cx, SwIko.y2+20, S ) ;
                                           End
                                         Else
                                           Begin
                                             Line ( Cx, SwIko.y2+1,
                                                    Cx, SwIko.y2+1 + DyScale ) ;
                                             OutTextXY ( Cx, SwIko.y2+12, S ) ;
                                           End ;
                                     End ;

                               End
                             Else
                                  Line ( Cx, SwIko.y2+1,
                                         Cx, SwIko.y2+1 + DyScale ) ;
                         End ;


                     End ; { I }


                 End ; { If Cx, Cy }

             End ; { Else }

       End ; { Ind }








         { Scale Decl }
         { ƒƒƒƒƒƒƒƒƒƒ }


     If ( DDeclCGr > 19.999 )
       Then
         Begin

           ScaleHour := True                       ;
           IndMax    := Round ( DDeclCGr / D10 )  ;
           StepScale := D10                       ;

         End
       Else
         Begin

           ScaleHour := False               ;
           IndMax    := Round ( DDeclCGr )  ;
           StepScale := C10                 ;

         End ;



     For Ind := - IndMax To IndMax Do
       Begin

         RaPl := StepScale * Ind ;

         Cy   := Round  ( Yc -  RaPl * My ) ;

         If (     ( Cy <= SwIko.y2 )
              And ( Cy >= SwIko.y1 )  )  Then
           Begin

               Line ( SwIko.x1-DxScale3, Cy,  SwIko.x1-1, Cy  ) ;

               RaPl := DeclC * Rg + StepScale * Ind ;

               Str ( Abs ( RaPl ) : 2 : 0, S ) ;

               If (     ( S [ 1 ]             = ' ' )
                    And ( Round ( StepScale ) = 1   )   )  Then
                 Delete ( S, 1, 1 ) ;

               S := ' ' + S  ;

               If ( Abs ( RaPl ) > 0.5 ) Then
                 Begin
                   If ( RaPl > 0.0 )
                     Then S [ 1 ] := '+'
                     Else S [ 1 ] := '-' ;
                 End ;

               S := S + chr ( 243 ) ;

               SetTextJustify ( RightText, CenterText );
               OutTextXY ( SwIko.x1-DxScale3-2, Cy, S ) ;


               If ( Round ( DDeclCGr ) <= 4.99 )  Then
                 Begin

                   For I := -5  To  5  Do
                    If ( I <> 0 )  Then
                     Begin

                       RaPl := StepScale * Ind + StepScale / 6.0 * I ;

                       Cy   := Round  ( Yc -  RaPl * My ) ;

                       If (     ( Cy <= SwIko.y2 )
                            And ( Cy >= SwIko.y1 )  )  Then
                         Begin

                           If ( Abs ( I ) <> 3 )
                             Then Line ( SwIko.x1-DxScale  , Cy, SwIko.x1-1, Cy )
                             Else Line ( SwIko.x1-DxScale2 , Cy, SwIko.x1-1, Cy ) ;

                         End ;


                     End ;


                 End ;


           End ;

       End ;


 SetLineStyle ( SolidLn, 0, NormWidth ) ;




 Case NPl Of

    1 : Begin
          S := 'å•‡™„‡®©'  ;
        End ;

    2 : Begin
          S := 'Ç•≠•‡†'  ;
        End ;

    3 : Begin
          S := 'á•¨´Ô'  ;
        End ;

    4 : Begin
          S := 'å†‡·'  ;
        End ;

    5 : Begin
          S := 'ûØ®‚•‡'  ;
        End ;

    6 : Begin
          S := 'ë†‚„‡≠'  ;
        End ;

    7 : Begin
          S := 'ì‡†≠'  ;
        End ;

    8 : Begin
          S := 'ç•Ø‚„≠'  ;
        End ;

    9 : Begin
          S := 'è´„‚Æ≠'  ;
        End ;

   10 : Begin
          S := 'ã„≠†'  ;
        End ;

   11 : Begin
          S := 'ëÆ´≠Ê•'  ;
        End ;

   Else   S := '' ;

 End ;


 Str ( Param.TimeYear : 4, t ) ;
 S := S + '  ' + t ;


 SetTextJustify ( CenterText, CenterText );
 OutTextXY ( ( SwIko.x1+SwIko.x2 ) Div 2 , SwIko.y2+80, S ) ;



       { Scale Mv }
       { ƒƒƒƒƒƒƒƒ }

      BaseCx := 90 ;

      Mv := MvMax - ( 7 - 1 ) ;

      If ( Round ( Mv ) = - 2 )  Then
        BaseCx := 90 + 27 ;

      If ( Round ( Mv ) = - 3 )  Then
        BaseCx := 90 + 54 ;

      If ( Round ( Mv ) = - 4 )  Then
        BaseCx := 90 + 81 ;


      Cx := SwIko.x1 + BaseCx + 10  ;
      Cy := SwIko.y2 +  50  ;
      OutTextXY ( Cx, Cy, '  Mv:' ) ;

      Prima := True ;
      Ind   := 7    ;

      For I := 7 DownTo 1 Do
       If ( Round ( MvMax - ( I - 1 ) ) >= -1 )  Then
        Begin


          Mv := MvMax - ( I - 1 ) ;
          Str ( Round ( Mv ) : 3, S ) ;

          If  Prima  Then
            Begin
              Str ( Round ( Mv ) : 2, S ) ;
              If  ( Round ( Mv ) > 0 )  Then
                Begin
                  Str ( Mv+0.5 : 3:1, S ) ;
                  S := Char(60) + S ;
                End ;
              Prima := False ;
            End ;


          SRadii := 1 + Round ( MvMax - Mv ) ;
          If ( SRadii > 7 )  Then
          SRadii := 7 ;


          Cx := SwIko.x1 + BaseCx + 50 + 54 * ( 7 - Ind ) ;
          Cy := SwIko.y2 +  50                            ;

          SColor := Black ;

          Case SRadii Of

                         1:  Begin

                              PutPixel ( Cx  , Cy   , SColor ) ;
                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;

                             End ;


                         2:  Begin

                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx  , Cy-1, Cx  , Cy+1 ) ;

                             End ;


                         3: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                            End ;

                         4: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;
                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;

                            End ;

                         5: Begin

                              Line ( Cx-1, Cy-1, Cx+1, Cy-1 ) ;
                              Line ( Cx-1, Cy  , Cx+1, Cy   ) ;
                              Line ( Cx-1, Cy+1, Cx+1, Cy+1 ) ;

                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;

                              Line ( Cx-2, Cy-1, Cx+2, Cy-1 ) ;
                              Line ( Cx-2, Cy+1, Cx+2, Cy+1 ) ;

                              Line ( Cx-1, Cy-2, Cx+1, Cy-2 ) ;
                              Line ( Cx-1, Cy+2, Cx+1, Cy+2 ) ;

                            End ;

                         6: Begin

                              Dec ( Cy ) ;

                              Line ( Cx-2, Cy-1, Cx+2, Cy-1 ) ;
                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx-2, Cy+1, Cx+2, Cy+1 ) ;

                              Line ( Cx-2, Cy  , Cx+2, Cy   ) ;
                              Line ( Cx  , Cy-2, Cx  , Cy+2 ) ;

                              Line ( Cx-2, Cy-2, Cx+2, Cy-2 ) ;
                              Line ( Cx-2, Cy+2, Cx+2, Cy+2 ) ;

                              Line ( Cx-2, Cy-2, Cx+2, Cy-2 ) ;
                              Line ( Cx-2, Cy+2, Cx+2, Cy+2 ) ;

                              Line ( Cx-1, Cy-3, Cx+1, Cy-3 ) ;
                              Line ( Cx-1, Cy+3, Cx+1, Cy+3 ) ;

                              Line ( Cx-3, Cy-1, Cx-3, Cy+1 ) ;
                              Line ( Cx+3, Cy-1, Cx+3, Cy+1 ) ;

                            End ;

                         7: Begin

                              Dec ( Cy ) ;
                              SetFillStyle ( SolidFill, SColor ) ;
                              FillEllipse ( Cx, Cy, 4, 4 ) ;

                            End ;

          End ; { Case }


          Cx := SwIko.x1 + BaseCx + 57 + 54 * ( 7 - Ind ) ;
          Cy := SwIko.y2 +  50                            ;


          While (     ( Length ( S ) >  0 )
                  And ( S [ 1 ]      = ' ')  )   Do
            Delete ( S, 1, 1 ) ;


          SetTextJustify ( LeftText, CenterText );
          OutTextXY ( Cx, Cy, S ) ;


          Dec ( Ind ) ;

        End ;







 If ( B_Ppm )  Then
   PpmFld ;


 If ( B_Bs )  Then
   BsFld ;



 For I := 1 To 16 Do
   Begin
     CxOld [ I ] := 32123 ;
     CyOld [ I ] := 32123 ;
   End ;




 StepTime      := C10 ;
 {
 JD8 ( Param.TimeYear, 12, 21, JDate0   ) ;
 }

 JD8 ( Param.TimeYear-1, 12, 31, JDate0   ) ;
 JD8 ( Param.TimeYear+1,  1,  2, JDateEnd ) ;
 If (     ( FileOut  )
      And ( NPl < 10 ) )  Then
   JDateEnd := JDateEnd + 8 * Round ( StepTime ) ;

 JDate := JDate0 - C10 ;
 {
 JdFile   := JDate0 - StepWriteFile  ;
 }
 Str ( Param.TimeYear Mod 100 : 2, t ) ;

 If ( t [ 1 ] = ' ' )  Then
      t [ 1 ] := '0';


 S := PlanetName [ NPl ] ;
 While (     ( Length ( S )       >  0 )
         And ( S [ Length ( S ) ] = ' ')  )   Do
   Delete ( S, Length ( S ), 1 ) ;


 If ( NPl = 11 ) And ( B_Sumerki )  Then
   Begin
     Str ( FiPlanDrav : 3:0, S1 ) ;
     S := S + S1 ;
   End ;


 S := S + '.' + t ;

 Assign  ( PlanOut, S ) ;


 NPl := Round ( Abs ( Param.ISat ) ) ;

 If ( NPl < 10 )
   Then
     Begin
       StepWriteFile := 8.0  ;
     End
   Else
     Begin
       StepWriteFile := C10   ;
     End ;


 If ( FileOut )  Then
   Begin

     ReWrite ( PlanOut ) ;



     Case NPl Of

       1 : Begin
             S := 'å•‡™„‡®©'  ;
           End ;

       2 : Begin
             S := 'Ç•≠•‡†'  ;
           End ;

       3 : Begin
             S := 'á•¨´Ô'  ;
           End ;

       4 : Begin
             S := 'å†‡·'  ;
           End ;

       5 : Begin
             S := 'ûØ®‚•‡'  ;
           End ;

       6 : Begin
             S := 'ë†‚„‡≠'  ;
           End ;

       7 : Begin
            S := 'ì‡†≠'  ;
           End ;

       8 : Begin
             S := 'ç•Ø‚„≠'  ;
           End ;

       9 : Begin
             S := 'è´„‚Æ≠'  ;
           End ;

      10 : Begin
             S := 'ã„≠†'  ;
           End ;

      11 : Begin
             S := 'ëÆ´≠Ê•'  ;
           End ;

         Else   S := '' ;

     End ;

     Writeln ( PlanOut ) ;
     Writeln ( PlanOut, S : 65 ) ;
     Writeln ( PlanOut ) ;


     Str ( FiPlanDrav : 3:0, t ) ;
     {
     t [ 1 ] := '+' ;
     }
     Writeln ( PlanOut ) ;
     Writeln ( PlanOut, '  ò®‡Æ‚† ', t, '¯' ) ;
     Writeln ( PlanOut ) ;
     If ( NPl < 10 )  Then
       Begin
             Write   ( PlanOut,
'          √ƒƒƒƒ  ÑÆ´£Æ‚† = 0¯ ƒƒƒƒ¥  √ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  0 Á. Ç·•¨. Çp.  ƒƒƒƒƒƒƒƒƒƒƒƒƒ¥' ) ;
             WriteLn ( PlanOut,
'√ƒƒ ÑÆ´£Æ‚† = 0¯ ƒƒ¥√ƒ  0 Á. Ç·. Çp. ƒ¥ ' ) ;
             WriteLn ( PlanOut);
         Write   ( PlanOut,
'  Ñ†‚†     ÇÆ·Â.  Ç.ä.   á†Â.   ÒÄ    èp.ÇÆ·Â.    ë™´.  É•ÆÊ.ê.   Ñ®†¨.');
{
  ü≠¢.  1   6 38  10 28  14 19   52    17 10.8   -20 24   0.899    7.32
}
         WriteLn ( PlanOut,
'  î†ß†  á¢.Ç. Ç®§.H. Ç®§.ä. à≠.Ç. ÑÆ´£.  ò®p. É•´.ê.' ) ;
{
   0.48 - 0.0   6 38  7 42   1  4  166.3   6.2  0.369
}


             Writeln ( PlanOut          ) ;
           { Year }
           { ƒƒƒƒ }

     Str ( Param.TimeYear  : 6, S ) ;
     Write ( PlanOut, S ) ;

             Write   ( PlanOut,
      '     Á  ¨   Á  ¨   Á  ¨    ¯    Á   ¨      ¯  `    Ä.Ö.     "    ' ) ;
{
  ü≠¢.  1   6 38  10 28  14 19   52    17 10.8   -20 24   0.899    7.32
}
             Writeln ( PlanOut,
'               Á  ¨  Á  ¨   Á  ¨    ¯     ¯    Ä.Ö.  ' ) ;
{
   0.48 - 0.0   6 38  7 42   1  4  166.3   6.2  0.369
}



       End ;

     Writeln ( PlanOut ) ;

   End ;



 With SwIko Do
   SetViewPort ( x1, y1, x2, y2, clipon ) ;


 BVid := True ;

 While  Not  EndProc Do
   Begin


     PlPro ( False,
             JDate, JDate, 3,
             0.0, 0.0, 0.0,
             11, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );


     X :=   RectCoordPl [ 11, 1 ] ;
     Y :=   RectCoordPl [ 11, 3 ] * SEps2000
          + RectCoordPl [ 11, 2 ] * CEps2000 ;

     LSun := ATan2 ( Y, X ) ;

     PlPro ( False,
             JDate, JDate, 3,
             0.0, 0.0, 0.0,
             NPl, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );

     RaS   := RezPl [ NPl, 1 ]                 ;
     RaS   := RaS - Trunc ( RaS / Pi2 ) * Pi2  ;
     DeclS := RezPl [ NPl, 2 ]                 ;

     X :=   RectCoordPl [ NPl, 1 ] ;
     Y :=   RectCoordPl [ NPl, 3 ] * SEps2000
          + RectCoordPl [ NPl, 2 ] * CEps2000 ;

     LPlan := ATan2 ( Y, X ) ;

     RoPlanSun :=  (   RectCoordPl [ NPl, 1 ] * RectCoordPl [ 11, 1 ]
                     + RectCoordPl [ NPl, 2 ] * RectCoordPl [ 11, 2 ]
                     + RectCoordPl [ NPl, 3 ] * RectCoordPl [ 11, 3 ] ) /
            ( Sqrt (   Sqr ( RectCoordPl [ NPl, 1 ] )
                     + Sqr ( RectCoordPl [ NPl, 2 ] )
                     + Sqr ( RectCoordPl [ NPl, 3 ] )  )  *
              Sqrt (   Sqr ( RectCoordPl [ 11 , 1 ] )
                     + Sqr ( RectCoordPl [ 11 , 2 ] )
                     + Sqr ( RectCoordPl [ 11 , 3 ] )  )  ) ;

     RoPlanSun := ArcTan ( Sqrt ( C10 - Sqr ( RoPlanSun ) ) / RoPlanSun ) ;


           { Date }
           { ƒƒƒƒ }

     DayJd ( JDate, YearDate, MonthDate, DayDate ) ;

     S := '' ;
     Str ( YearDate  : 5, t ) ;
     S := S + t ;

     Case  MonthDate  Of

        1 : t := ' ü≠¢.' ;
        2 : t := ' î•¢.' ;
        3 : t := ' å†‡‚' ;
        4 : t := ' ÄØ‡.' ;
        5 : t := '  å†©' ;
        6 : t := ' àÓ≠Ï' ;
        7 : t := ' àÓ´Ï' ;
        8 : t := ' Ä¢£.' ;
        9 : t := ' ë•≠.' ;
       10 : t := ' é™‚.' ;
       11 : t := 'HÆÔ°.' ;
       12 : t := ' Ñ•™.' ;

     End ;




     If (     ( Round ( DayDate )  =  1      )
          And ( MonthDate          =  1      )
          And (  JdFile            < -1.0e10 )  )  Then
       JdFile := JDate - StepWriteFile ;

     {
     If (     ( JdFile > -1.0e10                         )
          And ( Round ( Jdate - JdFile ) = StepWriteFile )  )  Then
     }
     If ( JdFile > -1.0e10 )  Then
       Begin

         JdFile := JDate ;

         If ( FileOut )  Then
           PlanetFile ( JDate ) ;

       End ;



     If (     ( NPl <>  3 )
          And ( NPl  >  0 )
          And ( NPl <= 15 )  )   Then
       Begin

         RaS   := RezPl [ NPl, 1 ] ;
         DeclS := RezPl [ NPl, 2 ] ;

         RR := RaS - RaC ;
         If ( Abs ( RR ) > Pi )  Then
           Begin
             If ( RR > 0.0 )
               Then  RR := RaS - ( RaC + Pi2 )
               Else  RR := RaS - ( RaC - Pi2 ) ;
           End ;


         Cx := Dx - Round ( ( ( RR            ) * Rg / 15.0 ) * Mx ) ;
         Cy := Dy - Round ( ( ( DeclS - DeclC ) * Rg        ) * My ) ;

         {
         SRadii := 1 + Round ( ( ( MvMax - RezPl [ NPl, 3 ] ) ) / C20 ) ;
         If ( SRadii < 1 )  Then
           SRadii := 1 ;
           }
         SRadii := 1 ;


         If ( CxOld [ NPl ] = 32123 )
           Then
             PutPixel ( Cx, Cy, Black )
           Else
             Begin
               If ( Abs ( CxOld [ NPl ] - ( Cx ) ) <  Dx  )  Then
                 Begin

                   If ( BVid )
                     Then
                       Begin
                         {
                         SetLineStyle ( SolidLn, 0, ThickWidth ) ;
                         }
                         Line ( CxOld [ NPl ], CyOld [ NPl ], Cx, Cy ) ;
                         {
                         SetLineStyle ( SolidLn, 0, NormWidth ) ;
                         }
                       End
                     Else
                       Begin
                         Line ( CxOld [ NPl ], CyOld [ NPl ], Cx, Cy ) ;
                       End ;

                 End ;

               CxOld [ NPl ] := Cx ;
               CyOld [ NPl ] := Cy ;

             End ;


         CxOld [ NPl ] := Cx ;
         CyOld [ NPl ] := Cy ;

         If  (    ( Round ( DayDate ) = 1 )
               Or (     ( MonthDateOld <> 0         )
                    And ( MonthDateOld <> MonthDate )  )  )
                                                             Then
           Begin

             Line ( Cx, Cy, Cx, Cy-15 ) ;

             If ( YearDate = Param.TimeYear )   Then
               Begin

                 Str ( MonthDate : 2 , S ) ;

                 If ( S [ 1 ] = ' ' )  Then
                   Delete ( S, 1, 1 ) ;

                 SetTextJustify ( CenterText, CenterText );
                 OutTextXY ( Cx, Cy-20, S ) ;

               End ;

           End ;

       End ; { NPl }



     If ( KeyPressed )  Then
       Begin  { ÇÎ°®p†•¨ ÆØ‚®Á•·™®© Ê•≠‚p }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


         EndProc := False   ;
         chh     := GetKey  ;


         Quit    := False ;
         Sn      := '' ;


         Repeat
         Until KeyPressed ;

         chh    := GetKey ;

         Case chh Of

           ESCKey   : Begin
                        Quit    := True  ;
                        EndProc := True  ;
                      End ;

         End;



       End    { ÇÎ°®p†•¨ ÆØ‚®Á•·™®© Ê•≠‚p }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
      Else

       Begin


              { For Sumerki }
            If ( Not B_Sumerki )
              Then
                Begin

                  If (      ( Not FileOut      )
                       Or   ( JdFile < -1.0e10 ) )
                    Then NDate := NDate  + Round ( StepTime )
                    Else NDate := NDate  + 8 * Round ( StepTime ) ;
                End
              Else
                Begin
                  NDate := NDate  + Round ( StepTime ) ;
                End ;


            MonthDateOld := MonthDate          ;
            JDate        := JDate0 + NDate - 1 ;
            {
            JDATE := JDATE + STEPTime ;
            }
            If ( JDate > JDateEnd )  Then
              EndProc := True ;

       End ;

   End ;  { While Not EndProc }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }



  If ( FileOut )  Then
    Close ( PlanOut ) ;


  Sound ( 500 ) ;
  Delay ( 300 ) ;
  NoSound ;



  Repeat
  Until KeyPressed ;
  chh    := GetKey ;



  With pvp Do
    SetViewPort ( x1, y1, x2, y2, clip );

  SetColor   ( Col   ) ;
  SetBkColor ( Black ) ;

  With Fs Do
    SetFillStyle(Pattern, Color);
  SetWriteMode ( NormalPut );
  ClearViewPort;


  FileMode := 2 ;


End;




End.
