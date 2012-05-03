
{$O+,F+}

Unit PPLPRO;
Interface

Uses

   PVar, PVarMenu ;



  Procedure  PLPRO (     BEfem        : Boolean     ;
                         JD , JDREZ   : Double      ;
                         NPl0         : Integer     ;
                         X0, Y0, Z0   : Double      ;
                         NPL1         : Integer     ;
                     Var RezPl        : REZARRAY    ;
                     Var RectCoordPl  : PlCoordType ;
                     Var PhaseMoon    : Double      ;
                     Var PhaseEarth   : Double        ) ;


IMPLEMENTATION

Uses

   CRT,
   PJD8,
   PATan2,
   PPrenXYZ,
   PMERK,
   PVENERA,
   PSol,
   PMARS,
   PJUP,
   PSATJUP,
   PSAT,
   PURAN,
   PNEPT,
   PPLU,
   PMONDIA,
   PNutNew,
   PDE200  ;


  Procedure  PLPRO (     BEfem        : Boolean     ;
                         JD , JDREZ   : Double      ;
                         NPl0         : Integer     ;
                         X0, Y0, Z0   : Double      ;
                         NPL1         : Integer     ;
                     Var RezPl        : REZARRAY    ;
                     Var RectCoordPl  : PlCoordType ;
                     Var PhaseMoon    : Double      ;
                     Var PhaseEarth   : Double        ) ;


{*

      INPUT :    BEfem    Момент в эфемеpидном вpемени
                    JD    МОМЕНТ ВРЕМЕНИ
	     	 JDREZ    ЭПОХА РЕЗУЛЬТАТА
		 RezPl    МАССИВ ВЫЧИСЛЕННЫХ КООРАИНАТ
                  NOL0    НОМЕР ПЛАНЕТЫ С НАБЛЮДАТЕЛЕМ
                  X0,
                  Y0,
                  Z0      Планетоцентpические кооpдинаты наблюдателя в АЕ
                  NPL1    НОМЕР ВЫЧИСЛЯЕМОЙ ПЛАНЕТЫ ( 0 - ВСЕ ПЛАНЕТЫ )

	OUTPUT:   GEOCENTRIC  EQUATORIAL COORDINATES And
	──────	  VISUAL MAGNITUDES Of PLANETS , DIFFERENTIAL
		  EQUATORIAL COORDINATES And VISUAL MAGNITUDES
		  Of JUPITER SATELITS,  MOON PHASES (in Grad).


*}



  Const


	Diam : Array [ 1..15 ] Of Double = ( 3.36,  8.34,  8.79418,
					      4.68, 98.41, 83.28,
                                             32.45, 30.78,  9.67 ,
                                              2.3963, 959.63,
                                              1.627, 2.041, 3.585, 3.254 ) ;

	RMSATJ	: Array [ 1..4 ] Of Double = ( 5.02 , 5.29 , 4.61 , 5.65 ) ;

        DTE : Array [ 0 .. 10 ] Of Single =
        ( -2.7, 10.5, 21.2, 24.0, 24.3, 29.2, 33.2, 40.2, 50.5, 57.2, 64.0 ) ;



  Var

        PrNut,
        CalcPlDE200                             : Boolean ;

	XSJ, YSJ, DRSJ				: CoordArray  ;

        X,  Y,  Z,
        Vx, Vy, Vz,
        RM, RL, RB, R                           : Array [ 1..15 ] Of Double ;

        XPl    , YPl    , ZPl
                                                : Array [ 1..15 ] Of Double ;

        JAB, JAbMax                      : Word ;

        IPlBeg, IPlEnd,
	IY, IM, NJDTEK, NJTEK,
        II, HH, MM,
	NPl, NPLM, IFF, MONF	         : LongInt ;


	JdPl, Tau,
	PI2, DAY, PAR,
	XEartchBaric   , YEartchBaric   , ZEartchBaric   ,
	XSunBaricT     , YSunBaricT     , ZSunBaricT     ,
	XSunBaricTmTau , YSunBaricTmTau , ZSunBaricTmTau ,
	XSunGeocN, YSunGeocN, ZSunGeocN,
	RSunGeoc, RLSun, RBSun, RSun,
        VxEartch, VyEartch, VzEartch,
        XS , YS , ZS , RS ,
        X00, Y00, Z00, R00,
        XPl0, YPl0, ZPl0,
        Xp  , Yp  , Zp  ,
	XpN , YpN , ZpN ,
	XpNn, YpNn, ZpNn,
        Xq  , Yq  , Zq  ,
        XeGelioc  , YeGelioc  , ZeGelioc  ,
        XeGeliocN , YeGeliocN , ZeGeliocN ,
        Xqn , Yqn , Zqn ,
        XS0, YS0, ZS0, RS0,
        XM,  YM,  ZM,
        VXM, VYM, VZM,
        RPlSun,
        Mc, C, Au,
	XX, YY, ZZ, RLDL, RDL, DRLS,
	UGOL, SU, CU, XSAT, YSAT,
	CA, SA, TRA, SD, CD,
	Ra, Decl, SP, CP, PP, SF, CF, SI,
	XSP , YSP , ZSP , RSP ,
	XSPN, YSPN, ZSPN,
        RLPL, RP, RPE,
        R0PL, Phase,
        E, P, Q,
        VxB, VyB, VzB,
        JDE,
        DrSatJup, DRaSatJup, DDeclSatJup,
        DxSatJup, DySatJup, DzSatJup,
        SRaJup, CRaJup, SDeclJup, CDeclJup,
        XJup, YJup, ZJup, RJup,
        RRab,
        Cc, Ff, Ss,
        T , Eps, L,
        OM, L1, F, D,
        DPsi, DEps,
        SEpsM, CEpsM,
        SEpsT, CEpsT,
        SDPsi, CDPsi                             : Double ;


   Procedure MAGN (     N                        : Integer     ;
		        RP, RPE, RE, JD, X, Y, Z : Double        ;
		    Var RM                       : Double      ) ;

