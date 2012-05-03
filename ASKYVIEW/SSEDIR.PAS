
{$O+,F+}

Unit SSEDir;

Interface

Uses SSVar, TDialogs, TStdObj;

procedure SetEDir  ;

Implementation

procedure SetEDir ;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  ExitCode : Word    ;

  Y,X      : Byte    ;
  XMaxOkno : Byte    ;


Begin


 XMaxOkno := 44 ;


 R.Assign( 1, 1, XMaxOkno + 3, 11 );
 Dialog := New( PDialog , Init ( R, ' Extension Files ', jcCentered ));

 With Dialog^ do
  Begin

   Y        :=  2 ;
   X        := 15 ;
   XMaxOkno := 44 ;


   { *************** ˆ¬¯®àâ **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 2, Y,  5, Y  );
   If (     ( OptOsOrient       =  4 )
        And ( NObject           = 12 )
        And ( NObjectSputnikNum =  0 ) )
     Then  Bruce^.InitLabel ( R, 'Output file ')
     Else  Bruce^.InitLabel ( R, 'Import'   ) ;
   Insert( Bruce );
   Inc( Y ,2  );

   { *************** Satellits **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 2, Y,  5, Y  );
   Bruce^.InitLabel(R,'Satellites');
   Insert( Bruce );
   Inc( Y ,2  );

   { *************** FotSysDir **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 2, Y,  5, Y  );
   Bruce^.InitLabel(R,'FotSys');
   Insert( Bruce );
   Inc( Y ,2  );

   { *************** Pzs **************** }

{
   R.Assign( X,Y,X + 15,Y + 1);
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( x + 17, Y, X + 32, Y + 1);
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );
}
   R.Assign( X+7, Y, X+18, Y+1 );
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( x+19, Y, X+30, Y+1 );
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

{

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 2, Y,  5, Y  );
   Bruce^.InitLabel(R,'CCD');
   Insert( Bruce );
   Inc( Y ,2  );


   R.Assign( X,Y,X + 15,Y + 1);
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( x + 17, Y, X + 32, Y + 1);
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

}

   SetData ( EDir );

   ExitCode := Run ;

   If ExitCode <> cmCancel Then
    Begin

     GetData ( EDir );

    End;

  End;

 Dispose( Dialog, Done );

End;



end.