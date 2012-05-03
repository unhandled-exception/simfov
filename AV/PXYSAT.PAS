
{$O+,F+}


  Unit PXYSAT ;

   Interface

   Procedure  XYSAT ( T, T0                               : Double  ;  { JD }
                      NPl0                                : Integer ;
                      Eksc, ISat, OmG, OmL, M0,
                      Mot, Mot1, Mot2, BStar              : Double  ;
                      Var X, Y, Z, VX, VY, VZ             : Double     ) ;



   Implementation

   Uses PVar ;

   Procedure  XYSAT ( T, T0                               : Double  ;  { JD }
                      NPl0                                : Integer ;
                      Eksc, ISat, OmG, OmL, M0,
                      Mot, Mot1, Mot2, BStar              : Double  ;
                      Var X, Y, Z, VX, VY, VZ             : Double     ) ;

            {
            T,T0 - ŒŽŒ…’› ‚…Œ…ˆ ‚ ž‹ˆ€‘Šˆ• „Ÿ•,
            NPl0 - H®¬¥p æ¥­âp «ì­®© ¯« ­¥âë,
            Eksc - Š‘–…’ˆ‘ˆ’…’,
            ISat - €Š‹Ž Ž’Ž‘ˆ’…‹œŽ ‡…ŒŽƒŽ Š‚€’Ž€,
            OmG  - ŸŒŽ… ‚Ž‘•Ž†„…ˆ… ‚Ž‘•Ž„Ÿ™…ƒŽ “‡‹€,
            OmL  - €‘‘’ŽŸˆ… …ˆ–…’€ Ž’ “‡‹€,
            M0   - ‘…„ŸŸ €ŽŒ€‹ˆŸ ‚ Ž•“ T0.
            Mot,
            Mot1,
            Mot2 - ‘p¥¤­¥¥ ¤¢¨¦¥­¨¥ ¨ ¯p®¨§¢®¤­ë¥ ¯® ¢p¥¬¥­¨
                ŠŽŽ„ˆ€’› ˆ ‘ŠŽŽ‘’ˆ ‚ ŠŒ.
            }

   Var

        J                                       : LongInt ;

        M, N                                    : Extended  ;

        A, R, E, DE, SE, CE, DZ, ET             : Extended    ;
        PX, PY, PZ, QX, QY, QZ                  : Extended    ;
        Eksc2                                   : Extended    ;
        SOmL, COmL, SOmG, COmG, SI, CI          : Extended    ;
        U, SU, CU                               : Extended    ;
        V, SV, CV                               : Extended    ;
        P, VN, VR                               : Extended    ;



     Begin


           Eksc2 := Eksc * Eksc ;

           N     := Mot + Mot1 * (T-T0) + Mot2 * Sqr (T-T0) ;

           A     := Fm [ NPl0 ] / Sqr ( N ) ;
           A     := Exp ( Ln ( A ) / 3.0 ) ;

           M     := M0 + N * ( T - T0 ) ;
           J     := Trunc ( M / Pi2 ) ;
           M     := M - J * Pi2 ;

           E     := M   ;
           DE    := C10 ;


           While ( Abs ( DE ) > 0.000001 )  Do
              Begin

                 dE := (   M + Eksc * Sin ( E ) - E ) /
                       ( C10 - Eksc * Cos ( E )     )   ;

                 E  := E + dE ;

              End  ;


           SE   := Sin ( E ) ;
           CE   := Cos ( E ) ;

           R    := A * ( C10 - Eksc * CE ) ;

           DZ   := A * ( CE - Eksc ) ;
           ET   := A *   SE * Sqrt ( C10 - Eksc2 ) ;

           SOmL := Sin ( OmL ) ;
           COmL := Cos ( OmL ) ;

           SOmG := Sin ( OmG ) ;
           COmG := Cos ( OmG ) ;

           SI   := Sin ( ISat ) ;
           CI   := Cos ( ISat ) ;


           PX   := COmL * COmG  -  SOmL * SOmG * CI ;
           PY   := COmL * SOmG  +  SOmL * COmG * CI ;
           PZ   := SOmL *   SI                      ;

           QX   := - SOmL * COmG  -  COmL * SOmG * CI ;
           QY   := - SOmL * SOmG  +  COmL * COmG * CI ;
           QZ   :=   COmL *   SI                      ;

           X    :=  PX * DZ  +  QX * ET ;
           Y    :=  PY * DZ  +  QY * ET ;
           Z    :=  PZ * DZ  +  QZ * ET ;


           SV   := A * SE * Sqrt ( C10 - Eksc2 ) / R ;
           CV   := A * ( CE - Eksc ) / R ;

           V    := ArcTan ( SV / CV ) ;
           If ( CV < 0.0 )  Then
             V := V + PI  ;
           If (  V < 0.0 )  Then
             V := V + Pi2 ;

           U    := V + OmL ;

           SU   := Sin ( U ) ;
           CU   := Cos ( U ) ;

           P    := A * ( C10 - Eksc2 ) ;

           VR   := Sqrt ( Fm [ NPl0 ] / P ) * Eksc * SV ;
           VN   := Sqrt ( Fm [ NPl0 ] / P ) * ( C10 + Eksc * CV ) ;

           VX   := X / R * VR ;
           VX   := VX + ( - SU * COmG - CU * SOmG * CI ) * VN ;

           VY   := Y / R * VR ;
           VY   := VY + ( - SU * SOmG + CU * COmG * CI ) * VN ;

           VZ   := Z / R * VR  +  CU * SI * VN ;


     End  ;


   End.
