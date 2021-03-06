
{$F+,O+}


 UNIT PPreNew ;

 INTERFACE

	PROCEDURE PreNew (      JDE1, JDE2  : DOUBLE ;
                           VAR    RA, DECL  : DOUBLE   ) ;


 IMPLEMENTATION

 Uses PAtan2 ;

	PROCEDURE PreNew (      JDE1, JDE2  : DOUBLE ;
                           VAR    RA, DECL  : DOUBLE   ) ;
{ ---------------------------------------------------------------
     J2000.0  2451545.0
     B1900.0  2415020.313516463
     B1950.0  2433282.423455513
            �po�o����e��oc�� a�c�o�o c�o�e�� 36525 ��e�.
            �ecce�e�a ��oxa ��� J2000:  2000.001278.
  --------------------------------------------------------------- }

   CONST

     HY   : Double =    36525.0           ;
     T0   : Double =  2451545.0           ;
     SR   : Double =   206264.8062470964  ;
     Pi2  : Double = Pi + Pi              ;

     CC1  : Double =  2306.2181     ;
     CC2  : Double =     1.39656    ;
     CC3  : Double =     0.000139   ;
     CC4  : Double =     0.30188    ;
     CC5  : Double =     0.000344   ;
     CC6  : Double =     0.017998   ;
     CC7  : Double =     1.09468    ;
     CC8  : Double =     0.000066   ;
     CC9  : Double =     0.018203   ;
     CC10 : Double =  2004.3109     ;
     CC11 : Double =     0.85330    ;
     CC12 : Double =     0.000217   ;
     CC13 : Double =     0.42665    ;
     CC14 : Double =     0.000217   ;
     CC15 : Double =     0.041833   ;


   VAR


     DT,DT2,DT3,T,T2,S1,S2,S3,C1,C2,C3,
     X, Y, Z,
     SRA, CRA,
     XEkl, YEkl, ZEkl, Eps, SEps, CEps ,
     LEkl, BEkl                              : Double ;

   BEGIN

      T   := ( JDE1 - T0   ) / HY ;
      DT  := ( JDE2 - JDE1 ) / HY ;

      Z   := SIN  ( DECL ) ;
      Y   := SQRT ( 1.0 - Z * Z ) ;
      SRA := SIN  ( RA ) ;
      CRA := COS  ( RA ) ;
      X   := CRA * Y ;
      Y   := SRA * Y ;



      If ( Abs ( DT ) <= 10.0 )  Then
        Begin

          T2  := T   * T  ;
          DT2 := DT  * DT ;
          DT3 := DT2 * DT ;

          S2  :=      (  CC1  +  CC2 * T         -  CC3 * T2  ) * DT  ;
          S1  := S2 + (  CC4  -  CC5 * T ) * DT2 +  CC6 * DT3         ;
          S3  := S2 + (  CC7  +  CC8 * T ) * DT2 +  CC9 * DT3         ;
          S2  :=      ( CC10  - CC11 * T         - CC12 * T2  ) * DT  ;
          S2  := S2 - ( CC13  + CC14 * T ) * DT2 - CC15 * DT3         ;

          S1  := S1 / SR ;
          S2  := S2 / SR ;
          S3  := S3 / SR ;

          C1  := COS ( S1 ) ;
          C2  := COS ( S2 ) ;
          C3  := COS ( S3 ) ;

          S1  := SIN ( S1 ) ;
          S2  := SIN ( S2 ) ;
          S3  := SIN ( S3 ) ;




          DT  :=  X   * C1  -  Y   * S1  ;
          DT2 :=  X   * S1  +  Y   * C1  ;
          DT3 :=  Z                      ;

          X   :=  DT  * C2  -  DT3 * S2  ;
          Y   :=  DT2                    ;
          Z   :=  DT  * S2  +  DT3 * C2  ;

          DT  :=  X   * C3  -  Y   * S3  ;
          DT2 :=  X   * S3  +  Y   * C3  ;
          DT3 :=  Z                      ;

          X   :=  DT  ;
          Y   :=  DT2 ;
          Z   :=  DT3 ;

        End
       Else
        Begin  { � �����⨪� }
               { ����������� }

 	  T := ( ( JDE1 + JDE2 ) / 2.0 - 2451545.0 ) / 36525.0;

	  Eps:= ( 84381.448 ) / SR ;

	  SEps := Sin ( Eps );
	  CEps := Cos ( Eps );

          XEkl :=    X                       ;
          YEkl :=    Y * CEps  +   Z * SEps  ;
	  ZEkl :=  - Y * SEps  +   Z * CEps  ;

          LEkl := ATan2 ( YEkl , XEkl ) ;
          BEkl := Atan2 ( ZEkl , Sqrt ( Sqr ( XEkl ) + Sqr ( YEkl ) )  ) ;
          If ( BEkl > Pi )  Then
            BEkl := BEkl - Pi2 ;

          LEkl := LEkl + 5029.0966 * DT / SR ;


          ZEkl :=                Cos ( BEkl ) ;
          XEkl := Cos ( LEkl ) * ZEkl         ;
          YEkl := Sin ( LEkl ) * ZEkl         ;
          ZEkl :=                Sin ( BEkl ) ;


          X :=  XEkl                          ;
          Y :=  YEkl * CEps  -   ZEkl * SEps  ;
	  Z :=  YEkl * SEps  +   ZEkl * CEps  ;

        End ;


      Ra   := ATan2 ( Y , X ) ;
      Decl := Atan2 ( Z , Sqrt ( Sqr ( X ) + Sqr ( Y ) )  ) ;
      If ( Decl > Pi )  Then
        Decl := Decl - Pi2 ;


   END ;

 END.
