
{$F+,O+}
Unit SSBegDat;

Interface

Uses SSVar, TDialogs, TStdObj, SSError, TMsgWin, PVar;


procedure SetBeginDate;

Implementation

Type

 SBeginDate = Record

    Year     : String [  6 ] ;
    Month    : String [  2 ] ;
    Day      : String [  2 ] ;

    Hour     : String [  3 ] ;
    Minute   : String [  3 ] ;
    Sec      : String [  6 ] ;

    Step     : String [ 12 ] ;

 End ;

Const

    MDRange : Array [ 1..12 ] of Byte = ( 31, 29,
                                          31, 30, 31,
                                          30, 31, 31,
                                          30, 31, 30,
                                          31 );


Procedure SetBeginDate;
Label BegDialog;
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
  I      : Byte ;

  SEL    : SBeginDate;

  ErrorFlag,
  E1F        : Boolean;

  Count      : Integer;

  Old        : TBeginDate;

  SStep      : String [ 12 ] ;

Begin

  R.assign( 1, 1, 39, 14 );
  Dialog := New( PDialog, Init( R, ' Starting date ', jcCentered ));

  Old := BeginDate;

  Str ( BeginDate.Year            , SEL.Year   ) ;
  Str ( BeginDate.Month  :  2     , SEL.Month  ) ;
  Str ( BeginDate.Day    :  2     , SEL.Day    ) ;

  Str ( BeginDate.Hour   :  3     , SEL.Hour   ) ;
  Str ( BeginDate.Minute :  3     , SEL.Minute ) ;
  Str ( BeginDate.Sec    :  6 : 3 , SEL.Sec    ) ;

  {
  Str ( BeginDate.Step   : 12 : 2 , SEL.Step   ) ;
  }

  If ( Abs ( BeginDate.Step ) < 86400.0 )  Then
    Begin
      Str ( BeginDate.Step : 12 : 3 , Sel.Step ) ;
      While ( Sel.Step [ 1 ] = ' ' )  Do
        Delete ( Sel.Step, 1, 1 ) ;
      If ( Sel.Step [ 2 ] = '.' )  Then
        Sel.Step := ' ' + Sel.Step ;
    End ;


  If (     ( Abs ( BeginDate.Step ) >=    86400 )
       And ( Abs ( BeginDate.Step ) <  31557600 )  )  Then
    Begin
      Str ( BeginDate.Step / 86400.0 : 10 : 1 , Sel.Step ) ;
      Sel.Step := Sel.Step + ' d' ;
      While ( Sel.Step [ 1 ] = ' ' )  Do
        Delete ( Sel.Step, 1, 1 ) ;
    End ;


  If ( Abs ( BeginDate.Step ) >= 31557600.0 )  Then
    Begin
      Str ( BeginDate.Step / 86400 / 365.25 : 10 : 1 , Sel.Step ) ;
      Sel.Step := Sel.Step + ' y' ;
      While ( Sel.Step [ 1 ] = ' ' )  Do
        Delete ( Sel.Step, 1, 1 ) ;
    End ;



  With Dialog^ do
    Begin


     R.Assign( 21, 1, 0, 0 );
     Bruce := New( PStaticText, Init( R, ' Universal  time '#13 +
                                         ' ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ '#13 ));
     Insert( Bruce );


 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 10 ;
      Y1  :=  3 ;

      L   :=  6 ;

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
      Y1  :=  5 ;

      L   :=  2 ;

      X2  := X1 + 2 + L ;
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
      Y1  :=  7 ;

      L   :=  2 ;

      X2  := X1 + 2 + L ;
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

      X1  := 31 ;
      Y1  :=  3 ;

      L   :=  3 ;

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

      X1  := 31 ;
      Y1  :=  5 ;

      L   :=  3 ;

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

      X1  := 28 ;
      Y1  :=  7 ;

      L   :=  6 ;

      X2  := X1 + 2 + L ;
      Y2  := Y1 + 1;

      LX1 := 22 ;

      LX2 := X1 ;
      LY  := Y1 ;


      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New ( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Sec' );
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 13 ;
      X1  := 22 ;
      Y1  := Y1 + 2  ;

      L   := 12 ;

      X2  := X1 + 2 + L ;
      Y2  := Y1 + 1;

      LX1 :=  2 ;

      LX2 := X1 ;
      LY  := Y1 ;


      R.Assign ( X1, Y1, X2, Y2 );
      Bruce := New ( PInputLine, Init( R, L ));
      R.Assign( LX1, LY, LX2, LY );
      Bruce^.InitLabel( R, 'Step sec ( d, y )' );
      Insert( Bruce );




 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 10 ;
      Y1  := 11 ;

      X2  := X1 +  9 ;
      Y2  := Y1 +  1 ;

      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PButton, Init( R, 'Ok', bfNormal, cmOk ));
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := X2 + 3 ;
      Y1  := 11 ;

      X2  := X1 +  9 ;
      Y2  := Y1 +  1 ;

      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PButton, Init( R, 'Cancel', bfNormal, cmCancel ));
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      SetData ( SEL );

      InsFlag := False;

BegDialog:;

          ECode := Run;

          If ECode = cmCancel Then
           BeginDate := Old;

          If ECode <> cmCancel Then
            Begin

              GetData( SEL );

              ErrorFlag := False;

              Val( SEL.Year  , BeginDate.Year    , Count );
              If Count <> 0 Then
                 ErrorFlag := True;

              Val( SEL.Month , BeginDate.Month   , Count );
              If Count <> 0 Then
                 ErrorFlag := True;

              Val( SEL.Day   , BeginDate.Day     , Count );
              If Count <> 0 Then
                 ErrorFlag := True;

              Val( SEL.Hour   , BeginDate.Hour   , Count );
              If Count <> 0 Then
                 ErrorFlag := True;

              Val( SEL.Minute , BeginDate.Minute , Count );
              If Count <> 0 Then
                 ErrorFlag := True;

              Val( SEL.Sec    , BeginDate.Sec    , Count );
              If Count <> 0 Then
                 ErrorFlag := True;



              For I := 1 To Length ( Sel.Step )  Do
                Sel.Step [ I ] := UpCase ( Sel.Step [ I ] ) ;



              If (     ( Pos ( 'D', Sel.Step ) = 0 )
                   And ( Pos ( 'Y', Sel.Step ) = 0 ) )  Then
                Begin

                  While (     ( Length ( Sel.Step ) > 0 )
                          And (    ( Sel.Step [ Length ( Sel.Step ) ] < '0')
                                Or ( Sel.Step [ Length ( Sel.Step ) ] > '9')  )  )  Do
                    Delete ( Sel.Step, Length ( Sel.Step ), 1 ) ;

                  Val( SEL.Step, BeginDate.Step, Count );
                  If Count <> 0
                    Then  ErrorFlag := True ;

                End ;



              If ( Pos ( 'D', Sel.Step ) > 0 )  Then
                Begin

                  While (     ( Length ( Sel.Step ) > 0 )
                          And (    ( Sel.Step [ Length ( Sel.Step ) ] < '0')
                                Or ( Sel.Step [ Length ( Sel.Step ) ] > '9')  )  )  Do
                    Delete ( Sel.Step, Length ( Sel.Step ), 1 ) ;

                  Val( SEL.Step, BeginDate.Step, Count );
                  If Count <> 0
                    Then  ErrorFlag := True
                    Else  BeginDate.Step := BeginDate.Step * 86400.0 ;

                End ;


              If ( Pos ( 'Y', Sel.Step ) > 0 )  Then
                Begin

                  While (     ( Length ( Sel.Step ) > 0 )
                          And (    ( Sel.Step [ Length ( Sel.Step ) ] < '0')
                                Or ( Sel.Step [ Length ( Sel.Step ) ] > '9')  )  )  Do
                    Delete ( Sel.Step, Length ( Sel.Step ), 1 ) ;

                  Val( SEL.Step, BeginDate.Step, Count );
                  If Count <> 0
                    Then  ErrorFlag := True
                    Else  BeginDate.Step :=   BeginDate.Step
                                            * 86400.0 * 365.25 ;

                End ;



{

              Val( SEL.Step    , BeginDate.Step    , Count );
              If Count <> 0 Then
                 ErrorFlag := True;
}
              If ErrorFlag Then
                Begin
                  EnterParamError;
                  GoTo BegDialog
                End ;




              If ( BeginDate.Year <> 0 )  Then
                Begin  { BeginDate.Year <> 0 }


                  If (    ( BeginDate.Month <  1 )
                       Or ( BeginDate.Month > 12 )  )  Then
                    Begin

                      ErrorMonthRange;
                      GoTo BegDialog

                    End ;


                  If ( BeginDate.Day  <  1 )   Then
                    Begin

                      ErrorDayRange( False, E1F );
                      GoTo BegDialog

                    End ;


                  If ( BeginDate.Day > MDRange [ BeginDate.Month ] )  Then
                    Begin

                      If MDRange[ BeginDate.Month ] = 30 Then
                         E1f := False ;

                      If MDRange[ BeginDate.Month ] = 31 Then
                         E1f := True ;

                      If BeginDate.Month <> 2 Then
                         ErrorDayRange( False, E1F );

                      If BeginDate.Month = 2 Then
                        Begin

                          If BeginDate.Year mod 4 = 0 Then
                             E1F := True;

                          If BeginDate.Year mod 4 <> 0 Then
                             E1F := FALSE;

                          ErrorDayRange ( True, E1F );

                        End ;

                      GoTo BegDialog;

                    End ;


                  IF (    ( BeginDate.Sec <  0.000 )
                       Or ( BeginDate.Sec > 59.999 )  )  Then
                    Begin

                      ErrorSecRange;
                      GoTo BegDialog;

                    End ;


                End  ;  { BeginDate.Year <> 0 }




               IF ( ( BeginDate.Hour Mod 100 ) > 23 ) Then
                 Begin

                   ErrorHourRange;
                   GoTo BegDialog;

                 End ;



               IF ( BeginDate.Minute Mod 100 > 59 ) Then
                 Begin

                   ErrorMinuteRange;
                   GoTo BegDialog;

                 End ;


              If ( ErrorFlag  = False )
                Then DateOld := False ;  { H¥ ¨á¯®«ì§®¢ âì áâ pãî ¤ âã ¯p¨
                                           ãáâ ­®¢ª¥ ­®¢®© }

            End ;{ If ECode <> cmCancel ...  }

        End ;


  Dispose( Dialog, Done );

End ;{ SetBeginDate }

End .
