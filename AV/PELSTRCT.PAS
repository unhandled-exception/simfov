
{$O+,F+}

Unit  PElStRct ;

 Interface

   Procedure  ElSatRectAng ;

 Implementation

   Uses  PVar, PVarMenu, PAtan2 ;


   Procedure  ElSatRectAng ;
 { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

 Var
    X, Y, Z, Vx, Vy, Vz,
    A, K, e, E0, M0,
    i, OmG, OmL, P, V, U,
    eSE, eCE, RVr,
    R1, R2, R3,
    R0, V02
                                : Double ;

  Begin

    K  := Sqrt ( FM [ Param.NPl0 ] / Sqr ( C864000 ) ) ;

    X  := Param.HAp    ;
    Y  := Param.HPer   ;
    Z  := Param.ISat   ;

    Vx := Param.OmG    ;
    Vy := Param.OmL    ;
    Vz := Param.ArgLat ;

    R0  := Sqrt ( Sqr ( X  ) + Sqr ( Y  ) + Sqr ( Z  )  ) ;
    V02 :=        Sqr ( Vx ) + Sqr ( Vy ) + Sqr ( Vz )    ;
    RVr := X * Vx  +  Y * Vy  + Z * Vz ;

    A   := C10 / Abs ( C20 / R0 - V02 / Sqr ( K ) ) ;

    eSE := RVr / ( K * Sqrt ( A ) ) ;
    eCE := C10 - R0 / A ;

    e   := Sqrt  ( Sqr ( eSE ) + Sqr ( eCE ) ) ;
    E0  := ATan2 ( eSE, eCE ) ;

    M0  := E0 - eSE ;

    R1 := Y * Vz  -  Z * Vy ;
    R2 := X * Vz  -  Z * Vx ;
    R3 := X * Vy  -  Y * Vx ;

    OmG := ATan2 ( R1, R2 ) ;

    If ( Abs ( Sin ( OmG ) ) > 0.5 )
      Then  i := ATan2 ( R1 / Sin ( OmG ) , R3 )
      Else  i := ATan2 ( R1 / Cos ( OmG ) , R3 ) ;

    P    := A * ( C10 - Sqr ( e ) )            ;
    HPer := A * ( C10 -       e   ) - R_Planet ;

    V := ATan2 ( Sqrt ( P ) * RVr ,  K * ( P - R0 ) ) ;

    If ( Sin ( i ) = 0.0 )
      Then
        Begin
          U := X * Cos ( OmG ) + Y * Sin ( OmG ) ;
          If ( U > 0.0 )
            Then  U := 0.0
            Else  U := Pi  ;
        End
      Else
          U := ATan2 ( Z / Sin ( i ) , X * Cos ( OmG ) + Y * Sin ( OmG ) ) ;

    HAp    := ( A - R_Planet ) * C20 - HPer  ;
    ISat   := i                              ;
    OmL    := U - V                          ;
    ArgLat := U                              ;


  End ;

End.