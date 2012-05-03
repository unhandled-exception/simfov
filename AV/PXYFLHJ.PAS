
{$O+,F+}



 Unit PXYFLHJ ;
     {*******}
{
           €‘—…’ Š‚€’Žˆ€‹œ›• ŸŒŽ“ƒŽ‹œ›• ŠŽŽ„ˆ€’
           ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

       „‹Ÿ “Š’€  ( LatASTRON, Long, Height(KM.) ) ‚ ŒŽŒ…’  Jd
       ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

              C “—…’ŽŒ ƒŽ„ˆ—Ž‰ €…€–ˆˆ ˆ “’€–ˆˆ
              ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

            ‘ Žƒ…˜Ž‘’œž … Ž‹……  1  ‘…Š“„›  „“ƒˆ
            ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
}


                      { …‡“‹œ’€’ : }
                      { ÜÜÜÜÜÜÜÜÜÜÜ }
{
                X, Y, Z  - Š‚€’Žˆ€‹œH›…,  Km
                Vx,Vy,Vz -                  Km/‘¥ª
                REarFL   - €„ˆ“‘ ‡…Œ‹ˆ ‚ “HŠ’…
                LatGeoc  - ƒ…Ž–…H’ˆ—…‘Š€Ÿ ˜ˆŽ’€
                S        - Œ…‘’HŽ… ˆ‘’ˆHŽ… ‡‚…‡„HŽ… ‚…ŒŸ
}

 Interface

   Procedure  XYFLHJ (      Lat, Long, Height, Jd   : DOUBLE    ;
                       Var  X  , Y  , Z   ,
                            VxS, VyS, VzS ,
                            REarFL, LatGeoc, S      : DOUBLE      ) ;


 Implementation

 Uses PVar ;

   Procedure  XYFLHJ (      Lat, Long, Height, Jd   : DOUBLE    ;
                       Var  X  , Y  , Z   ,
                            VxS, VyS, VzS ,
                            REarFL, LatGeoc, S      : DOUBLE      ) ;


      Const

            AE     : DOUBLE =  6378.137          ;
            FE     : DOUBLE =   298.2572         ;
            COEFF1 : DOUBLE =  0.00577551830441  ;
            S01900 : Double =  23925.836         ;

      Var

        D1, S0, AR, L, E2, CLat,
        DXY, DZ, C, SS, TAU, TAU2, X1, Y1, Z1,
        XX, XY, XZ, YX, YY, YZ, ZX, ZY, ZZ,
        Jd0, UT, R, RH, FMFG,
        T , Eps,
        OM, L1, F, D,
        DPsi, DEps,
        SEpsM, CEpsM,
        SEpsT, CEpsT,
        SDPsi, CDPsi,
        N,   BET,
        SA1, SA2,
        CA1, CA2                                     : DOUBLE ;

         Begin


             {  “’€–ˆŸ ‚ „Ž‹ƒŽ’… ˆ ‚ €Š‹Ž…  }
             {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }

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

           SEpsM := Sin ( Eps ) ;
           CEpsM := Cos ( Eps ) ;

           SEpsT := Sin ( Eps + DEps ) ;
           CEpsT := Cos ( Eps + DEps ) ;

           SDPsi := Sin ( DPsi ) ;
           CDPsi := Cos ( DPsi ) ;


           SEps := SEpsT ;
           CEps := CEpsT ;

             { Œ…‘’Ž… ‡‚…‡„Ž… ‚…ŒŸ }
             { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

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
           If ( S < 0.0 )  Then
             S := S + Pi2 ;
           S  := S  - Trunc ( S / PI2 ) * PI2 ;



              { ŸŒŽ“ƒŽ‹œ›… ŠŽŽ„ˆ€’› }
              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
           {
           FMFG := ( 692.743 * Sin ( C20 * Lat ) -
                       1.163 * Sin ( 4.0 * Lat ) +
                       0.003 * Sin ( 6.0 * Lat )   )  / SekRad ;

           LatGeoc := Lat - FMFG ;
           }

           LatGeoc := Lat             ; { „«ï X,Y,Z ­ã¦­   áâp®­. è¨p®â  }
           CLat    := Cos ( LatGeoc ) ;

           RH   := 0.99832707 + 0.00167644 * Cos ( C20 * Lat ) -
                                0.00000352 * Cos ( 4.0 * Lat )   ;

           REarFL := RH * AE ;  { €„ˆ“‘ ‡…Œ‹ˆ ‚ ’Ž—Š… ( Lat, Long ) ‚ ŠŒ }
                                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

           RH   := RH * ( AE + Height ) ;


           X    := Cos ( S )  *   CLat            ;
           Y    := Sin ( S )  *   CLat            ;
           Z    :=                Sin ( LatGeoc ) ;



              {  ƒŽ„ˆ—€Ÿ €…€–ˆŸ  }
              {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }

           T   := ( Jd - 2415020.0 ) / 36525.0 ;

           F   :=    40503.20 + 1739527290.54 * T ;
           D   :=  1262654.95 + 1602961611.18 * T ;
           N   :=   933059.79 -    6962911.23 * T ;
           L1  :=  1290513.00 +  129596579.10 * T ;

           SA1 := ( F - D + N ) / SekRad ;
           SA2 := ( SA1 + L1  ) / SekRad ;

           CA1 := Cos(SA1) ;
           CA2 := Cos(SA2) ;

           SA1 := Sin(SA1) ;
           SA2 := Sin(SA2) ;


           VXS  := (   0.01719971 * SA1 + 0.00028809 * SA2 ) * COEFF1 ;
           VYS  := ( - 0.01577888 * CA1 - 0.00026429 * CA2 ) * COEFF1 ;
           VZS  := ( - 0.00684523 * CA1 - 0.00011466 * CA2 ) * COEFF1 ;


           BET :=  Sqrt ( C10 - ( Sqr ( VXS ) + Sqr ( VYS ) + Sqr ( VZS ) ) ) ;


           F   :=  X * VXS  +  Y * VYS  +  Z * VZS ;

           SS  :=  C10 + F                  ;
           F   :=  C10 + F / ( C10 + BET )  ;





           If ( Not B_PlanDraw ) Then
             Begin

               X   :=  ( X * SS  -  F * VXS ) / BET ;
               Y   :=  ( Y * SS  -  F * VYS ) / BET ;
               Z   :=  ( Z * SS  -  F * VZS ) / BET ;

               XX :=    X                        ;
               YY :=    Y * CEpsT  +   Z * SEpsT ;
	       ZZ := -  Y * SEpsT  +   Z * CEpsT ;

	       X  :=   XX * CDPsi  +  YY * SDPsi ;
	       Y  := - XX * SDPsi  +  YY * CDPsi ;
	       Z  :=   ZZ                        ;

	       XX :=    X                        ;
	       YY :=    Y * CEpsM  -   Z * SEpsM ;
	       ZZ :=    Y * SEpsM  +   Z * CEpsM ;

               R  := Sqrt ( Sqr ( XX ) + Sqr ( YY ) + Sqr ( ZZ ) ) ;

	       X := XX / R ;
	       Y := YY / R ;
	       Z := ZZ / R ;

             End ;


           { ……‚Ž„  Š - ’  ‚  ŠŒ }
           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

           X   := X * RH  ;
           Y   := Y * RH  ;
           Z   := Z * RH  ;


           VXS := VXS * 149597870.66 / Coeff1 / C864000 - 7.292115e-8 * Y  ;
           VYS := VYS * 149597870.66 / Coeff1 / C864000 + 7.292115e-8 * X  ;
           VZS := VZS * 149597870.66 / Coeff1 / C864000                    ;


         End ;


 End.
