{$F+,O+}
Unit SSEpInf;
Interface

procedure SetEpochInformation;

Implementation

Uses TDialogs, TStdObj, SSEpoh, SSVar;

procedure SetEpochInformation;

Label BegDialog;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  ExitCode : Word    ;

  y,k,m,x,
  ACode,em : Byte    ;

  DEscFlag : Boolean;


Begin

 DEscFlag := False ;

 em := EpModel;

 R.Assign( 1, 1, 32, 8 );
 Dialog := New( PDialog , Init( R, ' Equinox type ', jcCentered ));
{
 Dialog := New( PDialog , Init( R, ' Epoch type ', jcCentered ));
}
 With Dialog^ do
  Begin

   x := 30;

   R.Assign( 3, 2, x, 4 );
   Bruce := New( PRadioButton, Init( R ));
   With Bruce^ do
    Begin

     m := 0;

     NewSItem('Equinox information');
     Inc( M );
     NewSItem('On date');
     Inc( M );

    End;

   Insert( Bruce );


   R.Assign( 8, 5, 8 + 9, 6 );
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmOk ));
   Insert( Bruce );

   R.Assign( 8 + 10 , 5, 8 + 10 + 9, 6 );
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData( EpModel );

BegDialog:;

   DEscFlag := False ;

   ExitCode := Run ;

   If ( ExitCode <> cmCancel ) and ( ExitCode <> cmQuit ) Then
    Begin

     GetData( EpModel );

     If Epmodel = 1 Then
      begin
        SetEpoh( ' Information equinox  ' , EpInform ) ;
        If EESFlag = True Then
          GoTo Begdialog;

      end;

    End;

  End;

 Dispose( Dialog, Done );

End;{ SetTeleskopPosition }


end.