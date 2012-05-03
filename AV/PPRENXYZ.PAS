
{$F+,O+}

 Unit PPreNXyz ;

 InterFace

	Procedure PreNXyz (      JDE1, JDE2  : Double ;
                            Var   X , Y , Z  : Double     ) ;


 Implementation


	Procedure PreNXyz (      JDE1, JDE2  : Double ;
                            Var   X , Y , Z  : Double     ) ;


   Const

     HY  : Double =   36525.0            ;
     T0  : Double = 2451545.0            ;
     Sr  : Double =  206264.8062470964   ;

     C1  : Double = 2306.2181   ;
     C2  : Double =    1.39656  ;
     C3  : Double =    0.000139 ;
     C4  : Double =    0.30188  ;
     C5  : Double =    0.000344 ;
     C6  : Double =    0.017998 ;
     C7  : Double =    1.09468  ;
     C8  : Double =    0.000066 ;
     C9  : Double =    0.018203 ;
     C10 : Double = 2004.3109   ;
     C11 : Double =    0.85330  ;
     C12 : Double =    0.000217 ;
     C13 : Double =    0.42665  ;
     C14 : Double =    0.000217 ;
     C15 : Double =    0.041833 ;


   Var
      T, T2,
      Dt, Dt2, Dt3,
      S1, S2, S3,
      CC1, CC2, CC3,
      R1, R2, R3       : Double ;

   Begin


      T  := ( JDE1 - T0   ) / HY ;
      Dt := ( JDE2 - JDE1 ) / HY ;

      T2  := T   * T  ;
      Dt2 := Dt  * Dt ;
      Dt3 := Dt2 * Dt ;

      S2  :=      (   C1
                    + C2  * T
                    - C3  * T2 ) * Dt  ;
      S1  := S2 + (   C4
                    - C5  * T  ) * Dt2
                    + C6         * Dt3 ;
      S3  := S2 + (   C7
                    + C8  * T  ) * Dt2
                    + C9         * Dt3 ;
      S2  :=      (   C10
                    - C11 * T
                    - C12 * T2 ) * Dt  ;
      S2  := S2 - (   C13
                    + C14 * T  ) * Dt2
                    - C15        * Dt3 ;


      S1  := S1 / Sr ;
      S2  := S2 / Sr ;
      S3  := S3 / Sr ;

      CC1 := Cos ( S1 ) ;
      CC2 := Cos ( S2 ) ;
      CC3 := Cos ( S3 ) ;

      S1  := Sin ( S1 ) ;
      S2  := Sin ( S2 ) ;
      S3  := Sin ( S3 ) ;



      R1 := X  * CC1 - Y  * S1  ;
      R2 := X  * S1  + Y  * CC1 ;
      R3 := Z                   ;

      X  := R1 * CC2 - R3 * S2  ;
      Y  := R2                  ;
      Z  := R1 * S2  + R3 * CC2 ;

      R1 := X  * CC3 - Y  * S3  ;
      R2 := X  * S3  + Y  * CC3 ;
      R3 := Z                   ;

      X  :=  R1  ;
      Y  :=  R2  ;
      Z  :=  R3  ;

   End ;

 End.
