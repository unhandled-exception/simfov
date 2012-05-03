Program PXYSatG  ;
      {
      SUBROUTINE SGP ( IFLAG,dT )
      COMMON / E1 / M0,OmL0,OmL0,e0,i0,Mot0,Mot1,Mot2,
     1         X,Y,Z,XDOT,YDOT,ZDOT
      COMMON / C1 / CK2,CK4,E6A,QOMS2T,S,TOTHRD,
     1        J3,Ke,XKMPER,AE
      }

  Function Atan2 ( S, C : Double ) : Double  ;

  Const
    C20   : Double =      2.0             ;
    Pi2   : Double = Pi * 2.0             ;
    Pid2  : Double = Pi / 2.0             ;
    Pi270 : Double = Pi * 2.0 - Pi / 2.0  ;

  Var
    A  : Double ;

  Begin


    If (     ( S = 0.0 )
         And ( C = 0.0 )  )
      Then
        Begin
          ATan2 := 0.0 ;
        End
      Else
        Begin
          If ( Abs ( C ) > 0.0 )
            Then
              Begin
                If ( Abs ( C ) > Abs ( S ) )
                  Then
                    Begin
                      A := ArcTan ( S / C ) ;
                    End
                  Else
                    Begin
                      If ( ( C / S ) < 0.0 )
                        Then  A := Pi270 - ArcTan ( C / S )
                        Else  A := Pid2  - ArcTan ( C / S ) ;
                      End ;

                If ( C < 0.0 )  Then  A := A + Pi  ;
                If ( A < 0.0 )  Then  A := A + Pi2 ;
                If ( A > Pi2 )  Then  A := A - Pi2 ;

              End
            Else
              Begin
                If ( S > 0.0 )
                  Then  A := Pi / C20
                  Else  A := Pi270    ;
              End ;

          ATan2 := A ;

        End ;

  End ;

Label 20, 30 ;

Const

   CK2    =    5.413080e-4       ;
   CK4    =    0.62098875e-6     ;
   E6A    =    1.0e-6            ;
   QOMS2T =    1.88027916e-9     ;
   S      =    1.01222928        ;
   TOTHRD =    2.0 / 3.0         ;
   J3     =   -0.253881e-5       ;
   Ke     =    0.743669161e-1    ;
   XKMPER = 6378.135             ;
   AE     =    1.0               ;
   Pi2    =    6.283185307179586 ;



Var

  ITem3                                         : Integer ;

  M0,OmL0,OmG0,e0,i0,Mot0,Mot1,Mot2             : Double  ;

  dT,
  C1, C2, C3, C4, C5, C6,
  CosIO, SinIO,
  AO, A1, PO, QO, XLO, PO2NO, XNODOT,
  D1, D1O, D2O, D3O, D4O,
  OmLDT, OmLAS, XLS,
  A, E, P, XNODES,
  AXNSL, AYNSL, XL, U, EO1,
  Tem2, Tem3, Tem5, TemP,
  SinEO1, CosEO1, ECosE, ESinE,
  EL2, PL, PL2, R, RDOT, RVDOT,
  SinU, CosU, Sin2U, Cos2U,
  SU, UK, RK, XNODEK, XINCK,
  SinUK, CosUK, SinNOK, CosNOK,
  SinIK, CosIK,
  XMX, XMY,
  X, Y, Z,
  UX, UY, UZ,
  VX, VY, VZ,
  XDOT, YDOT, ZDOT
                                                : Double  ;

