
{$F+,O+}
Unit SSEpohEl;

Interface

Uses SSVar, TDialogs, TStdObj, SSError, TMsgWin;


procedure SetEpohaElementov;

Implementation

Type

 SEpohaElementov = Record

    Year     : String[ 7 ];
    Month    : String[ 2 ];
    Day      : String[ 2 ];

    Hour     : String[ 2 ];
    Minute   : String[ 2 ];
    Sec      : String[ 6 ];

 end;

Const

    MDRange : Array[ 1..12 ] of Byte =(  31, 29,
                                         31, 30, 31,
                                         30, 31, 31,
                                         30, 31, 30,
                                         31 );


procedure SetEpohaElementov;

Var

  Dialog : PDialog;
  R      : TRect;
  ECode  : Word;

  Bruce  : PView;

  X1,Y1  : Byte;
  X2,Y2  : Byte;
  LX1,LY,
  LX2    : Byte;
  L      : Byte;

  SEL    : SEpohaElementov;

  ErrorFlag, E1F : Boolean;

  Count  : Integer;

  Old    : TEpohaElementov;

begin

  R.assign( 1, 1, 39, 12 );
  Dialog := New( PDialog, Init( R, ' Epoch elements ', jcCentered ));

  Old := EpohaElementov;

  Str( EpohaElementov.Year  , SEL.Year   );
  Str( EpohaElementov.Month : 2 , SEL.Month  );
  Str( EpohaElementov.Day   : 2 , SEL.Day    );

  Str( EpohaElementov.Hour   : 2 , SEL.Hour   );
  Str( EpohaElementov.Minute : 2 , SEL.Minute );
  Str( EpohaElementov.Sec    : 6 : 3 , SEL.Sec    );

  With Dialog^ do
    begin


     R.Assign( 21, 1, 0, 0 );
     Bruce := New( PStaticText, Init( R, '  Universal time'#13 +
                                         'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'#13 ));
     Insert( Bruce );


 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 10 ;
      Y1  := 3  ;

      L   := 7 ;

      X2  := X1 + 2 + L ;
      Y2  := Y1 + 1;

      LX1 := 2;
      LX2 := X1;
      LY  := Y1;


      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Year' );
      Insert( Bruce );


 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 10 ;
      Y1  := 5  ;

      L   := 2 ;

      X2  := X1 + 2 + 2 ;
      Y2  := Y1 + 1;

      LX1 := 2;
      LX2 := X1;
      LY  := Y1;


      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Month' );
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 10 ;
      Y1  := 7  ;

      L   := 2 ;

      X2  := X1 + 2 + 2 ;
      Y2  := Y1 + 1;

      LX1 := 2;
      LX2 := X1;
      LY  := Y1;


      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Day' );
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 30 ;
      Y1  := 3  ;

      L   := 2 ;

      X2  := X1 + 2 + L ;
      Y2  := Y1 + 1;

      LX1 := 22;

      LX2 := X1;
      LY  := Y1;


      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Hour' );
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 30 ;
      Y1  := 5  ;

      L   := 2 ;

      X2  := X1 + 2 + L ;
      Y2  := Y1 + 1;

      LX1 := 22;

      LX2 := X1;
      LY  := Y1;


      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Minute' );
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 30 ;
      Y1  := 7  ;

      L   := 6 ;

      X2  := X1 + 2 + L ;
      Y2  := Y1 + 1;

      LX1 := 22;

      LX2 := X1;
      LY  := Y1;


      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Sec' );
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 4;
      Y1  := 9  ;

      X2  := X1 + 13 ;
      Y2  := Y1 + 1;

      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PButton, Init( R, 'Ok', bfNormal, cmOk ));
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 21 ;
      Y1  := 9  ;

      X2  := X1 + 15 ;
      Y2  := Y1 + 1;

      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PButton, Init( R, 'Cancel', bfNormal, cmCancel ));
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      SetData( SEL );

      InsFlag := False;

      ErrorFlag := True;

      While ErrorFlag do
        begin

          ErrorFlag := False;

          ECode := Run;

          If ECode = cmCancel Then
           EpohaElementov := Old;

          If ECode <> cmCancel Then
            begin

              GetData( SEL );

              Val( SEL.Year  , EpohaElementov.Year    , Count );
              If Count <> 0 Then  ErrorFlag := True;

              Val( SEL.Month , EpohaElementov.Month   , Count );
              If Count <> 0 Then  ErrorFlag := True;

              Val( SEL.Day   , EpohaElementov.Day     , Count );
              If Count <> 0 Then  ErrorFlag := True;

              Val( SEL.Hour   , EpohaElementov.Hour   , Count );
              If Count <> 0 Then  ErrorFlag := True;

              Val( SEL.Minute , EpohaElementov.Minute , Count );
              If Count <> 0 Then  ErrorFlag := True;

              Val( SEL.Sec    , EpohaElementov.Sec    , Count );
              If Count <> 0 Then  ErrorFlag := True;

              If ErrorFlag Then EnterParamError;

              E1F := False;

              If ( Not ErrorFlag ) and ( Not E1F )
                 and ( EpohaElementov.Month > 12 ) Then
                   begin

                     E1F := True;
                     ErrorFlag := true;
                     ErrorMonthRange;

                   end;

              If ( Not ErrorFlag ) and ( Not E1F ) Then
                begin

                  If  EpohaElementov.Day > MDRange[ EpohaElementov.Month ] Then
                    begin

                      If MDRange[ EpohaElementov.Month ] = 30 Then E1f := False ;
                      If MDRange[ EpohaElementov.Month ] = 31 Then E1f := True ;

                      If EpohaElementov.Month <> 2 Then
                        ErrorDayRange( False, E1F );

                      E1f := True;
                      ErrorFlag := true;

                    end;

                  If EpohaElementov.Month = 2 Then
                    Begin

                      If EpohaElementov.Year mod 4 = 0 Then
                        E1F := True;

                      If EpohaElementov.Year mod 4 <> 0 Then
                        E1F := FALSE;

                      ErrorDayRange( True, E1F );

                      E1f := True;
                      ErrorFlag := true;

                    End;
                End;

              If ( Not ErrorFlag ) and ( Not E1F ) Then
                begin

                  IF ( EpohaElementov.Hour > 23 ) Then
                    begin

                      ErrorHourRange;
                      E1f := True;
                      ErrorFlag := true;

                    end;

                end;

              If ( Not ErrorFlag ) and ( Not E1F ) Then
                begin

                  IF ( EpohaElementov.Minute > 59 ) Then
                    begin

                      ErrorMinuteRange;
                      E1f := True;
                      ErrorFlag := true;

                    end;

                end;

              If ( Not ErrorFlag ) and ( Not E1F ) Then
                begin

                  IF ( EpohaElementov.Sec > 59.999 ) Then
                    begin

                      ErrorSecRange;
                      E1f := True;
                      ErrorFlag := true;

                    end;

                end;

            end;{ If ECode <> cmCancel ...  }

        end;

    end;

  Dispose( Dialog, Done );

end;{ SetEpohaElementov }

end.

