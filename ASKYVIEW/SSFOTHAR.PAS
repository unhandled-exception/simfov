{$F+,O+}

Unit SSFotHar;

Interface

Uses SSVar, TDialogs, TStdObj, SSError, TMsgWin;


procedure SetFotometrHar;

Implementation

procedure SetFotometrHar;

Label BegDialog ;

Type

  SFotometrHar = Record

   MvPred      : String[ 7 ];
   dMPriOtogd  : String[ 7 ];

  end;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  X,   Y,
  LX, LY,
  L,  BX,
  ml,ww,
  i,d,m,v  : Byte    ;

  ExitCode : Word    ;

  SFH      : SFotometrHar;

  Old      : TFotometrHar;

Begin

 Old := FotometrHar;

 Str( FotometrHar.MvPred     : 7 : 3 , SFH.MvPred      );
 Str( FotometrHar.dMPriOtogd : 7 : 3 , SFH.dMPriOtogd  );

 L  := 7;

 X  := 28;
 Y  := 2;

 LX := 6;
 LY := 2;

 BX := 9;

 R.Assign( 1, 1, 43, 9 );
 Dialog := New( PDialog , Init( R, ' Photometry ', jcCentered ));

 With Dialog^ do
  Begin

    R.Assign( X, Y, X + L + 2, Y+1 );
    Bruce := New( PInputLine, Init( R, L ));
    R.Assign( LX, LY, X , LY+1 );
    Bruce^.InitLabel( R, '          Mv  max' );
    Insert( Bruce );
    Inc( Y, 2 );
    Inc( LY, 2 );

    R.Assign( X, Y, X + L + 2, Y+1 );
    Bruce := New( PInputLine, Init( R, L ));
    R.Assign( LX, LY, X , LY+1 );
    If Regims.DetImp = 1
       Then  Bruce^.InitLabel( R, #127'M  determination    ' )
       Else  Bruce^.InitLabel( R, '          Mv  min' );
{
    Bruce^.InitLabel( R, #127'M  determination    ' );
}
    Insert( Bruce );
    Inc( Y, 2 );
    Inc( LY, 2 );


    R.Assign( BX,LY,BX + 11,LY+1);
    Bruce := New( PButton, Init( R,'Ok', bfNormal, cmQuit ));
    Insert( Bruce );

    R.Assign( BX + 13, LY, BX + 13 + 11,LY+1);
    Bruce := New( PButton, Init( R,' Cancel ', bfNormal, cmCancel ));
    Insert( Bruce );

    SetData( SFH );

    InsFlag := False;

 BegDialog:;

    ExitCode := Run ;

    If ExitCode = cmCancel Then
      FotometrHar := Old;

    If ExitCode <> cmCancel Then
      Begin

       GetData( SFH );

       d := 0;
       m := 0;
       v := 0;

       For i := 1 to Length( SFH.MvPred )  do
        begin
          case SFH.MvPred [ i ] of
           '1','2',
           '3','4',
           '5','6',
           '7','8',
           '9',
           '+','.',
           '-'      :Inc( D );
           '0'      :Inc( v );
          { '-'      :Inc( m );
           }
           ' '      :;
           else
            begin

              EnterParamError;
              GoTo BegDialog ;

            end;
        end;
      end;

    If ( M > 0 ) and ( Length( SFH.MvPred ) <= M ) Then
      begin

        EnterParamError;
        GoTo BegDialog ;

      end;

    If ( M > 0 ) and ( v > 0 ) Then
      begin

        EnterParamError;
        GoTo BegDialog ;

      end;


    if ( d = 0 ) Then
      begin

        EnterParamError;
        GoTo BegDialog ;

      end;


    d := 0;
    m := 0;

    For i := 1 to Length( SFH.dMPriOtogd )  do
      begin
        case  SFH.dMPriOtogd[ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','.'  : Inc(D);
         '-'      : Inc( m );
         ' '      :;
         else
          begin

            EnterParamError;
            GoTo BegDialog ;

          end;
        end;
      end;

    If M > 1 Then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;

    if ( d = 0 ) Then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;

    Val( SFH.MvPred      , FotometrHar.MvPred     , ExitCode );
    Val( SFH.dMPriOtogd  , FotometrHar.dMPriOtogd , ExitCode );


   End;


   End;

 Dispose( Dialog, Done );

end;{ SetFotometHar }



end.