Begin
      {
      INITIALIZATION
      }

      C1 :=  CK2 * 1.5 ;
      C2 :=  CK2 / 4.0 ;
      C3 :=  CK2 / 2.0 ;
      C4 :=  ( J3 * AE * Sqr ( AE ) ) / ( 4.0 * CK2 ) ;

      CosIO := Cos ( i0 ) ;
      SinIO := Sin ( i0 ) ;

      A1 := Exp ( Ln ( Ke / Mot0 ) * TOTHRD ) ;
      D1 := C1 / A1 / A1 * ( 3.0 * CosIO * CosIO - 1.0 ) / Exp ( Ln ( 1.0 - e0 * e0 ) * 1.5 ) ;
      AO := A1 * ( 1.0 - 1.0 / 3.0 * D1 - D1 * D1 - 134.0 / 81.0 * D1 * D1 * D1 ) ;
      PO := AO * ( 1.0 - e0 * e0 ) ;
      QO := AO * ( 1.0 - e0 ) ;

      XLO := M0 + OmL0 + OmG0 ;
      D1O := C3  * SinIO * SinIO ;
      D2O := C2  * ( 7.0 * CosIO * CosIO - 1.0 ) ;
      D3O := C1  * CosIO ;
      D4O := D3O * SinIO ;

      PO2NO  := Mot0 / ( PO * PO ) ;
      OmLDT  := C1 * PO2NO * ( 5.0 * CosIO * CosIO - 1.0 ) ;
      XNODOT := - 2.0 * D3O * PO2NO ;
      C5 := 0.5 * C4 * SinIO * ( 3.0 + 5.0 * CosIO ) / ( 1.0 + CosIO ) ;
      C6 := C4 * SinIO ;
      {
      UPDATE FOR SECULAR GRAVITY AND ATMOSPHERIC DRAG
      }
      A := Mot0 + ( 2.0 * Mot1 + 3.0 * Mot2 * dT ) * dT ;
      A := AO * Exp ( Ln ( Mot0 / A ) * TOTHRD ) ;
      E := E6A ;
      IF ( A > QO ) Then
        E := 1.0 - QO / A ;
      P := A * ( 1.0 - E * E ) ;
      XNODES :=  OmG0 + XNODOT * dT ;
      OmLAS  :=  OmL0 + OmLDT  * dT ;
      XLS := Frac ( ( XLO + ( Mot0 + OmLDT
                                   + XNODOT
                                   + (   Mot1
                                       + Mot2 * dT ) * dT ) * dT ) / Pi2 ) * Pi2 ;
      {
      LONG PERIOD PERIODICS
      }
      AXNSL := E * Cos ( OmLAS ) ;
      AYNSL := E * Sin ( OmLAS ) - C6 / P ;
      XL    := Frac ( ( XLS - C5 / P * AXNSL ) / Pi2 ) * Pi2 ;
      {
      SOLVE KEPLERS EQUATION
      }
      U := Frac ( ( XL - XNODES ) / Pi2 ) * Pi2 ;
      ITem3 := 0 ;
      EO1 := U ;
      Tem5 := 1.0 ;

   20 :;

      SinEO1 := Sin ( EO1 ) ;
      CosEO1 := Cos ( EO1 ) ;
      IF ( ABS ( Tem5 ) < E6A ) Then
        GoTo 30 ;
      IF ( ITem3 >= 10 ) Then
        GoTo 30 ;
      ITem3 := ITem3 + 1 ;
      Tem5  := 1.0 - CosEO1 * AXNSL  - SinEO1 * AYNSL ;
      Tem5  :=  ( U - AYNSL * CosEO1 + AXNSL * SinEO1 - EO1 ) / Tem5 ;
      Tem2  := ABS ( Tem5 ) ;
      IF ( Tem2 > 1.0 ) Then
        Tem5 := Tem2 / Tem5 ;
      EO1 := EO1 + Tem5 ;
      GoTo 20 ;
      {
      SHORT PERIOD PRELIMINARY QUANTITIES
      }
   30 :;

      ECosE := AXNSL * CosEO1 + AYNSL * SinEO1 ;
      ESinE := AXNSL * SinEO1 - AYNSL * CosEO1 ;
      EL2 := AXNSL * AXNSL + AYNSL * AYNSL ;
      PL := A * ( 1.0 - EL2 ) ;
      PL2 := PL * PL ;
      R := A * ( 1.0 - ECosE ) ;
      RDOT := Ke * Sqrt ( A ) / R * ESinE ;
      RVDOT := Ke * Sqrt ( PL ) / R ;
      TemP := ESinE / ( 1.0 + Sqrt ( 1.0 - EL2 ) ) ;
      SinU := A / R * ( SinEO1 - AYNSL - AXNSL * TemP ) ;
      CosU := A / R * ( CosEO1 - AXNSL + AYNSL * TemP ) ;
      SU := ATan2 ( SinU, CosU ) ;
      {
      UPDATE FOR SHORT PERIODICS
      }
      Sin2U :=  ( CosU + CosU ) * SinU ;
      Cos2U := 1.0 - 2.0 * SinU * SinU ;
      RK := R + D1O / PL * Cos2U ;
      UK := SU - D2O / PL2 * Sin2U ;
      XNODEK := XNODES + D3O * Sin2U / PL2 ;
      XINCK  := i0 + D4O / PL2 * Cos2U ;
      {
      ORIENTATION VECTORS
      }
      SinUK  := Sin ( UK ) ;
      CosUK  := Cos ( UK ) ;
      SinNOK := Sin ( XNODEK ) ;
      CosNOK := Cos ( XNODEK ) ;
      SinIK  := Sin ( XINCK ) ;
      CosIK  := Cos ( XINCK ) ;

      XMX := - SinNOK * CosIK ;
      XMY :=   CosNOK * CosIK ;

      UX := XMX * SinUK + CosNOK * CosUK ;
      UY := XMY * SinUK + SinNOK * CosUK ;
      UZ := SinIK * SinUK ;

      VX := XMX * CosUK - CosNOK * SinUK ;
      VY := XMY * CosUK - SinNOK * SinUK ;
      VZ := SinIK * CosUK ;
      {
      POSITION AND VELOCITY
      }
      X := RK * UX ;
      Y := RK * UY ;
      Z := RK * UZ ;

      XDOT := RDOT * UX ;
      YDOT := RDOT * UY ;
      ZDOT := RDOT * UZ ;

      XDOT := RVDOT * VX + XDOT ;
      YDOT := RVDOT * VY + YDOT ;
      ZDOT := RVDOT * VZ + ZDOT ;

END.
