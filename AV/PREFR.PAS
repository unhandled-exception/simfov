
{$F+,O+}

Unit PRefr ;

Interface

Uses PVar ;

   Function  HApparent ( H : Double ) : Double ;
   Function  HMean     ( H : Double ) : Double ;

Implementation

      Function Psi ( X : Double ) : Double ;

{
           Входной параметр:
        X - значение аргумента,
           Выходной параметр:
        Erfluk - значение 2/Sqrt(Pi) * integral Exp ( -Sqr ( X ) от X
                 до бесконечности ;
            Литература: Ю.ЛЮК. Специальные математические функции и
        их аппроксимации. 1980, "МИР", c. 131.

        T1, T2, T3 - значения многочленов ЧЕБЫШЕВА;
}

Const

      Hsqpi = 0.8862269254527580 ;

      AN : Array [ 1 .. 26 ] Of Double = (
              1.0954712997776232, -0.2891754011269890,
              0.1104563986337951, -0.0412531882278565,
              0.0140828380706516, -0.0043292954474314,
              0.0011982719015923, -0.0002999729623532,
              0.0000683258603789, -0.0000142469884549,
              0.0000027354087728, -0.0000004861912872,
              0.0000000803872762, -0.0000000124184183,
              0.0000000017995326, -0.0000000002454795,
              0.0000000000316251, -0.0000000000038590,
              0.0000000000004472, -0.0000000000000493,
              0.0000000000000052, -0.0000000000000005,
              0.0000000000000001, -0.466e-17,
              0.41e-18,             -0.4e-19                  ) ;

      CN : Array [ 1 .. 23 ] Of Double = (
              0.9750834237085559, -0.0240493938504146,
              0.0008204522408804, -0.0000434293081303,
              0.0000030184470340, -0.0000002544733193,
              0.0000000248583530, -0.0000000027317201,
              0.0000000003308472, -0.0000000000435055,
              0.0000000000061412, -0.0000000000009224,
              0.0000000000001464, -0.0000000000000244,
              0.0000000000000042, -0.77084e-15,
              0.14507e-15,          -0.2824e-16,
              0.567e-17,             0.117e-17,
              0.25e-18,             -0.5e-19,
              0.1e-19                                          ) ;

Var
      I                       : Integer ;
      S, T1, T2, T3, XX       : Double  ;


  Begin

      If ( Abs(X) <= 3.0)
        then
          Begin
            XX := X/3.0 ;
            T1 := C10   ;
            T2 := XX    ;
            T3 := XX    ;
            S  := 0.0   ;
            For I := 1 To 26  Do
              Begin
                S := S + AN [I] * T3 ;
                T3 := C20 * XX * T2 - T1 ;
                T1 := T2 ;
                T2 := T3 ;
                T3 := C20 * XX * T2 - T1 ;
                T1 := T2 ;
                T2 := T3 ;
              End ;
          S := S * C20 / Sqrt ( Pi ) ;
          S := C10 - S ;
        End
      Else   { Abs(X) > 3 }
        Begin
          XX := 3.0 / X ;
          T1 := C10     ;
          T2 := XX      ;
          T3 := C10     ;
          S  := 0.0     ;
          For I := 1 To 23  Do
            Begin
              S  := S + CN [I] * T3    ;
              T3 := C20 * XX * T2 - T1 ;
              T1 := T2  ;
              T2 := T3  ;
              If ( I <> 1 )  Then
                Begin
                  T3 := C20 * XX * T2 - T1 ;
                  T1 := T2 ;
                  T2 := T3 ;
                End ;
            End ;

          S := S * C20 / Sqrt ( Pi ) ;
          S := S / ( C20 * X ) * Exp ( - Sqr ( X ) ) ;

        End ; { Abs(X) < 3 }

      Psi := S * Sqrt ( Pi ) / C20 * Exp ( Sqr ( X ) ) ;

  End ;



 Function  HApparent ( H : Double ) : Double ;


   Var
       I                            : Integer ;
       S, C, F,
       HM, HAp, R0, R, Z0, X, X2    : Double  ;

   Begin

     If ( H < HGor )
       Then
           HApparent := H + Abs ( HGor )
       Else
         Begin

           HAp :=   H        ;
           HM  :=   Pi * C20 ;

           While ( Abs ( HM - H ) > ( C10 / 206264.806 ) ) Do
             Begin

               Z0  := Pi / C20 - HAp ;
               X   := 21.244 * Cos ( Z0 ) ;

               R   := 2563.5 * Sin ( Z0 ) * Psi ( X ) ;
               R   := R / 206264.806247 ;

               HM  := HAp - R ;
               HAp := HAp + ( H - HM ) ;

             End ;

           HApparent := HAp ;

         End ;

   End ;


  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

 Function  HMean ( H : Double ) : Double ;

   Var
       R, Z0, X, X2    : Double  ;

   Begin

         Z0    := Pi / C20 - H ;
         X     := 21.244 * Cos ( Z0 ) ;
         R     := 2563.5 * Sin ( Z0 ) * Psi ( X ) / 206264.806247 ;
         HMean := H - R ;

   End ;

End.
