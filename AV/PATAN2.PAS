
Unit  PAtan2 ;

 InterFace

	Function Atan2 ( S, C : Double ) : Double  ;


 Implementation

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

End.