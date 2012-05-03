
{$F+,O+}

 UNIT PPREOLD ;

 INTERFACE

	PROCEDURE PREOLD (     JDE1, JDE2  : DOUBLE ;
                          VAR    RA, DECL  : DOUBLE   ) ;


 IMPLEMENTATION

 Uses PAtan2 ;

	PROCEDURE PREOLD (     JDE1, JDE2  : DOUBLE ;
                          VAR    RA, DECL  : DOUBLE   ) ;


   CONST

     HY  =   36524.2198781     ;
     T0  = 2415020.313516463   ;
     SR  =  206264.8062470964  ;

   VAR


     DT,DT2,DT3,T,T2,S1,S2,S3,C1,C2,C3      : DOUBLE ;
     X, Y, Z                                : DOUBLE ;
     SRA, CRA                               : DOUBLE ;


   BEGIN

      T   := ( JDE1 - T0   ) / HY ;
      DT  := ( JDE2 - JDE1 ) / HY ;

      T2  := T   * T  ;
      DT2 := DT  * DT ;
      DT3 := DT2 * DT ;

      S2  :=      ( 2304.253  + 1.3973  * T + 0.00006 * T2 )  * DT  ;
      S1  := S2 + (    0.3023 - 0.0027  * T ) * DT2 + 0.01800 * DT3 ;
      S3  := S2 + (    1.0950 + 0.0039  * T ) * DT2 + 0.01832 * DT3 ;
      S2  :=      ( 2004.685  - 0.8533  * T - 0.00037 * T2 )  * DT  ;
      S2  := S2 - (    0.4267 + 0.00037 * T ) * DT2 - 0.0418  *DT3  ;



      S1  := S1 / SR ;
      S2  := S2 / SR ;
      S3  := S3 / SR ;

      C1  := COS ( S1 ) ;
      C2  := COS ( S2 ) ;
      C3  := COS ( S3 ) ;

      S1  := SIN ( S1 ) ;
      S2  := SIN ( S2 ) ;
      S3  := SIN ( S3 ) ;


      Z   := SIN  ( DECL ) ;
      Y   := SQRT ( 1.0 - Z * Z ) ;
      SRA := SIN  ( RA ) ;
      CRA := COS  ( RA ) ;
      X   := CRA * Y ;
      Y   := SRA * Y ;


      DT  := X * C1 - Y * S1 ;
      DT2 := X * S1 + Y * C1 ;
      DT3 := Z               ;

      X   := DT * C2 - DT3 * S2 ;
      Y   := DT2                ;
      Z   := DT * S2 + DT3 * C2 ;

      DT  := X * C3 - Y * S3 ;
      DT2 := X * S3 + Y * C3 ;
      DT3 := Z               ;

      X   := DT  ;
      Y   := DT2 ;
      Z   := DT3 ;

      Ra   := ATan2 ( Y , X ) ;
      Decl := Atan2 ( Z , Sqrt ( Sqr ( X ) + Sqr ( Y ) )  ) ;
      If ( Decl > Pi )  Then
        Decl := Decl - Pi*2.0 ;

   END ;

 END.
