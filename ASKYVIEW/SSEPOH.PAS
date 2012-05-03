{$F+,O+}

Unit SSEpoh ;

Interface

Uses  SSVar, TDialogs, TStdObj, SSError, TMsgWin;

Var
  EESFlag : boolean;

procedure SetEpoh ( Title : String; Var Ep : TEpoh );

Implementation

Const

    MDRange : Array[ 1..12 ] of Byte =(  31, 29,
                                         31, 30, 31,
                                         30, 31, 31,
                                         30, 31, 30,
                                         31 );

procedure SetEpoh( Title : String; Var Ep : TEpoh );

Label BegDialog ;

Type

 SEpoh = Record

   Year   : String [ 5 ] ;
   Month  : String [ 2 ] ;
   Day    : String [ 2 ] ;
   Hour   : String [ 2 ] ;
   Minute : String [ 2 ] ;
   Sec    : String [ 6 ] ;

 end;


Var

  SEp      : SEpoh   ;

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  X1,   Y1,
  X2,   Y2,
  LX1, LY1,
  LX2, LY2,LY,
  L,  BX,i : Byte    ;

  E1F      : Boolean;

  ExitCode : Word    ;

  OldEpoh  : TEpoh;

Begin

 Str ( Ep.Year   : 5     , SEp.Year   ) ;
 Str ( Ep.Month  : 2     , SEp.Month  ) ;
 Str ( Ep.Day    : 2     , SEp.Day    ) ;
 Str ( Ep.Hour   : 2     , SEp.Hour   ) ;
 Str ( Ep.Minute : 2     , SEp.Minute ) ;
 Str ( Ep.Sec    : 2 : 3 , SEp.Sec    ) ;


  R.assign( 1, 1, 39, 12 );
  Dialog := New( PDialog, Init( R, Title, jcCentered ));

  With Dialog^ do
    begin

     R.Assign( 21, 1, 0, 0 );
     Bruce := New( PStaticText, Init( R, ' Universal  time '#13 +
                                         ' ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ '#13   ) ) ;
     Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := 10 ;
      Y1  := 3  ;

      L   := 5 ;

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
      Y1  := 7  ;

      L   := 2 ;

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

      X1  := 10 ;
      Y1  :=  9 ;

      X2  := X1 +  9 ;
      Y2  := Y1 +  1 ;

      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PButton, Init( R, 'Ok', bfNormal, cmOk ));
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

      X1  := X2 + 3 ;
      Y1  :=  9 ;

      X2  := X1 +  9 ;
      Y2  := Y1 +  1 ;

      R.Assign( X1, Y1, X2, Y2 );
      Bruce := New( PButton, Init( R, 'Cancel', bfNormal, cmCancel ));
      Insert( Bruce );

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }
   SetData( SEp );

   OldEpoh := Ep;

   InsFlag := False;

BegDialog:;

   ExitCode := Run ;

   If ExitCode = cmCancel Then
     EESFlag := True;

   If ExitCode <> cmCancel Then
    Begin

     GetData( SEp );

     EESFlag := False;

     Val( SEp.Year  , Ep.Year  , ExitCode );
     If ExitCode <> 0 Then
       Begin
         EnterParamError;
         GoTo BegDialog;
       end;

     Val( SEp.Month , Ep.Month , ExitCode  );
     If ExitCode <> 0 Then
       Begin
         EnterParamError;
         GoTo BegDialog;
       end;

     Val( SEp.Day   , Ep.Day   , ExitCode );
     If ExitCode <> 0 Then
       Begin
         EnterParamError;
         GoTo BegDialog;
       end;

     Val( SEp.Hour  , Ep.Hour  , ExitCode );
     If ExitCode <> 0 Then
       Begin
         EnterParamError;
         GoTo BegDialog;
       end;

     Val( SEp.Minute , Ep.Minute , ExitCode  );
     If ExitCode <> 0 Then
       Begin
         EnterParamError;
         GoTo BegDialog;
       end;

     Val( SEp.Sec   , Ep.Sec   , ExitCode );
     If ExitCode <> 0 Then
       Begin
         EnterParamError;
         GoTo BegDialog;
       end;

     If ( Ep.Month > 12 ) or ( Ep.Month = 0 ) Then
       begin

         ErrorMonthRange;
         Ep := OldEpoh;
         GoTo BegDialog ;

       end;

     If  Ep.Day > MDRange[ Ep.Month ] Then
      begin

        If MDRange[ Ep.Month ] = 30 Then E1f := False ;
        If MDRange[ Ep.Month ] = 31 Then E1f := True ;

        If Ep.Month <> 2 Then
          begin
            ErrorDayRange( False, E1F );
            Ep := OldEpoh;
            GoTo BegDialog ;
          end;

        If Ep.Month = 2 Then
          Begin

            If Ep.Year mod 4 = 0 Then
              E1F := True;

            If Ep.Year mod 4 <> 0 Then
              E1F := FALSE;

            ErrorDayRange( True, E1F );
            Ep := OldEpoh;
            GoTo BegDialog ;

          End;
       end;

       If ( Ep.Hour < 0 ) or ( Ep.Hour >= 24 ) Then
         begin
          ErrorHourRange;
          GoTo BegDialog;
         end;

       If ( Ep.Minute < 0 ) or ( Ep.Minute >= 60 ) Then
         begin
          ErrorMinuteRange;
          GoTo BegDialog;
         end;

       If ( Ep.Sec < 0 ) or ( Ep.Sec >= 60 ) Then
         begin
          ErrorSecRange;
          GoTo BegDialog;
         end;


    End;

   End;

 Dispose( Dialog, Done );

end;{ SetEpoh }



end.