{
		вычисление звездных величин планет
		──────────────────────────────────


		w h o d :
		───────

	N     -	номеp pланеты
	RP    -	гелиоцентpическое pасстояние планеты
	RPE   -	pасстояние планета - телескоп
	RE    -	гелиоцентpическое pасстояние телескопа
	JD    -	юлианская дата
	X,Y,Z - пpямоугольные геоцентpические к-ты планеты


		ы ы х о д :
		─────────

	RM   -	звездная величина планеты
}


 Type AR = Array [ 1 .. 15 ] Of Double;

 Var

	F , R1, R2, R3, SA, CA, SD, CD, RN 	: Double ;


 Const

	RM0 : AR = ( -0.38, -4.41, -3.9, -1.51, -9.40, -8.88, -7.19, -6.87, -1.0, 0.23, -26.7, -1.9, -1.5, -2.2, -1.2  );
        CF1 : AR = (  0.0380, 0.01314,   0.0,  0.01486, 0.0, 0.0, 0.0, 0.0, 0.0, 0.026, 0.0, 0.04, 0.03, 0.03, 0.07 );
	AF1 : AR = (  0.0,               0.0,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF2 : AR = ( -0.000273,          0.0,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	AF2 : AR = (  0.0,               0.0,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF3 : AR = (  0.000002, 0.0000004351,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
        {
	RM0 : AR = ( 1.16, -4.0 ,-3.9, -1.3, -8.93, -8.68, -6.85, -7.05, -C10, 0.23, -26.7, -1.9, -1.5, -2.2, -1.2  );
	CF1 : AR = ( 0.02838, 0.01322, 0.014, 0.01486, 0.0, 0.0, 0.0, 0.0, 0.0, 0.026, 0.0, 0.04, 0.03, 0.03, 0.07 );
	AF1 : AR = ( -50.0,             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF2 : AR = ( 0.0001023,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	AF2 : AR = ( -50.0,             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF3 : AR = ( 0.0, 0.0000004247, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
        }
 Begin

        If ( N = 11 )
          Then

            Begin

	      RM := RM0 [ N ] + 5.0 * Ln ( RPE ) / 2.30259;

            End
          Else
            Begin

              { зависимость от pасстояния }
	      { ───────────────────────── }

	      RM := RM0 [ N ] + 5.0 * LN ( RP * RPE ) / 2.30259;



	      { зависимость от фазы }
	      { ─────────────────── }

              F := Phase * Rg ;

	      RM := RM + CF1 [ N ] * ( F + AF1 [ N ] );
	      RM := RM + CF2 [ N ] * ( F + AF2 [ N ] ) * ( F + AF2 [ N ] );
	      RM := RM + CF3 [ N ] *   F * F * F;

	      If ( N = 6 )  Then
	        Begin

                  { эффект кольца Сатуpна }
                  { ───────────────────── }

                  R1 := ( JD - 2433282.42 ) / 36524.22;
		  RN := 2.241289 + 0.073827 * R1
                                 + 0.004086 * R1 * R1
                                 + 0.000185 * R1 * R1 * R1  ;

		  R2 := 0.116756 - 0.007613 * R1 + 0.000224 * R1 * R1;
		  R3 := COS ( RN );

		  SD := Z / RPE;
		  CD := SQRT ( C10 - SD * SD );
		  CA := RPE * CD;
		  SA := Y / CA;
		  CA := X / CA;

		  R3 := - COS ( R2 ) * SD
                        + SIN ( R2 ) * CD *
                              ( SA * R3 - CA * SQRT ( C10 - R3 * R3 ));

                  RM := RM - 2.60  * ABS ( R3 )
                           + 1.25  * R3 * R3
                           + 0.044 * ABS ( F )  ;

	      End;

          End;

 End;




  Begin


      au  := 149597870660.0 ;
      c   := 299792458.0 * C864000 / au ;
      Mc  := 2 * 9.87e-9 ;



     JDE    := JD  ;

        { TDB }

     RRab := ( 357.528 + 35999.050 * ( Jd - 2451545.0 ) / 36525.0 ) * Gr ;
     RRab := 0.001658 * Sin ( RRab + 0.0167 * Sin ( RRab ) ) ;
     JdE  := JdE + RRab / 86400 ;



         { Пеpеход к пpиближенному эфемеpидному вpемени  }
         { ───────────────────────────────────────────── }
{
BEfem := True ;
}
     If ( Not BEfem )  Then
       Begin

         Tau := ( JD - 2415020.5 ) / 36525.0 ;

         If ( Tau < 0 ) Or ( Tau > 0.99 )
           Then
             Begin

               JDE := JD + ( 0.41 + 1.2053 * Tau +
                                    0.4992 * Tau * Tau ) / 1440.0 ;

               If ( Tau >= 1.0 ) Then
                 JdE := JD + ( 64.0 + ( Tau - 1.0 ) * 100.0 )  / C864000  ;

             End
           Else
             Begin

               Tau := Tau * C100 ;
               II  := Trunc ( Tau ) ;
               JDE := DTE [ II ] + ( Tau - II ) * ( DTE [ II + 1 ] - DTE [ II ] );

               If ( Param.TimeYear = 1997 )  Then
                 JdE := 63.184 ;

               If ( Param.TimeYear = 1998 )  Then
                 JdE := 63.184 ;

               If ( Param.TimeYear = 1999 )  Then
                 JdE := 63.184 ;

               Tau := Tau / C100 ;
               If ( Tau >= 1.0 ) Then
                 JdE := 64.0 + ( Tau - 1.0 ) * 100.0 ;

               JDE  := JD + JDE / C864000 ;

             End ;

       End ; { BEfem }


     {
     If ( BOlValMenu )  Then
       JdE := JdE + Frac ( JdE ) * JdE ;
     }


     If (     ( DE200Buf <> Nil         )
          And ( JDE > JdBegDE200 + 0.25 )
          And ( JDE < JdEndDE200        )  )
       Then
         CalcPlDE200 := True
       Else
         CalcPlDE200 := False ;



     PI2   := PI + PI ;
     NJTEK := 0 ;
     R0PL  := Sqrt (   Sqr ( X0 )
                     + Sqr ( Y0 )
                     + Sqr ( Z0 )  ) ;

     If ( NPL1 = 0 )
       Then
         Begin

           IPlBeg :=  1 ;
           IPlEnd := 11 ;

           Phase      := 0.0   ;
           PhaseMoon  := Phase ;
           PhaseEarth := Phase ;

         End
       Else
         Begin
           IPlBeg := NPL1;
           IPlEnd := NPL1;
         End;




        X00 := X0 ;
        Y00 := Y0 ;
        Z00 := Z0 ;


        If ( CalcPlDE200 )  Then
          Begin
            PreNXYZ ( JDRez, 2451545.0 , X00 , Y00 , Z00 ) ;
            Nutnew  ( JDRez     , -1   , X00 , Y00 , Z00 ) ;
          End ;

        R00 := Sqrt (   Sqr ( X00 )
                      + Sqr ( Y00 )
                      + Sqr ( Z00 )  ) ;




        { Кооpдинаты Земли относительно Баpицентpа }
        { ──────────────────────────────────────── }

        JdPl := JdE ;

        If ( CalcPlDE200 )
          Then
            DE200 ( 3, JdPl, JDRez, False, RSun, XS, YS, ZS,
                       VxEartch, VyEartch, VzEartch )
          Else
            Begin

              Sol  ( JdPl, JDREZ, RLSun, RBSun, RSun, XS, YS, ZS ) ;

              XS := - XS ;
              YS := - YS ;
              ZS := - ZS ;

              VxEartch := 0.0 ;
              VyEartch := 0.0 ;
              VzEartch := 0.0 ;

            End ;


        XEartchBaric := Xs ;
        YEartchBaric := Ys ;
        ZEartchBaric := Zs ;




        { Кооpдинаты Солнца относительно Баpицентpа }
        { ───────────────────────────────────────── }

        JdPl := JdE ;

        If ( CalcPlDE200 )
          Then
            DE200 ( 11, JdPl, JDRez, False, RSun,
                        XSunBaricT, YSunBaricT, ZSunBaricT,
                        VxS,       VyS,       VzS        )
          Else
            Begin

              XSunBaricT := 0.0 ;
              YSunBaricT := 0.0 ;
              ZSunBaricT := 0.0 ;

            End ;


        {
        P = Pl(t - tau) - E(t),
        }

	XX  := XSunBaricT - XEartchBaric ;
	YY  := YSunBaricT - YEartchBaric ;
	ZZ  := ZSunBaricT - ZEartchBaric ;

        P := Sqrt (   Sqr ( XX )
                    + Sqr ( YY )
                    + Sqr ( ZZ )  );

        Tau := ( P * 149597870.66 ) / ( 299792.458 * C864000 ) ;

        JdPl := JDE - Tau;



        If ( CalcPlDE200 )
          Then
            DE200 ( 11, JdPl, JDRez, False, RSun,
                        XSunBaricTmTau, YSunBaricTmTau, ZSunBaricTmTau,
                        VxS,       VyS,       VzS        )
          Else
            Begin

              XSunBaricTmTau := 0.0 ;
              YSunBaricTmTau := 0.0 ;
              ZSunBaricTmTau := 0.0 ;

            End ;



        {
        E = Eb ( t ) - Sunb ( t ),
        }
        XeGelioc := XEartchBaric - XSunBaricT ;
        YeGelioc := YEartchBaric - YSunBaricT ;
        ZeGelioc := ZEartchBaric - ZSunBaricT ;

        E  := Sqrt (   Sqr ( XeGelioc )
                     + Sqr ( YeGelioc )
                     + Sqr ( ZeGelioc ) ) ;

        XeGeliocN := XeGelioc / E ;
        YeGeliocN := YeGelioc / E ;
        ZeGeliocN := ZeGelioc / E ;




        XSunGeoc := XSunBaricTmTau - XEartchBaric ;
        YSunGeoc := YSunBaricTmTau - YEartchBaric ;
        ZSunGeoc := ZSunBaricTmTau - ZEartchBaric ;

        RSunGeoc  := Sqrt (   Sqr ( XSunGeoc )
                            + Sqr ( YSunGeoc )
                            + Sqr ( ZSunGeoc ) ) ;

        XSunGeocN := XSunGeoc / RSunGeoc ;
        YSunGeocN := YSunGeoc / RSunGeoc ;
        ZSunGeocN := ZSunGeoc / RSunGeoc ;




    { БаpиЦентpические Кооpдинаты Планет }
    { ────────────────────────────────── }


    For NPL := 1 To 11 Do
     If (    (     ( NPl >= IPlBeg )
               And ( NPl <= IPlEnd )
             )
          Or (     ( NPl  = NPl0   )
          Or ( NPl = 11            )
             )
        )  Then
      Begin  { NPl }

        PrNut  := False ;
        JdPl   :=   JdE ;
        JAbMax :=     2 ;

        If ( NPl = 3 )  Then
	  JAbMax := 1 ;


        For JAb := 1  To  JAbMax  Do
            Begin
               {
               If ( JAb = JAbMax )  Then
                 PrNut := True ;
               }


	       Case NPl Of

		1: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       MERK ( JdPl, JDREZ, RL[1], RB[1], R[1], X[1], Y[1], Z[1] );

		2: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       VENERA ( JdPl, JDREZ, RL[2], RB[2], R[2], X[2], Y[2], Z[2] );

		3: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                      Begin
                        Sol ( JdPl, JDREZ, RL[3], RB[3], R[3], X[3], Y[3], Z[3] );
                        X[3] := - X[3] ;
                        Y[3] := - Y[3] ;
                        Z[3] := - Z[3] ;
                      End ;

		4: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       MARS ( JdPl, JDREZ, RL[4], RB[4], R[4], X[4], Y[4], Z[4] );

		5: Begin

                     If ( CalcPlDE200 )
                       Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                       Else
		         JUP ( JdPl, JDREZ, RL[5], RB[5], R[5], X[5], Y[5], Z[5] );

                     If ( JAB = JAbMax ) Then
                       SATJUP ( JdPl, XSJ, YSJ, DRSJ );

		   End;

		6: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       SAT ( JdPl, JDREZ, RL[6], RB[6], R[6], X[6], Y[6], Z[6] );

		7: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       URAN ( JdPl, JDREZ, RL[7], RB[7], R[7], X[7], Y[7], Z[7] );

		8: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       NEPT ( JdPl, JDREZ, RL[8], RB[8], R[8], X[8], Y[8], Z[8] );

                9: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut, R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       PLU ( JdPl, JDREZ, RL[9], RB[9], R[9], X[9], Y[9], Z[9] );

               10: Begin
                    If ( CalcPlDE200 )
                     Then
                       Begin

                         DE200 (   3, JdPl, JDRez, PrNut, R[10],
                                                     XM ,  YM , ZM,
                                                    VXM , VYM , VZM  ) ;

                         DE200 ( NPl, JdPl, JDRez, PrNut,  R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] ) ;
                         {
                         XM := XEartchBaric + X [ 10 ] ;
                         YM := YEartchBaric + Y [ 10 ] ;
                         ZM := ZEartchBaric + Z [ 10 ] ;
                         }

                         XM := XM + X [ 10 ] ;
                         YM := YM + Y [ 10 ] ;
                         ZM := ZM + Z [ 10 ] ;

                       End
                     Else
                       Begin
                         {
                         Sol    ( JdPl, JDREZ, RL[10], RB[10], R[10], XM  , YM  , ZM   ) ;
                         }
                         MONDIA ( JdPl, JDREZ, RL[10], RB[10], R[10], X[10], Y[10], Z[10] );

                         XM := XEartchBaric + X [ 10 ] ;
                         YM := YEartchBaric + Y [ 10 ] ;
                         ZM := ZEartchBaric + Z [ 10 ] ;

                       End ;


		     R[10] := Sqrt (   Sqr ( XM )
                                     + Sqr ( YM )
                                     + Sqr ( ZM )  ) ;

                     X [ 10 ] := XM ;
                     Y [ 10 ] := YM ;
                     Z [ 10 ] := ZM ;

                   End ;

               11: If ( CalcPlDE200 )
                     Then
                       DE200 ( NPl, JdPl, JDRez, PrNut,  R[NPl],
                               X  [NPl], Y  [NPl], Z  [NPl],
                               VX [NPl], VY [NPl], VZ [NPl] )
                     Else
                       Begin
                         X [11] := 0.0     ;
                         Y [11] := 0.0     ;
                         Z [11] := 0.0     ;
                         R [11] := 1.0E-10 ;
                       End ;

	       End ; { Case }



             If ( Not CalcPlDE200 )  Then
               Begin
                 VX [ NPl ] := 0.0 ;
                 VY [ NPl ] := 0.0 ;
                 VZ [ NPl ] := 0.0 ;
               End ;



             XPl [ NPl ] := X [ NPl ] ;
             YPl [ NPl ] := Y [ NPl ] ;
             ZPl [ NPl ] := Z [ NPl ] ;




             { Гелиоцентpические к-ты в момент T, J2000 }
             { ──────────────────────────────────────── }
             If (     ( JAb  =   1 )
                  And ( NPl <>  11 )
                  And ( NPl = NPl1 )  )  Then
               Begin

                 XPlGelioC [ NPl1 ] := XPl [ NPl ] - XSunBaricT ;
                 YPlGelioC [ NPl1 ] := YPl [ NPl ] - YSunBaricT ;
                 ZPlGelioC [ NPl1 ] := ZPl [ NPl ] - ZSunBaricT ;

               End ;


             If (     (    JAb = 1 )
                  And ( JAbMax > 1 )  )   Then
               Begin

                 {
                 P = Pl(t - tau) - E(t),
                 }
	         XX  := XPl [ NPl ] - XEartchBaric ;
	         YY  := YPl [ NPl ] - YEartchBaric ;
	         ZZ  := ZPl [ NPl ] - ZEartchBaric ;

                 P := Sqrt (   Sqr ( XX )
                             + Sqr ( YY )
                             + Sqr ( ZZ )  );

                 {
                 Q = Pl(t - tau) - Sun(t - tau),
                 }
                 XX := XPl [ NPl ] - XSunBaricTmTau ;
                 YY := YPl [ NPl ] - YSunBaricTmTau ;
                 ZZ := ZPl [ NPl ] - ZSunBaricTmTau ;

                 Q := Sqrt (   Sqr ( XX )
                             + Sqr ( YY )
                             + Sqr ( ZZ )  ) ;


               End ; { JAb = 1 }



             {
             Решить относительно tau уpавнение (с точностью до 0.00001 с)
             c * tau = abs(P) + (2 * m/c**2)
             * ln[(abs(E) + abs(P) + abs(Q))/(abs(E) - abs(P) + abs(Q))]
             где:
             t - момент TDB, выpаженный способом, пpигодным для обpащения к
             эфемеpидам планет, напpимеp, в виде эфемеpидной юлианской даты,
             tau - световой пpомежуток, выpаженный в тех же единицах, что и t,
             напpимеp, в сутках,
             P = Plb ( t - tau ) - Eb   ( t       ),
             E = Eb  ( t       ) - Sunb ( t       ),
             Q = Qb  ( t - tau ) - Sunb ( t - tau ),
             Pl   ( t - tau ) - вектоp положения планеты в момент TDB = t - tau ,
             Eb   ( t       ) - вектоp положения Земли   в момент TDB = t       ,
             Sunb ( t       ) - вектоp положения Солнца  в момент TDB = t       ,
             m/c**2 = 9.87e-9, c = 173.1446 au/день (скоpость света),

             все вектоpы выpажены в астpономических  единицах в баpицентpической
             системе кооpдинат.

             Если вычисляется видимое место Солнца,
             Qb = Sb и P = Sb(t - tau) - Eb(t).
             }

             If ( JAbMax > 1 )  Then
             Begin { JAbMax > 1 }

             If (    (    ( Npl >= 10 )
                       Or ( NPl <>  3 ) )
                  Or ( Not CalcPlDE200  )  )
               Then
                 Begin
                   Tau := ( P * 149597870.66 ) / ( 299792.458 * C864000 ) ;
                 End
               Else
                 Begin
                   Tau := (  P
                           + Mc * ln (  ( E + P + Q ) / ( E - P + Q )  )
                                / 2.30259
                          )
                            * AE  / ( 299792.458 * C864000 ) ;
                 End ;


             If (     ( NPl0 = 11        )
                  And (    ( NPl  =  3 )
                        Or ( NPl  = 10 ) ) )
	       Then JdPl := JDE
	       Else JdPl := JDE - Tau;


             End ; { JAbMax > 1 }

            End ;  { JAb }


      End ;  { NPl }







    { Геоцентpические Видимые Кооpдинаты Планет }
    { ───────────────────────────────────────── }

    For NPL := 1 To 10 Do
     If (    (     ( NPl >= IPlBeg )
               And ( NPl <= IPlEnd )
             )
          Or (     ( NPl  = NPl0   )
             )
        )  Then
      Begin  { NPl }

       If ( NPl <> 3 )  Then
         Begin { Not Eartch }

           {
           P = Pl(t - tau) - E(t),
           }
	   Xp := XPl [ NPl ] - XEartchBaric ;
           Yp := YPl [ NPl ] - YEartchBaric ;
	   Zp := ZPl [ NPl ] - ZEartchBaric ;

           P := Sqrt (   Sqr ( Xp )
                       + Sqr ( Yp )
                       + Sqr ( Zp )  );


           XpnN := Xp / P ;
           YpnN := Yp / P ;
           ZpnN := Zp / P ;


             { Если планеты по  DE200 }
             { ────────────────────── }

         If ( CalcPlDE200 )  Then
           Begin

             {
             Q = Pl(t - tau) - Sun(t - tau),
             }
             Xq := XPl [ NPl ] - XSunBaricTmTau ;
             Yq := YPl [ NPl ] - YSunBaricTmTau ;
             Zq := ZPl [ NPl ] - ZSunBaricTmTau ;

             Q := Sqrt (   Sqr ( Xq )
                         + Sqr ( Yq )
                         + Sqr ( Zq )  ) ;

             If ( Q > 4.0e-5 )  Then
               Begin
                 Xqn := Xq / Q ;
                 Yqn := Yq / Q ;
                 Zqn := Zq / Q ;
               End ;

             {
             xeb, yeb, zeb - бapиц.   к-ты нaблюдaтeля нa     JDEtDB

             xq,  yq,  zq  - гeлиoц.  к-ты плaнeты нa мoмeнт  JDEtDB-Tau
             XeGelioc,
             YeGelioc,
             ZeGelioc      - гeлиoц.  к-ты нaблюдaтeля нa     JDEtDB
             xp,  yp,  zp  - paзнocть к-ты плaнeты в мoмeнт   JDEtDB-Tau
                             и нaблюдaтeля в мoмeнт           JDEtDB
             }

             If ( NPl < 11 )  Then
               Begin

                 { yчeт oтклoнeния cвeтa в пoлe тягoтeния Coлнцa }

                 cc :=   XpnN * XqN
                       + YpnN * YqN
                       + ZpnN * ZqN  ;

                 ff :=   XeGeliocN  * XpnN
                       + YeGeliocN  * YpnN
                       + ZeGeliocN  * ZpnN  ;

                 ss := Mc / ( E * (   XqN * XeGeliocN
                                    + YqN * YeGeliocN
                                    + ZqN * ZeGeliocN + C10 ) ) ;

                 XpnN := XpnN + ss * ( cc * XeGeliocN - ff * XqN ) ;
                 YpnN := YpnN + ss * ( cc * YeGeliocN - ff * YqN ) ;
                 ZpnN := ZpnN + ss * ( cc * ZeGeliocN - ff * ZqN ) ;


               End ;


             { Учeт aбeppaции oт cкopocти нaблюдaтeля }
             { ────────────────────────────────────── }

               Begin

                 VxB := VxEartch / 299792.458 / C864000 * AE ;
                 VyB := VyEartch / 299792.458 / C864000 * AE ;
                 VzB := VzEartch / 299792.458 / C864000 * AE ;

                 Cc := Sqrt ( C10 - ( Sqr ( VxB ) + Sqr ( VyB ) + Sqr ( VzB ) ) ) ;
                 Ff := XpnN * VxB + YpnN * VyB + ZpnN * VzB ;
                 Ss := C10 + Ff / ( C10 + Cc ) ;
                 Ff := Ff  + C10 ;

                 XPnN := ( Cc * XPnN + Ss * VxB ) / Ff ;
                 YPnN := ( Cc * YPnN + Ss * VyB ) / Ff ;
                 ZPnN := ( Cc * ZPnN + Ss * VzB ) / Ff ;

               End ;


             XPl [ NPl ] := XpnN * P + XEartchBaric  ;
             YPl [ NPl ] := YpnN * P + YEartchBaric  ;
             ZPl [ NPl ] := ZpnN * P + ZEartchBaric  ;

           End ;


        End ; { Not Eartch }

      End ;  { NPl }





     { Геоцентpические Видимые Кооpдинаты Солнца }
     { ───────────────────────────────────────── }

    For NPL := 11  To  11  Do
      Begin  { NPl }

             { Если планеты по  DE200 }
             { ────────────────────── }

         If ( CalcPlDE200 )  Then
           Begin
             {
             P = Pl(t - tau) - E(t),
             }
	     Xp  := XPl [ NPl ] - XEartchBaric ;
	     Yp  := YPl [ NPl ] - YEartchBaric ;
	     Zp  := ZPl [ NPl ] - ZEartchBaric ;

             P := Sqrt (   Sqr ( Xp )
                         + Sqr ( Yp )
                         + Sqr ( Zp )  );


             XpnN := Xp / P ;
             YpnN := Yp / P ;
             ZpnN := Zp / P ;



             {
             xeb, yeb, zeb - бapиц.   к-ты нaблюдaтeля нa     JDEtDB

             xq,  yq,  zq  - гeлиoц.  к-ты плaнeты нa мoмeнт  JDEtDB-Tau
             XeGelioc,
             YeGelioc,
             ZeGelioc      - гeлиoц.  к-ты нaблюдaтeля нa     JDEtDB
             xp,  yp,  zp  - paзнocть к-ты плaнeты в мoмeнт   JDEtDB-Tau
                             и нaблюдaтeля в мoмeнт           JDEtDB
             }


             { Учeт aбeppaции oт cкopocти нaблюдaтeля }
             { ────────────────────────────────────── }

               Begin

                 VxB := VxEartch / 299792.458 / C864000 * AE ;
                 VyB := VyEartch / 299792.458 / C864000 * AE ;
                 VzB := VzEartch / 299792.458 / C864000 * AE ;

                 Cc := Sqrt ( C10 - (   Sqr ( VxB )
                                      + Sqr ( VyB )
                                      + Sqr ( VzB ) ) ) ;

                 Ff :=   XPnN * VxB
                       + YPnN * VyB
                       + ZPnN * VzB ;

                 Ss := C10 + Ff / ( C10 + Cc ) ;
                 Ff := Ff  + C10 ;

                 XPnN := ( Cc * XPnN + Ss * VxB ) / Ff ;
                 YPnN := ( Cc * YPnN + Ss * VyB ) / Ff ;
                 ZPnN := ( Cc * ZPnN + Ss * VzB ) / Ff ;

               End ;


             XPl [ NPl ] := XpnN * P + XEartchBaric  ;
             YPl [ NPl ] := YpnN * P + YEartchBaric  ;
             ZPl [ NPl ] := ZpnN * P + ZEartchBaric  ;

           End ;

      End ;  { NPl }


    XPl0 := XPl [ NPl0 ] ;
    YPl0 := YPl [ NPl0 ] ;
    ZPl0 := ZPl [ NPl0 ] ;

    RectCoordPl [ NPl0 , 1 ] := 0.0 ;
    RectCoordPl [ NPl0 , 2 ] := 0.0 ;
    RectCoordPl [ NPl0 , 3 ] := 0.0 ;


     { Топоцентpические Кооpдинаты Планет }
     { ────────────────────────────────── }

    For NPL := IPlBeg  To  IPlEnd  Do
     {
     If  (    ( NPl <> NPl0            )
           Or (     ( R00  > 4.0e-5 )
                And ( Not B_Surf    )  )  )   Then
     }

     If  (    ( NPl <> NPl0   )
           Or ( R00  > 4.0e-5 )  )   Then
      Begin  { NPl }


         { Топоцентpические к-ты }
         { ───────────────────── }

         XX := XPl [ NPl ] ;
         YY := YPl [ NPl ] ;
         ZZ := ZPl [ NPl ] ;

         If ( NPl = 10 )  Then
           Begin

             XMoonGeoc := XX - XEartchBaric ;
             YMoonGeoc := YY - YEartchBaric ;
             ZMoonGeoc := ZZ - ZEartchBaric ;

             If ( CalcPlDE200 )  Then
               Begin
                 PreNXYZ ( 2451545.0 , JDRez, XMoonGeoc , YMoonGeoc , ZMoonGeoc ) ;
                 Nutnew  ( JDRez     , 1    , XMoonGeoc , YMoonGeoc , ZMoonGeoc ) ;
               End ;

           End ;


         If ( NPl = 11 )  Then
           Begin

             XSunGeoc := XX - XEartchBaric ;
             YSunGeoc := YY - YEartchBaric ;
             ZSunGeoc := ZZ - ZEartchBaric ;

             If ( CalcPlDE200 )  Then
               Begin
                 PreNXYZ ( 2451545.0 , JDRez, XSunGeoc , YSunGeoc , ZSunGeoc ) ;
                 Nutnew  ( JDRez     , 1    , XSunGeoc , YSunGeoc , ZSunGeoc ) ;
               End ;

           End ;


         XX := XX - ( XPl0 + X00 ) ;
         YY := YY - ( YPl0 + Y00 ) ;
         ZZ := ZZ - ( ZPl0 + Z00 ) ;

         If ( CalcPlDE200 )  Then
           Begin
             PreNXYZ ( 2451545.0 , JDRez, XX , YY , ZZ ) ;
             Nutnew  ( JDRez     , 1    , XX , YY , ZZ ) ;
           End ;

         XPl [ NPl ] := XX ;
         YPl [ NPl ] := YY ;
         ZPl [ NPl ] := ZZ ;


         { Запись пpямоугольных топоцентpических кооpдинат }
         { ─────────────────────────────────────────────── }

         RectCoordPl [ NPl , 1 ] := XX * AE ;
         RectCoordPl [ NPl , 2 ] := YY * AE ;
         RectCoordPl [ NPl , 3 ] := ZZ * AE ;

    End ;  { NPl }






    For NPL := IPlBeg  To  IPlEnd  Do
     If  (    ( NPl <> NPl0   )
           Or ( R00  > 4.0e-5 )  )   Then
      Begin  { NPl }


         { Пеpеход к сфеpическим кооpдинатам }
         { ───────────────────────────────── }

         XX := XPl [ NPl ] ;
         YY := YPl [ NPl ] ;
         ZZ := ZPl [ NPl ] ;

         RPE  := Sqrt (   Sqr ( XX )
                        + Sqr ( YY )
                        + Sqr ( ZZ )  ) ;

         If ( RPE > 4.0e-5 )
           Then
             Begin
               XpN := XX / RPE ;
               YpN := YY / RPE ;
	       ZpN := ZZ / RPE ;
             End
           Else
             Begin
               XpN := XX ;
               YpN := YY ;
               ZpN := ZZ ;

             End ;

         Ra   := ATan2 ( YPn , XPn ) ;
         Decl := Atan2 ( ZPn , Sqrt ( Sqr ( XPn ) + Sqr ( YPn ) )  ) ;
         If ( Decl > Pi )  Then
           Decl := Decl - Pi2 ;



         { АнтиСолнце }
         { ────────── }

         If (     ( NPl = 11                 )
              And (     ( B_Geoc          )
                    And ( NPl0 = 3        )
                    And ( B_Object_Tracks )  )  )  Then
           Begin

             Ra := Ra + Pi ;
             If ( Ra > Pi2 ) Then
               Ra := Ra - Pi2 ;
             Decl := - Decl ;

           End ;




        If ( RPE > 4.0e-5 )  Then
          Begin
            XpN := - XX / RPE ;
            YpN := - YY / RPE ;
	    ZpN := - ZZ / RPE ;
          End ;





               { Угол Фазы }
               { ───────── }

        If (     (    ( NPl <> NPl0   )
                   Or ( R00  > 4.0e-5 )  )
             And ( NPl0 <> 11         )
             And ( NPl  <> 11             )  )
          Then
            Begin

              XSP :=  XSunGeoc - XPl [ NPl ]  ;
              YSP :=  YSunGeoc - YPl [ NPl ]  ;
              ZSP :=  ZSunGeoc - ZPl [ NPl ]  ;

              RSP := Sqrt (   Sqr ( XSP )
                            + Sqr ( YSP )
                            + Sqr ( ZSP )  ) ;

              XSPN := XSP / RSP ;
              YSPN := YSP / RSP ;
              ZSPN := ZSP / RSP ;

              CP :=   XpN * XspN
                    + YpN * YspN
                    + ZpN * ZspN  ;

              If ( Sqr ( Cp ) > C10 )
                Then
                  Begin
                    Cp := C10 ;
                    Sp := 0.0 ;
                  End
                Else
                    Sp := Sqrt ( C10 - Sqr ( Cp ) ) ;
              {
              SP := Sqrt ( C10 - Sqr ( CP ) ) ;
              }
              {
              SP := Sqrt (   Sqr ( YpN * ZspN - ZpN * YspN )
                           + Sqr ( ZpN * XspN - XpN * ZspN )
                           + Sqr ( XpN * YspN - YpN * XspN )  )  ;
              }
              Phase := ATan2 ( SP , CP ) ;

            End
          Else
              Phase := 0.0 ;




         {
	 RP    -  гелиоцентpическое  pасстояние планеты
	 RPE   -  топоцентpическое   pасстояние планеты
	 RSP   -  топоцентpическое   pасстояние солнца
         }

	  RP  := R [ NPl ];

          MAGN ( NPl, RP, RPE, E, JdPl, XX, YY, ZZ, RM [NPl] ) ;
        { ──────────────────────────────────────────────────── }





             { ФАЗА И ПОЗИЦИОННЫЙ УГОЛ 'РОГОВ'}
             { ────────────────────────────── }

      If (     ( NPl  <> 11 )
           And ( NPl0 <> 11 ) )
        Then
          Begin

            SP := XpN * YSunGeocN - XSunGeocN * YpN ;

	    CP :=   ZSunGeocN * ( XpN * XpN         + YpN * YpN         )
                  - ZpN         * ( XpN * XSunGeocN + YpN * YSunGeocN ) ;

	    PP := ATan2 ( SP , CP ) ;

            {
               'PP'  -   УГОЛ  ПОЛЮС - ПЛАНЕТА - СОЛНЦЕ
                ───────────────────────────────────────
             ПРОТИВ ЧАСОВОЙ СТРЕЛКИ ПРИ ВЗГЛЯДЕ ИЗНУТРИ СФЕРЫ
             ────────────────────────────────────────────────
            }

            If ( NPl = 10 ) Then
              PhaseMoon := Phase ;

            If ( NPl = 3 ) Then
              PhaseEarth := Phase ;

          End  { NPl <> 11 }
        Else
          Begin { Солнце }
            PP := 0 ;
            Phase := 0.0 ;
            {
            PhaseMoon  := Phase ;
            PhaseEarth := Phase ;
            }
          End ;




	{ ЗАПИСЬ РЕЗУЛЬТАТОВ }
	{ ────────────────── }


        If ( ( NPl <> NPl0 ) Or ( R0PL > 1.0E-7 ) ) Then
          Begin

            RRab := Diam [ NPl ] / SekRad / RPE ;

            If ( RRab < C10 )
              Then
                Begin
                  RRab              := RRab / Sqrt ( C10 - Sqr ( RRab ) ) ;
                  RezPl [ NPl , 4 ] :=  C20 * ArcTan ( RRab ) ;
                End
              Else
                  RezPl [ NPl , 4 ] := C20 * PI ;

	    RezPl [ NPl , 1 ] := Ra         ;
	    RezPl [ NPl , 2 ] := Decl       ;
	    RezPl [ NPl , 3 ] := RM [ NPl ] ;
	    RezPl [ NPl , 5 ] := Phase      ;
	    RezPl [ NPl , 6 ] := PP         ;
            RezPl [ NPl , 7 ] := RPE        ;

          End ;




        { ПРЕОБРАЗОВАНИЕ КООРДИНАТ СПУТНИКОВ ЮПИТЕРА В ЭКВАТОРИАЛЬНЫЕ }
	{ ─────────────────────────────────────────────────────────── }

	If  (     ( NPl  = 5 )
              And ( NPl0 = 3 )  )   Then
         Begin

          RJup     :=       RezPl [ 5 , 7 ] * AE ;
          SRaJup   := Sin ( RezPl [ 5 , 1 ] ) ;
          CRaJup   := Cos ( RezPl [ 5 , 1 ] ) ;
          SDeclJup := Sin ( RezPl [ 5 , 2 ] ) ;
          CDeclJup := Cos ( RezPl [ 5 , 2 ] ) ;

	  UGOL := 23.439 * C36000 / SekRad * CRaJup ;

	  SU := Sin ( UGOL );
	  CU := Sqrt ( C10 - SU * SU );

          XJup := RectCoordPl [ 5 , 1 ]   ;
          YJup := RectCoordPl [ 5 , 2 ]   ;
          ZJup := RectCoordPl [ 5 , 3 ]   ;


	  For II := 1 To 4  Do
	   Begin

	    XSAT := XSJ [ II ] / SekRad;
	    YSAT := YSJ [ II ] / SekRad;

            DrSatJup    := DRSJ [ II ] * AE ;
            DRaSatJup   := ( XSAT * CU - YSAT * SU ) / CDeclJup  ;
            DDEclSatJup :=   XSAT * SU + YSAT * CU               ;

	    RezPl [ 11+II , 1 ] := RezPl [ 5 , 1 ] + DRaSatJup   ;
	    RezPl [ 11+II , 2 ] := RezPl [ 5 , 2 ] + DDeclSatJup ;
	    RezPl [ 11+II , 3 ] := RMSATJ [ II ];
	    RezPl [ 11+II , 4 ] := Diam  [ 11+II ] / RPE * C20 / SekRad;
	    RezPl [ 11+II , 5 ] := RezPl [ 5 , 5 ];
	    RezPl [ 11+II , 6 ] := RezPl [ 5 , 6 ];
            RezPl [ 11+II , 7 ] := RezPl [ 5 , 7 ] + DRSJ [ II ] ;

            DXSatJup :=          CRaJup * CDeclJup * DrSatJup
                        - RJup * SRaJup * CDeclJup * DRaSatJup
                        - RJup * CRaJup * SDeclJup * DDeclSatJup ;

            DYSatJup :=          SRaJup * CDeclJup * DrSatJup
                        + RJup * CRaJup * CDeclJup * DRaSatJup
                        - RJup * SRaJup * SDeclJup * DDeclSatJup ;

            DZSatJup := DrSatJup * SDeclJup + RJup * CDeclJup * DDeclSatJup ;

            RectCoordPl [ 11+II , 1 ] := XJup + DXSatJup ;
            RectCoordPl [ 11+II , 2 ] := YJup + DYSatJup ;
            RectCoordPl [ 11+II , 3 ] := ZJup + DZSatJup ;

	   End ;

         End ; { NPl }

    End ;  { NPl }

  End; { Proc PlPro }


End.

