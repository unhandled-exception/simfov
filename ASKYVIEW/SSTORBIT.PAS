{$F+,O+}

Unit SSTOrbit;

Interface

Uses SSVar, TDialogs, TStdObj, SSError, TMsgWin;

Procedure SetOrbitType;


Implementation

Procedure SetOrbitType;

Label BegDialog;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  ExitCode : Word    ;

  y,k,m,x,
  ACode,cp,

  TPNFS,

  BX,BY    : Byte    ;

  DEscFlag : Boolean;

Begin

 R.Assign( 1, 1, 32, 9 );
 Dialog := New( PDialog , Init( R, ' Orbite elements ', jcCentered ));

 With Dialog^ do
  Begin

   BX := 3;
   BY := 6;

   x := 25;

   R.Assign( 3, 2, 4 + x, 5 );
   Bruce := New( PRadioButton, Init( R ));
   With Bruce^ do
    Begin

     M := 0;

     NewSItem ( 'Keplers orbite') ;   Inc( M ) ;
     NewSItem ( 'Polinoms')        ;   Inc( M ) ;
     NewSItem ( 'Rectangular')     ;   Inc( M ) ;

    End;

   Insert( Bruce );

   R.Assign( BX, BY, BX + 13, BY + 1 );
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmOk ));
   Insert( Bruce );

   R.Assign( BX + 14 , BY, BX + 14 + 13, BY + 1 );
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData( SetOptOrbit );

BegDialog:;

   DEscFlag := False ;
   ExitCode := Run ;

   If ( ExitCode <> cmCancel ) Then
    Begin

     GetData ( SetOptOrbit );
     TPCP := 2 ;
     Space_Earth_Flag := 2;

    End;

  End;

 Dispose( Dialog, Done );

End;{ SetTeleskopPosition }

End.